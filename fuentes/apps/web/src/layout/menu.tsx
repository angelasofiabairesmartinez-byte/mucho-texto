import type { ComponentType } from 'react';
import { InicioCatalogo } from '../pantallas/01-inicio-catalogo/Pantalla';
import { FichaLibro } from '../pantallas/03-ficha-libro/Pantalla';
import { PrestamosDevoluciones } from '../pantallas/14-prestamos-devoluciones/Pantalla';

// ============================================================
// Las 22 pantallas del documento de mockups.
// Al terminar una pantalla: importar su componente y ponerlo en
// "componente". Los roles salen del mockup de cada pantalla.
// ============================================================
export type ItemMenu = {
  numero: string;
  etiqueta: string;
  ruta: string;
  roles: string[]; // vacío = cualquiera (incluso sin sesión)
  bloque: 3 | 4;
  grupo: 'Cliente' | 'Empleado' | 'Administración' | 'Cuenta';
  componente?: ComponentType;
};

const EMPLEADO = ['Bibliotecario', 'Cajero', 'Vendedor', 'Inventario', 'Atención al cliente', 'Operador de préstamos', 'Supervisor'];
const ADMIN = ['Administrador', 'Gerente'];

export const menu: ItemMenu[] = [
  { numero: '01', etiqueta: 'Inicio y catálogo', ruta: '/', roles: [], bloque: 3, grupo: 'Cliente', componente: InicioCatalogo },
  { numero: '02', etiqueta: 'Inicio de sesión', ruta: '/entrar', roles: [], bloque: 4, grupo: 'Cuenta' },
  { numero: '03', etiqueta: 'Ficha del libro', ruta: '/libros/:id', roles: [], bloque: 3, grupo: 'Cliente', componente: FichaLibro },
  { numero: '04', etiqueta: 'Carrito y pago', ruta: '/carrito', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '05', etiqueta: 'Mis préstamos', ruta: '/mis-prestamos', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '06', etiqueta: 'Mis reservas', ruta: '/mis-reservas', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '07', etiqueta: 'Notificaciones', ruta: '/notificaciones', roles: ['Cliente'], bloque: 4, grupo: 'Cliente' },
  { numero: '08', etiqueta: 'Perfil y credencial QR', ruta: '/perfil', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '09', etiqueta: 'Mi biblioteca digital', ruta: '/mi-biblioteca', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '10', etiqueta: 'Lector', ruta: '/leer/:recursoId', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '11', etiqueta: 'Audiolibro', ruta: '/escuchar/:recursoId', roles: ['Cliente'], bloque: 3, grupo: 'Cliente' },
  { numero: '12', etiqueta: 'Lista de deseos', ruta: '/deseos', roles: ['Cliente'], bloque: 4, grupo: 'Cliente' },
  { numero: '13', etiqueta: 'Inicio del empleado', ruta: '/empleado', roles: EMPLEADO, bloque: 4, grupo: 'Empleado' },
  { numero: '14', etiqueta: 'Préstamos y devoluciones', ruta: '/empleado/prestamos', roles: ['Bibliotecario', 'Operador de préstamos'], bloque: 4, grupo: 'Empleado', componente: PrestamosDevoluciones },
  { numero: '15', etiqueta: 'Caja', ruta: '/empleado/caja', roles: ['Cajero', 'Vendedor'], bloque: 4, grupo: 'Empleado' },
  { numero: '16', etiqueta: 'Clientes y credenciales', ruta: '/empleado/clientes', roles: ['Bibliotecario', 'Atención al cliente'], bloque: 4, grupo: 'Empleado' },
  { numero: '17', etiqueta: 'Catálogo e inventario', ruta: '/empleado/inventario', roles: ['Inventario', 'Bibliotecario'], bloque: 4, grupo: 'Empleado' },
  { numero: '18', etiqueta: 'Panel de reportes', ruta: '/admin', roles: ADMIN, bloque: 4, grupo: 'Administración' },
  { numero: '19', etiqueta: 'Compras y proveedores', ruta: '/admin/compras', roles: [...ADMIN, 'Compras'], bloque: 4, grupo: 'Administración' },
  { numero: '20', etiqueta: 'Biblioteca digital', ruta: '/admin/digital', roles: ['Administrador'], bloque: 3, grupo: 'Administración' },
  { numero: '21', etiqueta: 'Usuarios y bitácora', ruta: '/admin/usuarios', roles: ['Administrador'], bloque: 4, grupo: 'Administración' },
  { numero: '22', etiqueta: 'Ajustes', ruta: '/admin/ajustes', roles: ['Administrador'], bloque: 4, grupo: 'Administración' },
];
