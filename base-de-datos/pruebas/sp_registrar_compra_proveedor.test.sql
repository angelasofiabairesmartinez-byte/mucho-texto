/* ============================================================
   Prueba: dbo.sp_registrar_compra_proveedor
   Caso 1: una compra válida (5 libros a L 120.00) da total 600.00, crea
           la compra y su detalle, suma 5 al inventario y registra el
           movimiento ENTRADA.
   Casos siguientes: cada error (50001 a 50006) debe lanzarse con su número.
   Todo corre dentro de una transacción que se revierte.
   ============================================================ */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @r TABLE (compra_proveedor_id INT, total DECIMAL(10,2));
DECLARE @proveedor_id INT = (SELECT TOP 1 p.id FROM dbo.proveedor p ORDER BY p.id);
DECLARE @empleado_id INT = (SELECT TOP 1 e.id FROM dbo.empleado e ORDER BY e.id);
DECLARE @sucursal_id INT = (SELECT TOP 1 s.id FROM dbo.sucursal s ORDER BY s.id);
DECLARE @libro_id INT = (SELECT TOP 1 l.id FROM dbo.libro l ORDER BY l.id);
DECLARE @antes INT, @compra_id INT;

IF @proveedor_id IS NULL OR @empleado_id IS NULL OR @sucursal_id IS NULL OR @libro_id IS NULL
    THROW 50982, N'PRUEBA FALLIDA: faltan datos (proveedor, empleado, sucursal o libro).', 1;

BEGIN TRANSACTION;
    SELECT @antes = ISNULL((SELECT i.cantidad_disponible FROM dbo.inventariosucursal i
                            WHERE i.sucursal_id = @sucursal_id AND i.libro_id = @libro_id), 0);

    -- Caso 1: debe funcionar
    DECLARE @det_ok NVARCHAR(MAX) = CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":5,"costo_unitario":120.00}]');

    INSERT INTO @r
    EXEC dbo.sp_registrar_compra_proveedor
        @proveedor_id = @proveedor_id, @empleado_id = @empleado_id, @sucursal_id = @sucursal_id,
        @numero_factura = N'TEST-001', @detalle = @det_ok;

    SELECT @compra_id = compra_proveedor_id FROM @r;

    IF NOT EXISTS (SELECT 1 FROM @r WHERE compra_proveedor_id IS NOT NULL AND total = 600.00)
        THROW 50983, N'PRUEBA FALLIDA: sp_registrar_compra_proveedor debía devolver el id y un total de 600.00.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.compraproveedor WHERE id = @compra_id AND numero_factura = N'TEST-001'
                   AND proveedor_id = @proveedor_id)
        THROW 50984, N'PRUEBA FALLIDA: no se creó la compra.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.detallecompra
                   WHERE compra_proveedor_id = @compra_id AND libro_id = @libro_id
                     AND cantidad = 5 AND costo_unitario = 120.00)
        THROW 50985, N'PRUEBA FALLIDA: el detalle de la compra no quedó con los valores esperados.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.inventariosucursal
                   WHERE sucursal_id = @sucursal_id AND libro_id = @libro_id
                     AND cantidad_disponible = @antes + 5)
        THROW 50986, N'PRUEBA FALLIDA: el inventario debía subir 5 unidades.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.movimientoinventario
                   WHERE sucursal_id = @sucursal_id AND tipo_movimiento = N'ENTRADA' AND cantidad = 5
                     AND observacion LIKE CONCAT(N'Compra a proveedor ', @compra_id, N'%'))
        THROW 50987, N'PRUEBA FALLIDA: no se registró el movimiento ENTRADA.', 1;

    -- Casos de error
    DECLARE @casos TABLE (
        id INT IDENTITY(1,1) PRIMARY KEY,
        descripcion NVARCHAR(80),
        proveedor_id INT, empleado_id INT, sucursal_id INT,
        detalle NVARCHAR(MAX),
        esperado INT
    );

    INSERT INTO @casos (descripcion, proveedor_id, empleado_id, sucursal_id, detalle, esperado) VALUES
      (N'proveedor inexistente', -1,            @empleado_id, @sucursal_id, @det_ok, 50001),
      (N'empleado inexistente',  @proveedor_id, -1,           @sucursal_id, @det_ok, 50002),
      (N'sucursal inexistente',  @proveedor_id, @empleado_id, -1,           @det_ok, 50003),
      (N'sin libros',            @proveedor_id, @empleado_id, @sucursal_id, N'[]',   50004),
      (N'libro inexistente',     @proveedor_id, @empleado_id, @sucursal_id, N'[{"libro_id":-1,"cantidad":1,"costo_unitario":10.00}]', 50005),
      (N'cantidad en cero',      @proveedor_id, @empleado_id, @sucursal_id, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":0,"costo_unitario":10.00}]'), 50006),
      (N'costo en cero',         @proveedor_id, @empleado_id, @sucursal_id, CONCAT(N'[{"libro_id":', @libro_id, N',"cantidad":1,"costo_unitario":0}]'), 50006);

    DECLARE @i INT = 1;
    DECLARE @n INT = (SELECT COUNT(*) FROM @casos);
    DECLARE @c_desc NVARCHAR(80), @c_prov INT, @c_emp INT, @c_suc INT, @c_det NVARCHAR(MAX), @c_esp INT;
    DECLARE @num INT, @msg NVARCHAR(400);

    WHILE @i <= @n
    BEGIN
        SELECT @c_desc = descripcion, @c_prov = proveedor_id, @c_emp = empleado_id,
               @c_suc = sucursal_id, @c_det = detalle, @c_esp = esperado
        FROM @casos WHERE id = @i;

        SET @num = 0;
        BEGIN TRY
            EXEC dbo.sp_registrar_compra_proveedor
                @proveedor_id = @c_prov, @empleado_id = @c_emp, @sucursal_id = @c_suc, @detalle = @c_det;
        END TRY
        BEGIN CATCH
            SET @num = ERROR_NUMBER();
        END CATCH

        IF @num <> @c_esp
        BEGIN
            SET @msg = CONCAT(N'PRUEBA FALLIDA: el caso "', @c_desc, N'" debía dar el error ', @c_esp, N' y dio ', @num, N'.');
            THROW 50988, @msg, 1;
        END

        SET @i += 1;
    END
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

PRINT N'OK sp_registrar_compra_proveedor';