CREATE TABLE dbo.historialprestamo (
    id INT IDENTITY(1,1) NOT NULL,
    prestamo_id INT NOT NULL,
    empleado_id INT NULL,
    fecha_cambio DATETIME2(0) NOT NULL CONSTRAINT DF_historialprestamo_fecha_cambio DEFAULT GETDATE(),
    estado_anterior NVARCHAR(30) NULL,
    estado_nuevo NVARCHAR(30) NOT NULL,
    observacion NVARCHAR(250) NULL,
    CONSTRAINT PK_historialprestamo PRIMARY KEY (id),
    CONSTRAINT fk_historialprestamo_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_historialprestamo_prestamo FOREIGN KEY (prestamo_id) REFERENCES dbo.prestamo (id)
);

GO

CREATE INDEX IX_historialprestamo_prestamo_id ON dbo.historialprestamo (prestamo_id);
CREATE INDEX IX_historialprestamo_empleado_id ON dbo.historialprestamo (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva los cambios de estado que ocurren durante un préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del préstamo relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'fecha_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado que tenía el préstamo antes del cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'estado_anterior';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado asignado al préstamo después del cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'estado_nuevo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'observacion';
GO
