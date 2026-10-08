
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de la Base de Datos y Esquemas

use master
go

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_Mundial_2026')
BEGIN
	CREATE DATABASE DB_Mundial_2026
	COLLATE Latin1_General_CI_AI;
END
go

use DB_Mundial_2026
go

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'torneo')
BEGIN
	EXEC('CREATE SCHEMA torneo')
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'publicidad')
BEGIN
	EXEC('CREATE SCHEMA publicidad')
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'reglas')
BEGIN
	EXEC('CREATE SCHEMA reglas')
END
GO