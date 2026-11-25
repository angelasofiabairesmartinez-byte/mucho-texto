-- tipocliente
SET IDENTITY_INSERT dbo.tipocliente ON;
INSERT INTO dbo.tipocliente (id, nombre, descripcion, limite_prestamos, limite_renovaciones) VALUES
  (1, N'Estudiante', N'Lector inscrito en un centro educativo.', 3, 1),
  (2, N'Docente', N'Educador de cualquier nivel.', 5, 2),
  (3, N'Investigador', N'Persona que consulta fuentes con fines de estudio.', 5, 2),
  (4, N'Adulto mayor', N'Cliente de 60 años o más.', 3, 1),
  (5, N'Niño o niña', N'Lector menor de 12 años.', 2, 0),
  (6, N'Joven', N'Lector de entre 12 y 25 años.', 3, 1),
  (7, N'Empleado público', N'Trabajador de una institución del Estado.', 3, 1),
  (8, N'Empresa', N'Cliente corporativo.', 10, 2),
  (9, N'Institución educativa', N'Escuela, colegio o universidad.', 10, 2),
  (10, N'Biblioteca aliada', N'Biblioteca con convenio de intercambio.', 8, 2),
  (11, N'Cliente frecuente', N'Cliente con compras o préstamos recurrentes.', 5, 2),
  (12, N'Cliente ocasional', N'Cliente con visitas esporádicas.', 2, 0),
  (13, N'Socio premium', N'Cliente con membresía de beneficios.', 7, 3),
  (14, N'Visitante', N'Persona que consulta en sala.', 0, 0),
  (15, N'Jubilado', N'Cliente jubilado o pensionado.', 3, 1);
SET IDENTITY_INSERT dbo.tipocliente OFF;
