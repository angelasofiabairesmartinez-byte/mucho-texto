CREATE TABLE dbo.detallecompra (
    id INT IDENTITY(1,1) NOT NULL,
    compra_proveedor_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_detallecompra PRIMARY KEY (id),
    CONSTRAINT CK_detallecompra_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_detallecompra_compra FOREIGN KEY (compra_proveedor_id) REFERENCES dbo.compraproveedor (id),
    CONSTRAINT fk_detallecompra_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_detallecompra_compra_proveedor_id ON dbo.detallecompra (compra_proveedor_id);
CREATE INDEX IX_detallecompra_libro_id ON dbo.detallecompra (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Detalla los libros y cantidades incluidos en cada compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la línea de detalle de la compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la compra al proveedor a la que pertenece el detalle.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'compra_proveedor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad registrada para la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'cantidad';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Costo de adquisición por unidad comprada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'costo_unitario';
GO
