// Solo rutas: validar con Zod + llamar al servicio. Nada de SQL aquí.
import { Router } from 'express';
import { BuscarLibros } from '@muchotexto/shared';
import { documentar } from '../../compartido/docs.js';
import { buscarLibros, filtrosCatalogo } from './catalogo.servicio.js';

export const rutasCatalogo = Router();

documentar({ metodo: 'get', ruta: '/api/libros', modulo: 'Catálogo', resumen: 'Buscar y filtrar libros (título, autor, ISBN, categoría, idioma, formato)', query: BuscarLibros });
rutasCatalogo.get('/libros', async (req, res) => {
  const filtros = BuscarLibros.parse(req.query);
  res.json({ ok: true, data: await buscarLibros(filtros) });
});

documentar({ metodo: 'get', ruta: '/api/catalogos/filtros', modulo: 'Catálogo', resumen: 'Categorías, idiomas y formatos para los filtros' });
rutasCatalogo.get('/catalogos/filtros', async (_req, res) => {
  res.json({ ok: true, data: await filtrosCatalogo() });
});
