import { Route, Routes } from 'react-router';
import { Layout } from './layout/Layout';
import { menu } from './layout/menu';
import { RutaProtegida } from './auth/RutaProtegida';
import { PantallaPendiente } from './ui/PantallaPendiente';

// Las rutas salen de layout/menu.tsx: al terminar una pantalla,
// se cambia su "componente" allí. No hace falta tocar este archivo.
export function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        {menu.map((item) => (
          <Route
            key={item.ruta}
            path={item.ruta}
            element={
              <RutaProtegida roles={item.roles}>
                {item.componente ? <item.componente /> : <PantallaPendiente numero={item.numero} titulo={item.etiqueta} />}
              </RutaProtegida>
            }
          />
        ))}
        <Route path="*" element={<PantallaPendiente numero="--" titulo="Página no encontrada" />} />
      </Route>
    </Routes>
  );
}
