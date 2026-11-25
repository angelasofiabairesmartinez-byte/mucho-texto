import express from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import { prisma } from './compartido/db.js';
import { especificacion } from './compartido/docs.js';
import { manejarErrores, noEncontrado } from './compartido/errores.js';
import { rutasCatalogo } from './modulos/catalogo/catalogo.rutas.js';
import { rutasPrestamos } from './modulos/prestamos/prestamos.rutas.js';

export const app = express();
app.use(cors({ origin: process.env.WEB_URL ?? 'http://localhost:5173', credentials: true }));
app.use(express.json({ limit: '1mb' }));

// Estado del servicio (lo usa Uptime Kuma)
app.get('/api/salud', async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1 AS ok`;
    res.json({ ok: true, data: { api: 'ok', db: 'ok' } });
  } catch {
    res.status(503).json({ ok: false, error: { codigo: 'DB_CAIDA', mensaje: 'Sin conexión a la base de datos' } });
  }
});

// Módulos: agregar aquí cada nuevo Router
app.use('/api', rutasCatalogo);
app.use('/api', rutasPrestamos);

// Swagger en /api/docs (después de registrar los módulos)
app.get('/api/docs.json', (_req, res) => res.json(especificacion()));
app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(undefined, { swaggerOptions: { url: '/api/docs.json' } }));

app.use(noEncontrado);
app.use(manejarErrores);
