import { Link } from 'react-router';
import type { LibroResumen } from '@muchotexto/shared';
import { Etiqueta } from '../../ui/Etiqueta';
import { Portada } from '../../ui/Portada';
import { dinero, lista } from '../../ui/formato';

// Un libro en el catálogo o en novedades (RF-01.5)
export function TarjetaLibro({ libro }: { libro: LibroResumen }) {
  return (
    <Link to={`/libros/${libro.libro_id}`} className="flex gap-3 rounded-lg border border-stone-200 bg-white p-3 hover:border-stone-400">
      <Portada titulo={libro.titulo} className="h-24 w-16 shrink-0 text-sm" />
      <div className="min-w-0 space-y-1">
        <p className="font-medium leading-snug">{libro.titulo}</p>
        <p className="truncate text-sm text-stone-600">{libro.autores ?? 'Autor desconocido'}</p>
        <p className="text-xs text-stone-500">{lista(libro.categorias).slice(0, 2).join(' · ')}</p>
        <div className="flex flex-wrap items-center gap-1.5">
          <span className="text-sm font-semibold">{dinero(libro.precio_venta)}</span>
          {libro.tiene_texto && <Etiqueta tono="info">Digital</Etiqueta>}
          {libro.tiene_audio && <Etiqueta tono="exito">Audiolibro</Etiqueta>}
        </div>
      </div>
    </Link>
  );
}
