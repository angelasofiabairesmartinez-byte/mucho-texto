// Muestra una calificación de 1 a 5, o permite elegirla si recibe onElegir.
export function Estrellas({ valor, onElegir }: { valor: number; onElegir?: (n: number) => void }) {
  return (
    <span className="inline-flex" aria-label={`${valor.toFixed(1)} de 5 estrellas`}>
      {[1, 2, 3, 4, 5].map((n) =>
        onElegir ? (
          <button key={n} type="button" onClick={() => onElegir(n)} aria-label={`${n} estrellas`} className="px-0.5 text-xl leading-none">
            <span className={n <= valor ? 'text-amber-500' : 'text-stone-300'}>★</span>
          </button>
        ) : (
          <span key={n} className={n <= Math.round(valor) ? 'text-amber-500' : 'text-stone-300'}>★</span>
        ),
      )}
    </span>
  );
}
