CREATE OR ALTER VIEW dbo.vw_facturas
AS
SELECT
    t.factura_id,
    t.fecha,
    t.canal,
    t.cliente_id,
    t.cliente,
    t.empleado_id,
    t.empleado,
    t.lineas,
    t.unidades,
    t.subtotal,
    t.descuento_total,
    t.impuesto_total,
    t.total,
    t.formas_pago,
    t.total_pagado,
    t.total - t.total_pagado AS saldo_pendiente,
    CASE WHEN t.total_pagado = 0 THEN N'SIN PAGO'
         WHEN t.total_pagado < t.total THEN N'PAGO PARCIAL'
         ELSE N'PAGADA' END  AS estado_pago
FROM (
    SELECT
        f.id                                AS factura_id,
        f.fecha,
        CASE f.canal WHEN 'L' THEN N'EN LÍNEA' ELSE N'TIENDA' END AS canal,
        f.cliente_id,
        CASE WHEN f.cliente_id IS NULL THEN N'Consumidor final'
             ELSE CONCAT_WS(' ', pc.nombre, pc.segundo_nombre, pc.apellido, pc.segundo_apellido) END AS cliente,
        f.empleado_id,
        CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS empleado,
        ISNULL(d.lineas, 0)                 AS lineas,
        ISNULL(d.unidades, 0)               AS unidades,
        ISNULL(d.subtotal, 0)               AS subtotal,
        ISNULL(d.descuento, 0)              AS descuento_total,
        ISNULL(d.impuesto, 0)               AS impuesto_total,
        ISNULL(d.subtotal, 0) - ISNULL(d.descuento, 0) + ISNULL(d.impuesto, 0) AS total,
        pg.formas_pago,
        ISNULL(pg.total_pagado, 0)          AS total_pagado
    FROM dbo.factura f
    LEFT JOIN dbo.cliente cl   ON cl.id = f.cliente_id
    LEFT JOIN dbo.persona pc   ON pc.id = cl.persona_id
    INNER JOIN dbo.empleado em ON em.id = f.empleado_id
    INNER JOIN dbo.persona pe  ON pe.id = em.persona_id
    LEFT JOIN (
        SELECT factura_id,
               COUNT(*)                          AS lineas,
               SUM(cantidad)                     AS unidades,
               SUM(cantidad * precio_unitario)   AS subtotal,
               SUM(descuento)                    AS descuento,
               SUM(monto_impuesto)               AS impuesto
        FROM dbo.detallefactura
        GROUP BY factura_id
    ) d ON d.factura_id = f.id
    LEFT JOIN (
        SELECT ffp.factura_id,
               SUM(ffp.monto)                    AS total_pagado,
               STRING_AGG(fp.nombre, ', ')       AS formas_pago
        FROM dbo.facturaformapago ffp
        INNER JOIN dbo.formapago fp ON fp.id = ffp.forma_pago_id
        GROUP BY ffp.factura_id
    ) pg ON pg.factura_id = f.id
) t;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Facturas con totales, canal de venta, formas de pago y estado de pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_facturas';
GO
