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
