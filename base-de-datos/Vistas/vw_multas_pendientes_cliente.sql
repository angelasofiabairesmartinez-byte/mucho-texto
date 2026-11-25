CREATE OR ALTER VIEW dbo.vw_multas_pendientes_cliente
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    COUNT(m.id)                             AS cantidad_multas_pendientes,
    SUM(m.monto)                            AS monto_total_pendiente,
    SUM(ISNULL(pg.total_pagado, 0))         AS total_abonado,
    SUM(m.monto - ISNULL(pg.total_pagado, 0)) AS saldo_pendiente,
    MIN(m.fecha_generacion)                 AS multa_mas_antigua
FROM dbo.multa m
INNER JOIN dbo.detalleprestamo dp ON dp.id = m.detalle_prestamo_id
INNER JOIN dbo.prestamo p         ON p.id = dp.prestamo_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
LEFT JOIN (
    SELECT multa_id, SUM(monto) AS total_pagado
    FROM dbo.pagomulta
    GROUP BY multa_id
) pg ON pg.multa_id = m.id
WHERE m.estado = 'PENDIENTE'
GROUP BY cl.id, pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido, pe.correo;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Multas pendientes por cliente con monto total, abonos y saldo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_multas_pendientes_cliente';
GO
