CREATE TABLE dbo.librocategoria (
    libro_id INT NOT NULL,
    categoria_id INT NOT NULL,
    CONSTRAINT PK_librocategoria PRIMARY KEY (libro_id, categoria_id),
    CONSTRAINT fk_librocat_categoria FOREIGN KEY (categoria_id) REFERENCES dbo.categoria (id),
    CONSTRAINT fk_librocat_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_librocategoria_categoria_id ON dbo.librocategoria (categoria_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona cada libro con una o varias categorías.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro que se vincula con la categoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la categoría asignada al libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria', @level2type = N'COLUMN', @level2name = N'categoria_id';
GO
