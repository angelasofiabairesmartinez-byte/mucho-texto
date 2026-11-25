-- formatolibro
SET IDENTITY_INSERT dbo.formatolibro ON;
INSERT INTO dbo.formatolibro (id, nombre) VALUES
  (1, N'Tapa dura'),
  (2, N'Tapa blanda'),
  (3, N'Edición de bolsillo'),
  (4, N'eBook (EPUB)'),
  (5, N'Audiolibro'),
  (6, N'PDF digital'),
  (7, N'Rústica'),
  (8, N'Cartoné'),
  (9, N'Espiral'),
  (10, N'Braille'),
  (11, N'Edición de lujo'),
  (12, N'Álbum ilustrado'),
  (13, N'Cómic'),
  (14, N'Revista encuadernada'),
  (15, N'Libro de tela');
SET IDENTITY_INSERT dbo.formatolibro OFF;
