-- credencial (clientes de la app)
SET IDENTITY_INSERT dbo.credencial ON;
INSERT INTO dbo.credencial (id, fecha_registro, fecha_vencimiento, estado, cliente_id, empleado_id) VALUES
  (31, '2026-08-03', '2027-08-03', N'ACTIVA', 31, 14),
  (32, '2026-08-15', '2027-08-15', N'ACTIVA', 32, 16),
  (33, '2026-09-01', '2027-09-01', N'ACTIVA', 33, 16),
  (34, '2026-09-10', '2027-09-10', N'ACTIVA', 34, 7),
  (35, '2026-09-22', '2027-09-22', N'ACTIVA', 35, 19),
  (36, '2026-10-02', '2027-10-02', N'ACTIVA', 36, 16),
  (37, '2026-10-14', '2027-10-14', N'ACTIVA', 37, 14),
  (38, '2026-10-20', '2027-10-20', N'ACTIVA', 38, 16),
  (39, '2026-11-02', '2027-11-02', N'ACTIVA', 39, 16),
  (40, '2026-11-09', '2027-11-09', N'ACTIVA', 40, 7);
SET IDENTITY_INSERT dbo.credencial OFF;
