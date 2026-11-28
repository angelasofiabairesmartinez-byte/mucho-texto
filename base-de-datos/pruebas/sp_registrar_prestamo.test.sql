/* ============================================================
   Prueba: dbo.sp_registrar_prestamo
   Caso 1: un préstamo válido crea el préstamo Activo a 15 días, su
           detalle, deja los ejemplares Prestados y escribe el historial
           (dentro de una transacción que se revierte).
   Casos 2 a 7: cada error (50001 a 50007) debe lanzarse con su número.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
DECLARE @num INT;
DECLARE @r TABLE (prestamo_id INT, fecha_vencimiento DATE);
DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
DECLARE @estado_prestado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Prestado');
DECLARE @cliente_id INT = (SELECT TOP 1 c.id FROM dbo.cliente c WHERE dbo.fn_puede_prestar(c.id) = 1 ORDER BY c.id);
DECLARE @empleado_id INT = (SELECT TOP 1 e.id FROM dbo.empleado e ORDER BY e.id);
DECLARE @e1 INT, @e2 INT;

;WITH d AS (SELECT TOP 2 id FROM dbo.ejemplar WHERE estado_ejemplar_id = @estado_disponible ORDER BY id)
SELECT @e1 = MIN(id), @e2 = MAX(id) FROM d;

IF @cliente_id IS NULL OR @empleado_id IS NULL OR @e1 IS NULL OR @e1 = @e2
    THROW 50940, N'PRUEBA FALLIDA: faltan datos (cliente que pueda prestar, empleado o 2 ejemplares Disponibles).', 1;

DECLARE @json NVARCHAR(MAX) = CONCAT(N'[', @e1, N',', @e2, N']');

-- Caso 1: debe funcionar
BEGIN TRANSACTION;
    INSERT INTO @r
    EXEC dbo.sp_registrar_prestamo
        @cliente_id = @cliente_id, @empleado_id = @empleado_id,
        @ejemplares = @json, @observacion = N'Prueba';

    IF NOT EXISTS (SELECT 1 FROM @r WHERE prestamo_id IS NOT NULL AND fecha_vencimiento IS NOT NULL)
        THROW 50941, N'PRUEBA FALLIDA: sp_registrar_prestamo no devolvió prestamo_id y fecha_vencimiento.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.prestamo p INNER JOIN @r r ON r.prestamo_id = p.id
                   WHERE p.estado_prestamo_id = 1 AND p.cliente_id = @cliente_id
                     AND p.fecha_vencimiento = DATEADD(DAY, 15, @hoy))
        THROW 50942, N'PRUEBA FALLIDA: el préstamo debía quedar Activo a 15 días.', 1;

    IF (SELECT COUNT(*) FROM dbo.detalleprestamo d INNER JOIN @r r ON r.prestamo_id = d.prestamo_id) <> 2
        THROW 50943, N'PRUEBA FALLIDA: el préstamo debía tener 2 detalles.', 1;

    IF (SELECT COUNT(*) FROM dbo.ejemplar WHERE id IN (@e1, @e2) AND estado_ejemplar_id = @estado_prestado) <> 2
        THROW 50944, N'PRUEBA FALLIDA: los ejemplares debían quedar Prestados.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.historialprestamo h INNER JOIN @r r ON r.prestamo_id = h.prestamo_id)
        THROW 50945, N'PRUEBA FALLIDA: no se escribió el historial del préstamo.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: cliente inexistente (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_prestamo @cliente_id = -1, @empleado_id = @empleado_id, @ejemplares = @json;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50946, N'PRUEBA FALLIDA: un cliente inexistente debía dar el error 50001.', 1;

-- Caso 3: credencial no activa (50002)
SET @num = 0;
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'SUSPENDIDA' WHERE cliente_id = @cliente_id;
    BEGIN TRY
        EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50002
    THROW 50947, N'PRUEBA FALLIDA: una credencial suspendida debía dar el error 50002.', 1;

-- Caso 4: multa pendiente (50003)
SET @num = 0;
BEGIN TRANSACTION;
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json;

    INSERT INTO dbo.multa (fecha_generacion, monto, motivo, detalle_prestamo_id)
    SELECT TOP 1 @hoy, 10.00, N'Prueba', d.id
    FROM dbo.detalleprestamo d
    WHERE d.ejemplar_id = @e1
    ORDER BY d.id DESC;

    BEGIN TRY
        EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50003
    THROW 50948, N'PRUEBA FALLIDA: una multa pendiente debía dar el error 50003.', 1;

-- Caso 5: límite de préstamos alcanzado (50004)
SET @num = 0;
BEGIN TRANSACTION;
    UPDATE dbo.tipocliente SET limite_prestamos = 0
    WHERE id = (SELECT tipo_cliente_id FROM dbo.cliente WHERE id = @cliente_id);
    BEGIN TRY
        EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50004
    THROW 50949, N'PRUEBA FALLIDA: superar el límite de préstamos debía dar el error 50004.', 1;

-- Caso 6: ejemplar no disponible (50005)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = N'[-1]';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50005
    THROW 50950, N'PRUEBA FALLIDA: un ejemplar inexistente o no disponible debía dar el error 50005.', 1;

-- Caso 7: empleado inexistente (50006)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = -1, @ejemplares = @json;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50006
    THROW 50951, N'PRUEBA FALLIDA: un empleado inexistente debía dar el error 50006.', 1;

-- Caso 8: lista de ejemplares vacía (50007)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = N'[]';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50007
    THROW 50952, N'PRUEBA FALLIDA: una lista vacía debía dar el error 50007.', 1;

PRINT N'OK sp_registrar_prestamo';