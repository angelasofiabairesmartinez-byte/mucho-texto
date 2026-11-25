-- estadoejemplar
SET IDENTITY_INSERT dbo.estadoejemplar ON;
INSERT INTO dbo.estadoejemplar (id, nombre, descripcion) VALUES
  (1, N'Disponible', N'Listo para préstamo o venta.'),
  (2, N'Prestado', N'Actualmente en poder de un cliente.'),
  (3, N'Reservado', N'Apartado para un cliente.'),
  (4, N'En reparación', N'En proceso de encuadernación o reparación.'),
  (5, N'Dañado', N'Con daños que impiden su uso.'),
  (6, N'Perdido', N'No localizado tras inventario.'),
  (7, N'En catalogación', N'Pendiente de registro y clasificación.'),
  (8, N'En tránsito', N'En traslado entre sucursales.'),
  (9, N'Descartado', N'Dado de baja definitivamente.'),
  (10, N'En exhibición', N'Expuesto en sala o vitrina.'),
  (11, N'En restauración', N'En proceso de restauración.'),
  (12, N'En cuarentena', N'Aislado por revisión de calidad.'),
  (13, N'Donado', N'Entregado como donación.'),
  (14, N'Retirado de circulación', N'Fuera de uso por decisión administrativa.'),
  (15, N'Solo consulta en sala', N'No sale de la sucursal.');
SET IDENTITY_INSERT dbo.estadoejemplar OFF;
