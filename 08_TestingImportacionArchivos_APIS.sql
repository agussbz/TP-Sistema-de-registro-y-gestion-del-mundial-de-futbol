-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Prueba de APIS e Importacion de Archivos 

USE DB_Mundial_2026
GO

-- ==================================================
-- API: Transformación Moneda
-- ==================================================

DECLARE @Resultado DECIMAL(18,2);

EXEC publicidad.ConvertirMonedaAUSD
    @Monto = 15370.10, 
    @MonedaOrigen = 'ARS', 
    @MontoConvertido = @Resultado OUTPUT;

PRINT CONCAT('Monto convertido a USD: ', @Resultado);
GO

-- Otro ejemplo
DECLARE @Resultado2 DECIMAL(18,2);
EXEC publicidad.ConvertirMonedaAUSD
    @Monto = 10.0, 
    @MonedaOrigen = 'EUR', 
    @MontoConvertido = @Resultado2 OUTPUT;

PRINT CONCAT('Monto convertido a USD: ', @Resultado2);
GO

-- ==================================================
-- API: Consultar feriados
-- ==================================================

DECLARE @Resultado BIT;
DECLARE @Descripcion VARCHAR(100);

EXEC publicidad.SP_VerificarFeriadoMercado
    @CodigoPais = 'US',
    @Anio = 2026,
    @FechaPartido = '2026-07-04',
    @EsFeriado = @Resultado OUTPUT,
    @NombreFeriado = @Descripcion OUTPUT;

IF @Resultado = 1
    PRINT CONCAT('Es feriado. Motivo: ', @Descripcion);
ELSE
    PRINT 'Es un día hábil normal.';
GO

-- Otro ejemplo
DECLARE @Resultado BIT;
DECLARE @Descripcion VARCHAR(100);

EXEC publicidad.SP_VerificarFeriadoMercado
    @CodigoPais = 'AR',
    @Anio = 2026,
    @FechaPartido = '2026-05-25',
    @EsFeriado = @Resultado OUTPUT,
    @NombreFeriado = @Descripcion OUTPUT;

IF @Resultado = 1
    PRINT CONCAT('Es feriado. Motivo: ', @Descripcion);
ELSE
    PRINT 'Es un día hábil normal.';
GO


-- ===============================
-- torneo.SP_ImportarFixture_XML
-- ===============================

EXEC sp_configure 'show advanced options', 1;	
RECONFIGURE;
GO
EXEC sp_configure 'Ole Automation Procedures', 1;	
RECONFIGURE;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'FinalesArbitrosCompleto')
BEGIN
    CREATE TABLE torneo.FinalesArbitrosCompleto (
        FinalID INT IDENTITY(1,1) PRIMARY KEY,
        Anio INT NOT NULL,
        Referee VARCHAR(300) NOT NULL,
        AssistantReferees VARCHAR(500) NULL,
        FourthOfficial VARCHAR(300) NULL,
        ReserveFifthOfficial VARCHAR(300) NULL,
        VARAndAssistantVARs VARCHAR(500) NULL,
        FechaImportacion DATETIME DEFAULT GETDATE(),
        CONSTRAINT UQ_Final_AnioCompleto UNIQUE (Anio)
    );
END
GO

EXEC torneo.sp_ImportarFinalesArbitrosWikipediaCompleto;
GO

SELECT Anio, Referee, AssistantReferees, FourthOfficial, ReserveFifthOfficial, VARAndAssistantVARs
FROM torneo.FinalesArbitrosCompleto
ORDER BY Anio ASC;
GO

--==========================
-- IMPORTACION DE ARBITROS
--==========================

-- Antes de la importacion

SELECT COUNT(*) AS TotalAntes FROM reglamento.Arbitro;

DECLARE @RutaArbitros NVARCHAR(500) = 'C:\Importacion\referees.csv';
EXEC reglamento.SP_ImportarArbitros_CSV @RutaArchivo = @RutaArbitros;
GO

-- Despues de la importacion

SELECT COUNT(*) AS TotalDespues FROM reglamento.Arbitro;
SELECT TOP 10 p.Nombre, p.Apellido, a.Pais, a.RolArbitral
FROM reglamento.Arbitro a
JOIN torneo.Persona p ON a.PersonaID = p.PersonaID;

--==========================
-- IMPORTACION DE JUGADORES
--==========================

-- Antes de la importacion

SELECT COUNT(*) AS TotalPersonasAntes FROM torneo.Persona;
SELECT COUNT(*) AS TotalJugadoresAntes FROM torneo.Jugador;

DECLARE @RutaJugadores NVARCHAR(500) = 'C:\Importacion\players.csv';
EXEC torneo.SP_ImportarJugadores_CSV @RutaArchivo = @RutaJugadores;
GO

-- Despues de la importacion

SELECT COUNT(*) AS TotalPersonasDespues FROM torneo.Persona;
SELECT TOP 10 PersonaID, Nombre, Apellido, FechaNacimiento
FROM torneo.Persona
ORDER BY PersonaID DESC;