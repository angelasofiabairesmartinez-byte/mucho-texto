// Pantalla 03 · Ficha del libro (Bloque 3)
// RF-03.1 Información · RF-03.2 Disponibilidad · RF-03.3 a RF-03.7 Acciones
// RF-03.8 Lista de deseos · RF-03.9 Reseñas
// MOCK: usa el libro real de /api/libros y completa lo demás con datos de prueba
// hasta que Bloque 2 publique GET /api/libros/:id (contrato en packages/shared/src/cliente.ts).
import { Link, useParams } from 'react-router';
import { useAlternarDeseo, useFicha } from '../../api/ficha';
import { Etiqueta } from '../../ui/Etiqueta';
import { Mensaje } from '../../ui/Mensaje';
import { Portada } from '../../ui/Portada';
import { Tarjeta } from '../../ui/Tarjeta';
import { dinero, lista } from '../../ui/formato';
import { Acciones } from './Acciones';
import { Resenas } from './Resenas';

export function FichaLibro() {
  const id = Number(useParams().id);
  const ficha = useFicha(id);
  const deseo = useAlternarDeseo(id);

  if (!Number.isInteger(id) || id <= 0) return <Mensaje tipo="error">Libro no válido.</Mensaje>;
  if (ficha.isPending) return <Mensaje>Cargando…</Mensaje>;
  if (ficha.isError) return <Mensaje tipo="error">{ficha.error.message}</Mensaje>;

  const libro = ficha.data;
  const disponibles = libro.disponibilidad.reduce((s, d) => s + d.disponibles, 0);
  const enDeseos = libro.cliente?.en_lista_deseos ?? false;

  const datos: [string, string | number | null][] = [
    ['Editorial', libro.editorial],
    ['Edición', [libro.numero_edicion, libro.anio_publicacion].filter(Boolean).join(' · ') || null],
    ['Idioma', libro.idioma],
    ['Formato', libro.formato],
    ['ISBN', libro.isbn],
  ];

  return (
    <div className="space-y-6">
      <Link to="/" className="text-sm text-stone-600 underline">← Volver al catálogo</Link>

      <div className="grid gap-6 md:grid-cols-[12rem_1fr_16rem]">
        <Portada titulo={libro.titulo} ruta={libro.ruta_portada} className="aspect-[2/3] w-40 text-3xl md:w-full" />

        {/* RF-03.1 Información del libro */}
        <section className="min-w-0 space-y-3">
          <div className="flex items-start justify-between gap-3">
            <h1 className="text-2xl font-semibold leading-tight">{libro.titulo}</h1>
            {/* RF-03.8 Lista de deseos */}
            {libro.cliente && (
              <button
                type="button"
                onClick={() => deseo.mutate(!enDeseos)}
                disabled={deseo.isPending}
                aria-pressed={enDeseos}
                aria-label={enDeseos ? 'Quitar de la lista de deseos' : 'Agregar a la lista de deseos'}
                className="text-2xl leading-none"
              >
                <span className={enDeseos ? 'text-red-600' : 'text-stone-400'}>{enDeseos ? '♥' : '♡'}</span>
              </button>
            )}
          </div>
          <p className="text-stone-700">{libro.autores ?? 'Autor desconocido'}</p>
          <div className="flex flex-wrap gap-1.5">
            {lista(libro.categorias).map((c) => <Etiqueta key={c}>{c}</Etiqueta>)}
          </div>
          <p className="text-xl font-semibold">{dinero(libro.precio_venta)}</p>
          {libro.descripcion && <p className="text-stone-700">{libro.descripcion}</p>}
          <dl className="grid grid-cols-[auto_1fr] gap-x-4 gap-y-1 text-sm">
            {datos.filter(([, v]) => v !== null && v !== '').map(([k, v]) => (
              <div key={k} className="contents">
                <dt className="text-stone-500">{k}</dt>
                <dd>{v}</dd>
              </div>
            ))}
          </dl>
        </section>

        <aside className="space-y-4">
          {/* RF-03.2 Disponibilidad */}
          <Tarjeta titulo="Disponibilidad">
            <p className="font-medium">{disponibles > 0 ? `${disponibles} ${disponibles === 1 ? 'ejemplar disponible' : 'ejemplares disponibles'}` : 'Sin ejemplares disponibles'}</p>
            <ul className="mt-1 space-y-0.5 text-sm text-stone-600">
              {libro.disponibilidad.map((s) => <li key={s.sucursal_id}>{s.sucursal}: {s.disponibles}</li>)}
            </ul>
            {libro.cliente && (
              <p className="mt-2 text-sm text-stone-600">
                Tienes {libro.cliente.prestamos_activos} de {libro.cliente.limite_prestamos} préstamos en uso.
              </p>
            )}
          </Tarjeta>
          <Acciones libro={libro} />
        </aside>
      </div>

      <Resenas libro={libro} />
    </div>
  );
}
