CREATE OR ALTER VIEW dbo.vw_empleados_credenciales
AS
SELECT
    e.id                                    AS empleado_id,
    e.codigo_empleado,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS empleado,
    pe.correo,
    cg.nombre                               AS cargo,
    u.id                                    AS usuario_id,
    u.nombre_usuario,
    r.nombre                                AS rol,
    CASE WHEN u.id IS NULL THEN N'SIN CUENTA'
         WHEN u.estado = 1 THEN N'ACTIVA'
         ELSE N'INACTIVA' END               AS estado_cuenta,
    u.fecha_creacion                        AS fecha_creacion_cuenta,
    ISNULL(cr.activas, 0)                   AS credenciales_emitidas_activas,
    ISNULL(cr.inactivas, 0)                 AS credenciales_emitidas_inactivas
FROM dbo.empleado e
INNER JOIN dbo.persona pe   ON pe.id = e.persona_id
INNER JOIN dbo.cargo cg     ON cg.id = e.cargo_id
LEFT JOIN dbo.usuario u     ON u.persona_id = e.persona_id
LEFT JOIN dbo.rol r         ON r.id = u.rol_id
LEFT JOIN (
    SELECT c.empleado_id,
           SUM(CASE WHEN c.estado = 'ACTIVA'
                     AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
                    THEN 1 ELSE 0 END) AS activas,
           SUM(CASE WHEN c.estado = 'ACTIVA'
                     AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
                    THEN 0 ELSE 1 END) AS inactivas
    FROM dbo.credencial c
    WHERE c.empleado_id IS NOT NULL
    GROUP BY c.empleado_id
) cr ON cr.empleado_id = e.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Empleados con su cuenta de acceso y las credenciales de clientes que emitieron.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_empleados_credenciales';
GO
