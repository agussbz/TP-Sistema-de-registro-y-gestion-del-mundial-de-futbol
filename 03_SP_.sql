
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Stored Procedures ABM

use DB_Mundial_2026
go

--Sede

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Sede
    @NombreEstadio VARCHAR(70),
    @Ciudad VARCHAR(100),
    @Pais VARCHAR(50),
    @Capacidad INT,
    @HusoHorario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@NombreEstadio)) = ''
        SET @mensajeError = 'El nombre del estadio es obligatorio. ';
    IF @Capacidad <= 0
        SET @mensajeError =  @mensajeError + 'La capacidad debe ser mayor a cero. ';
    IF EXISTS (SELECT 1 FROM torneo.Sede WHERE NombreEstadio = @NombreEstadio AND Ciudad = @Ciudad)
        SET @mensajeError =  @mensajeError + 'El estadio ya se encuentra registrado en esta ciudad. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Sede (NombreEstadio, Ciudad, Pais, Capacidad, HusoHorario)
    VALUES (@NombreEstadio, @Ciudad, @Pais, @Capacidad, @HusoHorario);

    PRINT 'Sede registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Sede
    @SedeID INT,
    @NombreEstadio VARCHAR(70),
    @Ciudad VARCHAR(100),
    @Pais VARCHAR(50),
    @Capacidad INT,
    @HusoHorario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Sede WHERE SedeID = @SedeID)
        SET @mensajeError = 'La Sede no existe.';
    IF LTRIM(RTRIM(@NombreEstadio)) = ''
        SET @mensajeError =  @mensajeError + 'El nombre del estadio es obligatorio.';
    IF @Capacidad <= 0
        SET @mensajeError =  @mensajeError + 'La capacidad debe ser mayor a cero.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Sede 
    SET NombreEstadio= @NombreEstadio, 
        Ciudad= @Ciudad, 
        Pais= @Pais, 
        Capacidad= @Capacidad, 
        HusoHorario= @HusoHorario 
    WHERE SedeID= @SedeID;

    PRINT 'Sede modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Sede
    @SedeID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Sede WHERE SedeID = @SedeID)
        SET @mensajeError = 'La Sede no existe. ';
    
    IF EXISTS (SELECT 1 FROM torneo.Partido WHERE SedeID = @SedeID)
        SET @mensajeError =  @mensajeError + 'No se puede borrar: Hay partidos programados en esta sede. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Sede WHERE SedeID = @SedeID;
    PRINT 'Sede eliminada exitosamente.';
END
GO

--Seleccion

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Seleccion
    @Pais VARCHAR(50),
    @Confederacion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = 'El País es obligatorio.';
    IF LTRIM(RTRIM(@Confederacion)) = ''
        SET @mensajeError = @mensajeError + 'La Confederación es obligatoria.';
    IF EXISTS (SELECT 1 FROM torneo.Seleccion WHERE Pais = @Pais)
        SET @mensajeError = @mensajeError + 'Esta selección ya se encuentra registrada.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Seleccion (Pais, Confederacion)
    VALUES (@Pais, @Confederacion);

    PRINT 'Selección registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Seleccion
    @SeleccionID INT,
    @Pais VARCHAR(50),
    @Confederacion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
        SET @mensajeError = 'La Selección no existe.';
    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = @mensajeError + 'El País es obligatorio.';
    IF LTRIM(RTRIM(@Confederacion)) = ''
        SET @mensajeError = @mensajeError + 'La Confederación es obligatoria.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Seleccion 
    SET Pais = @Pais, 
        Confederacion = @Confederacion 
    WHERE SeleccionID = @SeleccionID;

    PRINT 'Selección modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Seleccion
    @SeleccionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
        SET @mensajeError = 'La Selección no existe.';
    
    IF EXISTS (SELECT 1 FROM torneo.Convocatoria WHERE SeleccionID = @SeleccionID)
        SET @mensajeError = @mensajeError + 'No se puede borrar: Tiene convocatorias asociadas.';
    IF EXISTS (SELECT 1 FROM torneo.Juega WHERE SeleccionID = @SeleccionID)
        SET @mensajeError = @mensajeError + 'No se puede borrar: Tiene partidos asignados.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID;
    PRINT 'Selección eliminada exitosamente.';
END
GO

-- Sancion

CREATE OR ALTER PROCEDURE reglamento.SP_Alta_Sancion
    @Descripcion VARCHAR(50),
    @ArbitroID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@Descripcion)) = ''
        SET @mensajeError = 'La descripción es obligatoria. ';
    IF NOT EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @ArbitroID)
        SET @mensajeError = @mensajeError + 'El Árbitro ingresado no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO reglamento.Sancion (Descripcion, ArbitroID)
    VALUES (@Descripcion, @ArbitroID);

    PRINT 'Sanción registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Modificacion_Sancion
    @SancionID INT,
    @Descripcion VARCHAR(50),
    @ArbitroID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Sancion WHERE SancionID = @SancionID)
        SET @mensajeError = 'La Sanción no existe. ';
    IF LTRIM(RTRIM(@Descripcion)) = ''
        SET @mensajeError = @mensajeError + 'La descripción es obligatoria. ';
    IF NOT EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @ArbitroID)
        SET @mensajeError = @mensajeError + 'El Árbitro ingresado no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE reglamento.Sancion 
    SET Descripcion = @Descripcion, ArbitroID = @ArbitroID 
    WHERE SancionID = @SancionID;

    PRINT 'Sanción modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Baja_Sancion
    @SancionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Sancion WHERE SancionID = @SancionID)
        SET @mensajeError = 'La Sanción no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM reglamento.Sancion WHERE SancionID = @SancionID;
    PRINT 'Sanción eliminada exitosamente.';
END
GO

--Juega

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Juega
    @PartidoID INT,
    @SeleccionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = 'El Partido no existe.';
    IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
        SET @mensajeError = @mensajeError + 'La Selección no existe.';
    IF EXISTS (SELECT 1 FROM torneo.Juega WHERE PartidoID = @PartidoID AND SeleccionID = @SeleccionID)
        SET @mensajeError = @mensajeError + 'La selección ya está asignada a este partido.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Juega (PartidoID, SeleccionID)
    VALUES (@PartidoID, @SeleccionID);

    PRINT 'Selección asignada al partido exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Juega
    @PartidoID INT,
    @SeleccionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Juega WHERE PartidoID = @PartidoID AND SeleccionID = @SeleccionID)
        SET @mensajeError = 'El registro de juego no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Juega WHERE PartidoID = @PartidoID AND SeleccionID = @SeleccionID;
    PRINT 'Asignación eliminada exitosamente.';
END
GO

--CuentaConExhibicion

CREATE OR ALTER PROCEDURE publicidad.SP_Alta_CuentaConExhibicion
    @ExhibicionID INT,
    @PartidoID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM publicidad.Exhibicion WHERE ExhibicionID = @ExhibicionID)
        SET @mensajeError = 'La Exhibición no existe.';
    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'El Partido no existe.';
    IF EXISTS (SELECT 1 FROM publicidad.CuentaConExhibicion WHERE ExhibicionID = @ExhibicionID AND PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'Esta exhibición ya está asignada a este partido.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO publicidad.CuentaConExhibicion (ExhibicionID, PartidoID)
    VALUES (@ExhibicionID, @PartidoID);

    PRINT 'Exhibición asignada al partido exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE publicidad.SP_Baja_CuentaConExhibicion
    @ExhibicionID INT,
    @PartidoID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM publicidad.CuentaConExhibicion WHERE ExhibicionID = @ExhibicionID AND PartidoID = @PartidoID)
        SET @mensajeError = 'El registro de exhibición no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM publicidad.CuentaConExhibicion WHERE ExhibicionID = @ExhibicionID AND PartidoID = @PartidoID;
    PRINT 'Exhibición desvinculada del partido exitosamente.';
END
GO

--Participa

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Participa
    @FormacionID INT,
    @PersonaID INT,
    @Titular BIT,
    @PosicionCancha VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Formacion WHERE FormacionID = @FormacionID)
        SET @mensajeError = 'La Formación no existe. ';
    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El Jugador no existe. ';
    IF EXISTS (SELECT 1 FROM torneo.Participa WHERE FormacionID = @FormacionID AND PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El jugador ya participa en esta formación. ';
    IF LTRIM(RTRIM(@PosicionCancha)) = ''
        SET @mensajeError = @mensajeError + 'La posición en cancha es obligatoria. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Participa (FormacionID, PersonaID, Titular, PosicionCancha)
    VALUES (@FormacionID, @PersonaID, @Titular, @PosicionCancha);

    PRINT 'Participación registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Participa
    @FormacionID INT,
    @PersonaID INT,
    @Titular BIT,
    @PosicionCancha VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Participa WHERE FormacionID = @FormacionID AND PersonaID = @PersonaID)
        SET @mensajeError = 'El registro de participación no existe. ';
    IF LTRIM(RTRIM(@PosicionCancha)) = ''
        SET @mensajeError = @mensajeError + 'La posición en cancha es obligatoria. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Participa 
    SET Titular = @Titular, PosicionCancha = @PosicionCancha 
    WHERE FormacionID = @FormacionID AND PersonaID = @PersonaID;

    PRINT 'Participación modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Participa
    @FormacionID INT,
    @PersonaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Participa WHERE FormacionID = @FormacionID AND PersonaID = @PersonaID)
        SET @mensajeError = 'El registro de participación no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Participa WHERE FormacionID = @FormacionID AND PersonaID = @PersonaID;
    PRINT 'Participación eliminada exitosamente.';
END
GO

--Suspension

CREATE OR ALTER PROCEDURE reglamento.SP_Alta_Suspension
    @PersonaID INT,
    @Motivo VARCHAR(200),
    @PartidosSuspendido INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = 'El Jugador ingresado no existe. ';
    IF LTRIM(RTRIM(@Motivo)) = ''
        SET @mensajeError = @mensajeError + 'El motivo es obligatorio. ';
    IF @PartidosSuspendido <= 0
        SET @mensajeError = @mensajeError + 'La cantidad de partidos suspendidos debe ser mayor a cero. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO reglamento.Suspension (PersonaID, Motivo, PartidosSuspendido)
    VALUES (@PersonaID, @Motivo, @PartidosSuspendido);

    PRINT 'Suspensión registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Modificacion_Suspension
    @SuspensionID INT,
    @Motivo VARCHAR(200),
    @PartidosSuspendido INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Suspension WHERE SuspensionID = @SuspensionID)
        SET @mensajeError = 'La Suspensión no existe. ';
    IF LTRIM(RTRIM(@Motivo)) = ''
        SET @mensajeError = @mensajeError + 'El motivo es obligatorio. ';
    IF @PartidosSuspendido <= 0
        SET @mensajeError = @mensajeError + 'La cantidad de partidos suspendidos debe ser mayor a cero. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE reglamento.Suspension 
    SET Motivo = @Motivo, PartidosSuspendido = @PartidosSuspendido 
    WHERE SuspensionID = @SuspensionID;

    PRINT 'Suspensión modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Baja_Suspension
    @SuspensionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Suspension WHERE SuspensionID = @SuspensionID)
        SET @mensajeError = 'La Suspensión no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM reglamento.Suspension WHERE SuspensionID = @SuspensionID;
    PRINT 'Suspensión eliminada exitosamente.';
END
GO