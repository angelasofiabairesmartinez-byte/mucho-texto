// Forma única de todas las respuestas de la API.
export type RespuestaOk<T> = { ok: true; data: T };
export type RespuestaError = {
  ok: false;
  error: { codigo: string; mensaje: string; detalles?: unknown };
};
export type Respuesta<T> = RespuestaOk<T> | RespuestaError;
