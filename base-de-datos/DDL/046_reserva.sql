CREATE TABLE dbo.reserva (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    libro_id INT NOT NULL,
    fecha_reserva DATETIME2(0) NOT NULL CONSTRAINT DF_reserva_fecha_reserva DEFAULT GETDATE(),
    fecha_vencimiento DATETIME2(0) NULL,
    estado NVARCHAR(30) NOT NULL CONSTRAINT DF_reserva_estado DEFAULT N'PENDIENTE',
    fecha_atencion DATETIME2(0) NULL,
    tipo NVARCHAR(1) NOT NULL CONSTRAINT DF_reserva_tipo DEFAULT N'R',
    sucursal_id INT NULL,
    ejemplar_id INT NULL,
    prestamo_id INT NULL,
    CONSTRAINT PK_reserva PRIMARY KEY (id),
    CONSTRAINT CK_reserva_estado CHECK (estado IN (N'PENDIENTE', N'ATENDIDA', N'VENCIDA', N'CANCELADA')),
    CONSTRAINT CK_reserva_tipo CHECK (tipo IN (N'R', N'S')),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_reserva_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id),
    CONSTRAINT fk_reserva_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id),
    CONSTRAINT fk_reserva_ejemplar FOREIGN KEY (ejemplar_id) REFERENCES dbo.ejemplar (id),
    CONSTRAINT fk_reserva_prestamo FOREIGN KEY (prestamo_id) REFERENCES dbo.prestamo (id)
);

GO

CREATE INDEX IX_reserva_cliente_id ON dbo.reserva (cliente_id);
CREATE INDEX IX_reserva_libro_id ON dbo.reserva (libro_id);
CREATE INDEX IX_reserva_ejemplar_id ON dbo.reserva (ejemplar_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las reservas de libros y las solicitudes de préstamo hechas por los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se realizó la reserva.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'fecha_reserva';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite o de vencimiento del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la reserva: PENDIENTE, ATENDIDA, VENCIDA o CANCELADA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se atendió la reserva.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'fecha_atencion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'R: Reserva; S: Solicitud de préstamo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Sucursal donde el cliente retirará el libro (solicitudes de préstamo).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'sucursal_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ejemplar apartado para el cliente mientras la solicitud está pendiente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'ejemplar_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Préstamo generado cuando la reserva o solicitud fue atendida.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'reserva', @level2type = N'COLUMN', @level2name = N'prestamo_id';
GO
