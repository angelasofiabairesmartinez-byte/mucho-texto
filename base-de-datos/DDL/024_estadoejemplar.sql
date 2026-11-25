CREATE TABLE dbo.estadoejemplar (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(30) NOT NULL,
    descripcion NVARCHAR(120) NULL,
    CONSTRAINT PK_estadoejemplar PRIMARY KEY (id),
    CONSTRAINT UQ_estadoejemplar_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los estados en que puede encontrarse un ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'descripcion';
GO
