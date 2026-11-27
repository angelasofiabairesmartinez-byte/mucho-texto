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
