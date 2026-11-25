// Genera base-de-datos/script-completo.sql uniendo todos los archivos
// en el orden de ejecución. Es el script de "ejecución masiva" que
// pide el docente: se abre en SSMS, se ejecuta y crea todo.
//   node scripts/generar-script-completo.mjs           -> genera
//   node scripts/generar-script-completo.mjs --check   -> falla si está desactualizado
import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

const raiz = join(import.meta.dirname, '..', 'base-de-datos');
const salida = join(raiz, 'script-completo.sql');
const sql = (carpeta) =>
  existsSync(join(raiz, carpeta))
    ? readdirSync(join(raiz, carpeta)).filter((f) => f.endsWith('.sql')).sort().map((f) => join(carpeta, f))
    : [];

const ddl = sql('DDL');
const orden = [
  ddl[0],
  '__USE__',
  ...ddl.slice(1),
  ...sql('Vistas'),
  ...sql('Funciones'),
  ...sql('Procedimientos'),
  ...sql('DML'),
];

let texto = `/* ============================================================
   Mucho Texto - biblioteca_libreria
   SCRIPT COMPLETO (generado automáticamente, no editar a mano)
   Generado con: node scripts/generar-script-completo.mjs
   Orden: DDL -> Vistas -> Funciones -> Procedimientos -> DML
   ============================================================ */\n\n`;
for (const archivo of orden) {
  if (archivo === '__USE__') { texto += 'USE biblioteca_libreria;\nGO\n\n'; continue; }
  let contenido = readFileSync(join(raiz, archivo), 'utf8').replace(/^﻿/, '').trimEnd();
  if (!/\nGO$/i.test(contenido)) contenido += '\nGO';
  texto += `-- >>> ${archivo.replaceAll('\\', '/')}\n${contenido}\n\n`;
}

if (process.argv.includes('--check')) {
  const actual = existsSync(salida) ? readFileSync(salida, 'utf8') : '';
  if (actual !== texto) {
    console.error('script-completo.sql está desactualizado. Corre: pnpm db:script');
    process.exit(1);
  }
  console.log('script-completo.sql al día');
} else {
  writeFileSync(salida, texto);
  console.log(`script-completo.sql generado (${orden.length - 1} archivos)`);
}
