import { app } from './app.js';

const puerto = Number(process.env.API_PORT ?? 3000);
app.listen(puerto, () => {
  console.log(`API Mucho Texto en http://localhost:${puerto}  ·  docs: http://localhost:${puerto}/api/docs`);
});
