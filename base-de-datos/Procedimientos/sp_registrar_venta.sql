/* ============================================================
   Procedimiento: dbo.sp_registrar_venta
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra una venta en una transacción: factura, detalle
                (precio, descuento e impuesto por línea), formas de pago
                e inventario de la sucursal (descuenta existencias y
                registra el movimiento SALIDA).
   Parámetros: @empleado_id, @sucursal_id, @cliente_id (opcional),
               @detalle (JSON, ej. '[{"libro_id":3,"cantidad":2,
               "descuento_id":null,"impuesto_id":1}]'),
               @pagos (JSON, ej. '[{"forma_pago_id":1,"monto":250.00,
               "referencia":null}]'), @canal (T: tienda; L: en línea;
               por defecto T)
   Devuelve: factura_id, subtotal, descuento_total, impuesto_total, total
   Errores: 50001 El empleado no existe, 50002 La sucursal no existe,
            50003 El cliente no existe, 50004 Debe indicar al menos un
            libro y una forma de pago, 50005 Uno de los libros no existe,
            50006 No hay existencias suficientes en la sucursal, 50007 La
            suma de los pagos no coincide con el total, 50008 El descuento
            no existe, no está activo o no está vigente, 50009 El impuesto
            no existe o no está vigente, 50010 La forma de pago no existe,
            50011 La cantidad de cada libro debe ser mayor a cero,
            50012 El canal no es válido, 50013 Una forma de pago no puede
            repetirse, 50014 Uno de los libros no tiene precio de venta,
            50015 El monto de cada pago debe ser mayor a cero
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_venta
    @empleado_id INT,
    @sucursal_id INT,
    @cliente_id INT = NULL,
    @detalle NVARCHAR(MAX),
    @pagos NVARCHAR(MAX),
    @canal NVARCHAR(1) = N'T'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @ahora DATETIME2(0) = CAST(GETDATE() AS DATETIME2(0));
    DECLARE @factura_id INT;
    DECLARE @subtotal DECIMAL(10,2);
    DECLARE @descuento_total DECIMAL(10,2);
    DECLARE @impuesto_total DECIMAL(10,2);
    DECLARE @total DECIMAL(10,2);
    DECLARE @suma_pagos DECIMAL(10,2);
    DECLARE @filas INT;

    DECLARE @lineas TABLE (
        linea INT IDENTITY(1,1) PRIMARY KEY,
        libro_id INT NULL,
        cantidad INT NULL,
        descuento_id INT NULL,
        impuesto_id INT NULL,
        precio_unitario DECIMAL(10,2) NULL,
        descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
        monto_impuesto DECIMAL(10,2) NOT NULL DEFAULT 0
    );
    DECLARE @pagos_t TABLE (forma_pago_id INT NULL, monto DECIMAL(10,2) NULL, referencia NVARCHAR(80) NULL);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50001, N'El empleado no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.sucursal s WHERE s.id = @sucursal_id)
        THROW 50002, N'La sucursal no existe.', 1;

    IF @cliente_id IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.cliente c WHERE c.id = @cliente_id)
        THROW 50003, N'El cliente no existe.', 1;

    IF @canal IS NULL OR @canal NOT IN (N'T', N'L')
        THROW 50012, N'El canal no es válido; use T o L.', 1;

    IF @detalle IS NULL OR ISJSON(@detalle) = 0 OR @pagos IS NULL OR ISJSON(@pagos) = 0
        THROW 50004, N'Debe indicar al menos un libro y una forma de pago.', 1;

    INSERT INTO @lineas (libro_id, cantidad, descuento_id, impuesto_id)
    SELECT j.libro_id, j.cantidad, j.descuento_id, j.impuesto_id
    FROM OPENJSON(@detalle)
         WITH (libro_id INT '$.libro_id',
               cantidad INT '$.cantidad',
               descuento_id INT '$.descuento_id',
               impuesto_id INT '$.impuesto_id') j;

    INSERT INTO @pagos_t (forma_pago_id, monto, referencia)
    SELECT j.forma_pago_id, j.monto, j.referencia
    FROM OPENJSON(@pagos)
         WITH (forma_pago_id INT '$.forma_pago_id',
               monto DECIMAL(10,2) '$.monto',
               referencia NVARCHAR(80) '$.referencia') j;

    IF NOT EXISTS (SELECT 1 FROM @lineas) OR NOT EXISTS (SELECT 1 FROM @pagos_t)
        THROW 50004, N'Debe indicar al menos un libro y una forma de pago.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l WHERE l.cantidad IS NULL OR l.cantidad <= 0)
        THROW 50011, N'La cantidad de cada libro debe ser mayor a cero.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.libro_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.libro b WHERE b.id = l.libro_id))
        THROW 50005, N'Uno de los libros no existe.', 1;

    UPDATE l
    SET precio_unitario = b.precio_venta
    FROM @lineas l
    INNER JOIN dbo.libro b ON b.id = l.libro_id;

    IF EXISTS (SELECT 1 FROM @lineas l WHERE l.precio_unitario IS NULL)
        THROW 50014, N'Uno de los libros no tiene precio de venta.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.descuento_id IS NOT NULL
                 AND NOT EXISTS (SELECT 1 FROM dbo.descuento d
                                 WHERE d.id = l.descuento_id
                                   AND d.estado = 1
                                   AND d.fecha_inicio <= @hoy
                                   AND (d.fecha_fin IS NULL OR d.fecha_fin >= @hoy)))
        THROW 50008, N'El descuento no existe, no está activo o no está vigente.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.impuesto_id IS NOT NULL
                 AND NOT EXISTS (SELECT 1 FROM dbo.impuesto i
                                 WHERE i.id = l.impuesto_id
                                   AND i.estado = 1
                                   AND i.fecha_inicio <= @hoy
                                   AND (i.fecha_fin IS NULL OR i.fecha_fin >= @hoy)))
        THROW 50009, N'El impuesto no existe o no está vigente.', 1;

    IF EXISTS (SELECT 1
               FROM (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t
               WHERE ISNULL((SELECT i.cantidad_disponible
                             FROM dbo.inventariosucursal i
                             WHERE i.sucursal_id = @sucursal_id AND i.libro_id = t.libro_id), 0) < t.pedido)
        THROW 50006, N'No hay existencias suficientes en la sucursal.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t p
               WHERE p.forma_pago_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.formapago f WHERE f.id = p.forma_pago_id))
        THROW 50010, N'La forma de pago no existe.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t p WHERE p.monto IS NULL OR p.monto <= 0)
        THROW 50015, N'El monto de cada pago debe ser mayor a cero.', 1;

    IF EXISTS (SELECT 1 FROM @pagos_t GROUP BY forma_pago_id HAVING COUNT(*) > 1)
        THROW 50013, N'Una forma de pago no puede repetirse.', 1;

    -- Descuento por línea: PORCENTAJE o MONTO_FIJO por unidad, sin pasar del precio
    UPDATE l
    SET descuento = CAST(CASE WHEN x.du > l.precio_unitario THEN l.precio_unitario ELSE x.du END
                         * l.cantidad AS DECIMAL(10,2))
    FROM @lineas l
    INNER JOIN dbo.descuento d ON d.id = l.descuento_id
    CROSS APPLY (SELECT CASE WHEN d.tipo_descuento = N'PORCENTAJE'
                             THEN ROUND(l.precio_unitario * d.valor / 100.0, 2)
                             ELSE d.valor END AS du) x;

    -- Impuesto por línea sobre (precio x cantidad - descuento)
    UPDATE l
    SET monto_impuesto = CAST(ROUND((l.precio_unitario * l.cantidad - l.descuento) * i.porcentaje / 100.0, 2)
                              AS DECIMAL(10,2))
    FROM @lineas l
    INNER JOIN dbo.impuesto i ON i.id = l.impuesto_id;

    SELECT @subtotal = SUM(precio_unitario * cantidad),
           @descuento_total = SUM(descuento),
           @impuesto_total = SUM(monto_impuesto)
    FROM @lineas;

    SET @total = @subtotal - @descuento_total + @impuesto_total;

    SELECT @suma_pagos = SUM(monto) FROM @pagos_t;
    IF @suma_pagos <> @total
        THROW 50007, N'La suma de los pagos no coincide con el total.', 1;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.factura (fecha, cliente_id, empleado_id, canal)
            VALUES (@ahora, @cliente_id, @empleado_id, @canal);
            SET @factura_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detallefactura (factura_id, libro_id, cantidad, precio_unitario, descuento, descuento_id, impuesto_id, monto_impuesto)
            SELECT @factura_id, l.libro_id, l.cantidad, l.precio_unitario, l.descuento, l.descuento_id, l.impuesto_id, l.monto_impuesto
            FROM @lineas l;

            INSERT INTO dbo.facturaformapago (factura_id, forma_pago_id, monto, referencia)
            SELECT @factura_id, p.forma_pago_id, p.monto, p.referencia
            FROM @pagos_t p;

            -- Inventario: solo descuenta si todavía alcanzan las existencias
            UPDATE i
            SET cantidad_disponible = i.cantidad_disponible - t.pedido
            FROM dbo.inventariosucursal i
            INNER JOIN (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t
                    ON t.libro_id = i.libro_id
            WHERE i.sucursal_id = @sucursal_id
              AND i.cantidad_disponible >= t.pedido;
            SET @filas = @@ROWCOUNT;

            IF @filas <> (SELECT COUNT(DISTINCT libro_id) FROM @lineas)
                THROW 50006, N'No hay existencias suficientes en la sucursal.', 1;

            INSERT INTO dbo.movimientoinventario (sucursal_id, ejemplar_id, empleado_id, tipo_movimiento, cantidad, observacion)
            SELECT @sucursal_id, NULL, @empleado_id, N'SALIDA', t.pedido,
                   CONCAT(N'Venta factura ', @factura_id, N', libro ', t.libro_id)
            FROM (SELECT libro_id, SUM(cantidad) AS pedido FROM @lineas GROUP BY libro_id) t;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @factura_id AS factura_id,
               @subtotal AS subtotal,
               @descuento_total AS descuento_total,
               @impuesto_total AS impuesto_total,
               @total AS total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO