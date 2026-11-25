CREATE TABLE dbo.cliente (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_registro DATE NOT NULL,
    persona_id INT NOT NULL,
    tipo_cliente_id INT NOT NULL,
    CONSTRAINT PK_cliente PRIMARY KEY (id),
    CONSTRAINT UQ_cliente_persona_id UNIQUE (persona_id),
    CONSTRAINT fk_cliente_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id),
    CONSTRAINT fk_cliente_tipo FOREIGN KEY (tipo_cliente_id) REFERENCES dbo.tipocliente (id)
);

GO

CREATE INDEX IX_cliente_tipo_cliente_id ON dbo.cliente (tipo_cliente_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra a las personas inscritas como clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cliente';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cliente', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la información.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cliente', @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cliente', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la categoría asignada al cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cliente', @level2type = N'COLUMN', @level2name = N'tipo_cliente_id';
GO
