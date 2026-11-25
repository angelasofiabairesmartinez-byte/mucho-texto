# Mucho Texto

Aplicación de la biblioteca y librería **Mucho Texto**, sobre la base de datos `biblioteca_libreria` (SQL Server).
Proyecto final de Bases de Datos I · UNAH-Comayagua · Entrega: domingo 6 de diciembre de 2026.

| Bloque | Responsable | Qué hace |
| --- | --- | --- |
| 1 · Base de datos | Ángel Fabricio | SP, funciones, pruebas SQL, datos, diccionario, bitácora |
| 2 · API y seguridad | José Andrez | API Express + Zod + Prisma, login y roles, Docker y monitoreo, manual técnico |
| 3 · Cliente y biblioteca digital | Ángela | Pantallas del cliente, lector, audiolibros con IA, reportes, modelos, prototipos |
| 4 · Mostrador y administración | Gonzalo | Pantallas de empleado y administrador, QR, manual de usuario, video |

Las reglas de trabajo están en [CONTRIBUTING.md](CONTRIBUTING.md). Léelo antes de tu primer PR.

## Levantar el proyecto

Necesitas Git, Node.js 22, Docker Desktop y pnpm (`corepack enable`). SQL Server ocupa unos 2 GB de RAM.

```bash
git clone https://github.com/angelasofiabairesmartinez-byte/mucho-texto.git
cd mucho-texto
cp .env.example .env
docker compose up -d     # SQL Server + crea la BD con todos los datos (tarda ~1 min la primera vez)
pnpm install
pnpm dev                 # API: http://localhost:3000/api/docs · App: http://localhost:5173
```

Si `pnpm dev` dice que no encuentra el cliente de Prisma, corre una vez `pnpm --filter @muchotexto/api build`.

## Comandos

| Comando | Para qué |
| --- | --- |
| `pnpm dev` | API y app en modo desarrollo |
| `pnpm verificar` | Lo mismo que revisa el CI: script completo al día, tipos y compilación. Córrelo antes de cada PR |
| `pnpm db:reiniciar` | Borra y vuelve a crear la BD desde los archivos de `base-de-datos/` |
| `pnpm db:pruebas` | Crea la BD y corre las pruebas de `base-de-datos/pruebas/` |
| `pnpm db:script` | Regenera `base-de-datos/script-completo.sql` (después de tocar cualquier `.sql`) |

## Estructura

```text
base-de-datos/   DDL/ Vistas/ Funciones/ Procedimientos/ DML/ pruebas/ + script-completo.sql
documentacion/   contratos-sp.md, bitacora-cambios.md, manuales
fuentes/
  apps/api/        API Express (módulos en src/modulos/)
  apps/web/        App React (pantallas en src/pantallas/, numeradas como en los mockups)
  packages/shared/ Esquemas Zod que usan la API y la app
scripts/         utilidades (generar script completo, datos con Faker)
```

## Usuarios de prueba

Las contraseñas de la base de la segunda entrega son marcadores (`TEST$...`). El Bloque 2 las reemplaza por hashes reales al conectar el login y las anota aquí.
