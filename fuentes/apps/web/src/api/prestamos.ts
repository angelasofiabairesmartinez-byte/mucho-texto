import { useMutation, useQueryClient } from '@tanstack/react-query';
import type { PrestamoRegistrado, RegistrarPrestamo } from '@muchotexto/shared';
import { pedir } from './cliente';

export function useRegistrarPrestamo() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (datos: RegistrarPrestamo) =>
      pedir<PrestamoRegistrado>('/prestamos', { method: 'POST', body: JSON.stringify(datos) }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['prestamos'] }),
  });
}
