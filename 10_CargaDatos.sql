
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
    (N'Qatar', 81900.00, 'UTC+3'),
    (N'China', 12600.00, 'UTC+8'),
    (N'Australia', 65000.00, 'UTC+10');

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
    Huso          VARCHAR(50)  COLLATE DATABASE_DEFAULT NOT NULL
);
INSERT INTO #SedeSeed (NombreEstadio, Ciudad, Pais, Capacidad, Huso) VALUES
    (N'Estadio Azteca', N'Ciudad de Mexico', N'México', 83264, 'UTC-6'),
    (N'MetLife Stadium', N'Nueva York', N'Estados Unidos', 82500, 'UTC-4'),
    (N'SoFi Stadium', N'Los Angeles', N'Estados Unidos', 70240, 'UTC-7'),
    (N'AT&T Stadium', N'Dallas', N'Estados Unidos', 94000, 'UTC-5'),
    (N'Mercedes-Benz Stadium', N'Atlanta', N'Estados Unidos', 71000, 'UTC-4'),
    (N'Hard Rock Stadium', N'Miami', N'Estados Unidos', 64767, 'UTC-4'),
    (N'BMO Field', N'Toronto', N'Canadá', 45000, 'UTC-4'),
    (N'BC Place', N'Vancouver', N'Canadá', 54500, 'UTC-7'),
    (N'Estadio BBVA', N'Monterrey', N'México', 53500, 'UTC-6'),
    (N'Estadio Akron', N'Guadalajara', N'México', 48071, 'UTC-6'),
    (N'Lumen Field', N'Seattle', N'Estados Unidos', 69000, 'UTC-7'),
    (N'NRG Stadium', N'Houston', N'Estados Unidos', 72220, 'UTC-5');

INSERT INTO torneo.Sede (NombreEstadio, Ciudad, Pais, Capacidad, HusoHorario)
SELECT s.NombreEstadio, s.Ciudad, s.Pais, s.Capacidad, s.Huso
FROM #SedeSeed s
WHERE NOT EXISTS (SELECT 1 FROM torneo.Sede x WHERE x.NombreEstadio = s.NombreEstadio);

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
    (2, N'Argentina', 'CONMEBOL', 'A'),
    (3, N'Marruecos', 'CAF', 'A'),
    (4, N'Japón', 'AFC', 'A'),
    (5, N'Estados Unidos', 'CONCACAF', 'B'),
    (6, N'Brasil', 'CONMEBOL', 'B'),
    (7, N'Senegal', 'CAF', 'B'),
    (8, N'Corea del Sur', 'AFC', 'B'),
    (9, N'Canadá', 'CONCACAF', 'C'),
    (10, N'España', 'UEFA', 'C'),
    (11, N'Uruguay', 'CONMEBOL', 'C'),
    (12, N'Portugal', 'UEFA', 'C'),
    (13, N'Francia', 'UEFA', 'D'),
    (14, N'Alemania', 'UEFA', 'D'),
    (15, N'Inglaterra', 'UEFA', 'D'),
    (16, N'Colombia', 'CONMEBOL', 'D');

INSERT INTO torneo.Seleccion (Pais, Confederacion)
SELECT e.Pais, e.Confederacion
FROM #Equipo e
WHERE NOT EXISTS (SELECT 1 FROM torneo.Seleccion s WHERE s.Pais = e.Pais);

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
    ('T', 16, 32, N'Bruno', N'Sosa', '19680921', NULL, NULL, N'Asistente');

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
-- 6. FIXTURE: 32 PARTIDOS 
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
    (1, N'Fase de Grupos', N'Estadio Azteca', N'México', N'Argentina', '20260611 19:00', 1, 2, 81598, NULL),
    (2, N'Fase de Grupos', N'Estadio BBVA', N'Marruecos', N'Japón', '20260611 22:00', 1, 1, 51895, NULL),
    (3, N'Fase de Grupos', N'SoFi Stadium', N'Estados Unidos', N'Brasil', '20260612 19:00', 1, 3, 67430, NULL),
    (4, N'Fase de Grupos', N'MetLife Stadium', N'Senegal', N'Corea del Sur', '20260612 22:00', 2, 2, 78375, NULL),
    (5, N'Fase de Grupos', N'BMO Field', N'Canadá', N'España', '20260613 16:00', 0, 2, 42300, NULL),
    (6, N'Fase de Grupos', N'NRG Stadium', N'Uruguay', N'Portugal', '20260613 22:00', 1, 1, 67164, NULL),
    (7, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Francia', N'Alemania', '20260614 19:00', 2, 2, 65320, NULL),
    (8, N'Fase de Grupos', N'Hard Rock Stadium', N'Inglaterra', N'Colombia', '20260615 01:00', 3, 0, 58937, NULL),
    (9, N'Fase de Grupos', N'Estadio Akron', N'México', N'Marruecos', '20260617 19:00', 1, 0, 43263, NULL),
    (10, N'Fase de Grupos', N'AT&T Stadium', N'Argentina', N'Japón', '20260617 22:00', 3, 1, 83660, NULL),
    (11, N'Fase de Grupos', N'Lumen Field', N'Estados Unidos', N'Senegal', '20260618 19:00', 2, 1, 60720, NULL),
    (12, N'Fase de Grupos', N'SoFi Stadium', N'Brasil', N'Corea del Sur', '20260619 01:00', 2, 0, 61108, NULL),
    (13, N'Fase de Grupos', N'BC Place', N'Canadá', N'Uruguay', '20260619 19:00', 0, 1, 46870, NULL),
    (14, N'Fase de Grupos', N'NRG Stadium', N'España', N'Portugal', '20260619 22:00', 0, 1, 61387, NULL),
    (15, N'Fase de Grupos', N'MetLife Stadium', N'Francia', N'Inglaterra', '20260620 19:00', 1, 0, 69300, NULL),
    (16, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Alemania', N'Colombia', '20260620 22:00', 4, 1, 58930, NULL),
    (17, N'Fase de Grupos', N'Estadio Azteca', N'México', N'Japón', '20260624 01:00', 2, 0, 68276, NULL),
    (18, N'Fase de Grupos', N'Estadio Akron', N'Argentina', N'Marruecos', '20260624 01:00', 1, 1, 38937, NULL),
    (19, N'Fase de Grupos', N'SoFi Stadium', N'Estados Unidos', N'Corea del Sur', '20260625 01:00', 0, 0, 56192, NULL),
    (20, N'Fase de Grupos', N'MetLife Stadium', N'Brasil', N'Senegal', '20260625 01:00', 1, 1, 80850, NULL),
    (21, N'Fase de Grupos', N'BMO Field', N'Canadá', N'Portugal', '20260626 22:00', 1, 3, 43650, NULL),
    (22, N'Fase de Grupos', N'NRG Stadium', N'España', N'Uruguay', '20260626 22:00', 1, 1, 69331, NULL),
    (23, N'Fase de Grupos', N'Mercedes-Benz Stadium', N'Francia', N'Colombia', '20260627 22:00', 2, 1, 67450, NULL),
    (24, N'Fase de Grupos', N'Hard Rock Stadium', N'Alemania', N'Inglaterra', '20260627 22:00', 0, 1, 60880, NULL),
    (25, N'Cuartos', N'AT&T Stadium', N'Argentina', N'Estados Unidos', '20260709 19:00', 3, 1, 87420, NULL),
    (26, N'Cuartos', N'SoFi Stadium', N'Brasil', N'México', '20260710 22:00', 3, 2, 64620, NULL),
    (27, N'Cuartos', N'Hard Rock Stadium', N'Portugal', N'Inglaterra', '20260711 16:00', 0, 1, 58937, N'Francia'),
    (28, N'Cuartos', N'Mercedes-Benz Stadium', N'Francia', N'Uruguay', '20260711 22:00', 2, 0, 63900, NULL),
    (29, N'Semifinal', N'AT&T Stadium', N'Argentina', N'Inglaterra', '20260714 19:00', 2, 1, 83660, NULL),
    (30, N'Semifinal', N'Mercedes-Benz Stadium', N'Brasil', N'Francia', '20260715 19:00', 1, 2, 62480, NULL),
    (31, N'Tercer Puesto', N'Hard Rock Stadium', N'Brasil', N'Inglaterra', '20260718 21:00', 2, 1, 56347, NULL),
    (32, N'Final', N'MetLife Stadium', N'Argentina', N'Francia', '20260719 19:00', 3, 2, 70950, NULL);

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
    (1, 'L', 6, 'Amarilla', 34, N'Falta tactica', 0),
    (1, 'V', 4, 'Amarilla', 71, N'Juego brusco', 0),
    (2, 'L', 3, 'Amarilla', 55, N'Protestas', 0),
    (2, 'V', 8, 'Amarilla', 80, N'Demora de juego', 0),
    (3, 'V', 2, 'Amarilla', 40, N'Falta tactica', 0),
    (4, 'L', 4, 'Amarilla', 62, N'Juego brusco', 0),
    (4, 'V', 6, 'Amarilla', 88, N'Falta tactica', 0),
    (5, 'L', 2, 'Amarilla', 29, N'Mano deliberada', 0),
    (5, 'V', 8, 'Amarilla', 74, N'Protestas', 0),
    (6, 'L', 3, 'Amarilla', 51, N'Juego brusco', 0),
    (6, 'V', 6, 'Amarilla', 66, N'Falta tactica', 0),
    (7, 'L', 8, 'Amarilla', 37, N'Falta tactica', 0),
    (7, 'V', 2, 'Amarilla', 59, N'Juego brusco', 0),
    (8, 'L', 2, 'Amarilla', 30, N'Protestas', 0),
    (8, 'V', 4, 'Amarilla', 25, N'Falta tactica', 0),
    (8, 'V', 4, 'Amarilla', 68, N'Mano deliberada (doble amarilla)', 1),
    (9, 'L', 6, 'Amarilla', 61, N'Juego brusco (acumulacion)', 1),
    (9, 'V', 2, 'Amarilla', 77, N'Demora de juego', 0),
    (10, 'L', 3, 'Amarilla', 49, N'Falta tactica', 0),
    (10, 'V', 4, 'Amarilla', 83, N'Juego brusco', 0),
    (11, 'L', 8, 'Amarilla', 33, N'Protestas', 0),
    (11, 'V', 3, 'Amarilla', 85, N'Falta tactica', 0),
    (12, 'L', 3, 'Amarilla', 20, N'Falta tactica', 0),
    (12, 'V', 4, 'Roja', 77, N'Juego brusco grave (roja directa)', 2),
    (13, 'L', 6, 'Amarilla', 44, N'Protestas', 0),
    (13, 'V', 2, 'Amarilla', 70, N'Falta tactica', 0),
    (14, 'L', 4, 'Amarilla', 58, N'Juego brusco', 0),
    (14, 'V', 3, 'Amarilla', 64, N'Mano deliberada', 0),
    (15, 'L', 3, 'Amarilla', 32, N'Falta tactica', 0),
    (15, 'V', 6, 'Amarilla', 79, N'Protestas', 0),
    (16, 'L', 4, 'Amarilla', 52, N'Juego brusco', 0),
    (16, 'V', 3, 'Amarilla', 67, N'Falta tactica', 0),
    (17, 'L', 3, 'Amarilla', 36, N'Falta tactica', 0),
    (17, 'V', 3, 'Amarilla', 75, N'Demora de juego', 0),
    (18, 'L', 2, 'Amarilla', 55, N'Juego brusco', 0),
    (18, 'V', 4, 'Amarilla', 62, N'Protestas', 0),
    (19, 'L', 4, 'Amarilla', 40, N'Falta tactica', 0),
    (19, 'V', 3, 'Amarilla', 71, N'Juego brusco', 0),
    (20, 'L', 8, 'Amarilla', 60, N'Falta tactica', 0),
    (20, 'V', 2, 'Amarilla', 84, N'Protestas', 0),
    (21, 'L', 3, 'Amarilla', 47, N'Juego brusco', 0),
    (21, 'V', 8, 'Amarilla', 73, N'Falta tactica', 0),
    (22, 'L', 2, 'Amarilla', 39, N'Protestas', 0),
    (22, 'V', 4, 'Amarilla', 68, N'Juego brusco', 0),
    (23, 'L', 4, 'Amarilla', 56, N'Falta tactica', 0),
    (23, 'V', 2, 'Amarilla', 81, N'Demora de juego', 0),
    (24, 'L', 8, 'Amarilla', 43, N'Juego brusco', 0),
    (24, 'V', 3, 'Amarilla', 88, N'Falta tactica', 0),
    (25, 'L', 8, 'Amarilla', 52, N'Falta tactica', 0),
    (25, 'V', 6, 'Amarilla', 70, N'Protestas', 0),
    (26, 'L', 4, 'Amarilla', 61, N'Juego brusco', 0),
    (26, 'V', 4, 'Amarilla', 74, N'Falta tactica', 0),
    (27, 'L', 2, 'Amarilla', 35, N'Falta tactica', 0),
    (27, 'V', 4, 'Amarilla', 66, N'Juego brusco', 0),
    (28, 'L', 6, 'Amarilla', 49, N'Protestas', 0),
    (28, 'V', 6, 'Roja', 82, N'Agresion (roja directa)', 2),
    (29, 'L', 6, 'Amarilla', 58, N'Falta tactica', 0),
    (29, 'V', 8, 'Amarilla', 74, N'Juego brusco', 0),
    (30, 'L', 6, 'Amarilla', 50, N'Protestas', 0),
    (30, 'V', 2, 'Amarilla', 60, N'Falta tactica', 0);

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
    (26, 'L', 3, 108, N'Alargue', N'Jugada'),
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