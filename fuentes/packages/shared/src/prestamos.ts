import { z } from 'zod';

// POST /api/prestamos  (pantalla 14, RF-14.4)
// Debe coincidir con el contrato de dbo.sp_registrar_prestamo
export const RegistrarPrestamo = z.object({
  clienteId: z.number().int().positive('Selecciona un cliente'),
  ejemplares: z
    .array(z.number().int().positive())
    .min(1, 'Agrega al menos un ejemplar'),
});
export type RegistrarPrestamo = z.infer<typeof RegistrarPrestamo>;

export type PrestamoRegistrado = { prestamo_id: number };
