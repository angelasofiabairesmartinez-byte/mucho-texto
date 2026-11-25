CREATE TABLE dbo.notalectura (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    recurso_digital_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    posicion INT NOT NULL,
    texto_seleccionado NVARCHAR(500) NULL,
    nota NVARCHAR(500) NULL,
    color NVARCHAR(7) NULL,
    fecha_creacion DATETIME2(0) NOT NULL CONSTRAINT DF_notalectura_fecha_creacion DEFAULT GETDATE(),
    CONSTRAINT PK_notalectura PRIMARY KEY (id),
    CONSTRAINT CK_notalectura_tipo CHECK (tipo IN (N'S', N'N', N'M')),
    CONSTRAINT fk_notalectura_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_notalectura_recurso FOREIGN KEY (recurso_digital_id) REFERENCES dbo.recursodigital (id)
);

GO

CREATE INDEX IX_notalectura_cliente_id ON dbo.notalectura (cliente_id);
CREATE INDEX IX_notalectura_recurso_digital_id ON dbo.notalectura (recurso_digital_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los subrayados, notas y marcadores que el cliente crea en el lector digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente que creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del recurso digital donde se creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'recurso_digital_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'S: Subrayado; N: Nota; M: Marcador', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Página o segundo donde se ubica la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'posicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fragmento de texto subrayado, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'texto_seleccionado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Comentario escrito por el cliente, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'nota';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Color del subrayado en formato hexadecimal, por ejemplo #F5C542.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'color';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO
