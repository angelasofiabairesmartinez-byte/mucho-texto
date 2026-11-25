import type { ReactNode } from 'react';
import { useSesion } from './sesion';
import { Mensaje } from '../ui/Mensaje';

export function RutaProtegida({ roles, children }: { roles: string[]; children: ReactNode }) {
  const sesion = useSesion();
  if (roles.length && !roles.includes(sesion.rol) && sesion.rol !== 'Administrador') {
    return <Mensaje tipo="error">No tienes permiso para ver esta pantalla.</Mensaje>;
  }
  return <>{children}</>;
}
