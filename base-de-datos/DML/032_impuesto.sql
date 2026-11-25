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
