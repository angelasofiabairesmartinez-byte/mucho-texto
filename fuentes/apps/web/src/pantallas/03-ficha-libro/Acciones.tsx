import { Link } from 'react-router';
import type { LibroFicha } from '@muchotexto/shared';
import { useReservar, useSolicitarPrestamo } from '../../api/ficha';
import { useCarrito } from '../../carrito/carrito';
import { Boton } from '../../ui/Boton';
import { Mensaje } from '../../ui/Mensaje';

// RF-03.3 Solicitar préstamo · RF-03.4 Bloqueo por límite · RF-03.5 Reservar
// RF-03.6 Comprar · RF-03.7 Leer y escuchar
export function Acciones({ libro }: { libro: LibroFicha }) {
  const solicitar = useSolicitarPrestamo(libro.libro_id);
  const reservar = useReservar(libro.libro_id);
  const carrito = useCarrito();
  const disponibles = libro.disponibilidad.reduce((s, d) => s + d.disponibles, 0);
  const cliente = libro.cliente;
  const texto = libro.recursos.find((r) => r.tipo === 'T');
  const audio = libro.recursos.find((r) => r.tipo === 'A');
  const enCarrito = carrito.items.some((i) => i.libro_id === libro.libro_id);
  const secundario = 'rounded-md border border-stone-300 bg-white px-4 py-2 text-center text-sm font-medium hover:bg-stone-50';

  return (
    <div className="space-y-3">
      {!cliente ? (
        <Mensaje>Inicia sesión para pedir prestado, reservar o comprar.</Mensaje>
      ) : disponibles > 0 ? (
        <>
          <Boton className="w-full" disabled={!cliente.puede_prestar || solicitar.isPending || solicitar.isSuccess} onClick={() => solicitar.mutate()}>
            {solicitar.isPending ? 'Solicitando…' : solicitar.isSuccess ? 'Préstamo solicitado' : 'Solicitar préstamo'}
          </Boton>
          {!cliente.puede_prestar && cliente.motivo_bloqueo && <Mensaje tipo="error">{cliente.motivo_bloqueo}</Mensaje>}
          {solicitar.isError && <Mensaje tipo="error">{solicitar.error.message}</Mensaje>}
          {solicitar.isSuccess && (
            <Mensaje tipo="exito">
              Retíralo en la sucursal. {solicitar.data.prestamos_activos} de {solicitar.data.limite_prestamos} préstamos en uso · plazo de {solicitar.data.plazo_dias} días
            </Mensaje>
          )}
        </>
      ) : (
        <>
          <Boton
            className="w-full"
            disabled={cliente.reserva_pendiente || reservar.isPending}
            onClick={() => {
              if (window.confirm('No hay ejemplares disponibles. ¿Quieres reservar este libro?')) reservar.mutate();
            }}
          >
            {cliente.reserva_pendiente ? 'Reserva pendiente' : reservar.isPending ? 'Reservando…' : 'Reservar'}
          </Boton>
          {reservar.isError && <Mensaje tipo="error">{reservar.error.message}</Mensaje>}
          {(reservar.isSuccess || cliente.reserva_pendiente) && (
            <Mensaje tipo="exito">Te avisaremos cuando haya un ejemplar. Tendrás 3 días para retirarlo.</Mensaje>
          )}
        </>
      )}

      {libro.precio_venta !== null && (
        <button
          type="button"
          className={`${secundario} w-full`}
          onClick={() => carrito.agregar({ libro_id: libro.libro_id, titulo: libro.titulo, precio: Number(libro.precio_venta) })}
        >
          {enCarrito ? 'Agregar otro al carrito' : 'Comprar'}
        </button>
      )}
      {enCarrito && <p className="text-center text-sm"><Link to="/carrito" className="underline">Ver carrito ({carrito.cantidad})</Link></p>}

      {libro.permite_digital === 1 && (texto || audio) && (
        <div className="grid grid-cols-2 gap-2">
          {texto && <Link to={`/leer/${texto.recurso_id}`} className={secundario}>Leer</Link>}
          {audio && <Link to={`/escuchar/${audio.recurso_id}`} className={secundario}>Escuchar</Link>}
        </div>
      )}
    </div>
  );
}
