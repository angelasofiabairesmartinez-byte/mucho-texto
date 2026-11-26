# Contratos de procedimientos y funciones

Cada SP o función se describe aquí **antes** de programarlo, para que la API y las pantallas puedan avanzar con datos de prueba.
Responsable de llenar la tabla: Bloque 1 (Ángel) — **miércoles 25 de noviembre**. Los del módulo digital: Bloque 3.

Formato de cada fila: parámetros con tipo, columnas que devuelve el `SELECT` final, y errores `THROW` con su mensaje.

## Tanda 1 — viernes 27 de noviembre

| Objeto | Parámetros | Devuelve | Errores | RF |
| --- | --- | --- | --- | --- |
| `fn_puede_prestar` | `@cliente_id INT` | `BIT`: 1 si la credencial está ACTIVA y vigente, no hay multas PENDIENTE y el cliente está bajo su límite de préstamos; 0 en otro caso | No aplica (una función no usa THROW) | RF-03.3, RF-14.2 |
| `fn_prestamos_activos_cliente` | `@cliente_id INT` | `INT`: cantidad de préstamos no devueltos (estados 1 Activo, 3 Vencido, 4 Renovado y 8 En mora) | No aplica | RF-01.7, RF-05.1 |
| `fn_calcular_multa` | `@prestamo_id INT`, `@fecha_devolucion DATE` (PENDIENTE DE CONFIRMAR, ver pregunta 4 en el PR) | `DECIMAL(10,2)`: días de atraso × 5.00; 0 si no hay atraso | No aplica | RF-14.7 |
| `fn_ejemplares_disponibles` | `@libro_id INT` | `INT`: cantidad de ejemplares con estado 1 (Disponible) | No aplica | RF-03.2 |
| `sp_registrar_cliente` | `@nombre NVARCHAR(60)`, `@segundo_nombre NVARCHAR(60) = NULL`, `@apellido NVARCHAR(60)`, `@segundo_apellido NVARCHAR(60) = NULL`, `@correo NVARCHAR(120)`, `@genero NCHAR(1) = NULL`, `@fecha_nacimiento DATE = NULL`, `@telefono NVARCHAR(25)`, `@tipo_telefono NVARCHAR(1)`, `@tipo_cliente_id INT`, `@empleado_id INT = NULL` | `cliente_id INT`, `persona_id INT`, `credencial_id INT`, `fecha_vencimiento DATE` (de la credencial) | 50001 El correo ya está registrado · 50002 El tipo de cliente no existe · 50003 El empleado no existe | RF-02.6, RF-16.1 |
| `sp_registrar_prestamo` | `@cliente_id INT`, `@empleado_id INT`, `@ejemplares NVARCHAR(MAX)` (JSON con ids de ejemplar, ej. `'[5,12]'`), `@observacion NVARCHAR(200) = NULL` | `prestamo_id INT`, `fecha_vencimiento DATE` | 50001 El cliente no existe · 50002 La credencial no está activa o está vencida · 50003 El cliente tiene multas pendientes · 50004 El cliente alcanzó su límite de préstamos · 50005 Uno de los ejemplares no está disponible | RF-14.4 |
| `sp_registrar_devolucion` | `@empleado_id INT`, `@ejemplares NVARCHAR(MAX)` (JSON, ej. `'[{"ejemplar_id":5,"condicion_entrega":"Buen estado"}]'`, PENDIENTE DE CONFIRMAR, ver pregunta 6), `@observacion NVARCHAR(200) = NULL` | `devolucion_id INT`, `multa_total DECIMAL(10,2)` (0 si no hubo atraso) | 50001 El empleado no existe · 50002 Debe indicar al menos un ejemplar · 50003 Uno de los ejemplares no tiene un préstamo pendiente de devolución | RF-14.6, RF-14.7, RF-14.8 |
| `sp_crear_reserva` | `@cliente_id INT`, `@libro_id INT` | `reserva_id INT`, `estado NVARCHAR(30)` (siempre PENDIENTE al crearla) | 50001 El cliente no existe · 50002 El libro no existe · 50003 El libro tiene ejemplares disponibles; no se puede reservar | RF-03.5 |
| `sp_registrar_venta` | `@empleado_id INT`, `@sucursal_id INT`, `@cliente_id INT = NULL`, `@detalle NVARCHAR(MAX)` (JSON, ej. `'[{"libro_id":3,"cantidad":2,"descuento_id":null,"impuesto_id":1}]'`), `@pagos NVARCHAR(MAX)` (JSON, ej. `'[{"forma_pago_id":1,"monto":250.00,"referencia":null}]'`) (PENDIENTE DE CONFIRMAR, ver pregunta 8) | `factura_id INT`, `subtotal DECIMAL(10,2)`, `descuento_total DECIMAL(10,2)`, `impuesto_total DECIMAL(10,2)`, `total DECIMAL(10,2)` | 50001 El empleado no existe · 50002 La sucursal no existe · 50003 El cliente no existe · 50004 Debe indicar al menos un libro y una forma de pago · 50005 Uno de los libros no existe · 50006 No hay existencias suficientes en la sucursal · 50007 La suma de los pagos no coincide con el total | RF-04.6, RF-15.5 |
| `sp_registrar_compra_proveedor` | `@proveedor_id INT`, `@empleado_id INT`, `@sucursal_id INT`, `@numero_factura NVARCHAR(40) = NULL`, `@detalle NVARCHAR(MAX)` (JSON, ej. `'[{"libro_id":3,"cantidad":10,"costo_unitario":120.00}]'`) | `compra_proveedor_id INT`, `total DECIMAL(10,2)` | 50001 El proveedor no existe · 50002 El empleado no existe · 50003 La sucursal no existe · 50004 Debe indicar al menos un libro · 50005 Uno de los libros no existe · 50006 La cantidad y el costo deben ser mayores a cero | RF-19.3 |

## Tanda 2 — domingo 29 de noviembre

| Objeto | Parámetros | Devuelve | Errores | RF |
| --- | --- | --- | --- | --- |
| `sp_renovar_prestamo` | `@prestamo_id INT` | `prestamo_id INT`, `fecha_vencimiento DATE` (la nueva), `estado_prestamo_id INT` (4 Renovado) | 50001 El préstamo no existe · 50002 El préstamo ya fue devuelto y no se puede renovar · 50003 El préstamo alcanzó su límite de renovaciones | RF-05.3 |
| `sp_cancelar_reserva` | `@reserva_id INT` | `reserva_id INT`, `estado NVARCHAR(30)` (CANCELADA) | 50001 La reserva no existe · 50002 La reserva ya fue atendida, cancelada o venció y no se puede cancelar | RF-06.4 |
| `sp_registrar_pago_multa` | `@multa_id INT`, `@monto DECIMAL(10,2)`, `@forma_pago_id INT` | `pago_multa_id INT`, `saldo_pendiente DECIMAL(10,2)`, `estado_multa NVARCHAR(20)` (PAGADA si el saldo queda en 0) | 50001 La multa no existe · 50002 La multa ya está pagada · 50003 La forma de pago no existe · 50004 El monto debe ser mayor a cero y no puede superar el saldo pendiente | RF-15.6 |
| `sp_renovar_credencial` | `@cliente_id INT`, `@accion NVARCHAR(20)` (RENOVAR, SUSPENDER o REACTIVAR), `@empleado_id INT = NULL` | `credencial_id INT`, `estado NVARCHAR(20)`, `fecha_vencimiento DATE` | 50001 El cliente no tiene credencial · 50002 La acción no es válida; use RENOVAR, SUSPENDER o REACTIVAR · 50003 La acción no se puede aplicar al estado actual de la credencial | RF-16.5 |
| `sp_registrar_movimiento_inventario` | `@sucursal_id INT`, `@libro_id INT`, `@empleado_id INT`, `@tipo_movimiento NVARCHAR(30)` (ENTRADA, SALIDA, AJUSTE o TRASLADO), `@cantidad INT`, `@ejemplar_id INT = NULL`, `@observacion NVARCHAR(250) = NULL` | `movimiento_id INT`, `cantidad_disponible INT` (existencia resultante en la sucursal) | 50001 La sucursal no existe · 50002 El empleado no existe · 50003 El libro no existe · 50004 El tipo de movimiento no es válido · 50005 La cantidad debe ser mayor a cero · 50006 No hay existencias suficientes para la salida | RF-17.6 |
| `sp_registrar_auditoria` | `@usuario_id INT = NULL`, `@accion NVARCHAR(50)`, `@tabla_afectada NVARCHAR(100)`, `@registro_id NVARCHAR(100) = NULL`, `@detalle NVARCHAR(500) = NULL` | `auditoria_id INT` | 50001 El usuario no existe · 50002 La acción y la tabla afectada son obligatorias | RF-02.4, RF-22.6 |
| `fn_precio_con_descuento` | `@libro_id INT` (PENDIENTE DE CONFIRMAR, ver pregunta 14) | `DECIMAL(10,2)`: precio final del libro aplicando el descuento vigente; el precio sin descuento si no hay ninguno | No aplica | RF-04.2, RF-12.1 |

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