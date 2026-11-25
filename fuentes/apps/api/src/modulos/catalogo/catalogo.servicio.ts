// Único lugar del módulo que habla con la base de datos.
import type { BuscarLibros, LibroResumen } from '@muchotexto/shared';
import { prisma } from '../../compartido/db.js';

// Lectura desde la vista dbo.vw_inventario_libros (RF-01.1)
export async function buscarLibros(f: BuscarLibros): Promise<LibroResumen[]> {
  const texto = f.buscar ? `%${f.buscar}%` : null;
  const saltar = (f.pagina - 1) * f.porPagina;
  return prisma.$queryRaw<LibroResumen[]>`
    SELECT v.libro_id, v.titulo, v.autores, v.categorias, v.precio_venta, v.isbn,
           v.editorial, v.idioma, v.formato, v.permite_digital, v.ejemplares_disponibles
    FROM dbo.vw_inventario_libros v
    WHERE ${texto} IS NULL
       OR v.titulo LIKE ${texto} OR v.autores LIKE ${texto} OR v.isbn LIKE ${texto}
    ORDER BY v.titulo
    OFFSET ${saltar} ROWS FETCH NEXT ${f.porPagina} ROWS ONLY`;
}
