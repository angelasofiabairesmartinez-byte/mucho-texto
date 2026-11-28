import type { ReactNode } from 'react';

export function Tarjeta({ titulo, accion, children, className = '' }: { titulo?: string; accion?: ReactNode; children: ReactNode; className?: string }) {
  return (
    <section className={`rounded-lg border border-stone-200 bg-white p-4 ${className}`}>
      {(titulo || accion) && (
        <header className="mb-3 flex items-center justify-between gap-2">
          {titulo && <h2 className="font-semibold">{titulo}</h2>}
          {accion}
        </header>
      )}
      {children}
    </section>
  );
}
