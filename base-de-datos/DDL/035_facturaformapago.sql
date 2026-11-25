CREATE TABLE dbo.facturaformapago (
    factura_id INT NOT NULL,
    forma_pago_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    referencia NVARCHAR(80) NULL,
    CONSTRAINT PK_facturaformapago PRIMARY KEY (factura_id, forma_pago_id),
    CONSTRAINT fk_facturaformapago_factura FOREIGN KEY (factura_id) REFERENCES dbo.factura (id),
    CONSTRAINT fk_facturaformapago_forma FOREIGN KEY (forma_pago_id) REFERENCES dbo.formapago (id)
);

GO

CREATE INDEX IX_facturaformapago_forma_pago_id ON dbo.facturaformapago (forma_pago_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona las facturas con sus formas de pago y montos abonados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la factura en la que se registra el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'factura_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la forma de pago usada en la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'forma_pago_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número o dato de referencia del pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'referencia';
GO
