import { z } from 'zod';

// GET /api/libros?buscar=...&pagina=1
export const BuscarLibros = z.object({
  buscar: z.string().trim().max(100).optional(),
  pagina: z.coerce.number().int().min(1).default(1),
  porPagina: z.coerce.number().int().min(1).max(50).default(20),
});
export type BuscarLibros = z.infer<typeof BuscarLibros>;

// Una fila de dbo.vw_inventario_libros (solo las columnas que usa la app)
export const LibroResumen = z.object({
  libro_id: z.number(),
  titulo: z.string(),
});
export type LibroResumen = z.infer<typeof LibroResumen> & Record<string, unknown>;
