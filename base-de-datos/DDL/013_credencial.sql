CREATE TABLE dbo.credencial (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_registro DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    estado NVARCHAR(20) NOT NULL CONSTRAINT DF_credencial_estado DEFAULT N'ACTIVA',
    cliente_id INT NOT NULL,
    empleado_id INT NULL,
    CONSTRAINT PK_credencial PRIMARY KEY (id),
    CONSTRAINT CK_credencial_estado CHECK (estado IN (N'ACTIVA', N'VENCIDA', N'SUSPENDIDA')),
    CONSTRAINT fk_credencial_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_credencial_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_credencial_cliente_id ON dbo.credencial (cliente_id);
CREATE INDEX IX_credencial_empleado_id ON dbo.credencial (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Controla las credenciales asignadas a los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la información.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite o de vencimiento del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la credencial: ACTIVA, VENCIDA o SUSPENDIDA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO
