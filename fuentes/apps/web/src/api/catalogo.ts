import { useQuery } from '@tanstack/react-query';
import type { BuscarLibros, FiltrosCatalogo, LibroResumen } from '@muchotexto/shared';
import { pedir } from './cliente';

export type FiltrosBusqueda = Partial<Omit<BuscarLibros, 'pagina' | 'porPagina'>> & { porPagina?: number };

function aQuery(f: FiltrosBusqueda) {
  const p = new URLSearchParams();
  for (const [clave, valor] of Object.entries(f)) {
    if (valor !== undefined && valor !== '') p.set(clave, String(valor));
  }
  return p.toString();
}

// RF-01.1, RF-01.2, RF-01.5 · ruta real
export function useLibros(filtros: FiltrosBusqueda, activo = true) {
  return useQuery({
    queryKey: ['libros', filtros],
    queryFn: () => pedir<LibroResumen[]>(`/libros?${aQuery(filtros)}`),
    enabled: activo,
    placeholderData: (anterior) => anterior,
  });
}

// RF-01.2 · ruta real
export function useFiltrosCatalogo() {
  return useQuery({
    queryKey: ['catalogos', 'filtros'],
    queryFn: () => pedir<FiltrosCatalogo>('/catalogos/filtros'),
    staleTime: 10 * 60_000,
  });
}
