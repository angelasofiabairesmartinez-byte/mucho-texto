CREATE OR ALTER VIEW dbo.vw_reservas_pendientes
AS
SELECT
    r.id                                    AS reserva_id,
    r.cliente_id,
    CONCAT_WS(' ', pe.nombre, pe.segundo_nombre, pe.apellido, pe.segundo_apellido) AS cliente,
    r.libro_id,
    l.titulo,
    r.fecha_reserva,
    r.fecha_vencimiento,
    ROW_NUMBER() OVER (PARTITION BY r.libro_id ORDER BY r.fecha_reserva) AS posicion_fila,
    COUNT(*) OVER (PARTITION BY r.libro_id) AS total_en_fila,
    ISNULL(ed.disponibles, 0)               AS ejemplares_disponibles
FROM dbo.reserva r
INNER JOIN dbo.cliente cl  ON cl.id = r.cliente_id
INNER JOIN dbo.persona pe  ON pe.id = cl.persona_id
INNER JOIN dbo.libro l     ON l.id = r.libro_id
LEFT JOIN (
    SELECT ej.libro_id, COUNT(*) AS disponibles
    FROM dbo.ejemplar ej
    INNER JOIN dbo.estadoejemplar ee ON ee.id = ej.estado_ejemplar_id
    WHERE ee.nombre = N'Disponible'
    GROUP BY ej.libro_id
) ed ON ed.libro_id = r.libro_id
WHERE r.estado = 'PENDIENTE';

GO

EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Reservas pendientes con la posición del cliente en la fila.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_reservas_pendientes';
GO
