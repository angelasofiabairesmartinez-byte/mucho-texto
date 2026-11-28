import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { CrearResena, type LibroFicha } from '@muchotexto/shared';
import { useCrearResena } from '../../api/ficha';
import { Boton } from '../../ui/Boton';
import { Estrellas } from '../../ui/Estrellas';
import { Mensaje } from '../../ui/Mensaje';
import { Tarjeta } from '../../ui/Tarjeta';
import { fecha } from '../../ui/formato';

// RF-03.9 · Promedio, comentarios visibles y una reseña por cliente y libro
export function Resenas({ libro }: { libro: LibroFicha }) {
  const crear = useCrearResena(libro.libro_id);
  const form = useForm<CrearResena>({ resolver: zodResolver(CrearResena), defaultValues: { calificacion: 0 } });
  const calificacion = form.watch('calificacion');
  const { errors } = form.formState;
  const { promedio, total, lista } = libro.resenas;

  return (
    <Tarjeta
      titulo="Reseñas"
      accion={promedio !== null && (
        <span className="flex items-center gap-2 text-sm">
          <Estrellas valor={promedio} /> {promedio.toFixed(1)} · {total} {total === 1 ? 'reseña' : 'reseñas'}
        </span>
      )}
    >
      {libro.cliente && !libro.cliente.ya_reseno && (
        <form
          className="mb-4 space-y-2 rounded-md bg-stone-50 p-3"
          onSubmit={form.handleSubmit((datos) => crear.mutate(datos, { onSuccess: () => form.reset({ calificacion: 0 }) }))}
        >
          <p className="text-sm font-medium">Escribe tu reseña</p>
          <Estrellas valor={calificacion} onElegir={(n) => form.setValue('calificacion', n, { shouldValidate: true })} />
          {errors.calificacion && <p className="text-sm text-red-700">{errors.calificacion.message}</p>}
          <textarea
            {...form.register('comentario')}
            rows={3}
            maxLength={500}
            placeholder="¿Qué te pareció? (opcional)"
            className="w-full rounded-md border border-stone-300 bg-white px-3 py-2 text-sm"
          />
          {errors.comentario && <p className="text-sm text-red-700">{errors.comentario.message}</p>}
          <Boton type="submit" disabled={crear.isPending}>{crear.isPending ? 'Publicando…' : 'Publicar reseña'}</Boton>
          {crear.isError && <Mensaje tipo="error">{crear.error.message}</Mensaje>}
        </form>
      )}

      {lista.length === 0 ? (
        <p className="text-sm text-stone-600">Todavía no hay reseñas. ¡Sé el primero!</p>
      ) : (
        <ul className="divide-y divide-stone-100">
          {lista.map((r) => (
            <li key={r.id} className="py-3">
              <div className="flex items-center justify-between gap-2 text-sm">
                <span className="font-medium">{r.cliente}</span>
                <span className="text-stone-500">{fecha(r.fecha)}</span>
              </div>
              <Estrellas valor={r.calificacion} />
              {r.comentario && <p className="text-sm text-stone-700">{r.comentario}</p>}
            </li>
          ))}
        </ul>
      )}
    </Tarjeta>
  );
}
