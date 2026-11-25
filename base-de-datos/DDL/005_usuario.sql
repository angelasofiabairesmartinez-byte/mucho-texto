CREATE TABLE dbo.usuario (
    id INT IDENTITY(1,1) NOT NULL,
    nombre_usuario NVARCHAR(50) NOT NULL,
    contrasena_hash NVARCHAR(255) NOT NULL,
    persona_id INT NOT NULL,
    rol_id INT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL CONSTRAINT DF_usuario_fecha_creacion DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_usuario_estado DEFAULT 1,
    CONSTRAINT PK_usuario PRIMARY KEY (id),
    CONSTRAINT UQ_usuario_nombre_usuario UNIQUE (nombre_usuario),
    CONSTRAINT UQ_usuario_persona_id UNIQUE (persona_id),
    CONSTRAINT CK_usuario_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_usuario_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES dbo.rol (id)
);

GO

CREATE INDEX IX_usuario_rol_id ON dbo.usuario (rol_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las cuentas de acceso de empleados y clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre utilizado para iniciar sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'nombre_usuario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Hash de la contraseña de acceso; no debe almacenarse la contraseña en texto plano.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'contrasena_hash';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona (empleado o cliente) propietaria de la cuenta de usuario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del rol asignado al usuario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'rol_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se creó el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'fecha_creacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'estado';
GO
