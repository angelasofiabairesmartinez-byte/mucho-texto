import { z } from 'zod';
import type { LibroResumen } from './catalogo.js';

// ============================================================
// Contratos de las rutas del cliente para las pantallas 01 y 03.
// Bloque 2 implementa las rutas devolviendo EXACTAMENTE estas formas.
// Mientras tanto, la app usa datos de prueba (// MOCK en src/api/).
// ============================================================

// GET /api/clientes/yo/inicio · Pantalla 01 (RF-01.3, RF-01.4, RF-01.7)
export type InicioCliente = {
  prestamos_activos: number;
  limite_prestamos: number;
  proximo_vencimiento: { titulo: string; fecha: string } | null;
  continuar_leyendo: {
    recurso_id: number;
    libro_id: number;
    titulo: string;
    pagina_actual: number;
    total_paginas: number;
    porcentaje: number;
    recurso_audio_id: number | null;
  } | null;
  recomendaciones: { libro_id: number; titulo: string; autores: string | null; motivo: string }[];
};

// GET /api/libros/:id · Pantalla 03 (RF-03.1 a RF-03.9)
export type Resena = {
  id: number;
  cliente: string;
  calificacion: number;
  comentario: string | null;
  fecha: string;
};

export type LibroFicha = LibroResumen & {
  descripcion: string | null;
  numero_edicion: string | null;
  anio_publicacion: number | null;
  ruta_portada: string | null;
  disponibilidad: { sucursal_id: number; sucursal: string; disponibles: number }[];
  recursos: { recurso_id: number; tipo: 'T' | 'A' }[];
  resenas: { promedio: number | null; total: number; lista: Resena[] };
  // null si no hay sesión de cliente
  cliente: {
    prestamos_activos: number;
    limite_prestamos: number;
    puede_prestar: boolean;
    motivo_bloqueo: string | null; // mensaje cuando puede_prestar = false
    en_lista_deseos: boolean;
    ya_reseno: boolean;
    reserva_pendiente: boolean;
  } | null;
};

// POST /api/prestamos/solicitudes · RF-03.3
export const SolicitarPrestamo = z.object({ libroId: z.number().int().positive() });
export type SolicitarPrestamo = z.infer<typeof SolicitarPrestamo>;
export type SolicitudRegistrada = { prestamos_activos: number; limite_prestamos: number; plazo_dias: number };

// POST /api/reservas · RF-03.5 (dbo.sp_crear_reserva)
export const CrearReserva = z.object({ libroId: z.number().int().positive() });
export type CrearReserva = z.infer<typeof CrearReserva>;
export type ReservaCreada = { reserva_id: number; estado: string };

// PUT / DELETE /api/clientes/yo/deseos/:libroId · RF-03.8
export type EstadoDeseo = { en_lista_deseos: boolean };

// POST /api/libros/:id/resenas · RF-03.9
export const CrearResena = z.object({
  calificacion: z.number({ error: 'Elige de 1 a 5 estrellas' }).int().min(1, 'Elige de 1 a 5 estrellas').max(5),
  comentario: z.string().trim().max(500, 'Máximo 500 caracteres').optional(),
});
export type CrearResena = z.infer<typeof CrearResena>;
