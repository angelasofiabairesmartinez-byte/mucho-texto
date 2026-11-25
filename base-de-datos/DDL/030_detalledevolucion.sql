CREATE TABLE dbo.detalledevolucion (
    id INT IDENTITY(1,1) NOT NULL,
    devolucion_id INT NOT NULL,
    detalle_prestamo_id INT NOT NULL,
    condicion_entrega NVARCHAR(40) NOT NULL,
    observacion NVARCHAR(200) NULL,
    CONSTRAINT PK_detalledevolucion PRIMARY KEY (id),
    CONSTRAINT UQ_detalledevolucion_detalle_prestamo_id UNIQUE (detalle_prestamo_id),
    CONSTRAINT fk_detalledevolucion_detalleprestamo FOREIGN KEY (detalle_prestamo_id) REFERENCES dbo.detalleprestamo (id),
    CONSTRAINT fk_detalledevolucion_devolucion FOREIGN KEY (devolucion_id) REFERENCES dbo.devolucion (id)
);

GO

CREATE INDEX IX_detalledevolucion_devolucion_id ON dbo.detalledevolucion (devolucion_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Detalla los ejemplares devueltos y su condición de entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del detalle de devolución.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de devolucion relacionado con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'devolucion_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del detalle de préstamo relacionado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'detalle_prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Condición en que se recibió el ejemplar devuelto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'condicion_entrega';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'observacion';
GO
