CREATE TABLE dbo.libro (
    id INT IDENTITY(1,1) NOT NULL,
    titulo NVARCHAR(180) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    edicion_id INT NOT NULL,
    precio_venta DECIMAL(10,2) NULL,
    permite_digital SMALLINT NOT NULL CONSTRAINT DF_libro_permite_digital DEFAULT 0,
    ruta_portada NVARCHAR(300) NULL,
    CONSTRAINT PK_libro PRIMARY KEY (id),
    CONSTRAINT CK_libro_precio_venta CHECK (precio_venta IS NULL OR precio_venta >= 0),
    CONSTRAINT CK_libro_permite_digital CHECK (permite_digital IN (0, 1)),
    CONSTRAINT fk_libro_edicion FOREIGN KEY (edicion_id) REFERENCES dbo.edicion (id)
);

GO

CREATE INDEX IX_libro_edicion_id ON dbo.libro (edicion_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene la información bibliográfica general de cada título.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Título con el que se identifica el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'titulo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la edición a la que pertenece el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'edicion_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Precio de venta al público vigente del libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'precio_venta';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Tiene derechos para lectura digital y audiolibro; 0: Solo formato físico', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'permite_digital';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ruta o URL de la imagen de portada que se muestra en el catálogo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'ruta_portada';
GO
