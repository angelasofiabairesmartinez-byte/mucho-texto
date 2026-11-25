import type { ErrorRequestHandler, RequestHandler } from 'express';
import { ZodError } from 'zod';
import type { RespuestaError } from '@muchotexto/shared';

// Error con mensaje para el usuario y código HTTP.
export class ErrorApp extends Error {
  constructor(public status: number, public codigo: string, mensaje: string) {
    super(mensaje);
  }
}

// Los SP lanzan THROW 50001-50099 con un mensaje en español:
// ese mensaje se muestra tal cual al usuario (error 400).
function errorDeSqlServer(err: unknown): { numero: number; mensaje: string } | null {
  const texto = String((err as { message?: string })?.message ?? '');
  const original = (err as { meta?: { driverAdapterError?: { cause?: { code?: number; message?: string } } } })
    ?.meta?.driverAdapterError?.cause;
  const numero = original?.code ?? Number(/\b(50\d{3})\b/.exec(texto)?.[1] ?? NaN);
  if (numero >= 50000 && numero < 51000) {
    return { numero, mensaje: original?.message ?? texto };
  }
  return null;
}

export const noEncontrado: RequestHandler = (_req, res) => {
  const cuerpo: RespuestaError = { ok: false, error: { codigo: 'NO_ENCONTRADO', mensaje: 'Ruta no encontrada' } };
  res.status(404).json(cuerpo);
};

export const manejarErrores: ErrorRequestHandler = (err, _req, res, _next) => {
  let status = 500;
  let cuerpo: RespuestaError = { ok: false, error: { codigo: 'ERROR_INTERNO', mensaje: 'Ocurrió un error inesperado' } };

  if (err instanceof ZodError) {
    status = 400;
    cuerpo = { ok: false, error: { codigo: 'DATOS_INVALIDOS', mensaje: 'Revisa los datos enviados', detalles: err.issues } };
  } else if (err instanceof ErrorApp) {
    status = err.status;
    cuerpo = { ok: false, error: { codigo: err.codigo, mensaje: err.message } };
  } else {
    const sql = errorDeSqlServer(err);
    if (sql) {
      status = 400;
      cuerpo = { ok: false, error: { codigo: `SQL_${sql.numero}`, mensaje: sql.mensaje } };
    } else {
      console.error(err);
    }
  }
  res.status(status).json(cuerpo);
};
