CREATE TABLE dbo.telefono (
    id INT IDENTITY(1,1) NOT NULL,
    numero NVARCHAR(25) NOT NULL,
    persona_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    CONSTRAINT PK_telefono PRIMARY KEY (id),
    CONSTRAINT CK_telefono_tipo CHECK (tipo IN (N'P', N'L', N'F')),
    CONSTRAINT fk_telefono_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id)
);

GO

CREATE INDEX IX_telefono_persona_id ON dbo.telefono (persona_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los números telefónicos asociados a una persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico o número de referencia, según el contexto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'numero';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'P: Personal; L: Laboral; F: Fijo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'tipo';
GO
