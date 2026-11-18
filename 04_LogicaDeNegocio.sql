
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


--===============================================================
-- Registro de alineaciones validando titularidad y suspensiones
--===============================================================

CREATE OR ALTER PROCEDURE torneo.SP_RegistrarAlineacion_Validada
    @FormacionID INT,
    @PersonaID INT,
    @Titular BIT,
    @PosicionCancha VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM torneo.Formacion WHERE FormacionID = @FormacionID)
            THROW 50001, 'La formación especificada no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
            THROW 50002, 'El jugador especificado no existe.', 1;

        IF EXISTS (SELECT 1 FROM reglamento.Suspension WHERE PersonaID = @PersonaID AND PartidosSuspendido > 0)
            THROW 50003, 'El jugador se encuentra suspendido y no puede ser alineado.', 1;

        IF @Titular = 1 AND (SELECT COUNT(*) FROM torneo.Participa WHERE FormacionID = @FormacionID AND Titular = 1) >= 11
            THROW 50004, 'La formación ya cuenta con el máximo de 11 titulares.', 1;

        IF @Titular = 0 AND (SELECT COUNT(*) FROM torneo.Participa WHERE FormacionID = @FormacionID AND Titular = 0) >= 15
            THROW 50005, 'El banco de suplentes ya cuenta con el máximo de 15 jugadores.', 1;

        INSERT INTO torneo.Participa (FormacionID, PersonaID, Titular, PosicionCancha)
        VALUES (@FormacionID, @PersonaID, @Titular, @PosicionCancha);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO


--========================================
-- Registro de cambios durante el partido
--========================================

CREATE OR ALTER PROCEDURE torneo.SP_RegistrarCambioPartido
    @PartidoID INT,
    @JugadorSaleID INT,
    @JugadorEntraID INT,
    @NumeroVentana INT,
    @Minuto INT,
    @Motivo VARCHAR(20)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
            THROW 50001, 'El partido especificado no existe.', 1;

        IF @JugadorSaleID = @JugadorEntraID
            THROW 50002, 'El jugador que sale y el que entra no pueden ser el mismo.', 1;

        DECLARE @ConvSale INT = (SELECT ConvocatoriaID FROM torneo.Jugador WHERE PersonaID = @JugadorSaleID);
        DECLARE @ConvEntra INT = (SELECT ConvocatoriaID FROM torneo.Jugador WHERE PersonaID = @JugadorEntraID);

        IF @ConvSale IS NULL OR @ConvEntra IS NULL OR @ConvSale <> @ConvEntra
            THROW 50003, 'Ambos jugadores deben existir y pertenecer a la misma selección.', 1;

        DECLARE @MaxVentanas INT = 3;
        DECLARE @MaxCambios INT = 5;

        IF @Minuto> 90
        BEGIN
            SET @MaxVentanas = 4;
            SET @MaxCambios = 6;
        END

        IF @NumeroVentana NOT BETWEEN 1 AND @MaxVentanas
            THROW 50004, 'El número de ventana excede el límite permitido.', 1;

        DECLARE @CambiosRealizados INT;
        SET @CambiosRealizados = (
            SELECT COUNT(*) FROM torneo.Sustitucion s
            JOIN torneo.Jugador j ON s.JugadorSaleID = j.PersonaID
            WHERE s.PartidoID = @PartidoID AND j.ConvocatoriaID = @ConvSale
        );

        IF @CambiosRealizados >= @MaxCambios
            THROW 50005, 'La selección ya agotó los cambios permitidos en este partido.', 1;

        INSERT INTO torneo.Sustitucion (PartidoID, JugadorSaleID, JugadorEntraID, NumeroVentana, Minuto, Motivo)
        VALUES (@PartidoID, @JugadorSaleID, @JugadorEntraID, @NumeroVentana, @Minuto, @Motivo);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO


--==============================================
-- Registro de Gol y actualización del marcador
--==============================================
CREATE OR ALTER PROCEDURE torneo.SP_RegistrarGol_Y_ActualizarResultado
    @PartidoID INT,
    @PersonaID INT,
    @AsistentePersonaID INT = NULL,
    @Periodo VARCHAR(30),
    @Tipo VARCHAR(30),
    @Minuto INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
            THROW 50001, 'El partido no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
            THROW 50002, 'El jugador autor del gol no existe.', 1;

        IF @AsistentePersonaID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @AsistentePersonaID)
            THROW 50003, 'El jugador asistente no existe.', 1;

        INSERT INTO torneo.Gol (PartidoID, PersonaID, AsistentePersonaID, Periodo, Tipo, Minuto)
        VALUES (@PartidoID, @PersonaID, @AsistentePersonaID, @Periodo, @Tipo, @Minuto);

        DECLARE @Sel1 INT = (SELECT MIN(SeleccionID) FROM torneo.Juega WHERE PartidoID = @PartidoID);
        DECLARE @Sel2 INT = (SELECT MAX(SeleccionID) FROM torneo.Juega WHERE PartidoID = @PartidoID);

        IF @Sel1 IS NOT NULL AND @Sel2 IS NOT NULL
        BEGIN
            DECLARE @Goles1 INT = (
                SELECT COUNT(*) FROM torneo.Gol g
                JOIN torneo.Jugador j ON g.PersonaID = j.PersonaID
                JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID
                WHERE g.PartidoID = @PartidoID AND c.SeleccionID = @Sel1
            );

            DECLARE @Goles2 INT = (
                SELECT COUNT(*) FROM torneo.Gol g
                JOIN torneo.Jugador j ON g.PersonaID = j.PersonaID
                JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID
                WHERE g.PartidoID = @PartidoID AND c.SeleccionID = @Sel2
            );

            UPDATE torneo.Partido
            SET ResultadoFinal = CAST(@Goles1 AS VARCHAR(5)) + '-' + CAST(@Goles2 AS VARCHAR(5))
            WHERE PartidoID = @PartidoID;
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO


--=============================================
-- Registro de Tarjeta y cálculo de suspensión
--=============================================
CREATE OR ALTER PROCEDURE reglamento.SP_ProcesarTarjeta_Y_Suspension
    @TarjetaID INT,
    @PartidoID INT,
    @PersonaID INT,
    @Minuto INT,
    @Motivo VARCHAR(100)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        DECLARE @TipoTarjeta VARCHAR(30);
        SET @TipoTarjeta = (SELECT Tipo FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID);
        
        IF @TipoTarjeta IS NULL
            THROW 50001, 'El tipo de tarjeta especificado no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
            THROW 50002, 'El partido no existe.', 1;

        IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
            THROW 50003, 'El jugador no existe.', 1;

        INSERT INTO reglamento.TarjetaAsignada (TarjetaID, PartidoID, PersonaID, Minuto, Motivo)
        VALUES (@TarjetaID, @PartidoID, @PersonaID, @Minuto, @Motivo);

        IF @TipoTarjeta = 'Roja'
        BEGIN
            INSERT INTO reglamento.Suspension (PersonaID, Motivo, PartidosSuspendido)
            VALUES (@PersonaID, 'Expulsión por Roja Directa', 2);
        END
        ELSE IF @TipoTarjeta = 'Amarilla'
        BEGIN
            DECLARE @AmarillasPartido INT = (
                SELECT COUNT(*) FROM reglamento.TarjetaAsignada 
                WHERE PartidoID = @PartidoID AND PersonaID = @PersonaID AND TarjetaID = @TarjetaID
            );

            DECLARE @AmarillasTorneo INT = (
                SELECT COUNT(*) FROM reglamento.TarjetaAsignada 
                WHERE PersonaID = @PersonaID AND TarjetaID = @TarjetaID
            );

            IF @AmarillasPartido = 2
            BEGIN
                INSERT INTO reglamento.Suspension (PersonaID, Motivo, PartidosSuspendido)
                VALUES (@PersonaID, 'Expulsión por doble amarilla en el partido', 1);
            END
            ELSE IF @AmarillasTorneo % 2 = 0
            BEGIN
                INSERT INTO reglamento.Suspension (PersonaID, Motivo, PartidosSuspendido)
                VALUES (@PersonaID, 'Acumulación de tarjetas amarillas en el torneo', 1);
            END
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO


--=========================
-- Designación de Árbitros
--=========================

CREATE OR ALTER PROCEDURE reglamento.SP_DesignarArbitro_SinConflicto
    @PartidoID INT,
    @ArbitroID INT,
    @Informe VARCHAR(50),
    @RolArbitral VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
            THROW 50001, 'El partido no existe.', 1;

        DECLARE @FasePartido VARCHAR(50) = (SELECT Fase FROM torneo.Partido WHERE PartidoID = @PartidoID);
        DECLARE @PaisArbitro VARCHAR(50) = (SELECT Pais FROM reglamento.Arbitro WHERE PersonaID = @ArbitroID);
        
        IF @PaisArbitro IS NULL
            THROW 50002, 'El árbitro ingresado no existe.', 1;

        IF EXISTS (SELECT 1 FROM reglamento.SeDesignaArbitro WHERE PartidoID = @PartidoID AND ArbitroID = @ArbitroID)
            THROW 50003, 'El árbitro ya fue designado para este partido.', 1;

        IF EXISTS (
            SELECT 1 
            FROM torneo.Juega j
            JOIN torneo.Seleccion s ON j.SeleccionID = s.SeleccionID
            WHERE j.PartidoID = @PartidoID AND s.Pais = @PaisArbitro
        )
            THROW 50004, 'Conflicto de nacionalidad: El árbitro tiene la misma nacionalidad que una de las selecciones del partido.', 1;

        INSERT INTO reglamento.SeDesignaArbitro (PartidoID, ArbitroID, Informe, RolArbitral)
        VALUES (@PartidoID, @ArbitroID, @Informe, @RolArbitral);

        IF @FasePartido IN ('Dieciseisavos', 'Octavos', 'Cuartos', 'Semifinal', 'Final')
        BEGIN
            IF EXISTS (
                SELECT 1 FROM torneo.Juega j2
                JOIN torneo.Seleccion s2 ON j2.SeleccionID = s2.SeleccionID
                JOIN torneo.Partido p2 ON j2.PartidoID = p2.PartidoID
                WHERE s2.Pais = @PaisArbitro AND p2.Fase = @FasePartido
            )
            BEGIN
                PRINT 'ADVERTENCIA: El árbitro designado proviene de un país que sigue en competencia en esta fase (' + @FasePartido + ') y podría existir un futuro cruce de intereses.';
            END
        END

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO

--=================================================
-- Asignación automática de espacios publicitarios
--=================================================
CREATE OR ALTER PROCEDURE publicidad.SP_AsignarCuatroPiezasPorPartido
    @PartidoID INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
            THROW 50001, 'El partido especificado no existe.', 1;

        IF (SELECT COUNT(*) FROM publicidad.CuentaConExhibicion WHERE PartidoID = @PartidoID) >= 4
            THROW 50002, 'Este partido ya tiene ocupados sus 4 espacios publicitarios.', 1;

        IF (SELECT COUNT(*) FROM publicidad.PiezaPublicitaria) < 4
            THROW 50003, 'Deben existir al menos 4 piezas publicitarias registradas para asignar.', 1;

        DECLARE @FechaHoraUTC DATETIME;
        SET @FechaHoraUTC = (SELECT fechaHoraUTC FROM torneo.Partido WHERE PartidoID = @PartidoID);

        CREATE TABLE #Top4Piezas (
            NumeroEspacio INT IDENTITY(1,1),
            PiezaID INT,
            Tarifa DECIMAL(10,2)
        );

        ;WITH EvaluacionPiezas AS (
            SELECT 
                pp.PiezaID,
                pp.Tarifa,

                CASE WHEN p.Nombre IN (
                    SELECT s.Pais FROM torneo.Juega j JOIN torneo.Seleccion s ON j.SeleccionID = s.SeleccionID WHERE j.PartidoID = @PartidoID
                ) THEN 1 ELSE 0 END AS EsPaisQueJuega,

                ISNULL(p.PBI, 0) AS PBI_Mercado,

                CASE WHEN DATEPART(HOUR, DATEADD(HOUR, ISNULL(TRY_CAST(REPLACE(p.HusoHorario, 'UTC', '') AS INT), 0), @FechaHoraUTC)) BETWEEN 19 AND 23 
                THEN 1 ELSE 0 END AS CaeEnPrimeTime,
                ROW_NUMBER() OVER (
                    PARTITION BY pp.PiezaID 
                    ORDER BY 
                        CASE WHEN p.Nombre IN (SELECT s.Pais FROM torneo.Juega j JOIN torneo.Seleccion s ON j.SeleccionID = s.SeleccionID WHERE j.PartidoID = @PartidoID) THEN 1 ELSE 0 END DESC,
                        ISNULL(p.PBI, 0) DESC,
                        CASE WHEN DATEPART(HOUR, DATEADD(HOUR, ISNULL(TRY_CAST(REPLACE(p.HusoHorario, 'UTC', '') AS INT), 0), @FechaHoraUTC)) BETWEEN 19 AND 23 THEN 1 ELSE 0 END DESC
                ) AS MejorMercadoPorPieza
            FROM publicidad.PiezaPublicitaria pp
            JOIN publicidad.Campaña c ON pp.CampañaID = c.CampañaID
            JOIN publicidad.Anunciante a ON c.AnuncianteID = a.AnuncianteID
            LEFT JOIN publicidad.InteresPublicitario ip ON a.AnuncianteID = ip.AnuncianteID
            LEFT JOIN torneo.Pais p ON ip.PaisID = p.PaisID
        )
        INSERT INTO #Top4Piezas (PiezaID, Tarifa)
        SELECT TOP 4 PiezaID, Tarifa
        FROM EvaluacionPiezas
        WHERE MejorMercadoPorPieza = 1
        ORDER BY EsPaisQueJuega DESC, PBI_Mercado DESC, CaeEnPrimeTime DESC, Tarifa DESC;

        DECLARE @ExhibicionesCreadas TABLE (ExhibicionID INT);

        INSERT INTO publicidad.Exhibicion (Espacio, PiezaID, Costo)
        OUTPUT INSERTED.ExhibicionID INTO @ExhibicionesCreadas(ExhibicionID)
        SELECT 
            'Panel Perimetral ' + CAST(NumeroEspacio AS VARCHAR(5)), 
            PiezaID, 
            CAST(Tarifa AS INT)
        FROM #Top4Piezas;

        INSERT INTO publicidad.CuentaConExhibicion (ExhibicionID, PartidoID)
        SELECT ExhibicionID, @PartidoID
        FROM @ExhibicionesCreadas;

        DROP TABLE #Top4Piezas;
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW; 
    END CATCH;
END
GO