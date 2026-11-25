CREATE TABLE dbo.formatolibro (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_formatolibro PRIMARY KEY (id),
    CONSTRAINT UQ_formatolibro_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los formatos disponibles de publicación de los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro', @level2type = N'COLUMN', @level2name = N'nombre';
GO
