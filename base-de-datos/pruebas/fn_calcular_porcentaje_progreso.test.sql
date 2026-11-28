/* ============================================================
   Prueba: dbo.fn_calcular_porcentaje_progreso
   Recurso 1: libro digital de 336 páginas.
   Recurso 23: audiolibro de 21120 segundos.
   ============================================================ */
SET NOCOUNT ON;

IF dbo.fn_calcular_porcentaje_progreso(1, 168) <> 50.00
    THROW 50940, N'PRUEBA FALLIDA: página 168 de 336 debía ser 50%.', 1;

IF dbo.fn_calcular_porcentaje_progreso(23, 5280) <> 25.00
    THROW 50941, N'PRUEBA FALLIDA: segundo 5280 de 21120 debía ser 25%.', 1;

IF dbo.fn_calcular_porcentaje_progreso(1, 0) <> 0.00
    THROW 50942, N'PRUEBA FALLIDA: la posición 0 debía ser 0%.', 1;

IF dbo.fn_calcular_porcentaje_progreso(1, 500) <> 100.00
    THROW 50943, N'PRUEBA FALLIDA: pasar del total debía dar 100%.', 1;

IF dbo.fn_calcular_porcentaje_progreso(-1, 10) <> 0.00
    THROW 50944, N'PRUEBA FALLIDA: un recurso inexistente debía dar 0%.', 1;

PRINT N'OK fn_calcular_porcentaje_progreso';
