import { NavLink, Outlet } from 'react-router';
import { menu } from './menu';
import { useSesion } from '../auth/sesion';

// Menú lateral en escritorio y barra inferior en móvil.
// Solo muestra las pantallas permitidas para el rol de la sesión.
export function Layout() {
  const sesion = useSesion();
  const visibles = menu.filter(
    (m) => !m.ruta.includes(':') && (sesion.rol === 'Administrador' || m.roles.length === 0 || m.roles.includes(sesion.rol)),
  );

  return (
    <div className="min-h-screen md:flex">
      <aside className="hidden w-64 shrink-0 border-r border-stone-200 bg-white p-4 md:block">
        <p className="mb-4 text-lg font-semibold">Mucho Texto</p>
        <nav className="space-y-1 text-sm">
          {visibles.map((m) => (
            <NavLink
              key={m.ruta}
              to={m.ruta}
              end
              className={({ isActive }) => `block rounded px-2 py-1.5 ${isActive ? 'bg-stone-900 text-white' : 'hover:bg-stone-100'}`}
            >
              <span className="mr-2 text-stone-400">{m.numero}</span>
              {m.etiqueta}
            </NavLink>
          ))}
        </nav>
      </aside>

      <main className="flex-1 p-4 pb-24 md:p-8">
        <Outlet />
      </main>

      <nav className="fixed inset-x-0 bottom-0 flex overflow-x-auto border-t border-stone-200 bg-white md:hidden">
        {visibles.slice(0, 5).map((m) => (
          <NavLink key={m.ruta} to={m.ruta} end className="flex-1 px-2 py-3 text-center text-xs">
            {m.etiqueta}
          </NavLink>
        ))}
      </nav>

      {/* Botón de ayuda siempre visible: abre el manual de usuario (requisito de la entrega) */}
      <a
        href="/manual/index.html"
        target="_blank"
        rel="noreferrer"
        aria-label="Abrir el manual de usuario"
        title="Manual de usuario"
        className="fixed bottom-20 right-4 flex h-12 w-12 items-center justify-center rounded-full bg-stone-900 text-xl font-semibold text-white shadow-lg md:bottom-6"
      >
        ?
      </a>
    </div>
  );
}
