CREATE TABLE dbo.idioma (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_idioma PRIMARY KEY (id),
    CONSTRAINT UQ_idioma_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene los idiomas en los que se publican los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma', @level2type = N'COLUMN', @level2name = N'nombre';
GO
