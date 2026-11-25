CREATE TABLE dbo.recursodigital (
    id INT IDENTITY(1,1) NOT NULL,
    libro_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    ruta_archivo NVARCHAR(300) NOT NULL,
    total_paginas INT NULL,
    duracion_segundos INT NULL,
    generado_ia SMALLINT NOT NULL CONSTRAINT DF_recursodigital_generado_ia DEFAULT 0,
    voz_narracion NVARCHAR(60) NULL,
    fecha_publicacion DATETIME2(0) NOT NULL CONSTRAINT DF_recursodigital_fecha_publicacion DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_recursodigital_estado DEFAULT 1,
    CONSTRAINT PK_recursodigital PRIMARY KEY (id),
    CONSTRAINT UQ_recursodigital_libro_id_tipo UNIQUE (libro_id, tipo),
    CONSTRAINT CK_recursodigital_tipo CHECK (tipo IN (N'T', N'A')),
    CONSTRAINT CK_recursodigital_generado_ia CHECK (generado_ia IN (0, 1)),
    CONSTRAINT CK_recursodigital_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_recursodigital_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los archivos digitales de un libro: texto para el lector y audio para el audiolibro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del recurso digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro al que pertenece el recurso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'T: Texto (lector digital); A: Audio (audiolibro)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ruta o URL del archivo digital (EPUB, PDF o MP3).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'ruta_archivo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Total de páginas del recurso de texto; NULL en audio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'total_paginas';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Duración total del audiolibro en segundos; NULL en texto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'duracion_segundos';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Audio generado con inteligencia artificial a partir del texto; 0: Narración humana o archivo original', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'generado_ia';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la voz o del narrador del audiolibro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'voz_narracion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que el recurso se publicó en la biblioteca digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'fecha_publicacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Disponible; 0: Retirado', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'estado';
GO
