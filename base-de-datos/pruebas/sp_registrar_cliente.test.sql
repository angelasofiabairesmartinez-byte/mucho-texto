/* ============================================================
   Prueba: dbo.sp_registrar_cliente
   Caso 1: un registro válido crea persona, teléfono, cliente,
           credencial ACTIVA por un año y usuario con rol Cliente
           (dentro de una transacción que se revierte).
   Casos 2 a 7: cada error (50001 a 50006) debe lanzarse con su número.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
DECLARE @r TABLE (cliente_id INT, persona_id INT, credencial_id INT, usuario_id INT, fecha_vencimiento DATE);
DECLARE @num INT;

-- Caso 1: debe funcionar
BEGIN TRANSACTION;
    INSERT INTO @r
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @genero = N'F', @telefono = N'+504 9999-0000', @tipo_telefono = N'P',
        @tipo_cliente_id = 1, @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash',
        @empleado_id = 1;

    IF NOT EXISTS (SELECT 1 FROM @r WHERE cliente_id IS NOT NULL AND persona_id IS NOT NULL
                                      AND credencial_id IS NOT NULL AND usuario_id IS NOT NULL)
        THROW 50929, N'PRUEBA FALLIDA: sp_registrar_cliente no devolvió los ids.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.persona p WHERE p.correo = N'prueba.cliente@example.com')
        THROW 50930, N'PRUEBA FALLIDA: no se creó la persona.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.telefono t INNER JOIN dbo.persona p ON p.id = t.persona_id
                   WHERE p.correo = N'prueba.cliente@example.com' AND t.numero = N'+504 9999-0000' AND t.tipo = N'P')
        THROW 50931, N'PRUEBA FALLIDA: no se creó el teléfono.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.credencial cr
                   INNER JOIN dbo.cliente c ON c.id = cr.cliente_id
                   INNER JOIN dbo.persona p ON p.id = c.persona_id
                   WHERE p.correo = N'prueba.cliente@example.com' AND cr.estado = N'ACTIVA'
                     AND cr.fecha_vencimiento = DATEADD(YEAR, 1, @hoy))
        THROW 50932, N'PRUEBA FALLIDA: la credencial debía quedar ACTIVA por un año.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.usuario u INNER JOIN dbo.persona p ON p.id = u.persona_id
                   WHERE p.correo = N'prueba.cliente@example.com' AND u.nombre_usuario = N'prueba_cliente' AND u.rol_id = 16)
        THROW 50933, N'PRUEBA FALLIDA: el usuario debía crearse con el rol Cliente.', 1;
ROLLBACK TRANSACTION;

-- Caso 2: correo repetido (50001)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'andrea.castro31@example.com',
        @telefono = N'+504 9999-0000', @tipo_telefono = N'P', @tipo_cliente_id = 1,
        @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50001
    THROW 50934, N'PRUEBA FALLIDA: un correo repetido debía dar el error 50001.', 1;

-- Caso 3: tipo de cliente inexistente (50002)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @telefono = N'+504 9999-0000', @tipo_telefono = N'P', @tipo_cliente_id = -1,
        @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50002
    THROW 50935, N'PRUEBA FALLIDA: un tipo de cliente inexistente debía dar el error 50002.', 1;

-- Caso 4: empleado inexistente (50003)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @telefono = N'+504 9999-0000', @tipo_telefono = N'P', @tipo_cliente_id = 1,
        @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash', @empleado_id = -1;
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50003
    THROW 50936, N'PRUEBA FALLIDA: un empleado inexistente debía dar el error 50003.', 1;

-- Caso 5: nombre de usuario repetido (50004)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @telefono = N'+504 9999-0000', @tipo_telefono = N'P', @tipo_cliente_id = 1,
        @nombre_usuario = N'acastro', @contrasena_hash = N'TEST$hash';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50004
    THROW 50937, N'PRUEBA FALLIDA: un nombre de usuario repetido debía dar el error 50004.', 1;

-- Caso 6: tipo de teléfono inválido (50005)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @telefono = N'+504 9999-0000', @tipo_telefono = N'X', @tipo_cliente_id = 1,
        @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50005
    THROW 50938, N'PRUEBA FALLIDA: un tipo de teléfono inválido debía dar el error 50005.', 1;

-- Caso 7: género inválido (50006)
SET @num = 0;
BEGIN TRY
    EXEC dbo.sp_registrar_cliente
        @nombre = N'Prueba', @apellido = N'Cliente', @correo = N'prueba.cliente@example.com',
        @genero = N'X', @telefono = N'+504 9999-0000', @tipo_telefono = N'P', @tipo_cliente_id = 1,
        @nombre_usuario = N'prueba_cliente', @contrasena_hash = N'TEST$hash';
END TRY
BEGIN CATCH
    SET @num = ERROR_NUMBER();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
IF @num <> 50006
    THROW 50939, N'PRUEBA FALLIDA: un género inválido debía dar el error 50006.', 1;

PRINT N'OK sp_registrar_cliente';