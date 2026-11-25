-- rol
SET IDENTITY_INSERT dbo.rol ON;
INSERT INTO dbo.rol (id, nombre, descripcion) VALUES
  (1, N'Administrador', N'Acceso total al sistema y a su configuración.'),
  (2, N'Gerente', N'Acceso a reportes y aprobaciones de su sucursal.'),
  (3, N'Bibliotecario', N'Gestiona préstamos, devoluciones y multas.'),
  (4, N'Cajero', N'Registra facturas y cobros.'),
  (5, N'Vendedor', N'Consulta catálogo y registra ventas.'),
  (6, N'Inventario', N'Administra existencias y movimientos.'),
  (7, N'Compras', N'Registra compras y proveedores.'),
  (8, N'Contabilidad', N'Consulta facturación, pagos e impuestos.'),
  (9, N'Auditor', N'Acceso de solo lectura a la bitácora de auditoría.'),
  (10, N'Soporte técnico', N'Acceso técnico para mantenimiento del sistema.'),
  (11, N'Atención al cliente', N'Gestiona clientes, reservas y reseñas.'),
  (12, N'Consulta', N'Acceso de solo lectura al catálogo.'),
  (13, N'Supervisor', N'Supervisa la operación diaria del personal.'),
  (14, N'Invitado', N'Acceso limitado y temporal.'),
  (15, N'Operador de préstamos', N'Registra préstamos y devoluciones únicamente.');
SET IDENTITY_INSERT dbo.rol OFF;

SET IDENTITY_INSERT dbo.rol ON;
INSERT INTO dbo.rol (id, nombre, descripcion) VALUES
  (16, N'Cliente', N'Acceso a la app: catálogo, préstamos, reservas, compras y biblioteca digital.');
SET IDENTITY_INSERT dbo.rol OFF;
