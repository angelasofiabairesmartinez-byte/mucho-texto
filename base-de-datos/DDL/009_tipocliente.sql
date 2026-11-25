CREATE TABLE dbo.tipocliente (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    descripcion NVARCHAR(150) NULL,
    limite_prestamos SMALLINT NOT NULL CONSTRAINT DF_tipocliente_limite_prestamos DEFAULT 3,
    limite_renovaciones SMALLINT NOT NULL CONSTRAINT DF_tipocliente_limite_renovaciones DEFAULT 1,
    CONSTRAINT PK_tipocliente PRIMARY KEY (id),
    CONSTRAINT UQ_tipocliente_nombre UNIQUE (nombre),
    CONSTRAINT CK_tipocliente_limite_prestamos CHECK (limite_prestamos BETWEEN 0 AND 20),
    CONSTRAINT CK_tipocliente_limite_renovaciones CHECK (limite_renovaciones BETWEEN 0 AND 5)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define las categorías de clientes de la biblioteca o librería.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad máxima de ejemplares que el cliente puede tener prestados al mismo tiempo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'limite_prestamos';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad máxima de veces que el cliente puede renovar un mismo préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'limite_renovaciones';
GO
