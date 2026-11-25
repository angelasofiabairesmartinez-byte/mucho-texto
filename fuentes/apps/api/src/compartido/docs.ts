// Documentación Swagger generada desde los esquemas Zod.
// Cada módulo llama a documentar(...) junto a su ruta.
import { z } from 'zod';

type Ruta = {
  metodo: 'get' | 'post' | 'put' | 'patch' | 'delete';
  ruta: string; // estilo OpenAPI: /api/prestamos/{id}
  modulo: string;
  resumen: string;
  query?: z.ZodObject;
  cuerpo?: z.ZodType;
  mock?: boolean;
};

const rutas: Ruta[] = [];
export const documentar = (r: Ruta) => rutas.push(r);

export function especificacion() {
  const paths: Record<string, Record<string, unknown>> = {};
  for (const r of rutas) {
    const parametros = r.query
      ? Object.entries(r.query.shape).map(([nombre, esquema]) => ({
          name: nombre,
          in: 'query',
          required: !(esquema as z.ZodType).safeParse(undefined).success,
          schema: z.toJSONSchema(esquema as z.ZodType, { io: 'input', unrepresentable: 'any' }),
        }))
      : [];
    paths[r.ruta] ??= {};
    paths[r.ruta]![r.metodo] = {
      tags: [r.modulo],
      summary: r.mock ? `[MOCK] ${r.resumen}` : r.resumen,
      parameters: parametros,
      ...(r.cuerpo && {
        requestBody: {
          required: true,
          content: { 'application/json': { schema: z.toJSONSchema(r.cuerpo, { io: 'input', unrepresentable: 'any' }) } },
        },
      }),
      responses: { 200: { description: '{ ok: true, data }' }, 400: { description: '{ ok: false, error }' } },
    };
  }
  return { openapi: '3.1.0', info: { title: 'API Mucho Texto', version: '0.1.0' }, paths };
}
