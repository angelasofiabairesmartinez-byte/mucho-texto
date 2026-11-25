/* ============================================================
   Prueba: estructura base de biblioteca_libreria
   Revisa que existan las tablas y vistas de la segunda entrega
   y que las vistas principales devuelvan datos.
   ============================================================ */
SET NOCOUNT ON;

IF (SELECT COUNT(*) FROM sys.tables WHERE schema_id = SCHEMA_ID(N'dbo')) < 53
    THROW 50900, N'PRUEBA FALLIDA: faltan tablas (se esperan 53).', 1;

IF (SELECT COUNT(*) FROM sys.views WHERE schema_id = SCHEMA_ID(N'dbo')) < 16
    THROW 50901, N'PRUEBA FALLIDA: faltan vistas (se esperan 16).', 1;

IF NOT EXISTS (SELECT 1 FROM dbo.vw_inventario_libros)
    THROW 50902, N'PRUEBA FALLIDA: vw_inventario_libros no devuelve filas.', 1;

DECLARE @cliente_id INT = (SELECT TOP 1 vh.cliente_id FROM dbo.vw_historial_cliente vh);
IF @cliente_id IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.fn_historial_cliente(@cliente_id))
    THROW 50903, N'PRUEBA FALLIDA: fn_historial_cliente no devuelve el historial.', 1;

PRINT N'OK estructura';
