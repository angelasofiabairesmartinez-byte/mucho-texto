CREATE TABLE dbo.auditoria (
    id INT IDENTITY(1,1) NOT NULL,
    usuario_id INT NULL,
    fecha_hora DATETIME2(0) NOT NULL CONSTRAINT DF_auditoria_fecha_hora DEFAULT GETDATE(),
    accion NVARCHAR(50) NOT NULL,
    tabla_afectada NVARCHAR(100) NOT NULL,
    registro_id NVARCHAR(100) NULL,
    detalle NVARCHAR(500) NULL,
    CONSTRAINT PK_auditoria PRIMARY KEY (id),
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario (id)
);

GO

CREATE INDEX IX_auditoria_usuario_id ON dbo.auditoria (usuario_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva el registro de acciones importantes realizadas en el sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro de auditoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de usuario relacionado con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'usuario_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que ocurrió la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'fecha_hora';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de acción realizada en el sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'accion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la tabla en la que se realizó la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'tabla_afectada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del registro afectado por la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'registro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Información complementaria sobre la acción o el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'detalle';
GO
