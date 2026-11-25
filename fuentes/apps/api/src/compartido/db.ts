// Conexión única a SQL Server para toda la API.
import { PrismaMssql } from '@prisma/adapter-mssql';
import { PrismaClient } from '../generated/prisma/client.js';

const adapter = new PrismaMssql({
  server: process.env.DB_HOST ?? 'localhost',
  port: Number(process.env.DB_PORT ?? 1433),
  database: process.env.DB_NAME ?? 'biblioteca_libreria',
  user: process.env.DB_USER ?? 'sa',
  password: process.env.DB_PASSWORD ?? '',
  options: { encrypt: true, trustServerCertificate: true },
});

export const prisma = new PrismaClient({ adapter });
