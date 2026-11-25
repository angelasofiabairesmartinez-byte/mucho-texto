CREATE TABLE dbo.detalleprestamo (
    id INT IDENTITY(1,1) NOT NULL,
    prestamo_id INT NOT NULL,
    ejemplar_id INT NOT NULL,
    CONSTRAINT PK_detalleprestamo PRIMARY KEY (id),
    CONSTRAINT UQ_detalleprestamo_prestamo_id_ejemplar_id UNIQUE (prestamo_id, ejemplar_id),
    CONSTRAINT fk_detalleprestamo_ejemplar FOREIGN KEY (ejemplar_id) REFERENCES dbo.ejemplar (id),
    CONSTRAINT fk_detalleprestamo_prestamo FOREIGN KEY (prestamo_id) REFERENCES dbo.prestamo (id)
);

GO

CREATE INDEX IX_detalleprestamo_ejemplar_id ON dbo.detalleprestamo (ejemplar_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identifica los ejemplares incluidos en cada préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del detalle del préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del préstamo relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del ejemplar físico relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'ejemplar_id';
GO
