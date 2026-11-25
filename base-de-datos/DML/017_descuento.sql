-- descuento
SET IDENTITY_INSERT dbo.descuento ON;
INSERT INTO dbo.descuento (id, nombre, descripcion, tipo_descuento, valor, fecha_inicio, fecha_fin, estado) VALUES
  (1, N'Descuento estudiante', N'Para estudiantes con carné vigente.', N'PORCENTAJE', 10.00, '2025-01-10', NULL, 1),
  (2, N'Cliente frecuente', N'Beneficio por compras recurrentes.', N'PORCENTAJE', 5.00, '2025-01-10', NULL, 1),
  (3, N'Promoción de temporada', N'Descuento por temporada alta.', N'PORCENTAJE', 15.00, '2025-06-01', NULL, 1),
  (4, N'Adulto mayor', N'Para clientes de 60 años o más.', N'PORCENTAJE', 20.00, '2025-01-10', NULL, 1),
  (5, N'Día del libro', N'Celebración del Día del Libro.', N'PORCENTAJE', 25.00, '2025-04-01', NULL, 1),
  (6, N'Liquidación de inventario', N'Salida de títulos con poca rotación.', N'PORCENTAJE', 30.00, '2025-08-01', NULL, 1),
  (7, N'Cupón de bienvenida', N'Monto fijo para nuevos clientes.', N'MONTO_FIJO', 50.00, '2025-03-01', NULL, 1),
  (8, N'Bono lector', N'Monto fijo por lectura del mes.', N'MONTO_FIJO', 25.00, '2025-03-01', NULL, 1),
  (9, N'Descuento a empleados', N'Beneficio interno del personal.', N'PORCENTAJE', 15.00, '2025-01-10', NULL, 1),
  (10, N'Compra mayorista', N'Para compras de gran volumen.', N'PORCENTAJE', 12.00, '2025-02-01', NULL, 1),
  (11, N'Aniversario de la librería', N'Promoción por aniversario.', N'PORCENTAJE', 18.00, '2025-05-05', '2025-05-31', 0),
  (12, N'Black Friday 2025', N'Promoción de fin de noviembre.', N'PORCENTAJE', 35.00, '2025-11-28', '2025-11-30', 0),
  (13, N'Fin de año', N'Descuento de temporada navideña.', N'PORCENTAJE', 20.00, '2025-12-01', NULL, 1),
  (14, N'Regreso a clases', N'Campaña escolar de inicio de año.', N'PORCENTAJE', 10.00, '2025-12-15', NULL, 1),
  (15, N'Membresía premium', N'Beneficio exclusivo de socios.', N'PORCENTAJE', 8.00, '2025-01-10', NULL, 1);
SET IDENTITY_INSERT dbo.descuento OFF;
