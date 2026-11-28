/* ============================================================
   Procedimiento: dbo.sp_registrar_compra_proveedor
   Autor: Ángel Fabricio          Fecha: 2026-11-27
   Descripción: Registra una compra a un proveedor en una transacción:
                compra, detalle, existencias de la sucursal (suma al
                inventario) y movimiento ENTRADA por cada libro.
   Parámetros: @proveedor_id, @empleado_id, @sucursal_id,
               @numero_factura (opcional), @detalle (JSON, ej.
               '[{"libro_id":3,"cantidad":10,"costo_unitario":120.00}]')
   Devuelve: compra_proveedor_id, total
   Errores: 50001 El proveedor no existe, 50002 El empleado no existe,
            50003 La sucursal no existe, 50004 Debe indicar al menos un
            libro, 50005 Uno de los libros no existe, 50006 La cantidad
            y el costo deben ser mayores a cero
   ============================================================ */
CREATE OR ALTER PROCEDURE dbo.sp_registrar_compra_proveedor
    @proveedor_id INT,
    @empleado_id INT,
    @sucursal_id INT,
    @numero_factura NVARCHAR(40) = NULL,
    @detalle NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @hoy DATE = CAST(GETDATE() AS DATE);
    DECLARE @compra_id INT;
    DECLARE @total DECIMAL(10,2);
    DECLARE @lineas TABLE (libro_id INT NULL, cantidad INT NULL, costo_unitario DECIMAL(10,2) NULL);

    -- 1. Validaciones (antes de escribir nada)
    IF NOT EXISTS (SELECT 1 FROM dbo.proveedor p WHERE p.id = @proveedor_id)
        THROW 50001, N'El proveedor no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.empleado e WHERE e.id = @empleado_id)
        THROW 50002, N'El empleado no existe.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.sucursal s WHERE s.id = @sucursal_id)
        THROW 50003, N'La sucursal no existe.', 1;

    IF @detalle IS NULL OR ISJSON(@detalle) = 0
        THROW 50004, N'Debe indicar al menos un libro.', 1;

    INSERT INTO @lineas (libro_id, cantidad, costo_unitario)
    SELECT j.libro_id, j.cantidad, j.costo_unitario
    FROM OPENJSON(@detalle)
         WITH (libro_id INT '$.libro_id',
               cantidad INT '$.cantidad',
               costo_unitario DECIMAL(10,2) '$.costo_unitario') j;

    IF NOT EXISTS (SELECT 1 FROM @lineas)
        THROW 50004, N'Debe indicar al menos un libro.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.libro_id IS NULL
                  OR NOT EXISTS (SELECT 1 FROM dbo.libro b WHERE b.id = l.libro_id))
        THROW 50005, N'Uno de los libros no existe.', 1;

    IF EXISTS (SELECT 1 FROM @lineas l
               WHERE l.cantidad IS NULL OR l.cantidad <= 0
                  OR l.costo_unitario IS NULL OR l.costo_unitario <= 0)
        THROW 50006, N'La cantidad y el costo deben ser mayores a cero.', 1;

    SELECT @total = SUM(l.cantidad * l.costo_unitario) FROM @lineas l;

    -- 2. Escritura dentro de una transacción
    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO dbo.compraproveedor (fecha_compra, numero_factura, proveedor_id, empleado_id)
            VALUES (@hoy, @numero_factura, @proveedor_id, @empleado_id);
            SET @compra_id = SCOPE_IDENTITY();

            INSERT INTO dbo.detallecompra (compra_proveedor_id, libro_id, cantidad, costo_unitario)
            SELECT @compra_id, l.libro_id, l.cantidad, l.costo_unitario
            FROM @lineas l;

            -- Inventario: suma a la fila existente o crea la del libro en la sucursal
            UPDATE i
            SET cantidad_disponible = i.cantidad_disponible + t.cantidad
            FROM dbo.inventariosucursal i
            INNER JOIN (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t
                    ON t.libro_id = i.libro_id
            WHERE i.sucursal_id = @sucursal_id;

            INSERT INTO dbo.inventariosucursal (sucursal_id, libro_id, cantidad_disponible)
            SELECT @sucursal_id, t.libro_id, t.cantidad
            FROM (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t
            WHERE NOT EXISTS (SELECT 1 FROM dbo.inventariosucursal i
                              WHERE i.sucursal_id = @sucursal_id AND i.libro_id = t.libro_id);

            INSERT INTO dbo.movimientoinventario (sucursal_id, ejemplar_id, empleado_id, tipo_movimiento, cantidad, observacion)
            SELECT @sucursal_id, NULL, @empleado_id, N'ENTRADA', t.cantidad,
                   CONCAT(N'Compra a proveedor ', @compra_id, N', libro ', t.libro_id)
            FROM (SELECT libro_id, SUM(cantidad) AS cantidad FROM @lineas GROUP BY libro_id) t;
        COMMIT TRANSACTION;

        -- 3. Resultado para la API
        SELECT @compra_id AS compra_proveedor_id,
               @total AS total;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO