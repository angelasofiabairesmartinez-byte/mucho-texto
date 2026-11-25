CREATE TABLE dbo.persona (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(60) NOT NULL,
    segundo_nombre NVARCHAR(60) NULL,
    apellido NVARCHAR(60) NOT NULL,
    segundo_apellido NVARCHAR(60) NULL,
    correo NVARCHAR(120) NULL,
    genero NCHAR(1) NULL,
    fecha_nacimiento DATE NULL,
    CONSTRAINT PK_persona PRIMARY KEY (id),
    CONSTRAINT UQ_persona_correo UNIQUE (correo),
    CONSTRAINT CK_persona_genero CHECK (genero IS NULL OR genero IN (N'M', N'F'))
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los datos personales comunes de clientes, empleados y autores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Segundo nombre de la persona, si lo tiene.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'segundo_nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Primer apellido de la persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'apellido';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Segundo apellido de la persona, si lo tiene.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'segundo_apellido';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección de correo electrónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'correo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'M: Masculino; F: Femenino', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'genero';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de nacimiento de la persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'persona', @level2type = N'COLUMN', @level2name = N'fecha_nacimiento';
GO
