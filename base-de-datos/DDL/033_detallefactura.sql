CREATE TABLE dbo.detallefactura (
    id INT IDENTITY(1,1) NOT NULL,
    factura_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL CONSTRAINT DF_detallefactura_descuento DEFAULT 0,
    descuento_id INT NULL,
    impuesto_id INT NULL,
    monto_impuesto DECIMAL(10,2) NOT NULL CONSTRAINT DF_detallefactura_monto_impuesto DEFAULT 0,
    CONSTRAINT PK_detallefactura PRIMARY KEY (id),
    CONSTRAINT CK_detallefactura_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_detallefactura_descuento FOREIGN KEY (descuento_id) REFERENCES dbo.descuento (id),
    CONSTRAINT fk_detallefactura_factura FOREIGN KEY (factura_id) REFERENCES dbo.factura (id),
    CONSTRAINT fk_detallefactura_impuesto FOREIGN KEY (impuesto_id) REFERENCES dbo.impuesto (id),
    CONSTRAINT fk_detallefactura_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_detallefactura_factura_id ON dbo.detallefactura (factura_id);
CREATE INDEX IX_detallefactura_libro_id ON dbo.detallefactura (libro_id);
CREATE INDEX IX_detallefactura_descuento_id ON dbo.detallefactura (descuento_id);
CREATE INDEX IX_detallefactura_impuesto_id ON dbo.detallefactura (impuesto_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los libros, cantidades y valores correspondientes a cada línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la línea de detalle de la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la factura a la que pertenece el detalle.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'factura_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad registrada para la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'cantidad';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Precio aplicado a una unidad del producto vendido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'precio_unitario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto de descuento aplicado a la línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del descuento aplicado a la línea de factura, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'descuento_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del impuesto aplicado a la línea de factura, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'impuesto_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto del impuesto calculado para esta línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'monto_impuesto';
GO
