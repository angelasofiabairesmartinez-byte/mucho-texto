/* ============================================================
   Prueba: tablas de inicio de sesión (Better Auth)
   ============================================================ */
SET NOCOUNT ON;

IF OBJECT_ID(N'dbo.auth_user', N'U') IS NULL
   OR OBJECT_ID(N'dbo.auth_session', N'U') IS NULL
   OR OBJECT_ID(N'dbo.auth_account', N'U') IS NULL
   OR OBJECT_ID(N'dbo.auth_verification', N'U') IS NULL
    THROW 50920, N'PRUEBA FALLIDA: faltan tablas de Better Auth.', 1;

BEGIN TRANSACTION;
INSERT INTO dbo.auth_user (id, name, email, usuarioId) VALUES (N'prueba-1', N'Prueba', N'prueba@muchotexto.hn', 1);
INSERT INTO dbo.auth_session (id, expiresAt, token, userId) VALUES (N'sesion-1', DATEADD(DAY, 7, GETDATE()), N'token-prueba', N'prueba-1');
INSERT INTO dbo.auth_account (id, accountId, providerId, userId) VALUES (N'cuenta-1', N'prueba-1', N'credential', N'prueba-1');
DELETE FROM dbo.auth_user WHERE id = N'prueba-1';
IF EXISTS (SELECT 1 FROM dbo.auth_session s WHERE s.userId = N'prueba-1')
   OR EXISTS (SELECT 1 FROM dbo.auth_account a WHERE a.userId = N'prueba-1')
BEGIN
    ROLLBACK TRANSACTION;
    THROW 50921, N'PRUEBA FALLIDA: al borrar la cuenta no se borran sus sesiones.', 1;
END;
ROLLBACK TRANSACTION;

PRINT N'OK better auth';
