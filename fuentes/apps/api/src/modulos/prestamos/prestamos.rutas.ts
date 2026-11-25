import { Router } from 'express';
import { RegistrarPrestamo } from '@muchotexto/shared';
import { documentar } from '../../compartido/docs.js';
import { requiereRol } from '../../compartido/rol.js';
import { registrarPrestamo } from './prestamos.servicio.js';

export const rutasPrestamos = Router();

// Pantalla 14 · RF-14.4
documentar({ metodo: 'post', ruta: '/api/prestamos', modulo: 'Préstamos', resumen: 'Registrar un préstamo', cuerpo: RegistrarPrestamo, mock: true });
rutasPrestamos.post('/prestamos', requiereRol('Bibliotecario', 'Administrador'), async (req, res) => {
  const datos = RegistrarPrestamo.parse(req.body);
  const resultado = await registrarPrestamo(datos, req.usuario!.empleadoId!);
  res.status(201).json({ ok: true, data: resultado });
});
