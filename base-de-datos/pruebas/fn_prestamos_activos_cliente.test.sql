/* ============================================================
   Prueba: dbo.fn_prestamos_activos_cliente
   Caso 1: el cliente 1 no tiene préstamos, debe dar 0.
   Caso 2: el cliente 3 solo tiene préstamos devueltos o cerrados, debe dar 0.
   Caso 3: se crean 3 préstamos del cliente 1 (Activo, Renovado y
           Devuelto) dentro de una transacción que se revierte;
           deben contarse solo 2.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF dbo.fn_prestamos_activos_cliente(1) <> 0
    THROW 50913, N'PRUEBA FALLIDA: fn_prestamos_activos_cliente(1) debía devolver 0.', 1;

IF dbo.fn_prestamos_activos_cliente(3) <> 0
    THROW 50914, N'PRUEBA FALLIDA: fn_prestamos_activos_cliente(3) debía devolver 0 (solo tiene préstamos devueltos o cerrados).', 1;

BEGIN TRANSACTION;
    INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, cliente_id, empleado_id, estado_prestamo_id)
    VALUES (CAST(GETDATE() AS DATE), DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 1, 1, 1),
           (CAST(GETDATE() AS DATE), DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 1, 1, 4),
           (CAST(GETDATE() AS DATE), DATEADD(DAY, 15, CAST(GETDATE() AS DATE)), 1, 1, 2);

    IF dbo.fn_prestamos_activos_cliente(1) <> 2
        THROW 50915, N'PRUEBA FALLIDA: fn_prestamos_activos_cliente(1) debía devolver 2 (Activo y Renovado; el Devuelto no cuenta).', 1;
ROLLBACK TRANSACTION;

PRINT N'OK fn_prestamos_activos_cliente';