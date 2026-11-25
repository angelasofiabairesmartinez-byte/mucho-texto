# Base de datos `biblioteca_libreria`

| Carpeta | Contenido |
| --- | --- |
| `DDL/` | `000_base_de_datos.sql` crea la BD. Luego una tabla por archivo, en orden de dependencias, con sus índices, comentarios y triggers |
| `Vistas/` | Una vista por archivo |
| `Funciones/` | Una función por archivo |
| `Procedimientos/` | Un procedimiento por archivo (plantilla: `_plantilla.sql.txt`) |
| `DML/` | Datos de prueba, una tabla por archivo, en orden de dependencias |
| `pruebas/` | Una prueba por SP o función (plantilla: `_plantilla.test.sql.txt`) |
| `script-completo.sql` | Todo junto, generado con `pnpm db:script`. Es el script de ejecución masiva para SSMS |

Para crear la BD: `docker compose up -d` (o `pnpm db:reiniciar` para recrearla).
En SSMS también se puede abrir `script-completo.sql` y ejecutarlo completo.
