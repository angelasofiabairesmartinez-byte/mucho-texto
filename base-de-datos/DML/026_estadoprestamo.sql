-- estadoprestamo
SET IDENTITY_INSERT dbo.estadoprestamo ON;
INSERT INTO dbo.estadoprestamo (id, nombre, descripcion) VALUES
  (1, N'Activo', N'Préstamo vigente.'),
  (2, N'Devuelto', N'Todos los ejemplares fueron devueltos.'),
  (3, N'Vencido', N'Pasó la fecha límite sin devolución.'),
  (4, N'Renovado', N'Se amplió el plazo de entrega.'),
  (5, N'Reservado', N'Préstamo apartado, aún sin entrega.'),
  (6, N'Perdido', N'El ejemplar fue reportado como perdido.'),
  (7, N'Dañado', N'Se devolvió con daños.'),
  (8, N'En mora', N'Con multas pendientes de pago.'),
  (9, N'Cancelado', N'Cancelado antes de la entrega.'),
  (10, N'Pendiente de entrega', N'Aprobado, falta entregar al cliente.'),
  (11, N'Pendiente de devolución', N'Esperando la devolución del ejemplar.'),
  (12, N'Parcialmente devuelto', N'Devolvió solo parte de los ejemplares.'),
  (13, N'En revisión', N'Bajo revisión administrativa.'),
  (14, N'Extendido', N'Con plazo extendido por excepción.'),
  (15, N'Cerrado', N'Préstamo finalizado y sin saldo pendiente.');
SET IDENTITY_INSERT dbo.estadoprestamo OFF;
