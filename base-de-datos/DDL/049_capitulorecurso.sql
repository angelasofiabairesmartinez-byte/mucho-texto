CREATE TABLE dbo.capitulorecurso (
    id INT IDENTITY(1,1) NOT NULL,
    recurso_digital_id INT NOT NULL,
    numero SMALLINT NOT NULL,
    titulo NVARCHAR(150) NOT NULL,
    posicion_inicio INT NOT NULL,
    CONSTRAINT PK_capitulorecurso PRIMARY KEY (id),
    CONSTRAINT UQ_capitulorecurso_recurso_digital_id_numero UNIQUE (recurso_digital_id, numero),
    CONSTRAINT CK_capitulorecurso_posicion_inicio CHECK (posicion_inicio >= 0),
    CONSTRAINT fk_capitulorecurso_recurso FOREIGN KEY (recurso_digital_id) REFERENCES dbo.recursodigital (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Índice de capítulos de un recurso digital para navegar en el lector o en el reproductor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del recurso digital al que pertenece el capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'recurso_digital_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número de orden del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'numero';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Título del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'titulo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Página (texto) o segundo (audio) donde inicia el capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'posicion_inicio';
GO
