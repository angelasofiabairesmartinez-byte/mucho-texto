/* ============================================================
   Función: dbo.fn_ejemplares_disponibles
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Cuenta los ejemplares de un libro con estado 1 (Disponible).
   Parámetros: @libro_id (id del libro)
   Devuelve: INT, cantidad de ejemplares disponibles (0 si no hay o el libro no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_ejemplares_disponibles (@libro_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @resultado INT;

    SELECT @resultado = COUNT(*)
    FROM dbo.ejemplar e
    WHERE e.libro_id = @libro_id
      AND e.estado_ejemplar_id = 1;

    RETURN @resultado;
END
GO