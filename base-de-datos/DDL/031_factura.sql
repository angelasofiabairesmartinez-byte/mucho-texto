CREATE TABLE dbo.factura (
    id INT IDENTITY(1,1) NOT NULL,
    fecha DATETIME2(0) NOT NULL,
    cliente_id INT NULL,
    empleado_id INT NOT NULL,
    canal NVARCHAR(1) NOT NULL CONSTRAINT DF_factura_canal DEFAULT N'T',
    CONSTRAINT PK_factura PRIMARY KEY (id),
    CONSTRAINT CK_factura_canal CHECK (canal IN (N'T', N'L')),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_factura_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_factura_cliente_id ON dbo.factura (cliente_id);
CREATE INDEX IX_factura_empleado_id ON dbo.factura (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las ventas facturadas a clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se emitió la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'fecha';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'T: Tienda; L: En línea', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'canal';
GO
