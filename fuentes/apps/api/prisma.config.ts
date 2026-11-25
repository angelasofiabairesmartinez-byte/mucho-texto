// Configuración de Prisma 7. La URL sale del .env de la raíz.
import { config } from 'dotenv';
import { defineConfig } from 'prisma/config';

config({ path: '../../../.env' });

export default defineConfig({
  schema: 'prisma/schema.prisma',
  datasource: {
    url:
      process.env.DATABASE_URL ??
      'sqlserver://localhost:1433;database=biblioteca_libreria;user=sa;password=x;trustServerCertificate=true',
  },
});
