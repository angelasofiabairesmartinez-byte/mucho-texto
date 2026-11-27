/* ============================================================
   Función: dbo.fn_calcular_multa
   Autor: Ángel Fabricio          Fecha: 2026-11-26
   Descripción: Calcula la multa de un ejemplar prestado: días de atraso
                (fecha de devolución menos vencimiento del préstamo) x L 5.00.
   Parámetros: @detalle_prestamo_id (ejemplar dentro del préstamo),
               @fecha_devolucion (fecha en que se devuelve)
   Devuelve: DECIMAL(10,2), la multa; 0 si no hay atraso o el detalle no existe
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_calcular_multa (@detalle_prestamo_id INT, @fecha_devolucion DATE)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @dias_atraso INT;

    SELECT @dias_atraso = DATEDIFF(DAY, p.fecha_vencimiento, @fecha_devolucion)
    FROM dbo.detalleprestamo d
    INNER JOIN dbo.prestamo p ON p.id = d.prestamo_id
    WHERE d.id = @detalle_prestamo_id;

    IF @dias_atraso IS NULL OR @dias_atraso <= 0
        RETURN 0.00;

    RETURN CAST(@dias_atraso * 5.00 AS DECIMAL(10,2));
END
GO