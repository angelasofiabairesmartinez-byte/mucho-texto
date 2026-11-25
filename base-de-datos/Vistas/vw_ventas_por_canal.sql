CREATE OR ALTER VIEW dbo.vw_ventas_por_canal
AS
SELECT
    CONVERT(CHAR(7), vf.fecha, 120)         AS periodo,
    vf.canal,
    COUNT(*)                                AS facturas,
    SUM(vf.unidades)                        AS unidades_vendidas,
    SUM(vf.subtotal)                        AS subtotal,
    SUM(vf.descuento_total)                 AS descuentos,
    SUM(vf.impuesto_total)                  AS impuestos,
    SUM(vf.total)                           AS total_vendido,
    CAST(AVG(vf.total) AS DECIMAL(10,2))    AS ticket_promedio
FROM dbo.vw_facturas vf
GROUP BY CONVERT(CHAR(7), vf.fecha, 120), vf.canal;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ventas por mes separadas en tienda y en línea.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ventas_por_canal';
GO
