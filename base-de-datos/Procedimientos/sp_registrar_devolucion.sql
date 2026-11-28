/* ============================================================
   Procedimiento: dbo.sp_registrar_devolucion
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra la devolución de uno o varios ejemplares en una
                transacción: devolución y detalle, multa automática por
                atraso (fn_calcular_multa), estado del ejemplar, estado del
                préstamo (Devuelto o Parcialmente devuelto), historial y
                reserva en espera (el ejemplar queda apartado para la
                reserva pendiente más antigua de ese libro).
   Parámetros: @empleado_id, @ejemplares (JSON, ej.
               '[{"ejemplar_id":5,"condicion_entrega":"Buen estado"}]'),
               @observacion (opcional)
   Devuelve: devolucion_id, multa_total (0 si no hubo atraso)
   Errores: 50001 El empleado no existe, 50002 Debe indicar al menos un
            ejemplar, 50003 Uno de los ejemplares no tiene un préstamo
            pendiente de devolución
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_devolucion
    @empleado_id INT,
    @ejemplares NVARCHAR(MAX),
    @observacion NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @ahora DATETIME2(0) = CAST(GETDATE() AS DATETIME2(0));
    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @estado_reservado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Reservado');
    DECLARE @estado_danado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Dañado');
    DECLARE @estado_devuelto INT = 2;   -- Devuelto
    DECLARE @estado_parcial INT = 12;   -- Parcialmente devuelto
    DECLARE @devolucion_id INT;
    DECLARE @multa_total DECIMAL(10,2);

    DECLARE @items TABLE (
        ejemplar_id INT PRIMARY KEY,
        condicion_entrega NVARCHAR(40) NOT NULL,
        detalle_prestamo_id INT NULL,
        prestamo_id INT NULL,
        multa DECIMAL(10,2) NOT NULL DEFAULT 0,
        estado_nuevo INT NULL
    );
    DECLARE @prestamos TABLE (prestamo_id INT PRIMARY KEY, estado_anterior INT, estado_nuevo INT);
    DECLARE @reservados TABLE (ejemplar_id INT);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50001, N'El empleado no existe.', 1;

    IF @ejemplares IS NULL OR ISJSON(@ejemplares) = 0
        THROW 50002, N'Debe indicar al menos un ejemplar.', 1;

    INSERT INTO @items (ejemplar_id, condicion_entrega)
    SELECT j.ejemplar_id,
           MAX(ISNULL(NULLIF(LTRIM(RTRIM(j.condicion_entrega)), N''), N'Buen estado'))
    FROM OPENJSON(@ejemplares)
         WITH (ejemplar_id INT '$.ejemplar_id',
               condicion_entrega NVARCHAR(40) '$.condicion_entrega') j
    WHERE j.ejemplar_id IS NOT NULL
    GROUP BY j.ejemplar_id;

    IF NOT EXISTS (SELECT 1 FROM @items)
        THROW 50002, N'Debe indicar al menos un ejemplar.', 1;

    -- Préstamo abierto de cada ejemplar: el último detalle sin devolución
    -- (estados 1 Activo, 3, 4 Renovado, 8 En mora, 11, 12 y 14)
    UPDATE it
    SET detalle_prestamo_id = x.id,
        prestamo_id = x.prestamo_id
    FROM @items it
    CROSS APPLY (SELECT TOP 1 d.id, d.prestamo_id
                 FROM dbo.detalleprestamo d
                 INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
                 WHERE d.ejemplar_id = it.ejemplar_id
                   AND p.estado_prestamo_id IN (1, 3, 4, 8, 11, 12, 14)
                   AND NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd
                                   WHERE dd.detalle_prestamo_id = d.id)
                 ORDER BY d.id DESC) x;

    IF EXISTS (SELECT 1 FROM @items WHERE detalle_prestamo_id IS NULL)
        THROW 50003, N'Uno de los ejemplares no tiene un préstamo pendiente de devolución.', 1;

    UPDATE @items
    SET multa = dbo.fn_calcular_multa(detalle_prestamo_id, @hoy),
        estado_nuevo = CASE WHEN condicion_entrega LIKE N'%dañ%'
                            THEN @estado_danado ELSE @estado_disponible END;

    SELECT @multa_total = ISNULL(SUM(multa), 0) FROM @items;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.devolucion (fecha_devolucion, observacion, empleado_id)
            VALUES (@ahora, @observacion, @empleado_id);
            SET @devolucion_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detalledevolucion (devolucion_id, detalle_prestamo_id, condicion_entrega)
            SELECT @devolucion_id, it.detalle_prestamo_id, it.condicion_entrega
            FROM @items it;

            -- Multa automática por atraso
            INSERT INTO dbo.multa (fecha_generacion, monto, motivo, detalle_prestamo_id)
            SELECT @hoy, it.multa, N'Atraso en la devolución', it.detalle_prestamo_id
            FROM @items it
            WHERE it.multa > 0;

            -- Estado del ejemplar
            UPDATE e
            SET estado_ejemplar_id = it.estado_nuevo
            FROM dbo.ejemplar e
            INNER JOIN @items it ON it.ejemplar_id = e.id;

            -- Reserva en espera: el ejemplar disponible se aparta para la
            -- reserva pendiente más antigua de su libro
            ;WITH ej AS (
                SELECT it.ejemplar_id, e.libro_id,
                       ROW_NUMBER() OVER (PARTITION BY e.libro_id ORDER BY it.ejemplar_id) AS rn
                FROM @items it
                INNER JOIN dbo.ejemplar e ON e.id = it.ejemplar_id
                WHERE it.estado_nuevo = @estado_disponible
            ),
            rs AS (
                SELECT r.id, r.libro_id,
                       ROW_NUMBER() OVER (PARTITION BY r.libro_id ORDER BY r.fecha_reserva, r.id) AS rn
                FROM dbo.reserva r
                WHERE r.estado = N'PENDIENTE' AND r.tipo = N'R' AND r.ejemplar_id IS NULL
            )
            UPDATE r
            SET r.ejemplar_id = ej.ejemplar_id
            OUTPUT inserted.ejemplar_id INTO @reservados (ejemplar_id)
            FROM dbo.reserva r
            INNER JOIN rs ON rs.id = r.id
            INNER JOIN ej ON ej.libro_id = rs.libro_id AND ej.rn = rs.rn;

            UPDATE dbo.ejemplar
            SET estado_ejemplar_id = @estado_reservado
            WHERE id IN (SELECT ejemplar_id FROM @reservados);

            -- Estado del préstamo: Devuelto si ya no le quedan ejemplares
            INSERT INTO @prestamos (prestamo_id, estado_anterior, estado_nuevo)
            SELECT DISTINCT it.prestamo_id, p.estado_prestamo_id,
                   CASE WHEN NOT EXISTS (SELECT 1
                                         FROM dbo.detalleprestamo d
                                         WHERE d.prestamo_id = it.prestamo_id
                                           AND NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd
                                                           WHERE dd.detalle_prestamo_id = d.id))
                        THEN @estado_devuelto ELSE @estado_parcial END
            FROM @items it
            INNER JOIN dbo.prestamo p ON p.id = it.prestamo_id;

            UPDATE p
            SET estado_prestamo_id = pr.estado_nuevo
            FROM dbo.prestamo p
            INNER JOIN @prestamos pr ON pr.prestamo_id = p.id;

            INSERT INTO dbo.historialprestamo (prestamo_id, empleado_id, estado_anterior, estado_nuevo, observacion)
            SELECT pr.prestamo_id, @empleado_id, ea.nombre, en.nombre, N'Devolución registrada'
            FROM @prestamos pr
            INNER JOIN dbo.estadoprestamo ea ON ea.id = pr.estado_anterior
            INNER JOIN dbo.estadoprestamo en ON en.id = pr.estado_nuevo;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @devolucion_id AS devolucion_id,
               @multa_total AS multa_total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO