/* ============================================================
   Base de datos: biblioteca_libreria (Mucho Texto)
   Motor: Microsoft SQL Server 2017 o superior
   Bases de Datos I - Segunda entrega - Archivo 2
   Estándar de nombres: tablas y campos en minúsculas y singular;
   PK_, UQ_, fk_, CK_, DF_, IX_, vw_, fn_, trg_
   ============================================================ */

SET NOCOUNT ON;
GO

USE master;
GO

IF DB_ID(N'biblioteca_libreria') IS NOT NULL
BEGIN
    ALTER DATABASE biblioteca_libreria SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE biblioteca_libreria;
END
GO

CREATE DATABASE biblioteca_libreria COLLATE Latin1_General_100_CI_AI;
GO
