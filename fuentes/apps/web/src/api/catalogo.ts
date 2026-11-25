import { useQuery } from '@tanstack/react-query';
import type { LibroResumen } from '@muchotexto/shared';
import { pedir } from './cliente';

export function useLibros(buscar: string) {
  return useQuery({
    queryKey: ['libros', buscar],
    queryFn: () => pedir<LibroResumen[]>(`/libros?${new URLSearchParams(buscar ? { buscar } : {})}`),
  });
}
