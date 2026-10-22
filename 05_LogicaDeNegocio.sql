-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Logica de negocio

USE DB_Mundial_2026
GO

--=============================
-- Registro de partidos, sedes
--=============================

CREATE OR ALTER PROCEDURE torneo.SP_RegistrarPartidoCompleto
    @SedeID INT,
    @LocalID INT,
    @VisitanteID INT,
    @Fase VARCHAR(50),
    @Asistencia INT,
    @FechaHoraLocal DATETIME,
    @FechaHoraUTC DATETIME
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM torneo.Sede WHERE SedeID = @SedeID)
            THROW 50004, 'La sede no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @LocalID) OR 
           NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @VisitanteID)
            THROW 50005, 'Una o ambas selecciones no existen.', 1;

        IF @LocalID = @VisitanteID
            THROW 50001, 'Una selección no puede jugar contra sí misma.', 1;

        DECLARE @CapacidadSede INT;
        SET @CapacidadSede = (SELECT Capacidad FROM torneo.Sede WHERE SedeID = @SedeID);
        
        IF @Asistencia > @CapacidadSede
            THROW 50002, 'La asistencia supera la capacidad máxima del estadio.', 1;

        IF EXISTS (SELECT 1 FROM torneo.Partido WHERE SedeID = @SedeID AND fechaHoraUTC = @FechaHoraUTC)
            THROW 50003, 'Ya existe un partido programado en esta sede para ese horario.', 1;

        INSERT INTO torneo.Partido (SedeID, Fase, Asistencia, ResultadoFinal, fechaHoraLocal, fechaHoraUTC)
        VALUES (@SedeID, @Fase, @Asistencia, '0-0', @FechaHoraLocal, @FechaHoraUTC);

        DECLARE @NuevoPartidoID INT;
        SET @NuevoPartidoID = SCOPE_IDENTITY();

        INSERT INTO torneo.Juega (PartidoID, SeleccionID) VALUES (@NuevoPartidoID, @LocalID);
        INSERT INTO torneo.Juega (PartidoID, SeleccionID) VALUES (@NuevoPartidoID, @VisitanteID);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO

--===========================================================
-- Registro de convocatoria y altas/bajas de último momento
--===========================================================

CREATE OR ALTER PROCEDURE torneo.SP_ReemplazoUltMomento_Convocatoria
    @ConvocatoriaID INT,
    @PersonaBajaID INT,
    @PersonaAltaID INT,
    @ClubOrigenAlta VARCHAR(50),
    @DorsalAlta INT,
    @PosicionHabitualAlta VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaBajaID AND ConvocatoriaID = @ConvocatoriaID)
            THROW 50004, 'El jugador a dar de baja no pertenece a esta convocatoria.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaAltaID)
            THROW 50005, 'La persona ingresada como reemplazante no existe en la base.', 1;

        IF EXISTS (SELECT 1 FROM torneo.Participa WHERE PersonaID = @PersonaBajaID)
            THROW 50001, 'El jugador que se da de baja ya jugó, no se puede reemplazar.', 1;

        DELETE FROM torneo.Jugador 
        WHERE PersonaID = @PersonaBajaID AND ConvocatoriaID = @ConvocatoriaID;

        DECLARE @TotalJugadores INT;
        SET @TotalJugadores = (SELECT COUNT(*) FROM torneo.Jugador WHERE ConvocatoriaID = @ConvocatoriaID);

        IF @TotalJugadores>= 26
            THROW 50002, 'La convocatoria ya alcanzó el límite máximo de 26 jugadores.', 1;

        IF EXISTS (SELECT 1 FROM torneo.Jugador WHERE ConvocatoriaID = @ConvocatoriaID AND Dorsal = @DorsalAlta)
            THROW 50003, 'Ese número de dorsal ya está en uso.', 1;

        INSERT INTO torneo.Jugador (PersonaID, ClubOrigen, Dorsal, PosicionHabitual, ConvocatoriaID)
        VALUES (@PersonaAltaID, @ClubOrigenAlta, @DorsalAlta, @PosicionHabitualAlta, @ConvocatoriaID);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO