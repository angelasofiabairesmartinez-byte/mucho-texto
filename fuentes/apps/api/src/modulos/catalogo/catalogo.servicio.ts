// Único lugar del módulo que habla con la base de datos.
import type { BuscarLibros, FiltrosCatalogo, LibroResumen } from '@muchotexto/shared';
import { prisma } from '../../compartido/db.js';

const parecido = (t?: string) => (t ? `%${t}%` : null);

// Búsqueda y filtros del catálogo desde dbo.vw_inventario_libros (RF-01.1, RF-01.2, RF-01.5)
export async function buscarLibros(f: BuscarLibros): Promise<LibroResumen[]> {
  const texto = parecido(f.buscar);
  const categoria = parecido(f.categoria);
  const autor = parecido(f.autor);
  const idioma = f.idioma ?? null;
  const formato = f.formato ?? null;
  const saltar = (f.pagina - 1) * f.porPagina;
  return prisma.$queryRaw<LibroResumen[]>`
    SELECT v.libro_id, v.titulo, v.autores, v.categorias, v.precio_venta, v.isbn,
           v.editorial, v.idioma, v.formato, v.permite_digital, v.ejemplares_disponibles,
           CAST(CASE WHEN EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.libro_id = v.libro_id AND r.tipo = N'T' AND r.estado = 1)
                THEN 1 ELSE 0 END AS BIT) AS tiene_texto,
           CAST(CASE WHEN EXISTS (SELECT 1 FROM dbo.recursodigital r WHERE r.libro_id = v.libro_id AND r.tipo = N'A' AND r.estado = 1)
                THEN 1 ELSE 0 END AS BIT) AS tiene_audio
    FROM dbo.vw_inventario_libros v
    WHERE (${texto} IS NULL OR v.titulo LIKE ${texto} OR v.autores LIKE ${texto} OR v.isbn LIKE ${texto})
      AND (${categoria} IS NULL OR v.categorias LIKE ${categoria})
      AND (${autor} IS NULL OR v.autores LIKE ${autor})
      AND (${idioma} IS NULL OR v.idioma = ${idioma})
      AND (${formato} IS NULL OR v.formato = ${formato})
    ORDER BY CASE WHEN ${f.orden} = N'recientes' THEN v.libro_id END DESC, v.titulo
    OFFSET ${saltar} ROWS FETCH NEXT ${f.porPagina} ROWS ONLY`;
}

// Opciones para los filtros del catálogo (RF-01.2)
export async function filtrosCatalogo(): Promise<FiltrosCatalogo> {
  const [categorias, idiomas, formatos] = await Promise.all([
    prisma.$queryRaw<{ nombre: string }[]>`SELECT c.nombre FROM dbo.categoria c ORDER BY c.nombre`,
    prisma.$queryRaw<{ nombre: string }[]>`SELECT i.nombre FROM dbo.idioma i ORDER BY i.nombre`,
    prisma.$queryRaw<{ nombre: string }[]>`SELECT f.nombre FROM dbo.formatolibro f ORDER BY f.nombre`,
  ]);
  return {
    categorias: categorias.map((c) => c.nombre),
    idiomas: idiomas.map((i) => i.nombre),
    formatos: formatos.map((f) => f.nombre),
  };
}
