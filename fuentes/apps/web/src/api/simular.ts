// Ayuda para los datos de prueba (// MOCK) mientras Bloque 2 termina las rutas.
// Simula la espera de la red para que las pantallas muestren su estado "Cargando".
export function simular<T>(datos: T, ms = 300): Promise<T> {
  return new Promise((resolver) => setTimeout(() => resolver(structuredClone(datos)), ms));
}
