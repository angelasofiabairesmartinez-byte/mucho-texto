CREATE TABLE dbo.impuesto (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado SMALLINT NOT NULL CONSTRAINT DF_impuesto_estado DEFAULT 1,
    CONSTRAINT PK_impuesto PRIMARY KEY (id),
    CONSTRAINT CK_impuesto_estado CHECK (estado IN (0, 1)),
    CONSTRAINT CK_impuesto_porcentaje CHECK (porcentaje BETWEEN 0 AND 100)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los impuestos vigentes que se aplican en la facturación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Porcentaje definido para el impuesto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'porcentaje';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha desde la que comienza la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'fecha_inicio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha hasta la que se mantiene la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'fecha_fin';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'estado';
GO
