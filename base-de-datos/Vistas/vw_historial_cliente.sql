CREATE OR ALTER VIEW dbo.vw_historial_cliente
AS
SELECT
    f.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    N'COMPRA'                               AS tipo_movimiento,
    f.fecha                                 AS fecha_movimiento,
    f.id                                    AS numero_documento,
    l.id                                    AS libro_id,
    l.titulo,
    ed.isbn,
    df.cantidad,
    df.cantidad * df.precio_unitario - df.descuento + df.monto_impuesto AS monto_total,
    CAST(NULL AS DATE)                      AS fecha_limite_devolucion,
    CAST(NULL AS DATETIME2(0))              AS fecha_devolucion,
    N'COMPRADO'                             AS situacion
FROM dbo.factura f
INNER JOIN dbo.detallefactura df ON df.factura_id = f.id
INNER JOIN dbo.libro l           ON l.id = df.libro_id
INNER JOIN dbo.edicion ed        ON ed.id = l.edicion_id
INNER JOIN dbo.cliente cl        ON cl.id = f.cliente_id
INNER JOIN dbo.persona pe        ON pe.id = cl.persona_id

UNION ALL

SELECT
    p.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    N'PRÉSTAMO'                             AS tipo_movimiento,
    CAST(p.fecha_prestamo AS DATETIME2(0))  AS fecha_movimiento,
    p.id                                    AS numero_documento,
    l.id                                    AS libro_id,
    l.titulo,
    ed.isbn,
    1                                       AS cantidad,
    CAST(NULL AS DECIMAL(12,2))             AS monto_total,
    p.fecha_vencimiento                     AS fecha_limite_devolucion,
    dev.fecha_devolucion,
    CASE WHEN dev.id IS NOT NULL THEN N'DEVUELTO'
         WHEN p.fecha_vencimiento < CAST(GETDATE() AS DATE) THEN N'RETRASADO'
         ELSE N'VIGENTE' END                AS situacion
FROM dbo.prestamo p
INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
INNER JOIN dbo.ejemplar ej        ON ej.id = dp.ejemplar_id
INNER JOIN dbo.libro l            ON l.id = ej.libro_id
INNER JOIN dbo.edicion ed         ON ed.id = l.edicion_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
LEFT JOIN dbo.detalledevolucion dd ON dd.detalle_prestamo_id = dp.id
LEFT JOIN dbo.devolucion dev       ON dev.id = dd.devolucion_id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Historial de libros comprados y prestados por cada cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_historial_cliente';
GO
