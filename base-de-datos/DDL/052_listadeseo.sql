CREATE TABLE dbo.listadeseo (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    libro_id INT NOT NULL,
    fecha_agregado DATETIME2(0) NOT NULL CONSTRAINT DF_listadeseo_fecha_agregado DEFAULT GETDATE(),
    notificar_descuento SMALLINT NOT NULL CONSTRAINT DF_listadeseo_notificar_descuento DEFAULT 1,
    CONSTRAINT PK_listadeseo PRIMARY KEY (id),
    CONSTRAINT UQ_listadeseo_cliente_id_libro_id UNIQUE (cliente_id, libro_id),
    CONSTRAINT CK_listadeseo_notificar_descuento CHECK (notificar_descuento IN (0, 1)),
    CONSTRAINT fk_listadeseo_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_listadeseo_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_listadeseo_libro_id ON dbo.listadeseo (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los libros que cada cliente guarda en su lista de deseos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente dueño de la lista.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro guardado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se agregó el libro a la lista.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo', @level2type = N'COLUMN', @level2name = N'fecha_agregado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Avisar al cliente cuando el libro tenga descuento; 0: No avisar', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'listadeseo', @level2type = N'COLUMN', @level2name = N'notificar_descuento';
GO
