/* ============================================================
   Función: dbo.fn_puede_prestar
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Indica si un cliente puede recibir un préstamo: credencial
                ACTIVA y vigente, sin multas PENDIENTE y por debajo de
                su límite de préstamos (tipocliente.limite_prestamos).
   Parámetros: @cliente_id (id del cliente)
   Devuelve: BIT, 1 si puede prestar; 0 si no (o si el cliente no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_puede_prestar (@cliente_id INT)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT;

    SELECT @resultado =
        CASE
            WHEN EXISTS (SELECT 1
                         FROM dbo.credencial cr
                         WHERE cr.cliente_id = c.id
                           AND cr.estado = N'ACTIVA'
                           AND cr.fecha_vencimiento >= CAST(GETDATE() AS DATE))
             AND NOT EXISTS (SELECT 1
                             FROM dbo.multa m
                             INNER JOIN dbo.detalleprestamo d ON d.id = m.detalle_prestamo_id
                             INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
                             WHERE p.cliente_id = c.id
                               AND m.estado = N'PENDIENTE')
             AND dbo.fn_prestamos_activos_cliente(c.id) < tc.limite_prestamos
            THEN 1
            ELSE 0
        END
    FROM dbo.cliente c
    INNER JOIN dbo.tipocliente tc ON tc.id = c.tipo_cliente_id
    WHERE c.id = @cliente_id;

    RETURN ISNULL(@resultado, 0);
END
GO