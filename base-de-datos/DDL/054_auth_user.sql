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
