CREATE OR ALTER VIEW dbo.vw_lista_deseos_detalle
AS
SELECT
    ld.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    l.id                                    AS libro_id,
    l.titulo,
    l.precio_venta,
    ISNULL(inv.disponible, 0)               AS unidades_disponibles,
    CASE WHEN l.permite_digital = 1 THEN N'SI' ELSE N'NO' END AS disponible_digital,
    CASE WHEN ld.notificar_descuento = 1 THEN N'SI' ELSE N'NO' END AS avisar_descuento,
    ld.fecha_agregado,
    DATEDIFF(DAY, ld.fecha_agregado, CAST(GETDATE() AS DATE)) AS dias_en_lista
FROM dbo.listadeseo ld
INNER JOIN dbo.cliente cl  ON cl.id = ld.cliente_id
INNER JOIN dbo.persona pe  ON pe.id = cl.persona_id
INNER JOIN dbo.libro l     ON l.id = ld.libro_id
LEFT JOIN (
    SELECT libro_id, SUM(cantidad_disponible) AS disponible
    FROM dbo.inventariosucursal
    GROUP BY libro_id
) inv ON inv.libro_id = l.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Lista de deseos de cada cliente con precio y disponibilidad.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_lista_deseos_detalle';
GO
