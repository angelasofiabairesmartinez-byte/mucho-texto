/* ============================================================
   Prueba: dbo.sp_registrar_venta
   Caso 1: una venta válida (2 libros a L 100.00, descuento 10% e
           impuesto 15%) da subtotal 200.00, descuento 20.00, impuesto
           27.00 y total 207.00; crea factura, detalle, pago y movimiento
           SALIDA, y descuenta 2 del inventario.
   Casos siguientes: cada error (50001 a 50013 y 50015) debe lanzarse
           con su número.
   Todo corre dentro de una transacción que se revierte.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
DECLARE @r TABLE (factura_id INT, subtotal DECIMAL(10,2), descuento_total DECIMAL(10,2), impuesto_total DECIMAL(10,2), total DECIMAL(10,2));
DECLARE @empleado_id INT = (SELECT TOP 1 e.id FROM dbo.empleado e ORDER BY e.id);
DECLARE @sucursal_id INT, @libro_id INT;
DECLARE @desc_id INT, @desc_inactivo INT, @imp_id INT, @factura_id INT;

SELECT TOP 1 @sucursal_id = i.sucursal_id, @libro_id = i.libro_id
FROM dbo.inventariosucursal i
ORDER BY i.id;

IF @empleado_id IS NULL OR @sucursal_id IS NULL OR @libro_id IS NULL
    THROW 50975, N'PRUEBA FALLIDA: faltan datos (empleado o inventario de sucursal).', 1;

BEGIN TRANSACTION;
    UPDATE dbo.libro SET precio_venta = 100.00 WHERE id = @libro_id;
    UPDATE dbo.inventariosucursal SET cantidad_disponible = 10
    WHERE sucursal_id = @sucursal_id AND libro_id = @libro_id;

    INSERT INTO dbo.descuento (nombre, tipo_descuento, valor, fecha_inicio, estado)
    VALUES (N'Prueba 10%', N'PORCENTAJE', 10.00, DATEADD(DAY, -1, @hoy), 1);
    SET @desc_id = SCOPE_IDENTITY();

    INSERT INTO dbo.descuento (nombre, tipo_descuento, valor, fecha_inicio, estado)
    VALUES (N'Prueba inactivo', N'PORCENTAJE', 10.00, DATEADD(DAY, -1, @hoy), 0);
    SET @desc_inactivo = SCOPE_IDENTITY();

    INSERT INTO dbo.impuesto (nombre, porcentaje, fecha_inicio)
    VALUES (N'Prueba 15%', 15.00, DATEADD(DAY, -1, @hoy));
    SET @imp_id = SCOPE_IDENTITY();

    -- Caso 1: debe funcionar
    DECLARE @det_ok NVARCHAR(MAX) = CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":2,"descuento_id":', @desc_id, N',"impuesto_id":', @imp_id, N'}]');
    DECLARE @pagos_ok NVARCHAR(MAX) = N'[{"forma_pago_id":1,"monto":207.00,"referencia":null}]';

    INSERT INTO @r
    EXEC dbo.sp_registrar_venta
        @empleado_id = @empleado_id, @sucursal_id = @sucursal_id,
        @detalle = @det_ok, @pagos = @pagos_ok;

    SELECT @factura_id = factura_id FROM @r;

    IF NOT EXISTS (SELECT 1 FROM @r WHERE factura_id IS NOT NULL AND subtotal = 200.00
                   AND descuento_total = 20.00 AND impuesto_total = 27.00 AND total = 207.00)
        THROW 50976, N'PRUEBA FALLIDA: los totales debían ser 200.00, 20.00, 27.00 y 207.00.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.detallefactura
                   WHERE factura_id = @factura_id AND libro_id = @libro_id AND cantidad = 2
                     AND precio_unitario = 100.00 AND descuento = 20.00 AND monto_impuesto = 27.00)
        THROW 50977, N'PRUEBA FALLIDA: el detalle de factura no quedó con los valores esperados.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.facturaformapago
                   WHERE factura_id = @factura_id AND forma_pago_id = 1 AND monto = 207.00)
        THROW 50978, N'PRUEBA FALLIDA: no se registró el pago de la factura.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.inventariosucursal
                   WHERE sucursal_id = @sucursal_id AND libro_id = @libro_id AND cantidad_disponible = 8)
        THROW 50979, N'PRUEBA FALLIDA: el inventario debía bajar de 10 a 8.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.movimientoinventario
                   WHERE sucursal_id = @sucursal_id AND tipo_movimiento = N'SALIDA' AND cantidad = 2
                     AND observacion LIKE CONCAT(N'Venta factura ', @factura_id, N'%'))
        THROW 50980, N'PRUEBA FALLIDA: no se registró el movimiento SALIDA.', 1;

    -- Casos de error
    DECLARE @det_simple NVARCHAR(MAX) = CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":1}]');
    DECLARE @pagos_simple NVARCHAR(MAX) = N'[{"forma_pago_id":1,"monto":100.00}]';

    DECLARE @casos TABLE (
        id INT IDENTITY(1,1) PRIMARY KEY,
        descripcion NVARCHAR(80),
        empleado_id INT, sucursal_id INT, cliente_id INT,
        detalle NVARCHAR(MAX), pagos NVARCHAR(MAX), canal NVARCHAR(1),
        esperado INT
    );

    INSERT INTO @casos (descripcion, empleado_id, sucursal_id, cliente_id, detalle, pagos, canal, esperado) VALUES
      (N'empleado inexistente',   -1,           @sucursal_id, NULL, @det_simple, @pagos_simple, N'T', 50001),
      (N'sucursal inexistente',   @empleado_id, -1,           NULL, @det_simple, @pagos_simple, N'T', 50002),
      (N'cliente inexistente',    @empleado_id, @sucursal_id, -1,   @det_simple, @pagos_simple, N'T', 50003),
      (N'sin libros',             @empleado_id, @sucursal_id, NULL, N'[]',       @pagos_simple, N'T', 50004),
      (N'sin formas de pago',     @empleado_id, @sucursal_id, NULL, @det_simple, N'[]',         N'T', 50004),
      (N'libro inexistente',      @empleado_id, @sucursal_id, NULL, N'[{"libro_id":-1,"cantidad":1}]', @pagos_simple, N'T', 50005),
      (N'sin existencias',        @empleado_id, @sucursal_id, NULL, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":999999}]'), @pagos_simple, N'T', 50006),
      (N'pagos no coinciden',     @empleado_id, @sucursal_id, NULL, @det_simple, N'[{"forma_pago_id":1,"monto":1.00}]', N'T', 50007),
      (N'descuento inactivo',     @empleado_id, @sucursal_id, NULL, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":1,"descuento_id":', @desc_inactivo, N'}]'), @pagos_simple, N'T', 50008),
      (N'impuesto inexistente',   @empleado_id, @sucursal_id, NULL, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":1,"impuesto_id":-1}]'), @pagos_simple, N'T', 50009),
      (N'forma de pago inexistente', @empleado_id, @sucursal_id, NULL, @det_simple, N'[{"forma_pago_id":-1,"monto":100.00}]', N'T', 50010),
      (N'cantidad cero',          @empleado_id, @sucursal_id, NULL, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":0}]'), @pagos_simple, N'T', 50011),
      (N'canal inválido',         @empleado_id, @sucursal_id, NULL, @det_simple, @pagos_simple, N'X', 50012),
      (N'forma de pago repetida', @empleado_id, @sucursal_id, NULL, @det_simple, N'[{"forma_pago_id":1,"monto":50.00},{"forma_pago_id":1,"monto":50.00}]', N'T', 50013),
      (N'pago en cero',           @empleado_id, @sucursal_id, NULL, @det_simple, N'[{"forma_pago_id":1,"monto":0}]', N'T', 50015);

    DECLARE @i INT = 1;
    DECLARE @n INT = (SELECT COUNT(*) FROM @casos);
    DECLARE @c_desc NVARCHAR(80), @c_emp INT, @c_suc INT, @c_cli INT;
    DECLARE @c_det NVARCHAR(MAX), @c_pag NVARCHAR(MAX), @c_can NVARCHAR(1), @c_esp INT;
    DECLARE @num INT, @msg NVARCHAR(400);

    WHILE @i <= @n
    BEGIN
        SELECT @c_desc = descripcion, @c_emp = empleado_id, @c_suc = sucursal_id, @c_cli = cliente_id,
               @c_det = detalle, @c_pag = pagos, @c_can = canal, @c_esp = esperado
        FROM @casos WHERE id = @i;

        SET @num = 0;
        BEGIN TRY
            EXEC dbo.sp_registrar_venta
                @empleado_id = @c_emp, @sucursal_id = @c_suc, @cliente_id = @c_cli,
                @detalle = @c_det, @pagos = @c_pag, @canal = @c_can;
        END TRY
        BEGIN CATCH
            SET @num = ERROR_NUMBER();
        END CATCH

        IF @num <> @c_esp
        BEGIN
            SET @msg = CONCAT(N'PRUEBA FALLIDA: el caso "', @c_desc, N'" debía dar el error ', @c_esp, N' y dio ', @num, N'.');
            THROW 50981, @msg, 1;
        END

        SET @i += 1;
    END
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

PRINT N'OK sp_registrar_venta';