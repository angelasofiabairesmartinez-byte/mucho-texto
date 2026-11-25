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
