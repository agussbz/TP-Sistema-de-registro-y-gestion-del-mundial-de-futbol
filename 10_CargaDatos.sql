
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando

-- Fecha de entrega: 20/11/2026

-- Objetivo: Carga de Datos Faltantes

USE DB_Mundial_2026
GO

SET NOCOUNT ON;
SET DATEFORMAT ymd;
GO

IF OBJECT_ID('tempdb..#PaisSeed') IS NOT NULL DROP TABLE #PaisSeed;
IF OBJECT_ID('tempdb..#SedeSeed') IS NOT NULL DROP TABLE #SedeSeed;
IF OBJECT_ID('tempdb..#Equipo') IS NOT NULL DROP TABLE #Equipo;
IF OBJECT_ID('tempdb..#PersonaSeed') IS NOT NULL DROP TABLE #PersonaSeed;
IF OBJECT_ID('tempdb..#ArbSeed') IS NOT NULL DROP TABLE #ArbSeed;
IF OBJECT_ID('tempdb..#ArbIdioma') IS NOT NULL DROP TABLE #ArbIdioma;
IF OBJECT_ID('tempdb..#AnunSeed') IS NOT NULL DROP TABLE #AnunSeed;
IF OBJECT_ID('tempdb..#CampSeed') IS NOT NULL DROP TABLE #CampSeed;
IF OBJECT_ID('tempdb..#PiezaSeed') IS NOT NULL DROP TABLE #PiezaSeed;
IF OBJECT_ID('tempdb..#InteresSeed') IS NOT NULL DROP TABLE #InteresSeed;
IF OBJECT_ID('tempdb..#Fixture') IS NOT NULL DROP TABLE #Fixture;
IF OBJECT_ID('tempdb..#TarjetaPlan') IS NOT NULL DROP TABLE #TarjetaPlan;
IF OBJECT_ID('tempdb..#GolEspecial') IS NOT NULL DROP TABLE #GolEspecial;
IF OBJECT_ID('tempdb..#GolPlan') IS NOT NULL DROP TABLE #GolPlan;
IF OBJECT_ID('tempdb..#SubPlantilla') IS NOT NULL DROP TABLE #SubPlantilla;
IF OBJECT_ID('tempdb..#SubEspecial') IS NOT NULL DROP TABLE #SubEspecial;
IF OBJECT_ID('tempdb..#SubFinal') IS NOT NULL DROP TABLE #SubFinal;
IF OBJECT_ID('tempdb..#EquipoPartido') IS NOT NULL DROP TABLE #EquipoPartido;
IF OBJECT_ID('tempdb..#Sancion') IS NOT NULL DROP TABLE #Sancion;
IF OBJECT_ID('tempdb..#Excluido') IS NOT NULL DROP TABLE #Excluido;
IF OBJECT_ID('tempdb..#Alineacion') IS NOT NULL DROP TABLE #Alineacion;
GO

-- ===============================================================
-- 1. PAISES (mercados publicitarios), TIPOS DE TARJETA E IDIOMAS
-- ===============================================================

PRINT '--- 1. Paises, tarjetas e idiomas ---';

DECLARE @NormalizarPBIExistente BIT = 1;

CREATE TABLE #PaisSeed (
    Nombre VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    PBI    DECIMAL(18,2) NOT NULL,
    Huso   VARCHAR(10) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #PaisSeed (Nombre, PBI, Huso) VALUES
    (N'Argentina', 13650.00, 'UTC-3'),
    (N'Brasil', 10400.00, 'UTC-3'),
    (N'Uruguay', 21000.00, 'UTC-3'),
    (N'Paraguay', 6100.00, 'UTC-3'),
    (N'Chile', 17000.00, 'UTC-4'),
    (N'Colombia', 6950.00, 'UTC-5'),
    (N'Perú', 7300.00, 'UTC-5'),
    (N'México', 13800.00, 'UTC-6'),
    (N'Estados Unidos', 82000.00, 'UTC-4'),
    (N'Canadá', 53400.00, 'UTC-4'),
    (N'España', 32700.00, 'UTC+2'),
    (N'Francia', 44400.00, 'UTC+2'),
    (N'Alemania', 52800.00, 'UTC+2'),
    (N'Italia', 38400.00, 'UTC+2'),
    (N'Países Bajos', 62100.00, 'UTC+2'),
    (N'Inglaterra', 48900.00, 'UTC+1'),
    (N'Portugal', 27300.00, 'UTC+1'),
    (N'Marruecos', 3900.00, 'UTC+1'),
    (N'Senegal', 1700.00, 'UTC-0'),
    (N'Nigeria', 1100.00, 'UTC+1'),
    (N'Egipto', 3500.00, 'UTC+3'),
    (N'Sudáfrica', 6200.00, 'UTC+2'),
    (N'Japón', 33800.00, 'UTC+9'),
    (N'Corea del Sur', 33100.00, 'UTC+9'),
    (N'Arabia Saudita', 32400.00, 'UTC+3'),
    (N'Catar', 81900.00, 'UTC+3'),
    (N'China', 12600.00, 'UTC+8'),
    (N'Australia', 65000.00, 'UTC+10'),
    (N'República Checa', 30500.00, 'UTC+2'),
    (N'Bosnia y Herzegovina', 8300.00, 'UTC+2'),
    (N'Suiza', 104000.00, 'UTC+2'),
    (N'Haití', 1700.00, 'UTC-4'),
    (N'Escocia', 45000.00, 'UTC+1'),
    (N'Turquía', 15500.00, 'UTC+3'),
    (N'Curazao', 22000.00, 'UTC-4'),
    (N'Costa de Marfil', 2700.00, 'UTC+0'),
    (N'Ecuador', 6600.00, 'UTC-5'),
    (N'Suecia', 57000.00, 'UTC+2'),
    (N'Túnez', 4200.00, 'UTC+1'),
    (N'Bélgica', 56000.00, 'UTC+2'),
    (N'Irán', 4500.00, 'UTC+3:30'),
    (N'Nueva Zelanda', 48000.00, 'UTC+12'),
    (N'Cabo Verde', 4900.00, 'UTC-1'),
    (N'Irak', 5900.00, 'UTC+3'),
    (N'Noruega', 90000.00, 'UTC+2'),
    (N'Argelia', 5600.00, 'UTC+1'),
    (N'Austria', 58000.00, 'UTC+2'),
    (N'Jordania', 4600.00, 'UTC+3'),
    (N'RD Congo', 700.00, 'UTC+1'),
    (N'Uzbekistán', 3100.00, 'UTC+5'),
    (N'Croacia', 24000.00, 'UTC+2'),
    (N'Ghana', 2300.00, 'UTC+0'),
    (N'Panamá', 19000.00, 'UTC-5');

INSERT INTO torneo.Pais (Nombre, PBI, HusoHorario)
SELECT s.Nombre, s.PBI, s.Huso
FROM #PaisSeed s
WHERE NOT EXISTS (SELECT 1 FROM torneo.Pais p WHERE p.Nombre = s.Nombre);

IF @NormalizarPBIExistente = 1
BEGIN
    UPDATE p
       SET p.PBI = s.PBI, p.HusoHorario = s.Huso
      FROM torneo.Pais p
      JOIN #PaisSeed s ON s.Nombre = p.Nombre
     WHERE p.PBI <> s.PBI OR p.HusoHorario <> s.Huso;
END

INSERT INTO reglamento.Tarjeta (Tipo)
SELECT t.Tipo FROM (VALUES ('Amarilla'), ('Roja')) t(Tipo)
WHERE NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta x WHERE x.Tipo = t.Tipo);

INSERT INTO torneo.Idioma (Nombre)
SELECT i.Nombre FROM (VALUES (N'Español'), (N'Ingles'), (N'Frances'), (N'Aleman'), (N'Portugues'), (N'Italiano'), (N'Arabe')) i(Nombre)
WHERE NOT EXISTS (SELECT 1 FROM torneo.Idioma x WHERE x.Nombre = i.Nombre);

SELECT COUNT(*) AS TotalPaises FROM torneo.Pais;
GO

-- ======================================
-- 2. SEDES, SELECCIONES Y CONVOCATORIAS
-- ======================================

PRINT '--- 2. Sedes, selecciones y convocatorias ---';

CREATE TABLE #SedeSeed (
    NombreEstadio VARCHAR(70)  COLLATE DATABASE_DEFAULT NOT NULL,
    Ciudad        VARCHAR(100) COLLATE DATABASE_DEFAULT NOT NULL,
    Pais          VARCHAR(50)  COLLATE DATABASE_DEFAULT NOT NULL,
    Capacidad     INT NOT NULL,
    Huso          VARCHAR(50)  COLLATE DATABASE_DEFAULT NOT NULL,
    Latitud       DECIMAL(9,6) NOT NULL,
    Longitud      DECIMAL(9,6) NOT NULL
);
INSERT INTO #SedeSeed (NombreEstadio, Ciudad, Pais, Capacidad, Huso, Latitud, Longitud) VALUES
    (N'Estadio Azteca', N'Ciudad de Mexico', N'México', 83264, 'UTC-6', 19.302837, -99.150803),
    (N'MetLife Stadium', N'Nueva York', N'Estados Unidos', 82500, 'UTC-4', 40.813477, -74.074951),
    (N'SoFi Stadium', N'Los Angeles', N'Estados Unidos', 70240, 'UTC-7', 33.953438, -118.339447),
    (N'AT&T Stadium', N'Dallas', N'Estados Unidos', 94000, 'UTC-5', 32.748138, -97.093231),
    (N'Mercedes-Benz Stadium', N'Atlanta', N'Estados Unidos', 71000, 'UTC-4', 33.755371, -84.401436),
    (N'Hard Rock Stadium', N'Miami', N'Estados Unidos', 64767, 'UTC-4', 25.957830, -80.239326),
    (N'BMO Field', N'Toronto', N'Canadá', 45000, 'UTC-4', 43.633087, -79.418961),
    (N'BC Place', N'Vancouver', N'Canadá', 54500, 'UTC-7', 49.276646, -123.112564),
    (N'Estadio BBVA', N'Monterrey', N'México', 53500, 'UTC-6', 25.669132, -100.244621),
    (N'Estadio Akron', N'Guadalajara', N'México', 48071, 'UTC-6', 20.681721, -103.463135),
    (N'Lumen Field', N'Seattle', N'Estados Unidos', 69000, 'UTC-7', 47.595135, -122.331917),
    (N'NRG Stadium', N'Houston', N'Estados Unidos', 72220, 'UTC-5', 29.684702, -95.410965),
    (N'Gillette Stadium', N'Foxborough', N'Estados Unidos', 65878, 'UTC-4', 42.090790, -71.264404),
    (N'Lincoln Financial Field', N'Filadelfia', N'Estados Unidos', 67594, 'UTC-4', 39.901325, -75.167862),
    (N'Arrowhead Stadium', N'Kansas City', N'Estados Unidos', 76416, 'UTC-5', 39.048855, -94.484474),
    (N'Levi''s Stadium', N'Santa Clara', N'Estados Unidos', 68500, 'UTC-7', 37.403297, -121.969765);

INSERT INTO torneo.Sede (NombreEstadio, Ciudad, Pais, Capacidad, HusoHorario, Latitud, Longitud)
SELECT s.NombreEstadio, s.Ciudad, s.Pais, s.Capacidad, s.Huso, s.Latitud, s.Longitud
FROM #SedeSeed s
WHERE NOT EXISTS (SELECT 1 FROM torneo.Sede x WHERE x.NombreEstadio = s.NombreEstadio);

-- Actualizar coordenadas de las sedes existentes
UPDATE x
SET x.Latitud = s.Latitud,
    x.Longitud = s.Longitud
FROM torneo.Sede x
INNER JOIN #SedeSeed s
    ON x.NombreEstadio = s.NombreEstadio;

CREATE TABLE #Equipo (
    Idx            INT NOT NULL PRIMARY KEY,
    Pais           VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Confederacion  VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Grupo          CHAR(1) NOT NULL,
    SeleccionID    INT NULL,
    ConvocatoriaID INT NULL
);
INSERT INTO #Equipo (Idx, Pais, Confederacion, Grupo) VALUES
    (1, N'México', 'CONCACAF', 'A'),
    (2, N'Argentina', 'CONMEBOL', 'J'),
    (3, N'Marruecos', 'CAF', 'C'),
    (4, N'Japón', 'AFC', 'F'),
    (5, N'Estados Unidos', 'CONCACAF', 'D'),
    (6, N'Brasil', 'CONMEBOL', 'C'),
    (7, N'Senegal', 'CAF', 'I'),
    (8, N'Corea del Sur', 'AFC', 'A'),
    (9, N'Canadá', 'CONCACAF', 'B'),
    (10, N'España', 'UEFA', 'H'),
    (11, N'Uruguay', 'CONMEBOL', 'H'),
    (12, N'Portugal', 'UEFA', 'K'),
    (13, N'Francia', 'UEFA', 'I'),
    (14, N'Alemania', 'UEFA', 'E'),
    (15, N'Inglaterra', 'UEFA', 'L'),
    (16, N'Colombia', 'CONMEBOL', 'K'),
    (17, N'Sudáfrica', 'CAF', 'A'),
    (18, N'República Checa', 'UEFA', 'A'),
    (19, N'Bosnia y Herzegovina', 'UEFA', 'B'),
    (20, N'Catar', 'AFC', 'B'),
    (21, N'Suiza', 'UEFA', 'B'),
    (22, N'Haití', 'CONCACAF', 'C'),
    (23, N'Escocia', 'UEFA', 'C'),
    (24, N'Paraguay', 'CONMEBOL', 'D'),
    (25, N'Australia', 'AFC', 'D'),
    (26, N'Turquía', 'UEFA', 'D'),
    (27, N'Curazao', 'CONCACAF', 'E'),
    (28, N'Costa de Marfil', 'CAF', 'E'),
    (29, N'Ecuador', 'CONMEBOL', 'E'),
    (30, N'Países Bajos', 'UEFA', 'F'),
    (31, N'Suecia', 'UEFA', 'F'),
    (32, N'Túnez', 'CAF', 'F'),
    (33, N'Bélgica', 'UEFA', 'G'),
    (34, N'Egipto', 'CAF', 'G'),
    (35, N'Irán', 'AFC', 'G'),
    (36, N'Nueva Zelanda', 'OFC', 'G'),
    (37, N'Cabo Verde', 'CAF', 'H'),
    (38, N'Arabia Saudita', 'AFC', 'H'),
    (39, N'Irak', 'AFC', 'I'),
    (40, N'Noruega', 'UEFA', 'I'),
    (41, N'Argelia', 'CAF', 'J'),
    (42, N'Austria', 'UEFA', 'J'),
    (43, N'Jordania', 'AFC', 'J'),
    (44, N'RD Congo', 'CAF', 'K'),
    (45, N'Uzbekistán', 'AFC', 'K'),
    (46, N'Croacia', 'UEFA', 'L'),
    (47, N'Ghana', 'CAF', 'L'),
    (48, N'Panamá', 'CONCACAF', 'L');

INSERT INTO torneo.Seleccion (Pais, Confederacion, Grupo)
SELECT e.Pais, e.Confederacion, e.Grupo
FROM #Equipo e
WHERE NOT EXISTS (
    SELECT 1 
    FROM torneo.Seleccion s 
    WHERE s.Pais = e.Pais
);

UPDATE e
   SET SeleccionID = (SELECT MIN(s.SeleccionID) FROM torneo.Seleccion s WHERE s.Pais = e.Pais)
  FROM #Equipo e;

INSERT INTO torneo.Convocatoria (SeleccionID)
SELECT e.SeleccionID
FROM #Equipo e
WHERE e.SeleccionID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM torneo.Convocatoria c WHERE c.SeleccionID = e.SeleccionID);

UPDATE e
   SET ConvocatoriaID = (SELECT MIN(c.ConvocatoriaID) FROM torneo.Convocatoria c WHERE c.SeleccionID = e.SeleccionID)
  FROM #Equipo e;

SELECT COUNT(*) AS TotalSedes, COUNT(DISTINCT HusoHorario) AS HusosDistintos FROM torneo.Sede;
SELECT Idx, Pais, Grupo, SeleccionID, ConvocatoriaID FROM #Equipo ORDER BY Idx;
GO

-- ==============================================================================
-- 3. PERSONAS, JUGADORES (23 por seleccion) Y CUERPO TECNICO (DT + 2 asistentes)
-- ==============================================================================

PRINT '--- 3. Personas, jugadores y cuerpo tecnico ---';

CREATE TABLE #PersonaSeed (
    Tipo      CHAR(1) NOT NULL,                   
    EquipoIdx INT NOT NULL,
    Slot      INT NOT NULL,
    Nombre    VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Apellido  VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    FechaNac  DATE NOT NULL,
    Club      VARCHAR(50) COLLATE DATABASE_DEFAULT NULL,
    Posicion  VARCHAR(50) COLLATE DATABASE_DEFAULT NULL,
    Rol       VARCHAR(50) COLLATE DATABASE_DEFAULT NULL,
    PersonaID INT NULL
);

INSERT INTO #PersonaSeed (Tipo, EquipoIdx, Slot, Nombre, Apellido, FechaNac, Club, Posicion, Rol) VALUES
    ('J', 1, 1, N'Tomás', N'Montenegro', '19980925', N'Peñarol', N'Arquero', NULL),
    ('J', 1, 2, N'Ezequiel', N'Mansilla', '20010410', N'Nacional', N'Defensor', NULL),
    ('J', 1, 3, N'Mauricio', N'Ibarra', '20041123', N'Club América', N'Defensor', NULL),
    ('J', 1, 4, N'Federico', N'Rojas', '19920608', N'Pumas UNAM', N'Defensor', NULL),
    ('J', 1, 5, N'Nicolás', N'Aguirre', '19950121', N'Atlético Nacional', N'Defensor', NULL),
    ('J', 1, 6, N'Joaquín', N'Ledesma', '19980806', N'Millonarios', N'Mediocampista', NULL),
    ('J', 1, 7, N'Maximiliano', N'Quiroga', '20010319', N'Sevilla', N'Delantero', NULL),
    ('J', 1, 8, N'Leandro', N'Molina', '20041004', N'Real Sociedad', N'Mediocampista', NULL),
    ('J', 1, 9, N'Esteban', N'Domínguez', '19920517', N'River Plate', N'Delantero', NULL),
    ('J', 1, 10, N'Lucas', N'Cabrera', '19951202', N'Boca Juniors', N'Mediocampista', NULL),
    ('J', 1, 11, N'Emiliano', N'Ferreyra', '19980715', N'Racing Club', N'Delantero', NULL),
    ('J', 1, 12, N'Rodrigo', N'Luna', '20010228', N'Estudiantes', N'Arquero', NULL),
    ('J', 1, 13, N'Cristian', N'Sosa', '20040913', N'Peñarol', N'Defensor', NULL),
    ('J', 1, 14, N'Alejandro', N'Villalba', '19920426', N'Nacional', N'Defensor', NULL),
    ('J', 1, 15, N'Facundo', N'Barrios', '19951111', N'Club América', N'Defensor', NULL),
    ('J', 1, 16, N'Gonzalo', N'Gutiérrez', '19980624', N'Pumas UNAM', N'Defensor', NULL),
    ('J', 1, 17, N'Sebastián', N'Medina', '20010109', N'Atlético Nacional', N'Mediocampista', NULL),
    ('J', 1, 18, N'Ramiro', N'Peralta', '20040822', N'Millonarios', N'Mediocampista', NULL),
    ('J', 1, 19, N'Santiago', N'Roldán', '19920307', N'Sevilla', N'Mediocampista', NULL),
    ('J', 1, 20, N'Agustín', N'Acosta', '19951020', N'Real Sociedad', N'Mediocampista', NULL),
    ('J', 1, 21, N'Franco', N'Paz', '19980505', N'River Plate', N'Delantero', NULL),
    ('J', 1, 22, N'Bruno', N'Correa', '20011218', N'Boca Juniors', N'Delantero', NULL),
    ('J', 1, 23, N'Damián', N'Benítez', '20040703', N'Racing Club', N'Arquero', NULL),
    ('T', 1, 30, N'Sebastián', N'Villalba', '19750804', NULL, NULL, N'Director Tecnico'),
    ('T', 1, 31, N'Ramiro', N'Barrios', '19600113', NULL, NULL, N'Asistente'),
    ('T', 1, 32, N'Santiago', N'Gutiérrez', '19670622', NULL, NULL, N'Asistente'),
    ('J', 2, 1, N'Joaquín', N'Luna', '20031008', N'Pumas UNAM', N'Arquero', NULL),
    ('J', 2, 2, N'Maximiliano', N'Sosa', '19910521', N'Atlético Nacional', N'Defensor', NULL),
    ('J', 2, 3, N'Leandro', N'Villalba', '19941206', N'Millonarios', N'Defensor', NULL),
    ('J', 2, 4, N'Esteban', N'Barrios', '19970719', N'Sevilla', N'Defensor', NULL),
    ('J', 2, 5, N'Lucas', N'Gutiérrez', '20000204', N'Real Sociedad', N'Defensor', NULL),
    ('J', 2, 6, N'Emiliano', N'Medina', '20030917', N'River Plate', N'Mediocampista', NULL),
    ('J', 2, 7, N'Rodrigo', N'Peralta', '19910402', N'Boca Juniors', N'Delantero', NULL),
    ('J', 2, 8, N'Cristian', N'Roldán', '19941115', N'Racing Club', N'Mediocampista', NULL),
    ('J', 2, 9, N'Alejandro', N'Acosta', '19970628', N'Estudiantes', N'Delantero', NULL),
    ('J', 2, 10, N'Facundo', N'Paz', '20000113', N'Peñarol', N'Mediocampista', NULL),
    ('J', 2, 11, N'Gonzalo', N'Correa', '20030826', N'Nacional', N'Delantero', NULL),
    ('J', 2, 12, N'Sebastián', N'Benítez', '19910311', N'Club América', N'Arquero', NULL),
    ('J', 2, 13, N'Ramiro', N'Herrera', '19941024', N'Pumas UNAM', N'Defensor', NULL),
    ('J', 2, 14, N'Santiago', N'Montenegro', '19970509', N'Atlético Nacional', N'Defensor', NULL),
    ('J', 2, 15, N'Agustín', N'Mansilla', '20001222', N'Millonarios', N'Defensor', NULL),
    ('J', 2, 16, N'Franco', N'Ibarra', '20030707', N'Sevilla', N'Defensor', NULL),
    ('J', 2, 17, N'Bruno', N'Rojas', '19910220', N'Real Sociedad', N'Mediocampista', NULL),
    ('J', 2, 18, N'Damián', N'Aguirre', '19940905', N'River Plate', N'Mediocampista', NULL),
    ('J', 2, 19, N'Matías', N'Ledesma', '19970418', N'Boca Juniors', N'Mediocampista', NULL),
    ('J', 2, 20, N'Tomás', N'Quiroga', '20001103', N'Racing Club', N'Mediocampista', NULL),
    ('J', 2, 21, N'Ezequiel', N'Molina', '20030616', N'Estudiantes', N'Delantero', NULL),
    ('J', 2, 22, N'Mauricio', N'Domínguez', '19910101', N'Peñarol', N'Delantero', NULL),
    ('J', 2, 23, N'Federico', N'Cabrera', '19940814', N'Nacional', N'Arquero', NULL),
    ('T', 2, 30, N'Bruno', N'Montenegro', '19780917', NULL, NULL, N'Director Tecnico'),
    ('T', 2, 31, N'Damián', N'Mansilla', '19630226', NULL, NULL, N'Asistente'),
    ('T', 2, 32, N'Matías', N'Ibarra', '19700707', NULL, NULL, N'Asistente'),
    ('J', 3, 1, N'Mamadou', N'El Amrani', '19931119', N'Generation Foot', N'Arquero', NULL),
    ('J', 3, 2, N'Abdoulaye', N'Diop', '19960604', N'Jaraaf', N'Defensor', NULL),
    ('J', 3, 3, N'Yassine', N'Mbaye', '19990117', N'Ajax', N'Defensor', NULL),
    ('J', 3, 4, N'Adama', N'Touré', '20020802', N'Anderlecht', N'Defensor', NULL),
    ('J', 3, 5, N'Ismail', N'Alaoui', '19900315', N'Lens', N'Defensor', NULL),
    ('J', 3, 6, N'Ousmane', N'Gueye', '19931028', N'Olympique Marseille', N'Mediocampista', NULL),
    ('J', 3, 7, N'Idrissa', N'Faye', '19960513', N'Wydad Casablanca', N'Delantero', NULL),
    ('J', 3, 8, N'Badr', N'Haddad', '19991226', N'Raja Casablanca', N'Mediocampista', NULL),
    ('J', 3, 9, N'Youssef', N'Ndiaye', '20020711', N'Generation Foot', N'Delantero', NULL),
    ('J', 3, 10, N'Bilal', N'Cissé', '19900224', N'Jaraaf', N'Mediocampista', NULL),
    ('J', 3, 11, N'Cheikh', N'Lahlou', '19930909', N'Ajax', N'Delantero', NULL),
    ('J', 3, 12, N'Pape', N'Chakir', '19960422', N'Anderlecht', N'Arquero', NULL),
    ('J', 3, 13, N'Lamine', N'Diallo', '19991107', N'Lens', N'Defensor', NULL),
    ('J', 3, 14, N'Karim', N'Seck', '20020620', N'Olympique Marseille', N'Defensor', NULL),
    ('J', 3, 15, N'Omar', N'Bouzid', '19900105', N'Wydad Casablanca', N'Defensor', NULL),
    ('J', 3, 16, N'Ibrahima', N'Fall', '19930818', N'Raja Casablanca', N'Defensor', NULL),
    ('J', 3, 17, N'Samir', N'Kane', '19960303', N'Generation Foot', N'Mediocampista', NULL),
    ('J', 3, 18, N'Modou', N'Benali', '19991016', N'Jaraaf', N'Mediocampista', NULL),
    ('J', 3, 19, N'Amine', N'Idrissi', '20020501', N'Ajax', N'Mediocampista', NULL),
    ('J', 3, 20, N'Zakaria', N'Sow', '19901214', N'Anderlecht', N'Mediocampista', NULL),
    ('J', 3, 21, N'Moussa', N'Badji', '19930727', N'Lens', N'Delantero', NULL),
    ('J', 3, 22, N'Reda', N'Tazi', '19960212', N'Olympique Marseille', N'Delantero', NULL),
    ('J', 3, 23, N'Souleymane', N'Sarr', '19990925', N'Wydad Casablanca', N'Arquero', NULL),
    ('T', 3, 30, N'Samir', N'Seck', '19811002', NULL, NULL, N'Director Tecnico'),
    ('T', 3, 31, N'Modou', N'Bouzid', '19660311', NULL, NULL, N'Asistente'),
    ('T', 3, 32, N'Amine', N'Fall', '19730820', NULL, NULL, N'Asistente'),
    ('J', 4, 1, N'Seo-jun', N'Yamamoto', '19981202', N'FC Seoul', N'Arquero', NULL),
    ('J', 4, 2, N'Tae-yang', N'Choi', '20010715', N'Celtic', N'Defensor', NULL),
    ('J', 4, 3, N'Ryota', N'Han', '20040228', N'Eintracht Frankfurt', N'Defensor', NULL),
    ('J', 4, 4, N'Haruto', N'Takahashi', '19920913', N'Kawasaki Frontale', N'Defensor', NULL),
    ('J', 4, 5, N'Yuto', N'Kim', '19950426', N'Yokohama F. Marinos', N'Defensor', NULL),
    ('J', 4, 6, N'Ji-ho', N'Yoon', '19981111', N'Urawa Reds', N'Mediocampista', NULL),
    ('J', 4, 7, N'Sung-min', N'Tanaka', '20010624', N'Jeonbuk Hyundai', N'Delantero', NULL),
    ('J', 4, 8, N'Jae-won', N'Nakamura', '20040109', N'Ulsan HD', N'Mediocampista', NULL),
    ('J', 4, 9, N'Kenji', N'Jung', '19920822', N'FC Seoul', N'Delantero', NULL),
    ('J', 4, 10, N'Daiki', N'Oh', '19950307', N'Celtic', N'Mediocampista', NULL),
    ('J', 4, 11, N'Hyun-woo', N'Watanabe', '19981020', N'Eintracht Frankfurt', N'Delantero', NULL),
    ('J', 4, 12, N'Riku', N'Lee', '20010505', N'Kawasaki Frontale', N'Arquero', NULL),
    ('J', 4, 13, N'Woo-jin', N'Jang', '20041218', N'Yokohama F. Marinos', N'Defensor', NULL),
    ('J', 4, 14, N'Takumi', N'Sato', '19920703', N'Urawa Reds', N'Defensor', NULL),
    ('J', 4, 15, N'Shota', N'Kobayashi', '19950216', N'Jeonbuk Hyundai', N'Defensor', NULL),
    ('J', 4, 16, N'Joon-ho', N'Kang', '19980901', N'Ulsan HD', N'Defensor', NULL),
    ('J', 4, 17, N'Kaito', N'Seo', '20010414', N'FC Seoul', N'Mediocampista', NULL),
    ('J', 4, 18, N'Hoon', N'Ito', '20041127', N'Celtic', N'Mediocampista', NULL),
    ('J', 4, 19, N'Ren', N'Park', '19920612', N'Eintracht Frankfurt', N'Mediocampista', NULL),
    ('J', 4, 20, N'Min-jun', N'Lim', '19950125', N'Kawasaki Frontale', N'Mediocampista', NULL),
    ('J', 4, 21, N'Dong-hyun', N'Suzuki', '19980810', N'Yokohama F. Marinos', N'Delantero', NULL),
    ('J', 4, 22, N'Naoki', N'Kato', '20010323', N'Urawa Reds', N'Delantero', NULL),
    ('J', 4, 23, N'Yuma', N'Cho', '20041008', N'Jeonbuk Hyundai', N'Arquero', NULL),
    ('T', 4, 30, N'Kaito', N'Sato', '19621115', NULL, NULL, N'Director Tecnico'),
    ('T', 4, 31, N'Hoon', N'Kobayashi', '19690424', NULL, NULL, N'Asistente'),
    ('T', 4, 32, N'Ren', N'Kang', '19760905', NULL, NULL, N'Asistente'),
    ('J', 5, 1, N'Connor', N'Palmer', '20030113', N'LA Galaxy', N'Arquero', NULL),
    ('J', 5, 2, N'Cole', N'Carter', '19910826', N'Seattle Sounders', N'Defensor', NULL),
    ('J', 5, 3, N'Marcus', N'Hughes', '19940311', N'Toronto FC', N'Defensor', NULL),
    ('J', 5, 4, N'Oliver', N'Reed', '19971024', N'Vancouver Whitecaps', N'Defensor', NULL),
    ('J', 5, 5, N'Mason', N'Dawson', '20000509', N'Arsenal', N'Defensor', NULL),
    ('J', 5, 6, N'Ryan', N'Ellis', '20031222', N'Chelsea', N'Mediocampista', NULL),
    ('J', 5, 7, N'Nathan', N'Parker', '19910707', N'Aston Villa', N'Delantero', NULL),
    ('J', 5, 8, N'Trevor', N'Sullivan', '19940220', N'Newcastle United', N'Mediocampista', NULL),
    ('J', 5, 9, N'Jack', N'Spencer', '19970905', N'LA Galaxy', N'Delantero', NULL),
    ('J', 5, 10, N'Logan', N'Bennett', '20000418', N'Seattle Sounders', N'Mediocampista', NULL),
    ('J', 5, 11, N'Tyler', N'Hayes', '20031103', N'Toronto FC', N'Delantero', NULL),
    ('J', 5, 12, N'Aaron', N'Holland', '19910616', N'Vancouver Whitecaps', N'Arquero', NULL),
    ('J', 5, 13, N'Colin', N'Radcliffe', '19940101', N'Arsenal', N'Defensor', NULL),
    ('J', 5, 14, N'Harry', N'Collins', '19970814', N'Chelsea', N'Defensor', NULL),
    ('J', 5, 15, N'Liam', N'Murray', '20000327', N'Aston Villa', N'Defensor', NULL),
    ('J', 5, 16, N'Jordan', N'Hartley', '20031012', N'Newcastle United', N'Defensor', NULL),
    ('J', 5, 17, N'Callum', N'Foster', '19910525', N'LA Galaxy', N'Mediocampista', NULL),
    ('J', 5, 18, N'Elliot', N'Graham', '19941210', N'Seattle Sounders', N'Mediocampista', NULL),
    ('J', 5, 19, N'Noah', N'Whitaker', '19970723', N'Toronto FC', N'Mediocampista', NULL),
    ('J', 5, 20, N'Owen', N'Walker', '20000208', N'Vancouver Whitecaps', N'Mediocampista', NULL),
    ('J', 5, 21, N'Dylan', N'Brooks', '20030921', N'Arsenal', N'Delantero', NULL),
    ('J', 5, 22, N'Declan', N'Fletcher', '19910406', N'Chelsea', N'Delantero', NULL),
    ('J', 5, 23, N'James', N'Barrett', '19941119', N'Aston Villa', N'Arquero', NULL),
    ('T', 5, 30, N'Callum', N'Collins', '19651228', NULL, NULL, N'Director Tecnico'),
    ('T', 5, 31, N'Elliot', N'Murray', '19720509', NULL, NULL, N'Asistente'),
    ('T', 5, 32, N'Noah', N'Hartley', '19791018', NULL, NULL, N'Asistente'),
    ('J', 6, 1, N'Felipe', N'Barbosa', '19930224', N'São Paulo', N'Arquero', NULL),
    ('J', 6, 2, N'André', N'Monteiro', '19960909', N'Benfica', N'Defensor', NULL),
    ('J', 6, 3, N'Miguel', N'Rodrigues', '19990422', N'Sporting CP', N'Defensor', NULL),
    ('J', 6, 4, N'Thiago', N'Gomes', '20021107', N'FC Porto', N'Defensor', NULL),
    ('J', 6, 5, N'Mateus', N'Mendes', '19900620', N'Braga', N'Defensor', NULL),
    ('J', 6, 6, N'Bruno', N'Pereira', '19930105', N'Flamengo', N'Mediocampista', NULL),
    ('J', 6, 7, N'Tiago', N'Araújo', '19960818', N'Palmeiras', N'Delantero', NULL),
    ('J', 6, 8, N'Gonçalo', N'Moreira', '19990303', N'Corinthians', N'Mediocampista', NULL),
    ('J', 6, 9, N'Gabriel', N'Silva', '20021016', N'São Paulo', N'Delantero', NULL),
    ('J', 6, 10, N'Caio', N'Almeida', '19900501', N'Benfica', N'Mediocampista', NULL),
    ('J', 6, 11, N'Guilherme', N'Martins', '19931214', N'Sporting CP', N'Delantero', NULL),
    ('J', 6, 12, N'Diogo', N'Freitas', '19960727', N'FC Porto', N'Arquero', NULL),
    ('J', 6, 13, N'Fábio', N'Costa', '19990212', N'Braga', N'Defensor', NULL),
    ('J', 6, 14, N'Rafael', N'Ribeiro', '20020925', N'Flamengo', N'Defensor', NULL),
    ('J', 6, 15, N'Leonardo', N'Teixeira', '19900410', N'Palmeiras', N'Defensor', NULL),
    ('J', 6, 16, N'Lucas', N'Santos', '19931123', N'Corinthians', N'Defensor', NULL),
    ('J', 6, 17, N'Ricardo', N'Nascimento', '19960608', N'São Paulo', N'Mediocampista', NULL),
    ('J', 6, 18, N'João', N'Rocha', '19990121', N'Benfica', N'Mediocampista', NULL),
    ('J', 6, 19, N'Diego', N'Cavalcanti', '20020806', N'Sporting CP', N'Mediocampista', NULL),
    ('J', 6, 20, N'Henrique', N'Ferreira', '19900319', N'FC Porto', N'Mediocampista', NULL),
    ('J', 6, 21, N'Rodrigo', N'Carvalho', '19931004', N'Braga', N'Delantero', NULL),
    ('J', 6, 22, N'Nuno', N'Cardoso', '19960517', N'Flamengo', N'Delantero', NULL),
    ('J', 6, 23, N'Pedro', N'Oliveira', '19991202', N'Palmeiras', N'Arquero', NULL),
    ('T', 6, 30, N'Ricardo', N'Ribeiro', '19680113', NULL, NULL, N'Director Tecnico'),
    ('T', 6, 31, N'João', N'Teixeira', '19750622', NULL, NULL, N'Asistente'),
    ('T', 6, 32, N'Diego', N'Santos', '19601103', NULL, NULL, N'Asistente'),
    ('J', 7, 1, N'Moussa', N'Badji', '19980307', N'Lens', N'Arquero', NULL),
    ('J', 7, 2, N'Reda', N'Tazi', '20011020', N'Olympique Marseille', N'Defensor', NULL),
    ('J', 7, 3, N'Souleymane', N'Sarr', '20040505', N'Wydad Casablanca', N'Defensor', NULL),
    ('J', 7, 4, N'Hamza', N'Thiam', '19921218', N'Raja Casablanca', N'Defensor', NULL),
    ('J', 7, 5, N'Mamadou', N'El Amrani', '19950703', N'Generation Foot', N'Defensor', NULL),
    ('J', 7, 6, N'Abdoulaye', N'Diop', '19980216', N'Jaraaf', N'Mediocampista', NULL),
    ('J', 7, 7, N'Yassine', N'Mbaye', '20010901', N'Ajax', N'Delantero', NULL),
    ('J', 7, 8, N'Adama', N'Touré', '20040414', N'Anderlecht', N'Mediocampista', NULL),
    ('J', 7, 9, N'Ismail', N'Alaoui', '19921127', N'Lens', N'Delantero', NULL),
    ('J', 7, 10, N'Ousmane', N'Gueye', '19950612', N'Olympique Marseille', N'Mediocampista', NULL),
    ('J', 7, 11, N'Idrissa', N'Faye', '19980125', N'Wydad Casablanca', N'Delantero', NULL),
    ('J', 7, 12, N'Badr', N'Haddad', '20010810', N'Raja Casablanca', N'Arquero', NULL),
    ('J', 7, 13, N'Youssef', N'Ndiaye', '20040323', N'Generation Foot', N'Defensor', NULL),
    ('J', 7, 14, N'Bilal', N'Cissé', '19921008', N'Jaraaf', N'Defensor', NULL),
    ('J', 7, 15, N'Cheikh', N'Lahlou', '19950521', N'Ajax', N'Defensor', NULL),
    ('J', 7, 16, N'Pape', N'Chakir', '19981206', N'Anderlecht', N'Defensor', NULL),
    ('J', 7, 17, N'Lamine', N'Diallo', '20010719', N'Lens', N'Mediocampista', NULL),
    ('J', 7, 18, N'Karim', N'Seck', '20040204', N'Olympique Marseille', N'Mediocampista', NULL),
    ('J', 7, 19, N'Omar', N'Bouzid', '19920917', N'Wydad Casablanca', N'Mediocampista', NULL),
    ('J', 7, 20, N'Ibrahima', N'Fall', '19950402', N'Raja Casablanca', N'Mediocampista', NULL),
    ('J', 7, 21, N'Samir', N'Kane', '19981115', N'Generation Foot', N'Delantero', NULL),
    ('J', 7, 22, N'Modou', N'Benali', '20010628', N'Jaraaf', N'Delantero', NULL),
    ('J', 7, 23, N'Amine', N'Idrissi', '20040113', N'Ajax', N'Arquero', NULL),
    ('T', 7, 30, N'Lamine', N'Cissé', '19710226', NULL, NULL, N'Director Tecnico'),
    ('T', 7, 31, N'Karim', N'Lahlou', '19780707', NULL, NULL, N'Asistente'),
    ('T', 7, 32, N'Omar', N'Chakir', '19631216', NULL, NULL, N'Asistente'),
    ('J', 8, 1, N'Dong-hyun', N'Suzuki', '20030418', N'Yokohama F. Marinos', N'Arquero', NULL),
    ('J', 8, 2, N'Naoki', N'Kato', '19911103', N'Urawa Reds', N'Defensor', NULL),
    ('J', 8, 3, N'Yuma', N'Cho', '19940616', N'Jeonbuk Hyundai', N'Defensor', NULL),
    ('J', 8, 4, N'Sora', N'Shin', '19970101', N'Ulsan HD', N'Defensor', NULL),
    ('J', 8, 5, N'Seo-jun', N'Yamamoto', '20000814', N'FC Seoul', N'Defensor', NULL),
    ('J', 8, 6, N'Tae-yang', N'Choi', '20030327', N'Celtic', N'Mediocampista', NULL),
    ('J', 8, 7, N'Ryota', N'Han', '19911012', N'Eintracht Frankfurt', N'Delantero', NULL),
    ('J', 8, 8, N'Haruto', N'Takahashi', '19940525', N'Kawasaki Frontale', N'Mediocampista', NULL),
    ('J', 8, 9, N'Yuto', N'Kim', '19971210', N'Yokohama F. Marinos', N'Delantero', NULL),
    ('J', 8, 10, N'Ji-ho', N'Yoon', '20000723', N'Urawa Reds', N'Mediocampista', NULL),
    ('J', 8, 11, N'Sung-min', N'Tanaka', '20030208', N'Jeonbuk Hyundai', N'Delantero', NULL),
    ('J', 8, 12, N'Jae-won', N'Nakamura', '19910921', N'Ulsan HD', N'Arquero', NULL),
    ('J', 8, 13, N'Kenji', N'Jung', '19940406', N'FC Seoul', N'Defensor', NULL),
    ('J', 8, 14, N'Daiki', N'Oh', '19971119', N'Celtic', N'Defensor', NULL),
    ('J', 8, 15, N'Hyun-woo', N'Watanabe', '20000604', N'Eintracht Frankfurt', N'Defensor', NULL),
    ('J', 8, 16, N'Riku', N'Lee', '20030117', N'Kawasaki Frontale', N'Defensor', NULL),
    ('J', 8, 17, N'Woo-jin', N'Jang', '19910802', N'Yokohama F. Marinos', N'Mediocampista', NULL),
    ('J', 8, 18, N'Takumi', N'Sato', '19940315', N'Urawa Reds', N'Mediocampista', NULL),
    ('J', 8, 19, N'Shota', N'Kobayashi', '19971028', N'Jeonbuk Hyundai', N'Mediocampista', NULL),
    ('J', 8, 20, N'Joon-ho', N'Kang', '20000513', N'Ulsan HD', N'Mediocampista', NULL),
    ('J', 8, 21, N'Kaito', N'Seo', '20031226', N'FC Seoul', N'Delantero', NULL),
    ('J', 8, 22, N'Hoon', N'Ito', '19910711', N'Celtic', N'Delantero', NULL),
    ('J', 8, 23, N'Ren', N'Park', '19940224', N'Eintracht Frankfurt', N'Arquero', NULL),
    ('T', 8, 30, N'Woo-jin', N'Oh', '19740311', NULL, NULL, N'Director Tecnico'),
    ('T', 8, 31, N'Takumi', N'Watanabe', '19810820', NULL, NULL, N'Asistente'),
    ('T', 8, 32, N'Shota', N'Lee', '19660101', NULL, NULL, N'Asistente'),
    ('J', 9, 1, N'Dylan', N'Brooks', '19930501', N'Arsenal', N'Arquero', NULL),
    ('J', 9, 2, N'Declan', N'Fletcher', '19961214', N'Chelsea', N'Defensor', NULL),
    ('J', 9, 3, N'James', N'Barrett', '19990727', N'Aston Villa', N'Defensor', NULL),
    ('J', 9, 4, N'Ethan', N'Mitchell', '20020212', N'Newcastle United', N'Defensor', NULL),
    ('J', 9, 5, N'Connor', N'Palmer', '19900925', N'LA Galaxy', N'Defensor', NULL),
    ('J', 9, 6, N'Cole', N'Carter', '19930410', N'Seattle Sounders', N'Mediocampista', NULL),
    ('J', 9, 7, N'Marcus', N'Hughes', '19961123', N'Toronto FC', N'Delantero', NULL),
    ('J', 9, 8, N'Oliver', N'Reed', '19990608', N'Vancouver Whitecaps', N'Mediocampista', NULL),
    ('J', 9, 9, N'Mason', N'Dawson', '20020121', N'Arsenal', N'Delantero', NULL),
    ('J', 9, 10, N'Ryan', N'Ellis', '19900806', N'Chelsea', N'Mediocampista', NULL),
    ('J', 9, 11, N'Nathan', N'Parker', '19930319', N'Aston Villa', N'Delantero', NULL),
    ('J', 9, 12, N'Trevor', N'Sullivan', '19961004', N'Newcastle United', N'Arquero', NULL),
    ('J', 9, 13, N'Jack', N'Spencer', '19990517', N'LA Galaxy', N'Defensor', NULL),
    ('J', 9, 14, N'Logan', N'Bennett', '20021202', N'Seattle Sounders', N'Defensor', NULL),
    ('J', 9, 15, N'Tyler', N'Hayes', '19900715', N'Toronto FC', N'Defensor', NULL),
    ('J', 9, 16, N'Aaron', N'Holland', '19930228', N'Vancouver Whitecaps', N'Defensor', NULL),
    ('J', 9, 17, N'Colin', N'Radcliffe', '19960913', N'Arsenal', N'Mediocampista', NULL),
    ('J', 9, 18, N'Harry', N'Collins', '19990426', N'Chelsea', N'Mediocampista', NULL),
    ('J', 9, 19, N'Liam', N'Murray', '20021111', N'Aston Villa', N'Mediocampista', NULL),
    ('J', 9, 20, N'Jordan', N'Hartley', '19900624', N'Newcastle United', N'Mediocampista', NULL),
    ('J', 9, 21, N'Callum', N'Foster', '19930109', N'LA Galaxy', N'Delantero', NULL),
    ('J', 9, 22, N'Elliot', N'Graham', '19960822', N'Seattle Sounders', N'Delantero', NULL),
    ('J', 9, 23, N'Noah', N'Whitaker', '19990307', N'Toronto FC', N'Arquero', NULL),
    ('T', 9, 30, N'Colin', N'Bennett', '19770424', NULL, NULL, N'Director Tecnico'),
    ('T', 9, 31, N'Harry', N'Hayes', '19620905', NULL, NULL, N'Asistente'),
    ('T', 9, 32, N'Liam', N'Holland', '19690214', NULL, NULL, N'Asistente'),
    ('J', 10, 1, N'Bruno', N'Rojas', '19980612', N'Pumas UNAM', N'Arquero', NULL),
    ('J', 10, 2, N'Damián', N'Aguirre', '20010125', N'Atlético Nacional', N'Defensor', NULL),
    ('J', 10, 3, N'Matías', N'Ledesma', '20040810', N'Millonarios', N'Defensor', NULL),
    ('J', 10, 4, N'Tomás', N'Quiroga', '19920323', N'Sevilla', N'Defensor', NULL),
    ('J', 10, 5, N'Ezequiel', N'Molina', '19951008', N'Real Sociedad', N'Defensor', NULL),
    ('J', 10, 6, N'Mauricio', N'Domínguez', '19980521', N'River Plate', N'Mediocampista', NULL),
    ('J', 10, 7, N'Federico', N'Cabrera', '20011206', N'Boca Juniors', N'Delantero', NULL),
    ('J', 10, 8, N'Nicolás', N'Ferreyra', '20040719', N'Racing Club', N'Mediocampista', NULL),
    ('J', 10, 9, N'Joaquín', N'Luna', '19920204', N'Estudiantes', N'Delantero', NULL),
    ('J', 10, 10, N'Maximiliano', N'Sosa', '19950917', N'Peñarol', N'Mediocampista', NULL),
    ('J', 10, 11, N'Leandro', N'Villalba', '19980402', N'Nacional', N'Delantero', NULL),
    ('J', 10, 12, N'Esteban', N'Barrios', '20011115', N'Club América', N'Arquero', NULL),
    ('J', 10, 13, N'Lucas', N'Gutiérrez', '20040628', N'Pumas UNAM', N'Defensor', NULL),
    ('J', 10, 14, N'Emiliano', N'Medina', '19920113', N'Atlético Nacional', N'Defensor', NULL),
    ('J', 10, 15, N'Rodrigo', N'Peralta', '19950826', N'Millonarios', N'Defensor', NULL),
    ('J', 10, 16, N'Cristian', N'Roldán', '19980311', N'Sevilla', N'Defensor', NULL),
    ('J', 10, 17, N'Alejandro', N'Acosta', '20011024', N'Real Sociedad', N'Mediocampista', NULL),
    ('J', 10, 18, N'Facundo', N'Paz', '20040509', N'River Plate', N'Mediocampista', NULL),
    ('J', 10, 19, N'Gonzalo', N'Correa', '19921222', N'Boca Juniors', N'Mediocampista', NULL),
    ('J', 10, 20, N'Sebastián', N'Benítez', '19950707', N'Racing Club', N'Mediocampista', NULL),
    ('J', 10, 21, N'Ramiro', N'Herrera', '19980220', N'Estudiantes', N'Delantero', NULL),
    ('J', 10, 22, N'Santiago', N'Montenegro', '20010905', N'Peñarol', N'Delantero', NULL),
    ('J', 10, 23, N'Agustín', N'Mansilla', '20040418', N'Nacional', N'Arquero', NULL),
    ('T', 10, 30, N'Alejandro', N'Medina', '19800509', NULL, NULL, N'Director Tecnico'),
    ('T', 10, 31, N'Facundo', N'Peralta', '19651018', NULL, NULL, N'Asistente'),
    ('T', 10, 32, N'Gonzalo', N'Roldán', '19720327', NULL, NULL, N'Asistente'),
    ('J', 11, 1, N'Mauricio', N'Barrios', '20030723', N'Sevilla', N'Arquero', NULL),
    ('J', 11, 2, N'Federico', N'Gutiérrez', '19910208', N'Real Sociedad', N'Defensor', NULL),
    ('J', 11, 3, N'Nicolás', N'Medina', '19940921', N'River Plate', N'Defensor', NULL),
    ('J', 11, 4, N'Joaquín', N'Peralta', '19970406', N'Boca Juniors', N'Defensor', NULL),
    ('J', 11, 5, N'Maximiliano', N'Roldán', '20001119', N'Racing Club', N'Defensor', NULL),
    ('J', 11, 6, N'Leandro', N'Acosta', '20030604', N'Estudiantes', N'Mediocampista', NULL),
    ('J', 11, 7, N'Esteban', N'Paz', '19910117', N'Peñarol', N'Delantero', NULL),
    ('J', 11, 8, N'Lucas', N'Correa', '19940802', N'Nacional', N'Mediocampista', NULL),
    ('J', 11, 9, N'Emiliano', N'Benítez', '19970315', N'Club América', N'Delantero', NULL),
    ('J', 11, 10, N'Rodrigo', N'Herrera', '20001028', N'Pumas UNAM', N'Mediocampista', NULL),
    ('J', 11, 11, N'Cristian', N'Montenegro', '20030513', N'Atlético Nacional', N'Delantero', NULL),
    ('J', 11, 12, N'Alejandro', N'Mansilla', '19911226', N'Millonarios', N'Arquero', NULL),
    ('J', 11, 13, N'Facundo', N'Ibarra', '19940711', N'Sevilla', N'Defensor', NULL),
    ('J', 11, 14, N'Gonzalo', N'Rojas', '19970224', N'Real Sociedad', N'Defensor', NULL),
    ('J', 11, 15, N'Sebastián', N'Aguirre', '20000909', N'River Plate', N'Defensor', NULL),
    ('J', 11, 16, N'Ramiro', N'Ledesma', '20030422', N'Boca Juniors', N'Defensor', NULL),
    ('J', 11, 17, N'Santiago', N'Quiroga', '19911107', N'Racing Club', N'Mediocampista', NULL),
    ('J', 11, 18, N'Agustín', N'Molina', '19940620', N'Estudiantes', N'Mediocampista', NULL),
    ('J', 11, 19, N'Franco', N'Domínguez', '19970105', N'Peñarol', N'Mediocampista', NULL),
    ('J', 11, 20, N'Bruno', N'Cabrera', '20000818', N'Nacional', N'Mediocampista', NULL),
    ('J', 11, 21, N'Damián', N'Ferreyra', '20030303', N'Club América', N'Delantero', NULL),
    ('J', 11, 22, N'Matías', N'Luna', '19911016', N'Pumas UNAM', N'Delantero', NULL),
    ('J', 11, 23, N'Tomás', N'Sosa', '19940501', N'Atlético Nacional', N'Arquero', NULL),
    ('T', 11, 30, N'Santiago', N'Rojas', '19610622', NULL, NULL, N'Director Tecnico'),
    ('T', 11, 31, N'Agustín', N'Aguirre', '19681103', NULL, NULL, N'Asistente'),
    ('T', 11, 32, N'Franco', N'Ledesma', '19750412', NULL, NULL, N'Asistente'),
    ('J', 12, 1, N'Tiago', N'Cavalcanti', '19930806', N'Sporting CP', N'Arquero', NULL),
    ('J', 12, 2, N'Gonçalo', N'Ferreira', '19960319', N'FC Porto', N'Defensor', NULL),
    ('J', 12, 3, N'Gabriel', N'Carvalho', '19991004', N'Braga', N'Defensor', NULL),
    ('J', 12, 4, N'Caio', N'Cardoso', '20020517', N'Flamengo', N'Defensor', NULL),
    ('J', 12, 5, N'Guilherme', N'Oliveira', '19901202', N'Palmeiras', N'Defensor', NULL),
    ('J', 12, 6, N'Diogo', N'Lima', '19930715', N'Corinthians', N'Mediocampista', NULL),
    ('J', 12, 7, N'Fábio', N'Barbosa', '19960228', N'São Paulo', N'Delantero', NULL),
    ('J', 12, 8, N'Rafael', N'Monteiro', '19990913', N'Benfica', N'Mediocampista', NULL),
    ('J', 12, 9, N'Leonardo', N'Rodrigues', '20020426', N'Sporting CP', N'Delantero', NULL),
    ('J', 12, 10, N'Lucas', N'Gomes', '19901111', N'FC Porto', N'Mediocampista', NULL),
    ('J', 12, 11, N'Ricardo', N'Mendes', '19930624', N'Braga', N'Delantero', NULL),
    ('J', 12, 12, N'João', N'Pereira', '19960109', N'Flamengo', N'Arquero', NULL),
    ('J', 12, 13, N'Diego', N'Araújo', '19990822', N'Palmeiras', N'Defensor', NULL),
    ('J', 12, 14, N'Henrique', N'Moreira', '20020307', N'Corinthians', N'Defensor', NULL),
    ('J', 12, 15, N'Rodrigo', N'Silva', '19901020', N'São Paulo', N'Defensor', NULL),
    ('J', 12, 16, N'Nuno', N'Almeida', '19930505', N'Benfica', N'Defensor', NULL),
    ('J', 12, 17, N'Pedro', N'Martins', '19961218', N'Sporting CP', N'Mediocampista', NULL),
    ('J', 12, 18, N'Vinícius', N'Freitas', '19990703', N'FC Porto', N'Mediocampista', NULL),
    ('J', 12, 19, N'Felipe', N'Costa', '20020216', N'Braga', N'Mediocampista', NULL),
    ('J', 12, 20, N'André', N'Ribeiro', '19900901', N'Flamengo', N'Mediocampista', NULL),
    ('J', 12, 21, N'Miguel', N'Teixeira', '19930414', N'Palmeiras', N'Delantero', NULL),
    ('J', 12, 22, N'Thiago', N'Santos', '19961127', N'Corinthians', N'Delantero', NULL),
    ('J', 12, 23, N'Mateus', N'Nascimento', '19990612', N'São Paulo', N'Arquero', NULL),
    ('T', 12, 30, N'Pedro', N'Moreira', '19640707', NULL, NULL, N'Director Tecnico'),
    ('T', 12, 31, N'Vinícius', N'Silva', '19711216', NULL, NULL, N'Asistente'),
    ('T', 12, 32, N'Felipe', N'Almeida', '19780525', NULL, NULL, N'Asistente'),
    ('J', 13, 1, N'Romain', N'Girard', '19980917', N'Paris Saint-Germain', N'Arquero', NULL),
    ('J', 13, 2, N'Fabian', N'Hoffmann', '20010402', N'Olympique Lyon', N'Defensor', NULL),
    ('J', 13, 3, N'Theo', N'Hartmann', '20041115', N'Bayern Munich', N'Defensor', NULL),
    ('J', 13, 4, N'Lukas', N'Moreau', '19920628', N'Borussia Dortmund', N'Defensor', NULL),
    ('J', 13, 5, N'Leon', N'Mercier', '19950113', N'Bayer Leverkusen', N'Defensor', NULL),
    ('J', 13, 6, N'Bastien', N'Lehmann', '19980826', N'RB Leipzig', N'Mediocampista', NULL),
    ('J', 13, 7, N'Lucas', N'Baumann', '20010311', N'AS Monaco', N'Delantero', NULL),
    ('J', 13, 8, N'Antoine', N'Bonnet', '20041024', N'Lille', N'Mediocampista', NULL),
    ('J', 13, 9, N'Jonas', N'Schäfer', '19920509', N'Paris Saint-Germain', N'Delantero', NULL),
    ('J', 13, 10, N'Tobias', N'Roux', '19951222', N'Olympique Lyon', N'Mediocampista', NULL),
    ('J', 13, 11, N'Kilian', N'Lefèvre', '19980707', N'Bayern Munich', N'Delantero', NULL),
    ('J', 13, 12, N'Hugo', N'Vogel', '20010220', N'Borussia Dortmund', N'Arquero', NULL),
    ('J', 13, 13, N'Maxime', N'Krüger', '20040905', N'Bayer Leverkusen', N'Defensor', NULL),
    ('J', 13, 14, N'Felix', N'Richter', '19920418', N'RB Leipzig', N'Defensor', NULL),
    ('J', 13, 15, N'Kevin', N'Dupuis', '19951103', N'AS Monaco', N'Defensor', NULL),
    ('J', 13, 16, N'Dennis', N'Keller', '19980616', N'Lille', N'Defensor', NULL),
    ('J', 13, 17, N'Louis', N'Perrin', '20010101', N'Paris Saint-Germain', N'Mediocampista', NULL),
    ('J', 13, 18, N'Julien', N'Fournier', '20040814', N'Olympique Lyon', N'Mediocampista', NULL),
    ('J', 13, 19, N'Niklas', N'Becker', '19920327', N'Bayern Munich', N'Mediocampista', NULL),
    ('J', 13, 20, N'Matteo', N'Weiss', '19951012', N'Borussia Dortmund', N'Mediocampista', NULL),
    ('J', 13, 21, N'Johannes', N'Sauer', '19980525', N'Bayer Leverkusen', N'Delantero', NULL),
    ('J', 13, 22, N'Mathis', N'Lambert', '20011210', N'RB Leipzig', N'Delantero', NULL),
    ('J', 13, 23, N'Florian', N'Brandt', '20040723', N'AS Monaco', N'Arquero', NULL),
    ('T', 13, 30, N'Louis', N'Richter', '19670820', NULL, NULL, N'Director Tecnico'),
    ('T', 13, 31, N'Julien', N'Dupuis', '19740101', NULL, NULL, N'Asistente'),
    ('T', 13, 32, N'Niklas', N'Keller', '19810610', NULL, NULL, N'Asistente'),
    ('J', 14, 1, N'Bastien', N'Vogel', '20031028', N'Borussia Dortmund', N'Arquero', NULL),
    ('J', 14, 2, N'Lucas', N'Krüger', '19910513', N'Bayer Leverkusen', N'Defensor', NULL),
    ('J', 14, 3, N'Antoine', N'Richter', '19941226', N'RB Leipzig', N'Defensor', NULL),
    ('J', 14, 4, N'Jonas', N'Dupuis', '19970711', N'AS Monaco', N'Defensor', NULL),
    ('J', 14, 5, N'Tobias', N'Keller', '20000224', N'Lille', N'Defensor', NULL),
    ('J', 14, 6, N'Kilian', N'Perrin', '20030909', N'Paris Saint-Germain', N'Mediocampista', NULL),
    ('J', 14, 7, N'Hugo', N'Fournier', '19910422', N'Olympique Lyon', N'Delantero', NULL),
    ('J', 14, 8, N'Maxime', N'Becker', '19941107', N'Bayern Munich', N'Mediocampista', NULL),
    ('J', 14, 9, N'Felix', N'Weiss', '19970620', N'Borussia Dortmund', N'Delantero', NULL),
    ('J', 14, 10, N'Kevin', N'Sauer', '20000105', N'Bayer Leverkusen', N'Mediocampista', NULL),
    ('J', 14, 11, N'Dennis', N'Lambert', '20030818', N'RB Leipzig', N'Delantero', NULL),
    ('J', 14, 12, N'Louis', N'Brandt', '19910303', N'AS Monaco', N'Arquero', NULL),
    ('J', 14, 13, N'Julien', N'Marchand', '19941016', N'Lille', N'Defensor', NULL),
    ('J', 14, 14, N'Niklas', N'Girard', '19970501', N'Paris Saint-Germain', N'Defensor', NULL),
    ('J', 14, 15, N'Matteo', N'Hoffmann', '20001214', N'Olympique Lyon', N'Defensor', NULL),
    ('J', 14, 16, N'Johannes', N'Hartmann', '20030727', N'Bayern Munich', N'Defensor', NULL),
    ('J', 14, 17, N'Mathis', N'Moreau', '19910212', N'Borussia Dortmund', N'Mediocampista', NULL),
    ('J', 14, 18, N'Florian', N'Mercier', '19940925', N'Bayer Leverkusen', N'Mediocampista', NULL),
    ('J', 14, 19, N'Moritz', N'Lehmann', '19970410', N'RB Leipzig', N'Mediocampista', NULL),
    ('J', 14, 20, N'Romain', N'Baumann', '20001123', N'AS Monaco', N'Mediocampista', NULL),
    ('J', 14, 21, N'Fabian', N'Bonnet', '20030608', N'Lille', N'Delantero', NULL),
    ('J', 14, 22, N'Theo', N'Schäfer', '19910121', N'Paris Saint-Germain', N'Delantero', NULL),
    ('J', 14, 23, N'Lukas', N'Roux', '19940806', N'Olympique Lyon', N'Arquero', NULL),
    ('T', 14, 30, N'Mathis', N'Girard', '19700905', NULL, NULL, N'Director Tecnico'),
    ('T', 14, 31, N'Florian', N'Hoffmann', '19770214', NULL, NULL, N'Asistente'),
    ('T', 14, 32, N'Moritz', N'Hartmann', '19620723', NULL, NULL, N'Asistente'),
    ('J', 15, 1, N'Marcus', N'Murray', '19931111', N'Aston Villa', N'Arquero', NULL),
    ('J', 15, 2, N'Oliver', N'Hartley', '19960624', N'Newcastle United', N'Defensor', NULL),
    ('J', 15, 3, N'Mason', N'Foster', '19990109', N'LA Galaxy', N'Defensor', NULL),
    ('J', 15, 4, N'Ryan', N'Graham', '20020822', N'Seattle Sounders', N'Defensor', NULL),
    ('J', 15, 5, N'Nathan', N'Whitaker', '19900307', N'Toronto FC', N'Defensor', NULL),
    ('J', 15, 6, N'Trevor', N'Walker', '19931020', N'Vancouver Whitecaps', N'Mediocampista', NULL),
    ('J', 15, 7, N'Jack', N'Brooks', '19960505', N'Arsenal', N'Delantero', NULL),
    ('J', 15, 8, N'Logan', N'Fletcher', '19991218', N'Chelsea', N'Mediocampista', NULL),
    ('J', 15, 9, N'Tyler', N'Barrett', '20020703', N'Aston Villa', N'Delantero', NULL),
    ('J', 15, 10, N'Aaron', N'Mitchell', '19900216', N'Newcastle United', N'Mediocampista', NULL),
    ('J', 15, 11, N'Colin', N'Palmer', '19930901', N'LA Galaxy', N'Delantero', NULL),
    ('J', 15, 12, N'Harry', N'Carter', '19960414', N'Seattle Sounders', N'Arquero', NULL),
    ('J', 15, 13, N'Liam', N'Hughes', '19991127', N'Toronto FC', N'Defensor', NULL),
    ('J', 15, 14, N'Jordan', N'Reed', '20020612', N'Vancouver Whitecaps', N'Defensor', NULL),
    ('J', 15, 15, N'Callum', N'Dawson', '19900125', N'Arsenal', N'Defensor', NULL),
    ('J', 15, 16, N'Elliot', N'Ellis', '19930810', N'Chelsea', N'Defensor', NULL),
    ('J', 15, 17, N'Noah', N'Parker', '19960323', N'Aston Villa', N'Mediocampista', NULL),
    ('J', 15, 18, N'Owen', N'Sullivan', '19991008', N'Newcastle United', N'Mediocampista', NULL),
    ('J', 15, 19, N'Dylan', N'Spencer', '20020521', N'LA Galaxy', N'Mediocampista', NULL),
    ('J', 15, 20, N'Declan', N'Bennett', '19901206', N'Seattle Sounders', N'Mediocampista', NULL),
    ('J', 15, 21, N'James', N'Hayes', '19930719', N'Toronto FC', N'Delantero', NULL),
    ('J', 15, 22, N'Ethan', N'Holland', '19960204', N'Vancouver Whitecaps', N'Delantero', NULL),
    ('J', 15, 23, N'Connor', N'Radcliffe', '19990917', N'Arsenal', N'Arquero', NULL),
    ('T', 15, 30, N'Noah', N'Reed', '19731018', NULL, NULL, N'Director Tecnico'),
    ('T', 15, 31, N'Owen', N'Dawson', '19800327', NULL, NULL, N'Asistente'),
    ('T', 15, 32, N'Dylan', N'Ellis', '19650808', NULL, NULL, N'Asistente'),
    ('J', 16, 1, N'Federico', N'Correa', '19981222', N'Boca Juniors', N'Arquero', NULL),
    ('J', 16, 2, N'Nicolás', N'Benítez', '20010707', N'Racing Club', N'Defensor', NULL),
    ('J', 16, 3, N'Joaquín', N'Herrera', '20040220', N'Estudiantes', N'Defensor', NULL),
    ('J', 16, 4, N'Maximiliano', N'Montenegro', '19920905', N'Peñarol', N'Defensor', NULL),
    ('J', 16, 5, N'Leandro', N'Mansilla', '19950418', N'Nacional', N'Defensor', NULL),
    ('J', 16, 6, N'Esteban', N'Ibarra', '19981103', N'Club América', N'Mediocampista', NULL),
    ('J', 16, 7, N'Lucas', N'Rojas', '20010616', N'Pumas UNAM', N'Delantero', NULL),
    ('J', 16, 8, N'Emiliano', N'Aguirre', '20040101', N'Atlético Nacional', N'Mediocampista', NULL),
    ('J', 16, 9, N'Rodrigo', N'Ledesma', '19920814', N'Millonarios', N'Delantero', NULL),
    ('J', 16, 10, N'Cristian', N'Quiroga', '19950327', N'Sevilla', N'Mediocampista', NULL),
    ('J', 16, 11, N'Alejandro', N'Molina', '19981012', N'Real Sociedad', N'Delantero', NULL),
    ('J', 16, 12, N'Facundo', N'Domínguez', '20010525', N'River Plate', N'Arquero', NULL),
    ('J', 16, 13, N'Gonzalo', N'Cabrera', '20041210', N'Boca Juniors', N'Defensor', NULL),
    ('J', 16, 14, N'Sebastián', N'Ferreyra', '19920723', N'Racing Club', N'Defensor', NULL),
    ('J', 16, 15, N'Ramiro', N'Luna', '19950208', N'Estudiantes', N'Defensor', NULL),
    ('J', 16, 16, N'Santiago', N'Sosa', '19980921', N'Peñarol', N'Defensor', NULL),
    ('J', 16, 17, N'Agustín', N'Villalba', '20010406', N'Nacional', N'Mediocampista', NULL),
    ('J', 16, 18, N'Franco', N'Barrios', '20041119', N'Club América', N'Mediocampista', NULL),
    ('J', 16, 19, N'Bruno', N'Gutiérrez', '19920604', N'Pumas UNAM', N'Mediocampista', NULL),
    ('J', 16, 20, N'Damián', N'Medina', '19950117', N'Atlético Nacional', N'Mediocampista', NULL),
    ('J', 16, 21, N'Matías', N'Peralta', '19980802', N'Millonarios', N'Delantero', NULL),
    ('J', 16, 22, N'Tomás', N'Roldán', '20010315', N'Sevilla', N'Delantero', NULL),
    ('J', 16, 23, N'Ezequiel', N'Acosta', '20041028', N'Real Sociedad', N'Arquero', NULL),
    ('T', 16, 30, N'Agustín', N'Ferreyra', '19761103', NULL, NULL, N'Director Tecnico'),
    ('T', 16, 31, N'Franco', N'Luna', '19610412', NULL, NULL, N'Asistente'),
    ('T', 16, 32, N'Bruno', N'Sosa', '19680921', NULL, NULL, N'Asistente'),
    ('J', 17, 1, N'Ronwen', N'Williams', '19920121', N'Mamelodi Sundowns', N'Arquero', NULL),
    ('J', 17, 2, N'Thabang', N'Matuludi', '19990114', N'Polokwane City', N'Defensor', NULL),
    ('J', 17, 3, N'Khulumani', N'Ndamane', '20040205', N'Mamelodi Sundowns', N'Defensor', NULL),
    ('J', 17, 4, N'Teboho', N'Mokoena', '19970124', N'Mamelodi Sundowns', N'Mediocampista', NULL),
    ('J', 17, 5, N'Thalente', N'Mbatha', '20000306', N'Orlando Pirates', N'Mediocampista', NULL),
    ('J', 17, 6, N'Aubrey', N'Modiba', '19950722', N'Mamelodi Sundowns', N'Defensor', NULL),
    ('J', 17, 7, N'Oswin', N'Appollis', '20010825', N'Orlando Pirates', N'Delantero', NULL),
    ('J', 17, 8, N'Tshepang', N'Moremi', '20001002', N'Orlando Pirates', N'Delantero', NULL),
    ('J', 17, 9, N'Lyle', N'Foster', '20000903', N'Burnley', N'Delantero', NULL),
    ('J', 17, 10, N'Relebohile', N'Mofokeng', '20041023', N'Orlando Pirates', N'Delantero', NULL),
    ('J', 17, 11, N'Themba', N'Zwane', '19890803', N'Mamelodi Sundowns', N'Mediocampista', NULL),
    ('J', 17, 12, N'Thapelo', N'Maseko', '20031111', N'AEL Limassol', N'Delantero', NULL),
    ('J', 17, 13, N'Sphephelo', N'Sithole', '19990303', N'Tondela', N'Mediocampista', NULL),
    ('J', 17, 14, N'Mbekezeli', N'Mbokazi', '20050919', N'Chicago Fire', N'Defensor', NULL),
    ('J', 17, 15, N'Iqraam', N'Rayners', '19951219', N'Mamelodi Sundowns', N'Delantero', NULL),
    ('J', 17, 16, N'Sipho', N'Chaine', '19961214', N'Orlando Pirates', N'Arquero', NULL),
    ('J', 17, 17, N'Evidence', N'Makgopa', '20000605', N'Orlando Pirates', N'Delantero', NULL),
    ('J', 17, 18, N'Samukele', N'Kabini', '20040315', N'Molde', N'Defensor', NULL),
    ('J', 17, 19, N'Nkosinathi', N'Sibisi', '19950922', N'Orlando Pirates', N'Defensor', NULL),
    ('J', 17, 20, N'Khuliso', N'Mudau', '19950426', N'Mamelodi Sundowns', N'Defensor', NULL),
    ('J', 17, 21, N'Ime', N'Okon', '20040220', N'Hannover 96', N'Defensor', NULL),
    ('J', 17, 22, N'Ricardo', N'Goss', '19940402', N'Siwelele', N'Arquero', NULL),
    ('J', 17, 23, N'Jayden', N'Adams', '20010505', N'Mamelodi Sundowns', N'Mediocampista', NULL),
    ('T', 17, 30, N'Hugo', N'Broos', '19520410', NULL, NULL, N'Director Tecnico'),
    ('T', 17, 31, N'Helman', N'Mkhalele', '19691020', NULL, NULL, N'Asistente'),
    ('T', 17, 32, N'Daniel', N'Mokoena', '19750315', NULL, NULL, N'Asistente'),
    ('J', 18, 1, N'Jindřich', N'Staněk', '19960427', N'Slavia Praga', N'Arquero', NULL),
    ('J', 18, 2, N'David', N'Jurásek', '20000807', N'Besiktas', N'Defensor', NULL),
    ('J', 18, 3, N'Tomáš', N'Holeš', '19930331', N'Slavia Praga', N'Defensor', NULL),
    ('J', 18, 4, N'Robin', N'Hranáč', '20000129', N'Hoffenheim', N'Defensor', NULL),
    ('J', 18, 5, N'Vladimír', N'Coufal', '19920822', N'Hoffenheim', N'Defensor', NULL),
    ('J', 18, 6, N'Martin', N'Vitík', '20030121', N'Bologna', N'Defensor', NULL),
    ('J', 18, 7, N'Antonín', N'Barák', '19941203', N'Fiorentina', N'Mediocampista', NULL),
    ('J', 18, 8, N'Lukáš', N'Prov od', '19961023', N'Slavia Praga', N'Mediocampista', NULL),
    ('J', 18, 9, N'Adam', N'Hložek', '20020725', N'Hoffenheim', N'Delantero', NULL),
    ('J', 18, 10, N'Patrik', N'Schick', '19960124', N'Bayer Leverkusen', N'Delantero', NULL),
    ('J', 18, 11, N'Jan', N'Kuchta', '19970108', N'Sparta Praga', N'Delantero', NULL),
    ('J', 18, 12, N'Lukáš', N'Horníček', '20020713', N'Sporting Braga', N'Arquero', NULL),
    ('J', 18, 13, N'Mojmír', N'Chytil', '19990429', N'Slavia Praga', N'Delantero', NULL),
    ('J', 18, 14, N'Lukáš', N'Červ', '20010410', N'Viktoria Plzen', N'Mediocampista', NULL),
    ('J', 18, 15, N'Pavel', N'Šulc', '20001229', N'Olympique Lyon', N'Mediocampista', NULL),
    ('J', 18, 16, N'Matěj', N'Kovář', '20000517', N'PSV Eindhoven', N'Arquero', NULL),
    ('J', 18, 17, N'Václav', N'Černý', '19971017', N'Besiktas', N'Delantero', NULL),
    ('J', 18, 18, N'Ladislav', N'Krejčí', '19990420', N'Wolverhampton', N'Defensor', NULL),
    ('J', 18, 19, N'Tomáš', N'Chorý', '19950126', N'Slavia Praga', N'Delantero', NULL),
    ('J', 18, 20, N'Christos', N'Zafeiris', '20030223', N'Slavia Praga', N'Mediocampista', NULL),
    ('J', 18, 21, N'Alex', N'Král', '19980519', N'Union Berlin', N'Mediocampista', NULL),
    ('J', 18, 22, N'Tomáš', N'Souček', '19950227', N'West Ham', N'Mediocampista', NULL),
    ('J', 18, 23, N'Adam', N'Karabec', '20030702', N'Olympique Lyon', N'Mediocampista', NULL),
    ('T', 18, 30, N'Miroslav', N'Koubek', '19510901', NULL, NULL, N'Director Tecnico'),
    ('T', 18, 31, N'Jan', N'Novák', '19750412', NULL, NULL, N'Asistente'),
    ('T', 18, 32, N'Petr', N'Svoboda', '19800318', NULL, NULL, N'Asistente'),
    ('J', 19, 1, N'Nikola', N'Vasilj', '19951202', N'St. Pauli', N'Arquero', NULL),
    ('J', 19, 2, N'Amar', N'Dedić', '20020818', N'Benfica', N'Defensor', NULL),
    ('J', 19, 3, N'Sead', N'Kolašinac', '19930620', N'Atalanta', N'Defensor', NULL),
    ('J', 19, 4, N'Ermin', N'Bičakčić', '19900124', N'Eintracht Braunschweig', N'Defensor', NULL),
    ('J', 19, 5, N'Adrian', N'Barišić', '20010719', N'Basel', N'Defensor', NULL),
    ('J', 19, 6, N'Benjamin', N'Tahirović', '20030303', N'Brondby', N'Mediocampista', NULL),
    ('J', 19, 7, N'Amar', N'Rahmanović', '19940510', N'Krylia Sovetov', N'Mediocampista', NULL),
    ('J', 19, 8, N'Rade', N'Krunić', '19931007', N'Estrella Roja', N'Mediocampista', NULL),
    ('J', 19, 9, N'Ermedin', N'Demirović', '19980325', N'Stuttgart', N'Delantero', NULL),
    ('J', 19, 10, N'Edin', N'Džeko', '19860317', N'Fiorentina', N'Delantero', NULL),
    ('J', 19, 11, N'Haris', N'Tabaković', '19940616', N'Borussia Monchengladbach', N'Delantero', NULL),
    ('J', 19, 12, N'Kenan', N'Pirić', '19940707', N'Antalyaspor', N'Arquero', NULL),
    ('J', 19, 13, N'Ivan', N'Sunjić', '19961009', N'Pafos', N'Mediocampista', NULL),
    ('J', 19, 14, N'Armin', N'Gigović', '20020406', N'Young Boys', N'Mediocampista', NULL),
    ('J', 19, 15, N'Nikola', N'Katić', '19961010', N'Schalke 04', N'Defensor', NULL),
    ('J', 19, 16, N'Osman', N'Hadžikić', '19960312', N'Velež Mostar', N'Arquero', NULL),
    ('J', 19, 17, N'Esmir', N'Bajraktarević', '20050310', N'PSV Eindhoven', N'Delantero', NULL),
    ('J', 19, 18, N'Dario', N'Šarić', '19970530', N'Palermo', N'Mediocampista', NULL),
    ('J', 19, 19, N'Jusuf', N'Gazibegović', '20000311', N'Colonia', N'Defensor', NULL),
    ('J', 19, 20, N'Harun', N'Tabaković', '20020515', N'Sarajevo', N'Delantero', NULL),
    ('J', 19, 21, N'Samed', N'Baždar', '20040131', N'Real Zaragoza', N'Delantero', NULL),
    ('J', 19, 22, N'Ifet', N'Đakovac', '19971205', N'Akron Togliatti', N'Mediocampista', NULL),
    ('J', 19, 23, N'Nihad', N'Mujakić', '19980415', N'Partizan', N'Defensor', NULL),
    ('T', 19, 30, N'Sergej', N'Barbarez', '19710917', NULL, NULL, N'Director Tecnico'),
    ('T', 19, 31, N'Marko', N'Petrović', '19780512', NULL, NULL, N'Asistente'),
    ('T', 19, 32, N'Adnan', N'Hodžić', '19820423', NULL, NULL, N'Asistente'),
    ('J', 20, 1, N'Meshaal', N'Barsham', '19980214', N'Al Sadd', N'Arquero', NULL),
    ('J', 20, 2, N'Pedro', N'Miguel', '19900806', N'Al Sadd', N'Defensor', NULL),
    ('J', 20, 3, N'Abdelkarim', N'Hassan', '19930828', N'Al Wakrah', N'Defensor', NULL),
    ('J', 20, 4, N'Tarek', N'Salman', '19971205', N'Al Sadd', N'Defensor', NULL),
    ('J', 20, 5, N'Bassam', N'Al Rawi', '19971216', N'Al Duhail', N'Defensor', NULL),
    ('J', 20, 6, N'Abdulaziz', N'Hatem', '19901028', N'Al Rayyan', N'Mediocampista', NULL),
    ('J', 20, 7, N'Ahmed', N'Alaaeldin', '19930131', N'Al Gharafa', N'Delantero', NULL),
    ('J', 20, 8, N'Ali', N'Asad', '19930119', N'Al Sadd', N'Mediocampista', NULL),
    ('J', 20, 9, N'Mohammed', N'Muntari', '19931220', N'Al Gharafa', N'Delantero', NULL),
    ('J', 20, 10, N'Hassan', N'Al Haydos', '19901211', N'Al Sadd', N'Mediocampista', NULL),
    ('J', 20, 11, N'Akram', N'Afif', '19961118', N'Al Sadd', N'Delantero', NULL),
    ('J', 20, 12, N'Yousef', N'Hassan', '19960524', N'Al Gharafa', N'Arquero', NULL),
    ('J', 20, 13, N'Assim', N'Madibo', '19961022', N'Al Duhail', N'Mediocampista', NULL),
    ('J', 20, 14, N'Homam', N'Ahmed', '19990825', N'Al Gharafa', N'Defensor', NULL),
    ('J', 20, 15, N'Boualem', N'Khoukhi', '19900709', N'Al Sadd', N'Defensor', NULL),
    ('J', 20, 16, N'Salah', N'Zakaria', '19990424', N'Al Duhail', N'Arquero', NULL),
    ('J', 20, 17, N'Ismail', N'Mohamad', '19900405', N'Al Duhail', N'Mediocampista', NULL),
    ('J', 20, 18, N'Khalid', N'Muneer', '19980224', N'Al Wakrah', N'Delantero', NULL),
    ('J', 20, 19, N'Almoez', N'Ali', '19960819', N'Al Duhail', N'Delantero', NULL),
    ('J', 20, 20, N'Ahmed', N'Fathy', '19930125', N'Al Arabi', N'Mediocampista', NULL),
    ('J', 20, 21, N'Jassem', N'Gaber', '20020220', N'Al Arabi', N'Defensor', NULL),
    ('J', 20, 22, N'Mostafa', N'Mashaal', '20010328', N'Al Sadd', N'Mediocampista', NULL),
    ('J', 20, 23, N'Yusuf', N'Abdurisag', '19990806', N'Al Sadd', N'Delantero', NULL),
    ('T', 20, 30, N'Julen', N'Lopetegui', '19660828', NULL, NULL, N'Director Tecnico'),
    ('T', 20, 31, N'Ahmed', N'Al Mansouri', '19760415', NULL, NULL, N'Asistente'),
    ('T', 20, 32, N'Khalid', N'Al Naimi', '19810320', NULL, NULL, N'Asistente'),
    ('J', 21, 1, N'Gregor', N'Kobel', '19971206', N'Borussia Dortmund', N'Arquero', NULL),
    ('J', 21, 2, N'Kevin', N'Mbabu', '19950419', N'Midtjylland', N'Defensor', NULL),
    ('J', 21, 3, N'Silvan', N'Widmer', '19930305', N'Mainz 05', N'Defensor', NULL),
    ('J', 21, 4, N'Nico', N'Elvedi', '19960930', N'Borussia Monchengladbach', N'Defensor', NULL),
    ('J', 21, 5, N'Manuel', N'Akanji', '19950719', N'Inter', N'Defensor', NULL),
    ('J', 21, 6, N'Denis', N'Zakaria', '19961120', N'Monaco', N'Mediocampista', NULL),
    ('J', 21, 7, N'Breel', N'Embolo', '19970214', N'Rennes', N'Delantero', NULL),
    ('J', 21, 8, N'Remo', N'Freuler', '19920415', N'Bologna', N'Mediocampista', NULL),
    ('J', 21, 9, N'Noah', N'Okafor', '20000524', N'Leeds United', N'Delantero', NULL),
    ('J', 21, 10, N'Granit', N'Xhaka', '19920927', N'Sunderland', N'Mediocampista', NULL),
    ('J', 21, 11, N'Renato', N'Steffen', '19911103', N'Lugano', N'Delantero', NULL),
    ('J', 21, 12, N'Yvon', N'Mvogo', '19940606', N'Lorient', N'Arquero', NULL),
    ('J', 21, 13, N'Ricardo', N'Rodriguez', '19920825', N'Real Betis', N'Defensor', NULL),
    ('J', 21, 14, N'Becir', N'Omeragic', '20020120', N'Montpellier', N'Defensor', NULL),
    ('J', 21, 15, N'Cedric', N'Zesiger', '19980624', N'Augsburg', N'Defensor', NULL),
    ('J', 21, 16, N'Philipp', N'Kohn', '19980402', N'Monaco', N'Arquero', NULL),
    ('J', 21, 17, N'Ruben', N'Vargas', '19980805', N'Sevilla', N'Delantero', NULL),
    ('J', 21, 18, N'Vincent', N'Sierro', '19951008', N'Toulouse', N'Mediocampista', NULL),
    ('J', 21, 19, N'Dan', N'Ndoye', '20001025', N'Nottingham Forest', N'Delantero', NULL),
    ('J', 21, 20, N'Michel', N'Aebischer', '19970106', N'Pisa', N'Mediocampista', NULL),
    ('J', 21, 21, N'Fabian', N'Rieder', '20020216', N'Augsburg', N'Mediocampista', NULL),
    ('J', 21, 22, N'Zeki', N'Amdouni', '20001204', N'Burnley', N'Delantero', NULL),
    ('J', 21, 23, N'Ardon', N'Jashari', '20020730', N'Milan', N'Mediocampista', NULL),
    ('T', 21, 30, N'Murat', N'Yakin', '19740915', NULL, NULL, N'Director Tecnico'),
    ('T', 21, 31, N'Giorgio', N'Contini', '19740104', NULL, NULL, N'Asistente'),
    ('T', 21, 32, N'Martin', N'Keller', '19800212', NULL, NULL, N'Asistente'),
    ('J', 22, 1, N'Johny', N'Placide', '19880129', N'Bastia', N'Arquero', NULL),
    ('J', 22, 2, N'Carlens', N'Arcus', '19960628', N'Angers', N'Defensor', NULL),
    ('J', 22, 3, N'Alex', N'Christian', '19931205', N'Atyrau', N'Defensor', NULL),
    ('J', 22, 4, N'Ricardo', N'Ade', '19900521', N'LDU Quito', N'Defensor', NULL),
    ('J', 22, 5, N'Garven', N'Metussala', '19991231', N'Forge FC', N'Defensor', NULL),
    ('J', 22, 6, N'Bryan', N'Alceus', '19960201', N'Zira', N'Mediocampista', NULL),
    ('J', 22, 7, N'Derrick', N'Etienne', '19961125', N'Toronto FC', N'Delantero', NULL),
    ('J', 22, 8, N'Danley', N'Jean Jacques', '20000520', N'Philadelphia Union', N'Mediocampista', NULL),
    ('J', 22, 9, N'Duckens', N'Nazon', '19940407', N'Kayserispor', N'Delantero', NULL),
    ('J', 22, 10, N'Frantzdy', N'Pierrot', '19950329', N'AEK Atenas', N'Delantero', NULL),
    ('J', 22, 11, N'Don', N'Deedson Louicius', '20010211', N'Odense', N'Delantero', NULL),
    ('J', 22, 12, N'Alexandre', N'Pierre', '20010225', N'Sochaux', N'Arquero', NULL),
    ('J', 22, 13, N'Jean Kevin', N'Duverne', '19970712', N'Nantes', N'Defensor', NULL),
    ('J', 22, 14, N'Leverton', N'Pierre', '19980309', N'Dunkerque', N'Mediocampista', NULL),
    ('J', 22, 15, N'Christopher', N'Attys', '20010313', N'Triestina', N'Mediocampista', NULL),
    ('J', 22, 16, N'Josue', N'Duverger', '20000427', N'Vitoria Setubal', N'Arquero', NULL),
    ('J', 22, 17, N'Fafa', N'Picault', '19910223', N'Inter Miami', N'Delantero', NULL),
    ('J', 22, 18, N'Wilde Donald', N'Guerrier', '19890331', N'Qarabag', N'Defensor', NULL),
    ('J', 22, 19, N'Mondy', N'Prunier', '19991222', N'Charleroi', N'Delantero', NULL),
    ('J', 22, 20, N'Carnejy', N'Antoine', '19910727', N'Hapoel Haifa', N'Delantero', NULL),
    ('J', 22, 21, N'Steven', N'Saba', '19930224', N'Violette AC', N'Mediocampista', NULL),
    ('J', 22, 22, N'Martin', N'Experience', '19990309', N'Nancy', N'Defensor', NULL),
    ('J', 22, 23, N'Warren', N'Caddy', '19970409', N'Annecy', N'Delantero', NULL),
    ('T', 22, 30, N'Sebastien', N'Migne', '19721130', NULL, NULL, N'Director Tecnico'),
    ('T', 22, 31, N'Jean', N'Joseph', '19760314', NULL, NULL, N'Asistente'),
    ('T', 22, 32, N'Patrick', N'Louis', '19810522', NULL, NULL, N'Asistente'),
    ('J', 23, 1, N'Angus', N'Gunn', '19960122', N'Nottingham Forest', N'Arquero', NULL),
    ('J', 23, 2, N'Anthony', N'Ralston', '19981116', N'Celtic', N'Defensor', NULL),
    ('J', 23, 3, N'Andrew', N'Robertson', '19940311', N'Liverpool', N'Defensor', NULL),
    ('J', 23, 4, N'Scott', N'McTominay', '19961208', N'Napoli', N'Mediocampista', NULL),
    ('J', 23, 5, N'Grant', N'Hanley', '19911120', N'Hibernian', N'Defensor', NULL),
    ('J', 23, 6, N'Kieran', N'Tierney', '19970605', N'Celtic', N'Defensor', NULL),
    ('J', 23, 7, N'John', N'McGinn', '19941018', N'Aston Villa', N'Mediocampista', NULL),
    ('J', 23, 8, N'Callum', N'McGregor', '19930614', N'Celtic', N'Mediocampista', NULL),
    ('J', 23, 9, N'Lawrence', N'Shankland', '19950810', N'Hearts', N'Delantero', NULL),
    ('J', 23, 10, N'Che', N'Adams', '19960713', N'Torino', N'Delantero', NULL),
    ('J', 23, 11, N'Ryan', N'Christie', '19950222', N'Bournemouth', N'Mediocampista', NULL),
    ('J', 23, 12, N'Craig', N'Gordon', '19821231', N'Hearts', N'Arquero', NULL),
    ('J', 23, 13, N'Jack', N'Hendry', '19950507', N'Al Ettifaq', N'Defensor', NULL),
    ('J', 23, 14, N'Billy', N'Gilmour', '20010611', N'Napoli', N'Mediocampista', NULL),
    ('J', 23, 15, N'Ryan', N'Porteous', '19990325', N'Los Angeles FC', N'Defensor', NULL),
    ('J', 23, 16, N'Zander', N'Clark', '19920626', N'Hearts', N'Arquero', NULL),
    ('J', 23, 17, N'Stuart', N'Armstrong', '19920330', N'Aberdeen', N'Mediocampista', NULL),
    ('J', 23, 18, N'Lewis', N'Ferguson', '19990824', N'Bologna', N'Mediocampista', NULL),
    ('J', 23, 19, N'Tommy', N'Conway', '20020806', N'Middlesbrough', N'Delantero', NULL),
    ('J', 23, 20, N'Kenny', N'McLean', '19920108', N'Norwich City', N'Mediocampista', NULL),
    ('J', 23, 21, N'John', N'Souttar', '19960925', N'Rangers', N'Defensor', NULL),
    ('J', 23, 22, N'Ben', N'Doak', '20051111', N'Bournemouth', N'Delantero', NULL),
    ('J', 23, 23, N'Lyndon', N'Dykes', '19951007', N'Birmingham City', N'Delantero', NULL),
    ('T', 23, 30, N'Steve', N'Clarke', '19630829', NULL, NULL, N'Director Tecnico'),
    ('T', 23, 31, N'John', N'Carver', '19650116', NULL, NULL, N'Asistente'),
    ('T', 23, 32, N'Robert', N'Campbell', '19780421', NULL, NULL, N'Asistente'),
    ('J', 24, 1, N'Roberto', N'Fernandez', '19880329', N'Botafogo', N'Arquero', NULL),
    ('J', 24, 2, N'Gustavo', N'Gomez', '19930506', N'Palmeiras', N'Defensor', NULL),
    ('J', 24, 3, N'Omar', N'Alderete', '19961226', N'Sunderland', N'Defensor', NULL),
    ('J', 24, 4, N'Fabian', N'Balbuena', '19910823', N'Dinamo Moscu', N'Defensor', NULL),
    ('J', 24, 5, N'Junior', N'Alonso', '19930209', N'Atletico Mineiro', N'Defensor', NULL),
    ('J', 24, 6, N'Andres', N'Cubas', '19960522', N'Vancouver Whitecaps', N'Mediocampista', NULL),
    ('J', 24, 7, N'Miguel', N'Almiron', '19940210', N'Atlanta United', N'Mediocampista', NULL),
    ('J', 24, 8, N'Diego', N'Gomez', '20030327', N'Brighton', N'Mediocampista', NULL),
    ('J', 24, 9, N'Antonio', N'Sanabria', '19960304', N'Cremonese', N'Delantero', NULL),
    ('J', 24, 10, N'Julio', N'Enciso', '20040123', N'Strasbourg', N'Delantero', NULL),
    ('J', 24, 11, N'Ramon', N'Sosa', '19990831', N'Palmeiras', N'Delantero', NULL),
    ('J', 24, 12, N'Carlos', N'Coronel', '19961229', N'New York Red Bulls', N'Arquero', NULL),
    ('J', 24, 13, N'Juan', N'Caceres', '20000601', N'Dinamo Moscu', N'Defensor', NULL),
    ('J', 24, 14, N'Gaston', N'Gimenez', '19910727', N'Cerro Porteno', N'Mediocampista', NULL),
    ('J', 24, 15, N'Blas', N'Riveros', '19980203', N'Cerro Porteno', N'Defensor', NULL),
    ('J', 24, 16, N'Orlando', N'Gill', '20000611', N'San Lorenzo', N'Arquero', NULL),
    ('J', 24, 17, N'Alejandro', N'Romero Gamarra', '19950111', N'Al Ain', N'Mediocampista', NULL),
    ('J', 24, 18, N'Mathias', N'Villasanti', '19970124', N'Gremio', N'Mediocampista', NULL),
    ('J', 24, 19, N'Alex', N'Arce', '19950610', N'Independiente Rivadavia', N'Delantero', NULL),
    ('J', 24, 20, N'Adam', N'Bareiro', '19960726', N'Fortaleza', N'Delantero', NULL),
    ('J', 24, 21, N'Gustavo', N'Velazquez', '19910417', N'Cerro Porteno', N'Defensor', NULL),
    ('J', 24, 22, N'Damian', N'Bobadilla', '20010711', N'Sao Paulo', N'Mediocampista', NULL),
    ('J', 24, 23, N'Gabriel', N'Avalos', '19901012', N'Independiente', N'Delantero', NULL),
    ('T', 24, 30, N'Gustavo', N'Alfaro', '19620814', NULL, NULL, N'Director Tecnico'),
    ('T', 24, 31, N'Carlos', N'Gonzalez', '19750318', NULL, NULL, N'Asistente'),
    ('T', 24, 32, N'Marcelo', N'Benitez', '19800624', NULL, NULL, N'Asistente');

INSERT INTO #PersonaSeed (Tipo, EquipoIdx, Slot, Nombre, Apellido, FechaNac, Club, Posicion, Rol) VALUES
    ('J', 25, 1, N'Mathew', N'Ryan', '19920408', N'Levante', N'Arquero', NULL),
    ('J', 25, 2, N'Milos', N'Degenek', '19940428', N'TSC Backa Topola', N'Defensor', NULL),
    ('J', 25, 3, N'Aziz', N'Behich', '19901216', N'Melbourne City', N'Defensor', NULL),
    ('J', 25, 4, N'Kye', N'Rowles', '19980624', N'DC United', N'Defensor', NULL),
    ('J', 25, 5, N'Harry', N'Souttar', '19981022', N'Leicester City', N'Defensor', NULL),
    ('J', 25, 6, N'Martin', N'Boyle', '19930425', N'Hibernian', N'Delantero', NULL),
    ('J', 25, 7, N'Mathew', N'Leckie', '19910204', N'Melbourne City', N'Delantero', NULL),
    ('J', 25, 8, N'Jackson', N'Irvine', '19930307', N'St. Pauli', N'Mediocampista', NULL),
    ('J', 25, 9, N'Mitchell', N'Duke', '19910118', N'Machida Zelvia', N'Delantero', NULL),
    ('J', 25, 10, N'Ajdin', N'Hrustic', '19960705', N'Heracles Almelo', N'Mediocampista', NULL),
    ('J', 25, 11, N'Craig', N'Goodwin', '19911216', N'Adelaide United', N'Delantero', NULL),
    ('J', 25, 12, N'Joe', N'Gauci', '20000704', N'Aston Villa', N'Arquero', NULL),
    ('J', 25, 13, N'Aiden', N'ONeill', '19980704', N'New York City', N'Mediocampista', NULL),
    ('J', 25, 14, N'Riley', N'McGree', '19981102', N'Middlesbrough', N'Mediocampista', NULL),
    ('J', 25, 15, N'Cameron', N'Burgess', '19951021', N'Swansea City', N'Defensor', NULL),
    ('J', 25, 16, N'Paul', N'Izzo', '19950106', N'Randers', N'Arquero', NULL),
    ('J', 25, 17, N'Jordan', N'Bos', '20021029', N'Feyenoord', N'Defensor', NULL),
    ('J', 25, 18, N'Connor', N'Metcalfe', '19991105', N'St. Pauli', N'Mediocampista', NULL),
    ('J', 25, 19, N'Kusini', N'Yengi', '19990115', N'Aberdeen', N'Delantero', NULL),
    ('J', 25, 20, N'Samuel', N'Silvera', '20001025', N'Middlesbrough', N'Delantero', NULL),
    ('J', 25, 21, N'Lewis', N'Miller', '20000824', N'Hibernian', N'Defensor', NULL),
    ('J', 25, 22, N'Nestory', N'Irankunda', '20060209', N'Watford', N'Delantero', NULL),
    ('J', 25, 23, N'Alessandro', N'Circati', '20031010', N'Parma', N'Defensor', NULL),
    ('T', 25, 30, N'Tony', N'Popovic', '19730704', NULL, NULL, N'Director Tecnico'),
    ('T', 25, 31, N'Andrew', N'Wilson', '19760412', NULL, NULL, N'Asistente'),
    ('T', 25, 32, N'Michael', N'Taylor', '19810322', NULL, NULL, N'Asistente'),
    ('J', 26, 1, N'Ugurcan', N'Cakir', '19960405', N'Galatasaray', N'Arquero', NULL),
    ('J', 26, 2, N'Zeki', N'Celik', '19970217', N'Roma', N'Defensor', NULL),
    ('J', 26, 3, N'Merih', N'Demiral', '19980305', N'Al Ahli', N'Defensor', NULL),
    ('J', 26, 4, N'Caglar', N'Soyuncu', '19960523', N'Fenerbahce', N'Defensor', NULL),
    ('J', 26, 5, N'Kaan', N'Ayhan', '19941110', N'Galatasaray', N'Defensor', NULL),
    ('J', 26, 6, N'Orkun', N'Kokcu', '20001229', N'Besiktas', N'Mediocampista', NULL),
    ('J', 26, 7, N'Kerem', N'Akturkoglu', '19981021', N'Fenerbahce', N'Delantero', NULL),
    ('J', 26, 8, N'Arda', N'Guler', '20050225', N'Real Madrid', N'Mediocampista', NULL),
    ('J', 26, 9, N'Baris Alper', N'Yilmaz', '20000523', N'Galatasaray', N'Delantero', NULL),
    ('J', 26, 10, N'Hakan', N'Calhanoglu', '19940208', N'Inter', N'Mediocampista', NULL),
    ('J', 26, 11, N'Kenan', N'Yildiz', '20050504', N'Juventus', N'Delantero', NULL),
    ('J', 26, 12, N'Altay', N'Bayindir', '19980414', N'Manchester United', N'Arquero', NULL),
    ('J', 26, 13, N'Ferdi', N'Kadioglu', '19991007', N'Brighton', N'Defensor', NULL),
    ('J', 26, 14, N'Ismail', N'Yuksek', '19990126', N'Fenerbahce', N'Mediocampista', NULL),
    ('J', 26, 15, N'Abdulkerim', N'Bardakci', '19940907', N'Galatasaray', N'Defensor', NULL),
    ('J', 26, 16, N'Mert', N'Gunok', '19890301', N'Besiktas', N'Arquero', NULL),
    ('J', 26, 17, N'Irfan Can', N'Kahveci', '19950715', N'Fenerbahce', N'Mediocampista', NULL),
    ('J', 26, 18, N'Salih', N'Ozcan', '19980111', N'Borussia Dortmund', N'Mediocampista', NULL),
    ('J', 26, 19, N'Yunus', N'Akgun', '20000707', N'Galatasaray', N'Delantero', NULL),
    ('J', 26, 20, N'Semih', N'Kilicsoy', '20050815', N'Cagliari', N'Delantero', NULL),
    ('J', 26, 21, N'Mert', N'Muldur', '19990403', N'Fenerbahce', N'Defensor', NULL),
    ('J', 26, 22, N'Can', N'Uzun', '20051111', N'Eintracht Frankfurt', N'Mediocampista', NULL),
    ('J', 26, 23, N'Bertug', N'Yildirim', '20020712', N'Rennes', N'Delantero', NULL),
    ('T', 26, 30, N'Vincenzo', N'Montella', '19740618', NULL, NULL, N'Director Tecnico'),
    ('T', 26, 31, N'Mehmet', N'Kaya', '19780415', NULL, NULL, N'Asistente'),
    ('T', 26, 32, N'Ahmet', N'Demir', '19820521', NULL, NULL, N'Asistente'),
    ('J', 27, 1, N'Eloy', N'Room', '19890206', N'Vitesse', N'Arquero', NULL),
    ('J', 27, 2, N'Cuco', N'Martina', '19890925', N'NAC Breda', N'Defensor', NULL),
    ('J', 27, 3, N'Jurien', N'Gaari', '19931223', N'RKC Waalwijk', N'Defensor', NULL),
    ('J', 27, 4, N'Roshon', N'Van Eijma', '19980609', N'RKC Waalwijk', N'Defensor', NULL),
    ('J', 27, 5, N'Sherel', N'Floranus', '19980823', N'PEC Zwolle', N'Defensor', NULL),
    ('J', 27, 6, N'Leandro', N'Bacuna', '19910821', N'Groningen', N'Mediocampista', NULL),
    ('J', 27, 7, N'Juninho', N'Bacuna', '19970807', N'Al Wehda', N'Mediocampista', NULL),
    ('J', 27, 8, N'Vurnon', N'Anita', '19890404', N'RKC Waalwijk', N'Mediocampista', NULL),
    ('J', 27, 9, N'Rangelo', N'Janga', '19920416', N'Nea Salamina', N'Delantero', NULL),
    ('J', 27, 10, N'Kenji', N'Gorre', '19940929', N'Al Shahaniya', N'Delantero', NULL),
    ('J', 27, 11, N'Gervane', N'Kastaneer', '19960609', N'Persib Bandung', N'Delantero', NULL),
    ('J', 27, 12, N'Trevor', N'Doornbusch', '19990706', N'FC Dordrecht', N'Arquero', NULL),
    ('J', 27, 13, N'Joshua', N'Brenet', '19940320', N'Al Rayyan', N'Defensor', NULL),
    ('J', 27, 14, N'Godfried', N'Roemeratoe', '19990819', N'RKC Waalwijk', N'Mediocampista', NULL),
    ('J', 27, 15, N'Juriën', N'Juliana', '19980315', N'SV Centro Dominguito', N'Defensor', NULL),
    ('J', 27, 16, N'Tyrick', N'Bodak', '20020508', N'PSV Eindhoven', N'Arquero', NULL),
    ('J', 27, 17, N'Brandley', N'Kuwas', '19920919', N'FC Volendam', N'Delantero', NULL),
    ('J', 27, 18, N'Jeremy', N'Antonisse', '20020329', N'Moreirense', N'Delantero', NULL),
    ('J', 27, 19, N'Jearl', N'Margaritha', '20000410', N'Sabah FC', N'Delantero', NULL),
    ('J', 27, 20, N'Kevin', N'Felida', '19991111', N'RKC Waalwijk', N'Mediocampista', NULL),
    ('J', 27, 21, N'Justin', N'Ogenia', '19990205', N'FC Eindhoven', N'Defensor', NULL),
    ('J', 27, 22, N'Livano', N'Comenencia', '20040203', N'Juventus Next Gen', N'Defensor', NULL),
    ('J', 27, 23, N'Richairo', N'Zivkovic', '19960905', N'Bangkok United', N'Delantero', NULL),
    ('T', 27, 30, N'Dick', N'Advocaat', '19470927', NULL, NULL, N'Director Tecnico'),
    ('T', 27, 31, N'Patrick', N'Martina', '19750314', NULL, NULL, N'Asistente'),
    ('T', 27, 32, N'Erwin', N'Rosalia', '19810423', NULL, NULL, N'Asistente'),
    ('J', 28, 1, N'Yahia', N'Fofana', '20000821', N'Angers', N'Arquero', NULL),
    ('J', 28, 2, N'Wilfried', N'Singo', '20001225', N'Galatasaray', N'Defensor', NULL),
    ('J', 28, 3, N'Ghislain', N'Konan', '19951227', N'Al Fayha', N'Defensor', NULL),
    ('J', 28, 4, N'Ousmane', N'Diomande', '20031204', N'Sporting Lisboa', N'Defensor', NULL),
    ('J', 28, 5, N'Odilon', N'Kossounou', '20010104', N'Atalanta', N'Defensor', NULL),
    ('J', 28, 6, N'Seko', N'Fofana', '19950507', N'Rennes', N'Mediocampista', NULL),
    ('J', 28, 7, N'Simon', N'Adingra', '20020101', N'Sunderland', N'Delantero', NULL),
    ('J', 28, 8, N'Franck', N'Kessie', '19961219', N'Al Ahli', N'Mediocampista', NULL),
    ('J', 28, 9, N'Sebastien', N'Haller', '19940622', N'Utrecht', N'Delantero', NULL),
    ('J', 28, 10, N'Nicolas', N'Pepe', '19950529', N'Villarreal', N'Delantero', NULL),
    ('J', 28, 11, N'Wilfried', N'Zaha', '19921110', N'Charlotte FC', N'Delantero', NULL),
    ('J', 28, 12, N'Badra Ali', N'Sangare', '19860530', N'Sekhukhune United', N'Arquero', NULL),
    ('J', 28, 13, N'Jeremie', N'Boga', '19970103', N'Nice', N'Delantero', NULL),
    ('J', 28, 14, N'Jean Michael', N'Seri', '19910719', N'Al Orobah', N'Mediocampista', NULL),
    ('J', 28, 15, N'Evan', N'Ndicka', '19990820', N'Roma', N'Defensor', NULL),
    ('J', 28, 16, N'Charles', N'Folley', '19991029', N'ASEC Mimosas', N'Arquero', NULL),
    ('J', 28, 17, N'Karim', N'Konate', '20040321', N'Red Bull Salzburg', N'Delantero', NULL),
    ('J', 28, 18, N'Ibrahim', N'Sangare', '19971202', N'Nottingham Forest', N'Mediocampista', NULL),
    ('J', 28, 19, N'Amad', N'Diallo', '20020711', N'Manchester United', N'Delantero', NULL),
    ('J', 28, 20, N'Christian', N'Kouame', '19971206', N'Fiorentina', N'Delantero', NULL),
    ('J', 28, 21, N'Emmanuel', N'Agbadou', '19970617', N'Wolverhampton', N'Defensor', NULL),
    ('J', 28, 22, N'Hamed', N'Traore', '20000216', N'Bournemouth', N'Mediocampista', NULL),
    ('J', 28, 23, N'Guela', N'Doue', '20021017', N'Strasbourg', N'Defensor', NULL),
    ('T', 28, 30, N'Emerse', N'Fae', '19840124', NULL, NULL, N'Director Tecnico'),
    ('T', 28, 31, N'Jean', N'Kouassi', '19760412', NULL, NULL, N'Asistente'),
    ('T', 28, 32, N'Alain', N'Toure', '19820318', NULL, NULL, N'Asistente'),
    ('J', 29, 1, N'Hernan', N'Galindez', '19870330', N'Huracan', N'Arquero', NULL),
    ('J', 29, 2, N'Felix', N'Torres', '19970111', N'Corinthians', N'Defensor', NULL),
    ('J', 29, 3, N'Piero', N'Hincapie', '20020109', N'Arsenal', N'Defensor', NULL),
    ('J', 29, 4, N'Joel', N'Ordonez', '20040421', N'Brujas', N'Defensor', NULL),
    ('J', 29, 5, N'Robert', N'Arboleda', '19911022', N'Sao Paulo', N'Defensor', NULL),
    ('J', 29, 6, N'William', N'Pacho', '20011016', N'Paris Saint Germain', N'Defensor', NULL),
    ('J', 29, 7, N'Pervis', N'Estupinan', '19980121', N'Milan', N'Defensor', NULL),
    ('J', 29, 8, N'Carlos', N'Gruezo', '19950419', N'LDU Quito', N'Mediocampista', NULL),
    ('J', 29, 9, N'Enner', N'Valencia', '19891104', N'Internacional', N'Delantero', NULL),
    ('J', 29, 10, N'Kendry', N'Paez', '20070504', N'Strasbourg', N'Mediocampista', NULL),
    ('J', 29, 11, N'Kevin', N'Rodriguez', '20000304', N'Union Saint Gilloise', N'Delantero', NULL),
    ('J', 29, 12, N'Moises', N'Ramirez', '20000909', N'Independiente del Valle', N'Arquero', NULL),
    ('J', 29, 13, N'Jose', N'Cifuentes', '19990312', N'Rangers', N'Mediocampista', NULL),
    ('J', 29, 14, N'Alan', N'Franco', '19980821', N'Atletico Mineiro', N'Mediocampista', NULL),
    ('J', 29, 15, N'Angelo', N'Preciado', '19980218', N'Sparta Praga', N'Defensor', NULL),
    ('J', 29, 16, N'Gonzalo', N'Valle', '19960228', N'LDU Quito', N'Arquero', NULL),
    ('J', 29, 17, N'John', N'Yeboah', '20000623', N'Venezia', N'Delantero', NULL),
    ('J', 29, 18, N'Jhoanner', N'Chavez', '20020425', N'Lens', N'Defensor', NULL),
    ('J', 29, 19, N'Gonzalo', N'Plata', '20001101', N'Flamengo', N'Delantero', NULL),
    ('J', 29, 20, N'Nilson', N'Angulo', '20030619', N'Anderlecht', N'Delantero', NULL),
    ('J', 29, 21, N'Pedro', N'Vite', '20020309', N'Pumas UNAM', N'Mediocampista', NULL),
    ('J', 29, 22, N'Moises', N'Caicedo', '20011102', N'Chelsea', N'Mediocampista', NULL),
    ('J', 29, 23, N'Jeremy', N'Sarmiento', '20020616', N'Brighton', N'Delantero', NULL),
    ('T', 29, 30, N'Sebastian', N'Beccacece', '19801217', NULL, NULL, N'Director Tecnico'),
    ('T', 29, 31, N'Pablo', N'Ramirez', '19780514', NULL, NULL, N'Asistente'),
    ('T', 29, 32, N'Diego', N'Morales', '19820422', NULL, NULL, N'Asistente'),
    ('J', 30, 1, N'Bart', N'Verbruggen', '20020818', N'Brighton', N'Arquero', NULL),
    ('J', 30, 2, N'Denzel', N'Dumfries', '19960418', N'Inter', N'Defensor', NULL),
    ('J', 30, 3, N'Matthijs', N'De Ligt', '19990812', N'Manchester United', N'Defensor', NULL),
    ('J', 30, 4, N'Virgil', N'Van Dijk', '19910708', N'Liverpool', N'Defensor', NULL),
    ('J', 30, 5, N'Nathan', N'Ake', '19950218', N'Manchester City', N'Defensor', NULL),
    ('J', 30, 6, N'Stefan', N'De Vrij', '19920205', N'Inter', N'Defensor', NULL),
    ('J', 30, 7, N'Xavi', N'Simons', '20030421', N'Tottenham', N'Mediocampista', NULL),
    ('J', 30, 8, N'Frenkie', N'De Jong', '19970512', N'Barcelona', N'Mediocampista', NULL),
    ('J', 30, 9, N'Brian', N'Brobbey', '20020201', N'Sunderland', N'Delantero', NULL),
    ('J', 30, 10, N'Memphis', N'Depay', '19940213', N'Corinthians', N'Delantero', NULL),
    ('J', 30, 11, N'Cody', N'Gakpo', '19990507', N'Liverpool', N'Delantero', NULL),
    ('J', 30, 12, N'Mark', N'Flekken', '19930613', N'Bayer Leverkusen', N'Arquero', NULL),
    ('J', 30, 13, N'Micky', N'Van de Ven', '20010419', N'Tottenham', N'Defensor', NULL),
    ('J', 30, 14, N'Tijjani', N'Reijnders', '19980729', N'Manchester City', N'Mediocampista', NULL),
    ('J', 30, 15, N'Jurrien', N'Timber', '20010617', N'Arsenal', N'Defensor', NULL),
    ('J', 30, 16, N'Justin', N'Bijlow', '19980122', N'Feyenoord', N'Arquero', NULL),
    ('J', 30, 17, N'Donyell', N'Malen', '19990119', N'Aston Villa', N'Delantero', NULL),
    ('J', 30, 18, N'Ryan', N'Gravenberch', '20020516', N'Liverpool', N'Mediocampista', NULL),
    ('J', 30, 19, N'Wout', N'Weghorst', '19920807', N'Ajax', N'Delantero', NULL),
    ('J', 30, 20, N'Teun', N'Koopmeiners', '19980228', N'Juventus', N'Mediocampista', NULL),
    ('J', 30, 21, N'Joshua', N'Zirkzee', '20010522', N'Manchester United', N'Delantero', NULL),
    ('J', 30, 22, N'Quinten', N'Timber', '20010617', N'Feyenoord', N'Mediocampista', NULL),
    ('J', 30, 23, N'Jeremie', N'Frimpong', '20001210', N'Liverpool', N'Defensor', NULL),
    ('T', 30, 30, N'Ronald', N'Koeman', '19630321', NULL, NULL, N'Director Tecnico'),
    ('T', 30, 31, N'Erwin', N'Koeman', '19610920', NULL, NULL, N'Asistente'),
    ('T', 30, 32, N'Patrick', N'Van Leeuwen', '19790815', NULL, NULL, N'Asistente'),
    ('J', 31, 1, N'Robin', N'Olsen', '19900108', N'Malmo', N'Arquero', NULL),
    ('J', 31, 2, N'Emil', N'Krafth', '19940802', N'Newcastle United', N'Defensor', NULL),
    ('J', 31, 3, N'Victor', N'Lindelof', '19940717', N'Aston Villa', N'Defensor', NULL),
    ('J', 31, 4, N'Isak', N'Hien', '19990113', N'Atalanta', N'Defensor', NULL),
    ('J', 31, 5, N'Ludwig', N'Augustinsson', '19940421', N'Anderlecht', N'Defensor', NULL),
    ('J', 31, 6, N'Jesper', N'Karlstrom', '19950621', N'Udinese', N'Mediocampista', NULL),
    ('J', 31, 7, N'Viktor', N'Claesson', '19920102', N'Copenhague', N'Mediocampista', NULL),
    ('J', 31, 8, N'Emil', N'Forsberg', '19911023', N'New York Red Bulls', N'Mediocampista', NULL),
    ('J', 31, 9, N'Alexander', N'Isak', '19990921', N'Liverpool', N'Delantero', NULL),
    ('J', 31, 10, N'Viktor', N'Gyokeres', '19980604', N'Arsenal', N'Delantero', NULL),
    ('J', 31, 11, N'Dejan', N'Kulusevski', '20000425', N'Tottenham', N'Delantero', NULL),
    ('J', 31, 12, N'Viktor', N'Johansson', '19980914', N'Stoke City', N'Arquero', NULL),
    ('J', 31, 13, N'Ken', N'Sema', '19930930', N'Pafos', N'Mediocampista', NULL),
    ('J', 31, 14, N'Hugo', N'Larsson', '20040627', N'Eintracht Frankfurt', N'Mediocampista', NULL),
    ('J', 31, 15, N'Carl', N'Starfelt', '19950601', N'Celta de Vigo', N'Defensor', NULL),
    ('J', 31, 16, N'Kristoffer', N'Nordfeldt', '19890623', N'AIK', N'Arquero', NULL),
    ('J', 31, 17, N'Anthony', N'Elanga', '20020427', N'Newcastle United', N'Delantero', NULL),
    ('J', 31, 18, N'Yasin', N'Ayari', '20031006', N'Brighton', N'Mediocampista', NULL),
    ('J', 31, 19, N'Gustaf', N'Nilsson', '19970523', N'Brujas', N'Delantero', NULL),
    ('J', 31, 20, N'Jens', N'Cajuste', '19990810', N'Ipswich Town', N'Mediocampista', NULL),
    ('J', 31, 21, N'Gabriel', N'Gudmundsson', '19990429', N'Leeds United', N'Defensor', NULL),
    ('J', 31, 22, N'Alexander', N'Bernhardsson', '19980908', N'Holstein Kiel', N'Delantero', NULL),
    ('J', 31, 23, N'Lucas', N'Bergvall', '20060202', N'Tottenham', N'Mediocampista', NULL),
    ('T', 31, 30, N'Graham', N'Potter', '19750520', NULL, NULL, N'Director Tecnico'),
    ('T', 31, 31, N'Anders', N'Lindberg', '19760412', NULL, NULL, N'Asistente'),
    ('T', 31, 32, N'Johan', N'Eriksson', '19810318', NULL, NULL, N'Asistente'),
    ('J', 32, 1, N'Aymen', N'Dahmen', '19970128', N'CS Sfaxien', N'Arquero', NULL),
    ('J', 32, 2, N'Wajdi', N'Kechrida', '19951105', N'Al Gharafa', N'Defensor', NULL),
    ('J', 32, 3, N'Montassar', N'Talbi', '19980526', N'Lorient', N'Defensor', NULL),
    ('J', 32, 4, N'Yassine', N'Meriah', '19930702', N'Esperance', N'Defensor', NULL),
    ('J', 32, 5, N'Ali', N'Abdi', '19931220', N'Nice', N'Defensor', NULL),
    ('J', 32, 6, N'Ellyes', N'Skhiri', '19950510', N'Eintracht Frankfurt', N'Mediocampista', NULL),
    ('J', 32, 7, N'Youssef', N'Msakni', '19901028', N'Al Arabi', N'Delantero', NULL),
    ('J', 32, 8, N'Hannibal', N'Mejbri', '20030121', N'Burnley', N'Mediocampista', NULL),
    ('J', 32, 9, N'Seifeddine', N'Jaziri', '19930212', N'Zamalek', N'Delantero', NULL),
    ('J', 32, 10, N'Anis', N'Ben Slimane', '20010316', N'Norwich City', N'Mediocampista', NULL),
    ('J', 32, 11, N'Elias', N'Achouri', '19990210', N'Copenhague', N'Delantero', NULL),
    ('J', 32, 12, N'Bechir', N'Ben Said', '19941129', N'Esperance', N'Arquero', NULL),
    ('J', 32, 13, N'Ferjani', N'Sassi', '19920318', N'Al Gharafa', N'Mediocampista', NULL),
    ('J', 32, 14, N'Aissa', N'Laidouni', '19961213', N'Al Wakrah', N'Mediocampista', NULL),
    ('J', 32, 15, N'Dylan', N'Bronn', '19950619', N'Salernitana', N'Defensor', NULL),
    ('J', 32, 16, N'Mouez', N'Hassen', '19950305', N'Club Africain', N'Arquero', NULL),
    ('J', 32, 17, N'Hamza', N'Rafia', '19990402', N'Lecce', N'Mediocampista', NULL),
    ('J', 32, 18, N'Mohamed Ali', N'Ben Romdhane', '19990906', N'Al Ahly', N'Mediocampista', NULL),
    ('J', 32, 19, N'Haythem', N'Jouini', '19930507', N'Al Bataeh', N'Delantero', NULL),
    ('J', 32, 20, N'Sayfallah', N'Ltaief', '20000422', N'Twente', N'Delantero', NULL),
    ('J', 32, 21, N'Nader', N'Ghandri', '19950218', N'Akhmat Grozny', N'Defensor', NULL),
    ('J', 32, 22, N'Yan', N'Valery', '19990222', N'Sheffield Wednesday', N'Defensor', NULL),
    ('J', 32, 23, N'Bassem', N'Srarfi', '19970625', N'Club Africain', N'Delantero', NULL),
    ('T', 32, 30, N'Sami', N'Trabelsi', '19680204', NULL, NULL, N'Director Tecnico'),
    ('T', 32, 31, N'Karim', N'Ben Salem', '19770514', NULL, NULL, N'Asistente'),
    ('T', 32, 32, N'Mohamed', N'Mansouri', '19820422', NULL, NULL, N'Asistente'),
    ('J', 33, 1, N'Thibaut', N'Courtois', '19920511', N'Real Madrid', N'Arquero', NULL),
    ('J', 33, 2, N'Zeno', N'Debast', '20031024', N'Sporting Lisboa', N'Defensor', NULL),
    ('J', 33, 3, N'Arthur', N'Theate', '20000525', N'Eintracht Frankfurt', N'Defensor', NULL),
    ('J', 33, 4, N'Wout', N'Faes', '19980403', N'Leicester City', N'Defensor', NULL),
    ('J', 33, 5, N'Jan', N'Vertonghen', '19870424', N'Anderlecht', N'Defensor', NULL),
    ('J', 33, 6, N'Amadou', N'Onana', '20010816', N'Aston Villa', N'Mediocampista', NULL),
    ('J', 33, 7, N'Kevin', N'De Bruyne', '19910628', N'Napoli', N'Mediocampista', NULL),
    ('J', 33, 8, N'Youri', N'Tielemans', '19970507', N'Aston Villa', N'Mediocampista', NULL),
    ('J', 33, 9, N'Romelu', N'Lukaku', '19930513', N'Napoli', N'Delantero', NULL),
    ('J', 33, 10, N'Jeremy', N'Doku', '20020527', N'Manchester City', N'Delantero', NULL),
    ('J', 33, 11, N'Leandro', N'Trossard', '19941204', N'Arsenal', N'Delantero', NULL),
    ('J', 33, 12, N'Koen', N'Casteels', '19920625', N'Al Qadsiah', N'Arquero', NULL),
    ('J', 33, 13, N'Maxim', N'De Cuyper', '20001222', N'Brighton', N'Defensor', NULL),
    ('J', 33, 14, N'Dodi', N'Lukebakio', '19970924', N'Benfica', N'Delantero', NULL),
    ('J', 33, 15, N'Thomas', N'Meunier', '19910912', N'Lille', N'Defensor', NULL),
    ('J', 33, 16, N'Matz', N'Sels', '19920226', N'Nottingham Forest', N'Arquero', NULL),
    ('J', 33, 17, N'Charles', N'De Ketelaere', '20010310', N'Atalanta', N'Mediocampista', NULL),
    ('J', 33, 18, N'Orel', N'Mangala', '19980318', N'Olympique Lyon', N'Mediocampista', NULL),
    ('J', 33, 19, N'Lois', N'Openda', '20000216', N'Juventus', N'Delantero', NULL),
    ('J', 33, 20, N'Johan', N'Bakayoko', '20030420', N'RB Leipzig', N'Delantero', NULL),
    ('J', 33, 21, N'Timothy', N'Castagne', '19951205', N'Fulham', N'Defensor', NULL),
    ('J', 33, 22, N'Malick', N'Fofana', '20050331', N'Olympique Lyon', N'Delantero', NULL),
    ('J', 33, 23, N'Arthur', N'Vermeeren', '20050207', N'Olympique Marsella', N'Mediocampista', NULL),
    ('T', 33, 30, N'Rudi', N'Garcia', '19640220', NULL, NULL, N'Director Tecnico'),
    ('T', 33, 31, N'Marc', N'Willems', '19760412', NULL, NULL, N'Asistente'),
    ('T', 33, 32, N'Peter', N'De Smet', '19810318', NULL, NULL, N'Asistente'),
    ('J', 34, 1, N'Mohamed', N'El Shenawy', '19881218', N'Al Ahly', N'Arquero', NULL),
    ('J', 34, 2, N'Omar', N'Kamal', '19930929', N'Al Ahly', N'Defensor', NULL),
    ('J', 34, 3, N'Mohamed', N'Abdelmonem', '19990201', N'Nice', N'Defensor', NULL),
    ('J', 34, 4, N'Ahmed', N'Hegazi', '19910125', N'NEOM', N'Defensor', NULL),
    ('J', 34, 5, N'Mohamed', N'Hamdy', '19950315', N'Pyramids FC', N'Defensor', NULL),
    ('J', 34, 6, N'Hamdy', N'Fathy', '19940929', N'Al Wakrah', N'Mediocampista', NULL),
    ('J', 34, 7, N'Mahmoud', N'Trezeguet', '19941001', N'Al Ahly', N'Delantero', NULL),
    ('J', 34, 8, N'Emam', N'Ashour', '19980220', N'Al Ahly', N'Mediocampista', NULL),
    ('J', 34, 9, N'Mostafa', N'Mohamed', '19971128', N'Nantes', N'Delantero', NULL),
    ('J', 34, 10, N'Mohamed', N'Salah', '19920615', N'Liverpool', N'Delantero', NULL),
    ('J', 34, 11, N'Omar', N'Marmoush', '19990207', N'Manchester City', N'Delantero', NULL),
    ('J', 34, 12, N'Mohamed', N'Abou Gabal', '19890129', N'National Bank', N'Arquero', NULL),
    ('J', 34, 13, N'Ahmed', N'Fatouh', '19980322', N'Zamalek', N'Defensor', NULL),
    ('J', 34, 14, N'Marwan', N'Attia', '19980812', N'Al Ahly', N'Mediocampista', NULL),
    ('J', 34, 15, N'Yasser', N'Ibrahim', '19930210', N'Al Ahly', N'Defensor', NULL),
    ('J', 34, 16, N'Mostafa', N'Shoubeir', '20000317', N'Al Ahly', N'Arquero', NULL),
    ('J', 34, 17, N'Ahmed', N'Sayed Zizo', '19960110', N'Al Ahly', N'Mediocampista', NULL),
    ('J', 34, 18, N'Mohamed', N'Elneny', '19920711', N'Al Jazira', N'Mediocampista', NULL),
    ('J', 34, 19, N'Mahmoud', N'Kahraba', '19940413', N'Al Ittihad Tripoli', N'Delantero', NULL),
    ('J', 34, 20, N'Ibrahim', N'Adel', '20010423', N'Al Jazira', N'Delantero', NULL),
    ('J', 34, 21, N'Ahmed', N'Ramadan', '19970523', N'Ceramica Cleopatra', N'Defensor', NULL),
    ('J', 34, 22, N'Mohamed', N'Shehata', '20010208', N'Zamalek', N'Mediocampista', NULL),
    ('J', 34, 23, N'Osama', N'Faisal', '20010101', N'National Bank', N'Delantero', NULL),
    ('T', 34, 30, N'Hossam', N'Hassan', '19660810', NULL, NULL, N'Director Tecnico'),
    ('T', 34, 31, N'Ibrahim', N'Hassan', '19660810', NULL, NULL, N'Asistente'),
    ('T', 34, 32, N'Ahmed', N'Mansour', '19820415', NULL, NULL, N'Asistente'),
    ('J', 35, 1, N'Alireza', N'Beiranvand', '19920921', N'Tractor', N'Arquero', NULL),
    ('J', 35, 2, N'Sadegh', N'Moharrami', '19960301', N'Dinamo Zagreb', N'Defensor', NULL),
    ('J', 35, 3, N'Ehsan', N'Hajsafi', '19900225', N'AEK Atenas', N'Defensor', NULL),
    ('J', 35, 4, N'Shoja', N'Khalilzadeh', '19890514', N'Tractor', N'Defensor', NULL),
    ('J', 35, 5, N'Majid', N'Hosseini', '19960620', N'Kayserispor', N'Defensor', NULL),
    ('J', 35, 6, N'Saeid', N'Ezatolahi', '19961001', N'Shabab Al Ahli', N'Mediocampista', NULL),
    ('J', 35, 7, N'Alireza', N'Jahanbakhsh', '19930811', N'Heerenveen', N'Delantero', NULL),
    ('J', 35, 8, N'Ahmad', N'Noorollahi', '19930201', N'Al Wahda', N'Mediocampista', NULL),
    ('J', 35, 9, N'Mehdi', N'Taremi', '19920718', N'Olympiacos', N'Delantero', NULL),
    ('J', 35, 10, N'Sardar', N'Azmoun', '19950101', N'Shabab Al Ahli', N'Delantero', NULL),
    ('J', 35, 11, N'Mehdi', N'Ghayedi', '19981205', N'Al Ittihad Kalba', N'Delantero', NULL),
    ('J', 35, 12, N'Hossein', N'Hosseini', '19920630', N'Esteghlal', N'Arquero', NULL),
    ('J', 35, 13, N'Milad', N'Mohammadi', '19930929', N'Persepolis', N'Defensor', NULL),
    ('J', 35, 14, N'Saman', N'Ghoddos', '19930906', N'Al Ittihad Kalba', N'Mediocampista', NULL),
    ('J', 35, 15, N'Hossein', N'Kanaanizadegan', '19940323', N'Persepolis', N'Defensor', NULL),
    ('J', 35, 16, N'Payam', N'Niazmand', '19950406', N'Sepahan', N'Arquero', NULL),
    ('J', 35, 17, N'Mohammad', N'Mohebi', '19981220', N'Rostov', N'Delantero', NULL),
    ('J', 35, 18, N'Ali', N'Gholizadeh', '19960310', N'Lech Poznan', N'Delantero', NULL),
    ('J', 35, 19, N'Shahriar', N'Moghanlou', '19941221', N'Al Ittihad Kalba', N'Delantero', NULL),
    ('J', 35, 20, N'Omid', N'Norafkan', '19970409', N'Malavan', N'Mediocampista', NULL),
    ('J', 35, 21, N'Ramin', N'Rezaeian', '19900321', N'Esteghlal', N'Defensor', NULL),
    ('J', 35, 22, N'Mohammad', N'Ghorbani', '20010521', N'Al Wahda', N'Mediocampista', NULL),
    ('J', 35, 23, N'Amin', N'Hezbavi', '20030506', N'Sepahan', N'Defensor', NULL),
    ('T', 35, 30, N'Amir', N'Ghalenoei', '19631121', NULL, NULL, N'Director Tecnico'),
    ('T', 35, 31, N'Reza', N'Karimi', '19760412', NULL, NULL, N'Asistente'),
    ('T', 35, 32, N'Hamid', N'Rahimi', '19810318', NULL, NULL, N'Asistente'),
    ('J', 36, 1, N'Max', N'Crocombe', '19930812', N'Burton Albion', N'Arquero', NULL),
    ('J', 36, 2, N'Tim', N'Payne', '19940110', N'Wellington Phoenix', N'Defensor', NULL),
    ('J', 36, 3, N'Liberato', N'Cacace', '20000927', N'Wrexham', N'Defensor', NULL),
    ('J', 36, 4, N'Michael', N'Boxall', '19880818', N'Minnesota United', N'Defensor', NULL),
    ('J', 36, 5, N'Bill', N'Tuiloma', '19950327', N'Charlotte FC', N'Defensor', NULL),
    ('J', 36, 6, N'Joe', N'Bell', '19990427', N'Viking', N'Mediocampista', NULL),
    ('J', 36, 7, N'Kosta', N'Barbarouses', '19900219', N'Wellington Phoenix', N'Delantero', NULL),
    ('J', 36, 8, N'Marko', N'Stamenic', '20020219', N'Olympiacos', N'Mediocampista', NULL),
    ('J', 36, 9, N'Chris', N'Wood', '19911207', N'Nottingham Forest', N'Delantero', NULL),
    ('J', 36, 10, N'Sarpreet', N'Singh', '19990220', N'Uniao de Leiria', N'Mediocampista', NULL),
    ('J', 36, 11, N'Ben', N'Waine', '20010611', N'Plymouth Argyle', N'Delantero', NULL),
    ('J', 36, 12, N'Alex', N'Paulsen', '20020704', N'Auckland FC', N'Arquero', NULL),
    ('J', 36, 13, N'Francis', N'De Vries', '19941128', N'Auckland FC', N'Defensor', NULL),
    ('J', 36, 14, N'Matthew', N'Garbet', '20020413', N'NAC Breda', N'Mediocampista', NULL),
    ('J', 36, 15, N'Nando', N'Pijnaker', '19990225', N'Auckland FC', N'Defensor', NULL),
    ('J', 36, 16, N'Oliver', N'Sail', '19960113', N'Perth Glory', N'Arquero', NULL),
    ('J', 36, 17, N'Elijah', N'Just', '20000501', N'AC Horsens', N'Delantero', NULL),
    ('J', 36, 18, N'Clayton', N'Lewis', '19970212', N'Macarthur FC', N'Mediocampista', NULL),
    ('J', 36, 19, N'Alex', N'Greive', '19990513', N'Bohemians', N'Delantero', NULL),
    ('J', 36, 20, N'Callum', N'McCowatt', '19990430', N'Silkeborg', N'Delantero', NULL),
    ('J', 36, 21, N'Tyler', N'Bindon', '20050127', N'Nottingham Forest', N'Defensor', NULL),
    ('J', 36, 22, N'Ben', N'Old', '20020813', N'Saint Etienne', N'Mediocampista', NULL),
    ('J', 36, 23, N'Finn', N'Surman', '20030923', N'Portland Timbers', N'Defensor', NULL),
    ('T', 36, 30, N'Darren', N'Bazeley', '19721005', NULL, NULL, N'Director Tecnico'),
    ('T', 36, 31, N'James', N'Anderson', '19760514', NULL, NULL, N'Asistente'),
    ('T', 36, 32, N'Peter', N'Mitchell', '19820422', NULL, NULL, N'Asistente'),
    ('J', 37, 1, N'Vozinha', N'Dias', '19860603', N'Trencin', N'Arquero', NULL),
    ('J', 37, 2, N'Steven', N'Moreira', '19940813', N'Columbus Crew', N'Defensor', NULL),
    ('J', 37, 3, N'Stopira', N'Fernandes', '19880520', N'Fehervar', N'Defensor', NULL),
    ('J', 37, 4, N'Roberto', N'Lopes', '19920617', N'Shamrock Rovers', N'Defensor', NULL),
    ('J', 37, 5, N'Logan', N'Costa', '20010401', N'Villarreal', N'Defensor', NULL),
    ('J', 37, 6, N'Patrick', N'Andrade', '19930209', N'Qarabag', N'Mediocampista', NULL),
    ('J', 37, 7, N'Ryan', N'Mendes', '19900108', N'Kocaelispor', N'Delantero', NULL),
    ('J', 37, 8, N'Kevin', N'Pina', '19970127', N'Krasnodar', N'Mediocampista', NULL),
    ('J', 37, 9, N'Dailon', N'Livramento', '20010504', N'Hellas Verona', N'Delantero', NULL),
    ('J', 37, 10, N'Jovane', N'Cabral', '19980614', N'Estrela Amadora', N'Delantero', NULL),
    ('J', 37, 11, N'Garry', N'Rodrigues', '19901127', N'Sivasspor', N'Delantero', NULL),
    ('J', 37, 12, N'Marcio', N'Rosa', '19970223', N'Montalegre', N'Arquero', NULL),
    ('J', 37, 13, N'Joao', N'Correia', '19960905', N'Pafos', N'Defensor', NULL),
    ('J', 37, 14, N'Deroy', N'Duarte', '19990704', N'Ludogorets', N'Mediocampista', NULL),
    ('J', 37, 15, N'Diney', N'Borges', '19950117', N'Al Bataeh', N'Defensor', NULL),
    ('J', 37, 16, N'Bruno', N'Varela', '19941104', N'Vitoria Guimaraes', N'Arquero', NULL),
    ('J', 37, 17, N'Willy', N'Semedo', '19940427', N'Omonia', N'Delantero', NULL),
    ('J', 37, 18, N'Jamiro', N'Monteiro', '19931123', N'PEC Zwolle', N'Mediocampista', NULL),
    ('J', 37, 19, N'Bebe', N'Dias', '19900712', N'Racing Ferrol', N'Delantero', NULL),
    ('J', 37, 20, N'Kenny', N'Rocha Santos', '20000103', N'AEZ Zakakiou', N'Mediocampista', NULL),
    ('J', 37, 21, N'Wagner', N'Pina', '20021103', N'Estoril', N'Defensor', NULL),
    ('J', 37, 22, N'Helio', N'Varela', '20020503', N'Gent', N'Delantero', NULL),
    ('J', 37, 23, N'Gilson', N'Tavares', '20011229', N'Benfica B', N'Delantero', NULL),
    ('T', 37, 30, N'Pedro', N'Brito', '19700106', NULL, NULL, N'Director Tecnico'),
    ('T', 37, 31, N'Carlos', N'Monteiro', '19760415', NULL, NULL, N'Asistente'),
    ('T', 37, 32, N'Antonio', N'Fernandes', '19810320', NULL, NULL, N'Asistente'),
    ('J', 38, 1, N'Mohammed', N'Al Owais', '19911010', N'Al Hilal', N'Arquero', NULL),
    ('J', 38, 2, N'Sultan', N'Al Ghannam', '19940506', N'Al Nassr', N'Defensor', NULL),
    ('J', 38, 3, N'Abdulelah', N'Al Amri', '19970115', N'Al Nassr', N'Defensor', NULL),
    ('J', 38, 4, N'Ali', N'Al Bulayhi', '19891121', N'Al Hilal', N'Defensor', NULL),
    ('J', 38, 5, N'Hassan', N'Tambakti', '19990209', N'Al Hilal', N'Defensor', NULL),
    ('J', 38, 6, N'Mohammed', N'Kanno', '19940922', N'Al Hilal', N'Mediocampista', NULL),
    ('J', 38, 7, N'Salman', N'Al Faraj', '19890801', N'NEOM', N'Mediocampista', NULL),
    ('J', 38, 8, N'Abdulelah', N'Al Malki', '19941011', N'Al Ettifaq', N'Mediocampista', NULL),
    ('J', 38, 9, N'Firas', N'Al Buraikan', '20000514', N'Al Ahli', N'Delantero', NULL),
    ('J', 38, 10, N'Salem', N'Al Dawsari', '19910819', N'Al Hilal', N'Delantero', NULL),
    ('J', 38, 11, N'Saleh', N'Al Shehri', '19931101', N'Al Ittihad', N'Delantero', NULL),
    ('J', 38, 12, N'Nawaf', N'Al Aqidi', '20000510', N'Al Nassr', N'Arquero', NULL),
    ('J', 38, 13, N'Yasser', N'Al Shahrani', '19920525', N'Al Hilal', N'Defensor', NULL),
    ('J', 38, 14, N'Abdullah', N'Al Khaibari', '19960816', N'Al Nassr', N'Mediocampista', NULL),
    ('J', 38, 15, N'Saud', N'Abdulhamid', '19990718', N'Roma', N'Defensor', NULL),
    ('J', 38, 16, N'Ahmed', N'Al Kassar', '19910508', N'Al Qadsiah', N'Arquero', NULL),
    ('J', 38, 17, N'Abdulrahman', N'Ghareeb', '19970331', N'Al Nassr', N'Delantero', NULL),
    ('J', 38, 18, N'Musab', N'Al Juwayr', '20030620', N'Al Shabab', N'Mediocampista', NULL),
    ('J', 38, 19, N'Abdullah', N'Radif', '20030120', N'Al Ettifaq', N'Delantero', NULL),
    ('J', 38, 20, N'Faisal', N'Al Ghamdi', '20010813', N'Al Ittihad', N'Mediocampista', NULL),
    ('J', 38, 21, N'Mohammed', N'Al Burayk', '19920915', N'NEOM', N'Defensor', NULL),
    ('J', 38, 22, N'Marwan', N'Al Sahafi', '20040217', N'Al Ittihad', N'Delantero', NULL),
    ('J', 38, 23, N'Ayman', N'Yahya', '20010514', N'Al Nassr', N'Delantero', NULL),
    ('T', 38, 30, N'Herve', N'Renard', '19680930', NULL, NULL, N'Director Tecnico'),
    ('T', 38, 31, N'Ahmed', N'Al Harbi', '19770514', NULL, NULL, N'Asistente'),
    ('T', 38, 32, N'Khalid', N'Al Qahtani', '19820422', NULL, NULL, N'Asistente'),
    ('J', 39, 1, N'Jalal', N'Hassan', '19910518', N'Al Zawraa', N'Arquero', NULL),
    ('J', 39, 2, N'Hussein', N'Ali', '20020301', N'Heerenveen', N'Defensor', NULL),
    ('J', 39, 3, N'Merchas', N'Doski', '19991207', N'Viktoria Plzen', N'Defensor', NULL),
    ('J', 39, 4, N'Rebin', N'Sulaka', '19920412', N'Erbil', N'Defensor', NULL),
    ('J', 39, 5, N'Zaid', N'Tahseen', '20010129', N'Al Talaba', N'Defensor', NULL),
    ('J', 39, 6, N'Amir', N'Al Ammari', '19970727', N'Cracovia', N'Mediocampista', NULL),
    ('J', 39, 7, N'Ibrahim', N'Bayesh', '20000501', N'Al Riyadh', N'Mediocampista', NULL),
    ('J', 39, 8, N'Osama', N'Rashid', '19920113', N'Vizela', N'Mediocampista', NULL),
    ('J', 39, 9, N'Aymen', N'Hussein', '19960322', N'Al Khor', N'Delantero', NULL),
    ('J', 39, 10, N'Mohanad', N'Ali', '20000620', N'Al Shorta', N'Delantero', NULL),
    ('J', 39, 11, N'Ali', N'Jasim', '20040120', N'Como', N'Delantero', NULL),
    ('J', 39, 12, N'Ahmed', N'Basil', '19960819', N'Al Shorta', N'Arquero', NULL),
    ('J', 39, 13, N'Ahmed', N'Yahya', '20010119', N'Al Shorta', N'Defensor', NULL),
    ('J', 39, 14, N'Zidane', N'Iqbal', '20030427', N'Utrecht', N'Mediocampista', NULL),
    ('J', 39, 15, N'Saad', N'Natiq', '19940319', N'Al Quwa Al Jawiya', N'Defensor', NULL),
    ('J', 39, 16, N'Fahad', N'Talib', '19941021', N'Al Quwa Al Jawiya', N'Arquero', NULL),
    ('J', 39, 17, N'Youssef', N'Amyn', '20030821', N'Al Wehda', N'Delantero', NULL),
    ('J', 39, 18, N'Bashar', N'Resan', '19961222', N'Al Markhiya', N'Mediocampista', NULL),
    ('J', 39, 19, N'Ali', N'Al Hamadi', '20020301', N'Ipswich Town', N'Delantero', NULL),
    ('J', 39, 20, N'Mohammed', N'Qasim', '19961206', N'Al Shorta', N'Mediocampista', NULL),
    ('J', 39, 21, N'Frans', N'Putros', '19930714', N'Port FC', N'Defensor', NULL),
    ('J', 39, 22, N'Kevin', N'Yakob', '20001010', N'Aarhus', N'Mediocampista', NULL),
    ('J', 39, 23, N'Marko', N'Farji', '20040316', N'Stromsgodset', N'Delantero', NULL),
    ('T', 39, 30, N'Graham', N'Arnold', '19630803', NULL, NULL, N'Director Tecnico'),
    ('T', 39, 31, N'Ahmed', N'Al Rawi', '19760412', NULL, NULL, N'Asistente'),
    ('T', 39, 32, N'Omar', N'Al Jubouri', '19810318', NULL, NULL, N'Asistente'),
    ('J', 40, 1, N'Orjan', N'Nyland', '19900910', N'Sevilla', N'Arquero', NULL),
    ('J', 40, 2, N'Julian', N'Ryerson', '19971117', N'Borussia Dortmund', N'Defensor', NULL),
    ('J', 40, 3, N'Kristoffer', N'Ajer', '19980417', N'Brentford', N'Defensor', NULL),
    ('J', 40, 4, N'Leo', N'Ostigard', '19991128', N'Genoa', N'Defensor', NULL),
    ('J', 40, 5, N'David Moller', N'Wolfe', '20020423', N'Wolverhampton', N'Defensor', NULL),
    ('J', 40, 6, N'Patrick', N'Berg', '19971124', N'Bodo Glimt', N'Mediocampista', NULL),
    ('J', 40, 7, N'Alexander', N'Sorloth', '19951205', N'Atletico Madrid', N'Delantero', NULL),
    ('J', 40, 8, N'Sander', N'Berge', '19980214', N'Fulham', N'Mediocampista', NULL),
    ('J', 40, 9, N'Erling', N'Haaland', '20000721', N'Manchester City', N'Delantero', NULL),
    ('J', 40, 10, N'Martin', N'Odegaard', '19981217', N'Arsenal', N'Mediocampista', NULL),
    ('J', 40, 11, N'Antonio', N'Nusa', '20050417', N'RB Leipzig', N'Delantero', NULL),
    ('J', 40, 12, N'Egil', N'Selvik', '19970730', N'Watford', N'Arquero', NULL),
    ('J', 40, 13, N'Torbjorn', N'Heggem', '19990112', N'Bologna', N'Defensor', NULL),
    ('J', 40, 14, N'Kristian', N'Thorstvedt', '19990313', N'Sassuolo', N'Mediocampista', NULL),
    ('J', 40, 15, N'Marcus', N'Pedersen', '20000716', N'Torino', N'Defensor', NULL),
    ('J', 40, 16, N'Mathias', N'Dyngeland', '19951007', N'Brann', N'Arquero', NULL),
    ('J', 40, 17, N'Oscar', N'Bobb', '20030712', N'Manchester City', N'Delantero', NULL),
    ('J', 40, 18, N'Aron', N'Donnum', '19980420', N'Toulouse', N'Delantero', NULL),
    ('J', 40, 19, N'Jorgen', N'Strand Larsen', '20000206', N'Wolverhampton', N'Delantero', NULL),
    ('J', 40, 20, N'Felix', N'Horn Myhre', '19990304', N'Brann', N'Mediocampista', NULL),
    ('J', 40, 21, N'Andreas', N'Hanche Olsen', '19970117', N'Mainz 05', N'Defensor', NULL),
    ('J', 40, 22, N'Morten', N'Thorsby', '19960505', N'Genoa', N'Mediocampista', NULL),
    ('J', 40, 23, N'Andreas', N'Schjelderup', '20040601', N'Benfica', N'Delantero', NULL),
    ('T', 40, 30, N'Stale', N'Solbakken', '19680227', NULL, NULL, N'Director Tecnico'),
    ('T', 40, 31, N'Erik', N'Hansen', '19760412', NULL, NULL, N'Asistente'),
    ('T', 40, 32, N'Lars', N'Johansen', '19810318', NULL, NULL, N'Asistente'),
    ('J', 41, 1, N'Anthony', N'Mandrea', '19961225', N'Caen', N'Arquero', NULL),
    ('J', 41, 2, N'Youcef', N'Atal', '19960517', N'Al Sadd', N'Defensor', NULL),
    ('J', 41, 3, N'Rayan', N'Ait Nouri', '20010606', N'Manchester City', N'Defensor', NULL),
    ('J', 41, 4, N'Aissa', N'Mandi', '19911022', N'Lille', N'Defensor', NULL),
    ('J', 41, 5, N'Ramy', N'Bensebaini', '19950416', N'Borussia Dortmund', N'Defensor', NULL),
    ('J', 41, 6, N'Ismael', N'Bennacer', '19971201', N'Milan', N'Mediocampista', NULL),
    ('J', 41, 7, N'Riyad', N'Mahrez', '19910221', N'Al Ahli', N'Delantero', NULL),
    ('J', 41, 8, N'Hicham', N'Boudaoui', '19990923', N'Nice', N'Mediocampista', NULL),
    ('J', 41, 9, N'Baghdad', N'Bounedjah', '19911124', N'Al Shamal', N'Delantero', NULL),
    ('J', 41, 10, N'Houssem', N'Aouar', '19980630', N'Al Ittihad', N'Mediocampista', NULL),
    ('J', 41, 11, N'Amine', N'Gouiri', '20000216', N'Olympique Marsella', N'Delantero', NULL),
    ('J', 41, 12, N'Alexandre', N'Oukidja', '19880719', N'Metz', N'Arquero', NULL),
    ('J', 41, 13, N'Mohamed', N'Amoura', '20000509', N'Wolfsburgo', N'Delantero', NULL),
    ('J', 41, 14, N'Ramiz', N'Zerrouki', '19980526', N'Feyenoord', N'Mediocampista', NULL),
    ('J', 41, 15, N'Mohamed', N'Tougai', '20000110', N'Esperance', N'Defensor', NULL),
    ('J', 41, 16, N'Oussama', N'Benbot', '19941011', N'USM Alger', N'Arquero', NULL),
    ('J', 41, 17, N'Said', N'Benrahma', '19950810', N'NEOM', N'Delantero', NULL),
    ('J', 41, 18, N'Farès', N'Chaibi', '20021128', N'Eintracht Frankfurt', N'Mediocampista', NULL),
    ('J', 41, 19, N'Anis', N'Hadj Moussa', '20020211', N'Feyenoord', N'Delantero', NULL),
    ('J', 41, 20, N'Yassine', N'Benzia', '19940908', N'Qarabag', N'Mediocampista', NULL),
    ('J', 41, 21, N'Kevin', N'Guitoun', '19960222', N'Metz', N'Defensor', NULL),
    ('J', 41, 22, N'Adem', N'Zorgane', '20000106', N'Charleroi', N'Mediocampista', NULL),
    ('J', 41, 23, N'Jaouen', N'Hadjam', '20030326', N'Young Boys', N'Defensor', NULL),
    ('T', 41, 30, N'Vladimir', N'Petkovic', '19630815', NULL, NULL, N'Director Tecnico'),
    ('T', 41, 31, N'Karim', N'Mansouri', '19770514', NULL, NULL, N'Asistente'),
    ('T', 41, 32, N'Samir', N'Brahimi', '19820422', NULL, NULL, N'Asistente'),
    ('J', 42, 1, N'Patrick', N'Pentz', '19970102', N'Brondby', N'Arquero', NULL),
    ('J', 42, 2, N'Stefan', N'Posch', '19970514', N'Bologna', N'Defensor', NULL),
    ('J', 42, 3, N'Philipp', N'Lienhart', '19960711', N'Friburgo', N'Defensor', NULL),
    ('J', 42, 4, N'Kevin', N'Danso', '19980919', N'Tottenham', N'Defensor', NULL),
    ('J', 42, 5, N'Maximilian', N'Wober', '19980204', N'Werder Bremen', N'Defensor', NULL),
    ('J', 42, 6, N'Nicolas', N'Seiwald', '20010504', N'RB Leipzig', N'Mediocampista', NULL),
    ('J', 42, 7, N'Marcel', N'Sabitzer', '19940317', N'Borussia Dortmund', N'Mediocampista', NULL),
    ('J', 42, 8, N'Konrad', N'Laimer', '19970527', N'Bayern Munich', N'Mediocampista', NULL),
    ('J', 42, 9, N'Sasa', N'Kalajdzic', '19970707', N'Wolverhampton', N'Delantero', NULL),
    ('J', 42, 10, N'Florian', N'Grillitsch', '19950807', N'Hoffenheim', N'Mediocampista', NULL),
    ('J', 42, 11, N'Michael', N'Gregoritsch', '19940418', N'Friburgo', N'Delantero', NULL),
    ('J', 42, 12, N'Alexander', N'Schlager', '19960201', N'Red Bull Salzburg', N'Arquero', NULL),
    ('J', 42, 13, N'Christoph', N'Baumgartner', '19990801', N'RB Leipzig', N'Mediocampista', NULL),
    ('J', 42, 14, N'Patrick', N'Wimmer', '20010530', N'Wolfsburgo', N'Delantero', NULL),
    ('J', 42, 15, N'David', N'Alaba', '19920624', N'Real Madrid', N'Defensor', NULL),
    ('J', 42, 16, N'Heinz', N'Lindner', '19900717', N'Union Saint Gilloise', N'Arquero', NULL),
    ('J', 42, 17, N'Marko', N'Arnautovic', '19890419', N'Estrella Roja', N'Delantero', NULL),
    ('J', 42, 18, N'Romano', N'Schmid', '20000127', N'Werder Bremen', N'Mediocampista', NULL),
    ('J', 42, 19, N'Junior', N'Adamu', '20010606', N'Friburgo', N'Delantero', NULL),
    ('J', 42, 20, N'Alexander', N'Prass', '20010526', N'Hoffenheim', N'Mediocampista', NULL),
    ('J', 42, 21, N'Gernot', N'Trauner', '19920325', N'Feyenoord', N'Defensor', NULL),
    ('J', 42, 22, N'Andreas', N'Weimann', '19910805', N'Blackburn Rovers', N'Delantero', NULL),
    ('J', 42, 23, N'Flavius', N'Daniliuc', '20010427', N'Salernitana', N'Defensor', NULL),
    ('T', 42, 30, N'Ralf', N'Rangnick', '19580629', NULL, NULL, N'Director Tecnico'),
    ('T', 42, 31, N'Peter', N'Schneider', '19760415', NULL, NULL, N'Asistente'),
    ('T', 42, 32, N'Thomas', N'Berger', '19810320', NULL, NULL, N'Asistente'),
    ('J', 43, 1, N'Yazeed', N'Abulaila', '19930108', N'Al Jabalain', N'Arquero', NULL),
    ('J', 43, 2, N'Ihsan', N'Haddad', '19940205', N'Al Faisaly', N'Defensor', NULL),
    ('J', 43, 3, N'Abdallah', N'Nasib', '19940225', N'Al Hussein', N'Defensor', NULL),
    ('J', 43, 4, N'Yazan', N'Al Arab', '19960131', N'FC Seoul', N'Defensor', NULL),
    ('J', 43, 5, N'Salem', N'Al Ajalin', '19880218', N'Al Faisaly', N'Defensor', NULL),
    ('J', 43, 6, N'Nizar', N'Al Rashdan', '19990323', N'Al Hussein', N'Mediocampista', NULL),
    ('J', 43, 7, N'Mousa', N'Al Tamari', '19970610', N'Rennes', N'Delantero', NULL),
    ('J', 43, 8, N'Noor', N'Al Rawabdeh', '19970224', N'Selangor', N'Mediocampista', NULL),
    ('J', 43, 9, N'Yazan', N'Al Naimat', '19990604', N'Al Arabi', N'Delantero', NULL),
    ('J', 43, 10, N'Ali', N'Olwan', '20000326', N'Selangor', N'Delantero', NULL),
    ('J', 43, 11, N'Mahmoud', N'Al Mardi', '19931006', N'Al Hussein', N'Delantero', NULL),
    ('J', 43, 12, N'Abdallah', N'Al Fakhouri', '20000122', N'Al Wehdat', N'Arquero', NULL),
    ('J', 43, 13, N'Mohammad', N'Abu Hashish', '19950509', N'Al Hussein', N'Defensor', NULL),
    ('J', 43, 14, N'Rajaei', N'Ayed', '19930725', N'Al Wehdat', N'Mediocampista', NULL),
    ('J', 43, 15, N'Anas', N'Bani Yaseen', '19881129', N'Al Faisaly', N'Defensor', NULL),
    ('J', 43, 16, N'Ahmad', N'Juaidi', '19970717', N'Al Hussein', N'Arquero', NULL),
    ('J', 43, 17, N'Mohammad', N'Abu Zrayq', '19971230', N'Al Faisaly', N'Delantero', NULL),
    ('J', 43, 18, N'Saleh', N'Rateb', '19941218', N'Al Wehdat', N'Mediocampista', NULL),
    ('J', 43, 19, N'Hamza', N'Al Dardour', '19910512', N'Al Hussein', N'Delantero', NULL),
    ('J', 43, 20, N'Fadi', N'Awad', '19930326', N'PDRM', N'Mediocampista', NULL),
    ('J', 43, 21, N'Mohammad', N'Abu Al Nadi', '20010208', N'Al Hussein', N'Defensor', NULL),
    ('J', 43, 22, N'Ibrahim', N'Sadeh', '20000427', N'Al Khor', N'Mediocampista', NULL),
    ('J', 43, 23, N'Anas', N'Al Awadat', '19980529', N'Al Wehdat', N'Delantero', NULL),
    ('T', 43, 30, N'Jamal', N'Sellami', '19701006', NULL, NULL, N'Director Tecnico'),
    ('T', 43, 31, N'Ahmad', N'Al Khaldi', '19770514', NULL, NULL, N'Asistente'),
    ('T', 43, 32, N'Omar', N'Al Hamdan', '19820422', NULL, NULL, N'Asistente'),
    ('J', 44, 1, N'Lionel', N'Mpasi', '19940801', N'Rodez', N'Arquero', NULL),
    ('J', 44, 2, N'Gedeon', N'Kalulu', '19970829', N'Lorient', N'Defensor', NULL),
    ('J', 44, 3, N'Arthur', N'Masuaku', '19931107', N'Sunderland', N'Defensor', NULL),
    ('J', 44, 4, N'Chancel', N'Mbemba', '19940808', N'Lille', N'Defensor', NULL),
    ('J', 44, 5, N'Dylan', N'Batubinsika', '19960215', N'Saint Etienne', N'Defensor', NULL),
    ('J', 44, 6, N'Samuel', N'Moutoussamy', '19960812', N'Sivasspor', N'Mediocampista', NULL),
    ('J', 44, 7, N'Yoane', N'Wissa', '19960903', N'Newcastle United', N'Delantero', NULL),
    ('J', 44, 8, N'Charles', N'Pickel', '19970515', N'Cremonese', N'Mediocampista', NULL),
    ('J', 44, 9, N'Cedric', N'Bakambu', '19910411', N'Real Betis', N'Delantero', NULL),
    ('J', 44, 10, N'Gael', N'Kakuta', '19910621', N'Esteghlal', N'Mediocampista', NULL),
    ('J', 44, 11, N'Meschack', N'Elia', '19970806', N'Young Boys', N'Delantero', NULL),
    ('J', 44, 12, N'Dimitry', N'Bertaud', '19980606', N'Montpellier', N'Arquero', NULL),
    ('J', 44, 13, N'Joris', N'Kayembe', '19940808', N'Genk', N'Defensor', NULL),
    ('J', 44, 14, N'Edo', N'Kayembe', '19980603', N'Watford', N'Mediocampista', NULL),
    ('J', 44, 15, N'Henock', N'Inonga', '19931101', N'AS FAR', N'Defensor', NULL),
    ('J', 44, 16, N'Baggio', N'Siadi', '19970721', N'TP Mazembe', N'Arquero', NULL),
    ('J', 44, 17, N'Silas', N'Katompa Mvumpa', '19981006', N'Stuttgart', N'Delantero', NULL),
    ('J', 44, 18, N'Theo', N'Bongonda', '19951120', N'Spartak Moscu', N'Delantero', NULL),
    ('J', 44, 19, N'Fiston', N'Mayele', '19940624', N'Pyramids FC', N'Delantero', NULL),
    ('J', 44, 20, N'Noah', N'Sadiki', '20041217', N'Sunderland', N'Mediocampista', NULL),
    ('J', 44, 21, N'Axel', N'Tuanzebe', '19971114', N'Burnley', N'Defensor', NULL),
    ('J', 44, 22, N'Nathanael', N'Mbuku', '20020316', N'Dinamo Zagreb', N'Delantero', NULL),
    ('J', 44, 23, N'Simon', N'Banza', '19960813', N'Braga', N'Delantero', NULL),
    ('T', 44, 30, N'Sebastien', N'Desabre', '19760802', NULL, NULL, N'Director Tecnico'),
    ('T', 44, 31, N'Patrick', N'Ilunga', '19760412', NULL, NULL, N'Asistente'),
    ('T', 44, 32, N'Alain', N'Mbuyi', '19810318', NULL, NULL, N'Asistente'),
    ('J', 45, 1, N'Utkir', N'Yusupov', '19910104', N'Foolad', N'Arquero', NULL),
    ('J', 45, 2, N'Abdukodir', N'Khusanov', '20040229', N'Manchester City', N'Defensor', NULL),
    ('J', 45, 3, N'Farrukh', N'Sayfiyev', '19910117', N'Navbahor', N'Defensor', NULL),
    ('J', 45, 4, N'Rustam', N'Ashurmatov', '19960707', N'Rubin Kazan', N'Defensor', NULL),
    ('J', 45, 5, N'Husniddin', N'Alikulov', '19990404', N'Rizespor', N'Defensor', NULL),
    ('J', 45, 6, N'Otabek', N'Shukurov', '19960622', N'Al Fayha', N'Mediocampista', NULL),
    ('J', 45, 7, N'Abbosbek', N'Fayzullaev', '20031003', N'Istanbul Basaksehir', N'Mediocampista', NULL),
    ('J', 45, 8, N'Jaloliddin', N'Masharipov', '19930901', N'Esteghlal', N'Mediocampista', NULL),
    ('J', 45, 9, N'Eldor', N'Shomurodov', '19950629', N'Istanbul Basaksehir', N'Delantero', NULL),
    ('J', 45, 10, N'Igor', N'Sergeev', '19930430', N'Pakhtakor', N'Delantero', NULL),
    ('J', 45, 11, N'Oston', N'Urunov', '20001219', N'Persepolis', N'Delantero', NULL),
    ('J', 45, 12, N'Abduvohid', N'Nematov', '20010320', N'Nasaf', N'Arquero', NULL),
    ('J', 45, 13, N'Sherzod', N'Nasrullaev', '19980723', N'Nasaf', N'Defensor', NULL),
    ('J', 45, 14, N'Odiljon', N'Hamrobekov', '19960213', N'Bunyodkor', N'Mediocampista', NULL),
    ('J', 45, 15, N'Khojiakbar', N'Alijonov', '19970419', N'Pakhtakor', N'Defensor', NULL),
    ('J', 45, 16, N'Botirali', N'Ergashev', '19950623', N'Navbahor', N'Arquero', NULL),
    ('J', 45, 17, N'Azizbek', N'Turgunboev', '19941001', N'Sivasspor', N'Mediocampista', NULL),
    ('J', 45, 18, N'Akmal', N'Mozgovoy', '20000402', N'Nasaf', N'Mediocampista', NULL),
    ('J', 45, 19, N'Bobir', N'Abdikholikov', '19970423', N'Nasaf', N'Delantero', NULL),
    ('J', 45, 20, N'Diyor', N'Kholmatov', '20020722', N'Pakhtakor', N'Mediocampista', NULL),
    ('J', 45, 21, N'Umar', N'Eshmurodov', '19921130', N'Nasaf', N'Defensor', NULL),
    ('J', 45, 22, N'Jasurbek', N'Jaloliddinov', '20020510', N'Bunyodkor', N'Mediocampista', NULL),
    ('J', 45, 23, N'Khusain', N'Norchaev', '20020206', N'Nasaf', N'Delantero', NULL),
    ('T', 45, 30, N'Fabio', N'Cannavaro', '19730913', NULL, NULL, N'Director Tecnico'),
    ('T', 45, 31, N'Aziz', N'Karimov', '19760412', NULL, NULL, N'Asistente'),
    ('T', 45, 32, N'Rustam', N'Rahimov', '19810318', NULL, NULL, N'Asistente'),
    ('J', 46, 1, N'Dominik', N'Livakovic', '19950109', N'Girona', N'Arquero', NULL),
    ('J', 46, 2, N'Josip', N'Stanicic', '20000402', N'Bayern Munich', N'Defensor', NULL),
    ('J', 46, 3, N'Josko', N'Gvardiol', '20020123', N'Manchester City', N'Defensor', NULL),
    ('J', 46, 4, N'Josip', N'Sutalo', '20000228', N'Ajax', N'Defensor', NULL),
    ('J', 46, 5, N'Duje', N'Caleta Car', '19960917', N'Real Sociedad', N'Defensor', NULL),
    ('J', 46, 6, N'Mateo', N'Kovacic', '19940506', N'Manchester City', N'Mediocampista', NULL),
    ('J', 46, 7, N'Lovro', N'Majer', '19980117', N'Wolfsburgo', N'Mediocampista', NULL),
    ('J', 46, 8, N'Mario', N'Pasalic', '19950209', N'Atalanta', N'Mediocampista', NULL),
    ('J', 46, 9, N'Andrej', N'Kramaric', '19910619', N'Hoffenheim', N'Delantero', NULL),
    ('J', 46, 10, N'Luka', N'Modric', '19850909', N'Milan', N'Mediocampista', NULL),
    ('J', 46, 11, N'Ivan', N'Perisic', '19890202', N'PSV Eindhoven', N'Delantero', NULL),
    ('J', 46, 12, N'Ivica', N'Ivusic', '19950201', N'Hajduk Split', N'Arquero', NULL),
    ('J', 46, 13, N'Nikola', N'Vlasic', '19971004', N'Torino', N'Mediocampista', NULL),
    ('J', 46, 14, N'Luka', N'Sucic', '20020908', N'Real Sociedad', N'Mediocampista', NULL),
    ('J', 46, 15, N'Marin', N'Pongracic', '19970911', N'Fiorentina', N'Defensor', NULL),
    ('J', 46, 16, N'Dominik', N'Kotarski', '20000210', N'Copenhague', N'Arquero', NULL),
    ('J', 46, 17, N'Ante', N'Budimir', '19910722', N'Osasuna', N'Delantero', NULL),
    ('J', 46, 18, N'Petar', N'Sucic', '20031025', N'Inter', N'Mediocampista', NULL),
    ('J', 46, 19, N'Bruno', N'Petkovic', '19940916', N'Kocaelispor', N'Delantero', NULL),
    ('J', 46, 20, N'Martin', N'Baturina', '20030216', N'Como', N'Mediocampista', NULL),
    ('J', 46, 21, N'Borna', N'Sosa', '19980121', N'Crystal Palace', N'Defensor', NULL),
    ('J', 46, 22, N'Igor', N'Matanovic', '20030331', N'Friburgo', N'Delantero', NULL),
    ('J', 46, 23, N'Marko', N'Pjaca', '19950506', N'Dinamo Zagreb', N'Delantero', NULL),
    ('T', 46, 30, N'Zlatko', N'Dalic', '19661026', NULL, NULL, N'Director Tecnico'),
    ('T', 46, 31, N'Ivica', N'Olic', '19790914', NULL, NULL, N'Asistente'),
    ('T', 46, 32, N'Marko', N'Kovacevic', '19820422', NULL, NULL, N'Asistente'),
    ('J', 47, 1, N'Lawrence', N'Ati Zigi', '19961129', N'St. Gallen', N'Arquero', NULL),
    ('J', 47, 2, N'Tariq', N'Lamptey', '20000930', N'Fiorentina', N'Defensor', NULL),
    ('J', 47, 3, N'Gideon', N'Mensah', '19980718', N'Auxerre', N'Defensor', NULL),
    ('J', 47, 4, N'Mohammed', N'Salisu', '19990417', N'Monaco', N'Defensor', NULL),
    ('J', 47, 5, N'Alexander', N'Djiku', '19940809', N'Spartak Moscu', N'Defensor', NULL),
    ('J', 47, 6, N'Thomas', N'Partey', '19930613', N'Villarreal', N'Mediocampista', NULL),
    ('J', 47, 7, N'Abdul', N'Fatawu', '20040308', N'Leicester City', N'Delantero', NULL),
    ('J', 47, 8, N'Mohammed', N'Kudus', '20000802', N'Tottenham', N'Mediocampista', NULL),
    ('J', 47, 9, N'Jordan', N'Ayew', '19910911', N'Leicester City', N'Delantero', NULL),
    ('J', 47, 10, N'Inaki', N'Williams', '19940615', N'Athletic Bilbao', N'Delantero', NULL),
    ('J', 47, 11, N'Antoine', N'Semenyo', '20000107', N'Bournemouth', N'Delantero', NULL),
    ('J', 47, 12, N'Joseph', N'Wollacott', '19960908', N'Crawley Town', N'Arquero', NULL),
    ('J', 47, 13, N'Elisha', N'Owusu', '19971107', N'Auxerre', N'Mediocampista', NULL),
    ('J', 47, 14, N'Majeed', N'Ashimeru', '19971010', N'Anderlecht', N'Mediocampista', NULL),
    ('J', 47, 15, N'Daniel', N'Amartey', '19941221', N'Besiktas', N'Defensor', NULL),
    ('J', 47, 16, N'Benjamin', N'Asare', '19920713', N'Hearts of Oak', N'Arquero', NULL),
    ('J', 47, 17, N'Ernest', N'Nuamah', '20031101', N'Olympique Lyon', N'Delantero', NULL),
    ('J', 47, 18, N'Ibrahim', N'Sulemana', '20030522', N'Atalanta', N'Mediocampista', NULL),
    ('J', 47, 19, N'Kamaldeen', N'Sulemana', '20020215', N'Atalanta', N'Delantero', NULL),
    ('J', 47, 20, N'Abdul', N'Samed', '20000326', N'Lens', N'Mediocampista', NULL),
    ('J', 47, 21, N'Alidu', N'Seidu', '20000604', N'Rennes', N'Defensor', NULL),
    ('J', 47, 22, N'Joseph', N'Paintsil', '19980201', N'Los Angeles Galaxy', N'Delantero', NULL),
    ('J', 47, 23, N'Jerome', N'Opoku', '19981014', N'Istanbul Basaksehir', N'Defensor', NULL),
    ('T', 47, 30, N'Otto', N'Addo', '19750609', NULL, NULL, N'Director Tecnico'),
    ('T', 47, 31, N'Kwame', N'Mensah', '19760415', NULL, NULL, N'Asistente'),
    ('T', 47, 32, N'Daniel', N'Owusu', '19810320', NULL, NULL, N'Asistente'),
    ('J', 48, 1, N'Orlando', N'Mosquera', '19941225', N'Al Fayha', N'Arquero', NULL),
    ('J', 48, 2, N'Michael', N'Murillo', '19960211', N'Olympique Marsella', N'Defensor', NULL),
    ('J', 48, 3, N'Eric', N'Davis', '19910331', N'Plaza Amador', N'Defensor', NULL),
    ('J', 48, 4, N'Fidel', N'Escobar', '19950109', N'Saprissa', N'Defensor', NULL),
    ('J', 48, 5, N'Jose', N'Cordoba', '20010603', N'Norwich City', N'Defensor', NULL),
    ('J', 48, 6, N'Anibal', N'Godoy', '19900210', N'San Diego FC', N'Mediocampista', NULL),
    ('J', 48, 7, N'Jose Luis', N'Rodriguez', '19980619', N'Juarez', N'Delantero', NULL),
    ('J', 48, 8, N'Adalberto', N'Carrasquilla', '19981116', N'Pumas UNAM', N'Mediocampista', NULL),
    ('J', 48, 9, N'Jose', N'Fajardo', '19930818', N'Universidad Catolica', N'Delantero', NULL),
    ('J', 48, 10, N'Edgar', N'Barcenas', '19931023', N'Mazatlan', N'Mediocampista', NULL),
    ('J', 48, 11, N'Ismael', N'Diaz', '19970512', N'Leon', N'Delantero', NULL),
    ('J', 48, 12, N'Luis', N'Mejia', '19910316', N'Nacional', N'Arquero', NULL),
    ('J', 48, 13, N'Cristian', N'Martinez', '19970206', N'CD Plaza Amador', N'Mediocampista', NULL),
    ('J', 48, 14, N'Cesar', N'Blackman', '19980402', N'Slovan Bratislava', N'Defensor', NULL),
    ('J', 48, 15, N'Andres', N'Andrade', '19981016', N'LASK', N'Defensor', NULL),
    ('J', 48, 16, N'Cesar', N'Samudio', '19940305', N'Marathon', N'Arquero', NULL),
    ('J', 48, 17, N'Freddy', N'Gondola', '19950918', N'Alajuelense', N'Delantero', NULL),
    ('J', 48, 18, N'Abdiel', N'Ayarza', '19920912', N'Cienciano', N'Mediocampista', NULL),
    ('J', 48, 19, N'Eduardo', N'Guerrero', '20000221', N'Dinamo Kiev', N'Delantero', NULL),
    ('J', 48, 20, N'Alberto', N'Quintero', '19871218', N'Plaza Amador', N'Mediocampista', NULL),
    ('J', 48, 21, N'Roderick', N'Miller', '19920403', N'Turan Tovuz', N'Defensor', NULL),
    ('J', 48, 22, N'Jovani', N'Welch', '19991207', N'Academico Viseu', N'Mediocampista', NULL),
    ('J', 48, 23, N'Kahiser', N'Lenis', '20000723', N'Jaguares de Cordoba', N'Delantero', NULL),
    ('T', 48, 30, N'Thomas', N'Christiansen', '19730311', NULL, NULL, N'Director Tecnico'),
    ('T', 48, 31, N'Carlos', N'Rodriguez', '19760412', NULL, NULL, N'Asistente'),
    ('T', 48, 32, N'Miguel', N'Herrera', '19810318', NULL, NULL, N'Asistente');

INSERT INTO torneo.Persona (Nombre, Apellido, FechaNacimiento)
SELECT s.Nombre, s.Apellido, s.FechaNac
FROM #PersonaSeed s
WHERE NOT EXISTS (SELECT 1 FROM torneo.Persona p
                  WHERE p.Nombre = s.Nombre AND p.Apellido = s.Apellido AND p.FechaNacimiento = s.FechaNac);

UPDATE s
   SET PersonaID = (SELECT MIN(p.PersonaID) FROM torneo.Persona p
                    WHERE p.Nombre = s.Nombre AND p.Apellido = s.Apellido AND p.FechaNacimiento = s.FechaNac)
  FROM #PersonaSeed s;

INSERT INTO torneo.Jugador (PersonaID, ClubOrigen, Dorsal, PosicionHabitual, ConvocatoriaID)
SELECT s.PersonaID, s.Club, s.Slot, s.Posicion, e.ConvocatoriaID
FROM #PersonaSeed s
JOIN #Equipo e ON e.Idx = s.EquipoIdx
WHERE s.Tipo = 'J' AND s.PersonaID IS NOT NULL AND e.ConvocatoriaID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM torneo.Jugador j WHERE j.PersonaID = s.PersonaID)
  AND NOT EXISTS (SELECT 1 FROM torneo.Jugador j2 WHERE j2.ConvocatoriaID = e.ConvocatoriaID AND j2.Dorsal = s.Slot);

;WITH Libres AS (
    SELECT e.ConvocatoriaID, n.d AS Dorsal,
           ROW_NUMBER() OVER (PARTITION BY e.ConvocatoriaID ORDER BY n.d) AS rk
    FROM #Equipo e
    CROSS JOIN (SELECT TOP (60) 23 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS d FROM sys.all_objects) n
    WHERE e.ConvocatoriaID IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM torneo.Jugador j WHERE j.ConvocatoriaID = e.ConvocatoriaID AND j.Dorsal = n.d)
),
Pendientes AS (
    SELECT s.PersonaID, s.Club, s.Posicion, e.ConvocatoriaID,
           ROW_NUMBER() OVER (PARTITION BY e.ConvocatoriaID ORDER BY s.Slot) AS rk
    FROM #PersonaSeed s
    JOIN #Equipo e ON e.Idx = s.EquipoIdx
    WHERE s.Tipo = 'J' AND s.PersonaID IS NOT NULL AND e.ConvocatoriaID IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM torneo.Jugador j WHERE j.PersonaID = s.PersonaID)
)
INSERT INTO torneo.Jugador (PersonaID, ClubOrigen, Dorsal, PosicionHabitual, ConvocatoriaID)
SELECT p.PersonaID, p.Club, l.Dorsal, p.Posicion, p.ConvocatoriaID
FROM Pendientes p
JOIN Libres l ON l.ConvocatoriaID = p.ConvocatoriaID AND l.rk = p.rk;

INSERT INTO torneo.CuerpoTecnico (PersonaID, SeleccionID, Rol)
SELECT s.PersonaID, e.SeleccionID, s.Rol
FROM #PersonaSeed s
JOIN #Equipo e ON e.Idx = s.EquipoIdx
WHERE s.Tipo = 'T' AND s.PersonaID IS NOT NULL AND e.SeleccionID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM torneo.CuerpoTecnico ct WHERE ct.PersonaID = s.PersonaID);

SELECT e.Idx, e.Pais, COUNT(j.PersonaID) AS Convocados
FROM #Equipo e
LEFT JOIN torneo.Jugador j ON j.ConvocatoriaID = e.ConvocatoriaID
GROUP BY e.Idx, e.Pais
ORDER BY e.Idx;
GO

-- ========================================================
-- 4. ARBITROS (20), IDIOMAS QUE HABLAN Y ALGUNAS SANCIONES
-- ========================================================

PRINT '--- 4. Arbitros ---';

CREATE TABLE #ArbSeed (
    Orden     INT NOT NULL PRIMARY KEY,
    Nombre    VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Apellido  VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    FechaNac  DATE NOT NULL,
    Pais      VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Rol       VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    PersonaID INT NULL
);
INSERT INTO #ArbSeed (Orden, Nombre, Apellido, FechaNac, Pais, Rol) VALUES
    (1, N'Luca', N'Bertolini', '19810314', N'Italia', 'Principal'),
    (2, N'Joost', N'Verhagen', '19830702', N'Países Bajos', 'Principal'),
    (3, N'Piotr', N'Zielinski', '19791121', N'Polonia', 'Principal'),
    (4, N'Emre', N'Yildirim', '19850130', N'Turquía', 'Principal'),
    (5, N'Stefan', N'Meier', '19800509', N'Suiza', 'Principal'),
    (6, N'Rodrigo', N'Tapia', '19820917', N'Chile', 'Principal'),
    (7, N'Faisal', N'Al Harbi', '19841204', N'Arabia Saudita', 'Principal'),
    (8, N'Daniel', N'Foster', '19780625', N'Australia', 'Principal'),
    (9, N'Gabriel', N'Núñez', '19860211', N'Argentina', 'Principal'),
    (10, N'Olivier', N'Delmas', '19811008', N'Francia', 'Principal'),
    (11, N'Mihai', N'Popescu', '19870419', N'Rumania', 'Asistente'),
    (12, N'Matej', N'Kovac', '19880823', N'Eslovenia', 'Asistente'),
    (13, N'Jorge', N'Salazar', '19860303', N'Perú', 'Asistente'),
    (14, N'Andrés', N'Cevallos', '19851115', N'Ecuador', 'Asistente'),
    (15, N'Mauricio', N'Vargas', '19870127', N'Costa Rica', 'Asistente'),
    (16, N'Sipho', N'Dlamini', '19890606', N'Sudáfrica', 'Asistente'),
    (17, N'Tarek', N'Mansour', '19840912', N'Egipto', 'Cuarto Arbitro'),
    (18, N'Liam', N'Hartigan', '19830531', N'Nueva Zelanda', 'Cuarto Arbitro'),
    (19, N'Anders', N'Lindqvist', '19821219', N'Suecia', 'VAR'),
    (20, N'Carlos', N'Duarte', '19810728', N'Paraguay', 'VAR');

INSERT INTO torneo.Persona (Nombre, Apellido, FechaNacimiento)
SELECT s.Nombre, s.Apellido, s.FechaNac
FROM #ArbSeed s
WHERE NOT EXISTS (SELECT 1 FROM torneo.Persona p
                  WHERE p.Nombre = s.Nombre AND p.Apellido = s.Apellido AND p.FechaNacimiento = s.FechaNac);

UPDATE s
   SET PersonaID = (SELECT MIN(p.PersonaID) FROM torneo.Persona p
                    WHERE p.Nombre = s.Nombre AND p.Apellido = s.Apellido AND p.FechaNacimiento = s.FechaNac)
  FROM #ArbSeed s;

INSERT INTO reglamento.Arbitro (PersonaID, Pais, RolArbitral)
SELECT s.PersonaID, s.Pais, s.Rol
FROM #ArbSeed s
WHERE s.PersonaID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM reglamento.Arbitro a WHERE a.PersonaID = s.PersonaID);

CREATE TABLE #ArbIdioma (
    Orden  INT NOT NULL,
    Idioma VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #ArbIdioma (Orden, Idioma) VALUES
    (1, N'Italiano'),
    (1, N'Ingles'),
    (2, N'Ingles'),
    (2, N'Aleman'),
    (3, N'Ingles'),
    (4, N'Ingles'),
    (5, N'Aleman'),
    (5, N'Frances'),
    (5, N'Ingles'),
    (6, N'Español'),
    (6, N'Ingles'),
    (7, N'Arabe'),
    (7, N'Ingles'),
    (8, N'Ingles'),
    (9, N'Español'),
    (9, N'Ingles'),
    (10, N'Frances'),
    (10, N'Ingles'),
    (11, N'Ingles'),
    (12, N'Ingles'),
    (13, N'Español'),
    (14, N'Español'),
    (14, N'Ingles'),
    (15, N'Español'),
    (16, N'Ingles'),
    (17, N'Arabe'),
    (17, N'Ingles'),
    (18, N'Ingles'),
    (19, N'Ingles'),
    (20, N'Español'),
    (20, N'Ingles');

INSERT INTO torneo.PersonaHabla (PersonaID, IdiomaID)
SELECT DISTINCT a.PersonaID, i.IdiomaID
FROM #ArbIdioma ai
JOIN #ArbSeed a ON a.Orden = ai.Orden
JOIN torneo.Idioma i ON i.Nombre = ai.Idioma
WHERE a.PersonaID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM torneo.PersonaHabla ph WHERE ph.PersonaID = a.PersonaID AND ph.IdiomaID = i.IdiomaID);

DECLARE @Arb INT;

SET @Arb = (SELECT PersonaID FROM #ArbSeed WHERE Orden = 2);
IF @Arb IS NOT NULL AND NOT EXISTS (SELECT 1 FROM reglamento.Sancion WHERE ArbitroID = @Arb AND Descripcion = N'Apercibimiento por informe tardio')
    EXEC reglamento.SP_Alta_Sancion @Descripcion = N'Apercibimiento por informe tardio', @ArbitroID = @Arb;

SET @Arb = (SELECT PersonaID FROM #ArbSeed WHERE Orden = 5);
IF @Arb IS NOT NULL AND NOT EXISTS (SELECT 1 FROM reglamento.Sancion WHERE ArbitroID = @Arb AND Descripcion = N'Multa por demora en revision VAR')
    EXEC reglamento.SP_Alta_Sancion @Descripcion = N'Multa por demora en revision VAR', @ArbitroID = @Arb;

SET @Arb = (SELECT PersonaID FROM #ArbSeed WHERE Orden = 9);
IF @Arb IS NOT NULL AND NOT EXISTS (SELECT 1 FROM reglamento.Sancion WHERE ArbitroID = @Arb AND Descripcion = N'Observacion por criterio disciplinario')
    EXEC reglamento.SP_Alta_Sancion @Descripcion = N'Observacion por criterio disciplinario', @ArbitroID = @Arb;

SELECT COUNT(*) AS ArbitrosCargados FROM #ArbSeed s WHERE EXISTS (SELECT 1 FROM reglamento.Arbitro a WHERE a.PersonaID = s.PersonaID);
GO

-- ========================================================
-- 5. PUBLICIDAD: ANUNCIANTES, CAMPAÑAS, PIEZAS E INTERESES
-- ========================================================

PRINT '--- 5. Publicidad ---';

CREATE TABLE #AnunSeed (Pais VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL);
INSERT INTO #AnunSeed (Pais) VALUES
    (N'Argentina'),
    (N'Brasil'),
    (N'Estados Unidos'),
    (N'México'),
    (N'Japón'),
    (N'Alemania'),
    (N'España'),
    (N'Francia'),
    (N'Corea del Sur'),
    (N'Inglaterra'),
    (N'Canadá'),
    (N'Qatar'),
    (N'Colombia');

CREATE TABLE #CampSeed (
    Pais        VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Nombre      VARCHAR(30) COLLATE DATABASE_DEFAULT NOT NULL,
    FechaInicio DATE NOT NULL
);
INSERT INTO #CampSeed (Pais, Nombre, FechaInicio) VALUES
    (N'Argentina', N'Pampa Cola - Gol de Todos', '20260515'),
    (N'Brasil', N'Samba Sport - Joga Bonito', '20260520'),
    (N'Estados Unidos', N'Liberty Motors - Road to Win', '20260510'),
    (N'México', N'Aztec Beer - Pasion Mundial', '20260512'),
    (N'Japón', N'Sakura Mobile - Hajime', '20260518'),
    (N'Alemania', N'Rheinbank - Vorwarts', '20260525'),
    (N'España', N'Iberia Air - Vuela al Mundial', '20260522'),
    (N'Francia', N'Maison Mode - Allez Paris', '20260528'),
    (N'Corea del Sur', N'K-Tech - Dream Together', '20260530'),
    (N'Inglaterra', N'Albion Tea - Coming Home', '20260601'),
    (N'Canadá', N'Maple Foods - True North', '20260602'),
    (N'Qatar', N'Gulf Energy - Future Match', '20260508'),
    (N'Colombia', N'Cafe Andino - Sabor Mundial', '20260603');

CREATE TABLE #PiezaSeed (
    CampNombre VARCHAR(30) COLLATE DATABASE_DEFAULT NOT NULL,
    Contenido  VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Tarifa     DECIMAL(10,2) NOT NULL,
    Idioma     VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #PiezaSeed (CampNombre, Contenido, Tarifa, Idioma) VALUES
    (N'Pampa Cola - Gol de Todos', N'Spot LED 15s - Pampa Cola ES', 42000.00, N'Español'),
    (N'Samba Sport - Joga Bonito', N'Spot LED 15s - Samba Sport PT', 38000.00, N'Portugues'),
    (N'Samba Sport - Joga Bonito', N'Spot LED 15s - Samba Sport EN', 36000.00, N'Ingles'),
    (N'Liberty Motors - Road to Win', N'Spot LED 15s - Liberty Motors EN', 120000.00, N'Ingles'),
    (N'Liberty Motors - Road to Win', N'Spot LED 15s - Liberty Motors ES', 95000.00, N'Español'),
    (N'Aztec Beer - Pasion Mundial', N'Banner Rotativo - Aztec Beer ES', 52000.00, N'Español'),
    (N'Sakura Mobile - Hajime', N'Spot LED 15s - Sakura Mobile JP', 88000.00, N'Japones'),
    (N'Rheinbank - Vorwarts', N'Banner Rotativo - Rheinbank DE', 99000.00, N'Aleman'),
    (N'Iberia Air - Vuela al Mundial', N'Spot LED 15s - Iberia Air ES', 61000.00, N'Español'),
    (N'Maison Mode - Allez Paris', N'Spot LED 15s - Maison Mode FR', 72000.00, N'Frances'),
    (N'K-Tech - Dream Together', N'Spot LED 15s - K-Tech KR', 91000.00, N'Coreano'),
    (N'Albion Tea - Coming Home', N'Banner Rotativo - Albion Tea EN', 83000.00, N'Ingles'),
    (N'Maple Foods - True North', N'Banner Rotativo - Maple Foods EN', 47000.00, N'Ingles'),
    (N'Maple Foods - True North', N'Banner Rotativo - Maple Foods FR', 44000.00, N'Frances'),
    (N'Gulf Energy - Future Match', N'Spot LED 15s - Gulf Energy AR', 130000.00, N'Arabe'),
    (N'Cafe Andino - Sabor Mundial', N'Spot LED 15s - Cafe Andino ES', 36000.00, N'Español');

CREATE TABLE #InteresSeed (
    AnunPais    VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    PaisInteres VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Prioridad   VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #InteresSeed (AnunPais, PaisInteres, Prioridad) VALUES
    (N'Argentina', N'Argentina', 'Alta'),
    (N'Argentina', N'Uruguay', 'Media'),
    (N'Argentina', N'México', 'Baja'),
    (N'Brasil', N'Brasil', 'Alta'),
    (N'Brasil', N'Portugal', 'Media'),
    (N'Brasil', N'Estados Unidos', 'Baja'),
    (N'Estados Unidos', N'Estados Unidos', 'Alta'),
    (N'Estados Unidos', N'México', 'Media'),
    (N'Estados Unidos', N'Canadá', 'Media'),
    (N'México', N'México', 'Alta'),
    (N'México', N'Colombia', 'Media'),
    (N'México', N'Argentina', 'Baja'),
    (N'Japón', N'Japón', 'Alta'),
    (N'Japón', N'Corea del Sur', 'Media'),
    (N'Japón', N'Estados Unidos', 'Baja'),
    (N'Alemania', N'Alemania', 'Alta'),
    (N'Alemania', N'Francia', 'Media'),
    (N'Alemania', N'Inglaterra', 'Baja'),
    (N'España', N'España', 'Alta'),
    (N'España', N'Argentina', 'Media'),
    (N'España', N'México', 'Baja'),
    (N'Francia', N'Francia', 'Alta'),
    (N'Francia', N'Marruecos', 'Media'),
    (N'Francia', N'Senegal', 'Baja'),
    (N'Corea del Sur', N'Corea del Sur', 'Alta'),
    (N'Corea del Sur', N'Japón', 'Media'),
    (N'Corea del Sur', N'Estados Unidos', 'Baja'),
    (N'Inglaterra', N'Inglaterra', 'Alta'),
    (N'Inglaterra', N'Estados Unidos', 'Media'),
    (N'Inglaterra', N'Canadá', 'Baja'),
    (N'Canadá', N'Canadá', 'Alta'),
    (N'Canadá', N'Estados Unidos', 'Media'),
    (N'Canadá', N'Inglaterra', 'Baja'),
    (N'Qatar', N'Qatar', 'Alta'),
    (N'Qatar', N'Arabia Saudita', 'Media'),
    (N'Qatar', N'Marruecos', 'Baja'),
    (N'Colombia', N'Colombia', 'Alta'),
    (N'Colombia', N'Argentina', 'Media'),
    (N'Colombia', N'Brasil', 'Baja');

INSERT INTO publicidad.Anunciante (Pais)
SELECT a.Pais FROM #AnunSeed a
WHERE NOT EXISTS (SELECT 1 FROM publicidad.Anunciante x WHERE x.Pais = a.Pais);

INSERT INTO publicidad.Campaña (Nombre, FechaInicio, AnuncianteID)
SELECT c.Nombre, c.FechaInicio, (SELECT MIN(x.AnuncianteID) FROM publicidad.Anunciante x WHERE x.Pais = c.Pais)
FROM #CampSeed c
WHERE NOT EXISTS (SELECT 1 FROM publicidad.Campaña k WHERE k.Nombre = c.Nombre)
  AND EXISTS (SELECT 1 FROM publicidad.Anunciante x WHERE x.Pais = c.Pais);

INSERT INTO publicidad.PiezaPublicitaria (Contenido, Tarifa, Idioma, CampañaID)
SELECT p.Contenido, p.Tarifa, p.Idioma, (SELECT MIN(k.CampañaID) FROM publicidad.Campaña k WHERE k.Nombre = p.CampNombre)
FROM #PiezaSeed p
WHERE EXISTS (SELECT 1 FROM publicidad.Campaña k WHERE k.Nombre = p.CampNombre)
  AND NOT EXISTS (SELECT 1 FROM publicidad.PiezaPublicitaria pp
                  JOIN publicidad.Campaña k2 ON k2.CampañaID = pp.CampañaID
                  WHERE k2.Nombre = p.CampNombre AND pp.Contenido = p.Contenido);

INSERT INTO publicidad.InteresPublicitario (Prioridad, AnuncianteID, PaisID)
SELECT i.Prioridad, an.AnuncianteID, pa.PaisID
FROM #InteresSeed i
JOIN (SELECT Pais, MIN(AnuncianteID) AS AnuncianteID FROM publicidad.Anunciante GROUP BY Pais) an ON an.Pais = i.AnunPais
JOIN torneo.Pais pa ON pa.Nombre = i.PaisInteres
WHERE NOT EXISTS (SELECT 1 FROM publicidad.InteresPublicitario x WHERE x.AnuncianteID = an.AnuncianteID AND x.PaisID = pa.PaisID);

SELECT COUNT(DISTINCT Pais) AS PaisesAnunciantes FROM publicidad.Anunciante;
SELECT COUNT(*) AS Campañas FROM publicidad.Campaña;
SELECT COUNT(*) AS Piezas FROM publicidad.PiezaPublicitaria;
GO

-- =======================
-- 6.FIXTURE: 104 PARTIDOS 
-- =======================

PRINT '--- 6. Fixture y partidos ---';

CREATE TABLE #Fixture (
    Nro           INT NOT NULL PRIMARY KEY,
    Fase          VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    Sede          VARCHAR(70) COLLATE DATABASE_DEFAULT NOT NULL,
    EqLocal       VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    EqVisita      VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    UTC           DATETIME NOT NULL,
    GL            INT NOT NULL,           
    GV            INT NOT NULL,           
    Asistencia    INT NOT NULL,
    PrincipalPais VARCHAR(50) COLLATE DATABASE_DEFAULT NULL,   
    SedeID        INT NULL,
    LocalID       INT NULL,
    VisitID       INT NULL,
    PartidoID     INT NULL
);
INSERT INTO #Fixture (Nro, Fase, Sede, EqLocal, EqVisita, UTC, GL, GV, Asistencia, PrincipalPais) VALUES
    (1, N'Fase de Grupos', N'Estadio Azteca', N'México', N'República Checa', N'20260611 16:00', 2, 0, 71607, NULL),
    (2, N'Fase de Grupos', N'MetLife Stadium', N'Corea del Sur', N'Sudáfrica', N'20260611 19:00', 3, 0, 71775, NULL),
    (3, N'Fase de Grupos', N'SoFi Stadium', N'Canadá', N'Suiza', N'20260611 22:00', 1, 3, 61811, NULL),
    (4, N'Fase de Grupos', N'AT&T Stadium', N'Bosnia y Herzegovina', N'Catar', N'20260611 23:30', 2, 1, 83660, NULL),
    (5, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Marruecos', N'Escocia', N'20260612 16:00', 2, 0, 63900, NULL),
    (6, N'Fase de Grupos', N'Hard Rock Stadium', N'Brasil', N'Haití', N'20260612 19:00', 3, 0, 58937, NULL),
    (7, N'Fase de Grupos', N'BMO Field', N'Estados Unidos', N'Turquía', N'20260612 22:00', 3, 1, 41400, NULL),
    (8, N'Fase de Grupos', N'BC Place', N'Paraguay', N'Australia', N'20260612 23:30', 1, 2, 50685, NULL),
    (9, N'Fase de Grupos', N'Estadio BBVA', N'Alemania', N'Ecuador', N'20260613 16:00', 2, 0, 50290, NULL),
    (10, N'Fase de Grupos', N'Estadio Akron', N'Curazao', N'Costa de Marfil', N'20260613 19:00', 3, 0, 40860, NULL),
    (11, N'Fase de Grupos', N'Lumen Field', N'Japón', N'Túnez', N'20260613 22:00', 3, 1, 59340, NULL),
    (12, N'Fase de Grupos', N'NRG Stadium', N'Países Bajos', N'Suecia', N'20260613 23:30', 2, 1, 62831, NULL),
    (13, N'Fase de Grupos', N'Gillette Stadium', N'Bélgica', N'Nueva Zelanda', N'20260614 16:00', 2, 0, 57972, NULL),
    (14, N'Fase de Grupos', N'Lincoln Financial Field', N'Egipto', N'Irán', N'20260614 19:00', 0, 3, 60158, NULL),
    (15, N'Fase de Grupos', N'Arrowhead Stadium', N'España', N'Arabia Saudita', N'20260614 22:00', 3, 1, 68774, NULL),
    (16, N'Fase de Grupos', N'Levi''s Stadium', N'Uruguay', N'Cabo Verde', N'20260614 23:30', 2, 1, 62334, NULL),
    (17, N'Fase de Grupos', N'Estadio Azteca', N'Senegal', N'Noruega', N'20260615 16:00', 2, 0, 76602, NULL),
    (18, N'Fase de Grupos', N'MetLife Stadium', N'Francia', N'Irak', N'20260615 19:00', 3, 0, 76725, NULL),
    (19, N'Fase de Grupos', N'SoFi Stadium', N'Argentina', N'Jordania', N'20260615 22:00', 3, 1, 66025, NULL),
    (20, N'Fase de Grupos', N'AT&T Stadium', N'Argelia', N'Austria', N'20260615 23:30', 1, 2, 79900, NULL),
    (21, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Portugal', N'Uzbekistán', N'20260616 16:00', 2, 0, 61060, NULL),
    (22, N'Fase de Grupos', N'Hard Rock Stadium', N'Colombia', N'RD Congo', N'20260616 19:00', 3, 0, 56347, NULL),
    (23, N'Fase de Grupos', N'BMO Field', N'Inglaterra', N'Panamá', N'20260616 22:00', 3, 1, 39600, NULL),
    (24, N'Fase de Grupos', N'BC Place', N'Croacia', N'Ghana', N'20260616 23:30', 2, 1, 48505, NULL),
    (25, N'Fase de Grupos', N'Estadio BBVA', N'México', N'Sudáfrica', N'20260617 16:00', 3, 1, 48150, NULL),
    (26, N'Fase de Grupos', N'Estadio Akron', N'República Checa', N'Corea del Sur', N'20260617 19:00', 1, 2, 43744, NULL),
    (27, N'Fase de Grupos', N'Lumen Field', N'Canadá', N'Catar', N'20260617 22:00', 2, 0, 63479, NULL),
    (28, N'Fase de Grupos', N'NRG Stadium', N'Suiza', N'Bosnia y Herzegovina', N'20260617 23:30', 3, 0, 67164, NULL),
    (29, N'Fase de Grupos', N'Gillette Stadium', N'Marruecos', N'Haití', N'20260618 16:00', 3, 1, 61925, NULL),
    (30, N'Fase de Grupos', N'Lincoln Financial Field', N'Escocia', N'Brasil', N'20260618 19:00', 1, 2, 57454, NULL),
    (31, N'Fase de Grupos', N'Arrowhead Stadium', N'Estados Unidos', N'Australia', N'20260618 22:00', 2, 0, 65717, NULL),
    (32, N'Fase de Grupos', N'Levi''s Stadium', N'Turquía', N'Paraguay', N'20260618 23:30', 3, 0, 59595, NULL),
    (33, N'Fase de Grupos', N'Estadio Azteca', N'Alemania', N'Costa de Marfil', N'20260619 16:00', 3, 1, 73272, NULL),
    (34, N'Fase de Grupos', N'MetLife Stadium', N'Ecuador', N'Curazao', N'20260619 19:00', 2, 1, 73425, NULL),
    (35, N'Fase de Grupos', N'SoFi Stadium', N'Japón', N'Suecia', N'20260619 22:00', 2, 0, 63216, NULL),
    (36, N'Fase de Grupos', N'AT&T Stadium', N'Túnez', N'Países Bajos', N'20260619 23:30', 0, 3, 85539, NULL),
    (37, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Bélgica', N'Irán', N'20260620 16:00', 3, 1, 65319, NULL),
    (38, N'Fase de Grupos', N'Hard Rock Stadium', N'Nueva Zelanda', N'Egipto', N'20260620 19:00', 1, 2, 60233, NULL),
    (39, N'Fase de Grupos', N'BMO Field', N'España', N'Cabo Verde', N'20260620 22:00', 2, 0, 42300, NULL),
    (40, N'Fase de Grupos', N'BC Place', N'Arabia Saudita', N'Uruguay', N'20260620 23:30', 0, 3, 46325, NULL),
    (41, N'Fase de Grupos', N'Estadio BBVA', N'Senegal', N'Irak', N'20260621 16:00', 3, 1, 46010, NULL),
    (42, N'Fase de Grupos', N'Estadio Akron', N'Noruega', N'Francia', N'20260621 19:00', 1, 2, 41821, NULL),
    (43, N'Fase de Grupos', N'Lumen Field', N'Argentina', N'Austria', N'20260621 22:00', 2, 0, 60720, NULL),
    (44, N'Fase de Grupos', N'NRG Stadium', N'Jordania', N'Argelia', N'20260621 23:30', 0, 3, 64275, NULL),
    (45, N'Fase de Grupos', N'Gillette Stadium', N'Portugal', N'RD Congo', N'20260622 16:00', 3, 1, 59290, NULL),
    (46, N'Fase de Grupos', N'Lincoln Financial Field', N'Uzbekistán', N'Colombia', N'20260622 19:00', 1, 2, 61510, NULL),
    (47, N'Fase de Grupos', N'Arrowhead Stadium', N'Inglaterra', N'Ghana', N'20260622 22:00', 2, 0, 70302, NULL),
    (48, N'Fase de Grupos', N'Levi''s Stadium', N'Panamá', N'Croacia', N'20260622 23:30', 0, 3, 63704, NULL),
    (49, N'Fase de Grupos', N'Estadio Azteca', N'México', N'Corea del Sur', N'20260623 16:00', 2, 0, 78268, NULL),
    (50, N'Fase de Grupos', N'MetLife Stadium', N'Sudáfrica', N'República Checa', N'20260623 19:00', 3, 0, 70125, NULL),
    (51, N'Fase de Grupos', N'SoFi Stadium', N'Canadá', N'Bosnia y Herzegovina', N'20260623 22:00', 3, 1, 60406, NULL),
    (52, N'Fase de Grupos', N'AT&T Stadium', N'Catar', N'Suiza', N'20260623 23:30', 1, 2, 81780, NULL),
    (53, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Marruecos', N'Brasil', N'20260624 16:00', 0, 2, 62480, NULL),
    (54, N'Fase de Grupos', N'Hard Rock Stadium', N'Haití', N'Escocia', N'20260624 19:00', 0, 3, 57642, NULL),
    (55, N'Fase de Grupos', N'BMO Field', N'Estados Unidos', N'Paraguay', N'20260624 22:00', 3, 1, 40500, NULL),
    (56, N'Fase de Grupos', N'BC Place', N'Australia', N'Turquía', N'20260624 23:30', 2, 1, 49594, NULL),
    (57, N'Fase de Grupos', N'Estadio BBVA', N'Alemania', N'Curazao', N'20260625 16:00', 2, 0, 49219, NULL),
    (58, N'Fase de Grupos', N'Estadio Akron', N'Costa de Marfil', N'Ecuador', N'20260625 19:00', 0, 3, 44706, NULL),
    (59, N'Fase de Grupos', N'Lumen Field', N'Japón', N'Países Bajos', N'20260625 22:00', 1, 3, 64859, NULL),
    (60, N'Fase de Grupos', N'NRG Stadium', N'Suecia', N'Túnez', N'20260625 23:30', 2, 1, 61387, NULL),
    (61, N'Fase de Grupos', N'Gillette Stadium', N'Bélgica', N'Egipto', N'20260626 16:00', 2, 0, 56655, NULL),
    (62, N'Fase de Grupos', N'Lincoln Financial Field', N'Irán', N'Nueva Zelanda', N'20260626 19:00', 3, 0, 58806, NULL),
    (63, N'Fase de Grupos', N'Arrowhead Stadium', N'España', N'Uruguay', N'20260626 22:00', 3, 1, 67246, NULL),
    (64, N'Fase de Grupos', N'Levi''s Stadium', N'Cabo Verde', N'Arabia Saudita', N'20260626 23:30', 2, 1, 60965, NULL),
    (65, N'Fase de Grupos', N'Estadio Azteca', N'Senegal', N'Francia', N'20260627 16:00', 0, 2, 74937, NULL),
    (66, N'Fase de Grupos', N'MetLife Stadium', N'Irak', N'Noruega', N'20260627 19:00', 0, 3, 75075, NULL),
    (67, N'Fase de Grupos', N'SoFi Stadium', N'Argentina', N'Argelia', N'20260627 22:00', 3, 1, 64620, NULL),
    (68, N'Fase de Grupos', N'AT&T Stadium', N'Austria', N'Jordania', N'20260627 23:30', 2, 1, 87420, NULL),
    (69, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Portugal', N'Colombia', N'20260628 16:00', 2, 0, 66740, NULL),
    (70, N'Fase de Grupos', N'Hard Rock Stadium', N'RD Congo', N'Uzbekistán', N'20260628 19:00', 3, 0, 55051, NULL),
    (71, N'Fase de Grupos', N'BMO Field', N'Inglaterra', N'Croacia', N'20260628 22:00', 3, 1, 38700, NULL),
    (72, N'Fase de Grupos', N'BC Place', N'Ghana', N'Panamá', N'20260628 23:30', 2, 1, 47415, NULL),
    (73, N'Dieciseisavos', N'Estadio BBVA', N'Argentina', N'Noruega', N'20260628 16:00', 3, 1, 47080, NULL),
    (74, N'Dieciseisavos', N'Estadio Akron', N'Marruecos', N'México', N'20260628 19:00', 2, 0, 42783, NULL),
    (75, N'Dieciseisavos', N'Lumen Field', N'Senegal', N'Suiza', N'20260628 22:00', 2, 1, 62100, NULL),
    (76, N'Dieciseisavos', N'NRG Stadium', N'Brasil', N'Austria', N'20260628 23:30', 3, 1, 65720, NULL),
    (77, N'Dieciseisavos', N'Gillette Stadium', N'Estados Unidos', N'Ecuador', N'20260629 16:00', 2, 1, 60607, NULL),
    (78, N'Dieciseisavos', N'Lincoln Financial Field', N'Alemania', N'Corea del Sur', N'20260629 19:00', 2, 0, 62862, NULL),
    (79, N'Dieciseisavos', N'Arrowhead Stadium', N'Países Bajos', N'Australia', N'20260629 22:00', 3, 1, 71831, NULL),
    (80, N'Dieciseisavos', N'Levi''s Stadium', N'Bélgica', N'Canadá', N'20260629 23:30', 2, 0, 58225, NULL),
    (81, N'Dieciseisavos', N'Estadio Azteca', N'España', N'Irán', N'20260630 16:00', 2, 1, 71607, NULL),
    (82, N'Dieciseisavos', N'MetLife Stadium', N'Portugal', N'Argelia', N'20260630 19:00', 3, 1, 71775, NULL),
    (83, N'Dieciseisavos', N'SoFi Stadium', N'Inglaterra', N'Escocia', N'20260630 22:00', 2, 1, 61811, NULL),
    (84, N'Dieciseisavos', N'AT&T Stadium', N'Uruguay', N'Curazao', N'20260630 23:30', 2, 0, 83660, NULL),
    (85, N'Dieciseisavos', N'Mercedes-Benz Stadium', N'Colombia', N'Sudáfrica', N'20260701 16:00', 3, 1, 63900, NULL),
    (86, N'Dieciseisavos', N'Hard Rock Stadium', N'Croacia', N'Suecia', N'20260701 19:00', 2, 0, 58937, NULL),
    (87, N'Dieciseisavos', N'BMO Field', N'Japón', N'RD Congo', N'20260701 22:00', 2, 1, 41400, NULL),
    (88, N'Dieciseisavos', N'BC Place', N'Francia', N'Turquía', N'20260701 23:30', 3, 1, 50685, NULL),
    (89, N'Octavos', N'Estadio BBVA', N'Argentina', N'Marruecos', N'20260704 16:00', 2, 1, 50290, NULL),
    (90, N'Octavos', N'Estadio Akron', N'Brasil', N'Senegal', N'20260704 19:00', 2, 0, 40860, NULL),
    (91, N'Octavos', N'Lumen Field', N'Alemania', N'Estados Unidos', N'20260705 22:00', 2, 1, 59340, NULL),
    (92, N'Octavos', N'NRG Stadium', N'Países Bajos', N'Bélgica', N'20260705 23:30', 2, 0, 62831, NULL),
    (93, N'Octavos', N'Gillette Stadium', N'España', N'Portugal', N'20260706 16:00', 2, 1, 57972, NULL),
    (94, N'Octavos', N'Lincoln Financial Field', N'Inglaterra', N'Uruguay', N'20260706 19:00', 2, 0, 60158, NULL),
    (95, N'Octavos', N'Arrowhead Stadium', N'Colombia', N'Croacia', N'20260707 22:00', 2, 1, 68774, NULL),
    (96, N'Octavos', N'Levi''s Stadium', N'Francia', N'Japón', N'20260707 23:30', 2, 0, 62334, NULL),
    (97, N'Cuartos', N'Estadio Azteca', N'Argentina', N'Brasil', N'20260709 16:00', 2, 1, 76602, NULL),
    (98, N'Cuartos', N'MetLife Stadium', N'Alemania', N'Países Bajos', N'20260709 19:00', 2, 0, 76725, NULL),
    (99, N'Cuartos', N'SoFi Stadium', N'Inglaterra', N'España', N'20260710 22:00', 2, 1, 66025, NULL),
    (100, N'Cuartos', N'AT&T Stadium', N'Francia', N'Colombia', N'20260711 23:30', 2, 0, 79900, NULL),
    (101, N'Semifinal', N'Mercedes-Benz Stadium', N'Argentina', N'Alemania', N'20260714 16:00', 2, 1, 61060, NULL),
    (102, N'Semifinal', N'Hard Rock Stadium', N'Francia', N'Inglaterra', N'20260715 19:00', 2, 0, 56347, NULL),
    (103, N'Tercer Puesto', N'Hard Rock Stadium', N'Alemania', N'Inglaterra', N'20260718 21:00', 2, 1, 56994, NULL),
    (104, N'Final', N'MetLife Stadium', N'Argentina', N'Francia', N'20260719 19:00', 3, 2, 73425, NULL);

UPDATE f
   SET SedeID  = (SELECT MIN(s.SedeID) FROM torneo.Sede s WHERE s.NombreEstadio = f.Sede),
       LocalID = (SELECT MIN(x.SeleccionID) FROM torneo.Seleccion x WHERE x.Pais = f.EqLocal),
       VisitID = (SELECT MIN(x.SeleccionID) FROM torneo.Seleccion x WHERE x.Pais = f.EqVisita)
  FROM #Fixture f;
GO

DECLARE @Nro INT, @SedeID INT, @LocalID INT, @VisitID INT, @Fase VARCHAR(50), @UTC DATETIME, @Asis INT;
DECLARE @PartidoID INT, @Huso INT, @FLocal DATETIME, @Cap INT;

DECLARE cPartidos CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT Nro, SedeID, LocalID, VisitID, Fase, UTC, Asistencia
    FROM #Fixture
    ORDER BY Nro;

OPEN cPartidos;
FETCH NEXT FROM cPartidos INTO @Nro, @SedeID, @LocalID, @VisitID, @Fase, @UTC, @Asis;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @PartidoID = NULL;

    IF @SedeID IS NOT NULL AND @LocalID IS NOT NULL AND @VisitID IS NOT NULL
    BEGIN
        SELECT TOP 1 @PartidoID = p.PartidoID
        FROM torneo.Partido p
        JOIN torneo.Juega jl ON jl.PartidoID = p.PartidoID AND jl.SeleccionID = @LocalID
        JOIN torneo.Juega jv ON jv.PartidoID = p.PartidoID AND jv.SeleccionID = @VisitID
        WHERE p.SedeID = @SedeID AND p.Fase = @Fase
        ORDER BY p.PartidoID;

        IF @PartidoID IS NULL
        BEGIN
            WHILE EXISTS (SELECT 1 FROM torneo.Partido WHERE SedeID = @SedeID AND fechaHoraUTC = @UTC)
                SET @UTC = DATEADD(MINUTE, 15, @UTC);

            SELECT @Huso = TRY_CAST(REPLACE(HusoHorario, 'UTC', '') AS INT), @Cap = Capacidad
            FROM torneo.Sede WHERE SedeID = @SedeID;

            SET @FLocal = DATEADD(HOUR, ISNULL(@Huso, 0), @UTC);
            IF @Asis > @Cap SET @Asis = @Cap;

            BEGIN TRY
                EXEC torneo.SP_RegistrarPartidoCompleto
                     @SedeID = @SedeID, @LocalID = @LocalID, @VisitanteID = @VisitID,
                     @Fase = @Fase, @Asistencia = @Asis,
                     @FechaHoraLocal = @FLocal, @FechaHoraUTC = @UTC;
            END TRY
            BEGIN CATCH
                PRINT 'ERROR al registrar el partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ': ' + ERROR_MESSAGE();
            END CATCH

            SELECT TOP 1 @PartidoID = p.PartidoID
            FROM torneo.Partido p
            JOIN torneo.Juega jl ON jl.PartidoID = p.PartidoID AND jl.SeleccionID = @LocalID
            JOIN torneo.Juega jv ON jv.PartidoID = p.PartidoID AND jv.SeleccionID = @VisitID
            WHERE p.SedeID = @SedeID AND p.Fase = @Fase
            ORDER BY p.PartidoID;
        END

        UPDATE f
           SET PartidoID = @PartidoID,
               UTC = ISNULL((SELECT p.fechaHoraUTC FROM torneo.Partido p WHERE p.PartidoID = @PartidoID), f.UTC)
          FROM #Fixture f
         WHERE f.Nro = @Nro;
    END
    ELSE
        PRINT 'AVISO: partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ' sin sede o seleccion resuelta.';

    FETCH NEXT FROM cPartidos INTO @Nro, @SedeID, @LocalID, @VisitID, @Fase, @UTC, @Asis;
END

CLOSE cPartidos;
DEALLOCATE cPartidos;

SELECT COUNT(*) AS PartidosDelFixture, SUM(CASE WHEN PartidoID IS NULL THEN 1 ELSE 0 END) AS SinCrear FROM #Fixture;
GO

-- ==============================================
-- 7. FORMACIONES, TITULARES Y BANCO DE SUPLENTES
-- ==============================================

PRINT '--- 7. Formaciones y alineaciones ---';

CREATE TABLE #TarjetaPlan (
    Nro           INT NOT NULL,
    Lado          CHAR(1) NOT NULL,                 
    Dorsal        INT NOT NULL,
    Tipo          VARCHAR(30) COLLATE DATABASE_DEFAULT NOT NULL,
    Minuto        INT NOT NULL,
    Motivo        VARCHAR(100) COLLATE DATABASE_DEFAULT NOT NULL,
    PartidosFuera INT NOT NULL                     
);

INSERT INTO #TarjetaPlan (Nro, Lado, Dorsal, Tipo, Minuto, Motivo, PartidosFuera) VALUES
    (1, 'V', 7, 'Amarilla', 8, N'Mano deliberada', 0),
    (1, 'V', 3, 'Amarilla', 14, N'Mano deliberada', 0),
    (1, 'L', 17, 'Amarilla', 23, N'Falta tactica', 0),
    (1, 'L', 18, 'Amarilla', 45, N'Mano deliberada', 0),
    (2, 'V', 23, 'Amarilla', 13, N'Demora de juego', 0),
    (2, 'V', 6, 'Amarilla', 17, N'Demora de juego', 0),
    (2, 'L', 6, 'Amarilla', 24, N'Protestas', 0),
    (2, 'V', 5, 'Amarilla', 26, N'Mano deliberada', 0),
    (2, 'L', 18, 'Amarilla', 30, N'Mano deliberada', 0),
    (2, 'V', 3, 'Amarilla', 42, N'Protestas', 0),
    (3, 'L', 10, 'Amarilla', 31, N'Protestas', 0),
    (3, 'L', 8, 'Amarilla', 37, N'Mano deliberada', 0),
    (3, 'V', 6, 'Amarilla', 43, N'Mano deliberada', 0),
    (4, 'V', 6, 'Amarilla', 11, N'Demora de juego', 0),
    (4, 'V', 2, 'Amarilla', 22, N'Juego brusco', 0),
    (4, 'L', 13, 'Amarilla', 34, N'Demora de juego', 0),
    (4, 'L', 5, 'Amarilla', 38, N'Demora de juego', 0),
    (4, 'L', 8, 'Amarilla', 41, N'Protestas', 0),
    (5, 'L', 6, 'Amarilla', 22, N'Falta tactica', 0),
    (5, 'V', 7, 'Amarilla', 24, N'Demora de juego', 0),
    (5, 'L', 2, 'Amarilla', 35, N'Mano deliberada', 0),
    (5, 'V', 6, 'Amarilla', 38, N'Demora de juego', 0),
    (6, 'V', 4, 'Amarilla', 8, N'Falta tactica', 0),
    (6, 'V', 14, 'Amarilla', 17, N'Demora de juego', 0),
    (6, 'L', 6, 'Amarilla', 38, N'Mano deliberada', 0),
    (6, 'L', 4, 'Amarilla', 49, N'Demora de juego', 0),
    (7, 'L', 10, 'Amarilla', 20, N'Protestas', 0),
    (7, 'V', 2, 'Amarilla', 26, N'Protestas', 0),
    (7, 'L', 4, 'Amarilla', 35, N'Demora de juego', 0),
    (7, 'V', 10, 'Amarilla', 37, N'Falta tactica', 0),
    (7, 'L', 6, 'Amarilla', 39, N'Mano deliberada', 0),
    (7, 'L', 5, 'Amarilla', 40, N'Mano deliberada', 0),
    (8, 'L', 6, 'Amarilla', 19, N'Mano deliberada', 0),
    (8, 'V', 10, 'Amarilla', 20, N'Mano deliberada', 0),
    (8, 'L', 7, 'Amarilla', 24, N'Mano deliberada', 0),
    (8, 'V', 14, 'Amarilla', 25, N'Mano deliberada', 0),
    (8, 'V', 2, 'Amarilla', 31, N'Falta tactica', 0),
    (9, 'L', 2, 'Amarilla', 13, N'Falta tactica', 0),
    (9, 'V', 10, 'Amarilla', 15, N'Demora de juego', 0),
    (9, 'V', 3, 'Amarilla', 20, N'Juego brusco', 0),
    (10, 'V', 14, 'Amarilla', 17, N'Falta tactica', 0),
    (10, 'V', 8, 'Amarilla', 48, N'Protestas', 0),
    (11, 'V', 14, 'Amarilla', 26, N'Falta tactica', 0),
    (11, 'L', 4, 'Amarilla', 38, N'Demora de juego', 0),
    (11, 'L', 17, 'Amarilla', 42, N'Juego brusco', 0),
    (12, 'V', 5, 'Amarilla', 14, N'Mano deliberada', 0),
    (12, 'V', 4, 'Amarilla', 32, N'Falta tactica', 0),
    (12, 'L', 3, 'Amarilla', 40, N'Mano deliberada', 0),
    (12, 'L', 4, 'Amarilla', 45, N'Protestas', 0),
    (13, 'L', 17, 'Amarilla', 9, N'Falta tactica', 0),
    (13, 'V', 6, 'Amarilla', 28, N'Falta tactica', 0),
    (13, 'V', 5, 'Amarilla', 39, N'Mano deliberada', 0),
    (13, 'L', 4, 'Amarilla', 40, N'Mano deliberada', 0),
    (13, 'L', 2, 'Amarilla', 49, N'Protestas', 0),
    (14, 'L', 14, 'Amarilla', 17, N'Demora de juego', 0),
    (14, 'V', 20, 'Amarilla', 22, N'Falta tactica', 0),
    (14, 'L', 3, 'Amarilla', 41, N'Juego brusco', 0),
    (14, 'V', 6, 'Amarilla', 43, N'Mano deliberada', 0),
    (14, 'L', 4, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (15, 'V', 2, 'Amarilla', 11, N'Mano deliberada', 0),
    (15, 'V', 4, 'Amarilla', 49, N'Demora de juego', 0),
    (16, 'L', 5, 'Amarilla', 9, N'Juego brusco', 0),
    (16, 'L', 8, 'Amarilla', 21, N'Demora de juego', 0),
    (16, 'V', 4, 'Amarilla', 32, N'Protestas', 0),
    (16, 'L', 17, 'Amarilla', 49, N'Demora de juego', 0),
    (16, 'L', 2, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (17, 'L', 2, 'Amarilla', 19, N'Protestas', 0),
    (17, 'L', 5, 'Amarilla', 32, N'Protestas', 0),
    (17, 'V', 14, 'Amarilla', 39, N'Mano deliberada', 0),
    (18, 'V', 6, 'Amarilla', 14, N'Juego brusco', 0),
    (18, 'L', 4, 'Amarilla', 28, N'Demora de juego', 0),
    (18, 'V', 3, 'Amarilla', 41, N'Protestas', 0),
    (19, 'V', 4, 'Amarilla', 30, N'Juego brusco', 0),
    (19, 'V', 2, 'Amarilla', 30, N'Demora de juego', 0),
    (19, 'L', 3, 'Amarilla', 37, N'Protestas', 0),
    (20, 'V', 13, 'Amarilla', 14, N'Protestas', 0),
    (20, 'V', 4, 'Amarilla', 14, N'Mano deliberada', 0),
    (20, 'L', 2, 'Amarilla', 43, N'Demora de juego', 0),
    (20, 'V', 7, 'Amarilla', 43, N'Juego brusco', 0),
    (20, 'L', 5, 'Amarilla', 47, N'Protestas', 0),
    (21, 'V', 3, 'Amarilla', 28, N'Protestas', 0),
    (21, 'L', 2, 'Amarilla', 30, N'Juego brusco', 0),
    (21, 'V', 7, 'Amarilla', 45, N'Falta tactica', 0),
    (22, 'V', 8, 'Amarilla', 8, N'Falta tactica', 0),
    (22, 'L', 3, 'Amarilla', 12, N'Falta tactica', 0),
    (22, 'V', 6, 'Amarilla', 14, N'Juego brusco', 0),
    (22, 'L', 10, 'Amarilla', 24, N'Protestas', 0),
    (23, 'V', 18, 'Amarilla', 44, N'Protestas', 0),
    (24, 'L', 7, 'Amarilla', 10, N'Mano deliberada', 0),
    (24, 'V', 14, 'Amarilla', 31, N'Demora de juego', 0),
    (24, 'V', 5, 'Amarilla', 35, N'Falta tactica', 0),
    (24, 'L', 13, 'Amarilla', 48, N'Demora de juego', 0),
    (25, 'L', 6, 'Amarilla', 11, N'Mano deliberada', 0),
    (25, 'V', 6, 'Amarilla', 15, N'Protestas (acumulacion)', 1),
    (25, 'L', 8, 'Amarilla', 26, N'Protestas', 0),
    (25, 'V', 13, 'Amarilla', 34, N'Protestas', 0),
    (25, 'V', 11, 'Amarilla', 45, N'Falta tactica', 0),
    (26, 'L', 3, 'Amarilla', 15, N'Juego brusco (acumulacion)', 1),
    (26, 'V', 3, 'Amarilla', 16, N'Demora de juego', 0),
    (26, 'V', 2, 'Amarilla', 30, N'Demora de juego', 0),
    (26, 'L', 4, 'Amarilla', 43, N'Falta tactica', 0),
    (27, 'L', 8, 'Amarilla', 9, N'Mano deliberada (acumulacion)', 1),
    (27, 'V', 17, 'Amarilla', 22, N'Juego brusco', 0),
    (27, 'V', 10, 'Amarilla', 23, N'Mano deliberada', 0),
    (27, 'L', 4, 'Amarilla', 45, N'Juego brusco', 0),
    (28, 'V', 4, 'Amarilla', 9, N'Protestas', 0),
    (28, 'V', 6, 'Amarilla', 22, N'Falta tactica', 0),
    (28, 'L', 2, 'Amarilla', 42, N'Demora de juego', 0),
    (29, 'L', 5, 'Amarilla', 28, N'Juego brusco', 0),
    (29, 'V', 4, 'Amarilla', 43, N'Falta tactica (acumulacion)', 1),
    (29, 'L', 4, 'Amarilla', 48, N'Demora de juego', 0),
    (30, 'V', 8, 'Amarilla', 11, N'Juego brusco', 0),
    (30, 'V', 2, 'Amarilla', 23, N'Mano deliberada', 0),
    (30, 'L', 5, 'Amarilla', 28, N'Falta tactica', 0),
    (30, 'L', 4, 'Amarilla', 48, N'Demora de juego', 0),
    (30, 'V', 5, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (31, 'L', 8, 'Amarilla', 22, N'Demora de juego', 0),
    (31, 'V', 4, 'Amarilla', 30, N'Mano deliberada', 0),
    (31, 'L', 3, 'Amarilla', 33, N'Protestas', 0),
    (31, 'V', 13, 'Amarilla', 43, N'Mano deliberada', 0),
    (31, 'V', 3, 'Amarilla', 48, N'Mano deliberada', 0),
    (32, 'L', 14, 'Amarilla', 8, N'Protestas', 0),
    (32, 'V', 8, 'Amarilla', 10, N'Juego brusco', 0),
    (32, 'V', 6, 'Amarilla', 13, N'Protestas (acumulacion)', 1),
    (32, 'L', 3, 'Amarilla', 17, N'Mano deliberada', 0),
    (32, 'V', 5, 'Amarilla', 31, N'Demora de juego', 0),
    (32, 'L', 8, 'Amarilla', 48, N'Mano deliberada', 0),
    (33, 'V', 5, 'Amarilla', 14, N'Falta tactica', 0),
    (33, 'V', 6, 'Amarilla', 17, N'Mano deliberada', 0),
    (33, 'V', 4, 'Amarilla', 24, N'Protestas', 0),
    (33, 'V', 3, 'Amarilla', 29, N'Demora de juego', 0),
    (33, 'L', 4, 'Amarilla', 42, N'Juego brusco', 0),
    (33, 'L', 2, 'Amarilla', 44, N'Falta tactica (acumulacion)', 1),
    (33, 'L', 3, 'Amarilla', 45, N'Protestas', 0),
    (34, 'V', 5, 'Amarilla', 26, N'Protestas', 0),
    (34, 'V', 3, 'Amarilla', 42, N'Protestas', 0),
    (35, 'V', 13, 'Amarilla', 9, N'Juego brusco', 0),
    (35, 'V', 8, 'Amarilla', 18, N'Demora de juego', 0),
    (35, 'V', 7, 'Amarilla', 28, N'Demora de juego', 0),
    (35, 'L', 5, 'Amarilla', 46, N'Mano deliberada', 0),
    (35, 'L', 10, 'Amarilla', 48, N'Falta tactica', 0),
    (36, 'L', 2, 'Amarilla', 15, N'Demora de juego', 0),
    (36, 'V', 2, 'Amarilla', 31, N'Falta tactica', 0),
    (36, 'V', 18, 'Amarilla', 31, N'Protestas', 0),
    (37, 'V', 2, 'Amarilla', 28, N'Mano deliberada', 0),
    (37, 'L', 4, 'Amarilla', 46, N'Demora de juego (acumulacion)', 1),
    (38, 'V', 8, 'Amarilla', 30, N'Mano deliberada', 0),
    (38, 'L', 3, 'Amarilla', 32, N'Protestas', 0),
    (38, 'V', 2, 'Amarilla', 39, N'Falta tactica', 0),
    (39, 'V', 14, 'Amarilla', 13, N'Mano deliberada', 0),
    (39, 'L', 5, 'Amarilla', 30, N'Mano deliberada', 0),
    (39, 'L', 10, 'Amarilla', 45, N'Protestas', 0),
    (40, 'V', 10, 'Amarilla', 20, N'Mano deliberada', 0),
    (40, 'L', 7, 'Amarilla', 22, N'Juego brusco', 0),
    (40, 'L', 14, 'Amarilla', 28, N'Mano deliberada', 0),
    (40, 'V', 17, 'Amarilla', 28, N'Juego brusco (acumulacion)', 1),
    (40, 'L', 8, 'Amarilla', 40, N'Demora de juego', 0),
    (41, 'V', 6, 'Amarilla', 17, N'Mano deliberada (acumulacion)', 1),
    (41, 'L', 8, 'Amarilla', 30, N'Protestas', 0),
    (41, 'V', 8, 'Amarilla', 32, N'Juego brusco', 0),
    (42, 'V', 6, 'Amarilla', 22, N'Protestas', 0),
    (42, 'L', 6, 'Amarilla', 28, N'Protestas', 0),
    (42, 'L', 4, 'Amarilla', 29, N'Falta tactica', 0),
    (42, 'L', 20, 'Amarilla', 36, N'Protestas', 0),
    (42, 'V', 3, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (43, 'V', 10, 'Amarilla', 14, N'Mano deliberada', 0),
    (43, 'L', 3, 'Amarilla', 26, N'Demora de juego (acumulacion)', 1),
    (43, 'V', 7, 'Amarilla', 34, N'Protestas (acumulacion)', 1),
    (43, 'L', 4, 'Amarilla', 37, N'Mano deliberada', 0),
    (44, 'L', 5, 'Amarilla', 11, N'Mano deliberada', 0),
    (44, 'V', 6, 'Amarilla', 16, N'Protestas', 0),
    (44, 'L', 18, 'Amarilla', 19, N'Falta tactica', 0),
    (44, 'L', 20, 'Amarilla', 30, N'Protestas', 0),
    (45, 'L', 17, 'Amarilla', 29, N'Falta tactica', 0),
    (45, 'L', 10, 'Amarilla', 38, N'Mano deliberada', 0),
    (46, 'L', 3, 'Amarilla', 25, N'Protestas (acumulacion)', 1),
    (47, 'L', 18, 'Amarilla', 40, N'Protestas', 0),
    (47, 'V', 2, 'Amarilla', 42, N'Falta tactica', 0),
    (47, 'V', 13, 'Amarilla', 43, N'Juego brusco', 0),
    (48, 'V', 4, 'Amarilla', 9, N'Protestas', 0),
    (48, 'L', 10, 'Amarilla', 13, N'Demora de juego', 0),
    (48, 'L', 4, 'Amarilla', 18, N'Protestas', 0),
    (48, 'L', 3, 'Amarilla', 21, N'Demora de juego', 0),
    (48, 'L', 5, 'Amarilla', 34, N'Demora de juego', 0),
    (48, 'V', 2, 'Amarilla', 34, N'Falta tactica', 0),
    (49, 'L', 6, 'Amarilla', 38, N'Protestas (acumulacion)', 1),
    (49, 'V', 8, 'Amarilla', 38, N'Protestas', 0),
    (49, 'V', 6, 'Amarilla', 39, N'Protestas (acumulacion)', 1),
    (50, 'L', 2, 'Amarilla', 9, N'Mano deliberada', 0),
    (50, 'V', 8, 'Amarilla', 21, N'Demora de juego', 0),
    (50, 'L', 18, 'Amarilla', 31, N'Protestas', 0),
    (50, 'V', 7, 'Amarilla', 33, N'Protestas (acumulacion)', 1),
    (50, 'L', 4, 'Amarilla', 37, N'Juego brusco', 0),
    (51, 'L', 5, 'Amarilla', 12, N'Demora de juego', 0),
    (51, 'V', 6, 'Amarilla', 40, N'Demora de juego (acumulacion)', 1),
    (51, 'V', 7, 'Amarilla', 47, N'Falta tactica', 0),
    (52, 'V', 6, 'Amarilla', 9, N'Mano deliberada (acumulacion)', 1),
    (52, 'L', 4, 'Amarilla', 19, N'Falta tactica', 0),
    (52, 'L', 5, 'Amarilla', 29, N'Protestas', 0),
    (52, 'V', 4, 'Amarilla', 41, N'Mano deliberada', 0),
    (52, 'V', 18, 'Amarilla', 46, N'Juego brusco', 0),
    (52, 'V', 10, 'Amarilla', 48, N'Falta tactica', 0),
    (53, 'V', 13, 'Amarilla', 25, N'Mano deliberada', 0),
    (53, 'L', 5, 'Amarilla', 40, N'Demora de juego (acumulacion)', 1),
    (54, 'V', 7, 'Amarilla', 16, N'Demora de juego (acumulacion)', 1),
    (54, 'V', 11, 'Amarilla', 17, N'Juego brusco', 0),
    (54, 'V', 8, 'Amarilla', 20, N'Juego brusco', 0),
    (54, 'L', 8, 'Amarilla', 28, N'Protestas', 0),
    (54, 'V', 4, 'Amarilla', 46, N'Demora de juego (acumulacion)', 1),
    (55, 'L', 8, 'Amarilla', 10, N'Protestas (acumulacion)', 1),
    (55, 'V', 18, 'Amarilla', 16, N'Mano deliberada', 0),
    (55, 'V', 17, 'Amarilla', 18, N'Juego brusco', 0),
    (55, 'V', 4, 'Amarilla', 42, N'Protestas', 0),
    (55, 'V', 5, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (56, 'V', 17, 'Amarilla', 9, N'Protestas', 0),
    (56, 'L', 3, 'Amarilla', 17, N'Mano deliberada (acumulacion)', 1),
    (56, 'V', 8, 'Amarilla', 22, N'Demora de juego (acumulacion)', 1),
    (57, 'V', 6, 'Amarilla', 10, N'Mano deliberada', 0),
    (57, 'L', 4, 'Amarilla', 17, N'Protestas (acumulacion)', 1),
    (57, 'L', 18, 'Amarilla', 37, N'Mano deliberada', 0),
    (58, 'V', 8, 'Amarilla', 29, N'Falta tactica', 0),
    (59, 'L', 5, 'Amarilla', 13, N'Mano deliberada (acumulacion)', 1),
    (59, 'V', 5, 'Amarilla', 18, N'Juego brusco', 0),
    (59, 'V', 14, 'Amarilla', 22, N'Mano deliberada', 0),
    (60, 'V', 5, 'Amarilla', 27, N'Mano deliberada', 0),
    (60, 'V', 3, 'Amarilla', 38, N'Falta tactica', 0),
    (60, 'L', 4, 'Amarilla', 42, N'Mano deliberada (acumulacion)', 1),
    (60, 'V', 4, 'Amarilla', 43, N'Demora de juego', 0),
    (61, 'L', 6, 'Amarilla', 15, N'Falta tactica', 0),
    (61, 'L', 3, 'Amarilla', 18, N'Falta tactica', 0),
    (61, 'V', 14, 'Amarilla', 20, N'Mano deliberada (acumulacion)', 1),
    (61, 'L', 8, 'Amarilla', 30, N'Demora de juego', 0),
    (62, 'V', 14, 'Amarilla', 30, N'Mano deliberada', 0),
    (62, 'V', 8, 'Amarilla', 33, N'Falta tactica', 0),
    (62, 'V', 10, 'Amarilla', 37, N'Protestas', 0),
    (62, 'V', 4, 'Amarilla', 38, N'Demora de juego', 0),
    (63, 'L', 6, 'Amarilla', 11, N'Demora de juego', 0),
    (63, 'V', 8, 'Amarilla', 13, N'Mano deliberada (acumulacion)', 1),
    (63, 'L', 3, 'Amarilla', 22, N'Protestas', 0),
    (63, 'L', 10, 'Amarilla', 37, N'Mano deliberada (acumulacion)', 1),
    (63, 'V', 10, 'Amarilla', 37, N'Protestas (acumulacion)', 1),
    (63, 'L', 17, 'Amarilla', 46, N'Demora de juego', 0),
    (64, 'L', 6, 'Amarilla', 25, N'Protestas', 0),
    (64, 'L', 18, 'Amarilla', 41, N'Falta tactica', 0),
    (65, 'L', 6, 'Amarilla', 14, N'Mano deliberada', 0),
    (65, 'V', 6, 'Amarilla', 16, N'Falta tactica (acumulacion)', 1),
    (65, 'V', 8, 'Amarilla', 17, N'Protestas', 0),
    (65, 'L', 2, 'Amarilla', 36, N'Demora de juego (acumulacion)', 1),
    (65, 'V', 18, 'Amarilla', 42, N'Falta tactica', 0),
    (66, 'L', 3, 'Amarilla', 18, N'Demora de juego (acumulacion)', 1),
    (66, 'L', 4, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (67, 'V', 8, 'Amarilla', 23, N'Protestas', 0),
    (67, 'V', 6, 'Amarilla', 27, N'Mano deliberada (acumulacion)', 1),
    (67, 'V', 10, 'Amarilla', 29, N'Juego brusco', 0),
    (67, 'V', 2, 'Amarilla', 37, N'Juego brusco (acumulacion)', 1),
    (67, 'V', 4, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (68, 'V', 4, 'Amarilla', 20, N'Falta tactica (acumulacion)', 1),
    (68, 'L', 10, 'Amarilla', 34, N'Falta tactica (acumulacion)', 1),
    (68, 'V', 18, 'Amarilla', 45, N'Mano deliberada (acumulacion)', 1),
    (69, 'L', 17, 'Amarilla', 9, N'Mano deliberada (acumulacion)', 1),
    (69, 'L', 6, 'Amarilla', 21, N'Mano deliberada', 0),
    (69, 'V', 3, 'Amarilla', 25, N'Mano deliberada (acumulacion)', 1),
    (69, 'V', 17, 'Amarilla', 26, N'Juego brusco', 0),
    (69, 'V', 10, 'Amarilla', 41, N'Protestas (acumulacion)', 1),
    (70, 'L', 4, 'Amarilla', 15, N'Demora de juego', 0),
    (70, 'L', 2, 'Amarilla', 18, N'Demora de juego', 0),
    (70, 'V', 4, 'Amarilla', 37, N'Mano deliberada', 0),
    (70, 'V', 13, 'Amarilla', 43, N'Juego brusco', 0),
    (70, 'L', 14, 'Amarilla', 46, N'Demora de juego', 0),
    (71, 'V', 10, 'Amarilla', 10, N'Juego brusco', 0),
    (71, 'L', 6, 'Amarilla', 11, N'Protestas', 0),
    (71, 'L', 17, 'Amarilla', 23, N'Juego brusco', 0),
    (71, 'V', 6, 'Amarilla', 24, N'Juego brusco', 0),
    (71, 'V', 4, 'Amarilla', 31, N'Falta tactica (acumulacion)', 1),
    (71, 'L', 3, 'Amarilla', 33, N'Falta tactica', 0),
    (72, 'L', 3, 'Amarilla', 10, N'Protestas', 0),
    (72, 'V', 5, 'Amarilla', 11, N'Protestas (acumulacion)', 1),
    (72, 'V', 6, 'Amarilla', 13, N'Juego brusco', 0),
    (72, 'V', 8, 'Amarilla', 20, N'Mano deliberada', 0),
    (72, 'L', 18, 'Amarilla', 36, N'Demora de juego', 0),
    (72, 'V', 2, 'Amarilla', 49, N'Falta tactica', 0),
    (73, 'L', 2, 'Amarilla', 26, N'Demora de juego', 0),
    (73, 'L', 5, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (74, 'L', 3, 'Amarilla', 42, N'Juego brusco', 0),
    (74, 'V', 2, 'Amarilla', 42, N'Protestas', 0),
    (74, 'L', 8, 'Amarilla', 43, N'Demora de juego (acumulacion)', 1),
    (74, 'L', 10, 'Amarilla', 45, N'Demora de juego', 0),
    (75, 'V', 2, 'Amarilla', 34, N'Mano deliberada (acumulacion)', 1),
    (75, 'L', 17, 'Amarilla', 37, N'Falta tactica', 0),
    (76, 'L', 10, 'Amarilla', 18, N'Juego brusco', 0),
    (76, 'V', 6, 'Amarilla', 40, N'Protestas', 0),
    (76, 'L', 18, 'Amarilla', 47, N'Juego brusco', 0),
    (77, 'L', 4, 'Amarilla', 13, N'Falta tactica (acumulacion)', 1),
    (77, 'V', 10, 'Amarilla', 17, N'Protestas (acumulacion)', 1),
    (77, 'V', 14, 'Amarilla', 19, N'Mano deliberada', 0),
    (77, 'V', 4, 'Amarilla', 23, N'Mano deliberada', 0),
    (77, 'L', 6, 'Amarilla', 30, N'Falta tactica (acumulacion)', 1),
    (78, 'V', 17, 'Amarilla', 30, N'Falta tactica', 0),
    (78, 'L', 3, 'Amarilla', 32, N'Falta tactica (acumulacion)', 1),
    (78, 'L', 2, 'Amarilla', 39, N'Mano deliberada', 0),
    (78, 'V', 10, 'Amarilla', 45, N'Falta tactica', 0),
    (78, 'V', 4, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (79, 'V', 8, 'Amarilla', 9, N'Protestas', 0),
    (79, 'V', 4, 'Amarilla', 19, N'Mano deliberada (acumulacion)', 1),
    (79, 'V', 2, 'Amarilla', 23, N'Mano deliberada (acumulacion)', 1),
    (79, 'L', 3, 'Amarilla', 32, N'Juego brusco (acumulacion)', 1),
    (79, 'V', 15, 'Amarilla', 45, N'Falta tactica', 0),
    (80, 'L', 8, 'Amarilla', 8, N'Demora de juego (acumulacion)', 1),
    (80, 'L', 6, 'Amarilla', 12, N'Juego brusco (acumulacion)', 1),
    (80, 'V', 4, 'Amarilla', 24, N'Falta tactica (acumulacion)', 1),
    (80, 'V', 5, 'Amarilla', 36, N'Demora de juego (acumulacion)', 1),
    (80, 'L', 4, 'Amarilla', 38, N'Falta tactica', 0),
    (81, 'V', 3, 'Amarilla', 28, N'Mano deliberada', 0),
    (81, 'L', 17, 'Amarilla', 36, N'Demora de juego (acumulacion)', 1),
    (81, 'L', 4, 'Amarilla', 48, N'Falta tactica', 0),
    (81, 'V', 2, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (82, 'V', 10, 'Amarilla', 14, N'Demora de juego (acumulacion)', 1),
    (82, 'L', 8, 'Amarilla', 27, N'Protestas', 0),
    (82, 'L', 18, 'Amarilla', 34, N'Mano deliberada', 0),
    (82, 'L', 6, 'Amarilla', 36, N'Demora de juego (acumulacion)', 1),
    (82, 'V', 15, 'Amarilla', 43, N'Falta tactica', 0),
    (83, 'V', 3, 'Amarilla', 16, N'Demora de juego', 0),
    (83, 'V', 14, 'Amarilla', 22, N'Mano deliberada', 0),
    (83, 'V', 2, 'Amarilla', 29, N'Demora de juego', 0),
    (83, 'L', 8, 'Amarilla', 33, N'Juego brusco', 0),
    (84, 'V', 20, 'Amarilla', 19, N'Demora de juego', 0),
    (84, 'V', 3, 'Amarilla', 27, N'Falta tactica (acumulacion)', 1),
    (84, 'L', 6, 'Amarilla', 32, N'Protestas', 0),
    (84, 'L', 20, 'Amarilla', 42, N'Demora de juego', 0),
    (84, 'V', 5, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (85, 'V', 3, 'Amarilla', 11, N'Demora de juego (acumulacion)', 1),
    (85, 'L', 13, 'Amarilla', 18, N'Mano deliberada', 0),
    (85, 'V', 6, 'Amarilla', 27, N'Falta tactica', 0),
    (85, 'L', 5, 'Amarilla', 45, N'Juego brusco', 0),
    (86, 'L', 5, 'Amarilla', 22, N'Demora de juego', 0),
    (86, 'V', 8, 'Amarilla', 22, N'Falta tactica (acumulacion)', 1),
    (86, 'L', 6, 'Amarilla', 27, N'Mano deliberada (acumulacion)', 1),
    (86, 'V', 7, 'Amarilla', 32, N'Demora de juego (acumulacion)', 1),
    (86, 'V', 5, 'Amarilla', 34, N'Demora de juego (acumulacion)', 1),
    (86, 'L', 8, 'Amarilla', 40, N'Protestas', 0),
    (87, 'V', 2, 'Amarilla', 21, N'Juego brusco (acumulacion)', 1),
    (87, 'L', 13, 'Amarilla', 32, N'Protestas', 0),
    (87, 'V', 3, 'Amarilla', 33, N'Mano deliberada', 0),
    (87, 'V', 20, 'Amarilla', 39, N'Demora de juego', 0),
    (87, 'L', 8, 'Amarilla', 43, N'Demora de juego', 0),
    (88, 'L', 8, 'Amarilla', 14, N'Falta tactica (acumulacion)', 1),
    (88, 'L', 4, 'Amarilla', 21, N'Mano deliberada (acumulacion)', 1),
    (88, 'L', 5, 'Amarilla', 31, N'Falta tactica', 0),
    (88, 'L', 13, 'Amarilla', 42, N'Falta tactica', 0),
    (88, 'V', 14, 'Amarilla', 48, N'Demora de juego (acumulacion)', 1),
    (89, 'L', 10, 'Amarilla', 14, N'Falta tactica', 0),
    (89, 'V', 2, 'Amarilla', 20, N'Demora de juego (acumulacion)', 1),
    (89, 'L', 3, 'Amarilla', 27, N'Falta tactica', 0),
    (89, 'L', 18, 'Amarilla', 29, N'Juego brusco', 0),
    (89, 'L', 4, 'Amarilla', 37, N'Mano deliberada (acumulacion)', 1),
    (90, 'V', 6, 'Amarilla', 13, N'Falta tactica (acumulacion)', 1),
    (90, 'L', 4, 'Amarilla', 15, N'Falta tactica (acumulacion)', 1),
    (90, 'L', 3, 'Amarilla', 17, N'Mano deliberada', 0),
    (90, 'L', 6, 'Amarilla', 30, N'Juego brusco (acumulacion)', 1),
    (90, 'V', 3, 'Amarilla', 35, N'Juego brusco', 0),
    (91, 'L', 2, 'Amarilla', 11, N'Mano deliberada (acumulacion)', 1),
    (91, 'V', 10, 'Amarilla', 11, N'Mano deliberada (acumulacion)', 1),
    (91, 'V', 2, 'Amarilla', 19, N'Mano deliberada', 0),
    (91, 'L', 10, 'Amarilla', 36, N'Mano deliberada', 0),
    (92, 'V', 4, 'Amarilla', 8, N'Juego brusco (acumulacion)', 1),
    (92, 'L', 14, 'Amarilla', 23, N'Mano deliberada (acumulacion)', 1),
    (92, 'L', 8, 'Amarilla', 42, N'Demora de juego', 0),
    (93, 'V', 3, 'Amarilla', 13, N'Demora de juego', 0),
    (93, 'L', 19, 'Amarilla', 22, N'Protestas', 0),
    (93, 'V', 10, 'Amarilla', 28, N'Mano deliberada (acumulacion)', 1),
    (93, 'L', 6, 'Amarilla', 35, N'Falta tactica (acumulacion)', 1),
    (93, 'V', 5, 'Amarilla', 47, N'Protestas', 0),
    (94, 'L', 3, 'Amarilla', 19, N'Demora de juego (acumulacion)', 1),
    (94, 'L', 8, 'Amarilla', 34, N'Protestas (acumulacion)', 1),
    (94, 'L', 6, 'Amarilla', 46, N'Demora de juego (acumulacion)', 1),
    (95, 'L', 17, 'Amarilla', 24, N'Juego brusco (acumulacion)', 1),
    (95, 'L', 18, 'Amarilla', 26, N'Mano deliberada', 0),
    (95, 'V', 3, 'Amarilla', 27, N'Protestas', 0),
    (95, 'V', 13, 'Amarilla', 30, N'Demora de juego (acumulacion)', 1),
    (96, 'V', 8, 'Amarilla', 15, N'Protestas (acumulacion)', 1),
    (96, 'L', 13, 'Amarilla', 20, N'Demora de juego (acumulacion)', 1),
    (96, 'V', 10, 'Amarilla', 33, N'Mano deliberada (acumulacion)', 1),
    (96, 'L', 2, 'Amarilla', 46, N'Protestas', 0),
    (97, 'V', 17, 'Amarilla', 8, N'Protestas', 0),
    (97, 'L', 10, 'Amarilla', 31, N'Mano deliberada (acumulacion)', 1),
    (97, 'V', 10, 'Amarilla', 32, N'Protestas (acumulacion)', 1),
    (97, 'L', 3, 'Amarilla', 36, N'Demora de juego (acumulacion)', 1),
    (98, 'V', 4, 'Amarilla', 11, N'Falta tactica (acumulacion)', 1),
    (98, 'V', 8, 'Amarilla', 24, N'Mano deliberada (acumulacion)', 1),
    (98, 'V', 7, 'Amarilla', 29, N'Mano deliberada', 0),
    (98, 'L', 10, 'Amarilla', 31, N'Mano deliberada (acumulacion)', 1),
    (98, 'L', 13, 'Amarilla', 37, N'Falta tactica', 0),
    (98, 'L', 3, 'Amarilla', 46, N'Falta tactica', 0),
    (99, 'L', 2, 'Amarilla', 11, N'Falta tactica', 0),
    (99, 'L', 17, 'Amarilla', 21, N'Juego brusco (acumulacion)', 1),
    (99, 'V', 2, 'Amarilla', 31, N'Demora de juego', 0),
    (100, 'V', 3, 'Amarilla', 14, N'Mano deliberada', 0),
    (100, 'L', 8, 'Amarilla', 41, N'Demora de juego', 0),
    (100, 'L', 3, 'Amarilla', 47, N'Demora de juego', 0),
    (101, 'L', 4, 'Amarilla', 14, N'Falta tactica', 0),
    (101, 'V', 2, 'Amarilla', 26, N'Mano deliberada', 0),
    (101, 'V', 3, 'Amarilla', 31, N'Demora de juego (acumulacion)', 1),
    (101, 'V', 5, 'Amarilla', 36, N'Juego brusco', 0),
    (101, 'V', 17, 'Amarilla', 43, N'Falta tactica', 0),
    (102, 'L', 6, 'Amarilla', 18, N'Demora de juego', 0),
    (102, 'L', 10, 'Amarilla', 25, N'Demora de juego', 0),
    (102, 'L', 3, 'Amarilla', 33, N'Falta tactica (acumulacion)', 1),
    (102, 'V', 10, 'Amarilla', 38, N'Mano deliberada', 0),
    (102, 'V', 18, 'Amarilla', 48, N'Juego brusco (acumulacion)', 1),
    (102, 'L', 2, 'Roja', 89, N'Juego brusco grave (roja directa)', 2),
    (103, 'V', 4, 'Amarilla', 9, N'Falta tactica', 0),
    (103, 'L', 6, 'Amarilla', 16, N'Mano deliberada', 0),
    (103, 'V', 6, 'Amarilla', 18, N'Protestas', 0),
    (103, 'L', 10, 'Amarilla', 20, N'Protestas', 0),
    (103, 'L', 2, 'Amarilla', 37, N'Demora de juego (acumulacion)', 1),
    (104, 'V', 5, 'Amarilla', 8, N'Protestas (acumulacion)', 1),
    (104, 'L', 17, 'Amarilla', 12, N'Protestas', 0),
    (104, 'V', 10, 'Amarilla', 44, N'Falta tactica (acumulacion)', 1);


CREATE TABLE #EquipoPartido (
    Nro            INT NOT NULL,
    Lado           CHAR(1) NOT NULL,
    PartidoID      INT NULL,
    EquipoIdx      INT NOT NULL,
    SeleccionID    INT NOT NULL,
    ConvocatoriaID INT NOT NULL,
    TeamSeq        INT NULL                         
);

INSERT INTO #EquipoPartido (Nro, Lado, PartidoID, EquipoIdx, SeleccionID, ConvocatoriaID)
SELECT f.Nro, 'L', f.PartidoID, e.Idx, e.SeleccionID, e.ConvocatoriaID
FROM #Fixture f JOIN #Equipo e ON e.Pais = f.EqLocal
WHERE e.SeleccionID IS NOT NULL AND e.ConvocatoriaID IS NOT NULL
UNION ALL
SELECT f.Nro, 'V', f.PartidoID, e.Idx, e.SeleccionID, e.ConvocatoriaID
FROM #Fixture f JOIN #Equipo e ON e.Pais = f.EqVisita
WHERE e.SeleccionID IS NOT NULL AND e.ConvocatoriaID IS NOT NULL;

UPDATE ep
   SET TeamSeq = x.rn
  FROM #EquipoPartido ep
  JOIN (SELECT Nro, Lado, ROW_NUMBER() OVER (PARTITION BY SeleccionID ORDER BY Nro) AS rn FROM #EquipoPartido) x
    ON x.Nro = ep.Nro AND x.Lado = ep.Lado;

CREATE TABLE #Sancion (SeleccionID INT NOT NULL, Dorsal INT NOT NULL, TeamSeq INT NOT NULL, PartidosFuera INT NOT NULL);
INSERT INTO #Sancion (SeleccionID, Dorsal, TeamSeq, PartidosFuera)
SELECT ep.SeleccionID, t.Dorsal, ep.TeamSeq, t.PartidosFuera
FROM #TarjetaPlan t
JOIN #EquipoPartido ep ON ep.Nro = t.Nro AND ep.Lado = t.Lado
WHERE t.PartidosFuera > 0;

SELECT DISTINCT PersonaID INTO #Excluido FROM reglamento.Suspension WHERE PartidosSuspendido > 0;
GO

DECLARE @P INT, @Nro INT, @Lado CHAR(1), @EqIdx INT, @Sel INT, @Conv INT, @Seq INT;
DECLARE @Esq VARCHAR(50), @qD INT, @qM INT, @qF INT, @FormID INT;

DECLARE cAlin CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT PartidoID, Nro, Lado, EquipoIdx, SeleccionID, ConvocatoriaID, TeamSeq
    FROM #EquipoPartido
    WHERE PartidoID IS NOT NULL
    ORDER BY Nro, Lado;

OPEN cAlin;
FETCH NEXT FROM cAlin INTO @P, @Nro, @Lado, @EqIdx, @Sel, @Conv, @Seq;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1
                   FROM torneo.TieneFormacion tf
                   JOIN torneo.Participa pa ON pa.FormacionID = tf.FormacionID
                   JOIN torneo.Jugador j ON j.PersonaID = pa.PersonaID
                   WHERE tf.PartidoID = @P AND j.ConvocatoriaID = @Conv)
    BEGIN
        SET @Esq = CHOOSE(((@EqIdx + @Nro) % 4) + 1, '4-3-3', '4-4-2', '3-5-2', '4-2-3-1');
        SET @qD = CASE WHEN @Esq = '3-5-2' THEN 3 ELSE 4 END;
        SET @qM = CASE @Esq WHEN '4-3-3' THEN 3 WHEN '4-4-2' THEN 4 ELSE 5 END;
        SET @qF = CASE @Esq WHEN '4-3-3' THEN 3 WHEN '4-2-3-1' THEN 1 ELSE 2 END;

        INSERT INTO torneo.Formacion (EsquemaTactico) VALUES (@Esq);
        SET @FormID = SCOPE_IDENTITY();

        INSERT INTO torneo.TieneFormacion (PartidoID, FormacionID) VALUES (@P, @FormID);

        ;WITH J AS (
            SELECT j.PersonaID, j.Dorsal, j.PosicionHabitual AS Pos,
                   ROW_NUMBER() OVER (PARTITION BY j.PosicionHabitual ORDER BY j.Dorsal) AS rk
            FROM torneo.Jugador j
            WHERE j.ConvocatoriaID = @Conv
              AND NOT EXISTS (SELECT 1 FROM #Excluido x WHERE x.PersonaID = j.PersonaID)
              AND NOT EXISTS (SELECT 1 FROM #Sancion s
                              WHERE s.SeleccionID = @Sel AND s.Dorsal = j.Dorsal
                                AND @Seq > s.TeamSeq AND @Seq <= s.TeamSeq + s.PartidosFuera)
        ),
        K AS (
            SELECT PersonaID, Dorsal, Pos, rk,
                   CASE WHEN (Pos = 'Arquero' AND rk <= 1)
                          OR (Pos = 'Defensor' AND rk <= @qD)
                          OR (Pos = 'Mediocampista' AND rk <= @qM)
                          OR (Pos = 'Delantero' AND rk <= @qF)
                        THEN 1 ELSE 0 END AS Tit
            FROM J
        )
        INSERT INTO torneo.Participa (FormacionID, PersonaID, Titular, PosicionCancha)
        SELECT @FormID, PersonaID, Tit,
               CASE WHEN Tit = 0 THEN 'Suplente - ' + Pos
                    ELSE CASE Pos
                           WHEN 'Arquero' THEN 'Arquero'
                           WHEN 'Defensor' THEN CASE WHEN rk = 1 THEN 'Lateral Derecho'
                                                     WHEN rk = 4 THEN 'Lateral Izquierdo'
                                                     ELSE 'Defensor Central' END
                           WHEN 'Mediocampista' THEN CASE WHEN rk = 1 THEN 'Mediocampista Defensivo'
                                                          WHEN rk = 2 THEN 'Mediocampista Central'
                                                          ELSE 'Mediocampista Ofensivo' END
                           WHEN 'Delantero' THEN CASE WHEN rk = 1 THEN 'Centrodelantero' ELSE 'Extremo' END
                           ELSE Pos END
               END
        FROM K;
    END

    FETCH NEXT FROM cAlin INTO @P, @Nro, @Lado, @EqIdx, @Sel, @Conv, @Seq;
END

CLOSE cAlin;
DEALLOCATE cAlin;
GO

CREATE TABLE #Alineacion (
    PartidoID   INT NOT NULL,
    SeleccionID INT NOT NULL,
    PersonaID   INT NOT NULL,
    Titular     BIT NOT NULL,
    Dorsal      INT NOT NULL,
    Posicion    VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #Alineacion (PartidoID, SeleccionID, PersonaID, Titular, Dorsal, Posicion)
SELECT tf.PartidoID, c.SeleccionID, pa.PersonaID, pa.Titular, j.Dorsal, j.PosicionHabitual
FROM torneo.TieneFormacion tf
JOIN torneo.Participa pa ON pa.FormacionID = tf.FormacionID
JOIN torneo.Jugador j ON j.PersonaID = pa.PersonaID
JOIN torneo.Convocatoria c ON c.ConvocatoriaID = j.ConvocatoriaID
WHERE tf.PartidoID IN (SELECT PartidoID FROM #Fixture WHERE PartidoID IS NOT NULL);

SELECT ep.Nro, ep.Lado, SUM(CAST(a.Titular AS INT)) AS Titulares, SUM(1 - CAST(a.Titular AS INT)) AS Suplentes
FROM #EquipoPartido ep
LEFT JOIN #Alineacion a ON a.PartidoID = ep.PartidoID AND a.SeleccionID = ep.SeleccionID
WHERE ep.PartidoID IS NOT NULL
GROUP BY ep.Nro, ep.Lado
HAVING ISNULL(SUM(CAST(a.Titular AS INT)), 0) <> 11;
GO

-- =======================================================
-- 8. GOLES (torneo.SP_RegistrarGol_Y_ActualizarResultado)
-- =======================================================

PRINT '--- 8. Goles ---';

CREATE TABLE #GolEspecial (
    Nro INT NOT NULL, Lado CHAR(1) NOT NULL, K INT NOT NULL,
    Minuto INT NOT NULL,
    Periodo VARCHAR(30) COLLATE DATABASE_DEFAULT NOT NULL,
    Tipo    VARCHAR(30) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #GolEspecial (Nro, Lado, K, Minuto, Periodo, Tipo) VALUES
    (26, 'L', 3, 108, N'Adicionales', N'Jugada'),
    (32, 'L', 3, 93, N'Adicionales', N'Jugada');

CREATE TABLE #GolPlan (Nro INT NOT NULL, Lado CHAR(1) NOT NULL, K INT NOT NULL);
INSERT INTO #GolPlan (Nro, Lado, K)
SELECT f.Nro, 'L', n.n FROM #Fixture f JOIN (VALUES (1),(2),(3),(4),(5),(6)) n(n) ON n.n <= f.GL
UNION ALL
SELECT f.Nro, 'V', n.n FROM #Fixture f JOIN (VALUES (1),(2),(3),(4),(5),(6)) n(n) ON n.n <= f.GV;
GO

DECLARE @Nro INT, @Lado CHAR(1), @K INT, @P INT, @Sel INT, @EqIdx INT;
DECLARE @r INT, @idx INT, @t INT, @Autor INT, @Asist INT, @Min INT;
DECLARE @Periodo VARCHAR(30), @Tipo VARCHAR(30);

DECLARE cGoles CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT g.Nro, g.Lado, g.K, ep.PartidoID, ep.SeleccionID, ep.EquipoIdx
    FROM #GolPlan g
    JOIN #EquipoPartido ep ON ep.Nro = g.Nro AND ep.Lado = g.Lado
    WHERE ep.PartidoID IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM torneo.Gol x WHERE x.PartidoID = ep.PartidoID)   -- no duplicar si ya hay goles
    ORDER BY g.Nro, g.Lado, g.K;

OPEN cGoles;
FETCH NEXT FROM cGoles INTO @Nro, @Lado, @K, @P, @Sel, @EqIdx;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Autor = NULL;
    SET @Asist = NULL;

    SET @r = (@Nro * 5 + @K * 3 + @EqIdx * 2) % 10;
    SET @idx = CASE WHEN @r < 3 THEN 1 WHEN @r < 5 THEN 2 WHEN @r < 7 THEN 3 WHEN @r = 7 THEN 4 WHEN @r = 8 THEN 5 ELSE 6 END;

    ;WITH C AS (
        SELECT PersonaID,
               ROW_NUMBER() OVER (ORDER BY CASE Dorsal WHEN 9 THEN 1 WHEN 10 THEN 2 WHEN 11 THEN 3 WHEN 7 THEN 4 WHEN 8 THEN 5 ELSE 6 END, Dorsal) AS rn,
               COUNT(*) OVER () AS cnt
        FROM #Alineacion
        WHERE PartidoID = @P AND SeleccionID = @Sel AND Titular = 1
          AND Posicion IN ('Delantero', 'Mediocampista')
    )
    SELECT @Autor = PersonaID FROM C WHERE rn = CASE WHEN @idx > cnt THEN cnt ELSE @idx END;

    SET @t = (@Nro + @K + @EqIdx) % 9;
    SET @Tipo = CASE @t WHEN 0 THEN 'Penal' WHEN 1 THEN 'Tiro libre' WHEN 2 THEN 'Cabezazo' ELSE 'Jugada' END;
    SET @Min = 6 + ((@Nro * 11 + @K * 23 + CASE @Lado WHEN 'L' THEN 0 ELSE 7 END) % 80);
    SET @Periodo = CASE WHEN @Min <= 45 THEN 'Primer tiempo' ELSE 'Segundo tiempo' END;

    SELECT @Min = ge.Minuto, @Periodo = ge.Periodo, @Tipo = ge.Tipo
    FROM #GolEspecial ge
    WHERE ge.Nro = @Nro AND ge.Lado = @Lado AND ge.K = @K;

    IF @Tipo <> 'Penal' AND (@Nro + @K) % 4 <> 0 AND @Autor IS NOT NULL
    BEGIN
        ;WITH A AS (
            SELECT PersonaID,
                   ROW_NUMBER() OVER (ORDER BY CASE Dorsal WHEN 10 THEN 1 WHEN 8 THEN 2 WHEN 11 THEN 3 WHEN 7 THEN 4 WHEN 6 THEN 5 WHEN 9 THEN 6 ELSE 7 END, Dorsal) AS rn
            FROM #Alineacion
            WHERE PartidoID = @P AND SeleccionID = @Sel AND Titular = 1
              AND PersonaID <> @Autor AND Posicion <> 'Arquero'
        )
        SELECT @Asist = PersonaID FROM A WHERE rn = ((@Nro + @K) % 3) + 1;
    END

    IF @Autor IS NULL
        PRINT 'AVISO: sin autor disponible para el gol ' + CAST(@K AS VARCHAR(3)) + ' del partido Nro ' + CAST(@Nro AS VARCHAR(5));
    ELSE
    BEGIN
        BEGIN TRY
            EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado
                 @PartidoID = @P, @PersonaID = @Autor, @AsistentePersonaID = @Asist,
                 @Periodo = @Periodo, @Tipo = @Tipo, @Minuto = @Min;
        END TRY
        BEGIN CATCH
            PRINT 'ERROR gol (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + '): ' + ERROR_MESSAGE();
        END CATCH
    END

    FETCH NEXT FROM cGoles INTO @Nro, @Lado, @K, @P, @Sel, @EqIdx;
END

CLOSE cGoles;
DEALLOCATE cGoles;

SELECT COUNT(*) AS GolesDelFixture FROM torneo.Gol WHERE PartidoID IN (SELECT PartidoID FROM #Fixture WHERE PartidoID IS NOT NULL);
GO

-- ===============================
-- 9. AMONESTACIONES Y EXPULSIONES
-- ===============================

PRINT '--- 9. Tarjetas ---';

DECLARE @Nro INT, @Lado CHAR(1), @Dorsal INT, @Tipo VARCHAR(30), @Min INT, @Motivo VARCHAR(100);
DECLARE @P INT, @Sel INT, @Pers INT, @TarjID INT;

DECLARE cTarj CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT t.Nro, t.Lado, t.Dorsal, t.Tipo, t.Minuto, t.Motivo, ep.PartidoID, ep.SeleccionID
    FROM #TarjetaPlan t
    JOIN #EquipoPartido ep ON ep.Nro = t.Nro AND ep.Lado = t.Lado
    WHERE ep.PartidoID IS NOT NULL
    ORDER BY t.Nro, t.Minuto;

OPEN cTarj;
FETCH NEXT FROM cTarj INTO @Nro, @Lado, @Dorsal, @Tipo, @Min, @Motivo, @P, @Sel;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Pers = NULL;
    SET @TarjID = NULL;

    SELECT @Pers = a.PersonaID
    FROM #Alineacion a
    WHERE a.PartidoID = @P AND a.SeleccionID = @Sel AND a.Dorsal = @Dorsal AND a.Titular = 1;

    SELECT TOP 1 @TarjID = TarjetaID FROM reglamento.Tarjeta WHERE Tipo = @Tipo ORDER BY TarjetaID;

    IF @Pers IS NULL OR @TarjID IS NULL
        PRINT 'AVISO: no se pudo resolver jugador/tarjeta (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ', dorsal ' + CAST(@Dorsal AS VARCHAR(3)) + ')';
    ELSE IF NOT EXISTS (SELECT 1 FROM reglamento.TarjetaAsignada
                        WHERE PartidoID = @P AND PersonaID = @Pers AND TarjetaID = @TarjID AND Minuto = @Min)
    BEGIN
        BEGIN TRY
            EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension
                 @TarjetaID = @TarjID, @PartidoID = @P, @PersonaID = @Pers, @Minuto = @Min, @Motivo = @Motivo;
        END TRY
        BEGIN CATCH
            PRINT 'ERROR tarjeta (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + '): ' + ERROR_MESSAGE();
        END CATCH
    END

    FETCH NEXT FROM cTarj INTO @Nro, @Lado, @Dorsal, @Tipo, @Min, @Motivo, @P, @Sel;
END

CLOSE cTarj;
DEALLOCATE cTarj;


SELECT s.SuspensionID, p.Nombre, p.Apellido, sel.Pais AS Seleccion, s.Motivo, s.PartidosSuspendido
FROM reglamento.Suspension s
JOIN torneo.Jugador j ON j.PersonaID = s.PersonaID
JOIN torneo.Persona p ON p.PersonaID = s.PersonaID
JOIN torneo.Convocatoria c ON c.ConvocatoriaID = j.ConvocatoriaID
JOIN torneo.Seleccion sel ON sel.SeleccionID = c.SeleccionID
WHERE sel.Pais IN (SELECT Pais FROM #Equipo)
ORDER BY s.SuspensionID;
GO

-- ===========
-- 10. CAMBIOS
-- ===========

PRINT '--- 10. Cambios ---';

CREATE TABLE #SubPlantilla (
    Slot INT NOT NULL, Grupo VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    OutRank INT NOT NULL, InRank INT NOT NULL, Minuto INT NOT NULL, Ventana INT NOT NULL,
    Motivo VARCHAR(20) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #SubPlantilla (Slot, Grupo, OutRank, InRank, Minuto, Ventana, Motivo) VALUES
    (1, 'Mediocampista', 1, 1, 58, 1, 'Tactico'),
    (2, 'Delantero',     1, 1, 68, 2, 'Tactico'),
    (3, 'Defensor',      1, 1, 79, 3, 'Tactico');

CREATE TABLE #SubEspecial (
    Nro INT NOT NULL, Lado CHAR(1) NOT NULL, Slot INT NOT NULL,
    Grupo VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    OutRank INT NOT NULL, InRank INT NOT NULL, Minuto INT NOT NULL, Ventana INT NOT NULL,
    Motivo VARCHAR(20) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #SubEspecial (Nro, Lado, Slot, Grupo, OutRank, InRank, Minuto, Ventana, Motivo) VALUES
    (7, 'V', 2, N'Delantero', 1, 1, 14, 1, N'Lesion'),
    (26, 'L', 4, N'Mediocampista', 2, 2, 70, 2, N'Tactico'),
    (26, 'L', 5, N'Defensor', 2, 2, 82, 3, N'Tactico'),
    (26, 'L', 6, N'Defensor', 3, 3, 98, 4, N'Tactico');

CREATE TABLE #SubFinal (
    Nro INT NOT NULL, Lado CHAR(1) NOT NULL, Slot INT NOT NULL,
    Grupo VARCHAR(50) COLLATE DATABASE_DEFAULT NOT NULL,
    OutRank INT NOT NULL, InRank INT NOT NULL, Minuto INT NOT NULL, Ventana INT NOT NULL,
    Motivo VARCHAR(20) COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #SubFinal (Nro, Lado, Slot, Grupo, OutRank, InRank, Minuto, Ventana, Motivo)
SELECT ep.Nro, ep.Lado, p.Slot, p.Grupo, p.OutRank, p.InRank, p.Minuto + (ep.Nro % 5), p.Ventana, p.Motivo
FROM #EquipoPartido ep
CROSS JOIN #SubPlantilla p
WHERE NOT EXISTS (SELECT 1 FROM #SubEspecial e WHERE e.Nro = ep.Nro AND e.Lado = ep.Lado AND e.Slot = p.Slot)
UNION ALL
SELECT Nro, Lado, Slot, Grupo, OutRank, InRank, Minuto, Ventana, Motivo FROM #SubEspecial;
GO

DECLARE @Nro INT, @Lado CHAR(1), @Slot INT, @Grupo VARCHAR(50), @OutRank INT, @InRank INT;
DECLARE @Min INT, @Vent INT, @Motivo VARCHAR(20), @P INT, @Sel INT, @Sale INT, @Entra INT;

DECLARE cSub CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT s.Nro, s.Lado, s.Slot, s.Grupo, s.OutRank, s.InRank, s.Minuto, s.Ventana, s.Motivo, ep.PartidoID, ep.SeleccionID
    FROM #SubFinal s
    JOIN #EquipoPartido ep ON ep.Nro = s.Nro AND ep.Lado = s.Lado
    WHERE ep.PartidoID IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM torneo.Sustitucion x WHERE x.PartidoID = ep.PartidoID) 
    ORDER BY s.Nro, s.Lado, s.Minuto;

OPEN cSub;
FETCH NEXT FROM cSub INTO @Nro, @Lado, @Slot, @Grupo, @OutRank, @InRank, @Min, @Vent, @Motivo, @P, @Sel;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Sale = NULL;
    SET @Entra = NULL;

    SELECT @Sale = x.PersonaID
    FROM (SELECT a.PersonaID, ROW_NUMBER() OVER (ORDER BY a.Dorsal DESC) AS rn
          FROM #Alineacion a
          WHERE a.PartidoID = @P AND a.SeleccionID = @Sel AND a.Titular = 1 AND a.Posicion = @Grupo
            AND NOT EXISTS (SELECT 1 FROM reglamento.TarjetaAsignada ta
                            JOIN reglamento.Tarjeta tt ON tt.TarjetaID = ta.TarjetaID
                            WHERE ta.PartidoID = a.PartidoID AND ta.PersonaID = a.PersonaID AND tt.Tipo = 'Roja')
            AND (SELECT COUNT(*) FROM reglamento.TarjetaAsignada ta2
                 JOIN reglamento.Tarjeta tt2 ON tt2.TarjetaID = ta2.TarjetaID
                 WHERE ta2.PartidoID = a.PartidoID AND ta2.PersonaID = a.PersonaID AND tt2.Tipo = 'Amarilla') < 2
         ) x
    WHERE x.rn = @OutRank;

    SELECT @Entra = y.PersonaID
    FROM (SELECT a.PersonaID, ROW_NUMBER() OVER (ORDER BY a.Dorsal ASC) AS rn
          FROM #Alineacion a
          WHERE a.PartidoID = @P AND a.SeleccionID = @Sel AND a.Titular = 0 AND a.Posicion = @Grupo) y
    WHERE y.rn = @InRank;

    IF @Sale IS NULL OR @Entra IS NULL
        PRINT 'AVISO: no se pudo resolver el cambio (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ', ' + @Grupo + ')';
    ELSE
    BEGIN
        BEGIN TRY
            EXEC torneo.SP_RegistrarCambioPartido
                 @PartidoID = @P, @JugadorSaleID = @Sale, @JugadorEntraID = @Entra,
                 @NumeroVentana = @Vent, @Minuto = @Min, @Motivo = @Motivo;
        END TRY
        BEGIN CATCH
            PRINT 'ERROR cambio (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + '): ' + ERROR_MESSAGE();
        END CATCH
    END

    FETCH NEXT FROM cSub INTO @Nro, @Lado, @Slot, @Grupo, @OutRank, @InRank, @Min, @Vent, @Motivo, @P, @Sel;
END

CLOSE cSub;
DEALLOCATE cSub;

SELECT COUNT(*) AS CambiosDelFixture FROM torneo.Sustitucion WHERE PartidoID IN (SELECT PartidoID FROM #Fixture WHERE PartidoID IS NOT NULL);
GO

-- ==============================================================
-- 11. RESULTADO FINAL EN FORMATO 'goles local - goles visitante'
-- ==============================================================

PRINT '--- 11. Resultados ---';

DECLARE @P INT, @GL INT, @GV INT, @Res VARCHAR(20), @SedeID INT, @Fase VARCHAR(50), @Asis INT;
DECLARE @FL DATETIME, @FU DATETIME, @ResAct VARCHAR(20), @Goles INT;

DECLARE cRes CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT PartidoID, GL, GV FROM #Fixture WHERE PartidoID IS NOT NULL ORDER BY Nro;

OPEN cRes;
FETCH NEXT FROM cRes INTO @P, @GL, @GV;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Res = CAST(@GL AS VARCHAR(5)) + '-' + CAST(@GV AS VARCHAR(5));
    SET @Goles = (SELECT COUNT(*) FROM torneo.Gol WHERE PartidoID = @P);

    SELECT @SedeID = SedeID, @Fase = Fase, @Asis = Asistencia,
           @FL = fechaHoraLocal, @FU = fechaHoraUTC, @ResAct = ResultadoFinal
    FROM torneo.Partido WHERE PartidoID = @P;

    IF @Goles = @GL + @GV AND ISNULL(@ResAct, '') <> @Res
    BEGIN
        BEGIN TRY
            EXEC torneo.SP_Modificacion_Partido
                 @PartidoID = @P, @SedeID = @SedeID, @Fase = @Fase, @Asistencia = @Asis,
                 @ResultadoFinal = @Res, @fechaHoraLocal = @FL, @fechaHoraUTC = @FU;
        END TRY
        BEGIN CATCH
            PRINT 'ERROR resultado (partido ' + CAST(@P AS VARCHAR(10)) + '): ' + ERROR_MESSAGE();
        END CATCH
    END

    FETCH NEXT FROM cRes INTO @P, @GL, @GV;
END

CLOSE cRes;
DEALLOCATE cRes;

SELECT f.Nro, f.PartidoID, p.ResultadoFinal, CAST(f.GL AS VARCHAR(5)) + '-' + CAST(f.GV AS VARCHAR(5)) AS EsperadoFixture,
       (SELECT COUNT(*) FROM torneo.Gol g WHERE g.PartidoID = f.PartidoID) AS GolesCargados
FROM #Fixture f
JOIN torneo.Partido p ON p.PartidoID = f.PartidoID
WHERE p.ResultadoFinal <> CAST(f.GL AS VARCHAR(5)) + '-' + CAST(f.GV AS VARCHAR(5))
   OR (SELECT COUNT(*) FROM torneo.Gol g WHERE g.PartidoID = f.PartidoID) <> f.GL + f.GV;
GO

-- ========================
-- 12. DESIGNACION ARBITRAL
-- ========================

PRINT '--- 12. Designaciones arbitrales ---';

DECLARE @Nro INT, @P INT, @Fase VARCHAR(50), @PaisForzado VARCHAR(50);
DECLARE @Slot INT, @Rol VARCHAR(50), @Arb INT, @Informe VARCHAR(50), @HayExp INT, @HayAm INT;

DECLARE cArb CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT Nro, PartidoID, Fase, PrincipalPais FROM #Fixture WHERE PartidoID IS NOT NULL ORDER BY Nro;

OPEN cArb;
FETCH NEXT FROM cArb INTO @Nro, @P, @Fase, @PaisForzado;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM reglamento.SeDesignaArbitro WHERE PartidoID = @P)
    BEGIN

        SELECT @HayExp = COUNT(*)
        FROM reglamento.TarjetaAsignada ta JOIN reglamento.Tarjeta t ON t.TarjetaID = ta.TarjetaID
        WHERE ta.PartidoID = @P AND t.Tipo = 'Roja';

        SELECT @HayExp = @HayExp + COUNT(*)
        FROM (SELECT ta.PersonaID
              FROM reglamento.TarjetaAsignada ta JOIN reglamento.Tarjeta t ON t.TarjetaID = ta.TarjetaID
              WHERE ta.PartidoID = @P AND t.Tipo = 'Amarilla'
              GROUP BY ta.PersonaID HAVING COUNT(*) >= 2) d;

        SELECT @HayAm = COUNT(*) FROM reglamento.TarjetaAsignada WHERE PartidoID = @P;

        SET @Slot = 1;
        WHILE @Slot <= 5
        BEGIN
            SET @Rol = CASE @Slot WHEN 1 THEN 'Principal' WHEN 2 THEN 'Asistente' WHEN 3 THEN 'Asistente'
                                  WHEN 4 THEN 'Cuarto Arbitro' ELSE 'VAR' END;
            SET @Arb = NULL;

            IF @Slot = 1 AND @PaisForzado IS NOT NULL
                SELECT TOP 1 @Arb = a.PersonaID
                FROM #ArbSeed a
                WHERE a.Rol = 'Principal' AND a.Pais = @PaisForzado AND a.PersonaID IS NOT NULL
                ORDER BY a.Orden;

            IF @Arb IS NULL
                SELECT TOP 1 @Arb = a.PersonaID
                FROM #ArbSeed a
                WHERE a.Rol = @Rol AND a.PersonaID IS NOT NULL
                  AND NOT EXISTS (SELECT 1 FROM reglamento.SeDesignaArbitro d
                                  WHERE d.PartidoID = @P AND d.ArbitroID = a.PersonaID)
                  AND NOT EXISTS (SELECT 1 FROM torneo.Juega j
                                  JOIN torneo.Seleccion s ON s.SeleccionID = j.SeleccionID
                                  WHERE j.PartidoID = @P AND s.Pais = a.Pais)
                ORDER BY (a.Orden * 7 + @Nro * 5 + @Slot * 3) % 11, a.Orden;

            SET @Informe = CASE WHEN @Slot = 1 AND @HayExp > 0 THEN 'Informe postpartido: expulsion en el partido'
                                WHEN @Slot = 1 AND @HayAm > 0 THEN 'Informe postpartido: amonestaciones'
                                ELSE 'Sin observaciones' END;

            IF @Arb IS NULL
                PRINT 'AVISO: sin arbitro disponible para ' + @Rol + ' (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ')';
            ELSE
            BEGIN
                BEGIN TRY
                    EXEC reglamento.SP_DesignarArbitro_SinConflicto
                         @PartidoID = @P, @ArbitroID = @Arb, @Informe = @Informe, @RolArbitral = @Rol;
                END TRY
                BEGIN CATCH
                    PRINT 'ERROR designacion (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + ', ' + @Rol + '): ' + ERROR_MESSAGE();
                END CATCH
            END

            SET @Slot = @Slot + 1;
        END
    END

    FETCH NEXT FROM cArb INTO @Nro, @P, @Fase, @PaisForzado;
END

CLOSE cArb;
DEALLOCATE cArb;

SELECT f.Nro, f.PartidoID, COUNT(d.ArbitroID) AS Designados
FROM #Fixture f
LEFT JOIN reglamento.SeDesignaArbitro d ON d.PartidoID = f.PartidoID
WHERE f.PartidoID IS NOT NULL
GROUP BY f.Nro, f.PartidoID
HAVING COUNT(d.ArbitroID) <> 5;
GO

-- ========================================================
-- 13. ASIGNACION DE LAS 4 PIEZAS PUBLICITARIAS POR PARTIDO
-- ========================================================

PRINT '--- 13. Publicidad por partido ---';

DECLARE @P INT, @Nro INT;

DECLARE cPub CURSOR LOCAL STATIC READ_ONLY FOR
    SELECT Nro, PartidoID FROM #Fixture WHERE PartidoID IS NOT NULL ORDER BY Nro;

OPEN cPub;
FETCH NEXT FROM cPub INTO @Nro, @P;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM publicidad.CuentaConExhibicion WHERE PartidoID = @P)
    BEGIN
        BEGIN TRY
            EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID = @P;
        END TRY
        BEGIN CATCH
            PRINT 'ERROR publicidad (partido Nro ' + CAST(@Nro AS VARCHAR(5)) + '): ' + ERROR_MESSAGE();
        END CATCH
    END

    FETCH NEXT FROM cPub INTO @Nro, @P;
END

CLOSE cPub;
DEALLOCATE cPub;

SELECT f.Nro, f.PartidoID, COUNT(c.ExhibicionID) AS EspaciosOcupados
FROM #Fixture f
LEFT JOIN publicidad.CuentaConExhibicion c ON c.PartidoID = f.PartidoID
WHERE f.PartidoID IS NOT NULL
GROUP BY f.Nro, f.PartidoID
HAVING COUNT(c.ExhibicionID) <> 4;
GO

-- ================================================================
-- 14. DEMOSTRACIONES Y VERIFICACION DE LOS CRITERIOS DE ACEPTACION
-- ================================================================

PRINT '--- 14. Verificacion ---';

-- -------------------------------------------------------------------------------------
-- 14.1 CASO OBLIGATORIO: designacion arbitral descartada por conflicto de nacionalidad
-- -------------------------------------------------------------------------------------

DECLARE @PFinal INT = (SELECT PartidoID FROM #Fixture WHERE Nro = 32);
DECLARE @ArbAR INT = (SELECT PersonaID FROM #ArbSeed WHERE Pais = 'Argentina' AND Rol = 'Principal');

IF @PFinal IS NOT NULL AND @ArbAR IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_DesignarArbitro_SinConflicto
             @PartidoID = @PFinal, @ArbitroID = @ArbAR, @Informe = 'Designacion de prueba', @RolArbitral = 'Principal';
        PRINT 'FALLO: se permitio designar un arbitro con la misma nacionalidad que una de las selecciones.';
    END TRY
    BEGIN CATCH
        PRINT 'OK (esperado) - designacion descartada: ' + ERROR_MESSAGE();
    END CATCH
END

-- -------------------------------------------------------------
-- 14.2 CASO OBLIGATORIO: jugador suspendido no puede alinearse
-- -------------------------------------------------------------

DECLARE @FormMex INT, @PersMex INT;
SELECT TOP 1 @FormMex = tf.FormacionID
FROM torneo.TieneFormacion tf
JOIN torneo.Participa pa ON pa.FormacionID = tf.FormacionID
JOIN torneo.Jugador j ON j.PersonaID = pa.PersonaID
JOIN #EquipoPartido ep ON ep.PartidoID = tf.PartidoID AND ep.ConvocatoriaID = j.ConvocatoriaID
WHERE ep.Nro = 17 AND ep.Lado = 'L';

SELECT @PersMex = j.PersonaID
FROM torneo.Jugador j
JOIN #Equipo e ON e.ConvocatoriaID = j.ConvocatoriaID
WHERE e.Pais = 'México' AND j.Dorsal = 6;

IF @FormMex IS NOT NULL AND @PersMex IS NOT NULL
   AND EXISTS (SELECT 1 FROM reglamento.Suspension WHERE PersonaID = @PersMex AND PartidosSuspendido > 0)
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarAlineacion_Validada
             @FormacionID = @FormMex, @PersonaID = @PersMex, @Titular = 1, @PosicionCancha = 'Mediocampista Central';
        PRINT 'FALLO: se permitio alinear a un jugador suspendido.';
    END TRY
    BEGIN CATCH
        PRINT 'OK (esperado) - alineacion rechazada: ' + ERROR_MESSAGE();
    END CATCH
END
ELSE
    PRINT 'AVISO: no se pudo preparar la prueba 14.2 (revisar que existan la formacion del partido 17 y la suspension de Mexico dorsal 6).';
GO

-- ---------------------------
-- 14.3 Criterios de cantidad
-- ---------------------------

SELECT COUNT(*) AS Sedes, COUNT(DISTINCT HusoHorario) AS HusosDistintos FROM torneo.Sede;

SELECT COUNT(*) AS SeleccionesConAl23Convocados
FROM (SELECT e.Idx FROM #Equipo e JOIN torneo.Jugador j ON j.ConvocatoriaID = e.ConvocatoriaID
      GROUP BY e.Idx HAVING COUNT(*) >= 23) x;

SELECT COUNT(*) AS PartidosFixture,
       SUM(CASE WHEN x.Formaciones = 2 THEN 1 ELSE 0 END) AS ConDosFormaciones
FROM (SELECT f.PartidoID,
             (SELECT COUNT(*) FROM torneo.TieneFormacion tf WHERE tf.PartidoID = f.PartidoID) AS Formaciones
      FROM #Fixture f) x;

SELECT COUNT(*) AS ArbitrosSeed FROM #ArbSeed s WHERE EXISTS (SELECT 1 FROM reglamento.Arbitro a WHERE a.PersonaID = s.PersonaID);

SELECT COUNT(DISTINCT Pais) AS PaisesAnunciantes FROM publicidad.Anunciante;
GO

-- ------------------------
-- 14.4 Casos obligatorios
-- ------------------------

-- (a) Expulsion por DOBLE AMARILLA
SELECT ta.PartidoID, p.Nombre, p.Apellido, COUNT(*) AS Amarillas, 'Doble amarilla' AS Tipo
FROM reglamento.TarjetaAsignada ta
JOIN reglamento.Tarjeta t ON t.TarjetaID = ta.TarjetaID AND t.Tipo = 'Amarilla'
JOIN torneo.Persona p ON p.PersonaID = ta.PersonaID
GROUP BY ta.PartidoID, ta.PersonaID, p.Nombre, p.Apellido
HAVING COUNT(*) = 2
   AND EXISTS (SELECT 1 FROM reglamento.Suspension s WHERE s.PersonaID = ta.PersonaID AND s.Motivo LIKE '%doble amarilla%');

-- (b) Expulsion por ROJA DIRECTA
SELECT ta.PartidoID, p.Nombre, p.Apellido, ta.Minuto, ta.Motivo
FROM reglamento.TarjetaAsignada ta
JOIN reglamento.Tarjeta t ON t.TarjetaID = ta.TarjetaID AND t.Tipo = 'Roja'
JOIN torneo.Persona p ON p.PersonaID = ta.PersonaID
WHERE ta.PartidoID IN (SELECT PartidoID FROM #Fixture)
ORDER BY ta.PartidoID;

-- (c) Suspendido por ACUMULACION y fuera de la titular del siguiente partido.
SELECT p.Nombre, p.Apellido, s.Motivo, s.PartidosSuspendido,
       (SELECT COUNT(*) FROM torneo.Participa pa
        JOIN torneo.TieneFormacion tf ON tf.FormacionID = pa.FormacionID
        JOIN #Fixture f ON f.PartidoID = tf.PartidoID AND f.Nro = 17
        WHERE pa.PersonaID = j.PersonaID) AS JuegaPartido17
FROM reglamento.Suspension s
JOIN torneo.Jugador j ON j.PersonaID = s.PersonaID
JOIN #Equipo e ON e.ConvocatoriaID = j.ConvocatoriaID AND e.Pais = 'México' AND j.Dorsal = 6
JOIN torneo.Persona p ON p.PersonaID = j.PersonaID
WHERE s.Motivo LIKE 'Acumulaci%';

-- (d) Cambio por LESION en los primeros 20 minutos
SELECT su.PartidoID, su.Minuto, su.NumeroVentana, su.Motivo
FROM torneo.Sustitucion su
WHERE su.Motivo = 'Lesion' AND su.Minuto <= 20
  AND su.PartidoID IN (SELECT PartidoID FROM #Fixture);

-- (e) Partido en PRIME TIME en MAS DE 4 mercados.
SELECT f.Nro, f.EqLocal, f.EqVisita, f.UTC,
       COUNT(*) AS MercadosEnPrimeTime
FROM #Fixture f
JOIN torneo.Pais pa ON DATEPART(HOUR, DATEADD(HOUR, ISNULL(TRY_CAST(REPLACE(pa.HusoHorario, 'UTC', '') AS INT), 0), f.UTC)) BETWEEN 19 AND 23
GROUP BY f.Nro, f.EqLocal, f.EqVisita, f.UTC
HAVING COUNT(*) > 4
ORDER BY f.Nro;

-- (f) Piezas elegidas para uno de esos partidos 
SELECT f.Nro, ex.Espacio, an.Pais AS PaisAnunciante, ca.Nombre AS Campaña, pz.Idioma, ex.Costo
FROM #Fixture f
JOIN publicidad.CuentaConExhibicion cc ON cc.PartidoID = f.PartidoID
JOIN publicidad.Exhibicion ex ON ex.ExhibicionID = cc.ExhibicionID
JOIN publicidad.PiezaPublicitaria pz ON pz.PiezaID = ex.PiezaID
JOIN publicidad.Campaña ca ON ca.CampañaID = pz.CampañaID
JOIN publicidad.Anunciante an ON an.AnuncianteID = ca.AnuncianteID
WHERE f.Nro = 2
ORDER BY ex.Espacio;

GO

-- ---------------------------------------------------------------------
-- 14.5 Vista previa de los datos para los reportes de la Entrega 7
-- ---------------------------------------------------------------------

-- Top 10 goleadores del torneo
SELECT TOP 10 p.Nombre, p.Apellido, s.Pais AS Seleccion, COUNT(*) AS Goles
FROM torneo.Gol g
JOIN torneo.Persona p ON p.PersonaID = g.PersonaID
JOIN torneo.Jugador j ON j.PersonaID = g.PersonaID
JOIN torneo.Convocatoria c ON c.ConvocatoriaID = j.ConvocatoriaID
JOIN torneo.Seleccion s ON s.SeleccionID = c.SeleccionID
WHERE g.PartidoID IN (SELECT PartidoID FROM #Fixture)
GROUP BY p.Nombre, p.Apellido, s.Pais
ORDER BY COUNT(*) DESC, p.Apellido;

-- Ingresos estimados por publicidad por sede 
SELECT se.NombreEstadio, COUNT(DISTINCT pa.PartidoID) AS Partidos, SUM(ex.Costo) AS Ingresos
FROM #Fixture f
JOIN torneo.Partido pa ON pa.PartidoID = f.PartidoID
JOIN torneo.Sede se ON se.SedeID = pa.SedeID
JOIN publicidad.CuentaConExhibicion cc ON cc.PartidoID = pa.PartidoID
JOIN publicidad.Exhibicion ex ON ex.ExhibicionID = cc.ExhibicionID
GROUP BY se.NombreEstadio
ORDER BY Ingresos DESC;

PRINT '--- Carga de datos finalizada ---';
GO
