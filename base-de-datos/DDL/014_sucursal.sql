CREATE TABLE dbo.sucursal (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    direccion NVARCHAR(180) NOT NULL,
    telefono NVARCHAR(25) NULL,
    CONSTRAINT PK_sucursal PRIMARY KEY (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las sucursales de la biblioteca-librería.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección física o ubicación de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'direccion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'telefono';
GO
