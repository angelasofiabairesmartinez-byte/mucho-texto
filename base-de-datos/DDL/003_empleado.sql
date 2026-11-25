CREATE TABLE dbo.empleado (
    id INT IDENTITY(1,1) NOT NULL,
    codigo_empleado NVARCHAR(20) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    persona_id INT NOT NULL,
    cargo_id INT NOT NULL,
    CONSTRAINT PK_empleado PRIMARY KEY (id),
    CONSTRAINT UQ_empleado_codigo_empleado UNIQUE (codigo_empleado),
    CONSTRAINT UQ_empleado_persona_id UNIQUE (persona_id),
    CONSTRAINT fk_empleado_cargo FOREIGN KEY (cargo_id) REFERENCES dbo.cargo (id),
    CONSTRAINT fk_empleado_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id)
);

GO

CREATE INDEX IX_empleado_cargo_id ON dbo.empleado (cargo_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra a las personas que trabajan en la biblioteca o librería.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código único asignado al empleado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado', @level2type = N'COLUMN', @level2name = N'codigo_empleado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que comenzó la relación laboral del empleado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado', @level2type = N'COLUMN', @level2name = N'fecha_contratacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cargo asignado al empleado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'empleado', @level2type = N'COLUMN', @level2name = N'cargo_id';
GO
