CREATE OR ALTER VIEW dbo.vw_inventario_sucursal
AS
SELECT
    s.id                                    AS sucursal_id,
    s.nombre                                AS sucursal,
    s.direccion,
    s.telefono,
    ISNULL(inv.titulos, 0)                  AS titulos_distintos,
    ISNULL(inv.disponible, 0)               AS unidades_disponibles,
    ISNULL(inv.danada, 0)                   AS unidades_danadas,
    ISNULL(inv.reservada, 0)                AS unidades_reservadas,
    ISNULL(inv.disponible, 0) + ISNULL(inv.danada, 0) + ISNULL(inv.reservada, 0) AS total_unidades,
    ISNULL(ex.ejemplares, 0)                AS ejemplares_ubicados,
    inv.ultima_actualizacion
FROM dbo.sucursal s
LEFT JOIN (
    SELECT sucursal_id,
           COUNT(DISTINCT libro_id)    AS titulos,
           SUM(cantidad_disponible)    AS disponible,
           SUM(cantidad_danada)        AS danada,
           SUM(cantidad_reservada)     AS reservada,
           MAX(fecha_actualizacion)    AS ultima_actualizacion
    FROM dbo.inventariosucursal
    GROUP BY sucursal_id
) inv ON inv.sucursal_id = s.id
LEFT JOIN (
    SELECT es.sucursal_id, COUNT(ej.id) AS ejemplares
    FROM dbo.ejemplar ej
    INNER JOIN dbo.cubiculo cu ON cu.id = ej.cubiculo_id
    INNER JOIN dbo.estante es  ON es.id = cu.estante_id
    GROUP BY es.sucursal_id
) ex ON ex.sucursal_id = s.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Unidades disponibles, dañadas y reservadas por sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_inventario_sucursal';
GO
