CREATE TABLE dbo.historialcliente (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    empleado_id INT NULL,
    fecha_cambio DATETIME2(0) NOT NULL CONSTRAINT DF_historialcliente_fecha_cambio DEFAULT GETDATE(),
    tipo_cambio NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(250) NOT NULL,
    CONSTRAINT PK_historialcliente PRIMARY KEY (id),
    CONSTRAINT fk_historialcliente_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_historialcliente_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_historialcliente_cliente_id ON dbo.historialcliente (cliente_id);
CREATE INDEX IX_historialcliente_empleado_id ON dbo.historialcliente (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva un registro de cambios relevantes relacionados con los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'fecha_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de cambio realizado en los datos del cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'tipo_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'descripcion';
GO
