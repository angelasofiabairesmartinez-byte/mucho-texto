CREATE TABLE dbo.estante (
    id INT IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    sucursal_id INT NOT NULL,
    CONSTRAINT PK_estante PRIMARY KEY (id),
    CONSTRAINT UQ_estante_codigo_sucursal_id UNIQUE (codigo, sucursal_id),
    CONSTRAINT fk_estante_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id)
);

GO

CREATE INDEX IX_estante_sucursal_id ON dbo.estante (sucursal_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Organiza los estantes ubicados dentro de una sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código interno para identificar el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la sucursal relacionada con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'sucursal_id';
GO
