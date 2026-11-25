CREATE TABLE dbo.libroautor (
    libro_id INT NOT NULL,
    autor_id INT NOT NULL,
    orden_autoria SMALLINT NULL,
    CONSTRAINT PK_libroautor PRIMARY KEY (libro_id, autor_id),
    CONSTRAINT fk_libroautor_autor FOREIGN KEY (autor_id) REFERENCES dbo.autor (id),
    CONSTRAINT fk_libroautor_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_libroautor_autor_id ON dbo.libroautor (autor_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona los libros con sus autores y conserva el orden de autoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro que se vincula con el autor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del autor vinculado con el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'autor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Posición del autor en la lista de autores del libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'orden_autoria';
GO
