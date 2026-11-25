CREATE TABLE dbo.inventariosucursal (
    id INT IDENTITY(1,1) NOT NULL,
    sucursal_id INT NOT NULL,
    libro_id INT NOT NULL,
    cantidad_disponible INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_disponible DEFAULT 0,
    cantidad_danada INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_danada DEFAULT 0,
    cantidad_reservada INT NOT NULL CONSTRAINT DF_inventariosucursal_cantidad_reservada DEFAULT 0,
    fecha_actualizacion DATETIME2(0) NOT NULL CONSTRAINT DF_inventariosucursal_fecha_actualizacion DEFAULT GETDATE(),
    CONSTRAINT PK_inventariosucursal PRIMARY KEY (id),
    CONSTRAINT UQ_inventariosucursal_sucursal_id_libro_id UNIQUE (sucursal_id, libro_id),
    CONSTRAINT fk_inventariosucursal_libro FOREIGN KEY (libro_id) REFERENCES dbo.libro (id),
    CONSTRAINT fk_inventariosucursal_sucursal FOREIGN KEY (sucursal_id) REFERENCES dbo.sucursal (id)
);

GO

CREATE INDEX IX_inventariosucursal_libro_id ON dbo.inventariosucursal (libro_id);
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Resume las cantidades de libros por sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador único del registro de inventario por sucursal y libro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador de la sucursal relacionada con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'sucursal_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Identificador del libro relacionado con el registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'libro_id';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades disponibles en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_disponible';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades dañadas registradas en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_danada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Cantidad de unidades reservadas en la sucursal.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'cantidad_reservada';
EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha y hora de la última actualización del registro.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'inventariosucursal', @level2type = N'COLUMN', @level2name = N'fecha_actualizacion';

GO

CREATE TRIGGER dbo.trg_inventariosucursal_fecha_actualizacion
ON dbo.inventariosucursal
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 OR UPDATE(fecha_actualizacion) RETURN;
    UPDATE t
       SET fecha_actualizacion = GETDATE()
      FROM dbo.inventariosucursal AS t
      INNER JOIN inserted AS i ON i.id = t.id;
END;
GO
