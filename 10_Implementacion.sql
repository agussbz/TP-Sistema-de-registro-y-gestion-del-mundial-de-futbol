
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Probar paso a paso el funcionamiento de la DB

USE DB_Mundial_2026;
SET NOCOUNT ON;
-- Paso 1: Muestro las tablas vacias

--==============================
-- Tablas del esquema TORNEO
--==============================

SELECT * FROM Torneo.Sede;
SELECT * FROM Torneo.Partido;
SELECT * FROM Torneo.Seleccion;
SELECT * FROM Torneo.Juega;
SELECT * FROM Torneo.Convocatoria;
SELECT * FROM Torneo.Persona;
SELECT * FROM Torneo.CuerpoTecnico;
SELECT * FROM Torneo.Jugador;
SELECT * FROM Torneo.Formacion;
SELECT * FROM Torneo.TieneFormacion;
SELECT * FROM Torneo.Participa;
SELECT * FROM Torneo.Gol;
SELECT * FROM Torneo.Sustitucion;
SELECT * FROM Torneo.Pais;
SELECT * FROM Torneo.Idioma;
SELECT * FROM Torneo.PersonaHabla;
GO

--==============================
-- Tablas del esquema REGLAMENTO
--==============================

SELECT * FROM Reglamento.Arbitro;
SELECT * FROM Reglamento.Tarjeta;
SELECT * FROM Reglamento.Sancion;
SELECT * FROM Reglamento.SeDesignaArbitro;
SELECT * FROM Reglamento.Suspension;
SELECT * FROM Reglamento.TarjetaAsignada;
GO

--==============================
-- Tablas del esquema PUBLICIDAD
--==============================

SELECT * FROM Publicidad.Anunciante;
SELECT * FROM Publicidad.Campaña;
SELECT * FROM Publicidad.PiezaPublicitaria;
SELECT * FROM Publicidad.InteresPublicitario;
SELECT * FROM Publicidad.Exhibicion;
SELECT * FROM Publicidad.CuentaConExhibicion;
GO

-- Paso 2: cargo datos validos a las tablas

-- =============================================================
-- SEDE
-- =============================================================
EXEC torneo.SP_Alta_Sede 'Estadio Azteca', 'Ciudad de Mexico', 'Mexico', 87523, 'UTC-6';
EXEC torneo.SP_Alta_Sede 'MetLife Stadium', 'East Rutherford', 'Estados Unidos', 82500, 'UTC-4';
EXEC torneo.SP_Alta_Sede 'BMO Field', 'Toronto', 'Canada', 45000, 'UTC-4';
GO

-- =============================================================
-- SELECCION
-- =============================================================
EXEC torneo.SP_Alta_Seleccion 'Mexico', 'CONCACAF';
EXEC torneo.SP_Alta_Seleccion 'Argentina', 'CONMEBOL';
EXEC torneo.SP_Alta_Seleccion 'Canada', 'CONCACAF';
EXEC torneo.SP_Alta_Seleccion 'España', 'UEFA';
GO

-- =============================================================
-- IDIOMA, PAIS y TARJETA
-- =============================================================
EXEC torneo.SP_Alta_Idioma 'Español';
EXEC torneo.SP_Alta_Idioma 'Inglés';
EXEC torneo.SP_Alta_Idioma 'Francés';
GO

EXEC torneo.SP_Alta_Pais 'Mexico', 1300.00, 'UTC-6';
EXEC torneo.SP_Alta_Pais 'Argentina', 640.00, 'UTC-3';
EXEC torneo.SP_Alta_Pais 'Canada', 2100.00, 'UTC-4';
GO

EXEC reglamento.SP_Alta_Tarjeta 'Amarilla';
EXEC reglamento.SP_Alta_Tarjeta 'Roja';
GO

-- =============================================================
-- PERSONAS
-- =============================================================
EXEC torneo.SP_Alta_Persona 'Guillermo', 'Ochoa', '1985-07-13'; -- PersonaID 1
EXEC torneo.SP_Alta_Persona 'Lionel', 'Messi', '1987-06-24';    -- PersonaID 2
EXEC torneo.SP_Alta_Persona 'Emiliano', 'Martinez', '1992-09-02'; -- PersonaID 3
EXEC torneo.SP_Alta_Persona 'Javier', 'Aguirre', '1958-12-01';  -- PersonaID 4
EXEC torneo.SP_Alta_Persona 'Cesar', 'Ramos', '1983-12-15';     -- PersonaID 5, arbitro
EXEC torneo.SP_Alta_Persona 'Julian', 'Alvarez', '2000-01-31';  -- PersonaID 6
EXEC torneo.SP_Alta_Persona 'Lautaro', 'Martinez', '1997-08-22'; -- PersonaID 7
EXEC torneo.SP_Alta_Persona 'Alphonso', 'Davies', '2000-11-02'; -- PersonaID 8
EXEC torneo.SP_Alta_Persona 'John', 'Herdman', '1975-07-19';    -- PersonaID 9
EXEC torneo.SP_Alta_Persona 'Persona', 'De Prueba Baja', '1990-01-01'; -- PersonaID 10, registro aislado
GO

-- =============================================================
-- ANUNCIANTES
-- =============================================================
EXEC publicidad.SP_Alta_Anunciante 'Mexico';
EXEC publicidad.SP_Alta_Anunciante 'Argentina';
EXEC publicidad.SP_Alta_Anunciante 'Canada';
GO

-- =============================================================
-- CONVOCATORIAS y CUERPO TECNICO
-- =============================================================
EXEC torneo.SP_Alta_Convocatoria 1; -- ConvocatoriaID 1
EXEC torneo.SP_Alta_Convocatoria 2; -- ConvocatoriaID 2
EXEC torneo.SP_Alta_Convocatoria 3; -- ConvocatoriaID 3
GO

EXEC torneo.SP_Alta_CuerpoTecnico 4, 1, 'Entrenador';
EXEC torneo.SP_Alta_CuerpoTecnico 9, 3, 'Entrenador';
GO

-- =============================================================
-- JUGADORES
-- =============================================================
EXEC torneo.SP_Alta_Jugador 1, 'Club America', 1, 'Arquero', 1;
EXEC torneo.SP_Alta_Jugador 2, 'Inter Miami', 10, 'Delantero', 2;
EXEC torneo.SP_Alta_Jugador 3, 'Aston Villa', 23, 'Arquero', 2;
EXEC torneo.SP_Alta_Jugador 6, 'Atletico Madrid', 9, 'Delantero', 2;
EXEC torneo.SP_Alta_Jugador 7, 'Inter', 22, 'Delantero', 2;
EXEC torneo.SP_Alta_Jugador 8, 'Bayern Munich', 19, 'Defensor', 3;
GO

-- =========================================================
-- ARBITRO y SANCION
-- ========================================================= */
EXEC reglamento.SP_Alta_Arbitro 5, 'Mexico', 'Central';
EXEC reglamento.SP_Alta_Sancion 'Conducta antideportiva', 5;
GO

-- =============================================================
-- PARTIDOS
-- =============================================================
EXEC torneo.SP_Alta_Partido 1, 'Fase de grupos', 80000, '1-0', '2026-06-11T18:00:00', '2026-06-12T00:00:00';
EXEC torneo.SP_Alta_Partido 2, 'Fase de grupos', 79000, '2-1', '2026-06-12T20:00:00', '2026-06-13T00:00:00';
EXEC torneo.SP_Alta_Partido 3, 'Fase de grupos', 42000, '0-0', '2026-06-13T16:00:00', '2026-06-13T20:00:00';
GO

-- =============================================================
-- RELACIONES DE PARTIDOS, FORMACIONES y PARTICIPACION
-- =============================================================
EXEC torneo.SP_Alta_Juega 1, 1;
EXEC torneo.SP_Alta_Juega 1, 2;
EXEC torneo.SP_Alta_Juega 2, 2;
EXEC torneo.SP_Alta_Juega 2, 4;
EXEC torneo.SP_Alta_Juega 3, 3;
EXEC torneo.SP_Alta_Juega 3, 1;
GO

EXEC torneo.SP_Alta_Formacion '4-3-3'; -- FormacionID 1
EXEC torneo.SP_Alta_Formacion '4-4-2'; -- FormacionID 2
EXEC torneo.SP_Alta_Formacion '4-2-3-1'; -- FormacionID 3
GO

EXEC torneo.SP_Alta_TieneFormacion 1, 1;
EXEC torneo.SP_Alta_TieneFormacion 2, 2;
EXEC torneo.SP_Alta_TieneFormacion 3, 3;
GO

EXEC torneo.SP_Alta_Participa 1, 2, 1, 'Delantero';
EXEC torneo.SP_Alta_Participa 1, 6, 1, 'Delantero';
EXEC torneo.SP_Alta_Participa 1, 7, 1, 'Delantero';
EXEC torneo.SP_Alta_Participa 2, 3, 1, 'Arquero';
EXEC torneo.SP_Alta_Participa 3, 8, 1, 'Defensor';
GO

-- =============================================================
-- IDIOMAS HABLADOS
-- =============================================================
EXEC torneo.SP_Alta_PersonaHabla 1, 1;
EXEC torneo.SP_Alta_PersonaHabla 2, 1;
EXEC torneo.SP_Alta_PersonaHabla 5, 2;
EXEC torneo.SP_Alta_PersonaHabla 8, 2;
GO

-- =============================================================
-- GOLES, SUSTITUCIONES, TARJETAS y SUSPENSIONES
-- =============================================================
EXEC torneo.SP_Alta_Gol 1, 2, 6, 'Segundo tiempo', 'Jugada', 65;
EXEC torneo.SP_Alta_Gol 2, 6, 2, 'Primer tiempo', 'Jugada', 28;
GO

EXEC torneo.SP_Alta_Sustitucion 1, 7, 6, 1, 70, 'Tactico';
EXEC torneo.SP_Alta_Sustitucion 2, 6, 7, 2, 80, 'Precaucion';
GO

EXEC reglamento.SP_Alta_TarjetaAsignada 1, 1, 2, 35, 'Falta táctica';
EXEC reglamento.SP_Alta_TarjetaAsignada 2, 2, 6, 75, 'Conducta antideportiva';
GO

EXEC reglamento.SP_Alta_Suspension 7, 'Acumulación de tarjetas', 1;
GO

-- =============================================================
-- PUBLICIDAD: campañas, piezas, intereses y exhibiciones
-- =============================================================
EXEC publicidad.SP_Alta_Campaña 'Campaña Mexico', '2026-01-15', 1;
EXEC publicidad.SP_Alta_Campaña 'Campaña Argentina', '2026-02-01', 2;
EXEC publicidad.SP_Alta_Campaña 'Campaña Canada', '2026-02-15', 3;
GO

EXEC publicidad.SP_Alta_PiezaPublicitaria 'Bebida deportiva', 25000.00, 'Español', 1;
EXEC publicidad.SP_Alta_PiezaPublicitaria 'Tecnologia oficial', 35000.00, 'Inglés', 2;
EXEC publicidad.SP_Alta_PiezaPublicitaria 'Turismo Canada', 18000.00, 'Francés', 3;
GO

EXEC publicidad.SP_Alta_InteresPublicitario 1, 1, 'Alta';
EXEC publicidad.SP_Alta_InteresPublicitario 2, 2, 'Media';
EXEC publicidad.SP_Alta_InteresPublicitario 3, 3, 'Alta';
GO

EXEC publicidad.SP_Alta_Exhibicion 'Cartel lateral', 1, 5000;
EXEC publicidad.SP_Alta_Exhibicion 'Pantalla central', 2, 8000;
EXEC publicidad.SP_Alta_Exhibicion 'Panel de prensa', 3, 3000;
GO

EXEC publicidad.SP_Alta_CuentaConExhibicion 1, 1;
EXEC publicidad.SP_Alta_CuentaConExhibicion 2, 2;
EXEC publicidad.SP_Alta_CuentaConExhibicion 3, 3;
GO

-- =============================================================
-- DESIGNACION DE ARBITROS
-- =============================================================
EXEC reglamento.SP_Alta_SeDesignaArbitro 1, 5, 'Sin observaciones', 'Central';
EXEC reglamento.SP_Alta_SeDesignaArbitro 2, 5, 'Buen desempeño', 'Central';
GO

-- =============================================================
-- MODIFICACIONES EXITOSAS
-- Se modifica un registro existente de cada tipo que tiene SP
-- de modificación. Se usan valores válidos y no duplicados.
-- =============================================================
EXEC torneo.SP_Modificacion_Sede 1, 'Estadio Azteca', 'Ciudad de Mexico', 'Mexico', 87524, 'UTC-6';
EXEC torneo.SP_Modificacion_Seleccion 1, 'Mexico', 'CONCACAF';
EXEC reglamento.SP_Modificacion_Sancion 1, 'Conducta antideportiva revisada', 5;
EXEC torneo.SP_Modificacion_Partido 1, 1, 'Fase de grupos', 80001, '1-0', '2026-06-11T18:00:00', '2026-06-12T00:00:00';
EXEC torneo.SP_Modificacion_Participa 1, 2, 1, 'Delantero centro';
EXEC reglamento.SP_Modificacion_Suspension 1, 'Acumulación de tarjetas revisada', 2;
EXEC torneo.SP_Modificacion_Idioma 1, 'Español';
EXEC publicidad.SP_Modificacion_Anunciante 1, 'Mexico';
EXEC reglamento.SP_Modificacion_Arbitro 5, 'Mexico', 'Central';
EXEC publicidad.SP_Modificacion_InteresPublicitario 1, 1, 1, 'Muy alta';
EXEC torneo.SP_Modificacion_Gol 1, 1, 2, 6, 'Segundo tiempo', 'Jugada', 66;
EXEC reglamento.SP_Modificacion_TarjetaAsignada 1, 1, 1, 2, 36, 'Falta táctica';
EXEC torneo.SP_Modificacion_Pais 1, 'Mexico', 1300.00, 'UTC-6';
EXEC reglamento.SP_Modificacion_Tarjeta 1, 'Amarilla';
EXEC torneo.SP_Modificacion_Convocatoria 1, 1;
EXEC torneo.SP_Modificacion_CuerpoTecnico 4, 2, 1, 'Asistente tecnico';
EXEC publicidad.SP_Modificacion_Campaña 1, 'Campaña Mexico actualizada', '2026-01-20', 1;
EXEC torneo.SP_Modificacion_Sustitucion 1, 1, 7, 6, 1, 71, 'Tactico';
EXEC torneo.SP_Modificacion_Persona 10, 'Persona', 'De Prueba Modificada', '1990-01-01';
EXEC torneo.SP_Modificacion_Formacion 1, '4-3-3 ofensivo';
EXEC torneo.SP_Modificacion_Jugador 2, 'Inter Miami', 10, 'Delantero', 2;
EXEC torneo.SP_Modificacion_TieneFormacion 1, 1, 1, 1;
EXEC publicidad.SP_Modificacion_PiezaPublicitaria 1, 'Bebida deportiva actualizada', 26000.00, 'Español', 1;
EXEC reglamento.SP_Modificacion_SeDesignaArbitro 1, 5, 'Informe actualizado', 'Central';
EXEC publicidad.SP_Modificacion_Exhibicion 1, 'Cartel lateral actualizado', 1, 5500;
GO

-- =============================================================
-- BAJAS EXITOSAS DE REGISTROS AISLADOS
-- Se ejecutan al final para no romper dependencias de los datos
-- principales. Se usan registros que no tienen referencias.
-- =============================================================
EXEC torneo.SP_Alta_Sede 'Sede temporal para baja', 'Ciudad de prueba', 'Canada', 1000, 'UTC-4';
EXEC torneo.SP_Baja_Sede 4;
GO



-- Paso 3: consultas de ejemplo

-- Jugadores que recibieron tarjetas amarillas
SELECT per.Nombre, per.Apellido, s.Pais AS Seleccion, ta.Minuto, ta.Motivo, p.PartidoID
FROM reglamento.TarjetaAsignada ta
INNER JOIN reglamento.Tarjeta t
    ON ta.TarjetaID = t.TarjetaID
INNER JOIN torneo.Jugador j
    ON ta.PersonaID = j.PersonaID
INNER JOIN torneo.Persona per
    ON j.PersonaID = per.PersonaID
INNER JOIN torneo.Convocatoria c
    ON j.ConvocatoriaID = c.ConvocatoriaID
INNER JOIN torneo.Seleccion s
    ON c.SeleccionID = s.SeleccionID
INNER JOIN torneo.Partido p
    ON ta.PartidoID = p.PartidoID
WHERE t.Tipo = 'Amarilla'
ORDER BY p.PartidoID, ta.Minuto;

-- Jugadores que hicieron goles
SELECT per.Nombre, per.Apellido, s.Pais AS Seleccion, g.Minuto, g.Periodo, g.Tipo, p.ResultadoFinal
FROM torneo.Gol g
INNER JOIN torneo.Jugador j
    ON g.PersonaID = j.PersonaID
INNER JOIN torneo.Persona per
    ON j.PersonaID = per.PersonaID
INNER JOIN torneo.Convocatoria c
    ON j.ConvocatoriaID = c.ConvocatoriaID
INNER JOIN torneo.Seleccion s
    ON c.SeleccionID = s.SeleccionID
INNER JOIN torneo.Partido p
    ON g.PartidoID = p.PartidoID
ORDER BY p.PartidoID, g.Minuto;


-- Partidos con sus selecciones y sede
SELECT p.PartidoID, s1.Pais AS SeleccionLocal, s2.Pais AS SeleccionVisitante, p.ResultadoFinal, p.Fase, se.NombreEstadio, se.Ciudad
FROM torneo.Partido p
INNER JOIN torneo.Juega j1
    ON p.PartidoID = j1.PartidoID
INNER JOIN torneo.Juega j2
    ON p.PartidoID = j2.PartidoID
   AND j1.SeleccionID < j2.SeleccionID
INNER JOIN torneo.Seleccion s1
    ON j1.SeleccionID = s1.SeleccionID
INNER JOIN torneo.Seleccion s2
    ON j2.SeleccionID = s2.SeleccionID
INNER JOIN torneo.Sede se
    ON p.SedeID = se.SedeID
ORDER BY p.PartidoID;



-- Publicidad exhibida en cada partido
SELECT p.PartidoID, se.NombreEstadio, ex.Espacio, pp.Contenido, ca.Nombre AS Campaña, a.Pais AS PaisAnunciante, ex.Costo
FROM publicidad.CuentaConExhibicion ce
INNER JOIN publicidad.Exhibicion ex
    ON ce.ExhibicionID = ex.ExhibicionID
INNER JOIN publicidad.PiezaPublicitaria pp
    ON ex.PiezaID = pp.PiezaID
INNER JOIN publicidad.Campaña ca
    ON pp.CampañaID = ca.CampañaID
INNER JOIN publicidad.Anunciante a
    ON ca.AnuncianteID = a.AnuncianteID
INNER JOIN torneo.Partido p
    ON ce.PartidoID = p.PartidoID
INNER JOIN torneo.Sede se
    ON p.SedeID = se.SedeID
ORDER BY p.PartidoID, ex.Espacio;


-- Paso 4: Probar las SP de las reglas de negocio

-- =============================================================
-- torneo.SP_RegistrarPartidoCompleto
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;
PRINT '--- 1. SP_RegistrarPartidoCompleto ---';

SELECT TOP (1) @SedeID = SedeID, @Capacidad = Capacidad
FROM torneo.Sede
WHERE Capacidad IS NOT NULL
ORDER BY SedeID;

SELECT TOP (1) @LocalID = SeleccionID FROM torneo.Seleccion ORDER BY SeleccionID;
SELECT TOP (1) @VisitanteID = SeleccionID
FROM torneo.Seleccion WHERE SeleccionID <> @LocalID ORDER BY SeleccionID;

IF @SedeID IS NOT NULL AND @LocalID IS NOT NULL AND @VisitanteID IS NOT NULL
BEGIN
    SET @FechaUTC = DATEADD(MINUTE, 17, DATEADD(DAY, 500, GETUTCDATE()));
    SET @FechaLocal = @FechaUTC; -- Ajustar si el modelo exige conversión de huso horario.
    SET @AsistenciaPrueba = CASE WHEN @Capacidad > 0 THEN 1 ELSE 0 END;
    BEGIN TRY
        EXEC torneo.SP_RegistrarPartidoCompleto
            @SedeID=@SedeID, @LocalID=@LocalID, @VisitanteID=@VisitanteID,
            @Fase='Prueba', @Asistencia=@AsistenciaPrueba,
            @FechaHoraLocal=@FechaLocal, @FechaHoraUTC=@FechaUTC;
        SELECT TOP (1) @PartidoID = PartidoID
        FROM torneo.Partido WHERE SedeID=@SedeID AND fechaHoraUTC=@FechaUTC;
        PRINT 'OK esperado: partido registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR inesperado en caso exitoso de SP_RegistrarPartidoCompleto: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: faltan una sede con capacidad o dos selecciones.';

BEGIN TRY
    EXEC torneo.SP_RegistrarPartidoCompleto
        @SedeID=-999999, @LocalID=-999998, @VisitanteID=-999997,
        @Fase='Prueba fallida', @Asistencia=0,
        @FechaHoraLocal='2035-01-01T12:00:00', @FechaHoraUTC='2035-01-01T12:00:00';
    PRINT 'FALLO DE PRUEBA: se esperaba que el partido con sede inexistente fuera rechazado.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (sede inexistente): ' + ERROR_MESSAGE();
END CATCH;

IF @SedeID IS NOT NULL AND @LocalID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarPartidoCompleto
            @SedeID=@SedeID, @LocalID=@LocalID, @VisitanteID=@LocalID,
            @Fase='Prueba fallida', @Asistencia=0,
            @FechaHoraLocal='2035-01-02T12:00:00', @FechaHoraUTC='2035-01-02T12:00:00';
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar una selección contra sí misma.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (selección contra sí misma): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Torneo.Partido;

-- =============================================================
-- torneo.SP_ReemplazoUltMomento_Convocatoria
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;

PRINT '--- 2. SP_ReemplazoUltMomento_Convocatoria ---';

SET @ConvocatoriaID=NULL; SET @PersonaBajaID=NULL; SET @PersonaAltaID=NULL;
SELECT TOP (1)
    @ConvocatoriaID=j.ConvocatoriaID, @PersonaBajaID=j.PersonaID
FROM torneo.Jugador j
WHERE NOT EXISTS (SELECT 1 FROM torneo.Participa pa WHERE pa.PersonaID=j.PersonaID)
ORDER BY j.ConvocatoriaID, j.PersonaID;

SELECT TOP (1) @PersonaAltaID=p.PersonaID
FROM torneo.Persona p
WHERE NOT EXISTS (SELECT 1 FROM torneo.Jugador j WHERE j.PersonaID=p.PersonaID)
ORDER BY p.PersonaID;

IF @ConvocatoriaID IS NOT NULL AND @PersonaBajaID IS NOT NULL AND @PersonaAltaID IS NOT NULL
BEGIN
    SELECT @Dorsal = 7
    FROM torneo.Jugador WHERE ConvocatoriaID=@ConvocatoriaID;
    BEGIN TRY
        EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
            @ConvocatoriaID=@ConvocatoriaID, @PersonaBajaID=@PersonaBajaID,
            @PersonaAltaID=@PersonaAltaID, @ClubOrigenAlta='Club de prueba',
            @DorsalAlta=@Dorsal, @PosicionHabitualAlta='Delantero';
        PRINT 'OK esperado: reemplazo de convocatoria ejecutado.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de reemplazo (revisar restricciones adicionales): ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: se necesita un jugador sin participaciones y una persona que aún no sea jugador.';

BEGIN TRY
    EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
        @ConvocatoriaID=-999999, @PersonaBajaID=-999998, @PersonaAltaID=-999997,
        @ClubOrigenAlta='Prueba', @DorsalAlta=99, @PosicionHabitualAlta='Defensor';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar jugador/convocatoria inexistentes.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (jugador no pertenece a convocatoria): ' + ERROR_MESSAGE();
END CATCH;

-- El mismo dorsal ya existente debe rechazarse; el jugador elegido pertenece a esa convocatoria.
SELECT TOP (1) @ConvocatoriaID=ConvocatoriaID, @PersonaBajaID=PersonaID, @Dorsal=Dorsal
FROM torneo.Jugador ORDER BY ConvocatoriaID, PersonaID;
SELECT TOP (1) @PersonaAltaID=PersonaID
FROM torneo.Persona ORDER BY PersonaID;
IF @ConvocatoriaID IS NOT NULL AND @PersonaBajaID IS NOT NULL AND @Dorsal IS NOT NULL AND @PersonaAltaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
            @ConvocatoriaID=@ConvocatoriaID, @PersonaBajaID=@PersonaBajaID,
            @PersonaAltaID=@PersonaAltaID, @ClubOrigenAlta='Prueba',
            @DorsalAlta=@Dorsal, @PosicionHabitualAlta='Defensor';
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar dorsal duplicado (si no se rechazó antes por otra regla, revisar datos).';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (reemplazo inválido/dorsal duplicado): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Torneo.Jugador;

-- =============================================================
-- torneo.SP_RegistrarAlineacion_Validada
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;

PRINT '--- 3. SP_RegistrarAlineacion_Validada ---';

SET @FormacionID=NULL; SET @PersonaID=NULL;
SELECT TOP (1) @FormacionID=f.FormacionID
FROM torneo.Formacion f ORDER BY f.FormacionID;

SELECT TOP (1) @PersonaID=j.PersonaID
FROM torneo.Jugador j
WHERE NOT EXISTS (SELECT 1 FROM reglamento.Suspension s WHERE s.PersonaID=j.PersonaID AND s.PartidosSuspendido>0)
  AND NOT EXISTS (SELECT 1 FROM torneo.Participa pa WHERE pa.FormacionID=@FormacionID AND pa.PersonaID=j.PersonaID)
ORDER BY j.PersonaID;

IF @FormacionID IS NOT NULL AND @PersonaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarAlineacion_Validada
            @FormacionID=@FormacionID, @PersonaID=@PersonaID,
            @Titular=0, @PosicionCancha='Suplente';
        PRINT 'OK esperado: jugador agregado a la formación como suplente.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de alineación: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: no hay formación o jugador elegible no suspendido/no repetido.';

BEGIN TRY
    EXEC torneo.SP_RegistrarAlineacion_Validada
        @FormacionID=-999999, @PersonaID=-999998, @Titular=1, @PosicionCancha='Arquero';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar una formación inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (formación inexistente): ' + ERROR_MESSAGE();
END CATCH;

SELECT TOP (1) @FormacionID=FormacionID FROM torneo.Formacion ORDER BY FormacionID;
SELECT TOP (1) @PersonaID=PersonaID FROM torneo.Jugador ORDER BY PersonaID;
IF @FormacionID IS NOT NULL AND @PersonaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarAlineacion_Validada
            @FormacionID=@FormacionID, @PersonaID=@PersonaID,
            @Titular=1, @PosicionCancha='Prueba';
        PRINT 'FALLO DE PRUEBA: se esperaba error por regla de alineación, si corresponde a estos datos.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (jugador posiblemente repetido/suspendido o restricción): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Torneo.Participa;



-- =============================================================
-- torneo.SP_RegistrarCambioPartido
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;

PRINT '--- 4. SP_RegistrarCambioPartido ---';

SET @PartidoID=NULL; SET @JugadorSaleID=NULL; SET @JugadorEntraID=NULL;
SELECT TOP (1) @PartidoID=PartidoID FROM torneo.Partido ORDER BY PartidoID;
SELECT TOP (1) @JugadorSaleID=j1.PersonaID, @JugadorEntraID=j2.PersonaID
FROM torneo.Jugador j1
JOIN torneo.Jugador j2 ON j1.ConvocatoriaID=j2.ConvocatoriaID AND j1.PersonaID<>j2.PersonaID
ORDER BY j1.ConvocatoriaID, j1.PersonaID, j2.PersonaID;

IF @PartidoID IS NOT NULL AND @JugadorSaleID IS NOT NULL AND @JugadorEntraID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarCambioPartido
            @PartidoID=@PartidoID, @JugadorSaleID=@JugadorSaleID,
            @JugadorEntraID=@JugadorEntraID, @NumeroVentana=1,
            @Minuto=60, @Motivo='Táctico';
        PRINT 'OK esperado: sustitución registrada.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de sustitución: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: se requiere un partido y dos jugadores de la misma convocatoria.';

BEGIN TRY
    EXEC torneo.SP_RegistrarCambioPartido
        @PartidoID=-999999, @JugadorSaleID=-999998, @JugadorEntraID=-999997,
        @NumeroVentana=1, @Minuto=60, @Motivo='Prueba';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (partido inexistente): ' + ERROR_MESSAGE();
END CATCH;

IF @PartidoID IS NOT NULL AND @JugadorSaleID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarCambioPartido
            @PartidoID=@PartidoID, @JugadorSaleID=@JugadorSaleID,
            @JugadorEntraID=@JugadorSaleID, @NumeroVentana=1,
            @Minuto=70, @Motivo='Prueba';
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar el mismo jugador entrando y saliendo.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (mismo jugador entra y sale): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Torneo.Sustitucion;



-- =============================================================
-- torneo.SP_RegistrarGol_Y_ActualizarResultado
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;
PRINT '--- 5. SP_RegistrarGol_Y_ActualizarResultado ---';

SET @PartidoID=NULL; SET @PersonaID=NULL;
SELECT TOP (1) @PartidoID=PartidoID FROM torneo.Partido ORDER BY PartidoID;
SELECT TOP (1) @PersonaID=PersonaID FROM torneo.Jugador ORDER BY PersonaID;

IF @PartidoID IS NOT NULL AND @PersonaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado
            @PartidoID=@PartidoID, @PersonaID=@PersonaID,
            @AsistentePersonaID=NULL, @Periodo='Primer tiempo',
            @Tipo='Jugada', @Minuto=25;
        PRINT 'OK esperado: gol registrado (verificar que el jugador pertenezca a uno de los equipos del partido para actualizar marcador).';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de gol: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: se necesita al menos un partido y un jugador.';

BEGIN TRY
    EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado
        @PartidoID=-999999, @PersonaID=-999998,
        @AsistentePersonaID=NULL, @Periodo='Prueba', @Tipo='Jugada', @Minuto=10;
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (partido inexistente): ' + ERROR_MESSAGE();
END CATCH;

IF @PartidoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado
            @PartidoID=@PartidoID, @PersonaID=-999998,
            @AsistentePersonaID=NULL, @Periodo='Prueba', @Tipo='Jugada', @Minuto=10;
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar un goleador inexistente.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (goleador inexistente): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Torneo.Gol;
SELECT * FROM Torneo.Partido;



-- =============================================================
-- reglamento.SP_ProcesarTarjeta_Y_Suspension
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;
PRINT '--- 6. SP_ProcesarTarjeta_Y_Suspension ---';

SET @TarjetaID=NULL; SET @PartidoID=NULL; SET @PersonaID=NULL;
SELECT TOP (1) @TarjetaID=TarjetaID FROM reglamento.Tarjeta ORDER BY TarjetaID;
SELECT TOP (1) @PartidoID=PartidoID FROM torneo.Partido ORDER BY PartidoID;
SELECT TOP (1) @PersonaID=PersonaID FROM torneo.Jugador ORDER BY PersonaID;

IF @TarjetaID IS NOT NULL AND @PartidoID IS NOT NULL AND @PersonaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension
            @TarjetaID=@TarjetaID, @PartidoID=@PartidoID,
            @PersonaID=@PersonaID, @Minuto=35, @Motivo='Prueba controlada';
        PRINT 'OK esperado: tarjeta procesada (si el tipo es Roja, puede crear suspensión).';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de tarjeta: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: falta un tipo de tarjeta, partido o jugador.';

BEGIN TRY
    EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension
        @TarjetaID=-999999, @PartidoID=-999998,
        @PersonaID=-999997, @Minuto=10, @Motivo='Prueba inválida';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un tipo de tarjeta inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (tarjeta inexistente): ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension
        @TarjetaID=@TarjetaID, @PartidoID=-999998,
        @PersonaID=@PersonaID, @Minuto=10, @Motivo='Prueba inválida';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (partido inexistente): ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM Reglamento.TarjetaAsignada;



-- =============================================================
-- reglamento.SP_DesignarArbitro_SinConflicto
-- =============================================================
EXEC reglamento.SP_Alta_Arbitro 6, 'Brasil', 'Central';
EXEC torneo.SP_Alta_Pais 'Brasil', 2100.00, 'UTC-4';
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;
PRINT '--- 7. SP_DesignarArbitro_SinConflicto ---';

SET @PartidoID=1; SET @ArbitroID=6; SET @PaisArbitro=4;
SELECT TOP (1) @PartidoID=p.PartidoID
FROM torneo.Partido p
WHERE (SELECT COUNT(*) FROM torneo.Juega j WHERE j.PartidoID=p.PartidoID) >= 2
ORDER BY p.PartidoID;

SELECT TOP (1) @ArbitroID=a.PersonaID, @PaisArbitro=a.Pais
FROM reglamento.Arbitro a
WHERE a.Pais IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM torneo.Juega j
      JOIN torneo.Seleccion s ON s.SeleccionID=j.SeleccionID
      WHERE j.PartidoID=@PartidoID AND s.Pais=a.Pais
  )
ORDER BY a.PersonaID;

IF @PartidoID IS NOT NULL AND @ArbitroID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_DesignarArbitro_SinConflicto
            @PartidoID=@PartidoID, @ArbitroID=@ArbitroID,
            @Informe='Prueba', @RolArbitral='Principal';
        PRINT 'OK esperado: árbitro designado.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de designación: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: no se encontró partido con dos equipos y árbitro de nacionalidad compatible.';

BEGIN TRY
    EXEC reglamento.SP_DesignarArbitro_SinConflicto
        @PartidoID=-999999, @ArbitroID=-999998,
        @Informe='Prueba', @RolArbitral='Principal';
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (partido inexistente): ' + ERROR_MESSAGE();
END CATCH;

IF @PartidoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_DesignarArbitro_SinConflicto
            @PartidoID=@PartidoID, @ArbitroID=-999998,
            @Informe='Prueba', @RolArbitral='Principal';
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar un árbitro inexistente.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (árbitro inexistente): ' + ERROR_MESSAGE();
    END CATCH;
END;

SELECT * FROM Reglamento.SeDesignaArbitro;



-- =============================================================
-- publicidad.SP_AsignarCuatroPiezasPorPartido
-- =============================================================
DECLARE
    @SedeID int, @LocalID int, @VisitanteID int, @Capacidad int,
    @PartidoID int, @FechaUTC datetime, @FechaLocal datetime,
    @ConvocatoriaID int, @PersonaBajaID int, @PersonaAltaID int,
    @Dorsal int, @FormacionID int, @PersonaID int,
    @JugadorSaleID int, @JugadorEntraID int, @TarjetaID int,
    @ArbitroID int, @PaisArbitro varchar(50),
    @PiezaPartidoID int, @AsistenciaPrueba int;
PRINT '--- 8. SP_AsignarCuatroPiezasPorPartido ---';

SET @PiezaPartidoID=NULL;
SELECT TOP (1) @PiezaPartidoID=p.PartidoID
FROM torneo.Partido p
WHERE (SELECT COUNT(*) FROM publicidad.CuentaConExhibicion c WHERE c.PartidoID=p.PartidoID) < 4
ORDER BY p.PartidoID;

IF @PiezaPartidoID IS NOT NULL
   AND (SELECT COUNT(*) FROM publicidad.PiezaPublicitaria) >= 4
BEGIN
    BEGIN TRY
        EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID=@PiezaPartidoID;
        PRINT 'OK esperado: se intentó asignar publicidad al partido.';
    END TRY
    BEGIN CATCH
        PRINT 'ERROR en caso exitoso de publicidad: ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: se necesitan un partido con menos de 4 espacios asignados y al menos 4 piezas publicitarias.';

BEGIN TRY
    EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID=-999999;
    PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido inexistente.';
END TRY
BEGIN CATCH
    PRINT 'FALLO esperado (partido inexistente): ' + ERROR_MESSAGE();
END CATCH;

SELECT TOP (1) @PiezaPartidoID=PartidoID
FROM torneo.Partido
WHERE (SELECT COUNT(*) FROM publicidad.CuentaConExhibicion c WHERE c.PartidoID=torneo.Partido.PartidoID) >= 4
ORDER BY PartidoID;

IF @PiezaPartidoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID=@PiezaPartidoID;
        PRINT 'FALLO DE PRUEBA: se esperaba rechazar un partido que ya tiene cuatro espacios ocupados.';
    END TRY
    BEGIN CATCH
        PRINT 'FALLO esperado (cuatro espacios ya ocupados): ' + ERROR_MESSAGE();
    END CATCH;
END
ELSE PRINT 'OMITIDO: no se encontró partido con los cuatro espacios ya ocupados para probar esa validación.';

SELECT * FROM Publicidad.Exhibicion;
