/* ============================================================
   Procedimiento: dbo.sp_crear_reserva
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Crea una reserva PENDIENTE (tipo R) de un libro sin
                ejemplares disponibles para un cliente que puede prestar.
   Parámetros: @cliente_id, @libro_id
   Devuelve: reserva_id, estado (siempre PENDIENTE al crearla)
   Errores: 50001 El cliente no existe, 50002 El libro no existe,
            50003 El libro tiene ejemplares disponibles; no se puede
            reservar, 50004 El cliente ya tiene una reserva pendiente de
            este libro, 50005 El cliente no puede reservar porque no
            cumple las condiciones para préstamo
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_crear_reserva
    @cliente_id INT,
    @libro_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @estado_disponible INT = (SELECT id FROM dbo.estadoejemplar WHERE nombre = N'Disponible');
    DECLARE @reserva_id INT;
    DECLARE @estado NVARCHAR(30);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50001, N'El cliente no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.libro l WHERE l.id = @libro_id)
        THROW 50002, N'El libro no existe.', 1;

    IF EXISTS (SELECT 1 FROM dbo.ejemplar e
               WHERE e.libro_id = @libro_id AND e.estado_ejemplar_id = @estado_disponible)
        THROW 50003, N'El libro tiene ejemplares disponibles; no se puede reservar.', 1;

    IF EXISTS (SELECT 1 FROM dbo.reserva r
               WHERE r.cliente_id = @cliente_id AND r.libro_id = @libro_id AND r.estado = N'PENDIENTE')
        THROW 50004, N'El cliente ya tiene una reserva pendiente de este libro.', 1;

    IF dbo.fn_puede_prestar(@cliente_id) = 0
        THROW 50005, N'El cliente no puede reservar porque no cumple las condiciones para préstamo.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.reserva (cliente_id, libro_id)
            VALUES (@cliente_id, @libro_id);
            SET @reserva_id = SCOPE_IDENTITY();

            SELECT @estado = r.estado FROM dbo.reserva r WHERE r.id = @reserva_id;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @reserva_id AS reserva_id,
               @estado AS estado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO