/* ============================================================
   Función: dbo.fn_prestamos_activos_cliente
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Cuenta los préstamos no devueltos de un cliente
                (estados 1 Activo, 3 Vencido, 4 Renovado y 8 En mora).
   Parámetros: @cliente_id (id del cliente)
   Devuelve: INT, cantidad de préstamos no devueltos (0 si no tiene o no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_prestamos_activos_cliente (@cliente_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @resultado INT;

    SELECT @resultado = COUNT(*)
    FROM dbo.prestamo p
    WHERE p.cliente_id = @cliente_id
      AND p.estado_prestamo_id IN (1, 3, 4, 8);

    RETURN @resultado;
END
GO