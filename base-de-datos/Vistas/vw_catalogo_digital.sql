CREATE OR ALTER VIEW dbo.vw_catalogo_digital
AS
SELECT
    l.id                                    AS libro_id,
    l.titulo,
    CASE WHEN rt.id IS NULL THEN N'NO' ELSE N'SI' END AS tiene_texto,
    rt.total_paginas,
    CASE WHEN ra.id IS NULL THEN N'NO' ELSE N'SI' END AS tiene_audio,
    CASE WHEN ra.id IS NULL THEN NULL
         WHEN ra.generado_ia = 1 THEN N'SI' ELSE N'NO' END AS audio_generado_ia,
    ra.voz_narracion,
    CONVERT(VARCHAR(8), DATEADD(SECOND, ra.duracion_segundos, CAST('00:00:00' AS TIME(0))), 108) AS duracion_audio,
    ISNULL(lc.lectores, 0)                  AS lectores,
    lc.avance_promedio
FROM dbo.libro l
LEFT JOIN dbo.recursodigital rt ON rt.libro_id = l.id AND rt.tipo = 'T' AND rt.estado = 1
LEFT JOIN dbo.recursodigital ra ON ra.libro_id = l.id AND ra.tipo = 'A' AND ra.estado = 1
LEFT JOIN (
    SELECT rd.libro_id,
           COUNT(DISTINCT pl.cliente_id)               AS lectores,
           CAST(AVG(pl.porcentaje) AS DECIMAL(5,2))    AS avance_promedio
    FROM dbo.progresolectura pl
    INNER JOIN dbo.recursodigital rd ON rd.id = pl.recurso_digital_id
    GROUP BY rd.libro_id
) lc ON lc.libro_id = l.id
WHERE l.permite_digital = 1;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Libros con derechos digitales: texto, audio, IA, duración y lectores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_catalogo_digital';
GO
