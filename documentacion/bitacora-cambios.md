# Bitácora de cambios — Tercera entrega

Todo cambio respecto a la segunda entrega se anota aquí con fecha, responsable, qué cambió y por qué.

| Fecha | Responsable | Objeto | Cambio | Motivo |
| --- | --- | --- | --- | --- |
| 2026-11-24 | Equipo | Script de la segunda entrega | Se separó `Script_MuchoTexto_SQLServer.sql` en archivos por objeto: `DDL/` (tabla + índices + comentarios + trigger), `Vistas/`, `Funciones/` y `DML/`. El contenido de cada objeto no cambió. | Estructura de carpetas pedida en la tercera entrega |
| 2026-11-24 | Equipo | `script-completo.sql` | Se genera automáticamente uniendo los archivos en orden DDL → Vistas → Funciones → Procedimientos → DML. | Mantener la ejecución masiva en un solo script |
| 2026-11-24 | Equipo | Orden de los inserts | Los inserts se ejecutan después de vistas, funciones y procedimientos (antes iban después de las tablas). | Los SP se crean antes de cargar datos; las vistas no dependen de datos |
