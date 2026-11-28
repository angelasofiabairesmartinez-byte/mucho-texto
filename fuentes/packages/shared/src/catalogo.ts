import { z } from 'zod';

// GET /api/libros  · Pantalla 01 (RF-01.1 búsqueda, RF-01.2 filtros, RF-01.5 novedades)
export const BuscarLibros = z.object({
  buscar: z.string().trim().max(100).optional(),
  categoria: z.string().trim().max(80).optional(),
  autor: z.string().trim().max(100).optional(),
  idioma: z.string().trim().max(50).optional(),
  formato: z.string().trim().max(40).optional(),
  orden: z.enum(['titulo', 'recientes']).default('titulo'),
  pagina: z.coerce.number().int().min(1).default(1),
  porPagina: z.coerce.number().int().min(1).max(50).default(20),
});
export type BuscarLibros = z.infer<typeof BuscarLibros>;

// Una fila de dbo.vw_inventario_libros con lo que usa el catálogo.
// Los DECIMAL pueden llegar como texto desde SQL Server: usar Number() al mostrarlos.
export type LibroResumen = {
  libro_id: number;
  titulo: string;
  autores: string | null;
  categorias: string | null;
  precio_venta: number | string | null;
  isbn: string | null;
  editorial: string | null;
  idioma: string | null;
  formato: string | null;
  permite_digital: number;
  ejemplares_disponibles: number;
  tiene_texto: boolean;
  tiene_audio: boolean;
};

// GET /api/catalogos/filtros · opciones de los filtros del catálogo (RF-01.2)
export type FiltrosCatalogo = {
  categorias: string[];
  idiomas: string[];
  formatos: string[];
};
