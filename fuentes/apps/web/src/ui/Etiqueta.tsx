import type { ReactNode } from 'react';

const tonos = {
  neutro: 'bg-stone-100 text-stone-700',
  info: 'bg-sky-100 text-sky-800',
  exito: 'bg-green-100 text-green-800',
  aviso: 'bg-amber-100 text-amber-800',
};

export function Etiqueta({ tono = 'neutro', children }: { tono?: keyof typeof tonos; children: ReactNode }) {
  return <span className={`inline-block rounded-full px-2 py-0.5 text-xs font-medium ${tonos[tono]}`}>{children}</span>;
}
