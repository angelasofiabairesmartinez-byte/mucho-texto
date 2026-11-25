import type { RequestHandler } from 'express';
import { ErrorApp } from './errores.js';

// ============================================================
// PENDIENTE (Bloque 2, jue 26): reemplazar por Better Auth.
// Por ahora deja pasar todo y marca la petición como "sin sesión"
// para poder desarrollar las pantallas. NO es seguro todavía.
// ============================================================
export type UsuarioSesion = { usuarioId: number; rol: string; empleadoId?: number; clienteId?: number };

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      usuario?: UsuarioSesion;
    }
  }
}

export function requiereRol(..._roles: string[]): RequestHandler {
  return (req, _res, next) => {
    // TODO Bloque 2: leer la sesión de Better Auth y validar el rol.
    req.usuario ??= { usuarioId: 1, rol: 'Administrador', empleadoId: 1 };
    if (!req.usuario) return next(new ErrorApp(401, 'SIN_SESION', 'Inicia sesión para continuar'));
    next();
  };
}
