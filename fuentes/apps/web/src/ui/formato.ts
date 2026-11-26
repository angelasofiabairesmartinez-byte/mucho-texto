// Formatos de presentación compartidos.
const lempiras = new Intl.NumberFormat('es-HN', { style: 'currency', currency: 'HNL' });

export const dinero = (valor: number | string | null | undefined) =>
  valor === null || valor === undefined || valor === '' ? '—' : lempiras.format(Number(valor));

export const fecha = (iso: string) =>
  new Date(`${iso.slice(0, 10)}T12:00:00`).toLocaleDateString('es-HN', { day: 'numeric', month: 'short', year: 'numeric' });

export const lista = (texto: string | null | undefined) =>
  (texto ?? '').split(',').map((t) => t.trim()).filter(Boolean);
