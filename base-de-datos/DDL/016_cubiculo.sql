CREATE TABLE dbo.cubiculo (
    id INT IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    estante_id INT NOT NULL,
    CONSTRAINT PK_cubiculo PRIMARY KEY (id),
    CONSTRAINT UQ_cubiculo_codigo_estante_id UNIQUE (codigo, estante_id),
    CONSTRAINT fk_cubiculo_estante FOREIGN KEY (estante_id) REFERENCES dbo.estante (id)
);

GO

CREATE INDEX IX_cubiculo_estante_id ON dbo.cubiculo (estante_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identifica los cubículos o espacios de ubicación dentro de un estante.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código interno para identificar el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del estante al que pertenece el cubículo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'estante_id';
GO
