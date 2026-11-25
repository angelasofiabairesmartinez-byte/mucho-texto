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
