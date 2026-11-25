CREATE TABLE dbo.edicion (
    id INT IDENTITY(1,1) NOT NULL,
    numero_edicion NVARCHAR(30) NULL,
    anio_publicacion NUMERIC(4,0) NULL,
    isbn NVARCHAR(20) NULL,
    editorial_id INT NOT NULL,
    idioma_id INT NOT NULL,
    formato_libro_id INT NOT NULL,
    CONSTRAINT PK_edicion PRIMARY KEY (id),
    CONSTRAINT UQ_edicion_isbn UNIQUE (isbn),
    CONSTRAINT fk_edicion_editorial FOREIGN KEY (editorial_id) REFERENCES dbo.editorial (id),
    CONSTRAINT fk_edicion_formato FOREIGN KEY (formato_libro_id) REFERENCES dbo.formatolibro (id),
    CONSTRAINT fk_edicion_idioma FOREIGN KEY (idioma_id) REFERENCES dbo.idioma (id)
);

GO

CREATE INDEX IX_edicion_editorial_id ON dbo.edicion (editorial_id);
CREATE INDEX IX_edicion_idioma_id ON dbo.edicion (idioma_id);
CREATE INDEX IX_edicion_formato_libro_id ON dbo.edicion (formato_libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los datos editoriales de cada edición de un libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número o denominación de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'numero_edicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Año en que se publicó la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'anio_publicacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número ISBN que identifica la edición publicada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'isbn';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la editorial de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'editorial_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del idioma de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'idioma_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del formato de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'formato_libro_id';
GO
