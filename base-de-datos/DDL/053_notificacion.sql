CREATE TABLE dbo.notificacion (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    titulo NVARCHAR(100) NOT NULL,
    mensaje NVARCHAR(300) NOT NULL,
    referencia_id INT NULL,
    fecha_envio DATETIME2(0) NOT NULL CONSTRAINT DF_notificacion_fecha_envio DEFAULT GETDATE(),
    leida SMALLINT NOT NULL CONSTRAINT DF_notificacion_leida DEFAULT 0,
    fecha_lectura DATETIME2(0) NULL,
    CONSTRAINT PK_notificacion PRIMARY KEY (id),
    CONSTRAINT CK_notificacion_tipo CHECK (tipo IN (N'V', N'R', N'M', N'D', N'G')),
    CONSTRAINT CK_notificacion_leida CHECK (leida IN (0, 1)),
    CONSTRAINT fk_notificacion_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id)
);

GO

CREATE INDEX IX_notificacion_cliente_id ON dbo.notificacion (cliente_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los avisos enviados a los clientes en la app.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente que recibe la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'V: Vencimiento de préstamo; R: Reserva disponible; M: Multa; D: Descuento en lista de deseos; G: General', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Título corto de la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'titulo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Texto completo de la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'mensaje';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del préstamo, reserva, multa o libro al que se refiere la notificación, según el tipo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'referencia_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se envió la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'fecha_envio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Leída; 0: No leída', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'leida';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que el cliente abrió la notificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notificacion', @level2type = N'COLUMN', @level2name = N'fecha_lectura';
GO
