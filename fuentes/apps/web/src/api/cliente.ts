// Única función para hablar con la API. Las pantallas usan los hooks
// de esta carpeta, nunca fetch directamente.
import type { Respuesta } from '@muchotexto/shared';

export class ErrorApi extends Error {
  constructor(public codigo: string, mensaje: string, public detalles?: unknown) {
    super(mensaje);
  }
}

export async function pedir<T>(ruta: string, opciones: RequestInit = {}): Promise<T> {
  const res = await fetch(`/api${ruta}`, {
    credentials: 'include',
    headers: { 'Content-Type': 'application/json', ...opciones.headers },
    ...opciones,
  });
  const cuerpo = (await res.json().catch(() => null)) as Respuesta<T> | null;
  if (!cuerpo) throw new ErrorApi('SIN_RESPUESTA', 'No se pudo conectar con el servidor');
  if (!cuerpo.ok) throw new ErrorApi(cuerpo.error.codigo, cuerpo.error.mensaje, cuerpo.error.detalles);
  return cuerpo.data;
}
