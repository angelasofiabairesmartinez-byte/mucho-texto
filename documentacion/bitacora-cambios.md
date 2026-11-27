# Bitácora de cambios — Tercera entrega

Todo cambio respecto a la segunda entrega se anota aquí con fecha, responsable, qué cambió y por qué.

| Fecha | Responsable | Objeto | Cambio | Motivo |
| --- | --- | --- | --- | --- |
| 2026-11-24 | Equipo | Script de la segunda entrega | Se separó `Script_MuchoTexto_SQLServer.sql` en archivos por objeto: `DDL/` (tabla + índices + comentarios + trigger), `Vistas/`, `Funciones/` y `DML/`. El contenido de cada objeto no cambió. | Estructura de carpetas pedida en la tercera entrega |
| 2026-11-24 | Equipo | `script-completo.sql` | Se genera automáticamente uniendo los archivos en orden DDL → Vistas → Funciones → Procedimientos → DML. | Mantener la ejecución masiva en un solo script |
| 2026-11-24 | Equipo | Orden de los inserts | Los inserts se ejecutan después de vistas, funciones y procedimientos (antes iban después de las tablas). | Los SP se crean antes de cargar datos; las vistas no dependen de datos |
| 2026-11-27 | Ángela Baires | `reserva` | Columnas nuevas: `tipo` (R: Reserva; S: Solicitud de préstamo, por defecto R), `sucursal_id`, `ejemplar_id` y `prestamo_id`, con sus llaves foráneas. Las reservas existentes quedan como tipo R. | La app permite solicitar un préstamo en línea (RF-03.3). Una solicitud es una reserva de un ejemplar disponible que el cliente retira en una sucursal, así que se guarda en la misma tabla en lugar de crear otra |
| 2026-11-27 | Ángela Baires | `descuento` | Columnas nuevas: `tipo_cliente_id` y `categoria_id` (ambas opcionales). Si las dos son NULL el descuento es general. Se asignaron en los datos de prueba: Estudiante, Adulto mayor y Empresa por tipo de cliente; Ficción, Historia y Educación por categoría. | Saber qué descuentos le corresponden a cada cliente en el carrito en línea (RF-04.2, RF-12.1) sin agregar tablas |
