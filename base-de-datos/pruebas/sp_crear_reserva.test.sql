/* ============================================================
   Prueba: dbo.sp_crear_reserva
   Caso 1: con todos los ejemplares prestados, un cliente que puede
           prestar crea una reserva PENDIENTE de tipo R.
   Casos 2 a 6: cada error (50001 a 50005) debe lanzarse con su número.
   Todo corre dentro de transacciones que se revierten.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @num INT;
DECLARE @r TABLE (reserva_id INT, estado NVARCHAR(30));
DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
DECLARE @estado_prestado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Prestado');
DECLARE @cliente_id INT = (SELECT TOP 1 c.id FROM dbo.cliente c WHERE dbo.fn_puede_prestar(c.id) = 1 ORDER BY c.id);
DECLARE @libro_id INT = (SELECT TOP 1 e.libro_id FROM dbo.ejemplar e ORDER BY e.id);
DECLARE @libro_disponible INT = (SELECT TOP 1 e.libro_id FROM dbo.ejemplar e
                                 WHERE e.estado_ejemplar_id = @estado_disponible ORDER BY e.id);

IF @cliente_id IS NULL OR @libro_id IS NULL OR @libro_disponible IS NULL
    THROW 50967, N'PRUEBA FALLIDA: faltan datos (cliente que pueda prestar, libro o ejemplar Disponible).', 1;

-- Caso 1: debe funcionar
BEGIN TRANSACTION;
    UPDATE dbo.ejemplar SET estado_ejemplar_id = @estado_prestado WHERE libro_id = @libro_id;
    UPDATE dbo.reserva SET estado = N'CANCELADA'
    WHERE cliente_id = @cliente_id AND libro_id = @libro_id AND estado = N'PENDIENTE';

    INSERT INTO @r
    EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = @libro_id;

    IF NOT EXISTS (SELECT 1 FROM @r WHERE reserva_id IS NOT NULL AND estado = N'PENDIENTE')
        THROW 50968, N'PRUEBA FALLIDA: sp_crear_reserva debía devolver reserva_id y estado PENDIENTE.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.reserva rs INNER JOIN @r r ON r.reserva_id = rs.id
                   WHERE rs.cliente_id = @cliente_id AND rs.libro_id = @libro_id
                     AND rs.tipo = N'R' AND rs.estado = N'PENDIENTE')
        THROW 50969, N'PRUEBA FALLIDA: no se creó la reserva PENDIENTE de tipo R.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: cliente inexistente (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_crear_reserva @cliente_id = -1, @libro_id = @libro_id;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50970, N'PRUEBA FALLIDA: un cliente inexistente debía dar el error 50001.', 1;

-- Caso 3: libro inexistente (50002)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = -1;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50002
    THROW 50971, N'PRUEBA FALLIDA: un libro inexistente debía dar el error 50002.', 1;

-- Caso 4: libro con ejemplares disponibles (50003)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = @libro_disponible;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50003
    THROW 50972, N'PRUEBA FALLIDA: un libro con ejemplares disponibles debía dar el error 50003.', 1;

-- Caso 5: reserva pendiente repetida (50004)
SET @num = 0;
BEGIN TRANSACTION;
    UPDATE dbo.ejemplar SET estado_ejemplar_id = @estado_prestado WHERE libro_id = @libro_id;
    UPDATE dbo.reserva SET estado = N'CANCELADA'
    WHERE cliente_id = @cliente_id AND libro_id = @libro_id AND estado = N'PENDIENTE';

    EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = @libro_id;
    BEGIN TRY
        EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = @libro_id;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50004
    THROW 50973, N'PRUEBA FALLIDA: una reserva pendiente repetida debía dar el error 50004.', 1;

-- Caso 6: cliente que no puede prestar (50005)
SET @num = 0;
BEGIN TRANSACTION;
    UPDATE dbo.ejemplar SET estado_ejemplar_id = @estado_prestado WHERE libro_id = @libro_id;
    UPDATE dbo.reserva SET estado = N'CANCELADA'
    WHERE cliente_id = @cliente_id AND libro_id = @libro_id AND estado = N'PENDIENTE';
    UPDATE dbo.credencial SET estado = N'SUSPENDIDA' WHERE cliente_id = @cliente_id;
    BEGIN TRY
        EXEC dbo.sp_crear_reserva @cliente_id = @cliente_id, @libro_id = @libro_id;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50005
    THROW 50974, N'PRUEBA FALLIDA: un cliente sin credencial activa debía dar el error 50005.', 1;

PRINT N'OK sp_crear_reserva';