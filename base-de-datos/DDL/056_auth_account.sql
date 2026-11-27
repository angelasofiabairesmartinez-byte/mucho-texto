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
