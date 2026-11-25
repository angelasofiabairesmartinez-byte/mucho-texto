CREATE OR ALTER VIEW dbo.vw_inventario_libros
AS
SELECT
    l.id                                    AS libro_id,
    l.titulo,
    l.descripcion,
    l.precio_venta,
    l.permite_digital,
    ed.isbn,
    ed.numero_edicion,
    ed.anio_publicacion,
    eo.nombre                               AS editorial,
    i.nombre                                AS idioma,
    fl.nombre                               AS formato,
    (SELECT STRING_AGG(CONCAT_WS(' ', pa.nombre, pa.segundo_nombre, pa.apellido, pa.segundo_apellido), ', ')
                WITHIN GROUP (ORDER BY la.orden_autoria)
     FROM dbo.libroautor la
     INNER JOIN dbo.autor a    ON a.id = la.autor_id
     INNER JOIN dbo.persona pa ON pa.id = a.persona_id
     WHERE la.libro_id = l.id)              AS autores,
    (SELECT STRING_AGG(c.nombre, ', ') WITHIN GROUP (ORDER BY c.nombre)
     FROM dbo.librocategoria lc
     INNER JOIN dbo.categoria c ON c.id = lc.categoria_id
     WHERE lc.libro_id = l.id)              AS categorias,
    ISNULL(ex.total_ejemplares, 0)          AS total_ejemplares,
    ISNULL(ex.ejemplares_disponibles, 0)    AS ejemplares_disponibles,
    ex.costo_promedio_adquisicion,
    ISNULL(inv.disponible, 0)               AS stock_disponible,
    ISNULL(inv.danada, 0)                   AS stock_danado,
    ISNULL(inv.reservada, 0)                AS stock_reservado
FROM dbo.libro l
INNER JOIN dbo.edicion ed        ON ed.id = l.edicion_id
INNER JOIN dbo.editorial eo      ON eo.id = ed.editorial_id
INNER JOIN dbo.idioma i          ON i.id = ed.idioma_id
INNER JOIN dbo.formatolibro fl   ON fl.id = ed.formato_libro_id
LEFT JOIN (
    SELECT ej.libro_id,
           COUNT(*) AS total_ejemplares,
           SUM(CASE WHEN ee.nombre = N'Disponible' THEN 1 ELSE 0 END) AS ejemplares_disponibles,
           AVG(ej.precio_adquisicion) AS costo_promedio_adquisicion
    FROM dbo.ejemplar ej
    INNER JOIN dbo.estadoejemplar ee ON ee.id = ej.estado_ejemplar_id
    GROUP BY ej.libro_id
) ex ON ex.libro_id = l.id
LEFT JOIN (
    SELECT libro_id,
           SUM(cantidad_disponible) AS disponible,
           SUM(cantidad_danada)     AS danada,
           SUM(cantidad_reservada)  AS reservada
    FROM dbo.inventariosucursal
    GROUP BY libro_id
) inv ON inv.libro_id = l.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Información general de cada libro con autores, categorías, ejemplares y stock.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_inventario_libros';
GO
