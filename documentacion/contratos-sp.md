# Contratos de procedimientos y funciones

Cada SP o función se describe aquí **antes** de programarlo, para que la API y las pantallas puedan avanzar con datos de prueba.
Responsable de llenar la tabla: Bloque 1 (Ángel) — **miércoles 25 de noviembre**. Los del módulo digital: Bloque 3.

## Reglas de negocio acordadas

| Regla | Valor | Decidido |
| --- | --- | --- |
| Duración de un préstamo | 15 días desde la fecha de préstamo | 2026-11-25 |
| Multa por atraso | L 5.00 por cada día de atraso, por ejemplar | 2026-11-25 |

Formato de cada fila: parámetros con tipo, columnas que devuelve el `SELECT` final, y errores `THROW` con su mensaje.

## Tanda 1 — viernes 27 de noviembre

| Objeto | Parámetros | Devuelve | Errores | RF |
| --- | --- | --- | --- | --- |
| `fn_puede_prestar` | | | | RF-03.3, RF-14.2 |
| `fn_prestamos_activos_cliente` | | | | RF-01.7, RF-05.1 |
| `fn_calcular_multa` | | | | RF-14.7 |
| `fn_ejemplares_disponibles` | | | | RF-03.2 |
| `sp_registrar_cliente` | | | | RF-02.6, RF-16.1 |
| `sp_registrar_prestamo` | | | | RF-14.4 |
| `sp_registrar_devolucion` | | | | RF-14.6, RF-14.7, RF-14.8 |
| `sp_crear_reserva` | | | | RF-03.5 |
| `sp_registrar_venta` | | | | RF-04.6, RF-15.5 |
| `sp_registrar_compra_proveedor` | | | | RF-19.3 |

## Tanda 2 — domingo 29 de noviembre

| Objeto | Parámetros | Devuelve | Errores | RF |
| --- | --- | --- | --- | --- |
| `sp_renovar_prestamo` | | | | RF-05.3 |
| `sp_cancelar_reserva` | | | | RF-06.4 |
| `sp_registrar_pago_multa` | | | | RF-15.6 |
| `sp_renovar_credencial` | | | | RF-16.5 |
| `sp_registrar_movimiento_inventario` | | | | RF-17.6 |
| `sp_registrar_auditoria` | | | | RF-02.4, RF-22.6 |
| `fn_precio_con_descuento` | | | | RF-04.2, RF-12.1 |

## Biblioteca digital (Bloque 3) — viernes 27 de noviembre

| Objeto | Parámetros | Devuelve | Errores | RF |
| --- | --- | --- | --- | --- |
| `sp_guardar_progreso_lectura` | | | | RF-10.2, RF-11.6 |
| `sp_registrar_audiolibro` | | | | RF-20.3 |
| `sp_retirar_recurso_digital` | | | | RF-20.5 |
| `fn_calcular_porcentaje_progreso` | | | | RF-10.2 |

## Ya existentes (segunda entrega)

| Objeto | Parámetros | Devuelve |
| --- | --- | --- |
| `fn_historial_cliente` | `@cliente_id INT` | Filas de `vw_historial_cliente` de ese cliente |
