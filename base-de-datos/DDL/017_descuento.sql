CREATE TABLE dbo.descuento (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(250) NULL,
    tipo_descuento NVARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado SMALLINT NOT NULL CONSTRAINT DF_descuento_estado DEFAULT 1,
    CONSTRAINT PK_descuento PRIMARY KEY (id),
    CONSTRAINT CK_descuento_estado CHECK (estado IN (0, 1)),
    CONSTRAINT CK_descuento_valor CHECK (valor >= 0),
    CONSTRAINT CK_descuento_tipo_descuento CHECK (tipo_descuento IN (N'PORCENTAJE', N'MONTO_FIJO'))
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los descuentos que pueden aplicarse en la facturación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Forma de cálculo del descuento: PORCENTAJE o MONTO_FIJO.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'tipo_descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del descuento, según el tipo configurado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'valor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha desde la que comienza la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'fecha_inicio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha hasta la que se mantiene la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'fecha_fin';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'estado';
GO
