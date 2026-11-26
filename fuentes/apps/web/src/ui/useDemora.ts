import { useEffect, useState } from 'react';

// Devuelve el valor después de que el usuario deja de escribir (evita una consulta por tecla).
export function useDemora<T>(valor: T, ms = 300): T {
  const [demorado, setDemorado] = useState(valor);
  useEffect(() => {
    const t = setTimeout(() => setDemorado(valor), ms);
    return () => clearTimeout(t);
  }, [valor, ms]);
  return demorado;
}
