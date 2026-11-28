/* ============================================================
   Prueba: dbo.sp_registrar_devolucion
   Caso 1: devolver un ejemplar deja el préstamo Parcialmente devuelto;
           devolver el otro lo deja Devuelto (y uno queda Dañado).
   Caso 2: con 3 días de atraso la multa es L 15.00 y queda PENDIENTE.
   Caso 3: si hay una reserva pendiente del libro, el ejemplar queda Reservado.
   Casos 4 a 6: errores 50001 a 50003.
   Todo corre dentro de transacciones que se revierten.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
DECLARE @num INT;
DECLARE @p TABLE (prestamo_id INT, fecha_vencimiento DATE);
DECLARE @d TABLE (devolucion_id INT, multa_total DECIMAL(10,2));
DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
DECLARE @estado_reservado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Reservado');
DECLARE @estado_danado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Dañado');
DECLARE @cliente_id INT = (SELECT TOP 1 c.id FROM dbo.cliente c WHERE dbo.fn_puede_prestar(c.id) = 1 ORDER BY c.id);
DECLARE @empleado_id INT = (SELECT TOP 1 e.id FROM dbo.empleado e ORDER BY e.id);
DECLARE @e1 INT, @e2 INT;
DECLARE @prestamo_id INT, @reserva_id INT;

;WITH d AS (SELECT TOP 2 id FROM dbo.ejemplar WHERE estado_ejemplar_id = @estado_disponible ORDER BY id)
SELECT @e1 = MIN(id), @e2 = MAX(id) FROM d;

IF @cliente_id IS NULL OR @empleado_id IS NULL OR @e1 IS NULL OR @e1 = @e2
    THROW 50953, N'PRUEBA FALLIDA: faltan datos (cliente que pueda prestar, empleado o 2 ejemplares Disponibles).', 1;

DECLARE @json_prestamo NVARCHAR(MAX) = CONCAT(N'[', @e1, N',', @e2, N']');
DECLARE @json_solo_e1 NVARCHAR(MAX) = CONCAT(N'[', @e1, N']');
DECLARE @json_e1 NVARCHAR(MAX) = CONCAT(N'[{"ejemplar_id":', @e1, N',"condicion_entrega":"Buen estado"}]');
DECLARE @json_e2 NVARCHAR(MAX) = CONCAT(N'[{"ejemplar_id":', @e2, N',"condicion_entrega":"Portada dañada"}]');

-- Caso 1: devolución parcial y luego total
BEGIN TRANSACTION;
    UPDATE dbo.reserva SET estado = N'CANCELADA' WHERE estado = N'PENDIENTE';

    INSERT INTO @p
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json_prestamo;
    SELECT @prestamo_id = prestamo_id FROM @p;

    INSERT INTO @d
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id, @ejemplares = @json_e1;

    IF NOT EXISTS (SELECT 1 FROM @d WHERE devolucion_id IS NOT NULL AND multa_total = 0)
        THROW 50954, N'PRUEBA FALLIDA: sp_registrar_devolucion debía devolver devolucion_id y multa_total 0.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.ejemplar WHERE id = @e1 AND estado_ejemplar_id = @estado_disponible)
        THROW 50955, N'PRUEBA FALLIDA: el ejemplar devuelto debía quedar Disponible.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.prestamo WHERE id = @prestamo_id AND estado_prestamo_id = 12)
        THROW 50956, N'PRUEBA FALLIDA: el préstamo debía quedar Parcialmente devuelto.', 1;

    DELETE FROM @d;
    INSERT INTO @d
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id, @ejemplares = @json_e2;

    IF NOT EXISTS (SELECT 1 FROM dbo.prestamo WHERE id = @prestamo_id AND estado_prestamo_id = 2)
        THROW 50957, N'PRUEBA FALLIDA: el préstamo debía quedar Devuelto.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.ejemplar WHERE id = @e2 AND estado_ejemplar_id = @estado_danado)
        THROW 50958, N'PRUEBA FALLIDA: el ejemplar con la portada dañada debía quedar Dañado.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.historialprestamo WHERE prestamo_id = @prestamo_id AND estado_nuevo = N'Devuelto')
        THROW 50959, N'PRUEBA FALLIDA: el historial debía registrar el estado Devuelto.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: atraso de 3 días = L 15.00
BEGIN TRANSACTION;
    UPDATE dbo.reserva SET estado = N'CANCELADA' WHERE estado = N'PENDIENTE';

    DELETE FROM @p;
    INSERT INTO @p
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json_solo_e1;
    SELECT @prestamo_id = prestamo_id FROM @p;

    UPDATE dbo.prestamo SET fecha_vencimiento = DATEADD(DAY, -3, @hoy) WHERE id = @prestamo_id;

    DELETE FROM @d;
    INSERT INTO @d
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id, @ejemplares = @json_e1;

    IF NOT EXISTS (SELECT 1 FROM @d WHERE multa_total = 15.00)
        THROW 50960, N'PRUEBA FALLIDA: 3 días de atraso debían dar una multa_total de 15.00.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.multa m
                   INNER JOIN dbo.detalleprestamo dp ON dp.id = m.detalle_prestamo_id
                   WHERE dp.prestamo_id = @prestamo_id AND m.monto = 15.00 AND m.estado = N'PENDIENTE')
        THROW 50961, N'PRUEBA FALLIDA: debía crearse una multa PENDIENTE de 15.00.', 1;
ROLLBACK TRANSACTION;

-- Caso 3: reserva en espera
BEGIN TRANSACTION;
    UPDATE dbo.reserva SET estado = N'CANCELADA' WHERE estado = N'PENDIENTE';

    DELETE FROM @p;
    INSERT INTO @p
    EXEC dbo.sp_registrar_prestamo @cliente_id = @cliente_id, @empleado_id = @empleado_id, @ejemplares = @json_solo_e1;

    INSERT INTO dbo.reserva (cliente_id, libro_id)
    SELECT @cliente_id, e.libro_id FROM dbo.ejemplar e WHERE e.id = @e1;
    SET @reserva_id = SCOPE_IDENTITY();

    DELETE FROM @d;
    INSERT INTO @d
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id, @ejemplares = @json_e1;

    IF NOT EXISTS (SELECT 1 FROM dbo.reserva WHERE id = @reserva_id AND ejemplar_id = @e1 AND estado = N'PENDIENTE')
        THROW 50962, N'PRUEBA FALLIDA: la reserva pendiente debía quedar con el ejemplar devuelto.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.ejemplar WHERE id = @e1 AND estado_ejemplar_id = @estado_reservado)
        THROW 50963, N'PRUEBA FALLIDA: el ejemplar debía quedar Reservado.', 1;
ROLLBACK TRANSACTION;

-- Caso 4: empleado inexistente (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_devolucion @empleado_id = -1, @ejemplares = @json_e1;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50964, N'PRUEBA FALLIDA: un empleado inexistente debía dar el error 50001.', 1;

-- Caso 5: sin ejemplares (50002)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id, @ejemplares = N'[]';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50002
    THROW 50965, N'PRUEBA FALLIDA: una lista vacía debía dar el error 50002.', 1;

-- Caso 6: ejemplar sin préstamo pendiente (50003)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_devolucion @empleado_id = @empleado_id,
         @ejemplares = N'[{"ejemplar_id":-1,"condicion_entrega":"Buen estado"}]';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50003
    THROW 50966, N'PRUEBA FALLIDA: un ejemplar sin préstamo debía dar el error 50003.', 1;

PRINT N'OK sp_registrar_devolucion';
