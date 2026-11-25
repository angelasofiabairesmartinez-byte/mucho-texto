CREATE TABLE dbo.compraproveedor (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_compra DATE NOT NULL,
    numero_factura NVARCHAR(40) NULL,
    proveedor_id INT NOT NULL,
    empleado_id INT NOT NULL,
    CONSTRAINT PK_compraproveedor PRIMARY KEY (id),
    CONSTRAINT fk_compra_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES dbo.proveedor (id)
);

GO

CREATE INDEX IX_compraproveedor_proveedor_id ON dbo.compraproveedor (proveedor_id);
CREATE INDEX IX_compraproveedor_empleado_id ON dbo.compraproveedor (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las compras realizadas a proveedores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se realizó la compra al proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'fecha_compra';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número de factura emitida por el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'numero_factura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del proveedor relacionado con la compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'proveedor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO
