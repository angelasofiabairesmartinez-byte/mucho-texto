CREATE OR ALTER VIEW dbo.vw_biblioteca_digital_cliente
AS
SELECT
    pl.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    l.id                                    AS libro_id,
    l.titulo,
    CASE rd.tipo WHEN 'T' THEN N'TEXTO' ELSE N'AUDIO' END AS tipo_recurso,
    pl.posicion_actual,
    CASE rd.tipo WHEN 'T' THEN rd.total_paginas ELSE rd.duracion_segundos END AS posicion_final,
    pl.porcentaje,
    CASE WHEN pl.porcentaje >= 100 THEN N'TERMINADO'
         WHEN rd.tipo = 'T' THEN N'LEYENDO'
         ELSE N'ESCUCHANDO' END             AS situacion,
    pl.fecha_inicio,
    pl.fecha_ultima_lectura,
    ISNULL(nt.total_notas, 0)               AS total_notas
FROM dbo.progresolectura pl
INNER JOIN dbo.recursodigital rd ON rd.id = pl.recurso_digital_id
INNER JOIN dbo.libro l           ON l.id = rd.libro_id
INNER JOIN dbo.cliente cl        ON cl.id = pl.cliente_id
INNER JOIN dbo.persona pe        ON pe.id = cl.persona_id
LEFT JOIN (
    SELECT nl.cliente_id, nl.recurso_digital_id, COUNT(*) AS total_notas
    FROM dbo.notalectura nl
    GROUP BY nl.cliente_id, nl.recurso_digital_id
) nt ON nt.cliente_id = pl.cliente_id AND nt.recurso_digital_id = pl.recurso_digital_id
WHERE rd.estado = 1;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Avance de lectura y audio de cada cliente en la biblioteca digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_biblioteca_digital_cliente';
GO
