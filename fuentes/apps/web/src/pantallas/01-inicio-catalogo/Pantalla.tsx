// Pantalla 01 · Inicio y catálogo (Bloque 3)
// EJEMPLO de pantalla de consulta: copia esta estructura.
// RF cubiertos por ahora: RF-01.1 (búsqueda). Faltan RF-01.2 a RF-01.7.
import { useState } from 'react';
import { Link } from 'react-router';
import { useLibros } from '../../api/catalogo';
import { Mensaje } from '../../ui/Mensaje';

export function InicioCatalogo() {
  const [buscar, setBuscar] = useState('');
  const libros = useLibros(buscar);

  return (
    <section className="space-y-4">
      <h1 className="text-xl font-semibold">Catálogo</h1>
      <input
        type="search"
        value={buscar}
        onChange={(e) => setBuscar(e.target.value)}
        placeholder="Buscar por título, autor o ISBN"
        className="w-full rounded-md border border-stone-300 bg-white px-3 py-2"
      />
      {libros.isPending && <Mensaje>Cargando…</Mensaje>}
      {libros.isError && <Mensaje tipo="error">{libros.error.message}</Mensaje>}
      {libros.data && libros.data.length === 0 && <Mensaje>No encontramos libros con esa búsqueda.</Mensaje>}
      <ul className="divide-y divide-stone-200 rounded-md border border-stone-200 bg-white">
        {libros.data?.map((l) => (
          <li key={l.libro_id} className="px-4 py-3">
            <Link to={`/libros/${l.libro_id}`} className="font-medium hover:underline">
              {l.titulo}
            </Link>
            <p className="text-sm text-stone-600">{String(l.autores ?? '')}</p>
          </li>
        ))}
      </ul>
    </section>
  );
}
