-- categoria
SET IDENTITY_INSERT dbo.categoria ON;
INSERT INTO dbo.categoria (id, nombre, descripcion) VALUES
  (1, N'Ficción', N'Novelas y cuentos de narrativa literaria.'),
  (2, N'Ciencia', N'Divulgación y textos de ciencias naturales.'),
  (3, N'Tecnología', N'Informática, programación y tecnología.'),
  (4, N'Historia', N'Historia nacional, regional y universal.'),
  (5, N'Biografía', N'Biografías, memorias y testimonios.'),
  (6, N'Infantil', N'Libros para lectores de primera infancia.'),
  (7, N'Juvenil', N'Literatura para adolescentes y jóvenes.'),
  (8, N'Poesía', N'Poemarios y antologías poéticas.'),
  (9, N'Arte', N'Artes visuales, música y fotografía.'),
  (10, N'Cocina', N'Recetarios y gastronomía.'),
  (11, N'Salud', N'Salud, nutrición y bienestar.'),
  (12, N'Educación', N'Pedagogía y material de apoyo escolar.'),
  (13, N'Negocios', N'Finanzas, emprendimiento y administración.'),
  (14, N'Autoayuda', N'Desarrollo personal y hábitos.'),
  (15, N'Filosofía', N'Pensamiento, ética y filosofía.');
SET IDENTITY_INSERT dbo.categoria OFF;
