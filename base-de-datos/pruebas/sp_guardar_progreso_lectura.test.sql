/* ============================================================
   Prueba: dbo.sp_guardar_progreso_lectura
   Caso 1: la primera vez crea el progreso; la segunda lo actualiza
           y devuelve el capítulo actual (dentro de una transacción
           que se revierte).
   Casos 2 a 4: cada error (50001 a 50003) debe lanzarse con su número.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @r TABLE (progreso_id INT, posicion_actual INT, porcentaje DECIMAL(5,2), capitulo_numero SMALLINT, capitulo_titulo NVARCHAR(150));
DECLARE @num INT;
DECLARE @cliente_id INT = (SELECT TOP 1 c.id FROM dbo.cliente c
                               WHERE NOT EXISTS (SELECT 1 FROM dbo.progresolectura pl WHERE pl.cliente_id = c.id AND pl.recurso_digital_id = 23)
                               ORDER BY c.id);

-- Caso 1: debe funcionar
BEGIN TRANSACTION;
    INSERT INTO @r EXEC dbo.sp_guardar_progreso_lectura @cliente_id = @cliente_id, @recurso_digital_id = 23, @posicion = 5280;
    IF NOT EXISTS (SELECT 1 FROM @r WHERE progreso_id IS NOT NULL AND porcentaje = 25.00 AND capitulo_numero = 1)
        THROW 50945, N'PRUEBA FALLIDA: la primera vez debía crear el progreso en 25% y capítulo 1.', 1;

    DELETE FROM @r;
    INSERT INTO @r EXEC dbo.sp_guardar_progreso_lectura @cliente_id = @cliente_id, @recurso_digital_id = 23, @posicion = 10560;
    IF NOT EXISTS (SELECT 1 FROM @r WHERE porcentaje = 50.00 AND capitulo_numero = 2)
        THROW 50946, N'PRUEBA FALLIDA: la segunda vez debía quedar en 50% y capítulo 2.', 1;

    IF (SELECT COUNT(*) FROM dbo.progresolectura pl WHERE pl.cliente_id = @cliente_id AND pl.recurso_digital_id = 23) <> 1
        THROW 50947, N'PRUEBA FALLIDA: debía existir un solo progreso por cliente y recurso.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: cliente que no existe (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_guardar_progreso_lectura @cliente_id = -1, @recurso_digital_id = 23, @posicion = 10;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50948, N'PRUEBA FALLIDA: debía lanzar 50001 con un cliente inexistente.', 1;

-- Caso 3: recurso retirado (50002)
SET @num = 0;
BEGIN TRANSACTION;
    UPDATE dbo.recursodigital SET estado = 0 WHERE id = 23;
    BEGIN TRY
        EXEC dbo.sp_guardar_progreso_lectura @cliente_id = @cliente_id, @recurso_digital_id = 23, @posicion = 10;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50002
    THROW 50949, N'PRUEBA FALLIDA: debía lanzar 50002 con un recurso retirado.', 1;

-- Caso 4: posición mayor que la duración (50003)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_guardar_progreso_lectura @cliente_id = @cliente_id, @recurso_digital_id = 23, @posicion = 99999;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50003
    THROW 50950, N'PRUEBA FALLIDA: debía lanzar 50003 con una posición fuera del recurso.', 1;

PRINT N'OK sp_guardar_progreso_lectura';
