/* ============================================================
   Prueba: dbo.fn_calcular_multa
   El detalle de préstamo 1 pertenece al préstamo 1, que vence
   el 2026-08-06. La multa es L 5.00 por cada día de atraso.
   ============================================================ */
SET NOCOUNT ON;

IF dbo.fn_calcular_multa(1, '2026-08-06') <> 0
    THROW 50916, N'PRUEBA FALLIDA: devolver el día del vencimiento debía dar multa 0.', 1;

IF dbo.fn_calcular_multa(1, '2026-08-01') <> 0
    THROW 50917, N'PRUEBA FALLIDA: devolver antes del vencimiento debía dar multa 0.', 1;

IF dbo.fn_calcular_multa(1, '2026-08-11') <> 25.00
    THROW 50918, N'PRUEBA FALLIDA: 5 días de atraso debían dar multa 25.00.', 1;

IF dbo.fn_calcular_multa(1, '2026-08-16') <> 50.00
    THROW 50919, N'PRUEBA FALLIDA: 10 días de atraso debían dar multa 50.00.', 1;

IF dbo.fn_calcular_multa(-1, '2026-08-16') <> 0
    THROW 50920, N'PRUEBA FALLIDA: un detalle inexistente debía dar multa 0.', 1;

PRINT N'OK fn_calcular_multa';