/* ============================================================
   Procedimiento: dbo.sp_guardar_progreso_lectura
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Guarda dónde va el cliente en un libro digital o
                audiolibro. Si es la primera vez crea el progreso; si no,
                lo actualiza. Calcula el porcentaje y el capítulo actual.
   Parámetros: @cliente_id (quien lee o escucha),
               @recurso_digital_id (libro digital o audiolibro),
               @posicion (página o segundo actual)
   Devuelve: progreso_id, posicion_actual, porcentaje, capitulo_numero,
             capitulo_titulo (NULL si el recurso no tiene capítulos)
   Errores: 50001 El cliente no existe, 50002 El recurso digital no
            existe o fue retirado, 50003 La posición no es válida
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_guardar_progreso_lectura
    @cliente_id INT,
    @recurso_digital_id INT,
    @posicion INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @total INT;
    DECLARE @porcentaje DECIMAL(5,2);
    DECLARE @progreso_id INT;
    DECLARE @capitulo_numero SMALLINT;
    DECLARE @capitulo_titulo NVARCHAR(150);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    SELECT @total = CASE r.tipo WHEN N'T' THEN r.total_paginas ELSE r.duracion_segundos END
    FROM dbo.recursodigital r
    WHERE r.id = @recurso_digital_id AND r.estado = 1;

    IF @@ROWCOUNT = 0
        THROW 50002, N'El recurso digital no existe o fue retirado.', 1;

    IF @posicion IS NULL OR @posicion < 0 OR (@total IS NOT NULL AND @posicion > @total)
        THROW 50003, N'La posición no es válida para este recurso.', 1;

    SET @porcentaje = dbo.fn_calcular_porcentaje_progreso(@recurso_digital_id, @posicion);

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            SELECT @progreso_id = pl.id
            FROM dbo.progresolectura pl WITH (UPDLOCK, HOLDLOCK)
            WHERE pl.cliente_id = @cliente_id AND pl.recurso_digital_id = @recurso_digital_id;

            IF @progreso_id IS NULL
            BEGIN
                INSERT INTO dbo.progresolectura (cliente_id, recurso_digital_id, posicion_actual, porcentaje)
                VALUES (@cliente_id, @recurso_digital_id, @posicion, @porcentaje);
                SET @progreso_id = SCOPE_IDENTITY();
            END
            ELSE
                UPDATE dbo.progresolectura
                SET posicion_actual = @posicion,
                    porcentaje = @porcentaje,
                    fecha_ultima_lectura = GETDATE()
                WHERE id = @progreso_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT TOP 1 @capitulo_numero = cr.numero, @capitulo_titulo = cr.titulo
        FROM dbo.capitulorecurso cr
        WHERE cr.recurso_digital_id = @recurso_digital_id AND cr.posicion_inicio <= @posicion
        ORDER BY cr.posicion_inicio DESC;

        SELECT @progreso_id AS progreso_id,
               @posicion AS posicion_actual,
               @porcentaje AS porcentaje,
               @capitulo_numero AS capitulo_numero,
               @capitulo_titulo AS capitulo_titulo;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
