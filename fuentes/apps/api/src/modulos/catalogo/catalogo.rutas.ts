// Solo rutas: validar con Zod + llamar al servicio. Nada de SQL aquí.
import { Router } from 'express';
import { BuscarLibros } from '@muchotexto/shared';
import { documentar } from '../../compartido/docs.js';
import { buscarLibros } from './catalogo.servicio.js';

export const rutasCatalogo = Router();

documentar({ metodo: 'get', ruta: '/api/libros', modulo: 'Catálogo', resumen: 'Buscar libros por título, autor o ISBN', query: BuscarLibros });
rutasCatalogo.get('/libros', async (req, res) => {
  const filtros = BuscarLibros.parse(req.query);
  res.json({ ok: true, data: await buscarLibros(filtros) });
});
