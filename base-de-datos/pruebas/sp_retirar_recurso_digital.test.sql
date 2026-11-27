/* ============================================================
   Prueba: dbo.sp_retirar_recurso_digital
   Caso 1: retira el recurso 23 y conserva su progreso y capítulos
           (dentro de una transacción que se revierte).
   Casos 2 y 3: errores 50001 y 50002.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @r TABLE (recurso_digital_id INT, libro_id INT, tipo NVARCHAR(1), lectores_afectados INT);
DECLARE @num INT;
DECLARE @capitulos INT = (SELECT COUNT(*) FROM dbo.capitulorecurso cr WHERE cr.recurso_digital_id = 23);

-- Caso 1: debe funcionar
BEGIN TRANSACTION;
    INSERT INTO @r EXEC dbo.sp_retirar_recurso_digital @recurso_digital_id = 23;
    IF NOT EXISTS (SELECT 1 FROM @r WHERE recurso_digital_id = 23 AND tipo = N'A')
        THROW 50956, N'PRUEBA FALLIDA: sp_retirar_recurso_digital no devolvió el recurso.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.id = 23 AND r.estado = 0)
        THROW 50957, N'PRUEBA FALLIDA: el recurso debía quedar en estado 0.', 1;
    IF (SELECT COUNT(*) FROM dbo.capitulorecurso cr WHERE cr.recurso_digital_id = 23) <> @capitulos
        THROW 50958, N'PRUEBA FALLIDA: no debía borrar los capítulos.', 1;

    -- Caso 3: retirarlo otra vez (50002)
    SET @num = 0;
    BEGIN TRY
        EXEC dbo.sp_retirar_recurso_digital @recurso_digital_id = 23;
    END TRY
    BEGIN CATCH
        SET @num = ERROR_NUMBER();
    END CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
IF @num <> 50002
    THROW 50959, N'PRUEBA FALLIDA: debía lanzar 50002 al retirar dos veces.', 1;

-- Caso 2: recurso que no existe (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_retirar_recurso_digital @recurso_digital_id = -1;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50960, N'PRUEBA FALLIDA: debía lanzar 50001 con un recurso inexistente.', 1;

PRINT N'OK sp_retirar_recurso_digital';
