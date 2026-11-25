CREATE TABLE dbo.pagomulta (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_pago DATETIME2(0) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    multa_id INT NOT NULL,
    forma_pago_id INT NOT NULL,
    CONSTRAINT PK_pagomulta PRIMARY KEY (id),
    CONSTRAINT fk_pagomulta_forma FOREIGN KEY (forma_pago_id) REFERENCES dbo.formapago (id),
    CONSTRAINT fk_pagomulta_multa FOREIGN KEY (multa_id) REFERENCES dbo.multa (id)
);

GO

CREATE INDEX IX_pagomulta_multa_id ON dbo.pagomulta (multa_id);
CREATE INDEX IX_pagomulta_forma_pago_id ON dbo.pagomulta (forma_pago_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los pagos realizados para cancelar multas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'fecha_pago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la multa a la que corresponde el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'multa_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la forma de pago utilizada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'forma_pago_id';
GO
