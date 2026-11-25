// Pantalla 14 · Préstamos y devoluciones (Bloque 4)
// EJEMPLO de pantalla con formulario: React Hook Form + el MISMO
// esquema Zod que valida la API (packages/shared).
// RF cubiertos por ahora: RF-14.4 (registrar préstamo) contra la ruta MOCK.
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { RegistrarPrestamo } from '@muchotexto/shared';
import { useRegistrarPrestamo } from '../../api/prestamos';
import { Boton } from '../../ui/Boton';
import { Campo } from '../../ui/Campo';
import { Mensaje } from '../../ui/Mensaje';

export function PrestamosDevoluciones() {
  const registrar = useRegistrarPrestamo();
  const form = useForm<RegistrarPrestamo>({ resolver: zodResolver(RegistrarPrestamo) });
  const { errors } = form.formState;

  return (
    <section className="max-w-md space-y-4">
      <h1 className="text-xl font-semibold">Nuevo préstamo</h1>
      <form className="space-y-3" onSubmit={form.handleSubmit((datos) => registrar.mutate(datos))}>
        <Campo etiqueta="Id del cliente" type="number" error={errors.clienteId?.message} {...form.register('clienteId', { valueAsNumber: true })} />
        <Campo etiqueta="Código del ejemplar" type="number" error={errors.ejemplares?.[0]?.message ?? errors.ejemplares?.message} {...form.register('ejemplares.0', { valueAsNumber: true })} />
        <Boton type="submit" disabled={registrar.isPending}>
          {registrar.isPending ? 'Guardando…' : 'Registrar préstamo'}
        </Boton>
      </form>
      {registrar.isError && <Mensaje tipo="error">{registrar.error.message}</Mensaje>}
      {registrar.isSuccess && <Mensaje tipo="exito">Préstamo #{registrar.data.prestamo_id} registrado.</Mensaje>}
    </section>
  );
}
