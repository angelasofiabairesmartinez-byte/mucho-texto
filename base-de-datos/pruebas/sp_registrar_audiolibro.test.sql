/* ============================================================
   Prueba: dbo.sp_registrar_audiolibro
   Caso 1: publica el audiolibro de un libro que no tiene, con dos
           capítulos (dentro de una transacción que se revierte).
   Caso 2: un audiolibro retirado se reemplaza y se vuelve a activar.
   Casos 3 a 7: errores 50001 a 50005.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @r TABLE (recurso_digital_id INT, libro_id INT, duracion_segundos INT, capitulos INT);
DECLARE @num INT;
DECLARE @caps NVARCHAR(MAX) = N'[{"numero":1,"titulo":"Capítulo 1","posicion_inicio":0},{"numero":2,"titulo":"Capítulo 2","posicion_inicio":600}]';
DECLARE @libro_sin_audio INT = (SELECT TOP 1 l.id FROM dbo.libro l
                                    WHERE NOT EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.libro_id = l.id AND r.tipo = N'A')
                                    ORDER BY l.id);

-- Caso 1: libro sin audiolibro
BEGIN TRANSACTION;
    INSERT INTO @r EXEC dbo.sp_registrar_audiolibro @libro_id = @libro_sin_audio, @ruta_archivo = N'/biblioteca-digital/audio/prueba.mp3',
        @duracion_segundos = 1200, @voz_narracion = N'Voz IA de prueba', @capitulos = @caps;
    IF NOT EXISTS (SELECT 1 FROM @r WHERE recurso_digital_id IS NOT NULL AND capitulos = 2)
        THROW 50951, N'PRUEBA FALLIDA: debía crear el audiolibro con 2 capítulos.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.libro_id = @libro_sin_audio AND r.tipo = N'A' AND r.estado = 1)
        THROW 50952, N'PRUEBA FALLIDA: el audiolibro debía quedar activo.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: reemplazar un audiolibro retirado (recurso 23, libro 1)
DELETE FROM @r;
BEGIN TRANSACTION;
    UPDATE dbo.recursodigital SET estado = 0 WHERE id = 23;
    INSERT INTO @r EXEC dbo.sp_registrar_audiolibro @libro_id = 1, @ruta_archivo = N'/biblioteca-digital/audio/libro_001_v2.mp3',
        @duracion_segundos = 1200, @capitulos = @caps;
    IF NOT EXISTS (SELECT 1 FROM @r WHERE recurso_digital_id = 23)
        THROW 50953, N'PRUEBA FALLIDA: debía reutilizar el recurso 23.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.id = 23 AND r.estado = 1 AND r.duracion_segundos = 1200)
       OR (SELECT COUNT(*) FROM dbo.capitulorecurso cr WHERE cr.recurso_digital_id = 23) <> 2
        THROW 50954, N'PRUEBA FALLIDA: debía reactivar el recurso con sus capítulos nuevos.', 1;
ROLLBACK TRANSACTION;

-- Casos 3 a 7: errores
DECLARE @casos TABLE (esperado INT, libro_id INT, duracion INT, capitulos NVARCHAR(MAX));
INSERT INTO @casos VALUES
    (50001, -1, 1200, NULL),
    (50002, @libro_sin_audio, 0, NULL),
    (50003, 1, 1200, NULL),
    (50004, @libro_sin_audio, 1200, N'esto no es json'),
    (50005, @libro_sin_audio, 1200, N'[{"numero":1,"titulo":"Fuera","posicion_inicio":5000}]');

DECLARE @esperado INT, @libro INT, @duracion INT, @c NVARCHAR(MAX), @mensaje NVARCHAR(200);
DECLARE casos CURSOR LOCAL FAST_FORWARD FOR SELECT esperado, libro_id, duracion, capitulos FROM @casos;
OPEN casos;
FETCH NEXT FROM casos INTO @esperado, @libro, @duracion, @c;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @num = 0;
    BEGIN TRY
        EXEC dbo.sp_registrar_audiolibro @libro_id = @libro, @ruta_archivo = N'/x.mp3', @duracion_segundos = @duracion, @capitulos = @c;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH
    IF @num <> @esperado
    BEGIN
        SET @mensaje = CONCAT(N'PRUEBA FALLIDA: sp_registrar_audiolibro debía lanzar ', @esperado, N' y lanzó ', @num, N'.');
        THROW 50955, @mensaje, 1;
    END
    FETCH NEXT FROM casos INTO @esperado, @libro, @duracion, @c;
END
CLOSE casos;
DEALLOCATE casos;

PRINT N'OK sp_registrar_audiolibro';
