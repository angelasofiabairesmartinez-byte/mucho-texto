CREATE TABLE dbo.autor (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_registro DATE NULL,
    persona_id INT NOT NULL,
    CONSTRAINT PK_autor PRIMARY KEY (id),
    CONSTRAINT UQ_autor_persona_id UNIQUE (persona_id),
    CONSTRAINT fk_autor_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra a las personas que figuran como autores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la información.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'persona_id';
GO
