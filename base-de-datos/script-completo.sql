/* ============================================================
   Mucho Texto - biblioteca_libreria
   SCRIPT COMPLETO (generado automáticamente, no editar a mano)
   Generado con: node scripts/generar-script-completo.mjs
   Orden: DDL -> Vistas -> Funciones -> Procedimientos -> DML
   ============================================================ */

-- >>> DDL/000_base_de_datos.sql
/* ============================================================
   Base de datos: biblioteca_libreria (Mucho Texto)
   Motor: Microsoft SQL Server 2017 o superior
   Bases de Datos I - Segunda entrega - Archivo 2
   Estándar de nombres: tablas y campos en minúsculas y singular;
   PK_, UQ_, fk_, CK_, DF_, IX_, vw_, fn_, trg_
   ============================================================ */

SET NOCOUNT ON;
GO

USE master;
GO

IF DB_ID(N'biblioteca_libreria') IS NOT NULL
BEGIN
    ALTER DATABASE biblioteca_libreria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE biblioteca_libreria;
END
GO

CREATE DATABASE biblioteca_libreria COLLATE Latin1_General_100_CI_AI;
GO

USE biblioteca_libreria;
GO

-- >>> DDL/001_cargo.sql
CREATE TABLE dbo.cargo (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(150) NULL,
    CONSTRAINT PK_cargo PRIMARY KEY (id),
    CONSTRAINT UQ_cargo_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene los cargos que pueden ocupar los empleados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cargo', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/002_persona.sql
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

-- >>> DDL/003_empleado.sql
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

-- >>> DDL/004_rol.sql
CREATE TABLE dbo.rol (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(200) NULL,
    CONSTRAINT PK_rol PRIMARY KEY (id),
    CONSTRAINT UQ_rol_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los roles que determinan el nivel de acceso al sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'rol';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'rol', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'rol', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'rol', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/005_usuario.sql
CREATE TABLE dbo.usuario (
    id INT IDENTITY(1,1) NOT NULL,
    nombre_usuario NVARCHAR(50) NOT NULL,
    contrasena_hash NVARCHAR(255) NOT NULL,
    persona_id INT NOT NULL,
    rol_id INT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL CONSTRAINT DF_usuario_fecha_creacion DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_usuario_estado DEFAULT 1,
    CONSTRAINT PK_usuario PRIMARY KEY (id),
    CONSTRAINT UQ_usuario_nombre_usuario UNIQUE (nombre_usuario),
    CONSTRAINT UQ_usuario_persona_id UNIQUE (persona_id),
    CONSTRAINT CK_usuario_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_usuario_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES dbo.rol (id)
);

GO

CREATE INDEX IX_usuario_rol_id ON dbo.usuario (rol_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las cuentas de acceso de empleados y clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre utilizado para iniciar sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'nombre_usuario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Hash de la contraseña de acceso; no debe almacenarse la contraseña en texto plano.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'contrasena_hash';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona (empleado o cliente) propietaria de la cuenta de usuario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del rol asignado al usuario.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'rol_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se creó el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'fecha_creacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'usuario', @level2type = N'COLUMN', @level2name = N'estado';
GO

-- >>> DDL/006_auditoria.sql
CREATE TABLE dbo.auditoria (
    id INT IDENTITY(1,1) NOT NULL,
    usuario_id INT NULL,
    fecha_hora DATETIME2(0) NOT NULL CONSTRAINT DF_auditoria_fecha_hora DEFAULT GETDATE(),
    accion NVARCHAR(50) NOT NULL,
    tabla_afectada NVARCHAR(100) NOT NULL,
    registro_id NVARCHAR(100) NULL,
    detalle NVARCHAR(500) NULL,
    CONSTRAINT PK_auditoria PRIMARY KEY (id),
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuario (id)
);

GO

CREATE INDEX IX_auditoria_usuario_id ON dbo.auditoria (usuario_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva el registro de acciones importantes realizadas en el sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro de auditoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de usuario relacionado con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'usuario_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que ocurrió la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'fecha_hora';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de acción realizada en el sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'accion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la tabla en la que se realizó la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'tabla_afectada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del registro afectado por la acción.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'registro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Información complementaria sobre la acción o el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auditoria', @level2type = N'COLUMN', @level2name = N'detalle';
GO

-- >>> DDL/007_autor.sql
CREATE TABLE dbo.autor (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_registro DATE NULL,
    persona_id INT NOT NULL,
    CONSTRAINT PK_autor PRIMARY KEY (id),
    CONSTRAINT UQ_autor_persona_id UNIQUE (persona_id),
    CONSTRAINT fk_autor_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra a las personas que figuran como autores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la información.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'autor', @level2type = N'COLUMN', @level2name = N'persona_id';
GO

-- >>> DDL/008_categoria.sql
CREATE TABLE dbo.categoria (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(200) NULL,
    CONSTRAINT PK_categoria PRIMARY KEY (id),
    CONSTRAINT UQ_categoria_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clasifica los libros por tema o área.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'categoria', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/009_tipocliente.sql
CREATE TABLE dbo.tipocliente (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    descripcion NVARCHAR(150) NULL,
    limite_prestamos SMALLINT NOT NULL CONSTRAINT DF_tipocliente_limite_prestamos DEFAULT 3,
    limite_renovaciones SMALLINT NOT NULL CONSTRAINT DF_tipocliente_limite_renovaciones DEFAULT 1,
    CONSTRAINT PK_tipocliente PRIMARY KEY (id),
    CONSTRAINT UQ_tipocliente_nombre UNIQUE (nombre),
    CONSTRAINT CK_tipocliente_limite_prestamos CHECK (limite_prestamos BETWEEN 0 AND 20),
    CONSTRAINT CK_tipocliente_limite_renovaciones CHECK (limite_renovaciones BETWEEN 0 AND 5)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define las categorías de clientes de la biblioteca o librería.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad máxima de ejemplares que el cliente puede tener prestados al mismo tiempo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'limite_prestamos';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad máxima de veces que el cliente puede renovar un mismo préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tipocliente', @level2type = N'COLUMN', @level2name = N'limite_renovaciones';
GO

-- >>> DDL/010_cliente.sql
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

-- >>> DDL/011_proveedor.sql
CREATE TABLE dbo.proveedor (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(25) NULL,
    correo NVARCHAR(120) NULL,
    direccion NVARCHAR(180) NULL,
    CONSTRAINT PK_proveedor PRIMARY KEY (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los proveedores a los que se compran libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'telefono';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección de correo electrónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'correo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección física o ubicación de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'proveedor', @level2type = N'COLUMN', @level2name = N'direccion';
GO

-- >>> DDL/012_compraproveedor.sql
CREATE TABLE dbo.compraproveedor (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_compra DATE NOT NULL,
    numero_factura NVARCHAR(40) NULL,
    proveedor_id INT NOT NULL,
    empleado_id INT NOT NULL,
    CONSTRAINT PK_compraproveedor PRIMARY KEY (id),
    CONSTRAINT fk_compra_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES dbo.proveedor (id)
);

GO

CREATE INDEX IX_compraproveedor_proveedor_id ON dbo.compraproveedor (proveedor_id);
CREATE INDEX IX_compraproveedor_empleado_id ON dbo.compraproveedor (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las compras realizadas a proveedores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se realizó la compra al proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'fecha_compra';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número de factura emitida por el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'numero_factura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del proveedor relacionado con la compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'proveedor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'compraproveedor', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO

-- >>> DDL/013_credencial.sql
CREATE TABLE dbo.credencial (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_registro DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    estado NVARCHAR(20) NOT NULL CONSTRAINT DF_credencial_estado DEFAULT N'ACTIVA',
    cliente_id INT NOT NULL,
    empleado_id INT NULL,
    CONSTRAINT PK_credencial PRIMARY KEY (id),
    CONSTRAINT CK_credencial_estado CHECK (estado IN (N'ACTIVA', N'VENCIDA', N'SUSPENDIDA')),
    CONSTRAINT fk_credencial_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_credencial_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_credencial_cliente_id ON dbo.credencial (cliente_id);
CREATE INDEX IX_credencial_empleado_id ON dbo.credencial (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Controla las credenciales asignadas a los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la información.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'fecha_registro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha límite o de vencimiento del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'fecha_vencimiento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la credencial: ACTIVA, VENCIDA o SUSPENDIDA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'credencial', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO

-- >>> DDL/014_sucursal.sql
CREATE TABLE dbo.sucursal (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    direccion NVARCHAR(180) NOT NULL,
    telefono NVARCHAR(25) NULL,
    CONSTRAINT PK_sucursal PRIMARY KEY (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las sucursales de la biblioteca-librería.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección física o ubicación de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'direccion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico de contacto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'sucursal', @level2type = N'COLUMN', @level2name = N'telefono';
GO

-- >>> DDL/015_estante.sql
CREATE TABLE dbo.estante (
    id INT IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    sucursal_id INT NOT NULL,
    CONSTRAINT PK_estante PRIMARY KEY (id),
    CONSTRAINT UQ_estante_codigo_sucursal_id UNIQUE (codigo, sucursal_id),
    CONSTRAINT fk_estante_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id)
);

GO

CREATE INDEX IX_estante_sucursal_id ON dbo.estante (sucursal_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Organiza los estantes ubicados dentro de una sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código interno para identificar el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la sucursal relacionada con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estante', @level2type = N'COLUMN', @level2name = N'sucursal_id';
GO

-- >>> DDL/016_cubiculo.sql
CREATE TABLE dbo.cubiculo (
    id INT IDENTITY(1,1) NOT NULL,
    codigo NVARCHAR(20) NOT NULL,
    estante_id INT NOT NULL,
    CONSTRAINT PK_cubiculo PRIMARY KEY (id),
    CONSTRAINT UQ_cubiculo_codigo_estante_id UNIQUE (codigo, estante_id),
    CONSTRAINT fk_cubiculo_estante FOREIGN KEY (estante_id) REFERENCES dbo.estante (id)
);

GO

CREATE INDEX IX_cubiculo_estante_id ON dbo.cubiculo (estante_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identifica los cubículos o espacios de ubicación dentro de un estante.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código interno para identificar el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'codigo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del estante al que pertenece el cubículo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cubiculo', @level2type = N'COLUMN', @level2name = N'estante_id';
GO

-- >>> DDL/017_descuento.sql
CREATE TABLE dbo.descuento (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(250) NULL,
    tipo_descuento NVARCHAR(20) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado SMALLINT NOT NULL CONSTRAINT DF_descuento_estado DEFAULT 1,
    tipo_cliente_id INT NULL,
    categoria_id INT NULL,
    CONSTRAINT PK_descuento PRIMARY KEY (id),
    CONSTRAINT CK_descuento_estado CHECK (estado IN (0, 1)),
    CONSTRAINT CK_descuento_valor CHECK (valor >= 0),
    CONSTRAINT CK_descuento_tipo_descuento CHECK (tipo_descuento IN (N'PORCENTAJE', N'MONTO_FIJO')),
    CONSTRAINT fk_descuento_tipocliente FOREIGN KEY (tipo_cliente_id) REFERENCES dbo.tipocliente (id),
    CONSTRAINT fk_descuento_categoria FOREIGN KEY (categoria_id) REFERENCES dbo.categoria (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los descuentos que pueden aplicarse en la facturación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Forma de cálculo del descuento: PORCENTAJE o MONTO_FIJO.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'tipo_descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del descuento, según el tipo configurado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'valor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha desde la que comienza la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'fecha_inicio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha hasta la que se mantiene la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'fecha_fin';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de cliente al que se limita el descuento. NULL: aplica a cualquier tipo de cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'tipo_cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Categoría de libros a la que se limita el descuento. NULL: aplica a cualquier libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'descuento', @level2type = N'COLUMN', @level2name = N'categoria_id';
GO

-- >>> DDL/018_editorial.sql
CREATE TABLE dbo.editorial (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_editorial PRIMARY KEY (id),
    CONSTRAINT UQ_editorial_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda las editoriales que publican las ediciones de los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'editorial';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'editorial', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'editorial', @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- >>> DDL/019_formatolibro.sql
CREATE TABLE dbo.formatolibro (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_formatolibro PRIMARY KEY (id),
    CONSTRAINT UQ_formatolibro_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los formatos disponibles de publicación de los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formatolibro', @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- >>> DDL/020_idioma.sql
CREATE TABLE dbo.idioma (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_idioma PRIMARY KEY (id),
    CONSTRAINT UQ_idioma_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene los idiomas en los que se publican los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'idioma', @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- >>> DDL/021_edicion.sql
CREATE TABLE dbo.edicion (
    id INT IDENTITY(1,1) NOT NULL,
    numero_edicion NVARCHAR(30) NULL,
    anio_publicacion NUMERIC(4,0) NULL,
    isbn NVARCHAR(20) NULL,
    editorial_id INT NOT NULL,
    idioma_id INT NOT NULL,
    formato_libro_id INT NOT NULL,
    CONSTRAINT PK_edicion PRIMARY KEY (id),
    CONSTRAINT UQ_edicion_isbn UNIQUE (isbn),
    CONSTRAINT fk_edicion_editorial FOREIGN KEY (editorial_id) REFERENCES dbo.editorial (id),
    CONSTRAINT fk_edicion_formato FOREIGN KEY (formato_libro_id) REFERENCES dbo.formatolibro (id),
    CONSTRAINT fk_edicion_idioma FOREIGN KEY (idioma_id) REFERENCES dbo.idioma (id)
);

GO

CREATE INDEX IX_edicion_editorial_id ON dbo.edicion (editorial_id);
CREATE INDEX IX_edicion_idioma_id ON dbo.edicion (idioma_id);
CREATE INDEX IX_edicion_formato_libro_id ON dbo.edicion (formato_libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los datos editoriales de cada edición de un libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número o denominación de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'numero_edicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Año en que se publicó la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'anio_publicacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número ISBN que identifica la edición publicada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'isbn';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la editorial de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'editorial_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del idioma de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'idioma_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del formato de la edición.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'edicion', @level2type = N'COLUMN', @level2name = N'formato_libro_id';
GO

-- >>> DDL/022_libro.sql
CREATE TABLE dbo.libro (
    id INT IDENTITY(1,1) NOT NULL,
    titulo NVARCHAR(180) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    edicion_id INT NOT NULL,
    precio_venta DECIMAL(10,2) NULL,
    permite_digital SMALLINT NOT NULL CONSTRAINT DF_libro_permite_digital DEFAULT 0,
    ruta_portada NVARCHAR(300) NULL,
    CONSTRAINT PK_libro PRIMARY KEY (id),
    CONSTRAINT CK_libro_precio_venta CHECK (precio_venta IS NULL OR precio_venta >= 0),
    CONSTRAINT CK_libro_permite_digital CHECK (permite_digital IN (0, 1)),
    CONSTRAINT fk_libro_edicion FOREIGN KEY (edicion_id) REFERENCES dbo.edicion (id)
);

GO

CREATE INDEX IX_libro_edicion_id ON dbo.libro (edicion_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contiene la información bibliográfica general de cada título.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Título con el que se identifica el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'titulo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'descripcion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la edición a la que pertenece el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'edicion_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Precio de venta al público vigente del libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'precio_venta';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Tiene derechos para lectura digital y audiolibro; 0: Solo formato físico', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'permite_digital';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ruta o URL de la imagen de portada que se muestra en el catálogo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libro', @level2type = N'COLUMN', @level2name = N'ruta_portada';
GO

-- >>> DDL/023_detallecompra.sql
CREATE TABLE dbo.detallecompra (
    id INT IDENTITY(1,1) NOT NULL,
    compra_proveedor_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_detallecompra PRIMARY KEY (id),
    CONSTRAINT CK_detallecompra_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_detallecompra_compra FOREIGN KEY (compra_proveedor_id) REFERENCES dbo.compraproveedor (id),
    CONSTRAINT fk_detallecompra_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_detallecompra_compra_proveedor_id ON dbo.detallecompra (compra_proveedor_id);
CREATE INDEX IX_detallecompra_libro_id ON dbo.detallecompra (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Detalla los libros y cantidades incluidos en cada compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la línea de detalle de la compra.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la compra al proveedor a la que pertenece el detalle.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'compra_proveedor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad registrada para la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'cantidad';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Costo de adquisición por unidad comprada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallecompra', @level2type = N'COLUMN', @level2name = N'costo_unitario';
GO

-- >>> DDL/024_estadoejemplar.sql
CREATE TABLE dbo.estadoejemplar (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(30) NOT NULL,
    descripcion NVARCHAR(120) NULL,
    CONSTRAINT PK_estadoejemplar PRIMARY KEY (id),
    CONSTRAINT UQ_estadoejemplar_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los estados en que puede encontrarse un ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoejemplar', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/025_ejemplar.sql
CREATE TABLE dbo.ejemplar (
    id INT IDENTITY(1,1) NOT NULL,
    codigo_barras NVARCHAR(40) NOT NULL,
    fecha_adquisicion DATE NULL,
    precio_adquisicion DECIMAL(10,2) NULL,
    libro_id INT NOT NULL,
    cubiculo_id INT NULL,
    estado_ejemplar_id INT NOT NULL,
    CONSTRAINT PK_ejemplar PRIMARY KEY (id),
    CONSTRAINT UQ_ejemplar_codigo_barras UNIQUE (codigo_barras),
    CONSTRAINT fk_ejemplar_cubiculo FOREIGN KEY (cubiculo_id) REFERENCES dbo.cubiculo (id),
    CONSTRAINT fk_ejemplar_estado FOREIGN KEY (estado_ejemplar_id) REFERENCES dbo.estadoejemplar (id),
    CONSTRAINT fk_ejemplar_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_ejemplar_libro_id ON dbo.ejemplar (libro_id);
CREATE INDEX IX_ejemplar_cubiculo_id ON dbo.ejemplar (cubiculo_id);
CREATE INDEX IX_ejemplar_estado_ejemplar_id ON dbo.ejemplar (estado_ejemplar_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra cada copia física de un libro y su ubicación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Código de barras único del ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'codigo_barras';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se adquirió el ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'fecha_adquisicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Costo de adquisición del ejemplar físico.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'precio_adquisicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cubículo donde se ubica el ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'cubiculo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del estado actual del ejemplar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ejemplar', @level2type = N'COLUMN', @level2name = N'estado_ejemplar_id';
GO

-- >>> DDL/026_estadoprestamo.sql
CREATE TABLE dbo.estadoprestamo (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(30) NOT NULL,
    descripcion NVARCHAR(120) NULL,
    CONSTRAINT PK_estadoprestamo PRIMARY KEY (id),
    CONSTRAINT UQ_estadoprestamo_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los estados posibles de un préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoprestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoprestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoprestamo', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'estadoprestamo', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/027_prestamo.sql
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

-- >>> DDL/028_detalleprestamo.sql
CREATE TABLE dbo.detalleprestamo (
    id INT IDENTITY(1,1) NOT NULL,
    prestamo_id INT NOT NULL,
    ejemplar_id INT NOT NULL,
    CONSTRAINT PK_detalleprestamo PRIMARY KEY (id),
    CONSTRAINT UQ_detalleprestamo_prestamo_id_ejemplar_id UNIQUE (prestamo_id, ejemplar_id),
    CONSTRAINT fk_detalleprestamo_ejemplar FOREIGN KEY (ejemplar_id) REFERENCES dbo.ejemplar (id),
    CONSTRAINT fk_detalleprestamo_prestamo FOREIGN KEY (prestamo_id) REFERENCES dbo.prestamo (id)
);

GO

CREATE INDEX IX_detalleprestamo_ejemplar_id ON dbo.detalleprestamo (ejemplar_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identifica los ejemplares incluidos en cada préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del detalle del préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del préstamo relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del ejemplar físico relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalleprestamo', @level2type = N'COLUMN', @level2name = N'ejemplar_id';
GO

-- >>> DDL/029_devolucion.sql
CREATE TABLE dbo.devolucion (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_devolucion DATETIME2(0) NOT NULL,
    observacion NVARCHAR(200) NULL,
    empleado_id INT NOT NULL,
    CONSTRAINT PK_devolucion PRIMARY KEY (id),
    CONSTRAINT fk_devolucion_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_devolucion_empleado_id ON dbo.devolucion (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra la devolución de ejemplares prestados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró la devolución.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'fecha_devolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'observacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'devolucion', @level2type = N'COLUMN', @level2name = N'empleado_id';
GO

-- >>> DDL/030_detalledevolucion.sql
CREATE TABLE dbo.detalledevolucion (
    id INT IDENTITY(1,1) NOT NULL,
    devolucion_id INT NOT NULL,
    detalle_prestamo_id INT NOT NULL,
    condicion_entrega NVARCHAR(40) NOT NULL,
    observacion NVARCHAR(200) NULL,
    CONSTRAINT PK_detalledevolucion PRIMARY KEY (id),
    CONSTRAINT UQ_detalledevolucion_detalle_prestamo_id UNIQUE (detalle_prestamo_id),
    CONSTRAINT fk_detalledevolucion_detalleprestamo FOREIGN KEY (detalle_prestamo_id) REFERENCES dbo.detalleprestamo (id),
    CONSTRAINT fk_detalledevolucion_devolucion FOREIGN KEY (devolucion_id) REFERENCES dbo.devolucion (id)
);

GO

CREATE INDEX IX_detalledevolucion_devolucion_id ON dbo.detalledevolucion (devolucion_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Detalla los ejemplares devueltos y su condición de entrega.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del detalle de devolución.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de devolucion relacionado con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'devolucion_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del detalle de préstamo relacionado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'detalle_prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Condición en que se recibió el ejemplar devuelto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'condicion_entrega';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detalledevolucion', @level2type = N'COLUMN', @level2name = N'observacion';
GO

-- >>> DDL/031_factura.sql
CREATE TABLE dbo.factura (
    id INT IDENTITY(1,1) NOT NULL,
    fecha DATETIME2(0) NOT NULL,
    cliente_id INT NULL,
    empleado_id INT NOT NULL,
    canal NVARCHAR(1) NOT NULL CONSTRAINT DF_factura_canal DEFAULT N'T',
    CONSTRAINT PK_factura PRIMARY KEY (id),
    CONSTRAINT CK_factura_canal CHECK (canal IN (N'T', N'L')),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_factura_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_factura_cliente_id ON dbo.factura (cliente_id);
CREATE INDEX IX_factura_empleado_id ON dbo.factura (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las ventas facturadas a clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se emitió la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'fecha';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'T: Tienda; L: En línea', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'factura', @level2type = N'COLUMN', @level2name = N'canal';
GO

-- >>> DDL/032_impuesto.sql
CREATE TABLE dbo.impuesto (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(80) NOT NULL,
    porcentaje DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado SMALLINT NOT NULL CONSTRAINT DF_impuesto_estado DEFAULT 1,
    CONSTRAINT PK_impuesto PRIMARY KEY (id),
    CONSTRAINT CK_impuesto_estado CHECK (estado IN (0, 1)),
    CONSTRAINT CK_impuesto_porcentaje CHECK (porcentaje BETWEEN 0 AND 100)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define los impuestos vigentes que se aplican en la facturación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'nombre';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Porcentaje definido para el impuesto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'porcentaje';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha desde la que comienza la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'fecha_inicio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha hasta la que se mantiene la vigencia.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'fecha_fin';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Activo; 0: Inactivo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'impuesto', @level2type = N'COLUMN', @level2name = N'estado';
GO

-- >>> DDL/033_detallefactura.sql
CREATE TABLE dbo.detallefactura (
    id INT IDENTITY(1,1) NOT NULL,
    factura_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL CONSTRAINT DF_detallefactura_descuento DEFAULT 0,
    descuento_id INT NULL,
    impuesto_id INT NULL,
    monto_impuesto DECIMAL(10,2) NOT NULL CONSTRAINT DF_detallefactura_monto_impuesto DEFAULT 0,
    CONSTRAINT PK_detallefactura PRIMARY KEY (id),
    CONSTRAINT CK_detallefactura_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_detallefactura_descuento FOREIGN KEY (descuento_id) REFERENCES dbo.descuento (id),
    CONSTRAINT fk_detallefactura_factura FOREIGN KEY (factura_id) REFERENCES dbo.factura (id),
    CONSTRAINT fk_detallefactura_impuesto FOREIGN KEY (impuesto_id) REFERENCES dbo.impuesto (id),
    CONSTRAINT fk_detallefactura_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_detallefactura_factura_id ON dbo.detallefactura (factura_id);
CREATE INDEX IX_detallefactura_libro_id ON dbo.detallefactura (libro_id);
CREATE INDEX IX_detallefactura_descuento_id ON dbo.detallefactura (descuento_id);
CREATE INDEX IX_detallefactura_impuesto_id ON dbo.detallefactura (impuesto_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los libros, cantidades y valores correspondientes a cada línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único de la línea de detalle de la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la factura a la que pertenece el detalle.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'factura_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad registrada para la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'cantidad';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Precio aplicado a una unidad del producto vendido.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'precio_unitario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto de descuento aplicado a la línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'descuento';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del descuento aplicado a la línea de factura, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'descuento_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del impuesto aplicado a la línea de factura, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'impuesto_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto del impuesto calculado para esta línea de factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'detallefactura', @level2type = N'COLUMN', @level2name = N'monto_impuesto';
GO

-- >>> DDL/034_formapago.sql
CREATE TABLE dbo.formapago (
    id INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_formapago PRIMARY KEY (id),
    CONSTRAINT UQ_formapago_nombre UNIQUE (nombre)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Define las formas de pago aceptadas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre con el que se identifica el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'formapago', @level2type = N'COLUMN', @level2name = N'nombre';
GO

-- >>> DDL/035_facturaformapago.sql
CREATE TABLE dbo.facturaformapago (
    factura_id INT NOT NULL,
    forma_pago_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    referencia NVARCHAR(80) NULL,
    CONSTRAINT PK_facturaformapago PRIMARY KEY (factura_id, forma_pago_id),
    CONSTRAINT fk_facturaformapago_factura FOREIGN KEY (factura_id) REFERENCES dbo.factura (id),
    CONSTRAINT fk_facturaformapago_forma FOREIGN KEY (forma_pago_id) REFERENCES dbo.formapago (id)
);

GO

CREATE INDEX IX_facturaformapago_forma_pago_id ON dbo.facturaformapago (forma_pago_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona las facturas con sus formas de pago y montos abonados.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la factura en la que se registra el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'factura_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la forma de pago usada en la factura.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'forma_pago_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número o dato de referencia del pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'facturaformapago', @level2type = N'COLUMN', @level2name = N'referencia';
GO

-- >>> DDL/036_historialcliente.sql
CREATE TABLE dbo.historialcliente (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    empleado_id INT NULL,
    fecha_cambio DATETIME2(0) NOT NULL CONSTRAINT DF_historialcliente_fecha_cambio DEFAULT GETDATE(),
    tipo_cambio NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(250) NOT NULL,
    CONSTRAINT PK_historialcliente PRIMARY KEY (id),
    CONSTRAINT fk_historialcliente_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_historialcliente_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id)
);

GO

CREATE INDEX IX_historialcliente_cliente_id ON dbo.historialcliente (cliente_id);
CREATE INDEX IX_historialcliente_empleado_id ON dbo.historialcliente (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva un registro de cambios relevantes relacionados con los clientes.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'fecha_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo de cambio realizado en los datos del cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'tipo_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Descripción complementaria del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialcliente', @level2type = N'COLUMN', @level2name = N'descripcion';
GO

-- >>> DDL/037_historialprestamo.sql
CREATE TABLE dbo.historialprestamo (
    id INT IDENTITY(1,1) NOT NULL,
    prestamo_id INT NOT NULL,
    empleado_id INT NULL,
    fecha_cambio DATETIME2(0) NOT NULL CONSTRAINT DF_historialprestamo_fecha_cambio DEFAULT GETDATE(),
    estado_anterior NVARCHAR(30) NULL,
    estado_nuevo NVARCHAR(30) NOT NULL,
    observacion NVARCHAR(250) NULL,
    CONSTRAINT PK_historialprestamo PRIMARY KEY (id),
    CONSTRAINT fk_historialprestamo_empleado FOREIGN KEY (empleado_id) REFERENCES dbo.empleado (id),
    CONSTRAINT fk_historialprestamo_prestamo FOREIGN KEY (prestamo_id) REFERENCES dbo.prestamo (id)
);

GO

CREATE INDEX IX_historialprestamo_prestamo_id ON dbo.historialprestamo (prestamo_id);
CREATE INDEX IX_historialprestamo_empleado_id ON dbo.historialprestamo (empleado_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Conserva los cambios de estado que ocurren durante un préstamo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del préstamo relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'prestamo_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del empleado relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'empleado_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'fecha_cambio';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado que tenía el préstamo antes del cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'estado_anterior';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado asignado al préstamo después del cambio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'estado_nuevo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Notas adicionales relacionadas con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'historialprestamo', @level2type = N'COLUMN', @level2name = N'observacion';
GO

-- >>> DDL/038_incidenciaejemplar.sql
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

-- >>> DDL/039_inventariosucursal.sql
CREATE TABLE dbo.inventariosucursal (
    id INT IDENTITY(1,1) NOT NULL,
    sucursal_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad_disponible INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_disponible DEFAULT 0,
    cantidad_danada INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_danada DEFAULT 0,
    cantidad_reservada INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_reservada DEFAULT 0,
    fecha_actualizacion DATETIME2(0) NOT NULL CONSTRAINT DF_inventariosucursal_fecha_actualizacion DEFAULT GETDATE(),
    CONSTRAINT PK_inventariosucursal PRIMARY KEY (id),
    CONSTRAINT UQ_inventariosucursal_sucursal_id_libro_id UNIQUE (sucursal_id, libro_id),
    CONSTRAINT fk_inventariosucursal_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id),
    CONSTRAINT fk_inventariosucursal_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id)
);

GO

CREATE INDEX IX_inventariosucursal_libro_id ON dbo.inventariosucursal (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Resume las cantidades de libros por sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro de inventario por sucursal y libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la sucursal relacionada con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'sucursal_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades disponibles en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_disponible';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades dañadas registradas en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_danada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades reservadas en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_reservada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última actualización del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

GO

CREATE TRIGGER dbo.trg_inventariosucursal_fecha_actualizacion
ON dbo.inventariosucursal
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 OR UPDATE(fecha_actualizacion) RETURN;
    UPDATE t
       SET fecha_actualizacion = GETDATE()
      FROM dbo.inventariosucursal AS t
      INNER JOIN inserted AS i ON i.id = t.id;
END;
GO

-- >>> DDL/040_libroautor.sql
CREATE TABLE dbo.libroautor (
    libro_id INT NOT NULL,
    autor_id INT NOT NULL,
    orden_autoria SMALLINT NULL,
    CONSTRAINT PK_libroautor PRIMARY KEY (libro_id, autor_id),
    CONSTRAINT fk_libroautor_autor FOREIGN KEY (autor_id) REFERENCES dbo.autor (id),
    CONSTRAINT fk_libroautor_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_libroautor_autor_id ON dbo.libroautor (autor_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona los libros con sus autores y conserva el orden de autoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro que se vincula con el autor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del autor vinculado con el libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'autor_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Posición del autor en la lista de autores del libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'libroautor', @level2type = N'COLUMN', @level2name = N'orden_autoria';
GO

-- >>> DDL/041_librocategoria.sql
CREATE TABLE dbo.librocategoria (
    libro_id INT NOT NULL,
    categoria_id INT NOT NULL,
    CONSTRAINT PK_librocategoria PRIMARY KEY (libro_id, categoria_id),
    CONSTRAINT fk_librocat_categoria FOREIGN KEY (categoria_id) REFERENCES dbo.categoria (id),
    CONSTRAINT fk_librocat_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_librocategoria_categoria_id ON dbo.librocategoria (categoria_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Relaciona cada libro con una o varias categorías.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro que se vincula con la categoría.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la categoría asignada al libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'librocategoria', @level2type = N'COLUMN', @level2name = N'categoria_id';
GO

-- >>> DDL/042_movimientoinventario.sql
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

-- >>> DDL/043_multa.sql
CREATE TABLE dbo.multa (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_generacion DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    motivo NVARCHAR(180) NOT NULL,
    estado NVARCHAR(20) NOT NULL CONSTRAINT DF_multa_estado DEFAULT N'PENDIENTE',
    detalle_prestamo_id INT NOT NULL,
    CONSTRAINT PK_multa PRIMARY KEY (id),
    CONSTRAINT CK_multa_estado CHECK (estado IN (N'PENDIENTE', N'PAGADA')),
    CONSTRAINT CK_multa_monto CHECK (monto >= 0),
    CONSTRAINT fk_multa_detalleprestamo FOREIGN KEY (detalle_prestamo_id) REFERENCES dbo.detalleprestamo (id)
);

GO

CREATE INDEX IX_multa_detalle_prestamo_id ON dbo.multa (detalle_prestamo_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las multas generadas por incumplimientos de préstamos.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se generó la multa.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'fecha_generacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Motivo por el que se generó la multa.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'motivo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Estado de la multa: PENDIENTE o PAGADA.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'estado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del detalle de préstamo relacionado.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'multa', @level2type = N'COLUMN', @level2name = N'detalle_prestamo_id';
GO

-- >>> DDL/044_pagomulta.sql
CREATE TABLE dbo.pagomulta (
    id INT IDENTITY(1,1) NOT NULL,
    fecha_pago DATETIME2(0) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    multa_id INT NOT NULL,
    forma_pago_id INT NOT NULL,
    CONSTRAINT PK_pagomulta PRIMARY KEY (id),
    CONSTRAINT fk_pagomulta_forma FOREIGN KEY (forma_pago_id) REFERENCES dbo.formapago (id),
    CONSTRAINT fk_pagomulta_multa FOREIGN KEY (multa_id) REFERENCES dbo.multa (id)
);

GO

CREATE INDEX IX_pagomulta_multa_id ON dbo.pagomulta (multa_id);
CREATE INDEX IX_pagomulta_forma_pago_id ON dbo.pagomulta (forma_pago_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los pagos realizados para cancelar multas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se registró el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'fecha_pago';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Monto monetario relacionado con la operación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'monto';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la multa a la que corresponde el pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'multa_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la forma de pago utilizada.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'pagomulta', @level2type = N'COLUMN', @level2name = N'forma_pago_id';
GO

-- >>> DDL/045_resenalibro.sql
CREATE TABLE dbo.resenalibro (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    libro_id INT NOT NULL,
    calificacion SMALLINT NOT NULL,
    comentario NVARCHAR(500) NULL,
    fecha_resena DATETIME2(0) NOT NULL CONSTRAINT DF_resenalibro_fecha_resena DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_resenalibro_estado DEFAULT 1,
    CONSTRAINT PK_resenalibro PRIMARY KEY (id),
    CONSTRAINT UQ_resenalibro_cliente_id_libro_id UNIQUE (cliente_id, libro_id),
    CONSTRAINT CK_resenalibro_calificacion CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT CK_resenalibro_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_resenalibro_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_resenalibro_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

CREATE INDEX IX_resenalibro_libro_id ON dbo.resenalibro (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra las calificaciones y opiniones de los clientes sobre los libros.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'calificación asignada por el cliente al libro. Acepta valores enteros del 1 al 5, donde 1 es la menor valoración y 5 es la mayor valoración.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'calificacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Opinión escrita por el cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'comentario';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se registró la reseña.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'fecha_resena';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Visible; 0: Oculta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'resenalibro', @level2type = N'COLUMN', @level2name = N'estado';
GO

-- >>> DDL/046_reserva.sql
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

-- >>> DDL/047_telefono.sql
CREATE TABLE dbo.telefono (
    id INT IDENTITY(1,1) NOT NULL,
    numero NVARCHAR(25) NOT NULL,
    persona_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    CONSTRAINT PK_telefono PRIMARY KEY (id),
    CONSTRAINT CK_telefono_tipo CHECK (tipo IN (N'P', N'L', N'F')),
    CONSTRAINT fk_telefono_persona FOREIGN KEY (persona_id) REFERENCES dbo.persona (id)
);

GO

CREATE INDEX IX_telefono_persona_id ON dbo.telefono (persona_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Registra los números telefónicos asociados a una persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número telefónico o número de referencia, según el contexto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'numero';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la persona relacionada con este registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'persona_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'P: Personal; L: Laboral; F: Fijo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'telefono', @level2type = N'COLUMN', @level2name = N'tipo';
GO

-- >>> DDL/048_recursodigital.sql
CREATE TABLE dbo.recursodigital (
    id INT IDENTITY(1,1) NOT NULL,
    libro_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    ruta_archivo NVARCHAR(300) NOT NULL,
    total_paginas INT NULL,
    duracion_segundos INT NULL,
    generado_ia SMALLINT NOT NULL CONSTRAINT DF_recursodigital_generado_ia DEFAULT 0,
    voz_narracion NVARCHAR(60) NULL,
    fecha_publicacion DATETIME2(0) NOT NULL CONSTRAINT DF_recursodigital_fecha_publicacion DEFAULT GETDATE(),
    estado SMALLINT NOT NULL CONSTRAINT DF_recursodigital_estado DEFAULT 1,
    CONSTRAINT PK_recursodigital PRIMARY KEY (id),
    CONSTRAINT UQ_recursodigital_libro_id_tipo UNIQUE (libro_id, tipo),
    CONSTRAINT CK_recursodigital_tipo CHECK (tipo IN (N'T', N'A')),
    CONSTRAINT CK_recursodigital_generado_ia CHECK (generado_ia IN (0, 1)),
    CONSTRAINT CK_recursodigital_estado CHECK (estado IN (0, 1)),
    CONSTRAINT fk_recursodigital_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los archivos digitales de un libro: texto para el lector y audio para el audiolibro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del recurso digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro al que pertenece el recurso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'T: Texto (lector digital); A: Audio (audiolibro)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ruta o URL del archivo digital (EPUB, PDF o MP3).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'ruta_archivo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Total de páginas del recurso de texto; NULL en audio.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'total_paginas';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Duración total del audiolibro en segundos; NULL en texto.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'duracion_segundos';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Audio generado con inteligencia artificial a partir del texto; 0: Narración humana o archivo original', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'generado_ia';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de la voz o del narrador del audiolibro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'voz_narracion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que el recurso se publicó en la biblioteca digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'fecha_publicacion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Disponible; 0: Retirado', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'recursodigital', @level2type = N'COLUMN', @level2name = N'estado';
GO

-- >>> DDL/049_capitulorecurso.sql
CREATE TABLE dbo.capitulorecurso (
    id INT IDENTITY(1,1) NOT NULL,
    recurso_digital_id INT NOT NULL,
    numero SMALLINT NOT NULL,
    titulo NVARCHAR(150) NOT NULL,
    posicion_inicio INT NOT NULL,
    CONSTRAINT PK_capitulorecurso PRIMARY KEY (id),
    CONSTRAINT UQ_capitulorecurso_recurso_digital_id_numero UNIQUE (recurso_digital_id, numero),
    CONSTRAINT CK_capitulorecurso_posicion_inicio CHECK (posicion_inicio >= 0),
    CONSTRAINT fk_capitulorecurso_recurso FOREIGN KEY (recurso_digital_id) REFERENCES dbo.recursodigital (id)
);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Índice de capítulos de un recurso digital para navegar en el lector o en el reproductor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del recurso digital al que pertenece el capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'recurso_digital_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Número de orden del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'numero';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Título del capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'titulo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Página (texto) o segundo (audio) donde inicia el capítulo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'capitulorecurso', @level2type = N'COLUMN', @level2name = N'posicion_inicio';
GO

-- >>> DDL/050_progresolectura.sql
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

-- >>> DDL/051_notalectura.sql
CREATE TABLE dbo.notalectura (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    recurso_digital_id INT NOT NULL,
    tipo NVARCHAR(1) NOT NULL,
    posicion INT NOT NULL,
    texto_seleccionado NVARCHAR(500) NULL,
    nota NVARCHAR(500) NULL,
    color NVARCHAR(7) NULL,
    fecha_creacion DATETIME2(0) NOT NULL CONSTRAINT DF_notalectura_fecha_creacion DEFAULT GETDATE(),
    CONSTRAINT PK_notalectura PRIMARY KEY (id),
    CONSTRAINT CK_notalectura_tipo CHECK (tipo IN (N'S', N'N', N'M')),
    CONSTRAINT fk_notalectura_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.cliente (id),
    CONSTRAINT fk_notalectura_recurso FOREIGN KEY (recurso_digital_id) REFERENCES dbo.recursodigital (id)
);

GO

CREATE INDEX IX_notalectura_cliente_id ON dbo.notalectura (cliente_id);
CREATE INDEX IX_notalectura_recurso_digital_id ON dbo.notalectura (recurso_digital_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Guarda los subrayados, notas y marcadores que el cliente crea en el lector digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del cliente que creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'cliente_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del recurso digital donde se creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'recurso_digital_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'S: Subrayado; N: Nota; M: Marcador', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'tipo';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Página o segundo donde se ubica la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'posicion';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fragmento de texto subrayado, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'texto_seleccionado';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Comentario escrito por el cliente, si corresponde.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'nota';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Color del subrayado en formato hexadecimal, por ejemplo #F5C542.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'color';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que se creó la nota.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'notalectura', @level2type = N'COLUMN', @level2name = N'fecha_creacion';
GO

-- >>> DDL/052_listadeseo.sql
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

-- >>> DDL/053_notificacion.sql
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

-- >>> DDL/054_auth_user.sql
CREATE TABLE dbo.auth_user (
    id NVARCHAR(36) NOT NULL,
    name NVARCHAR(120) NOT NULL,
    email NVARCHAR(120) NOT NULL,
    emailVerified BIT NOT NULL CONSTRAINT DF_auth_user_emailVerified DEFAULT 0,
    image NVARCHAR(500) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_user_createdAt DEFAULT GETDATE(),
    updatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_user_updatedAt DEFAULT GETDATE(),
    usuarioId INT NULL,
    CONSTRAINT PK_auth_user PRIMARY KEY (id),
    CONSTRAINT UQ_auth_user_email UNIQUE (email),
    CONSTRAINT fk_auth_user_usuario FOREIGN KEY (usuarioId) REFERENCES dbo.usuario (id)
);

GO

CREATE UNIQUE INDEX UX_auth_user_usuarioId ON dbo.auth_user (usuarioId) WHERE usuarioId IS NOT NULL;
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cuentas de inicio de sesión de Better Auth. Cada una puede enlazarse con un usuario del sistema.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador generado por Better Auth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre que muestra la cuenta.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'name';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Correo con el que se inicia sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'email';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'1: Correo verificado; 0: Sin verificar', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'emailVerified';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección de la foto de perfil.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'image';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de creación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'createdAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última modificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'updatedAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario del sistema enlazado; de él se toman el rol y la persona.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_user', @level2type = N'COLUMN', @level2name = N'usuarioId';
GO

-- >>> DDL/055_auth_session.sql
CREATE TABLE dbo.auth_session (
    id NVARCHAR(36) NOT NULL,
    expiresAt DATETIME2(0) NOT NULL,
    token NVARCHAR(255) NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_session_createdAt DEFAULT GETDATE(),
    updatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_session_updatedAt DEFAULT GETDATE(),
    ipAddress NVARCHAR(100) NULL,
    userAgent NVARCHAR(500) NULL,
    userId NVARCHAR(36) NOT NULL,
    CONSTRAINT PK_auth_session PRIMARY KEY (id),
    CONSTRAINT UQ_auth_session_token UNIQUE (token),
    CONSTRAINT fk_auth_session_user FOREIGN KEY (userId) REFERENCES dbo.auth_user (id) ON DELETE CASCADE
);

GO

CREATE INDEX IX_auth_session_userId ON dbo.auth_session (userId);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Sesiones abiertas de Better Auth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador generado por Better Auth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que vence la sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'expiresAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Token de la sesión que guarda la cookie.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'token';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de creación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'createdAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última modificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'updatedAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Dirección IP desde la que se inició sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'ipAddress';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Navegador o dispositivo desde el que se inició sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'userAgent';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cuenta dueña de la sesión.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_session', @level2type = N'COLUMN', @level2name = N'userId';
GO

-- >>> DDL/056_auth_account.sql
CREATE TABLE dbo.auth_account (
    id NVARCHAR(36) NOT NULL,
    accountId NVARCHAR(255) NOT NULL,
    providerId NVARCHAR(100) NOT NULL,
    userId NVARCHAR(36) NOT NULL,
    accessToken NVARCHAR(MAX) NULL,
    refreshToken NVARCHAR(MAX) NULL,
    idToken NVARCHAR(MAX) NULL,
    accessTokenExpiresAt DATETIME2(0) NULL,
    refreshTokenExpiresAt DATETIME2(0) NULL,
    scope NVARCHAR(500) NULL,
    password NVARCHAR(255) NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_account_createdAt DEFAULT GETDATE(),
    updatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_account_updatedAt DEFAULT GETDATE(),
    CONSTRAINT PK_auth_account PRIMARY KEY (id),
    CONSTRAINT UQ_auth_account_providerId_accountId UNIQUE (providerId, accountId),
    CONSTRAINT fk_auth_account_user FOREIGN KEY (userId) REFERENCES dbo.auth_user (id) ON DELETE CASCADE
);

GO

CREATE INDEX IX_auth_account_userId ON dbo.auth_account (userId);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Formas de acceso de cada cuenta de Better Auth: correo y contraseña o Google.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador generado por Better Auth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la cuenta en el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'accountId';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Proveedor de acceso: credential (correo y contraseña) o google.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'providerId';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cuenta de Better Auth a la que pertenece.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'userId';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Token de acceso entregado por el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'accessToken';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Token para renovar el acceso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'refreshToken';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Token de identidad entregado por el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'idToken';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que vence el token de acceso.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'accessTokenExpiresAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que vence el token de renovación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'refreshTokenExpiresAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Permisos concedidos por el proveedor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'scope';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Contraseña cifrada cuando el acceso es por correo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'password';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de creación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'createdAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última modificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_account', @level2type = N'COLUMN', @level2name = N'updatedAt';
GO

-- >>> DDL/057_auth_verification.sql
CREATE TABLE dbo.auth_verification (
    id NVARCHAR(36) NOT NULL,
    identifier NVARCHAR(255) NOT NULL,
    value NVARCHAR(MAX) NOT NULL,
    expiresAt DATETIME2(0) NOT NULL,
    createdAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_verification_createdAt DEFAULT GETDATE(),
    updatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_auth_verification_updatedAt DEFAULT GETDATE(),
    CONSTRAINT PK_auth_verification PRIMARY KEY (id)
);

GO

CREATE INDEX IX_auth_verification_identifier ON dbo.auth_verification (identifier);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Códigos temporales de Better Auth: verificación de correo y estado del inicio con Google.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador generado por Better Auth.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'A quién o a qué proceso pertenece el código.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'identifier';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Valor del código o del estado temporal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'value';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora en que vence el código.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'expiresAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de creación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'createdAt';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última modificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'auth_verification', @level2type = N'COLUMN', @level2name = N'updatedAt';
GO

-- >>> Vistas/01_vw_clientes_prestamos_vigentes.sql
CREATE OR ALTER VIEW dbo.vw_clientes_prestamos_vigentes
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    ca.credencial_id,
    ca.vencimiento_credencial,
    p.id                                    AS prestamo_id,
    p.fecha_prestamo,
    p.fecha_vencimiento                     AS fecha_limite_devolucion,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), p.fecha_vencimiento) AS dias_restantes,
    l.id                                    AS libro_id,
    l.titulo,
    ej.codigo_barras,
    ep.nombre                               AS estado_prestamo
FROM dbo.prestamo p
INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
INNER JOIN dbo.ejemplar ej        ON ej.id = dp.ejemplar_id
INNER JOIN dbo.libro l            ON l.id = ej.libro_id
INNER JOIN dbo.estadoprestamo ep  ON ep.id = p.estado_prestamo_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
INNER JOIN (
    SELECT c.cliente_id,
           MAX(c.id)                AS credencial_id,
           MAX(c.fecha_vencimiento) AS vencimiento_credencial
    FROM dbo.credencial c
    WHERE c.estado = 'ACTIVA'
      AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
    GROUP BY c.cliente_id
) ca ON ca.cliente_id = cl.id
WHERE NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd WHERE dd.detalle_prestamo_id = dp.id)
  AND p.fecha_vencimiento >= CAST(GETDATE() AS DATE);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clientes con credencial activa y libros prestados sin devolver dentro del plazo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_clientes_prestamos_vigentes';
GO

-- >>> Vistas/02_vw_clientes_prestamos_retrasados.sql
CREATE OR ALTER VIEW dbo.vw_clientes_prestamos_retrasados
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    ca.credencial_id,
    ca.vencimiento_credencial,
    p.id                                    AS prestamo_id,
    p.fecha_prestamo,
    p.fecha_vencimiento                     AS fecha_limite_devolucion,
    DATEDIFF(DAY, p.fecha_vencimiento, CAST(GETDATE() AS DATE)) AS dias_retraso,
    l.id                                    AS libro_id,
    l.titulo,
    ej.codigo_barras,
    ep.nombre                               AS estado_prestamo
FROM dbo.prestamo p
INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
INNER JOIN dbo.ejemplar ej        ON ej.id = dp.ejemplar_id
INNER JOIN dbo.libro l            ON l.id = ej.libro_id
INNER JOIN dbo.estadoprestamo ep  ON ep.id = p.estado_prestamo_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
INNER JOIN (
    SELECT c.cliente_id,
           MAX(c.id)                AS credencial_id,
           MAX(c.fecha_vencimiento) AS vencimiento_credencial
    FROM dbo.credencial c
    WHERE c.estado = 'ACTIVA'
      AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
    GROUP BY c.cliente_id
) ca ON ca.cliente_id = cl.id
WHERE NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd WHERE dd.detalle_prestamo_id = dp.id)
  AND p.fecha_vencimiento < CAST(GETDATE() AS DATE);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Clientes con credencial activa y libros prestados con retraso en la devolución.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_clientes_prestamos_retrasados';
GO

-- >>> Vistas/03_vw_clientes_credenciales_inactivas.sql
CREATE OR ALTER VIEW dbo.vw_clientes_credenciales_inactivas
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    tc.nombre                               AS tipo_cliente,
    c.id                                    AS credencial_id,
    c.fecha_registro,
    c.fecha_vencimiento,
    c.estado                                AS estado_credencial,
    CASE WHEN c.estado = 'ACTIVA' THEN N'VENCIDA POR FECHA' ELSE c.estado END AS situacion,
    CASE WHEN c.fecha_vencimiento < CAST(GETDATE() AS DATE)
         THEN DATEDIFF(DAY, c.fecha_vencimiento, CAST(GETDATE() AS DATE))
         ELSE 0 END                         AS dias_vencida,
    CASE WHEN EXISTS (SELECT 1
                      FROM dbo.credencial c2
                      WHERE c2.cliente_id = c.cliente_id
                        AND c2.estado = 'ACTIVA'
                        AND (c2.fecha_vencimiento IS NULL OR c2.fecha_vencimiento >= CAST(GETDATE() AS DATE)))
         THEN N'SI' ELSE N'NO' END          AS tiene_otra_credencial_activa
FROM dbo.credencial c
INNER JOIN dbo.cliente cl      ON cl.id = c.cliente_id
INNER JOIN dbo.persona pe      ON pe.id = cl.persona_id
INNER JOIN dbo.tipocliente tc  ON tc.id = cl.tipo_cliente_id
WHERE c.estado <> 'ACTIVA'
   OR c.fecha_vencimiento < CAST(GETDATE() AS DATE);

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Credenciales de clientes inactivas, suspendidas o vencidas.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_clientes_credenciales_inactivas';
GO

-- >>> Vistas/04_vw_empleados_credenciales.sql
CREATE OR ALTER VIEW dbo.vw_empleados_credenciales
AS
SELECT
    e.id                                    AS empleado_id,
    e.codigo_empleado,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS empleado,
    pe.correo,
    cg.nombre                               AS cargo,
    u.id                                    AS usuario_id,
    u.nombre_usuario,
    r.nombre                                AS rol,
    CASE WHEN u.id IS NULL THEN N'SIN CUENTA'
         WHEN u.estado = 1 THEN N'ACTIVA'
         ELSE N'INACTIVA' END               AS estado_cuenta,
    u.fecha_creacion                        AS fecha_creacion_cuenta,
    ISNULL(cr.activas, 0)                   AS credenciales_emitidas_activas,
    ISNULL(cr.inactivas, 0)                 AS credenciales_emitidas_inactivas
FROM dbo.empleado e
INNER JOIN dbo.persona pe   ON pe.id = e.persona_id
INNER JOIN dbo.cargo cg     ON cg.id = e.cargo_id
LEFT JOIN dbo.usuario u     ON u.persona_id = e.persona_id
LEFT JOIN dbo.rol r         ON r.id = u.rol_id
LEFT JOIN (
    SELECT c.empleado_id,
           SUM(CASE WHEN c.estado = 'ACTIVA'
                     AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
                    THEN 1 ELSE 0 END) AS activas,
           SUM(CASE WHEN c.estado = 'ACTIVA'
                     AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
                    THEN 0 ELSE 1 END) AS inactivas
    FROM dbo.credencial c
    WHERE c.empleado_id IS NOT NULL
    GROUP BY c.empleado_id
) cr ON cr.empleado_id = e.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Empleados con su cuenta de acceso y las credenciales de clientes que emitieron.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_empleados_credenciales';
GO

-- >>> Vistas/05_vw_historial_cliente.sql
CREATE OR ALTER VIEW dbo.vw_historial_cliente
AS
SELECT
    f.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    N'COMPRA'                               AS tipo_movimiento,
    f.fecha                                 AS fecha_movimiento,
    f.id                                    AS numero_documento,
    l.id                                    AS libro_id,
    l.titulo,
    ed.isbn,
    df.cantidad,
    df.cantidad * df.precio_unitario - df.descuento + df.monto_impuesto AS monto_total,
    CAST(NULL AS DATE)                      AS fecha_limite_devolucion,
    CAST(NULL AS DATETIME2(0))              AS fecha_devolucion,
    N'COMPRADO'                             AS situacion
FROM dbo.factura f
INNER JOIN dbo.detallefactura df ON df.factura_id = f.id
INNER JOIN dbo.libro l           ON l.id = df.libro_id
INNER JOIN dbo.edicion ed        ON ed.id = l.edicion_id
INNER JOIN dbo.cliente cl        ON cl.id = f.cliente_id
INNER JOIN dbo.persona pe        ON pe.id = cl.persona_id

UNION ALL

SELECT
    p.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    N'PRÉSTAMO'                             AS tipo_movimiento,
    CAST(p.fecha_prestamo AS DATETIME2(0))  AS fecha_movimiento,
    p.id                                    AS numero_documento,
    l.id                                    AS libro_id,
    l.titulo,
    ed.isbn,
    1                                       AS cantidad,
    CAST(NULL AS DECIMAL(12,2))             AS monto_total,
    p.fecha_vencimiento                     AS fecha_limite_devolucion,
    dev.fecha_devolucion,
    CASE WHEN dev.id IS NOT NULL THEN N'DEVUELTO'
         WHEN p.fecha_vencimiento < CAST(GETDATE() AS DATE) THEN N'RETRASADO'
         ELSE N'VIGENTE' END                AS situacion
FROM dbo.prestamo p
INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
INNER JOIN dbo.ejemplar ej        ON ej.id = dp.ejemplar_id
INNER JOIN dbo.libro l            ON l.id = ej.libro_id
INNER JOIN dbo.edicion ed         ON ed.id = l.edicion_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
LEFT JOIN dbo.detalledevolucion dd ON dd.detalle_prestamo_id = dp.id
LEFT JOIN dbo.devolucion dev       ON dev.id = dd.devolucion_id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Historial de libros comprados y prestados por cada cliente.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_historial_cliente';
GO

-- >>> Vistas/06_vw_inventario_libros.sql
CREATE OR ALTER VIEW dbo.vw_inventario_libros
AS
SELECT
    l.id                                    AS libro_id,
    l.titulo,
    l.descripcion,
    l.precio_venta,
    l.permite_digital,
    ed.isbn,
    ed.numero_edicion,
    ed.anio_publicacion,
    eo.nombre                               AS editorial,
    i.nombre                                AS idioma,
    fl.nombre                               AS formato,
    (SELECT STRING_AGG(CONCAT_WS(' ', pa.nombre, pa.segundo_nombre, pa.apellido, pa.segundo_apellido), ', ')
                WITHIN GROUP (ORDER BY la.orden_autoria)
     FROM dbo.libroautor la
     INNER JOIN dbo.autor a    ON a.id = la.autor_id
     INNER JOIN dbo.persona pa ON pa.id = a.persona_id
     WHERE la.libro_id = l.id)              AS autores,
    (SELECT STRING_AGG(c.nombre, ', ') WITHIN GROUP (ORDER BY c.nombre)
     FROM dbo.librocategoria lc
     INNER JOIN dbo.categoria c ON c.id = lc.categoria_id
     WHERE lc.libro_id = l.id)              AS categorias,
    ISNULL(ex.total_ejemplares, 0)          AS total_ejemplares,
    ISNULL(ex.ejemplares_disponibles, 0)    AS ejemplares_disponibles,
    ex.costo_promedio_adquisicion,
    ISNULL(inv.disponible, 0)               AS stock_disponible,
    ISNULL(inv.danada, 0)                   AS stock_danado,
    ISNULL(inv.reservada, 0)                AS stock_reservado
FROM dbo.libro l
INNER JOIN dbo.edicion ed        ON ed.id = l.edicion_id
INNER JOIN dbo.editorial eo      ON eo.id = ed.editorial_id
INNER JOIN dbo.idioma i          ON i.id = ed.idioma_id
INNER JOIN dbo.formatolibro fl   ON fl.id = ed.formato_libro_id
LEFT JOIN (
    SELECT ej.libro_id,
           COUNT(*) AS total_ejemplares,
           SUM(CASE WHEN ee.nombre = N'Disponible' THEN 1 ELSE 0 END) AS ejemplares_disponibles,
           AVG(ej.precio_adquisicion) AS costo_promedio_adquisicion
    FROM dbo.ejemplar ej
    INNER JOIN dbo.estadoejemplar ee ON ee.id = ej.estado_ejemplar_id
    GROUP BY ej.libro_id
) ex ON ex.libro_id = l.id
LEFT JOIN (
    SELECT libro_id,
           SUM(cantidad_disponible) AS disponible,
           SUM(cantidad_danada)     AS danada,
           SUM(cantidad_reservada)  AS reservada
    FROM dbo.inventariosucursal
    GROUP BY libro_id
) inv ON inv.libro_id = l.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Información general de cada libro con autores, categorías, ejemplares y stock.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_inventario_libros';
GO

-- >>> Vistas/07_vw_multas_pendientes_cliente.sql
CREATE OR ALTER VIEW dbo.vw_multas_pendientes_cliente
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    pe.correo,
    COUNT(m.id)                             AS cantidad_multas_pendientes,
    SUM(m.monto)                            AS monto_total_pendiente,
    SUM(ISNULL(pg.total_pagado, 0))         AS total_abonado,
    SUM(m.monto - ISNULL(pg.total_pagado, 0)) AS saldo_pendiente,
    MIN(m.fecha_generacion)                 AS multa_mas_antigua
FROM dbo.multa m
INNER JOIN dbo.detalleprestamo dp ON dp.id = m.detalle_prestamo_id
INNER JOIN dbo.prestamo p         ON p.id = dp.prestamo_id
INNER JOIN dbo.cliente cl         ON cl.id = p.cliente_id
INNER JOIN dbo.persona pe         ON pe.id = cl.persona_id
LEFT JOIN (
    SELECT multa_id, SUM(monto) AS total_pagado
    FROM dbo.pagomulta
    GROUP BY multa_id
) pg ON pg.multa_id = m.id
WHERE m.estado = 'PENDIENTE'
GROUP BY cl.id, pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido, pe.correo;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Multas pendientes por cliente con monto total, abonos y saldo.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_multas_pendientes_cliente';
GO

-- >>> Vistas/08_vw_facturas.sql
CREATE OR ALTER VIEW dbo.vw_facturas
AS
SELECT
    t.factura_id,
    t.fecha,
    t.canal,
    t.cliente_id,
    t.cliente,
    t.empleado_id,
    t.empleado,
    t.lineas,
    t.unidades,
    t.subtotal,
    t.descuento_total,
    t.impuesto_total,
    t.total,
    t.formas_pago,
    t.total_pagado,
    t.total - t.total_pagado AS saldo_pendiente,
    CASE WHEN t.total_pagado = 0 THEN N'SIN PAGO'
         WHEN t.total_pagado < t.total THEN N'PAGO PARCIAL'
         ELSE N'PAGADA' END  AS estado_pago
FROM (
    SELECT
        f.id                                AS factura_id,
        f.fecha,
        CASE f.canal WHEN 'L' THEN N'EN LÍNEA' ELSE N'TIENDA' END AS canal,
        f.cliente_id,
        CASE WHEN f.cliente_id IS NULL THEN N'Consumidor final'
             ELSE CONCAT_WS(' ', pc.nombre, pc.segundo_nombre, pc.apellido, pc.segundo_apellido) END AS cliente,
        f.empleado_id,
        CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS empleado,
        ISNULL(d.lineas, 0)                 AS lineas,
        ISNULL(d.unidades, 0)               AS unidades,
        ISNULL(d.subtotal, 0)               AS subtotal,
        ISNULL(d.descuento, 0)              AS descuento_total,
        ISNULL(d.impuesto, 0)               AS impuesto_total,
        ISNULL(d.subtotal, 0) - ISNULL(d.descuento, 0) + ISNULL(d.impuesto, 0) AS total,
        pg.formas_pago,
        ISNULL(pg.total_pagado, 0)          AS total_pagado
    FROM dbo.factura f
    LEFT JOIN dbo.cliente cl   ON cl.id = f.cliente_id
    LEFT JOIN dbo.persona pc   ON pc.id = cl.persona_id
    INNER JOIN dbo.empleado em ON em.id = f.empleado_id
    INNER JOIN dbo.persona pe  ON pe.id = em.persona_id
    LEFT JOIN (
        SELECT factura_id,
               COUNT(*)                          AS lineas,
               SUM(cantidad)                     AS unidades,
               SUM(cantidad * precio_unitario)   AS subtotal,
               SUM(descuento)                    AS descuento,
               SUM(monto_impuesto)               AS impuesto
        FROM dbo.detallefactura
        GROUP BY factura_id
    ) d ON d.factura_id = f.id
    LEFT JOIN (
        SELECT ffp.factura_id,
               SUM(ffp.monto)                    AS total_pagado,
               STRING_AGG(fp.nombre, ', ')       AS formas_pago
        FROM dbo.facturaformapago ffp
        INNER JOIN dbo.formapago fp ON fp.id = ffp.forma_pago_id
        GROUP BY ffp.factura_id
    ) pg ON pg.factura_id = f.id
) t;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Facturas con totales, canal de venta, formas de pago y estado de pago.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_facturas';
GO

-- >>> Vistas/09_vw_inventario_sucursal.sql
CREATE OR ALTER VIEW dbo.vw_inventario_sucursal
AS
SELECT
    s.id                                    AS sucursal_id,
    s.nombre                                AS sucursal,
    s.direccion,
    s.telefono,
    ISNULL(inv.titulos, 0)                  AS titulos_distintos,
    ISNULL(inv.disponible, 0)               AS unidades_disponibles,
    ISNULL(inv.danada, 0)                   AS unidades_danadas,
    ISNULL(inv.reservada, 0)                AS unidades_reservadas,
    ISNULL(inv.disponible, 0) + ISNULL(inv.danada, 0) + ISNULL(inv.reservada, 0) AS total_unidades,
    ISNULL(ex.ejemplares, 0)                AS ejemplares_ubicados,
    inv.ultima_actualizacion
FROM dbo.sucursal s
LEFT JOIN (
    SELECT sucursal_id,
           COUNT(DISTINCT libro_id)    AS titulos,
           SUM(cantidad_disponible)    AS disponible,
           SUM(cantidad_danada)        AS danada,
           SUM(cantidad_reservada)     AS reservada,
           MAX(fecha_actualizacion)    AS ultima_actualizacion
    FROM dbo.inventariosucursal
    GROUP BY sucursal_id
) inv ON inv.sucursal_id = s.id
LEFT JOIN (
    SELECT es.sucursal_id, COUNT(ej.id) AS ejemplares
    FROM dbo.ejemplar ej
    INNER JOIN dbo.cubiculo cu ON cu.id = ej.cubiculo_id
    INNER JOIN dbo.estante es  ON es.id = cu.estante_id
    GROUP BY es.sucursal_id
) ex ON ex.sucursal_id = s.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Unidades disponibles, dañadas y reservadas por sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_inventario_sucursal';
GO

-- >>> Vistas/10_vw_ranking_libros.sql
CREATE OR ALTER VIEW dbo.vw_ranking_libros
AS
SELECT
    x.libro_id,
    x.titulo,
    x.cantidad_prestamos,
    x.cantidad_ventas,
    x.calificacion_promedio,
    x.total_resenas,
    RANK() OVER (ORDER BY x.cantidad_prestamos DESC)    AS ranking_prestamos,
    RANK() OVER (ORDER BY x.cantidad_ventas DESC)       AS ranking_ventas,
    RANK() OVER (ORDER BY x.calificacion_promedio DESC) AS ranking_calificacion,
    RANK() OVER (ORDER BY x.cantidad_prestamos DESC,
                          x.cantidad_ventas DESC,
                          x.calificacion_promedio DESC) AS ranking_general
FROM (
    SELECT
        l.id                                AS libro_id,
        l.titulo,
        ISNULL(pr.cantidad_prestamos, 0)    AS cantidad_prestamos,
        ISNULL(vt.cantidad_ventas, 0)       AS cantidad_ventas,
        rs.calificacion_promedio,
        ISNULL(rs.total_resenas, 0)         AS total_resenas
    FROM dbo.libro l
    LEFT JOIN (
        SELECT ej.libro_id, COUNT(dp.id) AS cantidad_prestamos
        FROM dbo.detalleprestamo dp
        INNER JOIN dbo.ejemplar ej ON ej.id = dp.ejemplar_id
        GROUP BY ej.libro_id
    ) pr ON pr.libro_id = l.id
    LEFT JOIN (
        SELECT libro_id, SUM(cantidad) AS cantidad_ventas
        FROM dbo.detallefactura
        GROUP BY libro_id
    ) vt ON vt.libro_id = l.id
    LEFT JOIN (
        SELECT libro_id,
               CAST(AVG(CAST(calificacion AS DECIMAL(5,2))) AS DECIMAL(4,2)) AS calificacion_promedio,
               COUNT(*) AS total_resenas
        FROM dbo.resenalibro
        WHERE estado = 1
        GROUP BY libro_id
    ) rs ON rs.libro_id = l.id
) x;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ranking de libros por préstamos, ventas y calificación.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ranking_libros';
GO

-- >>> Vistas/11_vw_cliente_limite_prestamos.sql
CREATE OR ALTER VIEW dbo.vw_cliente_limite_prestamos
AS
SELECT
    cl.id                                   AS cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    tc.nombre                               AS tipo_cliente,
    tc.limite_prestamos,
    tc.limite_renovaciones,
    ISNULL(pu.en_uso, 0)                    AS prestamos_en_uso,
    CASE WHEN tc.limite_prestamos - ISNULL(pu.en_uso, 0) > 0
         THEN tc.limite_prestamos - ISNULL(pu.en_uso, 0)
         ELSE 0 END                         AS cupos_disponibles,
    CASE WHEN cr.cliente_id IS NULL THEN N'NO' ELSE N'SI' END AS credencial_activa,
    ISNULL(mp.saldo_pendiente, 0)           AS saldo_multas_pendientes,
    CASE WHEN cr.cliente_id IS NULL THEN N'NO - CREDENCIAL INACTIVA O VENCIDA'
         WHEN ISNULL(mp.saldo_pendiente, 0) > 0 THEN N'NO - MULTAS PENDIENTES'
         WHEN ISNULL(pu.en_uso, 0) >= tc.limite_prestamos THEN N'NO - LÍMITE ALCANZADO'
         ELSE N'SI' END                     AS puede_prestar
FROM dbo.cliente cl
INNER JOIN dbo.persona pe      ON pe.id = cl.persona_id
INNER JOIN dbo.tipocliente tc  ON tc.id = cl.tipo_cliente_id
LEFT JOIN (
    SELECT p.cliente_id, COUNT(dp.id) AS en_uso
    FROM dbo.prestamo p
    INNER JOIN dbo.detalleprestamo dp ON dp.prestamo_id = p.id
    WHERE NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd WHERE dd.detalle_prestamo_id = dp.id)
    GROUP BY p.cliente_id
) pu ON pu.cliente_id = cl.id
LEFT JOIN (
    SELECT DISTINCT c.cliente_id
    FROM dbo.credencial c
    WHERE c.estado = 'ACTIVA'
      AND (c.fecha_vencimiento IS NULL OR c.fecha_vencimiento >= CAST(GETDATE() AS DATE))
) cr ON cr.cliente_id = cl.id
LEFT JOIN dbo.vw_multas_pendientes_cliente mp ON mp.cliente_id = cl.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Préstamos en uso contra el límite de cada cliente e indicador de si puede prestar.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_cliente_limite_prestamos';
GO

-- >>> Vistas/12_vw_reservas_pendientes.sql
CREATE OR ALTER VIEW dbo.vw_reservas_pendientes
AS
SELECT
    r.id                                    AS reserva_id,
    r.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    r.libro_id,
    l.titulo,
    r.fecha_reserva,
    r.fecha_vencimiento,
    ROW_NUMBER() OVER (PARTITION BY r.libro_id ORDER BY r.fecha_reserva) AS posicion_fila,
    COUNT(*) OVER (PARTITION BY r.libro_id) AS total_en_fila,
    ISNULL(ed.disponibles, 0)               AS ejemplares_disponibles
FROM dbo.reserva r
INNER JOIN dbo.cliente cl  ON cl.id = r.cliente_id
INNER JOIN dbo.persona pe  ON pe.id = cl.persona_id
INNER JOIN dbo.libro l     ON l.id = r.libro_id
LEFT JOIN (
    SELECT ej.libro_id, COUNT(*) AS disponibles
    FROM dbo.ejemplar ej
    INNER JOIN dbo.estadoejemplar ee ON ee.id = ej.estado_ejemplar_id
    WHERE ee.nombre = N'Disponible'
    GROUP BY ej.libro_id
) ed ON ed.libro_id = r.libro_id
WHERE r.estado = 'PENDIENTE';

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Reservas pendientes con la posición del cliente en la fila.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_reservas_pendientes';
GO

-- >>> Vistas/13_vw_biblioteca_digital_cliente.sql
CREATE OR ALTER VIEW dbo.vw_biblioteca_digital_cliente
AS
SELECT
    pl.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    l.id                                    AS libro_id,
    l.titulo,
    CASE rd.tipo WHEN 'T' THEN N'TEXTO' ELSE N'AUDIO' END AS tipo_recurso,
    pl.posicion_actual,
    CASE rd.tipo WHEN 'T' THEN rd.total_paginas ELSE rd.duracion_segundos END AS posicion_final,
    pl.porcentaje,
    CASE WHEN pl.porcentaje >= 100 THEN N'TERMINADO'
         WHEN rd.tipo = 'T' THEN N'LEYENDO'
         ELSE N'ESCUCHANDO' END             AS situacion,
    pl.fecha_inicio,
    pl.fecha_ultima_lectura,
    ISNULL(nt.total_notas, 0)               AS total_notas
FROM dbo.progresolectura pl
INNER JOIN dbo.recursodigital rd ON rd.id = pl.recurso_digital_id
INNER JOIN dbo.libro l           ON l.id = rd.libro_id
INNER JOIN dbo.cliente cl        ON cl.id = pl.cliente_id
INNER JOIN dbo.persona pe        ON pe.id = cl.persona_id
LEFT JOIN (
    SELECT nl.cliente_id, nl.recurso_digital_id, COUNT(*) AS total_notas
    FROM dbo.notalectura nl
    GROUP BY nl.cliente_id, nl.recurso_digital_id
) nt ON nt.cliente_id = pl.cliente_id AND nt.recurso_digital_id = pl.recurso_digital_id
WHERE rd.estado = 1;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Avance de lectura y audio de cada cliente en la biblioteca digital.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_biblioteca_digital_cliente';
GO

-- >>> Vistas/14_vw_catalogo_digital.sql
CREATE OR ALTER VIEW dbo.vw_catalogo_digital
AS
SELECT
    l.id                                    AS libro_id,
    l.titulo,
    CASE WHEN rt.id IS NULL THEN N'NO' ELSE N'SI' END AS tiene_texto,
    rt.total_paginas,
    CASE WHEN ra.id IS NULL THEN N'NO' ELSE N'SI' END AS tiene_audio,
    CASE WHEN ra.id IS NULL THEN NULL
         WHEN ra.generado_ia = 1 THEN N'SI' ELSE N'NO' END AS audio_generado_ia,
    ra.voz_narracion,
    CONVERT(VARCHAR(8), DATEADD(SECOND, ra.duracion_segundos, CAST('00:00:00' AS TIME(0))), 108) AS duracion_audio,
    ISNULL(lc.lectores, 0)                  AS lectores,
    lc.avance_promedio
FROM dbo.libro l
LEFT JOIN dbo.recursodigital rt ON rt.libro_id = l.id AND rt.tipo = 'T' AND rt.estado = 1
LEFT JOIN dbo.recursodigital ra ON ra.libro_id = l.id AND ra.tipo = 'A' AND ra.estado = 1
LEFT JOIN (
    SELECT rd.libro_id,
           COUNT(DISTINCT pl.cliente_id)               AS lectores,
           CAST(AVG(pl.porcentaje) AS DECIMAL(5,2))    AS avance_promedio
    FROM dbo.progresolectura pl
    INNER JOIN dbo.recursodigital rd ON rd.id = pl.recurso_digital_id
    GROUP BY rd.libro_id
) lc ON lc.libro_id = l.id
WHERE l.permite_digital = 1;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Libros con derechos digitales: texto, audio, IA, duración y lectores.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_catalogo_digital';
GO

-- >>> Vistas/15_vw_lista_deseos_detalle.sql
CREATE OR ALTER VIEW dbo.vw_lista_deseos_detalle
AS
SELECT
    ld.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    l.id                                    AS libro_id,
    l.titulo,
    l.precio_venta,
    ISNULL(inv.disponible, 0)               AS unidades_disponibles,
    CASE WHEN l.permite_digital = 1 THEN N'SI' ELSE N'NO' END AS disponible_digital,
    CASE WHEN ld.notificar_descuento = 1 THEN N'SI' ELSE N'NO' END AS avisar_descuento,
    ld.fecha_agregado,
    DATEDIFF(DAY, ld.fecha_agregado, CAST(GETDATE() AS DATE)) AS dias_en_lista
FROM dbo.listadeseo ld
INNER JOIN dbo.cliente cl  ON cl.id = ld.cliente_id
INNER JOIN dbo.persona pe  ON pe.id = cl.persona_id
INNER JOIN dbo.libro l     ON l.id = ld.libro_id
LEFT JOIN (
    SELECT libro_id, SUM(cantidad_disponible) AS disponible
    FROM dbo.inventariosucursal
    GROUP BY libro_id
) inv ON inv.libro_id = l.id;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Lista de deseos de cada cliente con precio y disponibilidad.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_lista_deseos_detalle';
GO

-- >>> Vistas/16_vw_ventas_por_canal.sql
CREATE OR ALTER VIEW dbo.vw_ventas_por_canal
AS
SELECT
    CONVERT(CHAR(7), vf.fecha, 120)         AS periodo,
    vf.canal,
    COUNT(*)                                AS facturas,
    SUM(vf.unidades)                        AS unidades_vendidas,
    SUM(vf.subtotal)                        AS subtotal,
    SUM(vf.descuento_total)                 AS descuentos,
    SUM(vf.impuesto_total)                  AS impuestos,
    SUM(vf.total)                           AS total_vendido,
    CAST(AVG(vf.total) AS DECIMAL(10,2))    AS ticket_promedio
FROM dbo.vw_facturas vf
GROUP BY CONVERT(CHAR(7), vf.fecha, 120), vf.canal;

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Ventas por mes separadas en tienda y en línea.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ventas_por_canal';
GO

-- >>> Funciones/fn_calcular_multa.sql
/* ============================================================
   Función: dbo.fn_calcular_multa
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Calcula la multa de un ejemplar prestado: días de atraso
                (fecha de devolución menos vencimiento del préstamo) x L 5.00.
   Parámetros: @detalle_prestamo_id (ejemplar dentro del préstamo),
               @fecha_devolucion (fecha en que se devuelve)
   Devuelve: DECIMAL(10,2), la multa; 0 si no hay atraso o el detalle no existe
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_calcular_multa (@detalle_prestamo_id INT, @fecha_devolucion DATE)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @dias_atraso INT;

    SELECT @dias_atraso = DATEDIFF(DAY, p.fecha_vencimiento, @fecha_devolucion)
    FROM dbo.detalleprestamo d
    INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
    WHERE d.id = @detalle_prestamo_id;

    IF @dias_atraso IS NULL OR @dias_atraso <= 0
        RETURN 0.00;

    RETURN CAST(@dias_atraso * 5.00 AS DECIMAL(10,2));
END
GO

-- >>> Funciones/fn_calcular_porcentaje_progreso.sql
/* ============================================================
   Función: dbo.fn_calcular_porcentaje_progreso
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Calcula qué porcentaje de un recurso digital lleva el
                cliente: página actual entre total de páginas (texto) o
                segundo actual entre duración (audiolibro), por 100.
   Parámetros: @recurso_digital_id (libro digital o audiolibro),
               @posicion (página o segundo donde va el cliente)
   Devuelve: DECIMAL(5,2) entre 0 y 100; 0 si el recurso no existe
             o no tiene total de páginas o duración
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_calcular_porcentaje_progreso (@recurso_digital_id INT, @posicion INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total INT;

    SELECT @total = CASE r.tipo WHEN N'T' THEN r.total_paginas ELSE r.duracion_segundos END
    FROM dbo.recursodigital r
    WHERE r.id = @recurso_digital_id;

    IF @total IS NULL OR @total <= 0 OR @posicion IS NULL OR @posicion <= 0
        RETURN 0.00;

    IF @posicion >= @total
        RETURN 100.00;

    RETURN CAST(@posicion * 100.0 / @total AS DECIMAL(5,2));
END
GO

-- >>> Funciones/fn_ejemplares_disponibles.sql
/* ============================================================
   Función: dbo.fn_ejemplares_disponibles
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Cuenta los ejemplares de un libro con estado 1 (Disponible).
   Parámetros: @libro_id (id del libro)
   Devuelve: INT, cantidad de ejemplares disponibles (0 si no hay o el libro no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_ejemplares_disponibles (@libro_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @resultado INT;

    SELECT @resultado = COUNT(*)
    FROM dbo.ejemplar e
    WHERE e.libro_id = @libro_id
      AND e.estado_ejemplar_id = 1;

    RETURN @resultado;
END
GO

-- >>> Funciones/fn_historial_cliente.sql
-- Función: historial de un cliente específico
CREATE OR ALTER FUNCTION dbo.fn_historial_cliente (@cliente_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM dbo.vw_historial_cliente WHERE cliente_id = @cliente_id
);
GO

-- >>> Funciones/fn_prestamos_activos_cliente.sql
/* ============================================================
   Función: dbo.fn_prestamos_activos_cliente
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Cuenta los préstamos no devueltos de un cliente
                (estados 1 Activo, 3 Vencido, 4 Renovado y 8 En mora).
   Parámetros: @cliente_id (id del cliente)
   Devuelve: INT, cantidad de préstamos no devueltos (0 si no tiene o no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_prestamos_activos_cliente (@cliente_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @resultado INT;

    SELECT @resultado = COUNT(*)
    FROM dbo.prestamo p
    WHERE p.cliente_id = @cliente_id
      AND p.estado_prestamo_id IN (1, 3, 4, 8);

    RETURN @resultado;
END
GO

-- >>> Funciones/fn_puede_prestar.sql
/* ============================================================
   Función: dbo.fn_puede_prestar
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Indica si un cliente puede recibir un préstamo: credencial
                ACTIVA y vigente, sin multas PENDIENTE y por debajo de
                su límite de préstamos (tipocliente.limite_prestamos).
   Parámetros: @cliente_id (id del cliente)
   Devuelve: BIT, 1 si puede prestar; 0 si no (o si el cliente no existe)
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_puede_prestar (@cliente_id INT)
RETURNS BIT
AS
BEGIN
    DECLARE @resultado BIT;

    SELECT @resultado =
        CASE
            WHEN EXISTS (SELECT 1
                         FROM dbo.credencial cr
                         WHERE cr.cliente_id = c.id
                           AND cr.estado = N'ACTIVA'
                           AND cr.fecha_vencimiento >= CAST(GETDATE() AS DATE))
             AND NOT EXISTS (SELECT 1
                             FROM dbo.multa m
                             INNER JOIN dbo.detalleprestamo d ON d.id = m.detalle_prestamo_id
                             INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
                             WHERE p.cliente_id = c.id
                               AND m.estado = N'PENDIENTE')
             AND dbo.fn_prestamos_activos_cliente(c.id) < tc.limite_prestamos
            THEN 1
            ELSE 0
        END
    FROM dbo.cliente c
    INNER JOIN dbo.tipocliente tc ON tc.id = c.tipo_cliente_id
    WHERE c.id = @cliente_id;

    RETURN ISNULL(@resultado, 0);
END
GO

-- >>> Procedimientos/sp_crear_reserva.sql
/* ============================================================
   Procedimiento: dbo.sp_crear_reserva
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Crea una reserva PENDIENTE (tipo R) de un libro sin
                ejemplares disponibles para un cliente que puede prestar.
   Parámetros: @cliente_id, @libro_id
   Devuelve: reserva_id, estado (siempre PENDIENTE al crearla)
   Errores: 50001 El cliente no existe, 50002 El libro no existe,
            50003 El libro tiene ejemplares disponibles; no se puede
            reservar, 50004 El cliente ya tiene una reserva pendiente de
            este libro, 50005 El cliente no puede reservar porque no
            cumple las condiciones para préstamo
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_crear_reserva
    @cliente_id INT,
    @libro_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @reserva_id INT;
    DECLARE @estado NVARCHAR(30);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.libro l WHERE l.id = @libro_id)
        THROW 50002, N'El libro no existe.', 1;

    IF EXISTS (SELECT 1 FROM dbo.ejemplar e
               WHERE e.libro_id = @libro_id AND e.estado_ejemplar_id = @estado_disponible)
        THROW 50003, N'El libro tiene ejemplares disponibles; no se puede reservar.', 1;

    IF EXISTS (SELECT 1 FROM dbo.reserva r
               WHERE r.cliente_id = @cliente_id AND r.libro_id = @libro_id AND r.estado = N'PENDIENTE')
        THROW 50004, N'El cliente ya tiene una reserva pendiente de este libro.', 1;

    IF dbo.fn_puede_prestar(@cliente_id) = 0
        THROW 50005, N'El cliente no puede reservar porque no cumple las condiciones para préstamo.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.reserva (cliente_id, libro_id)
            VALUES (@cliente_id, @libro_id);
            SET @reserva_id = SCOPE_IDENTITY();

            SELECT @estado = r.estado FROM dbo.reserva r WHERE r.id = @reserva_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @reserva_id AS reserva_id,
               @estado AS estado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_guardar_progreso_lectura.sql
/* ============================================================
   Procedimiento: dbo.sp_guardar_progreso_lectura
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Guarda dónde va el cliente en un libro digital o
                audiolibro. Si es la primera vez crea el progreso; si no,
                lo actualiza. Calcula el porcentaje y el capítulo actual.
   Parámetros: @cliente_id (quien lee o escucha),
               @recurso_digital_id (libro digital o audiolibro),
               @posicion (página o segundo actual)
   Devuelve: progreso_id, posicion_actual, porcentaje, capitulo_numero,
             capitulo_titulo (NULL si el recurso no tiene capítulos)
   Errores: 50001 El cliente no existe, 50002 El recurso digital no
            existe o fue retirado, 50003 La posición no es válida
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_guardar_progreso_lectura
    @cliente_id INT,
    @recurso_digital_id INT,
    @posicion INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @total INT;
    DECLARE @porcentaje DECIMAL(5,2);
    DECLARE @progreso_id INT;
    DECLARE @capitulo_numero SMALLINT;
    DECLARE @capitulo_titulo NVARCHAR(150);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    SELECT @total = CASE r.tipo WHEN N'T' THEN r.total_paginas ELSE r.duracion_segundos END
    FROM dbo.recursodigital r
    WHERE r.id = @recurso_digital_id AND r.estado = 1;

    IF @@ROWCOUNT = 0
        THROW 50002, N'El recurso digital no existe o fue retirado.', 1;

    IF @posicion IS NULL OR @posicion < 0 OR (@total IS NOT NULL AND @posicion > @total)
        THROW 50003, N'La posición no es válida para este recurso.', 1;

    SET @porcentaje = dbo.fn_calcular_porcentaje_progreso(@recurso_digital_id, @posicion);

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            SELECT @progreso_id = pl.id
            FROM dbo.progresolectura pl WITH (UPDLOCK, HOLDLOCK)
            WHERE pl.cliente_id = @cliente_id AND pl.recurso_digital_id = @recurso_digital_id;

            IF @progreso_id IS NULL
            BEGIN
                INSERT INTO dbo.progresolectura (cliente_id, recurso_digital_id, posicion_actual, porcentaje)
                VALUES (@cliente_id, @recurso_digital_id, @posicion, @porcentaje);
                SET @progreso_id = SCOPE_IDENTITY();
            END
            ELSE
                UPDATE dbo.progresolectura
                SET posicion_actual = @posicion,
                    porcentaje = @porcentaje,
                    fecha_ultima_lectura = GETDATE()
                WHERE id = @progreso_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT TOP 1 @capitulo_numero = cr.numero, @capitulo_titulo = cr.titulo
        FROM dbo.capitulorecurso cr
        WHERE cr.recurso_digital_id = @recurso_digital_id AND cr.posicion_inicio <= @posicion
        ORDER BY cr.posicion_inicio DESC;

        SELECT @progreso_id AS progreso_id,
               @posicion AS posicion_actual,
               @porcentaje AS porcentaje,
               @capitulo_numero AS capitulo_numero,
               @capitulo_titulo AS capitulo_titulo;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_audiolibro.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_audiolibro
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Publica el audiolibro de un libro con sus capítulos.
                Si el libro tuvo un audiolibro retirado, lo reemplaza y
                lo vuelve a activar.
   Parámetros: @libro_id, @ruta_archivo (ruta o URL del MP3),
               @duracion_segundos, @generado_ia (1: Generado con IA;
               0: Grabado), @voz_narracion (nombre de la voz; opcional),
               @capitulos (JSON opcional, ej.
               '[{"numero":1,"titulo":"Capítulo 1","posicion_inicio":0}]')
   Devuelve: recurso_digital_id, libro_id, duracion_segundos,
             capitulos (cantidad registrada)
   Errores: 50001 El libro no existe, 50002 La duración debe ser mayor
            que 0, 50003 El libro ya tiene un audiolibro activo,
            50004 Los capítulos no tienen un formato válido,
            50005 Un capítulo empieza fuera de la duración del audio,
            50006 generado_ia debe ser 0 o 1
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_audiolibro
    @libro_id INT,
    @ruta_archivo NVARCHAR(300),
    @duracion_segundos INT,
    @generado_ia SMALLINT = 1,
    @voz_narracion NVARCHAR(60) = NULL,
    @capitulos NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @recurso_id INT;
    DECLARE @estado_actual SMALLINT;
    DECLARE @lista TABLE (numero SMALLINT, titulo NVARCHAR(150), posicion_inicio INT);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.libro l WHERE l.id = @libro_id)
        THROW 50001, N'El libro no existe.', 1;

    IF @duracion_segundos IS NULL OR @duracion_segundos <= 0
        THROW 50002, N'La duración debe ser mayor que 0.', 1;

    SELECT @recurso_id = r.id, @estado_actual = r.estado
    FROM dbo.recursodigital r
    WHERE r.libro_id = @libro_id AND r.tipo = N'A';

    IF @estado_actual = 1
        THROW 50003, N'El libro ya tiene un audiolibro activo; retírelo antes de publicar otro.', 1;

    IF @capitulos IS NOT NULL
    BEGIN
        IF ISJSON(@capitulos) = 0
            THROW 50004, N'Los capítulos no tienen un formato válido.', 1;

        INSERT INTO @lista (numero, titulo, posicion_inicio)
        SELECT j.numero, j.titulo, j.posicion_inicio
        FROM OPENJSON(@capitulos)
            WITH (numero SMALLINT, titulo NVARCHAR(150), posicion_inicio INT) j;

        IF EXISTS (SELECT 1 FROM @lista c WHERE c.numero IS NULL OR c.titulo IS NULL OR c.posicion_inicio IS NULL)
           OR EXISTS (SELECT c.numero FROM @lista c GROUP BY c.numero HAVING COUNT(*) > 1)
            THROW 50004, N'Los capítulos no tienen un formato válido.', 1;

        IF EXISTS (SELECT 1 FROM @lista c WHERE c.posicion_inicio < 0 OR c.posicion_inicio >= @duracion_segundos)
            THROW 50005, N'Un capítulo empieza fuera de la duración del audio.', 1;
    END

    IF @generado_ia IS NULL OR @generado_ia NOT IN (0, 1)
        THROW 50006, N'generado_ia debe ser 0 o 1.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            IF @recurso_id IS NULL
            BEGIN
                INSERT INTO dbo.recursodigital (libro_id, tipo, ruta_archivo, total_paginas, duracion_segundos, generado_ia, voz_narracion)
                VALUES (@libro_id, N'A', @ruta_archivo, NULL, @duracion_segundos, @generado_ia, @voz_narracion);
                SET @recurso_id = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                UPDATE dbo.recursodigital
                SET ruta_archivo = @ruta_archivo,
                    duracion_segundos = @duracion_segundos,
                    generado_ia = @generado_ia,
                    voz_narracion = @voz_narracion,
                    fecha_publicacion = GETDATE(),
                    estado = 1
                WHERE id = @recurso_id;

                DELETE FROM dbo.capitulorecurso WHERE recurso_digital_id = @recurso_id;
            END

            INSERT INTO dbo.capitulorecurso (recurso_digital_id, numero, titulo, posicion_inicio)
            SELECT @recurso_id, c.numero, c.titulo, c.posicion_inicio
            FROM @lista c;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @recurso_id AS recurso_digital_id,
               @libro_id AS libro_id,
               @duracion_segundos AS duracion_segundos,
               (SELECT COUNT(*) FROM @lista) AS capitulos;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_cliente.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_cliente
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Registra un cliente completo en una transacción: persona,
                teléfono, cliente, credencial ACTIVA por un año y usuario
                con rol Cliente.
   Parámetros: @nombre, @segundo_nombre, @apellido, @segundo_apellido,
               @correo, @genero (M o F), @fecha_nacimiento, @telefono,
               @tipo_telefono (P, L o F), @tipo_cliente_id,
               @nombre_usuario, @contrasena_hash (lo calcula la API),
               @empleado_id (quien registra; opcional)
   Devuelve: cliente_id, persona_id, credencial_id, usuario_id,
             fecha_vencimiento (de la credencial)
   Errores: 50001 El correo ya está registrado, 50002 El tipo de cliente
            no existe, 50003 El empleado no existe, 50004 El nombre de
            usuario ya existe, 50005 El tipo de teléfono no es válido,
            50006 El género no es válido
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_cliente
    @nombre NVARCHAR(60),
    @segundo_nombre NVARCHAR(60) = NULL,
    @apellido NVARCHAR(60),
    @segundo_apellido NVARCHAR(60) = NULL,
    @correo NVARCHAR(120),
    @genero NCHAR(1) = NULL,
    @fecha_nacimiento DATE = NULL,
    @telefono NVARCHAR(25),
    @tipo_telefono NVARCHAR(1),
    @tipo_cliente_id INT,
    @nombre_usuario NVARCHAR(50),
    @contrasena_hash NVARCHAR(255),
    @empleado_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @rol_cliente_id INT = 16;  -- rol Cliente
    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @fecha_vencimiento DATE = DATEADD(YEAR, 1, @hoy);
    DECLARE @persona_id INT;
    DECLARE @cliente_id INT;
    DECLARE @credencial_id INT;
    DECLARE @usuario_id INT;

    -- 1. Validaciones (antes de escribir nada)
    IF EXISTS (SELECT 1 FROM dbo.persona p WHERE p.correo = @correo)
        THROW 50001, N'El correo ya está registrado.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.tipocliente tc WHERE tc.id = @tipo_cliente_id)
        THROW 50002, N'El tipo de cliente no existe.', 1;

    IF @empleado_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50003, N'El empleado no existe.', 1;

    IF EXISTS (SELECT 1 FROM dbo.usuario u WHERE u.nombre_usuario = @nombre_usuario)
        THROW 50004, N'El nombre de usuario ya existe.', 1;

    IF @tipo_telefono NOT IN (N'P', N'L', N'F')
        THROW 50005, N'El tipo de teléfono no es válido; use P, L o F.', 1;

    IF @genero IS NOT NULL AND @genero NOT IN (N'M', N'F')
        THROW 50006, N'El género no es válido; use M o F.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.persona (nombre, segundo_nombre, apellido, segundo_apellido, correo, genero, fecha_nacimiento)
            VALUES (@nombre, @segundo_nombre, @apellido, @segundo_apellido, @correo, @genero, @fecha_nacimiento);
            SET @persona_id = SCOPE_IDENTITY();

            INSERT INTO dbo.telefono (numero, persona_id, tipo)
            VALUES (@telefono, @persona_id, @tipo_telefono);

            INSERT INTO dbo.cliente (fecha_registro, persona_id, tipo_cliente_id)
            VALUES (@hoy, @persona_id, @tipo_cliente_id);
            SET @cliente_id = SCOPE_IDENTITY();

            INSERT INTO dbo.credencial (fecha_registro, fecha_vencimiento, estado, cliente_id, empleado_id)
            VALUES (@hoy, @fecha_vencimiento, N'ACTIVA', @cliente_id, @empleado_id);
            SET @credencial_id = SCOPE_IDENTITY();

            INSERT INTO dbo.usuario (nombre_usuario, contrasena_hash, persona_id, rol_id)
            VALUES (@nombre_usuario, @contrasena_hash, @persona_id, @rol_cliente_id);
            SET @usuario_id = SCOPE_IDENTITY();
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @cliente_id AS cliente_id,
               @persona_id AS persona_id,
               @credencial_id AS credencial_id,
               @usuario_id AS usuario_id,
               @fecha_vencimiento AS fecha_vencimiento;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_compra_proveedor.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_compra_proveedor
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra una compra a un proveedor en una transacción:
                compra, detalle, existencias de la sucursal (suma al
                inventario) y movimiento ENTRADA por cada libro.
   Parámetros: @proveedor_id, @empleado_id, @sucursal_id,
               @numero_factura (opcional), @detalle (JSON, ej.
               '[{"libro_id":3,"cantidad":10,"costo_unitario":120.00}]')
   Devuelve: compra_proveedor_id, total
   Errores: 50001 El proveedor no existe, 50002 El empleado no existe,
            50003 La sucursal no existe, 50004 Debe indicar al menos un
            libro, 50005 Uno de los libros no existe, 50006 La cantidad
            y el costo deben ser mayores a cero
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_compra_proveedor
    @proveedor_id INT,
    @empleado_id INT,
    @sucursal_id INT,
    @numero_factura NVARCHAR(40) = NULL,
    @detalle NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @compra_id INT;
    DECLARE @total DECIMAL(10,2);
    DECLARE @lineas TABLE (libro_id INT NULL, cantidad INT NULL, costo_unitario DECIMAL(10,2) NULL);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.proveedor p WHERE p.id = @proveedor_id)
        THROW 50001, N'El proveedor no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50002, N'El empleado no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.sucursal s WHERE s.id = @sucursal_id)
        THROW 50003, N'La sucursal no existe.', 1;

    IF @detalle IS NULL OR ISJSON(@detalle) = 0
        THROW 50004, N'Debe indicar al menos un libro.', 1;

    INSERT INTO @lineas (libro_id, cantidad, costo_unitario)
    SELECT j.libro_id, j.cantidad, j.costo_unitario
    FROM OPENJSON(@detalle)
         WITH (libro_id INT '$.libro_id',
               cantidad INT '$.cantidad',
               costo_unitario DECIMAL(10,2) '$.costo_unitario') j;

    IF NOT EXISTS (SELECT 1 FROM @lineas)
        THROW 50004, N'Debe indicar al menos un libro.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.libro_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.libro b WHERE b.id = l.libro_id))
        THROW 50005, N'Uno de los libros no existe.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.cantidad IS NULL OR l.cantidad <= 0
                  OR l.costo_unitario IS NULL OR l.costo_unitario <= 0)
        THROW 50006, N'La cantidad y el costo deben ser mayores a cero.', 1;

    SELECT @total = SUM(l.cantidad * l.costo_unitario) FROM @lineas l;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.compraproveedor (fecha_compra, numero_factura, proveedor_id, empleado_id)
            VALUES (@hoy, @numero_factura, @proveedor_id, @empleado_id);
            SET @compra_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detallecompra (compra_proveedor_id, libro_id, cantidad, costo_unitario)
            SELECT @compra_id, l.libro_id, l.cantidad, l.costo_unitario
            FROM @lineas l;

            -- Inventario: suma a la fila existente o crea la del libro en la sucursal
            UPDATE i
            SET cantidad_disponible = i.cantidad_disponible + t.cantidad
            FROM dbo.inventariosucursal i
            INNER JOIN (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t
                    ON t.libro_id = i.libro_id
            WHERE i.sucursal_id = @sucursal_id;

            INSERT INTO dbo.inventariosucursal (sucursal_id, libro_id, cantidad_disponible)
            SELECT @sucursal_id, t.libro_id, t.cantidad
            FROM (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t
            WHERE NOT EXISTS (SELECT 1 FROM dbo.inventariosucursal i
                              WHERE i.sucursal_id = @sucursal_id AND i.libro_id = t.libro_id);

            INSERT INTO dbo.movimientoinventario (sucursal_id, ejemplar_id, empleado_id, tipo_movimiento, cantidad, observacion)
            SELECT @sucursal_id, NULL, @empleado_id, N'ENTRADA', t.cantidad,
                   CONCAT(N'Compra a proveedor ', @compra_id, N', libro ', t.libro_id)
            FROM (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @compra_id AS compra_proveedor_id,
               @total AS total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_devolucion.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_devolucion
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra la devolución de uno o varios ejemplares en una
                transacción: devolución y detalle, multa automática por
                atraso (fn_calcular_multa), estado del ejemplar, estado del
                préstamo (Devuelto o Parcialmente devuelto), historial y
                reserva en espera (el ejemplar queda apartado para la
                reserva pendiente más antigua de ese libro).
   Parámetros: @empleado_id, @ejemplares (JSON, ej.
               '[{"ejemplar_id":5,"condicion_entrega":"Buen estado"}]'),
               @observacion (opcional)
   Devuelve: devolucion_id, multa_total (0 si no hubo atraso)
   Errores: 50001 El empleado no existe, 50002 Debe indicar al menos un
            ejemplar, 50003 Uno de los ejemplares no tiene un préstamo
            pendiente de devolución
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_devolucion
    @empleado_id INT,
    @ejemplares NVARCHAR(MAX),
    @observacion NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @ahora DATETIME2(0) = CAST(GETDATE() AS DATETIME2(0));
    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @estado_reservado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Reservado');
    DECLARE @estado_danado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Dañado');
    DECLARE @estado_devuelto INT = 2;   -- Devuelto
    DECLARE @estado_parcial INT = 12;   -- Parcialmente devuelto
    DECLARE @devolucion_id INT;
    DECLARE @multa_total DECIMAL(10,2);

    DECLARE @items TABLE (
        ejemplar_id INT PRIMARY KEY,
        condicion_entrega NVARCHAR(40) NOT NULL,
        detalle_prestamo_id INT NULL,
        prestamo_id INT NULL,
        multa DECIMAL(10,2) NOT NULL DEFAULT 0,
        estado_nuevo INT NULL
    );
    DECLARE @prestamos TABLE (prestamo_id INT PRIMARY KEY, estado_anterior INT, estado_nuevo INT);
    DECLARE @reservados TABLE (ejemplar_id INT);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50001, N'El empleado no existe.', 1;

    IF @ejemplares IS NULL OR ISJSON(@ejemplares) = 0
        THROW 50002, N'Debe indicar al menos un ejemplar.', 1;

    INSERT INTO @items (ejemplar_id, condicion_entrega)
    SELECT j.ejemplar_id,
           MAX(ISNULL(NULLIF(LTRIM(RTRIM(j.condicion_entrega)), N''), N'Buen estado'))
    FROM OPENJSON(@ejemplares)
         WITH (ejemplar_id INT '$.ejemplar_id',
               condicion_entrega NVARCHAR(40) '$.condicion_entrega') j
    WHERE j.ejemplar_id IS NOT NULL
    GROUP BY j.ejemplar_id;

    IF NOT EXISTS (SELECT 1 FROM @items)
        THROW 50002, N'Debe indicar al menos un ejemplar.', 1;

    -- Préstamo abierto de cada ejemplar: el último detalle sin devolución
    -- (estados 1 Activo, 3, 4 Renovado, 8 En mora, 11, 12 y 14)
    UPDATE it
    SET detalle_prestamo_id = x.id,
        prestamo_id = x.prestamo_id
    FROM @items it
    CROSS APPLY (SELECT TOP 1 d.id, d.prestamo_id
                 FROM dbo.detalleprestamo d
                 INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
                 WHERE d.ejemplar_id = it.ejemplar_id
                   AND p.estado_prestamo_id IN (1, 3, 4, 8, 11, 12, 14)
                   AND NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd
                                   WHERE dd.detalle_prestamo_id = d.id)
                 ORDER BY d.id DESC) x;

    IF EXISTS (SELECT 1 FROM @items WHERE detalle_prestamo_id IS NULL)
        THROW 50003, N'Uno de los ejemplares no tiene un préstamo pendiente de devolución.', 1;

    UPDATE @items
    SET multa = dbo.fn_calcular_multa(detalle_prestamo_id, @hoy),
        estado_nuevo = CASE WHEN condicion_entrega LIKE N'%dañ%'
                            THEN @estado_danado ELSE @estado_disponible END;

    SELECT @multa_total = ISNULL(SUM(multa), 0) FROM @items;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.devolucion (fecha_devolucion, observacion, empleado_id)
            VALUES (@ahora, @observacion, @empleado_id);
            SET @devolucion_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detalledevolucion (devolucion_id, detalle_prestamo_id, condicion_entrega)
            SELECT @devolucion_id, it.detalle_prestamo_id, it.condicion_entrega
            FROM @items it;

            -- Multa automática por atraso
            INSERT INTO dbo.multa (fecha_generacion, monto, motivo, detalle_prestamo_id)
            SELECT @hoy, it.multa, N'Atraso en la devolución', it.detalle_prestamo_id
            FROM @items it
            WHERE it.multa > 0;

            -- Estado del ejemplar
            UPDATE e
            SET estado_ejemplar_id = it.estado_nuevo
            FROM dbo.ejemplar e
            INNER JOIN @items it ON it.ejemplar_id = e.id;

            -- Reserva en espera: el ejemplar disponible se aparta para la
            -- reserva pendiente más antigua de su libro
            ;WITH ej AS (
                SELECT it.ejemplar_id, e.libro_id,
                       ROW_NUMBER() OVER (PARTITION BY e.libro_id ORDER BY it.ejemplar_id) AS rn
                FROM @items it
                INNER JOIN dbo.ejemplar e ON e.id = it.ejemplar_id
                WHERE it.estado_nuevo = @estado_disponible
            ),
            rs AS (
                SELECT r.id, r.libro_id,
                       ROW_NUMBER() OVER (PARTITION BY r.libro_id ORDER BY r.fecha_reserva, r.id) AS rn
                FROM dbo.reserva r
                WHERE r.estado = N'PENDIENTE' AND r.tipo = N'R' AND r.ejemplar_id IS NULL
            )
            UPDATE r
            SET r.ejemplar_id = ej.ejemplar_id
            OUTPUT inserted.ejemplar_id INTO @reservados (ejemplar_id)
            FROM dbo.reserva r
            INNER JOIN rs ON rs.id = r.id
            INNER JOIN ej ON ej.libro_id = rs.libro_id AND ej.rn = rs.rn;

            UPDATE dbo.ejemplar
            SET estado_ejemplar_id = @estado_reservado
            WHERE id IN (SELECT ejemplar_id FROM @reservados);

            -- Estado del préstamo: Devuelto si ya no le quedan ejemplares
            INSERT INTO @prestamos (prestamo_id, estado_anterior, estado_nuevo)
            SELECT DISTINCT it.prestamo_id, p.estado_prestamo_id,
                   CASE WHEN NOT EXISTS (SELECT 1
                                         FROM dbo.detalleprestamo d
                                         WHERE d.prestamo_id = it.prestamo_id
                                           AND NOT EXISTS (SELECT 1 FROM dbo.detalledevolucion dd
                                                           WHERE dd.detalle_prestamo_id = d.id))
                        THEN @estado_devuelto ELSE @estado_parcial END
            FROM @items it
            INNER JOIN dbo.prestamo p ON p.id = it.prestamo_id;

            UPDATE p
            SET estado_prestamo_id = pr.estado_nuevo
            FROM dbo.prestamo p
            INNER JOIN @prestamos pr ON pr.prestamo_id = p.id;

            INSERT INTO dbo.historialprestamo (prestamo_id, empleado_id, estado_anterior, estado_nuevo, observacion)
            SELECT pr.prestamo_id, @empleado_id, ea.nombre, en.nombre, N'Devolución registrada'
            FROM @prestamos pr
            INNER JOIN dbo.estadoprestamo ea ON ea.id = pr.estado_anterior
            INNER JOIN dbo.estadoprestamo en ON en.id = pr.estado_nuevo;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @devolucion_id AS devolucion_id,
               @multa_total AS multa_total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_prestamo.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_prestamo
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra un préstamo de uno o varios ejemplares en una
                transacción: préstamo Activo a 15 días, detalle, ejemplares
                en estado Prestado e historial.
   Parámetros: @cliente_id, @empleado_id, @ejemplares (JSON con ids de
               ejemplar, ej. '[5,12]'), @observacion (opcional)
   Devuelve: prestamo_id, fecha_vencimiento
   Errores: 50001 El cliente no existe, 50002 La credencial no está activa
            o está vencida, 50003 El cliente tiene multas pendientes,
            50004 El cliente alcanzó su límite de préstamos, 50005 Uno de
            los ejemplares no está disponible, 50006 El empleado no existe,
            50007 Debe indicar al menos un ejemplar (JSON válido)
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_prestamo
    @cliente_id INT,
    @empleado_id INT,
    @ejemplares NVARCHAR(MAX),
    @observacion NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @dias_prestamo INT = 15;
    DECLARE @fecha_vencimiento DATE = DATEADD(DAY, @dias_prestamo, @hoy);
    DECLARE @estado_prestamo_activo INT = 1;  -- Activo
    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @estado_prestado INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Prestado');
    DECLARE @nombre_estado NVARCHAR(30) = (SELECT nombre FROM dbo.estadoprestamo WHERE id = @estado_prestamo_activo);
    DECLARE @prestamo_id INT;
    DECLARE @total INT;
    DECLARE @ids TABLE (ejemplar_id INT PRIMARY KEY);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50006, N'El empleado no existe.', 1;

    IF @ejemplares IS NULL OR ISJSON(@ejemplares) = 0
        THROW 50007, N'Debe indicar al menos un ejemplar (JSON válido, ej. [5,12]).', 1;

    INSERT INTO @ids (ejemplar_id)
    SELECT DISTINCT TRY_CAST(j.value AS INT)
    FROM OPENJSON(@ejemplares) j
    WHERE TRY_CAST(j.value AS INT) IS NOT NULL;

    SELECT @total = COUNT(*) FROM @ids;
    IF @total = 0
        THROW 50007, N'Debe indicar al menos un ejemplar (JSON válido, ej. [5,12]).', 1;

    IF NOT EXISTS (SELECT 1
                   FROM dbo.credencial cr
                   WHERE cr.cliente_id = @cliente_id
                     AND cr.estado = N'ACTIVA'
                     AND cr.fecha_vencimiento >= @hoy)
        THROW 50002, N'La credencial no está activa o está vencida.', 1;

    IF EXISTS (SELECT 1
               FROM dbo.multa m
               INNER JOIN dbo.detalleprestamo d ON d.id = m.detalle_prestamo_id
               INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
               WHERE p.cliente_id = @cliente_id
                 AND m.estado = N'PENDIENTE')
        THROW 50003, N'El cliente tiene multas pendientes.', 1;

    IF dbo.fn_prestamos_activos_cliente(@cliente_id) >=
       (SELECT tc.limite_prestamos
        FROM dbo.cliente c
        INNER JOIN dbo.tipocliente tc ON tc.id = c.tipo_cliente_id
        WHERE c.id = @cliente_id)
        THROW 50004, N'El cliente alcanzó su límite de préstamos.', 1;

    IF EXISTS (SELECT 1
               FROM @ids i
               WHERE NOT EXISTS (SELECT 1
                                 FROM dbo.ejemplar e
                                 WHERE e.id = i.ejemplar_id
                                   AND e.estado_ejemplar_id = @estado_disponible))
        THROW 50005, N'Uno de los ejemplares no está disponible.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.prestamo (fecha_prestamo, fecha_vencimiento, observacion, cliente_id, empleado_id, estado_prestamo_id)
            VALUES (@hoy, @fecha_vencimiento, @observacion, @cliente_id, @empleado_id, @estado_prestamo_activo);
            SET @prestamo_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detalleprestamo (prestamo_id, ejemplar_id)
            SELECT @prestamo_id, i.ejemplar_id FROM @ids i;

            -- Solo pasan a Prestado los que siguen disponibles (evita choques entre dos cajas)
            UPDATE dbo.ejemplar
            SET estado_ejemplar_id = @estado_prestado
            WHERE id IN (SELECT i.ejemplar_id FROM @ids i)
              AND estado_ejemplar_id = @estado_disponible;

            IF @@ROWCOUNT <> @total
                THROW 50005, N'Uno de los ejemplares no está disponible.', 1;

            INSERT INTO dbo.historialprestamo (prestamo_id, empleado_id, estado_anterior, estado_nuevo, observacion)
            VALUES (@prestamo_id, @empleado_id, NULL, @nombre_estado, N'Préstamo registrado');
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @prestamo_id AS prestamo_id,
               @fecha_vencimiento AS fecha_vencimiento;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_registrar_venta.sql
/* ============================================================
   Procedimiento: dbo.sp_registrar_venta
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra una venta en una transacción: factura, detalle
                (precio, descuento e impuesto por línea), formas de pago
                e inventario de la sucursal (descuenta existencias y
                registra el movimiento SALIDA).
   Parámetros: @empleado_id, @sucursal_id, @cliente_id (opcional),
               @detalle (JSON, ej. '[{"libro_id":3,"cantidad":2,
               "descuento_id":null,"impuesto_id":1}]'),
               @pagos (JSON, ej. '[{"forma_pago_id":1,"monto":250.00,
               "referencia":null}]'), @canal (T: tienda; L: en línea;
               por defecto T)
   Devuelve: factura_id, subtotal, descuento_total, impuesto_total, total
   Errores: 50001 El empleado no existe, 50002 La sucursal no existe,
            50003 El cliente no existe, 50004 Debe indicar al menos un
            libro y una forma de pago, 50005 Uno de los libros no existe,
            50006 No hay existencias suficientes en la sucursal, 50007 La
            suma de los pagos no coincide con el total, 50008 El descuento
            no existe, no está activo o no está vigente, 50009 El impuesto
            no existe o no está vigente, 50010 La forma de pago no existe,
            50011 La cantidad de cada libro debe ser mayor a cero,
            50012 El canal no es válido, 50013 Una forma de pago no puede
            repetirse, 50014 Uno de los libros no tiene precio de venta,
            50015 El monto de cada pago debe ser mayor a cero
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_venta
    @empleado_id INT,
    @sucursal_id INT,
    @cliente_id INT = NULL,
    @detalle NVARCHAR(MAX),
    @pagos NVARCHAR(MAX),
    @canal NVARCHAR(1) = N'T'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @ahora DATETIME2(0) = CAST(GETDATE() AS DATETIME2(0));
    DECLARE @factura_id INT;
    DECLARE @subtotal DECIMAL(10,2);
    DECLARE @descuento_total DECIMAL(10,2);
    DECLARE @impuesto_total DECIMAL(10,2);
    DECLARE @total DECIMAL(10,2);
    DECLARE @suma_pagos DECIMAL(10,2);
    DECLARE @filas INT;

    DECLARE @lineas TABLE (
        linea INT IDENTITY(1,1) PRIMARY KEY,
        libro_id INT NULL,
        cantidad INT NULL,
        descuento_id INT NULL,
        impuesto_id INT NULL,
        precio_unitario DECIMAL(10,2) NULL,
        descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
        monto_impuesto DECIMAL(10,2) NOT NULL DEFAULT 0
    );
    DECLARE @pagos_t TABLE (forma_pago_id INT NULL, monto DECIMAL(10,2) NULL, referencia NVARCHAR(80) NULL);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50001, N'El empleado no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.sucursal s WHERE s.id = @sucursal_id)
        THROW 50002, N'La sucursal no existe.', 1;

    IF @cliente_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50003, N'El cliente no existe.', 1;

    IF @canal IS NULL OR @canal NOT IN (N'T', N'L')
        THROW 50012, N'El canal no es válido; use T o L.', 1;

    IF @detalle IS NULL OR ISJSON(@detalle) = 0 OR @pagos IS NULL OR ISJSON(@pagos) = 0
        THROW 50004, N'Debe indicar al menos un libro y una forma de pago.', 1;

    INSERT INTO @lineas (libro_id, cantidad, descuento_id, impuesto_id)
    SELECT j.libro_id, j.cantidad, j.descuento_id, j.impuesto_id
    FROM OPENJSON(@detalle)
         WITH (libro_id INT '$.libro_id',
               cantidad INT '$.cantidad',
               descuento_id INT '$.descuento_id',
               impuesto_id INT '$.impuesto_id') j;

    INSERT INTO @pagos_t (forma_pago_id, monto, referencia)
    SELECT j.forma_pago_id, j.monto, j.referencia
    FROM OPENJSON(@pagos)
         WITH (forma_pago_id INT '$.forma_pago_id',
               monto DECIMAL(10,2) '$.monto',
               referencia NVARCHAR(80) '$.referencia') j;

    IF NOT EXISTS (SELECT 1 FROM @lineas) OR NOT EXISTS (SELECT 1 FROM @pagos_t)
        THROW 50004, N'Debe indicar al menos un libro y una forma de pago.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l WHERE l.cantidad IS NULL OR l.cantidad <= 0)
        THROW 50011, N'La cantidad de cada libro debe ser mayor a cero.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.libro_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.libro b WHERE b.id = l.libro_id))
        THROW 50005, N'Uno de los libros no existe.', 1;

    UPDATE l
    SET precio_unitario = b.precio_venta
    FROM @lineas l
    INNER JOIN dbo.libro b ON b.id = l.libro_id;

    IF EXISTS (SELECT 1 FROM @lineas l WHERE l.precio_unitario IS NULL)
        THROW 50014, N'Uno de los libros no tiene precio de venta.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.descuento_id IS NOT NULL
                 AND NOT EXISTS (SELECT 1 FROM dbo.descuento d
                                 WHERE d.id = l.descuento_id
                                   AND d.estado = 1
                                   AND d.fecha_inicio <= @hoy
                                   AND (d.fecha_fin IS NULL OR d.fecha_fin >= @hoy)))
        THROW 50008, N'El descuento no existe, no está activo o no está vigente.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.impuesto_id IS NOT NULL
                 AND NOT EXISTS (SELECT 1 FROM dbo.impuesto i
                                 WHERE i.id = l.impuesto_id
                                   AND i.estado = 1
                                   AND i.fecha_inicio <= @hoy
                                   AND (i.fecha_fin IS NULL OR i.fecha_fin >= @hoy)))
        THROW 50009, N'El impuesto no existe o no está vigente.', 1;

    IF EXISTS (SELECT 1
               FROM (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t
               WHERE ISNULL((SELECT i.cantidad_disponible
                             FROM dbo.inventariosucursal i
                             WHERE i.sucursal_id = @sucursal_id AND i.libro_id = t.libro_id), 0) < t.pedido)
        THROW 50006, N'No hay existencias suficientes en la sucursal.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t p
               WHERE p.forma_pago_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.formapago f WHERE f.id = p.forma_pago_id))
        THROW 50010, N'La forma de pago no existe.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t p WHERE p.monto IS NULL OR p.monto <= 0)
        THROW 50015, N'El monto de cada pago debe ser mayor a cero.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t GROUP BY forma_pago_id HAVING COUNT(*) > 1)
        THROW 50013, N'Una forma de pago no puede repetirse.', 1;

    -- Descuento por línea: PORCENTAJE o MONTO_FIJO por unidad, sin pasar del precio
    UPDATE l
    SET descuento = CAST(CASE WHEN x.du > l.precio_unitario THEN l.precio_unitario ELSE x.du END
                         * l.cantidad AS DECIMAL(10,2))
    FROM @lineas l
    INNER JOIN dbo.descuento d ON d.id = l.descuento_id
    CROSS APPLY (SELECT CASE WHEN d.tipo_descuento = N'PORCENTAJE'
                             THEN ROUND(l.precio_unitario * d.valor / 100.0, 2)
                             ELSE d.valor END AS du) x;

    -- Impuesto por línea sobre (precio x cantidad - descuento)
    UPDATE l
    SET monto_impuesto = CAST(ROUND((l.precio_unitario * l.cantidad - l.descuento) * i.porcentaje / 100.0, 2)
                              AS DECIMAL(10,2))
    FROM @lineas l
    INNER JOIN dbo.impuesto i ON i.id = l.impuesto_id;

    SELECT @subtotal = SUM(precio_unitario * cantidad),
           @descuento_total = SUM(descuento),
           @impuesto_total = SUM(monto_impuesto)
    FROM @lineas;

    SET @total = @subtotal - @descuento_total + @impuesto_total;

    SELECT @suma_pagos = SUM(monto) FROM @pagos_t;
    IF @suma_pagos <> @total
        THROW 50007, N'La suma de los pagos no coincide con el total.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.factura (fecha, cliente_id, empleado_id, canal)
            VALUES (@ahora, @cliente_id, @empleado_id, @canal);
            SET @factura_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detallefactura (factura_id, libro_id, cantidad, precio_unitario, descuento, descuento_id, impuesto_id, monto_impuesto)
            SELECT @factura_id, l.libro_id, l.cantidad, l.precio_unitario, l.descuento, l.descuento_id, l.impuesto_id, l.monto_impuesto
            FROM @lineas l;

            INSERT INTO dbo.facturaformapago (factura_id, forma_pago_id, monto, referencia)
            SELECT @factura_id, p.forma_pago_id, p.monto, p.referencia
            FROM @pagos_t p;

            -- Inventario: solo descuenta si todavía alcanzan las existencias
            UPDATE i
            SET cantidad_disponible = i.cantidad_disponible - t.pedido
            FROM dbo.inventariosucursal i
            INNER JOIN (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t
                    ON t.libro_id = i.libro_id
            WHERE i.sucursal_id = @sucursal_id
              AND i.cantidad_disponible >= t.pedido;
            SET @filas = @@ROWCOUNT;

            IF @filas <> (SELECT COUNT(DISTINCT libro_id) FROM @lineas)
                THROW 50006, N'No hay existencias suficientes en la sucursal.', 1;

            INSERT INTO dbo.movimientoinventario (sucursal_id, ejemplar_id, empleado_id, tipo_movimiento, cantidad, observacion)
            SELECT @sucursal_id, NULL, @empleado_id, N'SALIDA', t.pedido,
                   CONCAT(N'Venta factura ', @factura_id, N', libro ', t.libro_id)
            FROM (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @factura_id AS factura_id,
               @subtotal AS subtotal,
               @descuento_total AS descuento_total,
               @impuesto_total AS impuesto_total,
               @total AS total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> Procedimientos/sp_retirar_recurso_digital.sql
/* ============================================================
   Procedimiento: dbo.sp_retirar_recurso_digital
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Retira del catálogo un libro digital o audiolibro
                (estado 0). No borra nada: el progreso, las notas y los
                capítulos se conservan por si se vuelve a publicar.
   Parámetros: @recurso_digital_id
   Devuelve: recurso_digital_id, libro_id, tipo (T: Texto; A: Audio),
             lectores_afectados (clientes que tenían progreso)
   Errores: 50001 El recurso digital no existe, 50002 El recurso
            digital ya estaba retirado
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_retirar_recurso_digital
    @recurso_digital_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @estado SMALLINT;

    -- 1. Validaciones (antes de escribir nada)
    SELECT @estado = r.estado FROM dbo.recursodigital r WHERE r.id = @recurso_digital_id;

    IF @estado IS NULL
        THROW 50001, N'El recurso digital no existe.', 1;

    IF @estado = 0
        THROW 50002, N'El recurso digital ya estaba retirado.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE dbo.recursodigital SET estado = 0 WHERE id = @recurso_digital_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT r.id AS recurso_digital_id,
               r.libro_id,
               r.tipo,
               (SELECT COUNT(*) FROM dbo.progresolectura pl WHERE pl.recurso_digital_id = r.id) AS lectores_afectados
        FROM dbo.recursodigital r
        WHERE r.id = @recurso_digital_id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- >>> DML/001_cargo.sql
-- cargo
SET IDENTITY_INSERT dbo.cargo ON;
INSERT INTO dbo.cargo (id, nombre, descripcion) VALUES
  (1, N'Director general', N'Dirige la operación general de la biblioteca-librería.'),
  (2, N'Gerente de sucursal', N'Administra el personal y las ventas de una sucursal.'),
  (3, N'Bibliotecario', N'Atiende préstamos, devoluciones y consultas de lectores.'),
  (4, N'Auxiliar de biblioteca', N'Apoya la organización y el orden de los ejemplares.'),
  (5, N'Cajero', N'Registra cobros y emite facturas en caja.'),
  (6, N'Vendedor de mostrador', N'Asesora y vende libros a los clientes.'),
  (7, N'Encargado de inventario', N'Controla existencias y movimientos de inventario.'),
  (8, N'Analista de compras', N'Gestiona cotizaciones y compras a proveedores.'),
  (9, N'Contador', N'Lleva la contabilidad y los reportes financieros.'),
  (10, N'Asistente administrativo', N'Apoya tareas administrativas y de archivo.'),
  (11, N'Coordinador de préstamos', N'Supervisa el proceso de préstamos y devoluciones.'),
  (12, N'Encargado de atención al cliente', N'Resuelve consultas, reclamos y sugerencias.'),
  (13, N'Técnico de sistemas', N'Mantiene los equipos y el sistema informático.'),
  (14, N'Supervisor de almacén', N'Supervisa la recepción y el resguardo de mercadería.'),
  (15, N'Archivista', N'Cataloga y conserva el material bibliográfico.');
SET IDENTITY_INSERT dbo.cargo OFF;
GO

-- >>> DML/002_persona.sql
-- persona
SET IDENTITY_INSERT dbo.persona ON;
INSERT INTO dbo.persona (id, nombre, segundo_nombre, apellido, segundo_apellido, correo, genero, fecha_nacimiento) VALUES
  (1, N'José', N'Alberto', N'Martínez', N'Banegas', N'jose.martinez01@example.com', N'M', '1988-11-02'),
  (2, N'María', NULL, N'López', N'Cálix', N'maria.lopez02@example.com', N'F', '1991-07-01'),
  (3, N'Carlos', NULL, N'Hernández', N'Ordóñez', N'carlos.hernandez03@example.com', N'M', '1993-03-27'),
  (4, N'Ana', N'Isabel', N'Rodríguez', N'Mendoza', N'ana.rodriguez04@example.com', N'F', '1995-10-26'),
  (5, N'Luis', N'Eduardo', N'Flores', NULL, N'luis.flores05@example.com', N'M', '1975-10-15'),
  (6, N'Karla', N'Isabel', N'Reyes', N'Lagos', N'karla.reyes06@example.com', N'F', '2001-08-11'),
  (7, N'Miguel', NULL, N'Mejía', N'Maradiaga', N'miguel.mejia07@example.com', N'M', '2000-01-29'),
  (8, N'Sandra', N'Isabel', N'Zelaya', N'Euceda', N'sandra.zelaya08@example.com', N'F', '2002-03-06'),
  (9, N'Jorge', NULL, N'Cruz', N'Cerrato', N'jorge.cruz09@example.com', N'M', '1989-04-06'),
  (10, N'Gloria', N'Beatriz', N'Pineda', NULL, N'gloria.pineda10@example.com', N'F', '1976-05-22'),
  (11, N'Marvin', N'Ramón', N'Banegas', N'Sarmiento', N'marvin.banegas11@example.com', N'M', '1980-04-08'),
  (12, N'Daniela', N'Isabel', N'Cálix', N'Villanueva', N'daniela.calix12@example.com', N'F', '1998-02-10'),
  (13, N'Kevin', NULL, N'Ordóñez', N'Figueroa', N'kevin.ordonez13@example.com', N'M', '1990-06-29'),
  (14, N'Lesly', NULL, N'Mendoza', N'Varela', N'lesly.mendoza14@example.com', N'F', '1991-01-21'),
  (15, N'Óscar', NULL, N'Aguilar', NULL, N'oscar.aguilar15@example.com', N'M', '1994-06-23'),
  (16, N'Marcela', N'Elena', N'Lagos', N'Midence', N'marcela.lagos16@example.com', N'F', '1995-02-10'),
  (17, N'Edwin', N'Ramón', N'Maradiaga', N'Rivera', N'edwin.maradiaga17@example.com', N'M', '2000-01-17'),
  (18, N'Patricia', N'Elena', N'Euceda', N'Paz', N'patricia.euceda18@example.com', N'F', '1994-08-03'),
  (19, N'Wilmer', NULL, N'Cerrato', N'Alvarado', N'wilmer.cerrato19@example.com', N'M', '1992-07-07'),
  (20, N'Gabriela', NULL, N'Amaya', NULL, N'gabriela.amaya20@example.com', N'F', '1991-06-26'),
  (21, N'Daniel', N'Ramón', N'Sarmiento', N'Martínez', N'daniel.sarmiento21@example.com', N'M', '1989-06-05'),
  (22, N'Rosa', N'Lucía', N'Villanueva', N'López', N'rosa.villanueva22@example.com', N'F', '1983-03-17'),
  (23, N'Roberto', N'Alberto', N'Figueroa', N'Hernández', N'roberto.figueroa23@example.com', N'M', '1970-06-01'),
  (24, N'Mayra', N'Isabel', N'Varela', N'Rodríguez', N'mayra.varela24@example.com', N'F', '1976-09-21'),
  (25, N'Fernando', NULL, N'Castellanos', NULL, N'fernando.castellanos25@example.com', N'M', '1996-10-16'),
  (26, N'Claudia', N'Beatriz', N'Midence', N'Reyes', N'claudia.midence26@example.com', N'F', '1993-06-16'),
  (27, N'Allan', N'Ramón', N'Rivera', N'Mejía', N'allan.rivera27@example.com', N'M', '1986-02-23'),
  (28, N'Wendy', N'Lucía', N'Paz', N'Zelaya', N'wendy.paz28@example.com', N'F', '1981-09-01'),
  (29, N'Henry', NULL, N'Alvarado', N'Cruz', N'henry.alvarado29@example.com', N'M', '1991-10-13'),
  (30, N'Fabiola', N'Beatriz', N'Sierra', NULL, N'fabiola.sierra30@example.com', N'F', '1992-12-07');
SET IDENTITY_INSERT dbo.persona OFF;
GO

-- >>> DML/003_empleado.sql
-- empleado
SET IDENTITY_INSERT dbo.empleado ON;
INSERT INTO dbo.empleado (id, codigo_empleado, fecha_contratacion, persona_id, cargo_id) VALUES
  (1, N'EMP-001', '2026-08-07', 1, 14),
  (2, N'EMP-002', '2023-07-30', 2, 13),
  (3, N'EMP-003', '2022-11-14', 3, 9),
  (4, N'EMP-004', '2025-06-12', 4, 15),
  (5, N'EMP-005', '2018-05-18', 5, 14),
  (6, N'EMP-006', '2021-04-03', 6, 6),
  (7, N'EMP-007', '2023-02-18', 7, 15),
  (8, N'EMP-008', '2019-02-07', 8, 8),
  (9, N'EMP-009', '2025-09-24', 9, 12),
  (10, N'EMP-010', '2023-10-12', 10, 5),
  (11, N'EMP-011', '2023-01-30', 11, 15),
  (12, N'EMP-012', '2020-01-20', 12, 7),
  (13, N'EMP-013', '2026-03-01', 13, 8),
  (14, N'EMP-014', '2018-09-21', 14, 11),
  (15, N'EMP-015', '2020-12-27', 15, 15),
  (16, N'EMP-016', '2023-08-04', 16, 6),
  (17, N'EMP-017', '2019-01-31', 17, 4),
  (18, N'EMP-018', '2026-05-20', 18, 14),
  (19, N'EMP-019', '2022-08-12', 19, 3),
  (20, N'EMP-020', '2023-01-15', 20, 15),
  (21, N'EMP-021', '2018-02-27', 21, 2),
  (22, N'EMP-022', '2018-01-01', 22, 8),
  (23, N'EMP-023', '2024-07-06', 23, 9),
  (24, N'EMP-024', '2018-12-07', 24, 10),
  (25, N'EMP-025', '2020-03-25', 25, 4),
  (26, N'EMP-026', '2019-05-10', 26, 10),
  (27, N'EMP-027', '2018-07-02', 27, 13),
  (28, N'EMP-028', '2024-02-17', 28, 5),
  (29, N'EMP-029', '2025-07-01', 29, 13),
  (30, N'EMP-030', '2025-02-15', 30, 6);
SET IDENTITY_INSERT dbo.empleado OFF;
GO

-- >>> DML/004_rol.sql
-- rol
SET IDENTITY_INSERT dbo.rol ON;
INSERT INTO dbo.rol (id, nombre, descripcion) VALUES
  (1, N'Administrador', N'Acceso total al sistema y a su configuración.'),
  (2, N'Gerente', N'Acceso a reportes y aprobaciones de su sucursal.'),
  (3, N'Bibliotecario', N'Gestiona préstamos, devoluciones y multas.'),
  (4, N'Cajero', N'Registra facturas y cobros.'),
  (5, N'Vendedor', N'Consulta catálogo y registra ventas.'),
  (6, N'Inventario', N'Administra existencias y movimientos.'),
  (7, N'Compras', N'Registra compras y proveedores.'),
  (8, N'Contabilidad', N'Consulta facturación, pagos e impuestos.'),
  (9, N'Auditor', N'Acceso de solo lectura a la bitácora de auditoría.'),
  (10, N'Soporte técnico', N'Acceso técnico para mantenimiento del sistema.'),
  (11, N'Atención al cliente', N'Gestiona clientes, reservas y reseñas.'),
  (12, N'Consulta', N'Acceso de solo lectura al catálogo.'),
  (13, N'Supervisor', N'Supervisa la operación diaria del personal.'),
  (14, N'Invitado', N'Acceso limitado y temporal.'),
  (15, N'Operador de préstamos', N'Registra préstamos y devoluciones únicamente.');
SET IDENTITY_INSERT dbo.rol OFF;

SET IDENTITY_INSERT dbo.rol ON;
INSERT INTO dbo.rol (id, nombre, descripcion) VALUES
  (16, N'Cliente', N'Acceso a la app: catálogo, préstamos, reservas, compras y biblioteca digital.');
SET IDENTITY_INSERT dbo.rol OFF;
GO

-- >>> DML/005_usuario.sql
-- usuario
SET IDENTITY_INSERT dbo.usuario ON;
INSERT INTO dbo.usuario (id, nombre_usuario, contrasena_hash, persona_id, rol_id, fecha_creacion, estado) VALUES
  (1, N'jmartinez', N'TEST$9543c6c3aa220078503dc86b01504585279e6933', 1, 10, '2026-08-07 09:00:00', 1),
  (2, N'mlopez', N'TEST$7df2fc58dc56dc87f32efa03ed1ba5c8c4ffc64e', 2, 12, '2023-07-30 09:00:00', 1),
  (3, N'chernandez', N'TEST$3911c9b08bb9c91222867c53f000e394b870e4e1', 3, 8, '2022-11-14 09:00:00', 1),
  (4, N'arodriguez', N'TEST$e0412118991f77c9f551abfd219763c59682e074', 4, 12, '2025-06-12 09:00:00', 1),
  (5, N'lflores', N'TEST$ab2669816af38f6c159d6a384a6a03b381356bc5', 5, 3, '2018-05-18 09:00:00', 1),
  (6, N'kreyes', N'TEST$ea3e7f73c84c1884c88f63d622a60b44ef5fd31c', 6, 10, '2021-04-03 09:00:00', 1),
  (7, N'mmejia', N'TEST$ced8c28463f1bbbc697b65cb81f8c04a4e564cbf', 7, 3, '2023-02-18 09:00:00', 1),
  (8, N'szelaya', N'TEST$039e257a6041f10e325abdecce9182088520bf0c', 8, 2, '2019-02-07 09:00:00', 1),
  (9, N'jcruz', N'TEST$d573e7bb0d26efa012cc86e3e344f1c363ac4f14', 9, 6, '2025-09-24 09:00:00', 1),
  (10, N'gpineda', N'TEST$f1f02f49c50029abef3e41445a789b32a5721c6a', 10, 1, '2023-10-12 09:00:00', 1),
  (11, N'mbanegas', N'TEST$aecb9e6853e8153679dcbc8182a8c712068c8f90', 11, 5, '2023-01-30 09:00:00', 1),
  (12, N'dcalix', N'TEST$7f60b9fa1f124a78e9f914845377899a733c6676', 12, 8, '2020-01-20 09:00:00', 1),
  (13, N'kordonez', N'TEST$27655f912bb53283ce1075039e5cf6e992559248', 13, 10, '2026-03-01 09:00:00', 1),
  (14, N'lmendoza', N'TEST$561f8bfe9f93693f6f00e7c434fd02f6850567c2', 14, 8, '2018-09-21 09:00:00', 1),
  (15, N'oaguilar', N'TEST$11cb4ea7b5fc684aadb210953bbb492b9924eb8b', 15, 9, '2020-12-27 09:00:00', 1),
  (16, N'mlagos', N'TEST$ebe48123a5b0e526320be3f808be3b07662f286b', 16, 3, '2023-08-04 09:00:00', 1),
  (17, N'emaradiaga', N'TEST$d6c769cbee532f038b75d02aa5f274190b94a014', 17, 1, '2019-01-31 09:00:00', 1),
  (18, N'peuceda', N'TEST$304374b3a40eecb5c134a79bde3b7dd373aa881e', 18, 8, '2026-05-20 09:00:00', 1),
  (19, N'wcerrato', N'TEST$210f4de3053d82cbe0b89bcbadbafed0b600860c', 19, 11, '2022-08-12 09:00:00', 1),
  (20, N'gamaya', N'TEST$845074a1e1f66c3ac9108f8937fe43eb87a9ec13', 20, 15, '2023-01-15 09:00:00', 1),
  (21, N'dsarmiento', N'TEST$d828f123a945e7bb290f5d0f2341bbbef4e2ea68', 21, 3, '2018-02-27 09:00:00', 1),
  (22, N'rvillanueva', N'TEST$6a01977b887367376ce4048f45d6ac4263d52b10', 22, 14, '2018-01-01 09:00:00', 1),
  (23, N'rfigueroa', N'TEST$5814b53f2fec42754e0e889662186f4b1422fbef', 23, 3, '2024-07-06 09:00:00', 1),
  (24, N'mvarela', N'TEST$c7be5613ffce69737f62df2676c3266043710baf', 24, 14, '2018-12-07 09:00:00', 1),
  (25, N'fcastellanos', N'TEST$5366ece22d4d666177bb365449a4c2226a6dc402', 25, 9, '2020-03-25 09:00:00', 1),
  (26, N'cmidence', N'TEST$cbee23b086f9fa211ebf3deb71d02f517b67cfa6', 26, 9, '2019-05-10 09:00:00', 1),
  (27, N'arivera', N'TEST$d90e013a18357aebd0ef5c364619e5dbcbf5514c', 27, 4, '2018-07-02 09:00:00', 1),
  (28, N'wpaz', N'TEST$e0ed4a6217d6af8ff423f8be014182233b38c237', 28, 8, '2024-02-17 09:00:00', 1),
  (29, N'halvarado', N'TEST$c887417c8b890fec6872d96b5497db67a54b3b83', 29, 14, '2025-07-01 09:00:00', 1),
  (30, N'fsierra', N'TEST$f6111cf22eb52387ab9f4430d8ae93fbd978673a', 30, 1, '2025-02-15 09:00:00', 1);
SET IDENTITY_INSERT dbo.usuario OFF;
GO

-- >>> DML/006_auditoria.sql
-- auditoria
SET IDENTITY_INSERT dbo.auditoria ON;
INSERT INTO dbo.auditoria (id, usuario_id, fecha_hora, accion, tabla_afectada, registro_id, detalle) VALUES
  (1, 18, '2026-10-25 16:13:07', N'DELETE', N'factura', N'12', N'DELETE sobre factura (id 12) realizado desde el sistema.'),
  (2, 25, '2026-10-22 11:36:18', N'LOGOUT', N'ejemplar', N'18', N'LOGOUT sobre ejemplar (id 18) realizado desde el sistema.'),
  (3, 18, '2026-03-13 09:50:16', N'LOGOUT', N'ejemplar', N'22', N'LOGOUT sobre ejemplar (id 22) realizado desde el sistema.'),
  (4, 4, '2026-02-04 13:46:51', N'INSERT', N'reserva', N'6', N'INSERT sobre reserva (id 6) realizado desde el sistema.'),
  (5, 11, '2026-05-26 17:53:04', N'UPDATE', N'prestamo', N'17', N'UPDATE sobre prestamo (id 17) realizado desde el sistema.'),
  (6, 9, '2026-05-16 09:00:26', N'DELETE', N'multa', N'6', N'DELETE sobre multa (id 6) realizado desde el sistema.'),
  (7, 2, '2026-02-23 11:01:19', N'DELETE', N'reserva', N'1', N'DELETE sobre reserva (id 1) realizado desde el sistema.'),
  (8, 18, '2026-10-27 13:20:49', N'INSERT', N'prestamo', N'22', N'INSERT sobre prestamo (id 22) realizado desde el sistema.'),
  (9, 13, '2026-06-15 17:13:38', N'LOGIN', N'libro', N'30', N'LOGIN sobre libro (id 30) realizado desde el sistema.'),
  (10, 29, '2026-03-07 18:23:55', N'LOGIN', N'reserva', N'22', N'LOGIN sobre reserva (id 22) realizado desde el sistema.'),
  (11, 10, '2026-07-06 08:47:45', N'LOGOUT', N'ejemplar', N'13', N'LOGOUT sobre ejemplar (id 13) realizado desde el sistema.'),
  (12, 23, '2026-06-23 12:46:49', N'LOGIN', N'libro', N'10', N'LOGIN sobre libro (id 10) realizado desde el sistema.'),
  (13, 14, '2026-06-17 17:57:01', N'INSERT', N'ejemplar', N'25', N'INSERT sobre ejemplar (id 25) realizado desde el sistema.'),
  (14, 18, '2026-02-02 09:10:39', N'LOGOUT', N'multa', N'7', N'LOGOUT sobre multa (id 7) realizado desde el sistema.'),
  (15, 5, '2026-09-29 13:38:41', N'INSERT', N'prestamo', N'2', N'INSERT sobre prestamo (id 2) realizado desde el sistema.'),
  (16, 19, '2026-03-10 13:26:24', N'DELETE', N'libro', N'14', N'DELETE sobre libro (id 14) realizado desde el sistema.'),
  (17, 14, '2026-04-27 10:11:34', N'LOGIN', N'cliente', N'25', N'LOGIN sobre cliente (id 25) realizado desde el sistema.'),
  (18, 9, '2026-03-21 11:01:01', N'INSERT', N'reserva', N'29', N'INSERT sobre reserva (id 29) realizado desde el sistema.'),
  (19, 9, '2026-06-15 10:40:37', N'DELETE', N'empleado', N'14', N'DELETE sobre empleado (id 14) realizado desde el sistema.'),
  (20, 2, '2026-09-25 12:21:40', N'INSERT', N'factura', N'18', N'INSERT sobre factura (id 18) realizado desde el sistema.'),
  (21, 22, '2026-01-10 18:15:30', N'LOGOUT', N'multa', N'2', N'LOGOUT sobre multa (id 2) realizado desde el sistema.'),
  (22, 17, '2026-03-23 14:45:23', N'INSERT', N'cliente', N'22', N'INSERT sobre cliente (id 22) realizado desde el sistema.'),
  (23, 28, '2026-04-17 13:22:29', N'UPDATE', N'ejemplar', N'11', N'UPDATE sobre ejemplar (id 11) realizado desde el sistema.'),
  (24, 26, '2026-10-29 12:12:10', N'LOGIN', N'empleado', N'29', N'LOGIN sobre empleado (id 29) realizado desde el sistema.'),
  (25, 29, '2026-01-07 13:52:53', N'LOGIN', N'factura', N'16', N'LOGIN sobre factura (id 16) realizado desde el sistema.'),
  (26, 2, '2026-04-03 09:19:23', N'LOGOUT', N'reserva', N'26', N'LOGOUT sobre reserva (id 26) realizado desde el sistema.'),
  (27, 23, '2026-02-25 08:34:13', N'LOGOUT', N'ejemplar', N'5', N'LOGOUT sobre ejemplar (id 5) realizado desde el sistema.'),
  (28, 2, '2026-07-25 14:34:33', N'LOGOUT', N'ejemplar', N'19', N'LOGOUT sobre ejemplar (id 19) realizado desde el sistema.'),
  (29, 5, '2026-07-23 13:35:16', N'UPDATE', N'prestamo', N'3', N'UPDATE sobre prestamo (id 3) realizado desde el sistema.'),
  (30, 19, '2026-04-12 10:57:18', N'DELETE', N'libro', N'24', N'DELETE sobre libro (id 24) realizado desde el sistema.');
SET IDENTITY_INSERT dbo.auditoria OFF;
GO

-- >>> DML/007_autor.sql
-- autor
SET IDENTITY_INSERT dbo.autor ON;
INSERT INTO dbo.autor (id, fecha_registro, persona_id) VALUES
  (1, '2024-10-29', 1),
  (2, '2025-07-08', 2),
  (3, '2024-10-19', 3),
  (4, '2024-12-31', 4),
  (5, '2024-05-17', 5),
  (6, '2025-02-01', 6),
  (7, '2024-07-12', 7),
  (8, '2026-02-03', 8),
  (9, '2025-10-06', 9),
  (10, '2024-01-10', 10),
  (11, '2026-05-17', 11),
  (12, '2025-09-12', 12),
  (13, '2025-10-25', 13),
  (14, '2025-05-06', 14),
  (15, '2025-03-08', 15),
  (16, '2024-12-30', 16),
  (17, '2026-04-11', 17),
  (18, '2026-03-01', 18),
  (19, '2026-03-06', 19),
  (20, '2026-06-17', 20),
  (21, '2025-07-04', 21),
  (22, '2024-06-23', 22),
  (23, '2026-01-09', 23),
  (24, '2025-06-12', 24),
  (25, '2024-01-31', 25),
  (26, '2024-07-02', 26),
  (27, '2024-11-18', 27),
  (28, '2025-07-06', 28),
  (29, '2024-05-28', 29),
  (30, '2024-06-16', 30);
SET IDENTITY_INSERT dbo.autor OFF;
GO

-- >>> DML/008_categoria.sql
-- categoria
SET IDENTITY_INSERT dbo.categoria ON;
INSERT INTO dbo.categoria (id, nombre, descripcion) VALUES
  (1, N'Ficción', N'Novelas y cuentos de narrativa literaria.'),
  (2, N'Ciencia', N'Divulgación y textos de ciencias naturales.'),
  (3, N'Tecnología', N'Informática, programación y tecnología.'),
  (4, N'Historia', N'Historia nacional, regional y universal.'),
  (5, N'Biografía', N'Biografías, memorias y testimonios.'),
  (6, N'Infantil', N'Libros para lectores de primera infancia.'),
  (7, N'Juvenil', N'Literatura para adolescentes y jóvenes.'),
  (8, N'Poesía', N'Poemarios y antologías poéticas.'),
  (9, N'Arte', N'Artes visuales, música y fotografía.'),
  (10, N'Cocina', N'Recetarios y gastronomía.'),
  (11, N'Salud', N'Salud, nutrición y bienestar.'),
  (12, N'Educación', N'Pedagogía y material de apoyo escolar.'),
  (13, N'Negocios', N'Finanzas, emprendimiento y administración.'),
  (14, N'Autoayuda', N'Desarrollo personal y hábitos.'),
  (15, N'Filosofía', N'Pensamiento, ética y filosofía.');
SET IDENTITY_INSERT dbo.categoria OFF;
GO

-- >>> DML/009_tipocliente.sql
-- tipocliente
SET IDENTITY_INSERT dbo.tipocliente ON;
INSERT INTO dbo.tipocliente (id, nombre, descripcion, limite_prestamos, limite_renovaciones) VALUES
  (1, N'Estudiante', N'Lector inscrito en un centro educativo.', 3, 1),
  (2, N'Docente', N'Educador de cualquier nivel.', 5, 2),
  (3, N'Investigador', N'Persona que consulta fuentes con fines de estudio.', 5, 2),
  (4, N'Adulto mayor', N'Cliente de 60 años o más.', 3, 1),
  (5, N'Niño o niña', N'Lector menor de 12 años.', 2, 0),
  (6, N'Joven', N'Lector de entre 12 y 25 años.', 3, 1),
  (7, N'Empleado público', N'Trabajador de una institución del Estado.', 3, 1),
  (8, N'Empresa', N'Cliente corporativo.', 10, 2),
  (9, N'Institución educativa', N'Escuela, colegio o universidad.', 10, 2),
  (10, N'Biblioteca aliada', N'Biblioteca con convenio de intercambio.', 8, 2),
  (11, N'Cliente frecuente', N'Cliente con compras o préstamos recurrentes.', 5, 2),
  (12, N'Cliente ocasional', N'Cliente con visitas esporádicas.', 2, 0),
  (13, N'Socio premium', N'Cliente con membresía de beneficios.', 7, 3),
  (14, N'Visitante', N'Persona que consulta en sala.', 0, 0),
  (15, N'Jubilado', N'Cliente jubilado o pensionado.', 3, 1);
SET IDENTITY_INSERT dbo.tipocliente OFF;
GO

-- >>> DML/010_cliente.sql
-- cliente
SET IDENTITY_INSERT dbo.cliente ON;
INSERT INTO dbo.cliente (id, fecha_registro, persona_id, tipo_cliente_id) VALUES
  (1, '2024-01-30', 1, 15),
  (2, '2024-04-29', 2, 9),
  (3, '2025-11-14', 3, 15),
  (4, '2025-12-22', 4, 11),
  (5, '2026-02-24', 5, 1),
  (6, '2026-05-12', 6, 6),
  (7, '2024-03-06', 7, 6),
  (8, '2024-11-05', 8, 4),
  (9, '2025-06-28', 9, 3),
  (10, '2025-09-05', 10, 10),
  (11, '2024-09-11', 11, 3),
  (12, '2024-04-18', 12, 6),
  (13, '2025-05-11', 13, 2),
  (14, '2026-06-13', 14, 14),
  (15, '2026-01-14', 15, 2),
  (16, '2025-01-25', 16, 5),
  (17, '2025-09-23', 17, 5),
  (18, '2025-10-25', 18, 2),
  (19, '2024-12-22', 19, 8),
  (20, '2025-05-25', 20, 2),
  (21, '2025-07-22', 21, 9),
  (22, '2024-09-09', 22, 14),
  (23, '2025-01-02', 23, 11),
  (24, '2026-04-14', 24, 8),
  (25, '2025-08-22', 25, 6),
  (26, '2024-03-25', 26, 2),
  (27, '2026-03-08', 27, 2),
  (28, '2026-04-07', 28, 8),
  (29, '2026-03-07', 29, 5),
  (30, '2024-09-28', 30, 13);
SET IDENTITY_INSERT dbo.cliente OFF;
GO

-- >>> DML/011_proveedor.sql
-- proveedor
SET IDENTITY_INSERT dbo.proveedor ON;
INSERT INTO dbo.proveedor (id, nombre, telefono, correo, direccion) VALUES
  (1, N'Distribuidora Libros del Sur', N'+504 2565-7166', N'ventas01@distribuidoralibro.example.com', N'Colonia Los Pinos, bloque 1, Comayagua'),
  (2, N'Importadora Letras Vivas', N'+504 2963-9414', N'ventas02@importadoraletrasv.example.com', N'Colonia Los Pinos, bloque 2, El Progreso'),
  (3, N'Papelería y Libros Central', N'+504 2853-2250', N'ventas03@papeleriaylibrosce.example.com', N'Colonia Los Pinos, bloque 3, Santa Rosa de Copán'),
  (4, N'Mayorista Páginas S.A.', N'+504 2940-6577', N'ventas04@mayoristapaginass..example.com', N'Colonia Los Pinos, bloque 4, Choloma'),
  (5, N'Comercial Lectura Plus', N'+504 2291-9815', N'ventas05@comerciallecturapl.example.com', N'Colonia Los Pinos, bloque 5, Siguatepeque'),
  (6, N'Distribuciones El Saber', N'+504 2499-5712', N'ventas06@distribucioneselsa.example.com', N'Colonia Los Pinos, bloque 6, Comayagua'),
  (7, N'Grupo Editorial Norte', N'+504 2668-3308', N'ventas07@grupoeditorialnort.example.com', N'Colonia Los Pinos, bloque 7, El Progreso'),
  (8, N'Libros y Más Honduras', N'+504 2860-6062', N'ventas08@librosymashonduras.example.com', N'Colonia Los Pinos, bloque 8, Santa Rosa de Copán'),
  (9, N'Surtidora Académica', N'+504 2225-7043', N'ventas09@surtidoraacademica.example.com', N'Colonia Los Pinos, bloque 9, Choloma'),
  (10, N'Importaciones Bibliomundo', N'+504 2572-8554', N'ventas10@importacionesbibli.example.com', N'Colonia Los Pinos, bloque 10, Siguatepeque'),
  (11, N'Distribuidora Cuentos y Letras', N'+504 2632-2485', N'ventas11@distribuidoracuent.example.com', N'Colonia Los Pinos, bloque 11, Comayagua'),
  (12, N'Comercializadora Tinta y Papel', N'+504 2608-9166', N'ventas12@comercializadorati.example.com', N'Colonia Los Pinos, bloque 12, El Progreso'),
  (13, N'Libros Express Centroamérica', N'+504 2319-7970', N'ventas13@librosexpresscentr.example.com', N'Colonia Los Pinos, bloque 13, Santa Rosa de Copán'),
  (14, N'Proveedora Universal de Textos', N'+504 2718-9045', N'ventas14@proveedorauniversa.example.com', N'Colonia Los Pinos, bloque 14, Choloma'),
  (15, N'Distribuidora Ágora', N'+504 2607-9595', N'ventas15@distribuidoraagora.example.com', N'Colonia Los Pinos, bloque 15, Siguatepeque');
SET IDENTITY_INSERT dbo.proveedor OFF;
GO

-- >>> DML/012_compraproveedor.sql
-- compraproveedor
SET IDENTITY_INSERT dbo.compraproveedor ON;
INSERT INTO dbo.compraproveedor (id, fecha_compra, numero_factura, proveedor_id, empleado_id) VALUES
  (1, '2025-09-21', N'F-2026-0001', 1, 1),
  (2, '2025-12-07', N'F-2026-0002', 2, 23),
  (3, '2025-08-16', N'F-2026-0003', 3, 22),
  (4, '2025-09-26', N'F-2026-0004', 4, 11),
  (5, '2025-04-18', N'F-2026-0005', 5, 22),
  (6, '2026-03-28', N'F-2026-0006', 6, 30),
  (7, '2025-11-09', N'F-2026-0007', 7, 30),
  (8, '2026-02-11', N'F-2026-0008', 8, 28),
  (9, '2026-01-19', N'F-2026-0009', 9, 27),
  (10, '2026-02-05', N'F-2026-0010', 10, 25),
  (11, '2025-12-05', N'F-2026-0011', 11, 17),
  (12, '2025-06-16', N'F-2026-0012', 12, 14),
  (13, '2025-08-28', N'F-2026-0013', 13, 21),
  (14, '2025-08-17', N'F-2026-0014', 14, 2),
  (15, '2025-09-21', N'F-2026-0015', 15, 24),
  (16, '2025-05-28', N'F-2026-0016', 1, 1),
  (17, '2025-07-15', N'F-2026-0017', 2, 18),
  (18, '2026-02-23', N'F-2026-0018', 3, 9),
  (19, '2025-05-06', N'F-2026-0019', 4, 11),
  (20, '2025-12-22', N'F-2026-0020', 5, 21),
  (21, '2026-01-08', N'F-2026-0021', 6, 14),
  (22, '2025-10-30', N'F-2026-0022', 7, 28),
  (23, '2025-11-03', N'F-2026-0023', 8, 11),
  (24, '2025-03-07', N'F-2026-0024', 9, 2),
  (25, '2026-03-23', N'F-2026-0025', 10, 8),
  (26, '2026-01-20', N'F-2026-0026', 11, 4),
  (27, '2026-02-02', N'F-2026-0027', 12, 28),
  (28, '2025-07-16', N'F-2026-0028', 13, 11),
  (29, '2025-03-10', N'F-2026-0029', 14, 25),
  (30, '2025-06-16', N'F-2026-0030', 15, 26);
SET IDENTITY_INSERT dbo.compraproveedor OFF;
GO

-- >>> DML/013_credencial.sql
-- credencial
SET IDENTITY_INSERT dbo.credencial ON;
INSERT INTO dbo.credencial (id, fecha_registro, fecha_vencimiento, estado, cliente_id, empleado_id) VALUES
  (1, '2024-01-30', '2025-01-29', N'VENCIDA', 1, 22),
  (2, '2024-04-29', '2025-04-29', N'VENCIDA', 2, 8),
  (3, '2025-11-14', '2026-11-14', N'VENCIDA', 3, 6),
  (4, '2025-12-22', '2026-12-22', N'ACTIVA', 4, 11),
  (5, '2026-02-24', '2027-02-24', N'ACTIVA', 5, 14),
  (6, '2026-05-12', '2027-05-12', N'ACTIVA', 6, 17),
  (7, '2024-03-06', '2025-03-06', N'VENCIDA', 7, 18),
  (8, '2024-11-05', '2025-11-05', N'VENCIDA', 8, 11),
  (9, '2025-06-28', '2026-06-28', N'VENCIDA', 9, 11),
  (10, '2025-09-05', '2026-09-05', N'SUSPENDIDA', 10, 30),
  (11, '2024-09-11', '2025-09-11', N'VENCIDA', 11, 29),
  (12, '2024-04-18', '2025-04-18', N'VENCIDA', 12, 24),
  (13, '2025-05-11', '2026-05-11', N'VENCIDA', 13, 22),
  (14, '2026-06-13', '2027-06-13', N'ACTIVA', 14, 28),
  (15, '2026-01-14', '2027-01-14', N'ACTIVA', 15, 16),
  (16, '2025-01-25', '2026-01-25', N'VENCIDA', 16, 13),
  (17, '2025-09-23', '2026-09-23', N'VENCIDA', 17, 11),
  (18, '2025-10-25', '2026-10-25', N'VENCIDA', 18, 6),
  (19, '2024-12-22', '2025-12-22', N'VENCIDA', 19, 7),
  (20, '2025-05-25', '2026-05-25', N'SUSPENDIDA', 20, 26),
  (21, '2025-07-22', '2026-07-22', N'VENCIDA', 21, 15),
  (22, '2024-09-09', '2025-09-09', N'VENCIDA', 22, 8),
  (23, '2025-01-02', '2026-01-02', N'VENCIDA', 23, 28),
  (24, '2026-04-14', '2027-04-14', N'ACTIVA', 24, 23),
  (25, '2025-08-22', '2026-08-22', N'VENCIDA', 25, 30),
  (26, '2024-03-25', '2025-03-25', N'VENCIDA', 26, 12),
  (27, '2026-03-08', '2027-03-08', N'ACTIVA', 27, 25),
  (28, '2026-04-07', '2027-04-07', N'ACTIVA', 28, 26),
  (29, '2026-03-07', '2027-03-07', N'ACTIVA', 29, 12),
  (30, '2024-09-28', '2025-09-28', N'SUSPENDIDA', 30, 14);
SET IDENTITY_INSERT dbo.credencial OFF;
GO

-- >>> DML/014_sucursal.sql
-- sucursal
SET IDENTITY_INSERT dbo.sucursal ON;
INSERT INTO dbo.sucursal (id, nombre, direccion, telefono) VALUES
  (1, N'Sucursal Siguatepeque', N'Barrio El Centro, frente al parque central, Siguatepeque', N'+504 2321-6234'),
  (2, N'Sucursal Tegucigalpa', N'Barrio El Centro, frente al parque central, Tegucigalpa', N'+504 2714-9385'),
  (3, N'Sucursal San Pedro Sula', N'Barrio El Centro, frente al parque central, San Pedro Sula', N'+504 2862-2681'),
  (4, N'Sucursal Comayagua', N'Barrio El Centro, frente al parque central, Comayagua', N'+504 2428-7891'),
  (5, N'Sucursal La Ceiba', N'Barrio El Centro, frente al parque central, La Ceiba', N'+504 2786-9975'),
  (6, N'Sucursal Choluteca', N'Barrio El Centro, frente al parque central, Choluteca', N'+504 2948-9042'),
  (7, N'Sucursal El Progreso', N'Barrio El Centro, frente al parque central, El Progreso', N'+504 2969-8226'),
  (8, N'Sucursal Danlí', N'Barrio El Centro, frente al parque central, Danlí', N'+504 2445-1041'),
  (9, N'Sucursal Juticalpa', N'Barrio El Centro, frente al parque central, Juticalpa', N'+504 2828-2322'),
  (10, N'Sucursal Santa Rosa de Copán', N'Barrio El Centro, frente al parque central, Santa Rosa de Copán', N'+504 2313-5706'),
  (11, N'Sucursal Tela', N'Barrio El Centro, frente al parque central, Tela', N'+504 2300-8367'),
  (12, N'Sucursal Puerto Cortés', N'Barrio El Centro, frente al parque central, Puerto Cortés', N'+504 2211-9032'),
  (13, N'Sucursal Choloma', N'Barrio El Centro, frente al parque central, Choloma', N'+504 2895-6148'),
  (14, N'Sucursal La Esperanza', N'Barrio El Centro, frente al parque central, La Esperanza', N'+504 2415-7508'),
  (15, N'Sucursal Catacamas', N'Barrio El Centro, frente al parque central, Catacamas', N'+504 2457-6696');
SET IDENTITY_INSERT dbo.sucursal OFF;
GO

-- >>> DML/015_estante.sql
-- estante
SET IDENTITY_INSERT dbo.estante ON;
INSERT INTO dbo.estante (id, codigo, sucursal_id) VALUES
  (1, N'EST-01', 1),
  (2, N'EST-02', 2),
  (3, N'EST-03', 3),
  (4, N'EST-04', 4),
  (5, N'EST-05', 5),
  (6, N'EST-06', 6),
  (7, N'EST-07', 7),
  (8, N'EST-08', 8),
  (9, N'EST-09', 9),
  (10, N'EST-10', 10),
  (11, N'EST-11', 11),
  (12, N'EST-12', 12),
  (13, N'EST-13', 13),
  (14, N'EST-14', 14),
  (15, N'EST-15', 15),
  (16, N'EST-16', 1),
  (17, N'EST-17', 2),
  (18, N'EST-18', 3),
  (19, N'EST-19', 4),
  (20, N'EST-20', 5),
  (21, N'EST-21', 6),
  (22, N'EST-22', 7),
  (23, N'EST-23', 8),
  (24, N'EST-24', 9),
  (25, N'EST-25', 10),
  (26, N'EST-26', 11),
  (27, N'EST-27', 12),
  (28, N'EST-28', 13),
  (29, N'EST-29', 14),
  (30, N'EST-30', 15);
SET IDENTITY_INSERT dbo.estante OFF;
GO

-- >>> DML/016_cubiculo.sql
-- cubiculo
SET IDENTITY_INSERT dbo.cubiculo ON;
INSERT INTO dbo.cubiculo (id, codigo, estante_id) VALUES
  (1, N'C-01', 1),
  (2, N'C-02', 2),
  (3, N'C-03', 3),
  (4, N'C-04', 4),
  (5, N'C-05', 5),
  (6, N'C-06', 6),
  (7, N'C-07', 7),
  (8, N'C-08', 8),
  (9, N'C-09', 9),
  (10, N'C-10', 10),
  (11, N'C-11', 11),
  (12, N'C-12', 12),
  (13, N'C-13', 13),
  (14, N'C-14', 14),
  (15, N'C-15', 15),
  (16, N'C-16', 16),
  (17, N'C-17', 17),
  (18, N'C-18', 18),
  (19, N'C-19', 19),
  (20, N'C-20', 20),
  (21, N'C-21', 21),
  (22, N'C-22', 22),
  (23, N'C-23', 23),
  (24, N'C-24', 24),
  (25, N'C-25', 25),
  (26, N'C-26', 26),
  (27, N'C-27', 27),
  (28, N'C-28', 28),
  (29, N'C-29', 29),
  (30, N'C-30', 30);
SET IDENTITY_INSERT dbo.cubiculo OFF;
GO

-- >>> DML/017_descuento.sql
-- descuento
SET IDENTITY_INSERT dbo.descuento ON;
INSERT INTO dbo.descuento (id, nombre, descripcion, tipo_descuento, valor, fecha_inicio, fecha_fin, estado, tipo_cliente_id, categoria_id) VALUES
  (1, N'Descuento estudiante', N'Para estudiantes con carné vigente.', N'PORCENTAJE', 10.00, '2025-01-10', NULL, 1, 1, NULL),
  (2, N'Cliente frecuente', N'Beneficio por compras recurrentes.', N'PORCENTAJE', 5.00, '2025-01-10', NULL, 1, NULL, NULL),
  (3, N'Promoción de temporada', N'Descuento por temporada alta.', N'PORCENTAJE', 15.00, '2025-06-01', NULL, 1, NULL, 1),
  (4, N'Adulto mayor', N'Para clientes de 60 años o más.', N'PORCENTAJE', 20.00, '2025-01-10', NULL, 1, 4, NULL),
  (5, N'Día del libro', N'Celebración del Día del Libro.', N'PORCENTAJE', 25.00, '2025-04-01', NULL, 1, NULL, NULL),
  (6, N'Liquidación de inventario', N'Salida de títulos con poca rotación.', N'PORCENTAJE', 30.00, '2025-08-01', NULL, 1, NULL, 4),
  (7, N'Cupón de bienvenida', N'Monto fijo para nuevos clientes.', N'MONTO_FIJO', 50.00, '2025-03-01', NULL, 1, NULL, NULL),
  (8, N'Bono lector', N'Monto fijo por lectura del mes.', N'MONTO_FIJO', 25.00, '2025-03-01', NULL, 1, NULL, NULL),
  (9, N'Descuento a empleados', N'Beneficio interno del personal.', N'PORCENTAJE', 15.00, '2025-01-10', NULL, 1, NULL, NULL),
  (10, N'Compra mayorista', N'Para compras de gran volumen.', N'PORCENTAJE', 12.00, '2025-02-01', NULL, 1, 8, NULL),
  (11, N'Aniversario de la librería', N'Promoción por aniversario.', N'PORCENTAJE', 18.00, '2025-05-05', '2025-05-31', 0, NULL, NULL),
  (12, N'Black Friday 2025', N'Promoción de fin de noviembre.', N'PORCENTAJE', 35.00, '2025-11-28', '2025-11-30', 0, NULL, NULL),
  (13, N'Fin de año', N'Descuento de temporada navideña.', N'PORCENTAJE', 20.00, '2025-12-01', NULL, 1, NULL, NULL),
  (14, N'Regreso a clases', N'Campaña escolar de inicio de año.', N'PORCENTAJE', 10.00, '2025-12-15', NULL, 1, NULL, 12),
  (15, N'Membresía premium', N'Beneficio exclusivo de socios.', N'PORCENTAJE', 8.00, '2025-01-10', NULL, 1, NULL, NULL);
SET IDENTITY_INSERT dbo.descuento OFF;
GO

-- >>> DML/018_editorial.sql
-- editorial
SET IDENTITY_INSERT dbo.editorial ON;
INSERT INTO dbo.editorial (id, nombre) VALUES
  (1, N'Editorial Horizonte'),
  (2, N'Ediciones del Valle'),
  (3, N'Editorial Cumbre'),
  (4, N'Ediciones Mesoamérica'),
  (5, N'Editorial Faro'),
  (6, N'Ediciones Río Blanco'),
  (7, N'Editorial Sendero'),
  (8, N'Ediciones Pico Bonito'),
  (9, N'Editorial Aurora Boreal'),
  (10, N'Ediciones La Ceiba'),
  (11, N'Editorial Cordillera'),
  (12, N'Ediciones Lago Azul'),
  (13, N'Editorial Mirador'),
  (14, N'Ediciones Ceibal'),
  (15, N'Editorial Tierra Firme');
SET IDENTITY_INSERT dbo.editorial OFF;
GO

-- >>> DML/019_formatolibro.sql
-- formatolibro
SET IDENTITY_INSERT dbo.formatolibro ON;
INSERT INTO dbo.formatolibro (id, nombre) VALUES
  (1, N'Tapa dura'),
  (2, N'Tapa blanda'),
  (3, N'Edición de bolsillo'),
  (4, N'eBook (EPUB)'),
  (5, N'Audiolibro'),
  (6, N'PDF digital'),
  (7, N'Rústica'),
  (8, N'Cartoné'),
  (9, N'Espiral'),
  (10, N'Braille'),
  (11, N'Edición de lujo'),
  (12, N'Álbum ilustrado'),
  (13, N'Cómic'),
  (14, N'Revista encuadernada'),
  (15, N'Libro de tela');
SET IDENTITY_INSERT dbo.formatolibro OFF;
GO

-- >>> DML/020_idioma.sql
-- idioma
SET IDENTITY_INSERT dbo.idioma ON;
INSERT INTO dbo.idioma (id, nombre) VALUES
  (1, N'Español'),
  (2, N'Inglés'),
  (3, N'Francés'),
  (4, N'Portugués'),
  (5, N'Italiano'),
  (6, N'Alemán'),
  (7, N'Catalán'),
  (8, N'Latín'),
  (9, N'Náhuatl'),
  (10, N'Garífuna'),
  (11, N'Chino mandarín'),
  (12, N'Japonés'),
  (13, N'Árabe'),
  (14, N'Ruso'),
  (15, N'Miskito');
SET IDENTITY_INSERT dbo.idioma OFF;
GO

-- >>> DML/021_edicion.sql
-- edicion
SET IDENTITY_INSERT dbo.edicion ON;
INSERT INTO dbo.edicion (id, numero_edicion, anio_publicacion, isbn, editorial_id, idioma_id, formato_libro_id) VALUES
  (1, N'4.ª edición', 2021, N'978-4-9518-3801-1', 3, 1, 4),
  (2, N'4.ª edición', 2011, N'978-9-2419-6898-0', 3, 1, 1),
  (3, N'3.ª edición', 2018, N'978-0-2883-7555-7', 6, 2, 8),
  (4, N'3.ª edición', 2020, N'978-5-4072-0754-2', 14, 4, 8),
  (5, N'2.ª edición', 2016, N'978-4-8643-9061-3', 12, 3, 5),
  (6, N'4.ª edición', 2024, N'978-1-8895-7555-1', 3, 1, 3),
  (7, N'3.ª edición', 2021, N'978-8-6193-0733-8', 7, 2, 3),
  (8, N'2.ª edición', 2013, N'978-7-2855-6898-2', 4, 1, 3),
  (9, N'2.ª edición', 2009, N'978-9-0044-2248-3', 12, 1, 3),
  (10, N'4.ª edición', 2010, N'978-2-0226-9780-2', 5, 1, 6),
  (11, N'1.ª edición', 2019, N'978-6-2528-0700-0', 2, 1, 5),
  (12, N'3.ª edición', 2005, N'978-2-8316-6323-4', 4, 3, 8),
  (13, N'2.ª edición', 2016, N'978-2-8667-5347-4', 15, 2, 8),
  (14, N'1.ª edición', 2011, N'978-3-1159-2123-1', 11, 1, 4),
  (15, N'4.ª edición', 2005, N'978-8-2445-6078-8', 8, 1, 6),
  (16, N'4.ª edición', 2009, N'978-1-2835-7699-4', 1, 3, 6),
  (17, N'3.ª edición', 2007, N'978-7-7588-8144-0', 1, 1, 1),
  (18, N'1.ª edición', 2021, N'978-7-9169-7978-1', 1, 1, 6),
  (19, N'2.ª edición', 2005, N'978-1-6128-4001-7', 13, 2, 2),
  (20, N'3.ª edición', 2009, N'978-4-7357-3638-0', 14, 4, 6),
  (21, N'4.ª edición', 2006, N'978-7-3927-3197-2', 10, 1, 8),
  (22, N'1.ª edición', 2020, N'978-3-6087-2438-7', 6, 1, 7),
  (23, N'1.ª edición', 2016, N'978-9-8281-9539-6', 2, 2, 3),
  (24, N'4.ª edición', 2017, N'978-1-1660-3304-0', 13, 4, 3),
  (25, N'3.ª edición', 2016, N'978-1-4203-8178-8', 11, 1, 6),
  (26, N'4.ª edición', 2021, N'978-0-3704-1214-6', 4, 1, 5),
  (27, N'1.ª edición', 2020, N'978-4-1828-8983-7', 8, 4, 1),
  (28, N'3.ª edición', 2012, N'978-8-6713-0066-7', 9, 1, 8),
  (29, N'2.ª edición', 2010, N'978-3-2838-5642-7', 8, 1, 1),
  (30, N'3.ª edición', 2007, N'978-2-9837-2527-9', 9, 1, 3);
SET IDENTITY_INSERT dbo.edicion OFF;
GO

-- >>> DML/022_libro.sql
-- libro
SET IDENTITY_INSERT dbo.libro ON;
INSERT INTO dbo.libro (id, titulo, descripcion, edicion_id, precio_venta, permite_digital, ruta_portada) VALUES
  (1, N'La sombra del río', N'Novela sobre una familia ribereña y sus secretos.', 1, 570.00, 1, N'/portadas/libro_001.jpg'),
  (2, N'Fundamentos de física moderna', N'Introducción a la mecánica cuántica y la relatividad.', 2, 425.00, 1, N'/portadas/libro_002.jpg'),
  (3, N'Programación en C# desde cero', N'Curso práctico para aprender a programar.', 3, 310.00, 1, N'/portadas/libro_003.jpg'),
  (4, N'Historia de Honduras: de la colonia a hoy', N'Recorrido por los hitos de la historia nacional.', 4, 270.00, 1, N'/portadas/libro_004.jpg'),
  (5, N'Memorias de un maestro rural', N'Testimonio de cuatro décadas de enseñanza en el campo.', 5, 465.00, 1, N'/portadas/libro_005.jpg'),
  (6, N'El pequeño explorador', N'Aventuras ilustradas para primeros lectores.', 6, 555.00, 1, N'/portadas/libro_006.jpg'),
  (7, N'Misión en la montaña', N'Novela juvenil de aventuras y amistad.', 7, 250.00, 1, N'/portadas/libro_007.jpg'),
  (8, N'Versos del amanecer', N'Poemario sobre la naturaleza y la esperanza.', 8, 460.00, 1, N'/portadas/libro_008.jpg'),
  (9, N'Historia del arte centroamericano', N'Panorama de las artes visuales de la región.', 9, 345.00, 0, N'/portadas/libro_009.jpg'),
  (10, N'Cocina tradicional hondureña', N'Recetas clásicas con ingredientes locales.', 10, 390.00, 0, N'/portadas/libro_010.jpg'),
  (11, N'Guía de nutrición familiar', N'Consejos para una alimentación equilibrada.', 11, 245.00, 1, N'/portadas/libro_011.jpg'),
  (12, N'Pedagogía para el siglo XXI', N'Métodos activos para el aula moderna.', 12, 380.00, 1, N'/portadas/libro_012.jpg'),
  (13, N'Finanzas para emprendedores', N'Manejo del dinero para nuevos negocios.', 13, 345.00, 1, N'/portadas/libro_013.jpg'),
  (14, N'El poder de los hábitos pequeños', N'Cómo lograr cambios duraderos paso a paso.', 14, 470.00, 1, N'/portadas/libro_014.jpg'),
  (15, N'Pensar con claridad', N'Introducción al razonamiento y la lógica.', 15, 345.00, 1, N'/portadas/libro_015.jpg'),
  (16, N'Las luces de la ciudad vieja', N'Narraciones urbanas de ficción contemporánea.', 16, 260.00, 1, N'/portadas/libro_016.jpg'),
  (17, N'Biología celular ilustrada', N'La célula explicada con esquemas a color.', 17, 540.00, 0, N'/portadas/libro_017.jpg'),
  (18, N'Bases de datos relacionales', N'Modelado, SQL y normalización.', 18, 595.00, 1, N'/portadas/libro_018.jpg'),
  (19, N'Rutas comerciales de Centroamérica', N'Estudio del comercio regional a través del tiempo.', 19, 345.00, 0, N'/portadas/libro_019.jpg'),
  (20, N'Una vida entre libros', N'Biografía de una bibliotecaria incansable.', 20, 325.00, 1, N'/portadas/libro_020.jpg'),
  (21, N'El dragón de papel', N'Cuento infantil sobre la imaginación.', 21, 390.00, 1, N'/portadas/libro_021.jpg'),
  (22, N'Diario de verano', N'Novela juvenil de vacaciones y descubrimientos.', 22, 260.00, 1, N'/portadas/libro_022.jpg'),
  (23, N'Poemas para una tarde de lluvia', N'Antología de poesía breve.', 23, 550.00, 1, N'/portadas/libro_023.jpg'),
  (24, N'Fotografía paso a paso', N'Técnicas básicas de composición y luz.', 24, 245.00, 0, N'/portadas/libro_024.jpg'),
  (25, N'Postres de la abuela', N'Recetario de dulces caseros.', 25, 345.00, 0, N'/portadas/libro_025.jpg'),
  (26, N'Primeros auxilios básicos', N'Manual rápido de atención de emergencias.', 26, 365.00, 0, N'/portadas/libro_026.jpg'),
  (27, N'Matemáticas divertidas', N'Ejercicios y juegos para aprender cálculo.', 27, 560.00, 1, N'/portadas/libro_027.jpg'),
  (28, N'Contabilidad básica para pequeños negocios', N'Registros esenciales para comercios.', 28, 480.00, 0, N'/portadas/libro_028.jpg'),
  (29, N'Equilibrio emocional', N'Herramientas para manejar el estrés.', 29, 600.00, 1, N'/portadas/libro_029.jpg'),
  (30, N'Introducción a la ética', N'Principales corrientes del pensamiento moral.', 30, 440.00, 1, N'/portadas/libro_030.jpg');
SET IDENTITY_INSERT dbo.libro OFF;
GO

-- >>> DML/023_detallecompra.sql
-- detallecompra
SET IDENTITY_INSERT dbo.detallecompra ON;
INSERT INTO dbo.detallecompra (id, compra_proveedor_id, libro_id, cantidad, costo_unitario) VALUES
  (1, 1, 1, 10, 422.00),
  (2, 2, 2, 34, 315.00),
  (3, 3, 3, 15, 228.00),
  (4, 4, 4, 41, 199.00),
  (5, 5, 5, 50, 346.00),
  (6, 6, 6, 36, 410.00),
  (7, 7, 7, 46, 185.00),
  (8, 8, 8, 31, 340.00),
  (9, 9, 9, 42, 257.00),
  (10, 10, 10, 32, 288.00),
  (11, 11, 11, 15, 180.00),
  (12, 12, 12, 47, 283.00),
  (13, 13, 13, 11, 256.00),
  (14, 14, 14, 26, 347.00),
  (15, 15, 15, 25, 254.00),
  (16, 16, 16, 17, 194.00),
  (17, 17, 17, 34, 399.00),
  (18, 18, 18, 25, 440.00),
  (19, 19, 19, 29, 257.00),
  (20, 20, 20, 48, 239.00),
  (21, 21, 21, 46, 289.00),
  (22, 22, 22, 46, 193.00),
  (23, 23, 23, 21, 407.00),
  (24, 24, 24, 29, 183.00),
  (25, 25, 25, 44, 257.00),
  (26, 26, 26, 10, 270.00),
  (27, 27, 27, 11, 414.00),
  (28, 28, 28, 31, 354.00),
  (29, 29, 29, 21, 444.00),
  (30, 30, 30, 39, 325.00);
SET IDENTITY_INSERT dbo.detallecompra OFF;
GO

-- >>> DML/024_estadoejemplar.sql
-- estadoejemplar
SET IDENTITY_INSERT dbo.estadoejemplar ON;
INSERT INTO dbo.estadoejemplar (id, nombre, descripcion) VALUES
  (1, N'Disponible', N'Listo para préstamo o venta.'),
  (2, N'Prestado', N'Actualmente en poder de un cliente.'),
  (3, N'Reservado', N'Apartado para un cliente.'),
  (4, N'En reparación', N'En proceso de encuadernación o reparación.'),
  (5, N'Dañado', N'Con daños que impiden su uso.'),
  (6, N'Perdido', N'No localizado tras inventario.'),
  (7, N'En catalogación', N'Pendiente de registro y clasificación.'),
  (8, N'En tránsito', N'En traslado entre sucursales.'),
  (9, N'Descartado', N'Dado de baja definitivamente.'),
  (10, N'En exhibición', N'Expuesto en sala o vitrina.'),
  (11, N'En restauración', N'En proceso de restauración.'),
  (12, N'En cuarentena', N'Aislado por revisión de calidad.'),
  (13, N'Donado', N'Entregado como donación.'),
  (14, N'Retirado de circulación', N'Fuera de uso por decisión administrativa.'),
  (15, N'Solo consulta en sala', N'No sale de la sucursal.');
SET IDENTITY_INSERT dbo.estadoejemplar OFF;
GO

-- >>> DML/025_ejemplar.sql
-- ejemplar
SET IDENTITY_INSERT dbo.ejemplar ON;
INSERT INTO dbo.ejemplar (id, codigo_barras, fecha_adquisicion, precio_adquisicion, libro_id, cubiculo_id, estado_ejemplar_id) VALUES
  (1, N'7500000000001', '2025-09-25', 422.00, 1, 1, 1),
  (2, N'7500000000002', '2025-12-13', 315.00, 2, 2, 1),
  (3, N'7500000000003', '2025-08-24', 228.00, 3, 3, 1),
  (4, N'7500000000004', '2025-10-06', 199.00, 4, 4, 1),
  (5, N'7500000000005', '2025-05-03', 346.00, 5, 5, 1),
  (6, N'7500000000006', '2026-04-01', 410.00, 6, 6, 10),
  (7, N'7500000000007', '2025-11-18', 185.00, 7, 7, 10),
  (8, N'7500000000008', '2026-02-18', 340.00, 8, 8, 1),
  (9, N'7500000000009', '2026-01-29', 257.00, 9, 9, 1),
  (10, N'7500000000010', '2026-02-20', 288.00, 10, 10, 4),
  (11, N'7500000000011', '2025-12-15', 180.00, 11, 11, 8),
  (12, N'7500000000012', '2025-06-30', 283.00, 12, 12, 3),
  (13, N'7500000000013', '2025-09-04', 256.00, 13, 13, 1),
  (14, N'7500000000014', '2025-08-24', 347.00, 14, 14, 1),
  (15, N'7500000000015', '2025-10-01', 254.00, 15, 15, 15),
  (16, N'7500000000016', '2025-06-11', 194.00, 16, 16, 1),
  (17, N'7500000000017', '2025-07-27', 399.00, 17, 17, 1),
  (18, N'7500000000018', '2026-03-04', 440.00, 18, 18, 1),
  (19, N'7500000000019', '2025-05-16', 257.00, 19, 19, 1),
  (20, N'7500000000020', '2025-12-29', 239.00, 20, 20, 12),
  (21, N'7500000000021', '2026-01-16', 289.00, 21, 21, 2),
  (22, N'7500000000022', '2025-11-04', 193.00, 22, 22, 1),
  (23, N'7500000000023', '2025-11-07', 407.00, 23, 23, 1),
  (24, N'7500000000024', '2025-03-19', 183.00, 24, 24, 1),
  (25, N'7500000000025', '2026-04-03', 257.00, 25, 25, 2),
  (26, N'7500000000026', '2026-01-23', 270.00, 26, 26, 1),
  (27, N'7500000000027', '2026-02-08', 414.00, 27, 27, 5),
  (28, N'7500000000028', '2025-07-22', 354.00, 28, 28, 1),
  (29, N'7500000000029', '2025-03-24', 444.00, 29, 29, 1),
  (30, N'7500000000030', '2025-06-23', 325.00, 30, 30, 1);
SET IDENTITY_INSERT dbo.ejemplar OFF;
GO

-- >>> DML/026_estadoprestamo.sql
-- estadoprestamo
SET IDENTITY_INSERT dbo.estadoprestamo ON;
INSERT INTO dbo.estadoprestamo (id, nombre, descripcion) VALUES
  (1, N'Activo', N'Préstamo vigente.'),
  (2, N'Devuelto', N'Todos los ejemplares fueron devueltos.'),
  (3, N'Vencido', N'Pasó la fecha límite sin devolución.'),
  (4, N'Renovado', N'Se amplió el plazo de entrega.'),
  (5, N'Reservado', N'Préstamo apartado, aún sin entrega.'),
  (6, N'Perdido', N'El ejemplar fue reportado como perdido.'),
  (7, N'Dañado', N'Se devolvió con daños.'),
  (8, N'En mora', N'Con multas pendientes de pago.'),
  (9, N'Cancelado', N'Cancelado antes de la entrega.'),
  (10, N'Pendiente de entrega', N'Aprobado, falta entregar al cliente.'),
  (11, N'Pendiente de devolución', N'Esperando la devolución del ejemplar.'),
  (12, N'Parcialmente devuelto', N'Devolvió solo parte de los ejemplares.'),
  (13, N'En revisión', N'Bajo revisión administrativa.'),
  (14, N'Extendido', N'Con plazo extendido por excepción.'),
  (15, N'Cerrado', N'Préstamo finalizado y sin saldo pendiente.');
SET IDENTITY_INSERT dbo.estadoprestamo OFF;
GO

-- >>> DML/027_prestamo.sql
-- prestamo
SET IDENTITY_INSERT dbo.prestamo ON;
INSERT INTO dbo.prestamo (id, fecha_prestamo, fecha_vencimiento, observacion, cliente_id, empleado_id, estado_prestamo_id, numero_renovaciones) VALUES
  (1, '2026-07-30', '2026-08-06', N'Préstamo por 7 días.', 26, 6, 2, 0),
  (2, '2026-07-26', '2026-08-02', N'Préstamo por 7 días.', 18, 30, 15, 0),
  (3, '2026-08-24', '2026-08-31', N'Préstamo por 7 días.', 10, 17, 2, 0),
  (4, '2026-03-10', '2026-03-24', N'Préstamo por 14 días.', 16, 21, 15, 1),
  (5, '2026-09-25', '2026-10-09', N'Préstamo por 14 días.', 14, 27, 2, 0),
  (6, '2026-09-21', '2026-10-05', N'Préstamo por 14 días.', 13, 25, 15, 0),
  (7, '2026-07-10', '2026-07-17', N'Préstamo por 7 días.', 28, 12, 2, 0),
  (8, '2026-07-25', '2026-08-08', N'Préstamo por 14 días.', 17, 14, 15, 0),
  (9, '2026-03-09', '2026-03-23', N'Préstamo por 14 días.', 17, 21, 2, 0),
  (10, '2026-02-07', '2026-02-21', N'Préstamo por 14 días.', 21, 15, 15, 1),
  (11, '2026-03-09', '2026-03-16', N'Préstamo por 7 días.', 5, 8, 2, 0),
  (12, '2026-02-20', '2026-02-27', N'Préstamo por 7 días.', 29, 14, 15, 0),
  (13, '2026-02-24', '2026-03-03', N'Préstamo por 7 días.', 14, 6, 2, 0),
  (14, '2026-07-03', '2026-07-10', N'Préstamo por 7 días.', 5, 28, 15, 0),
  (15, '2026-02-12', '2026-02-26', N'Préstamo por 14 días.', 25, 19, 2, 0),
  (16, '2026-05-14', '2026-05-21', N'Préstamo por 7 días.', 15, 17, 15, 0),
  (17, '2026-08-19', '2026-08-26', N'Préstamo por 7 días.', 17, 27, 2, 0),
  (18, '2026-04-16', '2026-05-07', N'Préstamo por 21 días.', 11, 23, 15, 1),
  (19, '2026-07-16', '2026-08-06', N'Préstamo por 21 días.', 28, 12, 2, 0),
  (20, '2026-07-06', '2026-07-20', N'Préstamo por 14 días.', 9, 26, 15, 0),
  (21, '2026-01-16', '2026-02-06', N'Préstamo por 21 días.', 18, 18, 2, 0),
  (22, '2026-05-16', '2026-05-23', N'Préstamo por 7 días.', 2, 7, 15, 0),
  (23, '2026-10-08', '2026-10-22', N'Préstamo por 14 días.', 20, 22, 2, 0),
  (24, '2026-08-07', '2026-08-14', N'Préstamo por 7 días.', 3, 23, 15, 0),
  (25, '2026-01-17', '2026-01-31', N'Préstamo por 14 días.', 12, 30, 2, 0),
  (26, '2026-01-31', '2026-02-14', N'Préstamo por 14 días.', 9, 5, 15, 0),
  (27, '2026-08-04', '2026-08-18', N'Préstamo por 14 días.', 21, 21, 2, 0),
  (28, '2026-05-23', '2026-06-13', N'Préstamo por 21 días.', 20, 17, 15, 1),
  (29, '2026-02-26', '2026-03-05', N'Préstamo por 7 días.', 3, 13, 2, 0),
  (30, '2026-02-21', '2026-03-07', N'Préstamo por 14 días.', 11, 7, 15, 0);
SET IDENTITY_INSERT dbo.prestamo OFF;
GO

-- >>> DML/028_detalleprestamo.sql
-- detalleprestamo
SET IDENTITY_INSERT dbo.detalleprestamo ON;
INSERT INTO dbo.detalleprestamo (id, prestamo_id, ejemplar_id) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5),
  (6, 6, 6),
  (7, 7, 7),
  (8, 8, 8),
  (9, 9, 9),
  (10, 10, 10),
  (11, 11, 11),
  (12, 12, 12),
  (13, 13, 13),
  (14, 14, 14),
  (15, 15, 15),
  (16, 16, 16),
  (17, 17, 17),
  (18, 18, 18),
  (19, 19, 19),
  (20, 20, 20),
  (21, 21, 21),
  (22, 22, 22),
  (23, 23, 23),
  (24, 24, 24),
  (25, 25, 25),
  (26, 26, 26),
  (27, 27, 27),
  (28, 28, 28),
  (29, 29, 29),
  (30, 30, 30);
SET IDENTITY_INSERT dbo.detalleprestamo OFF;
GO

-- >>> DML/029_devolucion.sql
-- devolucion
SET IDENTITY_INSERT dbo.devolucion ON;
INSERT INTO dbo.devolucion (id, fecha_devolucion, observacion, empleado_id) VALUES
  (1, '2026-08-11 10:14:00', N'Devolución registrada en mostrador.', 13),
  (2, '2026-08-06 17:24:00', N'Devolución registrada en mostrador.', 23),
  (3, '2026-08-31 09:47:00', N'Devolución registrada en mostrador.', 20),
  (4, '2026-03-31 09:39:00', N'Devolución registrada en mostrador.', 10),
  (5, '2026-10-13 12:44:00', N'Devolución registrada en mostrador.', 21),
  (6, '2026-10-11 17:14:00', N'Devolución registrada en mostrador.', 1),
  (7, '2026-07-24 09:06:00', N'Devolución registrada en mostrador.', 8),
  (8, '2026-08-08 12:23:00', N'Devolución registrada en mostrador.', 1),
  (9, '2026-03-29 10:26:00', N'Devolución registrada en mostrador.', 8),
  (10, '2026-02-20 15:06:00', N'Devolución registrada en mostrador.', 21),
  (11, '2026-03-22 16:29:00', N'Devolución registrada en mostrador.', 28),
  (12, '2026-03-08 10:28:00', N'Devolución registrada en mostrador.', 16),
  (13, '2026-03-11 10:16:00', N'Devolución registrada en mostrador.', 23),
  (14, '2026-07-05 13:16:00', N'Devolución registrada en mostrador.', 25),
  (15, '2026-02-23 13:20:00', N'Devolución registrada en mostrador.', 14),
  (16, '2026-05-24 13:26:00', N'Devolución registrada en mostrador.', 24),
  (17, '2026-09-01 13:16:00', N'Devolución registrada en mostrador.', 10),
  (18, '2026-05-12 10:42:00', N'Devolución registrada en mostrador.', 11),
  (19, '2026-08-04 15:48:00', N'Devolución registrada en mostrador.', 22),
  (20, '2026-07-26 16:00:00', N'Devolución registrada en mostrador.', 12),
  (21, '2026-02-10 09:07:00', N'Devolución registrada en mostrador.', 25),
  (22, '2026-05-24 10:14:00', N'Devolución registrada en mostrador.', 6),
  (23, '2026-10-20 17:33:00', N'Devolución registrada en mostrador.', 21),
  (24, '2026-08-12 10:50:00', N'Devolución registrada en mostrador.', 26),
  (25, '2026-02-08 17:43:00', N'Devolución registrada en mostrador.', 27),
  (26, '2026-02-18 17:10:00', N'Devolución registrada en mostrador.', 20),
  (27, '2026-08-27 11:50:00', N'Devolución registrada en mostrador.', 1),
  (28, '2026-06-22 11:13:00', N'Devolución registrada en mostrador.', 11),
  (29, '2026-03-14 14:25:00', N'Devolución registrada en mostrador.', 3),
  (30, '2026-03-09 13:05:00', N'Devolución registrada en mostrador.', 10);
SET IDENTITY_INSERT dbo.devolucion OFF;
GO

-- >>> DML/030_detalledevolucion.sql
-- detalledevolucion
SET IDENTITY_INSERT dbo.detalledevolucion ON;
INSERT INTO dbo.detalledevolucion (id, devolucion_id, detalle_prestamo_id, condicion_entrega, observacion) VALUES
  (1, 1, 1, N'Con desgaste normal', N'Se anotó: con desgaste normal.'),
  (2, 2, 2, N'Páginas dobladas', N'Se anotó: páginas dobladas.'),
  (3, 3, 3, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (4, 4, 4, N'Con anotaciones', N'Se anotó: con anotaciones.'),
  (5, 5, 5, N'Con manchas', N'Se anotó: con manchas.'),
  (6, 6, 6, N'Portada dañada', N'Se anotó: portada dañada.'),
  (7, 7, 7, N'Con desgaste normal', N'Se anotó: con desgaste normal.'),
  (8, 8, 8, N'Con manchas', N'Se anotó: con manchas.'),
  (9, 9, 9, N'Páginas dobladas', N'Se anotó: páginas dobladas.'),
  (10, 10, 10, N'Buen estado', NULL),
  (11, 11, 11, N'Buen estado', NULL),
  (12, 12, 12, N'Buen estado', NULL),
  (13, 13, 13, N'Con manchas', N'Se anotó: con manchas.'),
  (14, 14, 14, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (15, 15, 15, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (16, 16, 16, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (17, 17, 17, N'Buen estado', NULL),
  (18, 18, 18, N'Portada dañada', N'Se anotó: portada dañada.'),
  (19, 19, 19, N'Portada dañada', N'Se anotó: portada dañada.'),
  (20, 20, 20, N'Portada dañada', N'Se anotó: portada dañada.'),
  (21, 21, 21, N'Páginas dobladas', N'Se anotó: páginas dobladas.'),
  (22, 22, 22, N'Buen estado', NULL),
  (23, 23, 23, N'Con manchas', N'Se anotó: con manchas.'),
  (24, 24, 24, N'Buen estado', NULL),
  (25, 25, 25, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (26, 26, 26, N'Portada dañada', N'Se anotó: portada dañada.'),
  (27, 27, 27, N'Páginas dobladas', N'Se anotó: páginas dobladas.'),
  (28, 28, 28, N'Con desgaste normal', N'Se anotó: con desgaste normal.'),
  (29, 29, 29, N'Lomo despegado', N'Se anotó: lomo despegado.'),
  (30, 30, 30, N'Con manchas', N'Se anotó: con manchas.');
SET IDENTITY_INSERT dbo.detalledevolucion OFF;
GO

-- >>> DML/031_factura.sql
-- factura
SET IDENTITY_INSERT dbo.factura ON;
INSERT INTO dbo.factura (id, fecha, cliente_id, empleado_id, canal) VALUES
  (1, '2026-02-26 16:22:54', 30, 8, N'T'),
  (2, '2026-02-18 12:09:17', 15, 13, N'T'),
  (3, '2026-07-08 09:16:43', 27, 14, N'L'),
  (4, '2026-07-03 10:44:58', 27, 2, N'T'),
  (5, '2026-09-11 09:56:12', 21, 7, N'T'),
  (6, '2026-02-16 13:12:01', NULL, 21, N'T'),
  (7, '2026-10-25 14:43:21', 18, 24, N'L'),
  (8, '2026-08-03 18:36:45', 16, 30, N'L'),
  (9, '2026-09-08 08:40:41', 11, 28, N'T'),
  (10, '2026-10-27 13:51:25', 18, 28, N'L'),
  (11, '2026-02-11 14:29:59', 22, 2, N'T'),
  (12, '2026-09-30 10:55:42', NULL, 16, N'T'),
  (13, '2026-08-02 09:16:07', 8, 14, N'T'),
  (14, '2026-06-23 11:29:43', 1, 4, N'T'),
  (15, '2026-10-02 13:11:25', 29, 26, N'L'),
  (16, '2026-07-05 10:19:48', 14, 10, N'T'),
  (17, '2026-09-10 11:05:25', 13, 28, N'T'),
  (18, '2026-10-09 12:49:20', NULL, 23, N'T'),
  (19, '2026-07-20 16:05:54', 7, 24, N'L'),
  (20, '2026-09-24 10:14:46', 25, 8, N'T'),
  (21, '2026-09-27 15:02:17', 28, 24, N'L'),
  (22, '2026-02-24 12:53:56', 25, 15, N'T'),
  (23, '2026-03-07 14:56:33', 17, 14, N'T'),
  (24, '2026-03-19 09:44:43', NULL, 9, N'T'),
  (25, '2026-10-26 10:15:20', 26, 19, N'L'),
  (26, '2026-06-19 08:43:18', 30, 6, N'T'),
  (27, '2026-10-05 12:29:33', 25, 23, N'L'),
  (28, '2026-04-07 12:51:17', 13, 1, N'T'),
  (29, '2026-08-09 14:48:35', 23, 1, N'L'),
  (30, '2026-03-08 08:56:01', NULL, 23, N'T');
SET IDENTITY_INSERT dbo.factura OFF;
GO

-- >>> DML/032_impuesto.sql
-- impuesto
SET IDENTITY_INSERT dbo.impuesto ON;
INSERT INTO dbo.impuesto (id, nombre, porcentaje, fecha_inicio, fecha_fin, estado) VALUES
  (1, N'ISV 15%', 15.00, '2024-01-01', NULL, 1),
  (2, N'ISV 18%', 18.00, '2024-01-01', NULL, 1),
  (3, N'Exento', 0.00, '2024-01-01', NULL, 1),
  (4, N'Impuesto selectivo 5%', 5.00, '2024-01-01', NULL, 1),
  (5, N'Impuesto selectivo 10%', 10.00, '2024-01-01', NULL, 1),
  (6, N'Tasa municipal 1%', 1.00, '2024-01-01', NULL, 1),
  (7, N'Tasa municipal 2%', 2.00, '2024-01-01', NULL, 1),
  (8, N'Impuesto de turismo 4%', 4.00, '2024-01-01', NULL, 1),
  (9, N'Contribución especial 3%', 3.00, '2024-01-01', NULL, 1),
  (10, N'Impuesto cultural 2%', 2.00, '2024-01-01', NULL, 1),
  (11, N'Impuesto educativo 1%', 1.00, '2024-01-01', NULL, 1),
  (12, N'Impuesto ambiental 2.5%', 2.50, '2024-01-01', NULL, 1),
  (13, N'Recargo regional 0.5%', 0.50, '2024-01-01', NULL, 1),
  (14, N'Impuesto temporal 6%', 6.00, '2024-01-01', '2025-12-31', 0),
  (15, N'Impuesto de lujo 12%', 12.00, '2024-01-01', '2025-12-31', 0);
SET IDENTITY_INSERT dbo.impuesto OFF;
GO

-- >>> DML/033_detallefactura.sql
-- detallefactura
SET IDENTITY_INSERT dbo.detallefactura ON;
INSERT INTO dbo.detallefactura (id, factura_id, libro_id, cantidad, precio_unitario, descuento, descuento_id, impuesto_id, monto_impuesto) VALUES
  (1, 1, 17, 3, 538.65, 0.00, NULL, 1, 242.39),
  (2, 2, 21, 3, 390.15, 0.00, NULL, 1, 175.57),
  (3, 3, 16, 1, 261.90, 25.00, 8, 1, 35.54),
  (4, 4, 2, 1, 425.25, 0.00, NULL, 1, 63.79),
  (5, 5, 22, 3, 260.55, 0.00, NULL, 1, 117.25),
  (6, 6, 1, 2, 569.70, 56.97, 2, 1, 162.36),
  (7, 7, 27, 3, 558.90, 0.00, NULL, 2, 301.81),
  (8, 8, 25, 3, 346.95, 0.00, NULL, 1, 156.13),
  (9, 9, 30, 2, 438.75, 175.50, 4, 1, 105.30),
  (10, 10, 14, 1, 468.45, 0.00, NULL, 3, 0.00),
  (11, 11, 20, 3, 322.65, 0.00, NULL, 1, 145.19),
  (12, 12, 29, 2, 599.40, 59.94, 2, 1, 170.83),
  (13, 13, 28, 1, 477.90, 0.00, NULL, 1, 71.69),
  (14, 14, 11, 1, 243.00, 0.00, NULL, 2, 43.74),
  (15, 15, 10, 3, 388.80, 174.96, 3, 1, 148.72),
  (16, 16, 19, 2, 346.95, 0.00, NULL, 1, 104.09),
  (17, 17, 13, 2, 345.60, 0.00, NULL, 1, 103.68),
  (18, 18, 4, 1, 268.65, 26.87, 14, 1, 36.27),
  (19, 19, 9, 2, 346.95, 0.00, NULL, 1, 104.09),
  (20, 20, 26, 2, 364.50, 0.00, NULL, 3, 0.00),
  (21, 21, 7, 2, 249.75, 49.95, 14, 2, 80.92),
  (22, 22, 24, 2, 247.05, 0.00, NULL, 1, 74.12),
  (23, 23, 6, 3, 553.50, 0.00, NULL, 1, 249.08),
  (24, 24, 5, 1, 467.10, 46.71, 14, 1, 63.06),
  (25, 25, 12, 2, 382.05, 0.00, NULL, 1, 114.62),
  (26, 26, 18, 3, 594.00, 0.00, NULL, 1, 267.30),
  (27, 27, 15, 3, 342.90, 51.44, 2, 1, 146.59),
  (28, 28, 8, 1, 459.00, 0.00, NULL, 2, 82.62),
  (29, 29, 23, 3, 549.45, 0.00, NULL, 1, 247.25),
  (30, 30, 3, 1, 307.80, 61.56, 13, 3, 0.00);
SET IDENTITY_INSERT dbo.detallefactura OFF;
GO

-- >>> DML/034_formapago.sql
-- formapago
SET IDENTITY_INSERT dbo.formapago ON;
INSERT INTO dbo.formapago (id, nombre) VALUES
  (1, N'Efectivo'),
  (2, N'Tarjeta de crédito'),
  (3, N'Tarjeta de débito'),
  (4, N'Transferencia bancaria'),
  (5, N'Cheque'),
  (6, N'Depósito bancario'),
  (7, N'Billetera móvil'),
  (8, N'Pago en línea'),
  (9, N'Vale de regalo'),
  (10, N'Nota de crédito'),
  (11, N'Pago mixto'),
  (12, N'Pago a plazos'),
  (13, N'Código QR'),
  (14, N'Cupón de canje'),
  (15, N'Pago contra entrega');
SET IDENTITY_INSERT dbo.formapago OFF;
GO

-- >>> DML/035_facturaformapago.sql
-- facturaformapago
INSERT INTO dbo.facturaformapago (factura_id, forma_pago_id, monto, referencia) VALUES
  (1, 5, 1858.34, N'REF-596758'),
  (2, 2, 1346.02, N'REF-317923'),
  (3, 6, 272.44, N'REF-397741'),
  (4, 5, 489.04, N'REF-893101'),
  (5, 1, 898.90, NULL),
  (6, 5, 1244.79, N'REF-623147'),
  (7, 4, 1978.51, N'REF-144808'),
  (8, 8, 1196.98, N'REF-823476'),
  (9, 9, 807.30, N'REF-366346'),
  (10, 11, 468.45, N'REF-779136'),
  (11, 10, 1113.14, N'REF-141436'),
  (12, 12, 1309.69, N'REF-776802'),
  (13, 11, 549.59, N'REF-317688'),
  (14, 12, 286.74, N'REF-653146'),
  (15, 14, 1140.16, N'REF-308585'),
  (16, 14, 797.99, N'REF-557298'),
  (17, 14, 794.88, N'REF-325583'),
  (18, 15, 278.05, N'REF-946527'),
  (19, 3, 797.99, N'REF-183068'),
  (20, 10, 729.00, N'REF-525987'),
  (21, 2, 530.47, N'REF-761440'),
  (22, 12, 568.22, N'REF-948764'),
  (23, 6, 1909.58, N'REF-539272'),
  (24, 1, 483.45, NULL),
  (25, 4, 878.72, N'REF-378144'),
  (26, 15, 2049.30, N'REF-387090'),
  (27, 13, 1123.85, N'REF-676215'),
  (28, 7, 541.62, N'REF-197350'),
  (29, 9, 1895.60, N'REF-100472'),
  (30, 6, 246.24, N'REF-765551');
GO

-- >>> DML/036_historialcliente.sql
-- historialcliente
SET IDENTITY_INSERT dbo.historialcliente ON;
INSERT INTO dbo.historialcliente (id, cliente_id, empleado_id, fecha_cambio, tipo_cambio, descripcion) VALUES
  (1, 1, 1, '2026-01-15 15:03:49', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (2, 2, 19, '2026-03-01 15:49:03', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (3, 3, 25, '2026-11-05 10:31:12', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (4, 4, 2, '2026-07-15 15:02:12', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (5, 5, 10, '2026-09-30 16:30:28', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (6, 6, 23, '2026-02-23 14:45:25', N'Actualización de dirección', N'Se actualizó la dirección de residencia.'),
  (7, 7, 29, '2026-02-27 12:25:15', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (8, 8, 3, '2026-02-15 08:11:01', N'Cambio de tipo de cliente', N'Se modificó la categoría asignada al cliente.'),
  (9, 9, 17, '2026-05-08 08:03:54', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (10, 10, 1, '2026-04-20 08:00:19', N'Cambio de tipo de cliente', N'Se modificó la categoría asignada al cliente.'),
  (11, 11, 13, '2026-04-15 15:05:56', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (12, 12, 16, '2026-02-24 13:58:22', N'Renovación de credencial', N'Se renovó la credencial por un año.'),
  (13, 13, 27, '2026-11-03 11:58:02', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (14, 14, 29, '2026-03-16 14:28:02', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (15, 15, 23, '2026-02-21 10:49:38', N'Actualización de dirección', N'Se actualizó la dirección de residencia.'),
  (16, 16, 16, '2026-01-15 13:50:31', N'Renovación de credencial', N'Se renovó la credencial por un año.'),
  (17, 17, 24, '2026-04-03 17:45:39', N'Actualización de dirección', N'Se actualizó la dirección de residencia.'),
  (18, 18, 7, '2026-11-05 16:04:47', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (19, 19, 7, '2026-09-13 08:53:08', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (20, 20, 22, '2026-02-25 16:26:07', N'Renovación de credencial', N'Se renovó la credencial por un año.'),
  (21, 21, 18, '2026-03-07 10:52:37', N'Cambio de tipo de cliente', N'Se modificó la categoría asignada al cliente.'),
  (22, 22, 20, '2026-02-28 12:31:59', N'Actualización de dirección', N'Se actualizó la dirección de residencia.'),
  (23, 23, 22, '2026-07-30 15:52:21', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (24, 24, 9, '2026-10-10 13:03:27', N'Cambio de tipo de cliente', N'Se modificó la categoría asignada al cliente.'),
  (25, 25, 8, '2026-06-22 09:25:31', N'Renovación de credencial', N'Se renovó la credencial por un año.'),
  (26, 26, 26, '2026-09-27 10:57:52', N'Renovación de credencial', N'Se renovó la credencial por un año.'),
  (27, 27, 19, '2026-08-30 11:16:35', N'Cambio de tipo de cliente', N'Se modificó la categoría asignada al cliente.'),
  (28, 28, 5, '2026-05-21 09:29:57', N'Actualización de correo', N'Se actualizó la dirección de correo del cliente.'),
  (29, 29, 13, '2026-05-20 11:52:47', N'Cambio de teléfono', N'Se registró un nuevo número de contacto.'),
  (30, 30, 13, '2026-03-23 16:51:10', N'Renovación de credencial', N'Se renovó la credencial por un año.');
SET IDENTITY_INSERT dbo.historialcliente OFF;
GO

-- >>> DML/037_historialprestamo.sql
-- historialprestamo
SET IDENTITY_INSERT dbo.historialprestamo ON;
INSERT INTO dbo.historialprestamo (id, prestamo_id, empleado_id, fecha_cambio, estado_anterior, estado_nuevo, observacion) VALUES
  (1, 1, 18, '2026-08-11 10:14:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (2, 2, 30, '2026-08-06 17:24:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (3, 3, 19, '2026-08-31 09:47:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (4, 4, 20, '2026-03-31 09:39:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (5, 5, 22, '2026-10-13 12:44:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (6, 6, 20, '2026-10-11 17:14:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (7, 7, 20, '2026-07-24 09:06:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (8, 8, 13, '2026-08-08 12:23:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (9, 9, 29, '2026-03-29 10:26:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (10, 10, 6, '2026-02-20 15:06:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (11, 11, 5, '2026-03-22 16:29:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (12, 12, 24, '2026-03-08 10:28:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (13, 13, 4, '2026-03-11 10:16:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (14, 14, 30, '2026-07-05 13:16:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (15, 15, 14, '2026-02-23 13:20:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (16, 16, 23, '2026-05-24 13:26:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (17, 17, 30, '2026-09-01 13:16:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (18, 18, 15, '2026-05-12 10:42:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (19, 19, 1, '2026-08-04 15:48:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (20, 20, 20, '2026-07-26 16:00:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (21, 21, 10, '2026-02-10 09:07:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (22, 22, 28, '2026-05-24 10:14:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (23, 23, 28, '2026-10-20 17:33:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (24, 24, 27, '2026-08-12 10:50:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (25, 25, 30, '2026-02-08 17:43:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (26, 26, 15, '2026-02-18 17:10:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (27, 27, 7, '2026-08-27 11:50:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (28, 28, 29, '2026-06-22 11:13:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.'),
  (29, 29, 19, '2026-03-14 14:25:00', N'Activo', N'Devuelto', N'Cambio de estado registrado automáticamente.'),
  (30, 30, 18, '2026-03-09 13:05:00', N'Devuelto', N'Cerrado', N'Cambio de estado registrado automáticamente.');
SET IDENTITY_INSERT dbo.historialprestamo OFF;
GO

-- >>> DML/038_incidenciaejemplar.sql
-- incidenciaejemplar
SET IDENTITY_INSERT dbo.incidenciaejemplar ON;
INSERT INTO dbo.incidenciaejemplar (id, ejemplar_id, empleado_id, tipo_incidencia, fecha_reporte, descripcion, estado, fecha_resolucion) VALUES
  (1, 29, 23, N'HUMEDAD', '2026-04-09 08:33:46', N'Se detectó humedad en el lomo.', N'ABIERTA', NULL),
  (2, 24, 10, N'PÉRDIDA', '2026-03-30 18:09:01', N'Ejemplar no localizado en el estante.', N'RESUELTA', '2026-04-02 18:09:01'),
  (3, 1, 26, N'ETIQUETA', '2026-10-04 11:29:44', N'Etiqueta de código ilegible.', N'EN PROCESO', NULL),
  (4, 21, 4, N'HUMEDAD', '2026-02-01 14:03:56', N'Se detectó humedad en el lomo.', N'RESUELTA', '2026-02-10 14:03:56'),
  (5, 4, 15, N'HUMEDAD', '2026-01-15 12:07:20', N'Se detectó humedad en el lomo.', N'RESUELTA', '2026-01-30 12:07:20'),
  (6, 21, 5, N'HUMEDAD', '2026-03-04 11:14:47', N'Se detectó humedad en el lomo.', N'ABIERTA', NULL),
  (7, 24, 14, N'DESGASTE', '2026-07-25 17:23:56', N'Desgaste excesivo en la portada.', N'EN PROCESO', NULL),
  (8, 13, 23, N'PÉRDIDA', '2026-10-06 10:58:29', N'Ejemplar no localizado en el estante.', N'RESUELTA', '2026-10-07 10:58:29'),
  (9, 4, 6, N'HUMEDAD', '2026-02-27 17:25:40', N'Se detectó humedad en el lomo.', N'EN PROCESO', NULL),
  (10, 15, 2, N'DAÑO', '2026-10-07 13:25:03', N'Ejemplar con páginas rasgadas.', N'EN PROCESO', NULL),
  (11, 25, 23, N'DAÑO', '2026-03-16 11:34:25', N'Ejemplar con páginas rasgadas.', N'EN PROCESO', NULL),
  (12, 5, 16, N'HUMEDAD', '2026-06-30 11:16:14', N'Se detectó humedad en el lomo.', N'RESUELTA', '2026-07-05 11:16:14'),
  (13, 28, 24, N'ETIQUETA', '2026-06-23 08:04:12', N'Etiqueta de código ilegible.', N'RESUELTA', '2026-06-29 08:04:12'),
  (14, 29, 24, N'DAÑO', '2026-02-06 14:12:56', N'Ejemplar con páginas rasgadas.', N'ABIERTA', NULL),
  (15, 6, 25, N'ETIQUETA', '2026-09-09 09:41:07', N'Etiqueta de código ilegible.', N'ABIERTA', NULL),
  (16, 14, 11, N'DESGASTE', '2026-05-10 18:23:04', N'Desgaste excesivo en la portada.', N'EN PROCESO', NULL),
  (17, 21, 14, N'HUMEDAD', '2026-01-28 17:55:35', N'Se detectó humedad en el lomo.', N'RESUELTA', '2026-02-06 17:55:35'),
  (18, 13, 3, N'DAÑO', '2026-06-25 12:13:06', N'Ejemplar con páginas rasgadas.', N'ABIERTA', NULL),
  (19, 1, 6, N'DAÑO', '2026-01-22 10:11:22', N'Ejemplar con páginas rasgadas.', N'EN PROCESO', NULL),
  (20, 4, 3, N'DAÑO', '2026-04-01 08:23:45', N'Ejemplar con páginas rasgadas.', N'RESUELTA', '2026-04-06 08:23:45'),
  (21, 7, 10, N'HUMEDAD', '2026-05-18 09:51:32', N'Se detectó humedad en el lomo.', N'EN PROCESO', NULL),
  (22, 17, 13, N'DAÑO', '2026-10-07 10:51:13', N'Ejemplar con páginas rasgadas.', N'ABIERTA', NULL),
  (23, 29, 24, N'DAÑO', '2026-07-20 10:46:07', N'Ejemplar con páginas rasgadas.', N'EN PROCESO', NULL),
  (24, 26, 17, N'PÉRDIDA', '2026-04-09 11:44:51', N'Ejemplar no localizado en el estante.', N'EN PROCESO', NULL),
  (25, 13, 2, N'ETIQUETA', '2026-09-17 16:29:31', N'Etiqueta de código ilegible.', N'EN PROCESO', NULL),
  (26, 10, 27, N'DESGASTE', '2026-07-13 12:58:10', N'Desgaste excesivo en la portada.', N'ABIERTA', NULL),
  (27, 5, 25, N'ETIQUETA', '2026-06-05 18:09:16', N'Etiqueta de código ilegible.', N'RESUELTA', '2026-06-13 18:09:16'),
  (28, 20, 26, N'ETIQUETA', '2026-02-15 18:45:10', N'Etiqueta de código ilegible.', N'RESUELTA', '2026-03-02 18:45:10'),
  (29, 13, 2, N'ETIQUETA', '2026-05-20 18:28:25', N'Etiqueta de código ilegible.', N'RESUELTA', '2026-05-25 18:28:25'),
  (30, 24, 2, N'ETIQUETA', '2026-05-04 17:14:25', N'Etiqueta de código ilegible.', N'ABIERTA', NULL);
SET IDENTITY_INSERT dbo.incidenciaejemplar OFF;
GO

-- >>> DML/039_inventariosucursal.sql
-- inventariosucursal
SET IDENTITY_INSERT dbo.inventariosucursal ON;
INSERT INTO dbo.inventariosucursal (id, sucursal_id, libro_id, cantidad_disponible, cantidad_danada, cantidad_reservada, fecha_actualizacion) VALUES
  (1, 1, 1, 25, 2, 0, '2026-10-07 17:25:23'),
  (2, 2, 2, 31, 0, 4, '2026-10-23 08:21:27'),
  (3, 3, 3, 18, 1, 1, '2026-09-27 16:29:59'),
  (4, 4, 4, 40, 1, 3, '2026-11-09 15:29:06'),
  (5, 5, 5, 2, 3, 2, '2026-10-03 12:25:53'),
  (6, 6, 6, 40, 2, 0, '2026-10-02 15:11:01'),
  (7, 7, 7, 22, 3, 4, '2026-10-02 10:52:26'),
  (8, 8, 8, 26, 0, 3, '2026-10-14 14:32:37'),
  (9, 9, 9, 26, 2, 0, '2026-10-23 12:34:03'),
  (10, 10, 10, 33, 1, 0, '2026-10-02 17:27:10'),
  (11, 11, 11, 13, 0, 4, '2026-11-20 16:56:28'),
  (12, 12, 12, 28, 2, 1, '2026-11-18 15:05:07'),
  (13, 13, 13, 2, 0, 4, '2026-11-06 17:50:31'),
  (14, 14, 14, 28, 0, 0, '2026-09-23 16:51:08'),
  (15, 15, 15, 12, 0, 3, '2026-09-03 09:40:58'),
  (16, 1, 16, 29, 1, 4, '2026-11-06 12:19:11'),
  (17, 2, 17, 33, 1, 0, '2026-10-19 10:17:54'),
  (18, 3, 18, 19, 1, 0, '2026-10-30 15:17:27'),
  (19, 4, 19, 26, 2, 1, '2026-09-22 18:13:07'),
  (20, 5, 20, 29, 3, 3, '2026-10-28 17:10:05'),
  (21, 6, 21, 20, 0, 5, '2026-10-18 11:54:48'),
  (22, 7, 22, 20, 2, 3, '2026-11-17 18:25:28'),
  (23, 8, 23, 10, 2, 1, '2026-09-09 16:58:37'),
  (24, 9, 24, 38, 0, 1, '2026-09-28 10:04:08'),
  (25, 10, 25, 29, 3, 4, '2026-10-24 17:10:56'),
  (26, 11, 26, 12, 3, 0, '2026-09-29 16:12:49'),
  (27, 12, 27, 9, 1, 4, '2026-10-05 15:05:23'),
  (28, 13, 28, 3, 1, 5, '2026-11-19 13:09:39'),
  (29, 14, 29, 13, 0, 3, '2026-10-08 10:21:24'),
  (30, 15, 30, 22, 3, 4, '2026-11-04 11:30:06');
SET IDENTITY_INSERT dbo.inventariosucursal OFF;
GO

-- >>> DML/040_libroautor.sql
-- libroautor
INSERT INTO dbo.libroautor (libro_id, autor_id, orden_autoria) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 1),
  (5, 5, 1),
  (6, 6, 1),
  (7, 7, 1),
  (8, 8, 1),
  (9, 9, 1),
  (10, 10, 1),
  (11, 11, 1),
  (12, 12, 1),
  (13, 13, 1),
  (14, 14, 1),
  (15, 15, 1),
  (16, 16, 1),
  (17, 17, 1),
  (18, 18, 1),
  (19, 19, 1),
  (20, 20, 1),
  (21, 21, 1),
  (22, 22, 1),
  (23, 23, 1),
  (24, 24, 1),
  (25, 25, 1),
  (26, 26, 1),
  (27, 27, 1),
  (28, 28, 1),
  (29, 29, 1),
  (30, 30, 1);
GO

-- >>> DML/041_librocategoria.sql
-- librocategoria
INSERT INTO dbo.librocategoria (libro_id, categoria_id) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10),
  (11, 11),
  (12, 12),
  (13, 13),
  (14, 14),
  (15, 15),
  (16, 1),
  (17, 2),
  (18, 3),
  (19, 4),
  (20, 5),
  (21, 6),
  (22, 7),
  (23, 8),
  (24, 9),
  (25, 10),
  (26, 11),
  (27, 12),
  (28, 13),
  (29, 14),
  (30, 15);
GO

-- >>> DML/042_movimientoinventario.sql
-- movimientoinventario
SET IDENTITY_INSERT dbo.movimientoinventario ON;
INSERT INTO dbo.movimientoinventario (id, sucursal_id, ejemplar_id, empleado_id, tipo_movimiento, fecha_movimiento, cantidad, observacion) VALUES
  (1, 8, 23, 13, N'TRASLADO', '2026-04-26 12:20:09', 1, N'Movimiento de tipo traslado registrado.'),
  (2, 13, 28, 26, N'TRASLADO', '2026-01-22 14:57:46', 1, N'Movimiento de tipo traslado registrado.'),
  (3, 6, NULL, 28, N'AJUSTE', '2026-02-10 09:18:23', 10, N'Movimiento de tipo ajuste registrado.'),
  (4, 14, 14, 2, N'AJUSTE', '2026-10-25 14:23:53', 1, N'Movimiento de tipo ajuste registrado.'),
  (5, 11, 11, 24, N'AJUSTE', '2026-01-28 08:29:40', 1, N'Movimiento de tipo ajuste registrado.'),
  (6, 12, NULL, 11, N'AJUSTE', '2026-03-05 12:34:07', 43, N'Movimiento de tipo ajuste registrado.'),
  (7, 4, 4, 7, N'ENTRADA', '2026-05-06 09:51:50', 1, N'Movimiento de tipo entrada registrado.'),
  (8, 14, 14, 2, N'AJUSTE', '2026-05-17 18:01:35', 1, N'Movimiento de tipo ajuste registrado.'),
  (9, 15, NULL, 17, N'SALIDA', '2026-02-10 17:21:53', 39, N'Movimiento de tipo salida registrado.'),
  (10, 3, 3, 30, N'TRASLADO', '2026-01-12 09:03:07', 1, N'Movimiento de tipo traslado registrado.'),
  (11, 8, 23, 29, N'AJUSTE', '2026-05-31 12:19:24', 1, N'Movimiento de tipo ajuste registrado.'),
  (12, 6, NULL, 12, N'ENTRADA', '2026-09-11 13:47:42', 16, N'Movimiento de tipo entrada registrado.'),
  (13, 5, 20, 21, N'SALIDA', '2026-03-14 09:03:42', 1, N'Movimiento de tipo salida registrado.'),
  (14, 12, 12, 10, N'SALIDA', '2026-10-24 08:54:40', 1, N'Movimiento de tipo salida registrado.'),
  (15, 11, NULL, 18, N'SALIDA', '2026-09-20 17:52:57', 14, N'Movimiento de tipo salida registrado.'),
  (16, 10, 10, 19, N'ENTRADA', '2026-11-10 13:15:56', 1, N'Movimiento de tipo entrada registrado.'),
  (17, 11, 26, 10, N'ENTRADA', '2026-04-06 11:31:40', 1, N'Movimiento de tipo entrada registrado.'),
  (18, 4, NULL, 21, N'SALIDA', '2026-10-21 15:36:20', 34, N'Movimiento de tipo salida registrado.'),
  (19, 14, 14, 17, N'ENTRADA', '2026-06-21 12:09:17', 1, N'Movimiento de tipo entrada registrado.'),
  (20, 10, 10, 9, N'TRASLADO', '2026-09-22 08:21:37', 1, N'Movimiento de tipo traslado registrado.'),
  (21, 10, NULL, 2, N'AJUSTE', '2026-07-17 13:23:33', 42, N'Movimiento de tipo ajuste registrado.'),
  (22, 15, 30, 14, N'AJUSTE', '2026-03-16 13:11:34', 1, N'Movimiento de tipo ajuste registrado.'),
  (23, 11, 11, 25, N'AJUSTE', '2026-08-15 09:33:51', 1, N'Movimiento de tipo ajuste registrado.'),
  (24, 12, NULL, 9, N'TRASLADO', '2026-01-19 18:22:25', 23, N'Movimiento de tipo traslado registrado.'),
  (25, 7, 7, 12, N'ENTRADA', '2026-09-15 13:01:26', 1, N'Movimiento de tipo entrada registrado.'),
  (26, 6, 6, 14, N'AJUSTE', '2026-07-21 18:39:34', 1, N'Movimiento de tipo ajuste registrado.'),
  (27, 11, NULL, 22, N'ENTRADA', '2026-04-22 11:04:29', 29, N'Movimiento de tipo entrada registrado.'),
  (28, 15, 30, 9, N'ENTRADA', '2026-04-28 08:31:17', 1, N'Movimiento de tipo entrada registrado.'),
  (29, 15, 15, 15, N'TRASLADO', '2026-07-21 11:43:56', 1, N'Movimiento de tipo traslado registrado.'),
  (30, 11, NULL, 3, N'TRASLADO', '2026-10-07 08:19:47', 46, N'Movimiento de tipo traslado registrado.');
SET IDENTITY_INSERT dbo.movimientoinventario OFF;
GO

-- >>> DML/043_multa.sql
-- multa
SET IDENTITY_INSERT dbo.multa ON;
INSERT INTO dbo.multa (id, fecha_generacion, monto, motivo, estado, detalle_prestamo_id) VALUES
  (1, '2026-08-11', 25.00, N'Retraso en la devolución', N'PAGADA', 1),
  (2, '2026-08-06', 20.00, N'Retraso en la devolución', N'PAGADA', 2),
  (3, '2026-08-31', 100.00, N'Páginas dobladas', N'PENDIENTE', 3),
  (4, '2026-03-31', 35.00, N'Retraso en la devolución', N'PAGADA', 4),
  (5, '2026-10-13', 20.00, N'Retraso en la devolución', N'PAGADA', 5),
  (6, '2026-10-11', 30.00, N'Retraso en la devolución', N'PENDIENTE', 6),
  (7, '2026-07-24', 35.00, N'Retraso en la devolución', N'PAGADA', 7),
  (8, '2026-08-08', 71.00, N'Portada dañada', N'PAGADA', 8),
  (9, '2026-03-29', 30.00, N'Retraso en la devolución', N'PENDIENTE', 9),
  (10, '2026-02-20', 98.00, N'Lomo despegado', N'PAGADA', 10),
  (11, '2026-03-22', 30.00, N'Retraso en la devolución', N'PAGADA', 11),
  (12, '2026-03-08', 45.00, N'Retraso en la devolución', N'PENDIENTE', 12),
  (13, '2026-03-11', 40.00, N'Retraso en la devolución', N'PAGADA', 13),
  (14, '2026-07-05', 161.00, N'Portada dañada', N'PAGADA', 14),
  (15, '2026-02-23', 207.00, N'Páginas dobladas', N'PENDIENTE', 15),
  (16, '2026-05-24', 15.00, N'Retraso en la devolución', N'PAGADA', 16),
  (17, '2026-09-01', 30.00, N'Retraso en la devolución', N'PAGADA', 17),
  (18, '2026-05-12', 25.00, N'Retraso en la devolución', N'PENDIENTE', 18),
  (19, '2026-08-04', 199.00, N'Páginas dobladas', N'PAGADA', 19),
  (20, '2026-07-26', 30.00, N'Retraso en la devolución', N'PAGADA', 20),
  (21, '2026-02-10', 20.00, N'Retraso en la devolución', N'PENDIENTE', 21),
  (22, '2026-05-24', 5.00, N'Retraso en la devolución', N'PAGADA', 22),
  (23, '2026-10-20', 63.00, N'Páginas dobladas', N'PAGADA', 23),
  (24, '2026-08-12', 200.00, N'Lomo despegado', N'PENDIENTE', 24),
  (25, '2026-02-08', 40.00, N'Retraso en la devolución', N'PAGADA', 25),
  (26, '2026-02-18', 20.00, N'Retraso en la devolución', N'PAGADA', 26),
  (27, '2026-08-27', 45.00, N'Retraso en la devolución', N'PENDIENTE', 27),
  (28, '2026-06-22', 45.00, N'Retraso en la devolución', N'PAGADA', 28),
  (29, '2026-03-14', 45.00, N'Retraso en la devolución', N'PAGADA', 29),
  (30, '2026-03-09', 10.00, N'Retraso en la devolución', N'PENDIENTE', 30);
SET IDENTITY_INSERT dbo.multa OFF;
GO

-- >>> DML/044_pagomulta.sql
-- pagomulta
SET IDENTITY_INSERT dbo.pagomulta ON;
INSERT INTO dbo.pagomulta (id, fecha_pago, monto, multa_id, forma_pago_id) VALUES
  (1, '2026-08-13 17:30:00', 25.00, 1, 11),
  (2, '2026-08-08 17:30:00', 20.00, 2, 14),
  (3, '2026-09-03 17:30:00', 40.00, 3, 11),
  (4, '2026-03-31 17:30:00', 35.00, 4, 13),
  (5, '2026-10-15 17:30:00', 20.00, 5, 13),
  (6, '2026-10-14 17:30:00', 18.00, 6, 7),
  (7, '2026-07-25 17:30:00', 35.00, 7, 8),
  (8, '2026-08-08 17:30:00', 71.00, 8, 4),
  (9, '2026-03-29 17:30:00', 15.00, 9, 2),
  (10, '2026-02-22 17:30:00', 98.00, 10, 10),
  (11, '2026-03-25 17:30:00', 30.00, 11, 13),
  (12, '2026-03-11 17:30:00', 22.50, 12, 6),
  (13, '2026-03-12 17:30:00', 40.00, 13, 7),
  (14, '2026-07-06 17:30:00', 161.00, 14, 6),
  (15, '2026-02-24 17:30:00', 82.80, 15, 9),
  (16, '2026-05-26 17:30:00', 15.00, 16, 4),
  (17, '2026-09-02 17:30:00', 30.00, 17, 1),
  (18, '2026-05-15 17:30:00', 15.00, 18, 10),
  (19, '2026-08-07 17:30:00', 199.00, 19, 6),
  (20, '2026-07-29 17:30:00', 30.00, 20, 1),
  (21, '2026-02-12 17:30:00', 10.00, 21, 7),
  (22, '2026-05-26 17:30:00', 5.00, 22, 15),
  (23, '2026-10-21 17:30:00', 63.00, 23, 2),
  (24, '2026-08-13 17:30:00', 80.00, 24, 8),
  (25, '2026-02-11 17:30:00', 40.00, 25, 4),
  (26, '2026-02-18 17:30:00', 20.00, 26, 2),
  (27, '2026-08-28 17:30:00', 18.00, 27, 7),
  (28, '2026-06-24 17:30:00', 45.00, 28, 1),
  (29, '2026-03-14 17:30:00', 45.00, 29, 6),
  (30, '2026-03-09 17:30:00', 6.00, 30, 14);
SET IDENTITY_INSERT dbo.pagomulta OFF;
GO

-- >>> DML/045_resenalibro.sql
-- resenalibro
SET IDENTITY_INSERT dbo.resenalibro ON;
INSERT INTO dbo.resenalibro (id, cliente_id, libro_id, calificacion, comentario, fecha_resena, estado) VALUES
  (1, 1, 12, 3, N'Buen libro, pero algo extenso.', '2026-09-13 16:07:58', 1),
  (2, 2, 16, 4, N'Contenido claro y bien explicado.', '2026-06-24 14:25:18', 1),
  (3, 3, 29, 1, N'Contenido claro y bien explicado.', '2026-04-17 08:11:32', 1),
  (4, 4, 25, 3, N'Una lectura entretenida.', '2026-04-07 18:21:52', 1),
  (5, 5, 20, 5, N'Muy recomendable.', '2026-04-22 18:23:57', 1),
  (6, 6, 1, 4, N'Lo recomiendo a mis amigos.', '2026-11-01 09:53:31', 1),
  (7, 7, 22, 4, N'Lo recomiendo a mis amigos.', '2026-10-20 12:36:36', 1),
  (8, 8, 7, 5, N'Buen libro, pero algo extenso.', '2026-04-03 15:38:29', 1),
  (9, 9, 13, 5, N'Una lectura entretenida.', '2026-07-13 15:21:26', 1),
  (10, 10, 6, 4, N'Muy recomendable.', '2026-08-10 13:48:18', 1),
  (11, 11, 10, 5, N'Podría ser más profundo.', '2026-08-30 15:03:34', 1),
  (12, 12, 15, 5, N'Lo recomiendo a mis amigos.', '2026-10-16 13:12:04', 1),
  (13, 13, 5, 4, N'Contenido claro y bien explicado.', '2026-06-14 12:56:33', 1),
  (14, 14, 19, 4, N'Me gustó mucho, lo volvería a leer.', '2026-10-09 15:16:33', 1),
  (15, 15, 4, 2, N'Buen libro, pero algo extenso.', '2026-06-23 08:52:12', 1),
  (16, 16, 18, 2, N'Muy recomendable.', '2026-03-09 17:05:28', 1),
  (17, 17, 11, 2, N'Contenido claro y bien explicado.', '2026-02-28 11:49:20', 1),
  (18, 18, 24, 4, N'Una lectura entretenida.', '2026-02-17 13:33:02', 1),
  (19, 19, 2, 4, N'Lo recomiendo a mis amigos.', '2026-09-28 16:51:21', 1),
  (20, 20, 27, 3, N'Una lectura entretenida.', '2026-10-02 17:05:01', 1),
  (21, 21, 21, 1, N'Buen libro, pero algo extenso.', '2026-05-03 17:13:47', 1),
  (22, 22, 8, 5, N'Podría ser más profundo.', '2026-04-13 15:05:30', 1),
  (23, 23, 30, 3, N'Una lectura entretenida.', '2026-04-05 12:13:20', 1),
  (24, 24, 14, 1, N'Me gustó mucho, lo volvería a leer.', '2026-07-17 17:13:31', 1),
  (25, 25, 17, 5, N'Lo recomiendo a mis amigos.', '2026-05-08 14:25:30', 1),
  (26, 26, 3, 3, N'Lo recomiendo a mis amigos.', '2026-03-11 12:29:12', 1),
  (27, 27, 9, 2, N'Podría ser más profundo.', '2026-03-19 10:48:17', 1),
  (28, 28, 23, 3, N'Contenido claro y bien explicado.', '2026-11-09 15:30:07', 1),
  (29, 29, 28, 2, N'Contenido claro y bien explicado.', '2026-09-18 12:16:55', 1),
  (30, 30, 26, 1, N'Excelente para principiantes.', '2026-05-26 08:36:49', 1);
SET IDENTITY_INSERT dbo.resenalibro OFF;
GO

-- >>> DML/046_reserva.sql
-- reserva
SET IDENTITY_INSERT dbo.reserva ON;
INSERT INTO dbo.reserva (id, cliente_id, libro_id, fecha_reserva, fecha_vencimiento, estado, fecha_atencion) VALUES
  (1, 10, 30, '2026-09-01 12:11:33', '2026-09-04 12:11:33', N'ATENDIDA', '2026-09-01 12:11:33'),
  (2, 11, 19, '2026-04-04 12:53:13', '2026-04-07 12:53:13', N'ATENDIDA', '2026-04-04 12:53:13'),
  (3, 21, 10, '2026-10-21 11:58:32', '2026-10-24 11:58:32', N'PENDIENTE', NULL),
  (4, 3, 26, '2026-07-21 15:18:55', '2026-07-24 15:18:55', N'VENCIDA', NULL),
  (5, 28, 21, '2026-07-18 16:24:25', '2026-07-21 16:24:25', N'ATENDIDA', '2026-07-19 16:24:25'),
  (6, 1, 26, '2026-03-11 10:23:44', '2026-03-14 10:23:44', N'ATENDIDA', '2026-03-13 10:23:44'),
  (7, 29, 3, '2026-07-03 18:09:25', '2026-07-06 18:09:25', N'VENCIDA', NULL),
  (8, 6, 13, '2026-03-13 18:43:50', '2026-03-16 18:43:50', N'CANCELADA', NULL),
  (9, 6, 16, '2026-07-24 16:15:22', '2026-07-27 16:15:22', N'PENDIENTE', NULL),
  (10, 18, 27, '2026-03-11 08:45:23', '2026-03-14 08:45:23', N'ATENDIDA', '2026-03-12 08:45:23'),
  (11, 11, 12, '2026-08-01 17:19:27', '2026-08-04 17:19:27', N'PENDIENTE', NULL),
  (12, 1, 28, '2026-03-20 18:32:14', '2026-03-23 18:32:14', N'PENDIENTE', NULL),
  (13, 11, 28, '2026-02-19 15:04:19', '2026-02-22 15:04:19', N'CANCELADA', NULL),
  (14, 23, 6, '2026-08-06 13:28:49', '2026-08-09 13:28:49', N'ATENDIDA', '2026-08-06 13:28:49'),
  (15, 2, 30, '2026-06-17 16:34:33', '2026-06-20 16:34:33', N'ATENDIDA', '2026-06-17 16:34:33'),
  (16, 20, 26, '2026-04-18 14:45:21', '2026-04-21 14:45:21', N'VENCIDA', NULL),
  (17, 8, 8, '2026-02-18 16:37:33', '2026-02-21 16:37:33', N'ATENDIDA', '2026-02-20 16:37:33'),
  (18, 28, 26, '2026-06-17 11:00:50', '2026-06-20 11:00:50', N'VENCIDA', NULL),
  (19, 5, 26, '2026-02-02 14:07:58', '2026-02-05 14:07:58', N'ATENDIDA', '2026-02-03 14:07:58'),
  (20, 10, 18, '2026-08-09 13:14:55', '2026-08-12 13:14:55', N'VENCIDA', NULL),
  (21, 10, 22, '2026-06-03 12:18:31', '2026-06-06 12:18:31', N'VENCIDA', NULL),
  (22, 29, 30, '2026-07-30 09:38:57', '2026-08-02 09:38:57', N'VENCIDA', NULL),
  (23, 20, 29, '2026-08-04 17:40:12', '2026-08-07 17:40:12', N'ATENDIDA', '2026-08-06 17:40:12'),
  (24, 23, 14, '2026-03-17 15:02:48', '2026-03-20 15:02:48', N'ATENDIDA', '2026-03-17 15:02:48'),
  (25, 21, 8, '2026-05-09 16:28:13', '2026-05-12 16:28:13', N'PENDIENTE', NULL),
  (26, 17, 1, '2026-09-18 13:09:55', '2026-09-21 13:09:55', N'CANCELADA', NULL),
  (27, 2, 11, '2026-07-12 15:33:48', '2026-07-15 15:33:48', N'CANCELADA', NULL),
  (28, 25, 24, '2026-03-31 18:51:41', '2026-04-03 18:51:41', N'ATENDIDA', '2026-04-02 18:51:41'),
  (29, 8, 19, '2026-10-01 14:07:09', '2026-10-04 14:07:09', N'VENCIDA', NULL),
  (30, 15, 2, '2026-05-06 13:30:20', '2026-05-09 13:30:20', N'ATENDIDA', '2026-05-08 13:30:20');
SET IDENTITY_INSERT dbo.reserva OFF;
GO

-- >>> DML/047_telefono.sql
-- telefono
SET IDENTITY_INSERT dbo.telefono ON;
INSERT INTO dbo.telefono (id, numero, persona_id, tipo) VALUES
  (1, N'+504 3127-9203', 1, N'L'),
  (2, N'+504 9149-9810', 2, N'P'),
  (3, N'+504 3557-8652', 3, N'L'),
  (4, N'+504 3531-5485', 4, N'P'),
  (5, N'+504 8262-9086', 5, N'P'),
  (6, N'+504 3531-1183', 6, N'P'),
  (7, N'+504 3222-1751', 7, N'P'),
  (8, N'+504 9808-2679', 8, N'P'),
  (9, N'+504 3515-2459', 9, N'L'),
  (10, N'+504 9796-3231', 10, N'P'),
  (11, N'+504 8204-6263', 11, N'P'),
  (12, N'+504 3505-6545', 12, N'P'),
  (13, N'+504 8557-6877', 13, N'L'),
  (14, N'+504 8121-6956', 14, N'P'),
  (15, N'+504 2893-2438', 15, N'F'),
  (16, N'+504 2720-6691', 16, N'F'),
  (17, N'+504 2998-4184', 17, N'F'),
  (18, N'+504 2424-3582', 18, N'F'),
  (19, N'+504 2810-1479', 19, N'F'),
  (20, N'+504 8138-2567', 20, N'L'),
  (21, N'+504 3559-6614', 21, N'P'),
  (22, N'+504 3498-1771', 22, N'L'),
  (23, N'+504 8709-7198', 23, N'P'),
  (24, N'+504 8411-5393', 24, N'L'),
  (25, N'+504 9563-9376', 25, N'L'),
  (26, N'+504 8541-9261', 26, N'P'),
  (27, N'+504 2881-2948', 27, N'F'),
  (28, N'+504 9565-8077', 28, N'L'),
  (29, N'+504 3396-3054', 29, N'P'),
  (30, N'+504 8421-7854', 30, N'P');
SET IDENTITY_INSERT dbo.telefono OFF;
GO

-- >>> DML/048_persona_app.sql
-- persona (clientes de la app)
SET IDENTITY_INSERT dbo.persona ON;
INSERT INTO dbo.persona (id, nombre, segundo_nombre, apellido, segundo_apellido, correo, genero, fecha_nacimiento) VALUES
  (31, N'Andrea', N'Sofía', N'Castro', N'Molina', N'andrea.castro31@example.com', N'F', '2004-05-14'),
  (32, N'Diego', NULL, N'Ramos', N'Suazo', N'diego.ramos32@example.com', N'M', '2003-09-02'),
  (33, N'Valeria', N'Nicole', N'Bonilla', NULL, N'valeria.bonilla33@example.com', N'F', '2005-01-23'),
  (34, N'Josué', N'David', N'Matute', N'Cano', N'josue.matute34@example.com', N'M', '1999-11-30'),
  (35, N'Camila', NULL, N'Turcios', N'Ávila', N'camila.turcios35@example.com', N'F', '2006-07-08'),
  (36, N'Ricardo', N'José', N'Espinoza', N'Galeas', N'ricardo.espinoza36@example.com', N'M', '1987-03-19'),
  (37, N'Nicole', N'María', N'Fiallos', N'Ponce', N'nicole.fiallos37@example.com', N'F', '2002-12-01'),
  (38, N'Elías', NULL, N'Barahona', N'Soto', N'elias.barahona38@example.com', N'M', '1958-04-27'),
  (39, N'Paola', N'Andrea', N'Reyes', N'Díaz', N'paola.reyes39@example.com', N'F', '1995-08-15'),
  (40, N'Samuel', N'Isaac', N'Zúniga', NULL, N'samuel.zuniga40@example.com', N'M', '2001-02-11');
SET IDENTITY_INSERT dbo.persona OFF;
GO

-- >>> DML/049_telefono_app.sql
-- telefono (clientes de la app)
SET IDENTITY_INSERT dbo.telefono ON;
INSERT INTO dbo.telefono (id, numero, persona_id, tipo) VALUES
  (31, N'+504 3427-9233', 31, N'P'),
  (32, N'+504 3328-7891', 32, N'P'),
  (33, N'+504 9869-8226', 33, N'P'),
  (34, N'+504 4102-2322', 34, N'P'),
  (35, N'+504 3394-2606', 35, N'P'),
  (36, N'+504 9111-9032', 36, N'P'),
  (37, N'+504 8315-7508', 37, N'P'),
  (38, N'+504 8456-6843', 38, N'P'),
  (39, N'+504 9863-9414', 39, N'P'),
  (40, N'+504 3840-6577', 40, N'P');
SET IDENTITY_INSERT dbo.telefono OFF;
GO

-- >>> DML/050_cliente_app.sql
-- cliente (clientes de la app)
SET IDENTITY_INSERT dbo.cliente ON;
INSERT INTO dbo.cliente (id, fecha_registro, persona_id, tipo_cliente_id) VALUES
  (31, '2026-08-03', 31, 1),
  (32, '2026-08-15', 32, 1),
  (33, '2026-09-01', 33, 6),
  (34, '2026-09-10', 34, 2),
  (35, '2026-09-22', 35, 6),
  (36, '2026-10-02', 36, 3),
  (37, '2026-10-14', 37, 1),
  (38, '2026-10-20', 38, 4),
  (39, '2026-11-02', 39, 11),
  (40, '2026-11-09', 40, 13);
SET IDENTITY_INSERT dbo.cliente OFF;
GO

-- >>> DML/051_credencial_app.sql
-- credencial (clientes de la app)
SET IDENTITY_INSERT dbo.credencial ON;
INSERT INTO dbo.credencial (id, fecha_registro, fecha_vencimiento, estado, cliente_id, empleado_id) VALUES
  (31, '2026-08-03', '2027-08-03', N'ACTIVA', 31, 14),
  (32, '2026-08-15', '2027-08-15', N'ACTIVA', 32, 16),
  (33, '2026-09-01', '2027-09-01', N'ACTIVA', 33, 16),
  (34, '2026-09-10', '2027-09-10', N'ACTIVA', 34, 7),
  (35, '2026-09-22', '2027-09-22', N'ACTIVA', 35, 19),
  (36, '2026-10-02', '2027-10-02', N'ACTIVA', 36, 16),
  (37, '2026-10-14', '2027-10-14', N'ACTIVA', 37, 14),
  (38, '2026-10-20', '2027-10-20', N'ACTIVA', 38, 16),
  (39, '2026-11-02', '2027-11-02', N'ACTIVA', 39, 16),
  (40, '2026-11-09', '2027-11-09', N'ACTIVA', 40, 7);
SET IDENTITY_INSERT dbo.credencial OFF;
GO

-- >>> DML/052_usuario_app.sql
-- usuario (clientes de la app)
SET IDENTITY_INSERT dbo.usuario ON;
INSERT INTO dbo.usuario (id, nombre_usuario, contrasena_hash, rol_id, fecha_creacion, estado, persona_id) VALUES
  (31, N'acastro', N'TEST$ee0f70c2d400d43377c81620f588f65796dc67d9', 16, '2026-08-03 10:00:00', 1, 31),
  (32, N'dramos', N'TEST$a37fc90d301d429b649c01dac38e71fed6c873b4', 16, '2026-08-15 10:00:00', 1, 32),
  (33, N'vbonilla', N'TEST$48edc1faabb1544b78a07e251d8af6f465c32c0c', 16, '2026-09-01 10:00:00', 1, 33),
  (34, N'jmatute', N'TEST$7ac683889959ef0e4a405c77227e1fd66f69bccd', 16, '2026-09-10 10:00:00', 1, 34),
  (35, N'cturcios', N'TEST$4c9e53726510e10a0853118ec98d47ca224829ea', 16, '2026-09-22 10:00:00', 1, 35),
  (36, N'respinoza', N'TEST$380a6969f7edc5a114a837dfd233a1368dbe58aa', 16, '2026-10-02 10:00:00', 1, 36),
  (37, N'nfiallos', N'TEST$ed3bbfd712ab673f49486190e60f963e8de2ee85', 16, '2026-10-14 10:00:00', 1, 37),
  (38, N'ebarahona', N'TEST$b0ed56a78ab1aa6e0ae9d41e58aca0f1bc15c633', 16, '2026-10-20 10:00:00', 1, 38),
  (39, N'preyes', N'TEST$5a32772450484cadfe63e49fd301e3f517afce25', 16, '2026-11-02 10:00:00', 1, 39),
  (40, N'szuniga', N'TEST$b7732acd32cec38498e0aa9889b7fdfc46a8c767', 16, '2026-11-09 10:00:00', 1, 40);
SET IDENTITY_INSERT dbo.usuario OFF;
GO

-- >>> DML/053_recursodigital.sql
-- recursodigital
SET IDENTITY_INSERT dbo.recursodigital ON;
INSERT INTO dbo.recursodigital (id, libro_id, tipo, ruta_archivo, total_paginas, duracion_segundos, generado_ia, voz_narracion, fecha_publicacion, estado) VALUES
  (1, 1, N'T', N'/biblioteca-digital/texto/libro_001.epub', 336, NULL, 0, NULL, '2026-09-11 15:00:00', 1),
  (2, 2, N'T', N'/biblioteca-digital/texto/libro_002.epub', 166, NULL, 0, NULL, '2026-07-22 13:00:00', 1),
  (3, 3, N'T', N'/biblioteca-digital/texto/libro_003.epub', 324, NULL, 0, NULL, '2026-08-08 09:00:00', 1),
  (4, 4, N'T', N'/biblioteca-digital/texto/libro_004.epub', 419, NULL, 0, NULL, '2026-06-09 11:00:00', 1),
  (5, 5, N'T', N'/biblioteca-digital/texto/libro_005.epub', 403, NULL, 0, NULL, '2026-09-26 17:00:00', 1),
  (6, 6, N'T', N'/biblioteca-digital/texto/libro_006.epub', 375, NULL, 0, NULL, '2026-10-04 14:00:00', 1),
  (7, 7, N'T', N'/biblioteca-digital/texto/libro_007.epub', 179, NULL, 0, NULL, '2026-07-22 13:00:00', 1),
  (8, 8, N'T', N'/biblioteca-digital/texto/libro_008.epub', 337, NULL, 0, NULL, '2026-10-03 16:00:00', 1),
  (9, 11, N'T', N'/biblioteca-digital/texto/libro_011.epub', 379, NULL, 0, NULL, '2026-10-09 16:00:00', 0),
  (10, 12, N'T', N'/biblioteca-digital/texto/libro_012.epub', 427, NULL, 0, NULL, '2026-09-20 17:00:00', 1),
  (11, 13, N'T', N'/biblioteca-digital/texto/libro_013.epub', 371, NULL, 0, NULL, '2026-06-09 13:00:00', 1),
  (12, 14, N'T', N'/biblioteca-digital/texto/libro_014.epub', 323, NULL, 0, NULL, '2026-08-21 16:00:00', 1),
  (13, 15, N'T', N'/biblioteca-digital/texto/libro_015.epub', 388, NULL, 0, NULL, '2026-06-26 16:00:00', 1),
  (14, 16, N'T', N'/biblioteca-digital/texto/libro_016.epub', 252, NULL, 0, NULL, '2026-10-10 13:00:00', 1),
  (15, 18, N'T', N'/biblioteca-digital/texto/libro_018.epub', 335, NULL, 0, NULL, '2026-09-24 11:00:00', 1),
  (16, 20, N'T', N'/biblioteca-digital/texto/libro_020.epub', 408, NULL, 0, NULL, '2026-09-17 16:00:00', 1),
  (17, 21, N'T', N'/biblioteca-digital/texto/libro_021.epub', 365, NULL, 0, NULL, '2026-06-17 13:00:00', 1),
  (18, 22, N'T', N'/biblioteca-digital/texto/libro_022.epub', 382, NULL, 0, NULL, '2026-10-06 14:00:00', 1),
  (19, 23, N'T', N'/biblioteca-digital/texto/libro_023.epub', 385, NULL, 0, NULL, '2026-06-25 12:00:00', 1),
  (20, 27, N'T', N'/biblioteca-digital/texto/libro_027.epub', 132, NULL, 0, NULL, '2026-09-14 11:00:00', 1),
  (21, 29, N'T', N'/biblioteca-digital/texto/libro_029.epub', 414, NULL, 0, NULL, '2026-09-24 09:00:00', 1),
  (22, 30, N'T', N'/biblioteca-digital/texto/libro_030.epub', 234, NULL, 0, NULL, '2026-06-24 09:00:00', 1),
  (23, 1, N'A', N'/biblioteca-digital/audio/libro_001.mp3', NULL, 21120, 1, N'Voz IA Mateo (español neutro)', '2026-10-18 10:00:00', 1),
  (24, 2, N'A', N'/biblioteca-digital/audio/libro_002.mp3', NULL, 13500, 1, N'Voz IA Camila (español latino)', '2026-07-21 12:00:00', 1),
  (25, 4, N'A', N'/biblioteca-digital/audio/libro_004.mp3', NULL, 42960, 1, N'Voz IA Lucía (español neutro)', '2026-06-12 17:00:00', 1),
  (26, 5, N'A', N'/biblioteca-digital/audio/libro_005.mp3', NULL, 17100, 0, N'Narración de estudio', '2026-08-08 14:00:00', 1),
  (27, 6, N'A', N'/biblioteca-digital/audio/libro_006.mp3', NULL, 34200, 1, N'Voz IA Lucía (español neutro)', '2026-06-02 14:00:00', 1),
  (28, 7, N'A', N'/biblioteca-digital/audio/libro_007.mp3', NULL, 19800, 1, N'Voz IA Camila (español latino)', '2026-10-04 11:00:00', 1),
  (29, 8, N'A', N'/biblioteca-digital/audio/libro_008.mp3', NULL, 24840, 1, N'Voz IA Camila (español latino)', '2026-07-28 16:00:00', 1),
  (30, 11, N'A', N'/biblioteca-digital/audio/libro_011.mp3', NULL, 16800, 1, N'Voz IA Camila (español latino)', '2026-07-04 17:00:00', 1),
  (31, 13, N'A', N'/biblioteca-digital/audio/libro_013.mp3', NULL, 38580, 1, N'Voz IA Mateo (español neutro)', '2026-06-22 15:00:00', 1),
  (32, 14, N'A', N'/biblioteca-digital/audio/libro_014.mp3', NULL, 38700, 1, N'Voz IA Camila (español latino)', '2026-07-11 11:00:00', 1),
  (33, 16, N'A', N'/biblioteca-digital/audio/libro_016.mp3', NULL, 40560, 1, N'Voz IA Camila (español latino)', '2026-08-18 17:00:00', 1),
  (34, 20, N'A', N'/biblioteca-digital/audio/libro_020.mp3', NULL, 41100, 0, N'Narración de estudio', '2026-09-14 15:00:00', 1),
  (35, 21, N'A', N'/biblioteca-digital/audio/libro_021.mp3', NULL, 27300, 1, N'Voz IA Lucía (español neutro)', '2026-10-12 12:00:00', 1),
  (36, 29, N'A', N'/biblioteca-digital/audio/libro_029.mp3', NULL, 42240, 1, N'Voz IA Mateo (español neutro)', '2026-06-04 10:00:00', 1),
  (37, 30, N'A', N'/biblioteca-digital/audio/libro_030.mp3', NULL, 39060, 1, N'Voz IA Mateo (español neutro)', '2026-06-19 09:00:00', 1);
SET IDENTITY_INSERT dbo.recursodigital OFF;
GO

-- >>> DML/054_capitulorecurso.sql
-- capitulorecurso
SET IDENTITY_INSERT dbo.capitulorecurso ON;
INSERT INTO dbo.capitulorecurso (id, recurso_digital_id, numero, titulo, posicion_inicio) VALUES
  (1, 23, 1, N'Capítulo 1: Introducción', 0),
  (2, 23, 2, N'Capítulo 2: Primera parte', 7040),
  (3, 23, 3, N'Capítulo 3: Desenlace', 14080),
  (4, 24, 1, N'Capítulo 1: Introducción', 0),
  (5, 24, 2, N'Capítulo 2: Primera parte', 4500),
  (6, 24, 3, N'Capítulo 3: Desenlace', 9000),
  (7, 25, 1, N'Capítulo 1: Introducción', 0),
  (8, 25, 2, N'Capítulo 2: Primera parte', 14320),
  (9, 25, 3, N'Capítulo 3: Desenlace', 28640),
  (10, 26, 1, N'Capítulo 1: Introducción', 0),
  (11, 26, 2, N'Capítulo 2: Primera parte', 5700),
  (12, 26, 3, N'Capítulo 3: Desenlace', 11400),
  (13, 27, 1, N'Capítulo 1: Introducción', 0),
  (14, 27, 2, N'Capítulo 2: Primera parte', 11400),
  (15, 27, 3, N'Capítulo 3: Desenlace', 22800),
  (16, 28, 1, N'Capítulo 1: Introducción', 0),
  (17, 28, 2, N'Capítulo 2: Primera parte', 6600),
  (18, 28, 3, N'Capítulo 3: Desenlace', 13200),
  (19, 29, 1, N'Capítulo 1: Introducción', 0),
  (20, 29, 2, N'Capítulo 2: Primera parte', 8280),
  (21, 29, 3, N'Capítulo 3: Desenlace', 16560),
  (22, 30, 1, N'Capítulo 1: Introducción', 0),
  (23, 30, 2, N'Capítulo 2: Primera parte', 5600),
  (24, 30, 3, N'Capítulo 3: Desenlace', 11200),
  (25, 31, 1, N'Capítulo 1: Introducción', 0),
  (26, 31, 2, N'Capítulo 2: Primera parte', 12860),
  (27, 31, 3, N'Capítulo 3: Desenlace', 25720),
  (28, 32, 1, N'Capítulo 1: Introducción', 0),
  (29, 32, 2, N'Capítulo 2: Primera parte', 12900),
  (30, 32, 3, N'Capítulo 3: Desenlace', 25800),
  (31, 33, 1, N'Capítulo 1: Introducción', 0),
  (32, 33, 2, N'Capítulo 2: Primera parte', 13520),
  (33, 33, 3, N'Capítulo 3: Desenlace', 27040),
  (34, 34, 1, N'Capítulo 1: Introducción', 0),
  (35, 34, 2, N'Capítulo 2: Primera parte', 13700),
  (36, 34, 3, N'Capítulo 3: Desenlace', 27400),
  (37, 35, 1, N'Capítulo 1: Introducción', 0),
  (38, 35, 2, N'Capítulo 2: Primera parte', 9100),
  (39, 35, 3, N'Capítulo 3: Desenlace', 18200),
  (40, 36, 1, N'Capítulo 1: Introducción', 0),
  (41, 36, 2, N'Capítulo 2: Primera parte', 14080),
  (42, 36, 3, N'Capítulo 3: Desenlace', 28160),
  (43, 37, 1, N'Capítulo 1: Introducción', 0),
  (44, 37, 2, N'Capítulo 2: Primera parte', 13020),
  (45, 37, 3, N'Capítulo 3: Desenlace', 26040);
SET IDENTITY_INSERT dbo.capitulorecurso OFF;
GO

-- >>> DML/055_progresolectura.sql
-- progresolectura
SET IDENTITY_INSERT dbo.progresolectura ON;
INSERT INTO dbo.progresolectura (id, cliente_id, recurso_digital_id, posicion_actual, porcentaje, fecha_inicio, fecha_ultima_lectura) VALUES
  (1, 23, 24, 675, 5.00, '2026-07-04 16:00:00', '2026-07-19 21:35:00'),
  (2, 20, 30, 10080, 60.00, '2026-07-16 15:00:00', '2026-08-15 22:57:00'),
  (3, 37, 12, 80, 25.00, '2026-09-14 16:00:00', '2026-09-20 23:24:00'),
  (4, 40, 23, 18585, 88.00, '2026-09-15 11:00:00', '2026-10-06 12:11:00'),
  (5, 36, 27, 1710, 5.00, '2026-07-26 18:00:00', '2026-08-24 20:57:00'),
  (6, 3, 36, 2112, 5.00, '2026-08-27 20:00:00', '2026-09-16 23:13:00'),
  (7, 31, 2, 41, 25.00, '2026-09-21 16:00:00', '2026-09-28 00:49:00'),
  (8, 9, 12, 80, 25.00, '2026-08-19 12:00:00', '2026-09-01 21:05:00'),
  (9, 27, 6, 273, 73.00, '2026-08-09 10:00:00', '2026-08-20 12:58:00'),
  (10, 17, 31, 33950, 88.00, '2026-10-08 14:00:00', '2026-10-17 21:58:00'),
  (11, 12, 22, 234, 100.00, '2026-08-31 15:00:00', '2026-09-03 23:59:00'),
  (12, 34, 19, 46, 12.00, '2026-07-28 11:00:00', '2026-07-28 12:35:00'),
  (13, 30, 23, 15417, 73.00, '2026-09-08 20:00:00', '2026-10-04 23:06:00'),
  (14, 2, 24, 3375, 25.00, '2026-08-15 16:00:00', '2026-09-06 01:46:00'),
  (15, 35, 15, 40, 12.00, '2026-09-18 19:00:00', '2026-09-27 04:29:00'),
  (16, 37, 15, 335, 100.00, '2026-08-07 17:00:00', '2026-08-16 02:29:00'),
  (17, 9, 7, 84, 47.00, '2026-07-13 14:00:00', '2026-07-18 15:48:00'),
  (18, 4, 24, 3375, 25.00, '2026-09-21 18:00:00', '2026-09-25 02:38:00'),
  (19, 21, 19, 385, 100.00, '2026-07-09 12:00:00', '2026-08-07 17:22:00'),
  (20, 11, 18, 179, 47.00, '2026-07-09 08:00:00', '2026-07-22 12:23:00'),
  (21, 27, 1, 16, 5.00, '2026-07-13 11:00:00', '2026-07-13 16:17:00'),
  (22, 8, 7, 179, 100.00, '2026-09-12 13:00:00', '2026-09-22 20:46:00'),
  (23, 39, 3, 236, 73.00, '2026-08-10 17:00:00', '2026-08-17 00:53:00'),
  (24, 28, 8, 202, 60.00, '2026-09-03 18:00:00', '2026-10-02 22:17:00'),
  (25, 25, 20, 79, 60.00, '2026-07-08 19:00:00', '2026-07-31 02:27:00'),
  (26, 2, 20, 79, 60.00, '2026-08-07 19:00:00', '2026-09-06 21:05:00'),
  (27, 20, 28, 11880, 60.00, '2026-09-13 08:00:00', '2026-09-30 13:50:00'),
  (28, 13, 37, 1953, 5.00, '2026-10-01 09:00:00', '2026-10-06 11:05:00'),
  (29, 8, 3, 81, 25.00, '2026-09-05 13:00:00', '2026-09-24 18:09:00'),
  (30, 2, 29, 24840, 100.00, '2026-07-17 13:00:00', '2026-07-30 19:33:00'),
  (31, 25, 17, 266, 73.00, '2026-09-23 11:00:00', '2026-10-17 13:08:00'),
  (32, 12, 36, 2112, 5.00, '2026-09-23 19:00:00', '2026-10-23 04:14:00'),
  (33, 17, 11, 140, 38.00, '2026-07-03 08:00:00', '2026-07-11 17:14:00'),
  (34, 31, 28, 9306, 47.00, '2026-08-10 10:00:00', '2026-09-09 11:31:00'),
  (35, 12, 37, 1953, 5.00, '2026-09-22 16:00:00', '2026-10-18 20:31:00');
SET IDENTITY_INSERT dbo.progresolectura OFF;
GO

-- >>> DML/056_notalectura.sql
-- notalectura
SET IDENTITY_INSERT dbo.notalectura ON;
INSERT INTO dbo.notalectura (id, cliente_id, recurso_digital_id, tipo, posicion, texto_seleccionado, nota, color, fecha_creacion) VALUES
  (1, 37, 12, N'N', 70, N'La lectura es el camino más corto hacia otros mundos.', N'Repasar para el examen.', NULL, '2026-09-19 18:09:00'),
  (2, 31, 2, N'M', 40, NULL, NULL, NULL, '2026-09-22 20:25:00'),
  (3, 9, 12, N'S', 68, N'La disciplina vence al talento cuando el talento no trabaja.', NULL, N'#A8E6A1', '2026-08-20 16:52:00'),
  (4, 27, 6, N'N', 263, N'Todo cambio empieza con un pequeño paso.', N'Comparar con el capítulo anterior.', NULL, '2026-08-11 14:00:00'),
  (5, 12, 22, N'M', 219, NULL, NULL, NULL, '2026-09-05 17:44:00'),
  (6, 34, 19, N'S', 41, N'La disciplina vence al talento cuando el talento no trabaja.', NULL, N'#F4A6C1', '2026-07-29 15:13:00'),
  (7, 35, 15, N'S', 29, N'Cada página era una puerta abierta.', NULL, N'#F4A6C1', '2026-09-18 20:33:00'),
  (8, 37, 15, N'S', 326, N'El río guardaba los secretos de la familia.', NULL, N'#A8E6A1', '2026-08-08 17:56:00'),
  (9, 9, 7, N'S', 78, N'La disciplina vence al talento cuando el talento no trabaja.', NULL, N'#A8E6A1', '2026-07-17 14:27:00'),
  (10, 21, 19, N'M', 373, NULL, NULL, NULL, '2026-07-13 16:29:00'),
  (11, 11, 18, N'S', 176, N'La lectura es el camino más corto hacia otros mundos.', NULL, N'#7EC8E3', '2026-07-14 11:24:00'),
  (12, 27, 1, N'N', 8, N'El río guardaba los secretos de la familia.', N'Repasar para el examen.', NULL, '2026-07-18 12:42:00'),
  (13, 8, 7, N'S', 170, N'El río guardaba los secretos de la familia.', NULL, N'#A8E6A1', '2026-09-14 14:13:00'),
  (14, 39, 3, N'M', 230, NULL, NULL, NULL, '2026-08-15 17:09:00'),
  (15, 28, 8, N'M', 189, NULL, NULL, NULL, '2026-09-05 22:40:00'),
  (16, 25, 20, N'S', 79, N'Todo cambio empieza con un pequeño paso.', NULL, N'#A8E6A1', '2026-07-12 20:19:00'),
  (17, 2, 20, N'S', 79, N'La lectura es el camino más corto hacia otros mundos.', NULL, N'#F5C542', '2026-08-09 19:37:00'),
  (18, 8, 3, N'N', 72, N'Todo cambio empieza con un pequeño paso.', N'Cita para el ensayo.', NULL, '2026-09-06 15:12:00'),
  (19, 25, 17, N'S', 263, N'El río guardaba los secretos de la familia.', NULL, N'#F4A6C1', '2026-09-23 11:42:00'),
  (20, 17, 11, N'M', 132, NULL, NULL, NULL, '2026-07-07 10:39:00'),
  (21, 37, 12, N'S', 69, N'Comprender el pasado ayuda a decidir el futuro.', NULL, N'#F4A6C1', '2026-09-14 20:49:00'),
  (22, 31, 2, N'S', 30, N'La disciplina vence al talento cuando el talento no trabaja.', NULL, N'#F4A6C1', '2026-09-25 19:01:00'),
  (23, 9, 12, N'S', 78, N'La lectura es el camino más corto hacia otros mundos.', NULL, N'#F4A6C1', '2026-08-21 14:20:00'),
  (24, 27, 6, N'S', 268, N'El río guardaba los secretos de la familia.', NULL, N'#F4A6C1', '2026-08-13 14:52:00'),
  (25, 12, 22, N'N', 224, N'La disciplina vence al talento cuando el talento no trabaja.', N'Buscar más información sobre esto.', NULL, '2026-09-03 17:45:00'),
  (26, 34, 19, N'S', 40, N'Comprender el pasado ayuda a decidir el futuro.', NULL, N'#7EC8E3', '2026-08-02 14:03:00'),
  (27, 35, 15, N'N', 27, N'Cada página era una puerta abierta.', N'Buscar más información sobre esto.', NULL, '2026-09-19 20:24:00'),
  (28, 37, 15, N'M', 331, NULL, NULL, NULL, '2026-08-10 19:22:00'),
  (29, 9, 7, N'N', 81, N'El río guardaba los secretos de la familia.', N'Comparar con el capítulo anterior.', NULL, '2026-07-16 16:19:00'),
  (30, 21, 19, N'S', 377, N'Todo cambio empieza con un pequeño paso.', NULL, N'#A8E6A1', '2026-07-10 16:52:00'),
  (31, 11, 18, N'S', 171, N'El río guardaba los secretos de la familia.', NULL, N'#F4A6C1', '2026-07-14 11:30:00'),
  (32, 27, 1, N'M', 16, NULL, NULL, NULL, '2026-07-17 13:53:00');
SET IDENTITY_INSERT dbo.notalectura OFF;
GO

-- >>> DML/057_listadeseo.sql
-- listadeseo
SET IDENTITY_INSERT dbo.listadeseo ON;
INSERT INTO dbo.listadeseo (id, cliente_id, libro_id, fecha_agregado, notificar_descuento) VALUES
  (1, 27, 11, '2026-06-25 18:49:00', 0),
  (2, 35, 17, '2026-07-24 14:22:00', 1),
  (3, 4, 30, '2026-09-11 19:11:00', 1),
  (4, 18, 18, '2026-08-04 10:21:00', 0),
  (5, 31, 28, '2026-10-02 13:00:00', 1),
  (6, 15, 21, '2026-07-01 18:54:00', 1),
  (7, 21, 1, '2026-07-24 20:29:00', 1),
  (8, 40, 21, '2026-09-03 09:35:00', 1),
  (9, 35, 25, '2026-06-03 09:09:00', 1),
  (10, 15, 15, '2026-07-23 17:43:00', 1),
  (11, 20, 3, '2026-10-24 14:45:00', 1),
  (12, 7, 1, '2026-08-09 14:02:00', 1),
  (13, 36, 24, '2026-10-10 11:58:00', 0),
  (14, 22, 11, '2026-08-28 13:38:00', 0),
  (15, 17, 16, '2026-08-23 21:16:00', 1),
  (16, 32, 5, '2026-06-06 15:51:00', 1),
  (17, 17, 27, '2026-09-28 11:23:00', 1),
  (18, 33, 27, '2026-09-11 12:13:00', 1),
  (19, 27, 28, '2026-06-17 19:46:00', 1),
  (20, 31, 20, '2026-06-24 21:32:00', 1),
  (21, 32, 11, '2026-11-17 13:23:00', 1),
  (22, 5, 18, '2026-07-15 20:16:00', 0),
  (23, 7, 30, '2026-11-03 11:01:00', 0),
  (24, 16, 7, '2026-09-18 16:54:00', 1),
  (25, 33, 7, '2026-08-09 20:55:00', 0),
  (26, 9, 18, '2026-08-23 13:41:00', 0),
  (27, 35, 20, '2026-10-17 11:09:00', 1),
  (28, 10, 5, '2026-11-16 17:03:00', 1),
  (29, 18, 26, '2026-08-16 21:11:00', 1),
  (30, 23, 5, '2026-09-26 10:11:00', 1);
SET IDENTITY_INSERT dbo.listadeseo OFF;
GO

-- >>> DML/058_notificacion.sql
-- notificacion
SET IDENTITY_INSERT dbo.notificacion ON;
INSERT INTO dbo.notificacion (id, cliente_id, tipo, titulo, mensaje, referencia_id, fecha_envio, leida, fecha_lectura) VALUES
  (1, 26, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #1 antes del 2026-08-06 o renovarlo desde la app.', 1, '2026-08-05 08:00:00', 0, NULL),
  (2, 10, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #3 antes del 2026-08-31 o renovarlo desde la app.', 3, '2026-08-30 08:00:00', 1, '2026-08-30 13:00:00'),
  (3, 14, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #5 antes del 2026-10-09 o renovarlo desde la app.', 5, '2026-10-08 08:00:00', 1, '2026-10-09 05:00:00'),
  (4, 28, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #7 antes del 2026-07-17 o renovarlo desde la app.', 7, '2026-07-16 08:00:00', 1, '2026-07-17 00:00:00'),
  (5, 17, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #9 antes del 2026-03-23 o renovarlo desde la app.', 9, '2026-03-22 08:00:00', 1, '2026-03-22 09:00:00'),
  (6, 5, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #11 antes del 2026-03-16 o renovarlo desde la app.', 11, '2026-03-15 08:00:00', 1, '2026-03-15 16:00:00'),
  (7, 14, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #13 antes del 2026-03-03 o renovarlo desde la app.', 13, '2026-03-02 08:00:00', 1, '2026-03-02 20:00:00'),
  (8, 25, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #15 antes del 2026-02-26 o renovarlo desde la app.', 15, '2026-02-25 08:00:00', 1, '2026-02-25 11:00:00'),
  (9, 17, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #17 antes del 2026-08-26 o renovarlo desde la app.', 17, '2026-08-25 08:00:00', 1, '2026-08-26 06:00:00'),
  (10, 28, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #19 antes del 2026-08-06 o renovarlo desde la app.', 19, '2026-08-05 08:00:00', 1, '2026-08-05 22:00:00'),
  (11, 18, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #21 antes del 2026-02-06 o renovarlo desde la app.', 21, '2026-02-05 08:00:00', 0, NULL),
  (12, 20, N'V', N'Tu préstamo vence mañana', N'Recuerda devolver los libros del préstamo #23 antes del 2026-10-22 o renovarlo desde la app.', 23, '2026-10-21 08:00:00', 1, '2026-10-21 13:00:00'),
  (13, 10, N'R', N'Tu reserva está disponible', N'El libro "Introducción a la ética" ya está disponible. Tienes 3 días para retirarlo.', 1, '2026-09-01 12:11:33', 1, '2026-09-02 05:11:33'),
  (14, 11, N'R', N'Tu reserva está disponible', N'El libro "Rutas comerciales de Centroamérica" ya está disponible. Tienes 3 días para retirarlo.', 2, '2026-04-04 12:53:13', 0, NULL),
  (15, 28, N'R', N'Tu reserva está disponible', N'El libro "El dragón de papel" ya está disponible. Tienes 3 días para retirarlo.', 5, '2026-07-19 16:24:25', 1, '2026-07-19 17:24:25'),
  (16, 1, N'R', N'Tu reserva está disponible', N'El libro "Primeros auxilios básicos" ya está disponible. Tienes 3 días para retirarlo.', 6, '2026-03-13 10:23:44', 0, NULL),
  (17, 23, N'R', N'Tu reserva está disponible', N'El libro "El pequeño explorador" ya está disponible. Tienes 3 días para retirarlo.', 14, '2026-08-06 13:28:49', 0, NULL),
  (18, 8, N'R', N'Tu reserva está disponible', N'El libro "Versos del amanecer" ya está disponible. Tienes 3 días para retirarlo.', 17, '2026-02-20 16:37:33', 1, '2026-02-21 11:37:33'),
  (19, 20, N'R', N'Tu reserva está disponible', N'El libro "Equilibrio emocional" ya está disponible. Tienes 3 días para retirarlo.', 23, '2026-08-06 17:40:12', 1, '2026-08-07 16:40:12'),
  (20, 15, N'R', N'Tu reserva está disponible', N'El libro "Fundamentos de física moderna" ya está disponible. Tienes 3 días para retirarlo.', 30, '2026-05-08 13:30:20', 1, '2026-05-09 00:30:20'),
  (21, 10, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 100.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 3, '2026-08-31 09:00:00', 0, NULL),
  (22, 13, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 30.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 6, '2026-10-11 09:00:00', 0, NULL),
  (23, 17, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 30.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 9, '2026-03-29 09:00:00', 1, '2026-03-29 16:00:00'),
  (24, 29, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 45.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 12, '2026-03-08 09:00:00', 0, NULL),
  (25, 25, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 207.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 15, '2026-02-23 09:00:00', 1, '2026-02-24 07:00:00'),
  (26, 11, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 25.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 18, '2026-05-12 09:00:00', 1, '2026-05-12 16:00:00'),
  (27, 3, N'M', N'Tienes una multa pendiente', N'Se generó una multa de L 200.00 en tu cuenta. Puedes pagarla en caja o desde la app.', 24, '2026-08-12 09:00:00', 0, NULL),
  (28, 35, N'D', N'Un libro de tu lista bajó de precio', N'"Biología celular ilustrada" tiene 15% de descuento por la promoción de fin de año.', 17, '2026-11-20 10:00:00', 0, NULL),
  (29, 4, N'D', N'Un libro de tu lista bajó de precio', N'"Introducción a la ética" tiene 15% de descuento por la promoción de fin de año.', 30, '2026-11-20 10:00:00', 0, NULL),
  (30, 31, N'D', N'Un libro de tu lista bajó de precio', N'"Contabilidad básica para pequeños negocios" tiene 15% de descuento por la promoción de fin de año.', 28, '2026-11-20 10:00:00', 1, '2026-11-21 02:00:00'),
  (31, 15, N'D', N'Un libro de tu lista bajó de precio', N'"El dragón de papel" tiene 15% de descuento por la promoción de fin de año.', 21, '2026-11-20 10:00:00', 0, NULL),
  (32, 21, N'D', N'Un libro de tu lista bajó de precio', N'"La sombra del río" tiene 15% de descuento por la promoción de fin de año.', 1, '2026-11-20 10:00:00', 1, '2026-11-20 16:00:00'),
  (33, 31, N'G', N'¡Bienvenido a Mucho Texto!', N'Ya puedes leer y escuchar libros desde la biblioteca digital de la app.', NULL, '2026-08-03 10:05:00', 1, '2026-08-04 14:05:00'),
  (34, 32, N'G', N'¡Bienvenido a Mucho Texto!', N'Ya puedes leer y escuchar libros desde la biblioteca digital de la app.', NULL, '2026-08-15 10:05:00', 1, '2026-08-16 10:05:00'),
  (35, 33, N'G', N'¡Bienvenido a Mucho Texto!', N'Ya puedes leer y escuchar libros desde la biblioteca digital de la app.', NULL, '2026-09-01 10:05:00', 1, '2026-09-02 01:05:00');
SET IDENTITY_INSERT dbo.notificacion OFF;
GO

