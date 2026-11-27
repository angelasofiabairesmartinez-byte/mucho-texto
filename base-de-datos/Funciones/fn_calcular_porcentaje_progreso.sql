/* ============================================================
   Función: dbo.fn_calcular_porcentaje_progreso
   Autor: Ángela Baires          Fecha: 2026-11-27
   Descripción: Calcula qué porcentaje de un recurso digital lleva el
                cliente: página actual entre total de páginas (texto) o
                segundo actual entre duración (audiolibro), por 100.
   Parámetros: @recurso_digital_id (libro digital o audiolibro),
               @posicion (página o segundo donde va el cliente)
   Devuelve: DECIMAL(5,2) entre 0 y 100; 0 si el recurso no existe
             o no tiene total de páginas o duración
   ============================================================ */
CREATE OR ALTER FUNCTION dbo.fn_calcular_porcentaje_progreso (@recurso_digital_id INT, @posicion INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total INT;

    SELECT @total = CASE r.tipo WHEN N'T' THEN r.total_paginas ELSE r.duracion_segundos END
    FROM dbo.recursodigital r
    WHERE r.id = @recurso_digital_id;

    IF @total IS NULL OR @total <= 0 OR @posicion IS NULL OR @posicion <= 0
        RETURN 0.00;

    IF @posicion >= @total
        RETURN 100.00;

    RETURN CAST(@posicion * 100.0 / @total AS DECIMAL(5,2));
END
GO
