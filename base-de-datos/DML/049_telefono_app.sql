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
