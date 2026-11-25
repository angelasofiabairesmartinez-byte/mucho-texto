-- formapago
SET IDENTITY_INSERT dbo.formapago ON;
INSERT INTO dbo.formapago (id, nombre) VALUES
  (1, N'Efectivo'),
  (2, N'Tarjeta de crédito'),
  (3, N'Tarjeta de débito'),
  (4, N'Transferencia bancaria'),
  (5, N'Cheque'),
  (6, N'Depósito bancario'),
  (7, N'Billetera móvil'),
  (8, N'Pago en línea'),
  (9, N'Vale de regalo'),
  (10, N'Nota de crédito'),
  (11, N'Pago mixto'),
  (12, N'Pago a plazos'),
  (13, N'Código QR'),
  (14, N'Cupón de canje'),
  (15, N'Pago contra entrega');
SET IDENTITY_INSERT dbo.formapago OFF;
