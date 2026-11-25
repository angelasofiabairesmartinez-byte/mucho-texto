-- proveedor
SET IDENTITY_INSERT dbo.proveedor ON;
INSERT INTO dbo.proveedor (id, nombre, telefono, correo, direccion) VALUES
  (1, N'Distribuidora Libros del Sur', N'+504 2565-7166', N'ventas01@distribuidoralibro.example.com', N'Colonia Los Pinos, bloque 1, Comayagua'),
  (2, N'Importadora Letras Vivas', N'+504 2963-9414', N'ventas02@importadoraletrasv.example.com', N'Colonia Los Pinos, bloque 2, El Progreso'),
  (3, N'Papelería y Libros Central', N'+504 2853-2250', N'ventas03@papeleriaylibrosce.example.com', N'Colonia Los Pinos, bloque 3, Santa Rosa de Copán'),
  (4, N'Mayorista Páginas S.A.', N'+504 2940-6577', N'ventas04@mayoristapaginass..example.com', N'Colonia Los Pinos, bloque 4, Choloma'),
  (5, N'Comercial Lectura Plus', N'+504 2291-9815', N'ventas05@comerciallecturapl.example.com', N'Colonia Los Pinos, bloque 5, Siguatepeque'),
  (6, N'Distribuciones El Saber', N'+504 2499-5712', N'ventas06@distribucioneselsa.example.com', N'Colonia Los Pinos, bloque 6, Comayagua'),
  (7, N'Grupo Editorial Norte', N'+504 2668-3308', N'ventas07@grupoeditorialnort.example.com', N'Colonia Los Pinos, bloque 7, El Progreso'),
  (8, N'Libros y Más Honduras', N'+504 2860-6062', N'ventas08@librosymashonduras.example.com', N'Colonia Los Pinos, bloque 8, Santa Rosa de Copán'),
  (9, N'Surtidora Académica', N'+504 2225-7043', N'ventas09@surtidoraacademica.example.com', N'Colonia Los Pinos, bloque 9, Choloma'),
  (10, N'Importaciones Bibliomundo', N'+504 2572-8554', N'ventas10@importacionesbibli.example.com', N'Colonia Los Pinos, bloque 10, Siguatepeque'),
  (11, N'Distribuidora Cuentos y Letras', N'+504 2632-2485', N'ventas11@distribuidoracuent.example.com', N'Colonia Los Pinos, bloque 11, Comayagua'),
  (12, N'Comercializadora Tinta y Papel', N'+504 2608-9166', N'ventas12@comercializadorati.example.com', N'Colonia Los Pinos, bloque 12, El Progreso'),
  (13, N'Libros Express Centroamérica', N'+504 2319-7970', N'ventas13@librosexpresscentr.example.com', N'Colonia Los Pinos, bloque 13, Santa Rosa de Copán'),
  (14, N'Proveedora Universal de Textos', N'+504 2718-9045', N'ventas14@proveedorauniversa.example.com', N'Colonia Los Pinos, bloque 14, Choloma'),
  (15, N'Distribuidora Ágora', N'+504 2607-9595', N'ventas15@distribuidoraagora.example.com', N'Colonia Los Pinos, bloque 15, Siguatepeque');
SET IDENTITY_INSERT dbo.proveedor OFF;
