CREATE TABLE dbo.formapago (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_formapago PRIMARY KEY (id),
    CONSTRAINT UQ_formapago_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define las formas de pago aceptadas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago', @level2type = N'COLUMN', @level2name = N'nombre';
GO
