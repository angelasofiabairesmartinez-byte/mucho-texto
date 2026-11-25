// PENDIENTE (Bloque 2 + 4): conectar con Better Auth.
// Mientras tanto la app actúa como Administrador para poder ver todo.
export type Sesion = { nombre: string; rol: string };

export function useSesion(): Sesion {
  return { nombre: 'Usuario de prueba', rol: 'Administrador' };
}
