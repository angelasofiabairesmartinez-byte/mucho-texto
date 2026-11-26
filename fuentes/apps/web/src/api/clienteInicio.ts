import { useQuery } from '@tanstack/react-query';
import type { InicioCliente } from '@muchotexto/shared';
import { simular } from './simular';
// import { pedir } from './cliente';

// MOCK hasta que exista GET /api/clientes/yo/inicio (Bloque 2).
// Para conectarlo: queryFn: () => pedir<InicioCliente>('/clientes/yo/inicio')
const inicioDePrueba: InicioCliente = {
  prestamos_activos: 2,
  limite_prestamos: 3,
  proximo_vencimiento: { titulo: 'Fundamentos de física moderna', fecha: '2026-12-02' },
  continuar_leyendo: {
    recurso_id: 1,
    libro_id: 1,
    titulo: 'La sombra del río',
    pagina_actual: 84,
    total_paginas: 240,
    porcentaje: 35,
    recurso_audio_id: 2,
  },
  recomendaciones: [
    { libro_id: 7, titulo: 'Misión en la montaña', autores: null, motivo: 'Porque leíste La sombra del río' },
    { libro_id: 2, titulo: 'Fundamentos de física moderna', autores: null, motivo: 'Porque compraste Programación en C# desde cero' },
    { libro_id: 4, titulo: 'Historia de Honduras: de la colonia a hoy', autores: null, motivo: 'Porque te interesa Historia' },
  ],
};

export function useInicioCliente() {
  return useQuery({ queryKey: ['clientes', 'yo', 'inicio'], queryFn: () => simular(inicioDePrueba) });
}
