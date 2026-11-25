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
