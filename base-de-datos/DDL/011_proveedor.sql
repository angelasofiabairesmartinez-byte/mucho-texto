CREATE TABLE dbo.proveedor (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(25) NULL,
    correo NVARCHAR(120) NULL,
    direccion NVARCHAR(180) NULL,
    CONSTRAINT PK_proveedor PRIMARY KEY (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los proveedores a los que se compran libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'telefono';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección de correo electrónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'correo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección física o ubicación de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'direccion';
GO
