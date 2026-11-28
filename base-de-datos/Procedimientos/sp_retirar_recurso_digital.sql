/* ============================================================
   Procedimiento: dbo.sp_retirar_recurso_digital
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Retira del catálogo un libro digital o audiolibro
                (estado 0). No borra nada: el progreso, las notas y los
                capítulos se conservan por si se vuelve a publicar.
   Parámetros: @recurso_digital_id
   Devuelve: recurso_digital_id, libro_id, tipo (T: Texto; A: Audio),
             lectores_afectados (clientes que tenían progreso)
   Errores: 50001 El recurso digital no existe, 50002 El recurso
            digital ya estaba retirado
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_retirar_recurso_digital
    @recurso_digital_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @estado SMALLINT;

    -- 1. Validaciones (antes de escribir nada)
    SELECT @estado = r.estado FROM dbo.recursodigital r WHERE r.id = @recurso_digital_id;

    IF @estado IS NULL
        THROW 50001, N'El recurso digital no existe.', 1;

    IF @estado = 0
        THROW 50002, N'El recurso digital ya estaba retirado.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE dbo.recursodigital SET estado = 0 WHERE id = @recurso_digital_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT r.id AS recurso_digital_id,
               r.libro_id,
               r.tipo,
               (SELECT COUNT(*) FROM dbo.progresolectura pl WHERE pl.recurso_digital_id = r.id) AS lectores_afectados
        FROM dbo.recursodigital r
        WHERE r.id = @recurso_digital_id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
