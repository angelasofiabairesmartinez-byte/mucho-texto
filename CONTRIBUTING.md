# Cómo trabajamos en Mucho Texto

Todos pueden subir su propia rama. A `develop` y `main` solo entra código con **la revisión automática (CI) en verde** y **la aprobación de 2 integrantes distintos al autor**. Nadie, ni la dueña del repo, puede saltarse esa regla.

## Flujo de cada tarea

1. Actualizar: `git switch develop` y `git pull`.
2. Crear tu rama: `git switch -c feat/<bloque>-<tarea>`
   Ejemplos: `feat/bd-sp-registrar-prestamo`, `feat/api-prestamos`, `feat/web-14-prestamos`.
3. Commits pequeños con este formato: `feat(bd): sp_registrar_prestamo`. Tipos: `feat`, `fix`, `test`, `docs`, `chore`.
4. Antes de subir: `pnpm verificar`. Si falla, no se sube.
5. Subir: `git push -u origin feat/<bloque>-<tarea>`.
6. Abrir el PR hacia **develop** y llenar la plantilla (RF que cubre, cómo probarlo, capturas).
7. Si el CI sale en rojo, corriges en la misma rama y vuelves a subir.
8. Dos compañeros revisan: bajan la rama, la prueban y aprueban o comentan. Si subes algo nuevo, las aprobaciones se reinician.
9. Merge tipo *squash*. La rama se borra sola.
10. `develop` pasa a `main` solo en los hitos (demo del 30 nov y entrega).

## Reglas de oro

- Nunca trabajar directo en `develop` ni en `main`.
- Un PR = una tarea, menos de 400 líneas.
- Nunca subir `.env`, contraseñas ni llaves. Solo `.env.example`.
- No tocar archivos de otro bloque sin avisar en el grupo.
- Revisar en serio: aprobar sin probar no cuenta.
- Se puede usar IA, pero el código debe correr y quien lo sube debe poder explicarlo.
- Si algo se rompe: avisar en el grupo. Nunca `git push --force`; se revierte el PR desde GitHub.
- Revisen los PR de los demás el mismo día que se abren para no frenar a nadie.

## Base de datos (Bloques 1 y 3)

- Un objeto por archivo, con el nombre del objeto: `Procedimientos/sp_registrar_prestamo.sql`. Plantilla: `Procedimientos/_plantilla.sql.txt`.
- Orden de ejecución: DDL → Vistas → Funciones → Procedimientos → DML, y dentro de cada carpeta en orden alfabético. Las vistas no usan funciones.
- Las vistas llevan prefijo numérico (`07_vw_...`) porque unas usan otras: una vista nueva va con el número siguiente. Si una función usa otra función, la que se usa debe quedar antes en orden alfabético.
- Cada SP o función lleva su prueba en `pruebas/<nombre>.test.sql` (plantilla: `pruebas/_plantilla.test.sql.txt`) con un caso que funciona y uno que debe fallar.
- Antes de programar un SP, su contrato va en `documentacion/contratos-sp.md`.
- Validaciones con `THROW 50001–50099` y mensaje en español: la API se lo muestra tal cual al usuario.
- Transacción siempre que el SP escriba en más de una tabla.
- Estilo: `SELECT ... FROM tabla t` en una línea, `INNER JOIN ... ON a = b` debajo con sangría, alias cortos.
- Prohibido: modificar tablas existentes, `DROP`, `DELETE`/`UPDATE` sin `WHERE`, ENUM. Un cambio de tabla se propone con un issue "Cambio en una tabla", se decide en equipo y va a `bitacora-cambios.md`.
- Después de tocar cualquier `.sql`: `pnpm db:script`.

## API (Bloque 2)

- Un módulo por tema en `fuentes/apps/api/src/modulos/<tema>/` con `<tema>.rutas.ts` (rol + Zod + servicio) y `<tema>.servicio.ts` (único lugar con SQL). Ejemplos: `catalogo` (vista real) y `prestamos` (mock).
- Esquemas Zod en `fuentes/packages/shared/src/`; los usan la API y los formularios.
- Solo `prisma.$queryRaw` con plantilla. Prohibido `$queryRawUnsafe` y concatenar SQL.
- Lecturas desde vistas, escrituras con SP. Mientras el SP no existe, la ruta devuelve datos de prueba y lleva `// MOCK`.
- Cada ruta se documenta con `documentar(...)` y aparece en `/api/docs`.
- `prisma db pull` solo después de un cambio de DDL aprobado. Nunca `prisma migrate`.

## Pantallas (Bloques 3 y 4)

- Una carpeta por pantalla con su número de mockup: `src/pantallas/14-prestamos-devoluciones/`. Ejemplos: 01 (consulta) y 14 (formulario).
- Al terminar una pantalla, se registra su componente en `src/layout/menu.tsx`.
- Datos solo con los hooks de `src/api/` (TanStack Query). Nada de `fetch` suelto.
- Formularios con React Hook Form + el esquema Zod de `packages/shared`.
- Solo componentes de `src/ui/` y clases de Tailwind. Nada de librerías nuevas sin acuerdo del equipo. El diseño final se hace el 2–3 de diciembre.
- El PR lleva captura en móvil y escritorio.
