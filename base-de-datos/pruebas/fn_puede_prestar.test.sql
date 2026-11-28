/* ============================================================
   Prueba: dbo.fn_puede_prestar
   Usa el cliente 31 (Estudiante, límite 3 préstamos) y arma cada
   caso dentro de una transacción que se revierte.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
DECLARE @prestamo_id INT;
DECLARE @detalle_id INT;

-- Caso 1: el cliente 1 tiene la credencial VENCIDA, no puede.
IF dbo.fn_puede_prestar(1) <> 0
    THROW 50921, N'PRUEBA FALLIDA: el cliente 1 (credencial vencida) no debía poder prestar.', 1;

-- Caso 2: un cliente inexistente no puede.
IF dbo.fn_puede_prestar(-1) <> 0
    THROW 50922, N'PRUEBA FALLIDA: un cliente inexistente no debía poder prestar.', 1;

-- Caso 3: credencial ACTIVA y vigente, sin multas y bajo el límite: puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'ACTIVA', fecha_vencimiento = DATEADD(DAY, 30, @hoy) WHERE cliente_id = 31;
    IF dbo.fn_puede_prestar(31) <> 1
        THROW 50923, N'PRUEBA FALLIDA: el cliente 31 con credencial activa debía poder prestar.', 1;
ROLLBACK TRANSACTION;

-- Caso 4: credencial SUSPENDIDA, no puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'SUSPENDIDA', fecha_vencimiento = DATEADD(DAY, 30, @hoy) WHERE cliente_id = 31;
    IF dbo.fn_puede_prestar(31) <> 0
        THROW 50924, N'PRUEBA FALLIDA: una credencial suspendida no debía permitir prestar.', 1;
ROLLBACK TRANSACTION;

-- Caso 5: credencial ACTIVA pero vencida ayer, no puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'ACTIVA', fecha_vencimiento = DATEADD(DAY, -1, @hoy) WHERE cliente_id = 31;
    IF dbo.fn_puede_prestar(31) <> 0
        THROW 50925, N'PRUEBA FALLIDA: una credencial vencida no debía permitir prestar.', 1;
ROLLBACK TRANSACTION;

-- Caso 6: multa PENDIENTE, no puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'ACTIVA', fecha_vencimiento = DATEADD(DAY, 30, @hoy) WHERE cliente_id = 31;
    INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, cliente_id, empleado_id, estado_prestamo_id)
    VALUES (@hoy, @hoy, 31, 1, 2);
    SET @prestamo_id = SCOPE_IDENTITY();
    INSERT INTO dbo.detalleprestamo (prestamo_id, ejemplar_id) VALUES (@prestamo_id, 1);
    SET @detalle_id = SCOPE_IDENTITY();
    INSERT INTO dbo.multa (fecha_generacion, monto, motivo, estado, detalle_prestamo_id)
    VALUES (@hoy, 25.00, N'Retraso en la devolución', N'PENDIENTE', @detalle_id);
    IF dbo.fn_puede_prestar(31) <> 0
        THROW 50926, N'PRUEBA FALLIDA: una multa pendiente no debía permitir prestar.', 1;
ROLLBACK TRANSACTION;

-- Caso 7: con 2 préstamos activos (límite 3) todavía puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'ACTIVA', fecha_vencimiento = DATEADD(DAY, 30, @hoy) WHERE cliente_id = 31;
    INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, cliente_id, empleado_id, estado_prestamo_id)
    VALUES (@hoy, DATEADD(DAY, 15, @hoy), 31, 1, 1),
           (@hoy, DATEADD(DAY, 15, @hoy), 31, 1, 1);
    IF dbo.fn_puede_prestar(31) <> 1
        THROW 50927, N'PRUEBA FALLIDA: con 2 préstamos de un límite de 3 debía poder prestar.', 1;
ROLLBACK TRANSACTION;

-- Caso 8: con 3 préstamos activos (el límite) ya no puede.
BEGIN TRANSACTION;
    UPDATE dbo.credencial SET estado = N'ACTIVA', fecha_vencimiento = DATEADD(DAY, 30, @hoy) WHERE cliente_id = 31;
    INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, cliente_id, empleado_id, estado_prestamo_id)
    VALUES (@hoy, DATEADD(DAY, 15, @hoy), 31, 1, 1),
           (@hoy, DATEADD(DAY, 15, @hoy), 31, 1, 1),
           (@hoy, DATEADD(DAY, 15, @hoy), 31, 1, 1);
    IF dbo.fn_puede_prestar(31) <> 0
        THROW 50928, N'PRUEBA FALLIDA: con 3 préstamos (el límite) no debía poder prestar.', 1;
ROLLBACK TRANSACTION;

PRINT N'OK fn_puede_prestar';