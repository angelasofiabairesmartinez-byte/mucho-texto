import type { PrestamoRegistrado, RegistrarPrestamo } from '@muchotexto/shared';
// import { prisma } from '../../compartido/db.js';

// MOCK: devuelve datos de prueba con la forma del contrato de
// dbo.sp_registrar_prestamo hasta que el SP exista (Bloque 1, vie 27).
// Para conectarlo, reemplazar el cuerpo por:
//   const [fila] = await prisma.$queryRaw<PrestamoRegistrado[]>`
//     EXEC dbo.sp_registrar_prestamo ${d.clienteId}, ${empleadoId}, ${JSON.stringify(d.ejemplares)}`;
//   return fila!;
export async function registrarPrestamo(d: RegistrarPrestamo, empleadoId: number): Promise<PrestamoRegistrado> {
  void d;
  void empleadoId;
  return { prestamo_id: 999 };
}
