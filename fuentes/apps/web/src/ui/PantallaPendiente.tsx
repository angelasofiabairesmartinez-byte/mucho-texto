import { Mensaje } from './Mensaje';

export function PantallaPendiente({ numero, titulo }: { numero: string; titulo: string }) {
  return (
    <section className="space-y-4">
      <h1 className="text-xl font-semibold">{titulo}</h1>
      <Mensaje>Pantalla {numero}: pendiente. Revisa su issue en GitHub para ver los RF que debe cumplir.</Mensaje>
    </section>
  );
}
