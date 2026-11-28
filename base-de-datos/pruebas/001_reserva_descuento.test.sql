/* ============================================================
   Prueba: columnas agregadas en la tercera entrega
   reserva: tipo, sucursal_id, ejemplar_id, prestamo_id
   descuento: tipo_cliente_id, categoria_id
   ============================================================ */
SET NOCOUNT ON;

IF COL_LENGTH(N'dbo.reserva', N'tipo') IS NULL
   OR COL_LENGTH(N'dbo.reserva', N'sucursal_id') IS NULL
   OR COL_LENGTH(N'dbo.reserva', N'ejemplar_id') IS NULL
   OR COL_LENGTH(N'dbo.reserva', N'prestamo_id') IS NULL
    THROW 50910, N'PRUEBA FALLIDA: faltan columnas nuevas en reserva.', 1;

IF COL_LENGTH(N'dbo.descuento', N'tipo_cliente_id') IS NULL
   OR COL_LENGTH(N'dbo.descuento', N'categoria_id') IS NULL
    THROW 50911, N'PRUEBA FALLIDA: faltan columnas nuevas en descuento.', 1;

IF EXISTS (SELECT 1 FROM dbo.reserva r WHERE r.tipo <> N'R')
    THROW 50912, N'PRUEBA FALLIDA: las reservas existentes deben quedar como tipo R.', 1;

IF NOT EXISTS (SELECT 1 FROM dbo.descuento d WHERE d.tipo_cliente_id IS NOT NULL)
   OR NOT EXISTS (SELECT 1 FROM dbo.descuento d WHERE d.categoria_id IS NOT NULL)
    THROW 50913, N'PRUEBA FALLIDA: no hay descuentos asignados a tipo de cliente o categoría.', 1;

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.reserva (cliente_id, libro_id, tipo) VALUES (1, 1, N'X');
    ROLLBACK TRANSACTION;
    THROW 50914, N'PRUEBA FALLIDA: reserva acepta un tipo distinto de R o S.', 1;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 50914 THROW;
END CATCH;

PRINT N'OK reserva y descuento';
