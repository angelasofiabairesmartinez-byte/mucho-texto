CREATE TABLE dbo.multa (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_generacion DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    motivo NVARCHAR(180) NOT NULL,
    estado NVARCHAR(20) NOT NULL CONSTRAINT DF_multa_estado DEFAULT N'PENDIENTE',
    detalle_prestamo_id INT NOT NULL,
    CONSTRAINT PK_multa PRIMARY KEY (id),
    CONSTRAINT CK_multa_estado CHECK (estado IN (N'PENDIENTE', N'PAGADA')),
    CONSTRAINT CK_multa_monto CHECK (monto >= 0),
    CONSTRAINT fk_multa_detalleprestamo FOREIGN KEY (detalle_prestamo_id) REFERENCES dbo.detalleprestamo (id)
);

GO

CREATE INDEX IX_multa_detalle_prestamo_id ON dbo.multa (detalle_prestamo_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las multas generadas por incumplimientos de préstamos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se generó la multa.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'fecha_generacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Motivo por el que se generó la multa.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'motivo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la multa: PENDIENTE o PAGADA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del detalle de préstamo relacionado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'detalle_prestamo_id';
GO
