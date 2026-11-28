// Pantalla 01 · Inicio y catálogo (Bloque 3)
// RF-01.1 Búsqueda · RF-01.2 Filtros · RF-01.3 Continuar leyendo · RF-01.4 Recomendaciones
// RF-01.5 Novedades · RF-01.6 Accesos rápidos · RF-01.7 Resumen de préstamos (escritorio)
// Datos reales: búsqueda, filtros y novedades. MOCK: continuar leyendo, recomendaciones y resumen.
import { useState } from 'react';
import { Link } from 'react-router';
import { useLibros, type FiltrosBusqueda } from '../../api/catalogo';
import { useInicioCliente } from '../../api/clienteInicio';
import { useCarrito } from '../../carrito/carrito';
import { Mensaje } from '../../ui/Mensaje';
import { Tarjeta } from '../../ui/Tarjeta';
import { fecha } from '../../ui/formato';
import { useDemora } from '../../ui/useDemora';
import { Filtros } from './Filtros';
import { TarjetaLibro } from './TarjetaLibro';

export function InicioCatalogo() {
  const [filtros, setFiltros] = useState<FiltrosBusqueda>({});
  const demorados = useDemora(filtros);
  const buscando = Boolean(demorados.buscar || demorados.categoria || demorados.autor || demorados.idioma || demorados.formato);

  const resultados = useLibros({ ...demorados, porPagina: 20 }, buscando);
  const novedades = useLibros({ orden: 'recientes', porPagina: 6 });
  const inicio = useInicioCliente();
  const carrito = useCarrito();

  return (
    <div className="grid gap-6 lg:grid-cols-[1fr_18rem]">
      <div className="min-w-0 space-y-6">
        {/* RF-01.6 Accesos rápidos */}
        <header className="flex items-center justify-between gap-3">
          <h1 className="text-xl font-semibold">Inicio</h1>
          <nav className="flex gap-2 text-sm" aria-label="Accesos rápidos">
            <Link to="/deseos" className="rounded-md border border-stone-300 bg-white px-3 py-1.5">♡ Lista de deseos</Link>
            <Link to="/carrito" className="rounded-md border border-stone-300 bg-white px-3 py-1.5">
              🛒 Carrito{carrito.cantidad > 0 && <span className="ml-1 rounded-full bg-stone-900 px-1.5 text-xs text-white">{carrito.cantidad}</span>}
            </Link>
          </nav>
        </header>

        {/* RF-01.1 Búsqueda */}
        <input
          type="search"
          value={filtros.buscar ?? ''}
          onChange={(e) => setFiltros({ ...filtros, buscar: e.target.value || undefined })}
          placeholder="Buscar por título, autor o ISBN"
          aria-label="Buscar libros"
          className="w-full rounded-md border border-stone-300 bg-white px-3 py-2"
        />

        {/* RF-01.2 Filtros */}
        <Filtros filtros={filtros} cambiar={setFiltros} />

        {buscando ? (
          <section className="space-y-3" aria-live="polite">
            <h2 className="font-semibold">Resultados</h2>
            {resultados.isPending && <Mensaje>Buscando…</Mensaje>}
            {resultados.isError && <Mensaje tipo="error">{resultados.error.message}</Mensaje>}
            {resultados.data?.length === 0 && <Mensaje>No encontramos libros con esa búsqueda.</Mensaje>}
            <div className="grid gap-3 sm:grid-cols-2">
              {resultados.data?.map((l) => <TarjetaLibro key={l.libro_id} libro={l} />)}
            </div>
          </section>
        ) : (
          <>
            {/* RF-01.3 Continuar leyendo */}
            {inicio.data?.continuar_leyendo && (
              <Tarjeta titulo="Continuar leyendo">
                {(() => {
                  const c = inicio.data.continuar_leyendo;
                  return (
                    <div className="space-y-3">
                      <div>
                        <p className="font-medium">{c.titulo}</p>
                        <p className="text-sm text-stone-600">Página {c.pagina_actual} de {c.total_paginas} · {c.porcentaje}%</p>
                        <div className="mt-2 h-2 rounded-full bg-stone-100">
                          <div className="h-2 rounded-full bg-stone-900" style={{ width: `${c.porcentaje}%` }} />
                        </div>
                      </div>
                      <div className="flex gap-2">
                        <Link to={`/leer/${c.recurso_id}?pagina=${c.pagina_actual}`} className="rounded-md bg-stone-900 px-4 py-2 text-sm text-white">Leer</Link>
                        {c.recurso_audio_id && (
                          <Link to={`/escuchar/${c.recurso_audio_id}`} className="rounded-md border border-stone-300 px-4 py-2 text-sm">Escuchar</Link>
                        )}
                      </div>
                    </div>
                  );
                })()}
              </Tarjeta>
            )}

            {/* RF-01.4 Recomendaciones */}
            {inicio.data && inicio.data.recomendaciones.length > 0 && (
              <Tarjeta titulo="Recomendados para ti">
                <ul className="divide-y divide-stone-100">
                  {inicio.data.recomendaciones.map((r) => (
                    <li key={r.libro_id} className="py-2">
                      <Link to={`/libros/${r.libro_id}`} className="font-medium hover:underline">{r.titulo}</Link>
                      <p className="text-sm text-stone-600">{r.motivo}</p>
                    </li>
                  ))}
                </ul>
              </Tarjeta>
            )}

            {/* RF-01.5 Novedades */}
            <section className="space-y-3">
              <h2 className="font-semibold">Novedades</h2>
              {novedades.isPending && <Mensaje>Cargando…</Mensaje>}
              {novedades.isError && <Mensaje tipo="error">{novedades.error.message}</Mensaje>}
              <div className="grid gap-3 sm:grid-cols-2">
                {novedades.data?.map((l) => <TarjetaLibro key={l.libro_id} libro={l} />)}
              </div>
            </section>
          </>
        )}
      </div>

      {/* RF-01.7 Resumen de préstamos (solo escritorio) */}
      <aside className="hidden lg:block">
        {inicio.data && (
          <Tarjeta titulo="Mis préstamos">
            <p className="text-3xl font-semibold">
              {inicio.data.prestamos_activos} <span className="text-base font-normal text-stone-500">de {inicio.data.limite_prestamos}</span>
            </p>
            <p className="text-sm text-stone-600">préstamos en uso</p>
            {inicio.data.proximo_vencimiento && (
              <Mensaje tipo="info">
                Próximo vencimiento: <strong>{inicio.data.proximo_vencimiento.titulo}</strong> el {fecha(inicio.data.proximo_vencimiento.fecha)}
              </Mensaje>
            )}
            <Link to="/mis-prestamos" className="mt-3 inline-block text-sm underline">Ver mis préstamos</Link>
          </Tarjeta>
        )}
      </aside>
    </div>
  );
}
