import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type {
  CrearResena,
  EstadoDeseo,
  LibroFicha,
  LibroResumen,
  ReservaCreada,
  SolicitudRegistrada,
} from '@muchotexto/shared';
import { pedir } from './cliente';
import { simular } from './simular';

// ============================================================
// MOCK: GET /api/libros/:id todavía no existe (Bloque 2).
// Toma el libro REAL de /api/libros y completa con datos de prueba
// lo que aún no tiene ruta (sucursales, reseñas, estado del cliente).
// Para conectarlo: queryFn: () => pedir<LibroFicha>(`/libros/${id}`)
// ============================================================
const estadoDePrueba = {
  deseos: new Set<number>([2]),
  resenas: new Map<number, LibroFicha['resenas']['lista']>(),
  solicitados: new Set<number>(),
  reservados: new Set<number>(),
  prestamosActivos: 2,
  limite: 3,
};

async function fichaDePrueba(id: number): Promise<LibroFicha> {
  const lista = await pedir<LibroResumen[]>('/libros?porPagina=50');
  const libro = lista.find((l) => l.libro_id === id);
  if (!libro) throw new Error('No encontramos ese libro');
  const resenas = estadoDePrueba.resenas.get(id) ?? [
    { id: 1, cliente: 'María L.', calificacion: 5, comentario: 'Me encantó, lo recomiendo.', fecha: '2026-11-10' },
    { id: 2, cliente: 'José R.', calificacion: 4, comentario: 'Muy buen libro para estudiar.', fecha: '2026-10-28' },
  ];
  estadoDePrueba.resenas.set(id, resenas);
  const promedio = resenas.length ? resenas.reduce((s, r) => s + r.calificacion, 0) / resenas.length : null;
  const limiteAlcanzado = estadoDePrueba.prestamosActivos >= estadoDePrueba.limite;
  const disponibles = Number(libro.ejemplares_disponibles);
  return simular({
    ...libro,
    descripcion: 'Descripción de prueba: la ruta /api/libros/:id traerá la descripción real.',
    numero_edicion: '1.ª',
    anio_publicacion: 2024,
    ruta_portada: null,
    disponibilidad: disponibles > 0
      ? [
          { sucursal_id: 1, sucursal: 'Sucursal Central', disponibles: Math.ceil(disponibles / 2) },
          { sucursal_id: 2, sucursal: 'Sucursal Norte', disponibles: Math.floor(disponibles / 2) },
        ].filter((s) => s.disponibles > 0)
      : [],
    recursos: [
      ...(libro.tiene_texto ? [{ recurso_id: id * 10 + 1, tipo: 'T' as const }] : []),
      ...(libro.tiene_audio ? [{ recurso_id: id * 10 + 2, tipo: 'A' as const }] : []),
    ],
    resenas: { promedio, total: resenas.length, lista: resenas },
    cliente: {
      prestamos_activos: estadoDePrueba.prestamosActivos,
      limite_prestamos: estadoDePrueba.limite,
      puede_prestar: !limiteAlcanzado,
      motivo_bloqueo: limiteAlcanzado ? 'Límite de préstamos alcanzado. Devuelve un libro para solicitar otro.' : null,
      en_lista_deseos: estadoDePrueba.deseos.has(id),
      ya_reseno: resenas.some((r) => r.cliente === 'Tú'),
      reserva_pendiente: estadoDePrueba.reservados.has(id),
    },
  });
}

export function useFicha(id: number) {
  return useQuery({ queryKey: ['libros', id, 'ficha'], queryFn: () => fichaDePrueba(id), enabled: id > 0 });
}

function useInvalidarFicha(id: number) {
  const qc = useQueryClient();
  return () => qc.invalidateQueries({ queryKey: ['libros', id, 'ficha'] });
}

// MOCK · POST /api/prestamos/solicitudes (RF-03.3)
export function useSolicitarPrestamo(id: number) {
  const invalidar = useInvalidarFicha(id);
  return useMutation({
    mutationFn: async (): Promise<SolicitudRegistrada> => {
      if (estadoDePrueba.prestamosActivos >= estadoDePrueba.limite) {
        throw new Error('Límite de préstamos alcanzado. Devuelve un libro para solicitar otro.');
      }
      estadoDePrueba.prestamosActivos += 1;
      estadoDePrueba.solicitados.add(id);
      return simular({ prestamos_activos: estadoDePrueba.prestamosActivos, limite_prestamos: estadoDePrueba.limite, plazo_dias: 15 });
    },
    onSuccess: invalidar,
  });
}

// MOCK · POST /api/reservas (RF-03.5, dbo.sp_crear_reserva)
export function useReservar(id: number) {
  const invalidar = useInvalidarFicha(id);
  return useMutation({
    mutationFn: async (): Promise<ReservaCreada> => {
      if (estadoDePrueba.reservados.has(id)) throw new Error('Ya tienes una reserva pendiente de este libro.');
      estadoDePrueba.reservados.add(id);
      return simular({ reserva_id: 900 + id, estado: 'PENDIENTE' });
    },
    onSuccess: invalidar,
  });
}

// MOCK · PUT/DELETE /api/clientes/yo/deseos/:libroId (RF-03.8)
export function useAlternarDeseo(id: number) {
  const invalidar = useInvalidarFicha(id);
  return useMutation({
    mutationFn: async (agregar: boolean): Promise<EstadoDeseo> => {
      if (agregar) estadoDePrueba.deseos.add(id);
      else estadoDePrueba.deseos.delete(id);
      return simular({ en_lista_deseos: agregar }, 150);
    },
    onSuccess: invalidar,
  });
}

// MOCK · POST /api/libros/:id/resenas (RF-03.9)
export function useCrearResena(id: number) {
  const invalidar = useInvalidarFicha(id);
  return useMutation({
    mutationFn: async (datos: CrearResena) => {
      const lista = estadoDePrueba.resenas.get(id) ?? [];
      if (lista.some((r) => r.cliente === 'Tú')) throw new Error('Ya escribiste una reseña de este libro.');
      lista.unshift({ id: Date.now(), cliente: 'Tú', calificacion: datos.calificacion, comentario: datos.comentario ?? null, fecha: new Date().toISOString().slice(0, 10) });
      estadoDePrueba.resenas.set(id, lista);
      return simular({ ok: true });
    },
    onSuccess: invalidar,
  });
}
