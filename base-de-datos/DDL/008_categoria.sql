CREATE TABLE dbo.categoria (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(200) NULL,
    CONSTRAINT PK_categoria PRIMARY KEY (id),
    CONSTRAINT UQ_categoria_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clasifica los libros por tema o área.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'descripcion';
GO
