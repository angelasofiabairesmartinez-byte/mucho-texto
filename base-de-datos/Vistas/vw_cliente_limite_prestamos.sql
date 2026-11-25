CREATE OR ALTER VIEW dbo.vw_cliente_limite_prestamos
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    tc.nombre                               AS tipo_cliente,
    tc.limite_prestamos,
    tc.limite_renovaciones,
    ISNULL(pu.en_uso, 0)                    AS prestamos_en_uso,
    CASE WHEN tc.limite_prestamos - ISNULL(pu.en_uso, 0) > 0
         THEN tc.limite_prestamos - ISNULL(pu.en_uso, 0)
         ELSE 0 END                         AS cupos_disponibles,
    CASE WHEN cr.cliente_id IS NULL THEN N'NO' ELSE N'SI' END AS credencial_activa,
    ISNULL(mp.saldo_pendiente, 0)           AS saldo_multas_pendientes,
    CASE WHEN cr.cliente_id IS NULL THEN N'NO - CREDENCIAL INACTIVA O VENCIDA'
         WHEN ISNULL(mp.saldo_pendiente, 0) > 0 THEN N'NO - MULTAS PENDIENTES'
         WHEN ISNULL(pu.en_uso, 0) >= tc.limite_prestamos THEN N'NO - LÍMITE ALCANZADO'
         ELSE N'SI' END                     AS puede_prestar
FROM dbo.cliente cl
INNER JOIN dbo.persona pe      ON pe.id = cl.persona_id
INNER JOIN dbo.tipocliente tc  ON tc.id = cl.tipo_cliente_id
LEFT JOIN (
    SELECT p.cliente_id, COUNT(dp.id) AS en_uso
    FROM dbo.prestamo p
    INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
    WHERE NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd WHERE dd.detalle_prestamo_id = dp.id)
    GROUP BY p.cliente_id
) pu ON pu.cliente_id = cl.id
LEFT JOIN (
    SELECT DISTINCT c.cliente_id
    FROM dbo.credencial c
    WHERE c.estado = 'ACTIVA'
      AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
) cr ON cr.cliente_id = cl.id
LEFT JOIN dbo.vw_multas_pendientes_cliente mp ON mp.cliente_id = cl.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Préstamos en uso contra el límite de cada cliente e indicador de si puede prestar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_cliente_limite_prestamos';
GO
