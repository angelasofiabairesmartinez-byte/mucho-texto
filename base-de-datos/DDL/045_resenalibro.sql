CREATE TABLE dbo.resenalibro (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    libro_id INT NOT NULL,
    calificacion SMALLINT NOT NULL,
    comentario NVARCHAR(500) NULL,
    fecha_resena DATETIME2(0) NOT NULL CONSTRAINT DF_resenalibro_fecha_resena DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_resenalibro_estado DEFAULT 1,
    CONSTRAINT PK_resenalibro PRIMARY KEY (id),
    CONSTRAINT UQ_resenalibro_cliente_id_libro_id UNIQUE (cliente_id, libro_id),
    CONSTRAINT CK_resenalibro_calificacion CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT CK_resenalibro_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_resenalibro_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_resenalibro_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_resenalibro_libro_id ON dbo.resenalibro (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las calificaciones y opiniones de los clientes sobre los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'calificación asignada por el cliente al libro. Acepta valores enteros del 1 al 5, donde 1 es la menor valoración y 5 es la mayor valoración.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'calificacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Opinión escrita por el cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'comentario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la reseña.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'fecha_resena';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Visible; 0: Oculta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'estado';
GO
