CREATE TABLE dbo.movimientoinventario (
    id INT IDENTITY(1,1) NOT NULL,
    sucursal_id INT NOT NULL,
    ejemplar_id INT NULL,
    empleado_id INT NOT NULL,
    tipo_movimiento NVARCHAR(30) NOT NULL,
    fecha_movimiento DATETIME2(0) NOT NULL CONSTRAINT DF_movimientoinventario_fecha_movimiento DEFAULT GETDATE(),
    cantidad INT NOT NULL,
    observacion NVARCHAR(250) NULL,
    CONSTRAINT PK_movimientoinventario PRIMARY KEY (id),
    CONSTRAINT fk_movinventario_ejemplar FOREIGN KEY (ejemplar_id) REFERENCES dbo.ejemplar (id),
    CONSTRAINT fk_movinventario_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_movinventario_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id)
);

GO

CREATE INDEX IX_movimientoinventario_sucursal_id ON dbo.movimientoinventario (sucursal_id);
CREATE INDEX IX_movimientoinventario_ejemplar_id ON dbo.movimientoinventario (ejemplar_id);
CREATE INDEX IX_movimientoinventario_empleado_id ON dbo.movimientoinventario (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra entradas, salidas y ajustes de inventario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del movimiento de inventario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la sucursal donde ocurre el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'sucursal_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del ejemplar físico relacionado con el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'ejemplar_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado que registra el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de movimiento realizado en el inventario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'tipo_movimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registra el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'fecha_movimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de ejemplares involucrados en el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'cantidad';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Observaciones adicionales sobre el movimiento.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'movimientoinventario', @level2type = N'COLUMN', @level2name = N'observacion';
GO
