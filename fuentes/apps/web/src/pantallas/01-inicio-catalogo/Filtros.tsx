import { useFiltrosCatalogo, type FiltrosBusqueda } from '../../api/catalogo';

type Props = { filtros: FiltrosBusqueda; cambiar: (f: FiltrosBusqueda) => void };

const selector = 'w-full rounded-md border border-stone-300 bg-white px-2 py-1.5 text-sm';

// RF-01.2 · Botones rápidos por categoría + panel de autor, idioma y formato. Se combinan.
export function Filtros({ filtros, cambiar }: Props) {
  const opciones = useFiltrosCatalogo();
  const hayFiltros = Boolean(filtros.categoria || filtros.autor || filtros.idioma || filtros.formato);
  const poner = (clave: keyof FiltrosBusqueda, valor: string) => cambiar({ ...filtros, [clave]: valor || undefined });

  return (
    <div className="space-y-3">
      <div className="flex gap-2 overflow-x-auto pb-1">
        {opciones.data?.categorias.map((c) => {
          const activa = filtros.categoria === c;
          return (
            <button
              key={c}
              type="button"
              onClick={() => poner('categoria', activa ? '' : c)}
              aria-pressed={activa}
              className={`shrink-0 rounded-full border px-3 py-1 text-sm ${activa ? 'border-stone-900 bg-stone-900 text-white' : 'border-stone-300 bg-white'}`}
            >
              {c}
            </button>
          );
        })}
      </div>

      <details className="rounded-md border border-stone-200 bg-white p-3" open={hayFiltros}>
        <summary className="cursor-pointer text-sm font-medium">Más filtros</summary>
        <div className="mt-3 grid gap-3 sm:grid-cols-3">
          <label className="space-y-1 text-sm">
            <span>Autor</span>
            <input className={selector} value={filtros.autor ?? ''} onChange={(e) => poner('autor', e.target.value)} placeholder="Nombre del autor" />
          </label>
          <label className="space-y-1 text-sm">
            <span>Idioma</span>
            <select className={selector} value={filtros.idioma ?? ''} onChange={(e) => poner('idioma', e.target.value)}>
              <option value="">Todos</option>
              {opciones.data?.idiomas.map((i) => <option key={i}>{i}</option>)}
            </select>
          </label>
          <label className="space-y-1 text-sm">
            <span>Formato</span>
            <select className={selector} value={filtros.formato ?? ''} onChange={(e) => poner('formato', e.target.value)}>
              <option value="">Todos</option>
              {opciones.data?.formatos.map((f) => <option key={f}>{f}</option>)}
            </select>
          </label>
        </div>
      </details>

      {hayFiltros && (
        <button type="button" className="text-sm text-stone-600 underline" onClick={() => cambiar({ buscar: filtros.buscar })}>
          Limpiar filtros
        </button>
      )}
    </div>
  );
}
