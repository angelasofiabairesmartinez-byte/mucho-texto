-- cargo
SET IDENTITY_INSERT dbo.cargo ON;
INSERT INTO dbo.cargo (id, nombre, descripcion) VALUES
  (1, N'Director general', N'Dirige la operación general de la biblioteca-librería.'),
  (2, N'Gerente de sucursal', N'Administra el personal y las ventas de una sucursal.'),
  (3, N'Bibliotecario', N'Atiende préstamos, devoluciones y consultas de lectores.'),
  (4, N'Auxiliar de biblioteca', N'Apoya la organización y el orden de los ejemplares.'),
  (5, N'Cajero', N'Registra cobros y emite facturas en caja.'),
  (6, N'Vendedor de mostrador', N'Asesora y vende libros a los clientes.'),
  (7, N'Encargado de inventario', N'Controla existencias y movimientos de inventario.'),
  (8, N'Analista de compras', N'Gestiona cotizaciones y compras a proveedores.'),
  (9, N'Contador', N'Lleva la contabilidad y los reportes financieros.'),
  (10, N'Asistente administrativo', N'Apoya tareas administrativas y de archivo.'),
  (11, N'Coordinador de préstamos', N'Supervisa el proceso de préstamos y devoluciones.'),
  (12, N'Encargado de atención al cliente', N'Resuelve consultas, reclamos y sugerencias.'),
  (13, N'Técnico de sistemas', N'Mantiene los equipos y el sistema informático.'),
  (14, N'Supervisor de almacén', N'Supervisa la recepción y el resguardo de mercadería.'),
  (15, N'Archivista', N'Cataloga y conserva el material bibliográfico.');
SET IDENTITY_INSERT dbo.cargo OFF;
