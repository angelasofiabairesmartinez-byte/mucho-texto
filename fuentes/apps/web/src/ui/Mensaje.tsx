import type { ReactNode } from 'react';

const estilos = {
  error: 'border-red-200 bg-red-50 text-red-800',
  exito: 'border-green-200 bg-green-50 text-green-800',
  info: 'border-stone-200 bg-white text-stone-700',
};

export function Mensaje({ tipo = 'info', children }: { tipo?: keyof typeof estilos; children: ReactNode }) {
  return <div className={`rounded-md border px-4 py-3 text-sm ${estilos[tipo]}`}>{children}</div>;
}
