CREATE OR ALTER VIEW dbo.vw_ranking_libros
AS
SELECT
    x.libro_id,
    x.titulo,
    x.cantidad_prestamos,
    x.cantidad_ventas,
    x.calificacion_promedio,
    x.total_resenas,
    RANK() OVER (ORDER BY x.cantidad_prestamos DESC)    AS ranking_prestamos,
    RANK() OVER (ORDER BY x.cantidad_ventas DESC)       AS ranking_ventas,
    RANK() OVER (ORDER BY x.calificacion_promedio DESC) AS ranking_calificacion,
    RANK() OVER (ORDER BY x.cantidad_prestamos DESC,
                          x.cantidad_ventas DESC,
                          x.calificacion_promedio DESC) AS ranking_general
FROM (
    SELECT
        l.id                                AS libro_id,
        l.titulo,
        ISNULL(pr.cantidad_prestamos, 0)    AS cantidad_prestamos,
        ISNULL(vt.cantidad_ventas, 0)       AS cantidad_ventas,
        rs.calificacion_promedio,
        ISNULL(rs.total_resenas, 0)         AS total_resenas
    FROM dbo.libro l
    LEFT JOIN (
        SELECT ej.libro_id, COUNT(dp.id) AS cantidad_prestamos
        FROM dbo.detalleprestamo dp
        INNER JOIN dbo.ejemplar ej ON ej.id = dp.ejemplar_id
        GROUP BY ej.libro_id
    ) pr ON pr.libro_id = l.id
    LEFT JOIN (
        SELECT libro_id, SUM(cantidad) AS cantidad_ventas
        FROM dbo.detallefactura
        GROUP BY libro_id
    ) vt ON vt.libro_id = l.id
    LEFT JOIN (
        SELECT libro_id,
               CAST(AVG(CAST(calificacion AS DECIMAL(5,2))) AS DECIMAL(4,2)) AS calificacion_promedio,
               COUNT(*) AS total_resenas
        FROM dbo.resenalibro
        WHERE estado = 1
        GROUP BY libro_id
    ) rs ON rs.libro_id = l.id
) x;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ranking de libros por préstamos, ventas y calificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ranking_libros';
GO
