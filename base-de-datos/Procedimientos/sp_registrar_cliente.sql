/* ============================================================
   Procedimiento: dbo.sp_registrar_cliente
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Registra un cliente completo en una transacción: persona,
                teléfono, cliente, credencial ACTIVA por un año y usuario
                con rol Cliente.
   Parámetros: @nombre, @segundo_nombre, @apellido, @segundo_apellido,
               @correo, @genero (M o F), @fecha_nacimiento, @telefono,
               @tipo_telefono (P, L o F), @tipo_cliente_id,
               @nombre_usuario, @contrasena_hash (lo calcula la API),
               @empleado_id (quien registra; opcional)
   Devuelve: cliente_id, persona_id, credencial_id, usuario_id,
             fecha_vencimiento (de la credencial)
   Errores: 50001 El correo ya está registrado, 50002 El tipo de cliente
            no existe, 50003 El empleado no existe, 50004 El nombre de
            usuario ya existe, 50005 El tipo de teléfono no es válido,
            50006 El género no es válido
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_cliente
    @nombre NVARCHAR(60),
    @segundo_nombre NVARCHAR(60) = NULL,
    @apellido NVARCHAR(60),
    @segundo_apellido NVARCHAR(60) = NULL,
    @correo NVARCHAR(120),
    @genero NCHAR(1) = NULL,
    @fecha_nacimiento DATE = NULL,
    @telefono NVARCHAR(25),
    @tipo_telefono NVARCHAR(1),
    @tipo_cliente_id INT,
    @nombre_usuario NVARCHAR(50),
    @contrasena_hash NVARCHAR(255),
    @empleado_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @rol_cliente_id INT = 16;  -- rol Cliente
    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @fecha_vencimiento DATE = DATEADD(YEAR, 1, @hoy);
    DECLARE @persona_id INT;
    DECLARE @cliente_id INT;
    DECLARE @credencial_id INT;
    DECLARE @usuario_id INT;

    -- 1. Validaciones (antes de escribir nada)
    IF EXISTS (SELECT 1 FROM dbo.persona p WHERE p.correo = @correo)
        THROW 50001, N'El correo ya está registrado.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.tipocliente tc WHERE tc.id = @tipo_cliente_id)
        THROW 50002, N'El tipo de cliente no existe.', 1;

    IF @empleado_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50003, N'El empleado no existe.', 1;

    IF EXISTS (SELECT 1 FROM dbo.usuario u WHERE u.nombre_usuario = @nombre_usuario)
        THROW 50004, N'El nombre de usuario ya existe.', 1;

    IF @tipo_telefono NOT IN (N'P', N'L', N'F')
        THROW 50005, N'El tipo de teléfono no es válido; use P, L o F.', 1;

    IF @genero IS NOT NULL AND @genero NOT IN (N'M', N'F')
        THROW 50006, N'El género no es válido; use M o F.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.persona (nombre, segundo_nombre, apellido, segundo_apellido, correo, genero, fecha_nacimiento)
            VALUES (@nombre, @segundo_nombre, @apellido, @segundo_apellido, @correo, @genero, @fecha_nacimiento);
            SET @persona_id = SCOPE_IDENTITY();

            INSERT INTO dbo.telefono (numero, persona_id, tipo)
            VALUES (@telefono, @persona_id, @tipo_telefono);

            INSERT INTO dbo.cliente (fecha_registro, persona_id, tipo_cliente_id)
            VALUES (@hoy, @persona_id, @tipo_cliente_id);
            SET @cliente_id = SCOPE_IDENTITY();

            INSERT INTO dbo.credencial (fecha_registro, fecha_vencimiento, estado, cliente_id, empleado_id)
            VALUES (@hoy, @fecha_vencimiento, N'ACTIVA', @cliente_id, @empleado_id);
            SET @credencial_id = SCOPE_IDENTITY();

            INSERT INTO dbo.usuario (nombre_usuario, contrasena_hash, persona_id, rol_id)
            VALUES (@nombre_usuario, @contrasena_hash, @persona_id, @rol_cliente_id);
            SET @usuario_id = SCOPE_IDENTITY();
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @cliente_id AS cliente_id,
               @persona_id AS persona_id,
               @credencial_id AS credencial_id,
               @usuario_id AS usuario_id,
               @fecha_vencimiento AS fecha_vencimiento;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO