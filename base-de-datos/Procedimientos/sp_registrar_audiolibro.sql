/* ============================================================
   Procedimiento: dbo.sp_registrar_audiolibro
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Publica el audiolibro de un libro con sus capítulos.
                Si el libro tuvo un audiolibro retirado, lo reemplaza y
                lo vuelve a activar.
   Parámetros: @libro_id, @ruta_archivo (ruta o URL del MP3),
               @duracion_segundos, @generado_ia (1: Generado con IA;
               0: Grabado), @voz_narracion (nombre de la voz; opcional),
               @capitulos (JSON opcional, ej.
               '[{"numero":1,"titulo":"Capítulo 1","posicion_inicio":0}]')
   Devuelve: recurso_digital_id, libro_id, duracion_segundos,
             capitulos (cantidad registrada)
   Errores: 50001 El libro no existe, 50002 La duración debe ser mayor
            que 0, 50003 El libro ya tiene un audiolibro activo,
            50004 Los capítulos no tienen un formato válido,
            50005 Un capítulo empieza fuera de la duración del audio,
            50006 generado_ia debe ser 0 o 1
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_audiolibro
    @libro_id INT,
    @ruta_archivo NVARCHAR(300),
    @duracion_segundos INT,
    @generado_ia SMALLINT = 1,
    @voz_narracion NVARCHAR(60) = NULL,
    @capitulos NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @recurso_id INT;
    DECLARE @estado_actual SMALLINT;
    DECLARE @lista TABLE (numero SMALLINT, titulo NVARCHAR(150), posicion_inicio INT);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.libro l WHERE l.id = @libro_id)
        THROW 50001, N'El libro no existe.', 1;

    IF @duracion_segundos IS NULL OR @duracion_segundos <= 0
        THROW 50002, N'La duración debe ser mayor que 0.', 1;

    SELECT @recurso_id = r.id, @estado_actual = r.estado
    FROM dbo.recursodigital r
    WHERE r.libro_id = @libro_id AND r.tipo = N'A';

    IF @estado_actual = 1
        THROW 50003, N'El libro ya tiene un audiolibro activo; retírelo antes de publicar otro.', 1;

    IF @capitulos IS NOT NULL
    BEGIN
        IF ISJSON(@capitulos) = 0
            THROW 50004, N'Los capítulos no tienen un formato válido.', 1;

        INSERT INTO @lista (numero, titulo, posicion_inicio)
        SELECT j.numero, j.titulo, j.posicion_inicio
        FROM OPENJSON(@capitulos)
            WITH (numero SMALLINT, titulo NVARCHAR(150), posicion_inicio INT) j;

        IF EXISTS (SELECT 1 FROM @lista c WHERE c.numero IS NULL OR c.titulo IS NULL OR c.posicion_inicio IS NULL)
           OR EXISTS (SELECT c.numero FROM @lista c GROUP BY c.numero HAVING COUNT(*) > 1)
            THROW 50004, N'Los capítulos no tienen un formato válido.', 1;

        IF EXISTS (SELECT 1 FROM @lista c WHERE c.posicion_inicio < 0 OR c.posicion_inicio >= @duracion_segundos)
            THROW 50005, N'Un capítulo empieza fuera de la duración del audio.', 1;
    END

    IF @generado_ia IS NULL OR @generado_ia NOT IN (0, 1)
        THROW 50006, N'generado_ia debe ser 0 o 1.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            IF @recurso_id IS NULL
            BEGIN
                INSERT INTO dbo.recursodigital (libro_id, tipo, ruta_archivo, total_paginas, duracion_segundos, generado_ia, voz_narracion)
                VALUES (@libro_id, N'A', @ruta_archivo, NULL, @duracion_segundos, @generado_ia, @voz_narracion);
                SET @recurso_id = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                UPDATE dbo.recursodigital
                SET ruta_archivo = @ruta_archivo,
                    duracion_segundos = @duracion_segundos,
                    generado_ia = @generado_ia,
                    voz_narracion = @voz_narracion,
                    fecha_publicacion = GETDATE(),
                    estado = 1
                WHERE id = @recurso_id;

                DELETE FROM dbo.capitulorecurso WHERE recurso_digital_id = @recurso_id;
            END

            INSERT INTO dbo.capitulorecurso (recurso_digital_id, numero, titulo, posicion_inicio)
            SELECT @recurso_id, c.numero, c.titulo, c.posicion_inicio
            FROM @lista c;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @recurso_id AS recurso_digital_id,
               @libro_id AS libro_id,
               @duracion_segundos AS duracion_segundos,
               (SELECT COUNT(*) FROM @lista) AS capitulos;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
