CREATE TABLE dbo.progresolectura (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    recurso_digital_id INT NOT NULL,
    posicion_actual INT NOT NULL CONSTRAINT DF_progresolectura_posicion_actual DEFAULT 0,
    porcentaje DECIMAL(5,2) NOT NULL CONSTRAINT DF_progresolectura_porcentaje DEFAULT 0,
    fecha_inicio DATETIME2(0) NOT NULL CONSTRAINT DF_progresolectura_fecha_inicio DEFAULT GETDATE(),
    fecha_ultima_lectura DATETIME2(0) NOT NULL CONSTRAINT DF_progresolectura_fecha_ultima_lectura DEFAULT GETDATE(),
    CONSTRAINT PK_progresolectura PRIMARY KEY (id),
    CONSTRAINT UQ_progresolectura_cliente_id_recurso_digital_id UNIQUE (cliente_id, recurso_digital_id),
    CONSTRAINT CK_progresolectura_porcentaje CHECK (porcentaje BETWEEN 0 AND 100),
    CONSTRAINT fk_progresolectura_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_progresolectura_recurso FOREIGN KEY (recurso_digital_id) REFERENCES dbo.recursodigital (id)
);

GO

CREATE INDEX IX_progresolectura_recurso_digital_id ON dbo.progresolectura (recurso_digital_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra hasta dónde ha leído o escuchado cada cliente un recurso digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente que lee o escucha el recurso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del recurso digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'recurso_digital_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Página (texto) o segundo (audio) donde se quedó el cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'posicion_actual';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Porcentaje de avance del recurso, de 0 a 100.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'porcentaje';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que el cliente abrió el recurso por primera vez.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'fecha_inicio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última vez que el cliente leyó o escuchó el recurso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'progresolectura', @level2type = N'COLUMN', @level2name = N'fecha_ultima_lectura';
GO
