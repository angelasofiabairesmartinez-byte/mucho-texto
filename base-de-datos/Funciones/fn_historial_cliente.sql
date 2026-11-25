-- Función: historial de un cliente específico
CREATE OR ALTER FUNCTION dbo.fn_historial_cliente (@cliente_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM dbo.vw_historial_cliente WHERE cliente_id = @cliente_id
);
GO
