CREATE TABLE dbo.ejemplar (
    id INT IDENTITY(1,1) NOT NULL,
    codigo_barras NVARCHAR(40) NOT NULL,
    fecha_adquisicion DATE NULL,
    precio_adquisicion DECIMAL(10,2) NULL,
    libro_id INT NOT NULL,
    cubiculo_id INT NULL,
    estado_ejemplar_id INT NOT NULL,
    CONSTRAINT PK_ejemplar PRIMARY KEY (id),
    CONSTRAINT UQ_ejemplar_codigo_barras UNIQUE (codigo_barras),
    CONSTRAINT fk_ejemplar_cubiculo FOREIGN KEY (cubiculo_id) REFERENCES dbo.cubiculo (id),
    CONSTRAINT fk_ejemplar_estado FOREIGN KEY (estado_ejemplar_id) REFERENCES dbo.estadoejemplar (id),
    CONSTRAINT fk_ejemplar_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_ejemplar_libro_id ON dbo.ejemplar (libro_id);
CREATE INDEX IX_ejemplar_cubiculo_id ON dbo.ejemplar (cubiculo_id);
CREATE INDEX IX_ejemplar_estado_ejemplar_id ON dbo.ejemplar (estado_ejemplar_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra cada copia física de un libro y su ubicación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código de barras único del ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'codigo_barras';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se adquirió el ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'fecha_adquisicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Costo de adquisición del ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'precio_adquisicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cubículo donde se ubica el ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'cubiculo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del estado actual del ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'estado_ejemplar_id';
GO
