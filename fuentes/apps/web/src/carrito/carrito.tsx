// Carrito del cliente (RF-01.6, RF-03.6). Vive en el navegador hasta que
// se paga en la pantalla 04; ahí se envía a dbo.sp_registrar_venta.
import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';

export type ItemCarrito = { libro_id: number; titulo: string; precio: number; cantidad: number };

type Carrito = {
  items: ItemCarrito[];
  cantidad: number;
  agregar: (item: Omit<ItemCarrito, 'cantidad'>) => void;
  quitar: (libroId: number) => void;
  vaciar: () => void;
};

const CLAVE = 'muchotexto.carrito';
const ContextoCarrito = createContext<Carrito | null>(null);

function leerGuardado(): ItemCarrito[] {
  try {
    return JSON.parse(localStorage.getItem(CLAVE) ?? '[]') as ItemCarrito[];
  } catch {
    return [];
  }
}

export function ProveedorCarrito({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<ItemCarrito[]>(leerGuardado);

  useEffect(() => {
    try {
      localStorage.setItem(CLAVE, JSON.stringify(items));
    } catch {
      // Sin almacenamiento disponible: el carrito vive solo en memoria.
    }
  }, [items]);

  const valor: Carrito = {
    items,
    cantidad: items.reduce((s, i) => s + i.cantidad, 0),
    agregar: (nuevo) =>
      setItems((actual) => {
        const existe = actual.find((i) => i.libro_id === nuevo.libro_id);
        return existe
          ? actual.map((i) => (i.libro_id === nuevo.libro_id ? { ...i, cantidad: i.cantidad + 1 } : i))
          : [...actual, { ...nuevo, cantidad: 1 }];
      }),
    quitar: (libroId) => setItems((actual) => actual.filter((i) => i.libro_id !== libroId)),
    vaciar: () => setItems([]),
  };

  return <ContextoCarrito.Provider value={valor}>{children}</ContextoCarrito.Provider>;
}

export function useCarrito() {
  const c = useContext(ContextoCarrito);
  if (!c) throw new Error('useCarrito debe usarse dentro de ProveedorCarrito');
  return c;
}
