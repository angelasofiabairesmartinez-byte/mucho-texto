CREATE OR ALTER VIEW dbo.vw_clientes_prestamos_vigentes
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    ca.credencial_id,
    ca.vencimiento_credencial,
    p.id                                    AS prestamo_id,
    p.fecha_prestamo,
    p.fecha_vencimiento                     AS fecha_limite_devolucion,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), p.fecha_vencimiento) AS dias_restantes,
    l.id                                    AS libro_id,
    l.titulo,
    ej.codigo_barras,
    ep.nombre                               AS estado_prestamo
FROM dbo.prestamo p
INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
INNER JOIN dbo.ejemplar ej        ON ej.id = dp.ejemplar_id
INNER JOIN dbo.libro l            ON l.id = ej.libro_id
INNER JOIN dbo.estadoprestamo ep  ON ep.id = p.estado_prestamo_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
INNER JOIN (
    SELECT c.cliente_id,
           MAX(c.id)                AS credencial_id,
           MAX(c.fecha_vencimiento) AS vencimiento_credencial
    FROM dbo.credencial c
    WHERE c.estado = 'ACTIVA'
      AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
    GROUP BY c.cliente_id
) ca ON ca.cliente_id = cl.id
WHERE NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd WHERE dd.detalle_prestamo_id = dp.id)
  AND p.fecha_vencimiento >= CAST(GETDATE() AS DATE);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clientes con credencial activa y libros prestados sin devolver dentro del plazo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_clientes_prestamos_vigentes';
GO
