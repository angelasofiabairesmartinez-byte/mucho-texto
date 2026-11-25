CREATE OR ALTER VIEW dbo.vw_clientes_credenciales_inactivas
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    tc.nombre                               AS tipo_cliente,
    c.id                                    AS credencial_id,
    c.fecha_registro,
    c.fecha_vencimiento,
    c.estado                                AS estado_credencial,
    CASE WHEN c.estado = 'ACTIVA' THEN N'VENCIDA POR FECHA' ELSE c.estado END AS situacion,
    CASE WHEN c.fecha_vencimiento < CAST(GETDATE() AS DATE)
         THEN DATEDIFF(DAY, c.fecha_vencimiento, CAST(GETDATE() AS DATE))
         ELSE 0 END                         AS dias_vencida,
    CASE WHEN EXISTS (SELECT 1
                      FROM dbo.credencial c2
                      WHERE c2.cliente_id = c.cliente_id
                        AND c2.estado = 'ACTIVA'
                        AND (c2.fecha_vencimiento IS NULL OR c2.fecha_vencimiento >= CAST(GETDATE() AS DATE)))
         THEN N'SI' ELSE N'NO' END          AS tiene_otra_credencial_activa
FROM dbo.credencial c
INNER JOIN dbo.cliente cl      ON cl.id = c.cliente_id
INNER JOIN dbo.persona pe      ON pe.id = cl.persona_id
INNER JOIN dbo.tipocliente tc  ON tc.id = cl.tipo_cliente_id
WHERE c.estado <> 'ACTIVA'
   OR c.fecha_vencimiento < CAST(GETDATE() AS DATE);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Credenciales de clientes inactivas, suspendidas o vencidas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_clientes_credenciales_inactivas';
GO
