/* ============================================================
   Procedimiento: dbo.sp_registrar_prestamo
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra un préstamo de uno o varios ejemplares en una
                transacción: préstamo Activo a 15 días, detalle, ejemplares
                en estado Prestado e historial.
   Parámetros: @cliente_id, @empleado_id, @ejemplares (JSON con ids de
               ejemplar, ej. '[5,12]'), @observacion (opcional)
   Devuelve: prestamo_id, fecha_vencimiento
   Errores: 50001 El cliente no existe, 50002 La credencial no está activa
            o está vencida, 50003 El cliente tiene multas pendientes,
            50004 El cliente alcanzó su límite de préstamos, 50005 Uno de
            los ejemplares no está disponible, 50006 El empleado no existe,
            50007 Debe indicar al menos un ejemplar (JSON válido)
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_prestamo
    @cliente_id INT,
    @empleado_id INT,
    @ejemplares NVARCHAR(MAX),
    @observacion NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @dias_prestamo INT = 15;
    DECLARE @fecha_vencimiento DATE = DATEADD(DAY, @dias_prestamo, @hoy);
    DECLARE @estado_prestamo_activo INT = 1;  -- Activo
    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @estado_prestado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Prestado');
    DECLARE @nombre_estado NVARCHAR(30) = (SELECT nombre FROM dbo.estadoprestamo WHERE id = @estado_prestamo_activo);
    DECLARE @prestamo_id INT;
    DECLARE @total INT;
    DECLARE @ids TABLE (ejemplar_id INT PRIMARY KEY);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50006, N'El empleado no existe.', 1;

    IF @ejemplares IS NULL OR ISJSON(@ejemplares) = 0
        THROW 50007, N'Debe indicar al menos un ejemplar (JSON válido, ej. [5,12]).', 1;

    INSERT INTO @ids (ejemplar_id)
    SELECT DISTINCT TRY_CAST(j.value AS INT)
    FROM OPENJSON(@ejemplares) j
    WHERE TRY_CAST(j.value AS INT) IS NOT NULL;

    SELECT @total = COUNT(*) FROM @ids;
    IF @total = 0
        THROW 50007, N'Debe indicar al menos un ejemplar (JSON válido, ej. [5,12]).', 1;

    IF NOT EXISTS (SELECT 1
                   FROM dbo.credencial cr
                   WHERE cr.cliente_id = @cliente_id
                     AND cr.estado = N'ACTIVA'
                     AND cr.fecha_vencimiento >= @hoy)
        THROW 50002, N'La credencial no está activa o está vencida.', 1;

    IF EXISTS (SELECT 1
               FROM dbo.multa m
               INNER JOIN dbo.detalleprestamo d ON d.id = m.detalle_prestamo_id
               INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
               WHERE p.cliente_id = @cliente_id
                 AND m.estado = N'PENDIENTE')
        THROW 50003, N'El cliente tiene multas pendientes.', 1;

    IF dbo.fn_prestamos_activos_cliente(@cliente_id) >=
       (SELECT tc.limite_prestamos
        FROM dbo.cliente c
        INNER JOIN dbo.tipocliente tc ON tc.id = c.tipo_cliente_id
        WHERE c.id = @cliente_id)
        THROW 50004, N'El cliente alcanzó su límite de préstamos.', 1;

    IF EXISTS (SELECT 1
               FROM @ids i
               WHERE NOT EXISTS (SELECT 1
                                 FROM dbo.ejemplar e
                                 WHERE e.id = i.ejemplar_id
                                   AND e.estado_ejemplar_id = @estado_disponible))
        THROW 50005, N'Uno de los ejemplares no está disponible.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, observacion, cliente_id, empleado_id, estado_prestamo_id)
            VALUES (@hoy, @fecha_vencimiento, @observacion, @cliente_id, @empleado_id, @estado_prestamo_activo);
            SET @prestamo_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detalleprestamo (prestamo_id, ejemplar_id)
            SELECT @prestamo_id, i.ejemplar_id FROM @ids i;

            -- Solo pasan a Prestado los que siguen disponibles (evita choques entre dos cajas)
            UPDATE dbo.ejemplar
            SET estado_ejemplar_id = @estado_prestado
            WHERE id IN (SELECT i.ejemplar_id FROM @ids i)
              AND estado_ejemplar_id = @estado_disponible;

            IF @@ROWCOUNT <> @total
                THROW 50005, N'Uno de los ejemplares no está disponible.', 1;

            INSERT INTO dbo.historialprestamo (prestamo_id, empleado_id, estado_anterior, estado_nuevo, observacion)
            VALUES (@prestamo_id, @empleado_id, NULL, @nombre_estado, N'Préstamo registrado');
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @prestamo_id AS prestamo_id,
               @fecha_vencimiento AS fecha_vencimiento;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO