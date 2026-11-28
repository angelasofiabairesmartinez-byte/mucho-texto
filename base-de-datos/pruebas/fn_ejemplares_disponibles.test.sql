/* ============================================================
   Prueba: dbo.fn_ejemplares_disponibles
   Casos con resultado conocido en los datos iniciales:
   libro 1 tiene 1 ejemplar disponible; libro 6 tiene su único
   ejemplar en exhibición (estado 10); el libro -1 no existe.
   ============================================================ */
SET NOCOUNT ON;

IF dbo.fn_ejemplares_disponibles(1) <> 1
    THROW 50910, N'PRUEBA FALLIDA: fn_ejemplares_disponibles(1) debía devolver 1.', 1;

IF dbo.fn_ejemplares_disponibles(6) <> 0
    THROW 50911, N'PRUEBA FALLIDA: fn_ejemplares_disponibles(6) debía devolver 0 (su ejemplar no está disponible).', 1;

IF dbo.fn_ejemplares_disponibles(-1) <> 0
    THROW 50912, N'PRUEBA FALLIDA: fn_ejemplares_disponibles(-1) debía devolver 0 (libro inexistente).', 1;

PRINT N'OK fn_ejemplares_disponibles';