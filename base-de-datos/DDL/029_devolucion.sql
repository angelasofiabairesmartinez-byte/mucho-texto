CREATE TABLE dbo.devolucion (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_devolucion DATETIME2(0) NOT NULL,
    observacion NVARCHAR(200) NULL,
    empleado_id INT NOT NULL,
    CONSTRAINT PK_devolucion PRIMARY KEY (id),
    CONSTRAINT fk_devolucion_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_devolucion_empleado_id ON dbo.devolucion (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra la devolución de ejemplares prestados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró la devolución.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'fecha_devolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'observacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO
