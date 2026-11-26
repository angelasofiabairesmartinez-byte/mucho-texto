// Portada del libro; si no hay imagen, muestra las iniciales del título.
export function Portada({ titulo, ruta, className = '' }: { titulo: string; ruta?: string | null; className?: string }) {
  const iniciales = titulo.split(' ').filter((p) => p.length > 2).slice(0, 2).map((p) => p[0]).join('').toUpperCase();
  return ruta ? (
    <img src={ruta} alt={`Portada de ${titulo}`} className={`rounded-md object-cover ${className}`} />
  ) : (
    <div aria-hidden className={`flex items-center justify-center rounded-md bg-stone-200 font-semibold text-stone-500 ${className}`}>
      {iniciales || '📖'}
    </div>
  );
}
