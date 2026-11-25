CREATE TABLE dbo.cargo (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(150) NULL,
    CONSTRAINT PK_cargo PRIMARY KEY (id),
    CONSTRAINT UQ_cargo_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene los cargos que pueden ocupar los empleados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'descripcion';
GO
