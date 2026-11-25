CREATE TABLE dbo.incidenciaejemplar (
    id INT IDENTITY(1,1) NOT NULL,
    ejemplar_id INT NOT NULL,
    empleado_id INT NOT NULL,
    tipo_incidencia NVARCHAR(40) NOT NULL,
    fecha_reporte DATETIME2(0) NOT NULL CONSTRAINT DF_incidenciaejemplar_fecha_reporte DEFAULT GETDATE(),
    descripcion NVARCHAR(250) NOT NULL,
    estado NVARCHAR(30) NOT NULL CONSTRAINT DF_incidenciaejemplar_estado DEFAULT N'ABIERTA',
    fecha_resolucion DATETIME2(0) NULL,
    CONSTRAINT PK_incidenciaejemplar PRIMARY KEY (id),
    CONSTRAINT CK_incidenciaejemplar_estado CHECK (estado IN (N'ABIERTA', N'EN PROCESO', N'RESUELTA')),
    CONSTRAINT fk_incidencia_ejemplar FOREIGN KEY (ejemplar_id) REFERENCES dbo.ejemplar (id),
    CONSTRAINT fk_incidencia_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_incidenciaejemplar_ejemplar_id ON dbo.incidenciaejemplar (ejemplar_id);
CREATE INDEX IX_incidenciaejemplar_empleado_id ON dbo.incidenciaejemplar (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra daños, pérdidas u otros incidentes relacionados con ejemplares.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del ejemplar físico relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'ejemplar_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clasificación del incidente reportado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'tipo_incidencia';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se reportó la incidencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'fecha_reporte';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la incidencia: ABIERTA, EN PROCESO o RESUELTA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se resolvió la incidencia, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'incidenciaejemplar', @level2type = N'COLUMN', @level2name = N'fecha_resolucion';
GO
