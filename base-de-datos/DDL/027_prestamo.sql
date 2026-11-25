CREATE TABLE dbo.prestamo (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    observacion NVARCHAR(200) NULL,
    cliente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    estado_prestamo_id INT NOT NULL,
    numero_renovaciones SMALLINT NOT NULL CONSTRAINT DF_prestamo_numero_renovaciones DEFAULT 0,
    CONSTRAINT PK_prestamo PRIMARY KEY (id),
    CONSTRAINT fk_prestamo_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_prestamo_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_prestamo_estado FOREIGN KEY (estado_prestamo_id) REFERENCES dbo.estadoprestamo (id)
);

GO

CREATE INDEX IX_prestamo_cliente_id ON dbo.prestamo (cliente_id);
CREATE INDEX IX_prestamo_empleado_id ON dbo.prestamo (empleado_id);
CREATE INDEX IX_prestamo_estado_prestamo_id ON dbo.prestamo (estado_prestamo_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los préstamos realizados a los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se realizó el préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'fecha_prestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite o de vencimiento del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'observacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del estado actual del préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'estado_prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de veces que se ha renovado el préstamo; no puede superar el límite del tipo de cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'prestamo', @level2type = N'COLUMN', @level2name = N'numero_renovaciones';
GO
