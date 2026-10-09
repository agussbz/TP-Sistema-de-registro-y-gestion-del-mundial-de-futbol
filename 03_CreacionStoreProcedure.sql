
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Store Procedure

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

-- ====================================================================
-- PLANTILLA ABM: Tabla IDIOMA
-- ====================================================================
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Idioma
    @nombre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@nombre)) = ''
        SET @mensajeError = 'El nombre del idioma es obligatorio. ';
    
    IF EXISTS (SELECT 1 FROM torneo.Idioma WHERE Nombre = @nombre)
        SET @mensajeError = 'El idioma ya se encuentra registrado. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Idioma (Nombre)
    VALUES (@nombre);

    PRINT 'Idioma registrado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Idioma
    @IdiomaID INT,
    @nombre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';
       
    IF NOT EXISTS (SELECT 1 FROM Torneo.Idioma WHERE IdiomaID = @IdiomaID)
        SET @mensajeError = 'El ID del idioma a modificar no existe. ';

    IF LTRIM(RTRIM(@nombre)) = ''
        SET @mensajeError = @mensajeError + 'El nombre del Idioma no puede quedar vac�o. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Idioma
    SET Nombre = @nombre
    WHERE IdiomaID = @IdiomaID;

    PRINT 'Idioma modificado exitosamente.';
END
GO


CREATE OR ALTER PROCEDURE torneo.SP_Baja_Idioma
    @IdiomaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM Torneo.Idioma WHERE IdiomaID = @IdiomaID)
        SET @mensajeError = 'El ID de la sede que intenta eliminar no existe.';

    IF EXISTS (SELECT 1 FROM Torneo.PersonaHabla WHERE IdiomaID = @IdiomaID)
        SET @mensajeError = @mensajeError + 'No se puede eliminar el idioma porque hay personas que lo hablan. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM Torneo.Idioma WHERE IdiomaID = @IdiomaID;

    PRINT 'Idioma eliminado exitosamente.';
END
GO


-- ====================================================================
-- PLANTILLA ABM: Tabla ANUNCIANTE
-- ====================================================================
CREATE OR ALTER PROCEDURE publicidad.SP_Alta_Anunciante
    @Pais VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = 'El nombre del pais es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO publicidad.Anunciante (Pais)
    VALUES (@Pais);

    PRINT 'Anunciante registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Anunciante
    @AnuncianteID INT,
    @Pais VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM Publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
        SET @mensajeError = 'El ID del anunciante a modificar no existe. ';

    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = @mensajeError + 'El nombre del pais no puede quedar vac�o. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE Publicidad.Anunciante
    SET Pais = @Pais
    WHERE AnuncianteID = @AnuncianteID;

    PRINT 'Anunciante modificada exitosamente.';
END
GO


CREATE OR ALTER PROCEDURE torneo.SP_Baja_Anunciante
    @AnuncianteID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
        SET @mensajeError = 'El ID de la sede que intenta eliminar no existe. ';

    IF EXISTS (SELECT 1 FROM publicidad.Campa�a WHERE AnuncianteID = @AnuncianteID)
        SET @mensajeError = @mensajeError + 'El ID del anunciante que intenta eliminar no es posible porque ya tiene anuncios programados. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM Publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID;

    PRINT 'Anunciante eliminada exitosamente.';
END
GO


-- ====================================================================
-- PLANTILLA ABM: Tabla ARBITRO
-- ====================================================================
CREATE OR ALTER PROCEDURE reglamento.SP_Alta_Arbitro
    @Pais VARCHAR(50),
	@RolArbitral VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = 'El nombre del pais es obligatorio.';

    IF LTRIM(RTRIM(@RolArbitral)) = ''
        SET @mensajeError = @mensajeError + 'El rol del arbitro es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO reglamento.Arbitro (Pais, RolArbitral)
    VALUES (@Pais, @RolArbitral);

    PRINT 'Arbitro registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Arbitro
    @PersonaID INT,
    @Pais VARCHAR(50),
	@RolArbitral VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @PersonaID)
        SET @mensajeError = 'El ID del arbitro a modificar no existe. ';

    IF LTRIM(RTRIM(@Pais)) = ''
        SET @mensajeError = @mensajeError + 'El nombre del estadio no puede quedar vac�o. ';

    IF LTRIM(RTRIM(@RolArbitral)) = ''
        SET @mensajeError = @mensajeError + 'El rol del arbitro no puede quedar vac�o. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE reglamento.Arbitro
    SET Pais = @Pais, RolArbitral = @RolArbitral
    WHERE PersonaID = @PersonaID;

    PRINT 'Arbitro modificada exitosamente.';
END
GO


CREATE OR ALTER PROCEDURE torneo.SP_Baja_Arbitro
    @PersonaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @PersonaID)
        SET @mensajeError = 'El ID del arbitro que intenta eliminar no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM reglamento.Arbitro WHERE PersonaID = @PersonaID;

    PRINT 'Arbitro eliminada exitosamente.';
END
GO

-- ====================================================================
-- PLANTILLA ABM: Tabla PersonaHabla
-- ====================================================================
CREATE OR ALTER PROCEDURE torneo.SP_Alta_PersonaHabla
    @PersonaID INT,
	@IdiomaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
        SET @mensajeError = 'La persona no existe.';

    IF NOT EXISTS (SELECT 1 FROM torneo.Idioma WHERE IdiomaID = @IdiomaID)
        SET @mensajeError = @mensajeError + 'El idioma no existe.';

    IF EXISTS (SELECT 1 FROM torneo.PersonaHabla WHERE PersonaID = @PersonaID AND IdiomaID = @IdiomaID)
        SET @mensajeError = @mensajeError + 'La persona ya habla este idioma.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.PersonaHabla (PersonaID, IdiomaID)
    VALUES (@PersonaID, @IdiomaID);

    PRINT 'Idioma hablado registrado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_PersonaHabla
    @PersonaID INT,
	@IdiomaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
        SET @mensajeError = 'La persona no existe.';

    IF NOT EXISTS (SELECT 1 FROM torneo.Idioma WHERE IdiomaID = @IdiomaID)
        SET @mensajeError = @mensajeError + 'El idioma no existe.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.PersonaHabla
    WHERE PersonaID = @PersonaID AND IdiomaID = @IdiomaID

    PRINT 'Idioma hablado eliminado exitosamente.';
END


-- ====================================================================
-- PLANTILLA ABM: Tabla Interes Publicitario
-- ====================================================================
CREATE OR ALTER PROCEDURE publicidad.SP_Alta_InteresPublicitario
	@AnuncianteID INT,
    @PaisID INT,
    @Prioridad VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM Publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
        SET @mensajeError = 'El ID del anunciante a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Pais WHERE PaisID = @PaisID)
        SET @mensajeError = 'El ID del pais a modificar no existe. ';

    IF LTRIM(RTRIM(@Prioridad)) = ''
        SET @mensajeError = @mensajeError + 'La descripcion de la prioridad es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO publicidad.InteresPublicitario (AnuncianteID, PaisID, Prioridad)
    VALUES (@AnuncianteID, @PaisID, @Prioridad);

    PRINT 'Interes Publicitario registrado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE publicidad.SP_Modificacion_InteresPublicitario
    @InteresID INT,
	@AnuncianteID INT,
    @Prioridad VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM Publicidad.InteresPublicitario WHERE InteresID = @InteresID)
        SET @mensajeError = 'El ID del anunciante a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM Publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
        SET @mensajeError = @mensajeError + 'El ID del anunciante a modificar no existe. ';

    IF LTRIM(RTRIM(@Prioridad)) = ''
        SET @mensajeError = @mensajeError + 'La descripcion de la prioridad es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE publicidad.InteresPublicitario
    SET AnuncianteID = @AnuncianteID, Prioridad = @Prioridad
    WHERE InteresID = @InteresID;

    PRINT 'Interes publicitario modificado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE publicidad.SP_Baja_InteresPublicitario
    @InteresID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM Publicidad.InteresPublicitario WHERE InteresID = @InteresID)
        SET @mensajeError = 'El ID del interes publicitario a eliminar no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM publicidad.InteresPublicitario
    WHERE InteresID = @InteresID;

    PRINT 'Interes publicitario eliminado exitosamente.';
END

-- ====================================================================
-- PLANTILLA ABM: Tabla Gol
-- ====================================================================
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Gol
    @PartidoID INT,
    @PersonaID INT,
    @AsistentePersonaID INT,
    @Periodo VARCHAR(30),
    @Tipo VARCHAR(30),
    @Minuto INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'El ID del paritdo a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El ID del jugador a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @AsistentePersonaID)
        SET @mensajeError = @mensajeError + 'El ID del jugador asistente a modificar no existe. ';

    IF LTRIM(RTRIM(@Periodo)) = ''
        SET @mensajeError = @mensajeError + 'El periodo es obligatorio.';

    IF LTRIM(RTRIM(@Tipo)) = ''
        SET @mensajeError = @mensajeError + 'El tipo es obligatorio.';

    IF @Minuto IS NULL
        SET @mensajeError = @mensajeError + 'El minuto no puede ser nulo';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Gol (PartidoID, PersonaID, AsistentePersonaID, Periodo, Tipo, Minuto)
    VALUES (@PartidoID, @PersonaID, @AsistentePersonaID, @Periodo, @Tipo, @Minuto);

    PRINT 'Gol registrado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Gol
    @GolID INT,
    @PartidoID INT,
    @PersonaID INT,
    @AsistentePersonaID INT,
    @Periodo VARCHAR(30),
    @Tipo VARCHAR(30),
    @Minuto INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Gol WHERE GolID = @GolID)
        SET @mensajeError = 'El ID del gol a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'El ID del paritdo a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El ID del jugador a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @AsistentePersonaID)
        SET @mensajeError = @mensajeError + 'El ID del jugador asistente a modificar no existe. ';

    IF LTRIM(RTRIM(@Periodo)) = ''
        SET @mensajeError = @mensajeError + 'El periodo no puede estar vacio.';

    IF LTRIM(RTRIM(@Tipo)) = ''
        SET @mensajeError = @mensajeError + 'El tipo no puede estar vacio.';

    IF @Minuto IS NULL
        SET @mensajeError = @mensajeError + 'El minuto no puede ser nulo';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Gol
    SET PartidoID = @PartidoID, PersonaID = @PersonaID, AsistentePersonaID = @AsistentePersonaID, Periodo = @Periodo, Tipo = @Tipo, Minuto = @Minuto
    WHERE GolID = @GolID;

    PRINT 'Gol modificado exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Gol
    @GolID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Gol WHERE GolID = @GolID)
        SET @mensajeError = 'El ID del gol a eliminar no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Gol
    WHERE GolID = @GolID;

    PRINT 'Gol eliminado exitosamente.';
END


-- ====================================================================
-- PLANTILLA ABM: Tabla Tarjeta Asignada
-- ====================================================================
CREATE OR ALTER PROCEDURE reglamento.SP_Alta_TarjetaAsignada
    @TarjetaID INT,
    @PartidoID INT,
    @PersonaID INT,
    @Minuto INT,
    @Motivo VARCHAR (100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID)
        SET @mensajeError = 'El ID de de la tarjeta a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'El ID de del partido a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El ID de de la persona a modificar no existe. ';

    IF @Minuto IS NULL OR @Minuto < 0
        SET @mensajeError = @mensajeError + 'El minuto no puede ser nulo o negativo.';

    IF LTRIM(RTRIM(@Motivo)) = ''
        SET @mensajeError = @mensajeError + 'El motivo es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO reglamento.TarjetaAsignada (TarjetaID, PartidoID, PersonaID, Minuto, Motivo)
    VALUES (@TarjetaID, @PartidoID, @PersonaID, @Minuto, @Motivo);

    PRINT 'Tarjeta asignada registrada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Modificacion_TarjetaAsignada
    @TarjetaAsignadaID INT,
    @TarjetaID INT,
    @PartidoID INT,
    @PersonaID INT,
    @Minuto INT,
    @Motivo VARCHAR (100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.TarjetaAsignada WHERE TarjetaAsignadaID = @TarjetaAsignadaID)
        SET @mensajeError = 'El ID de la tarjeta asignada a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID)
        SET @mensajeError = @mensajeError + 'El ID de la tarjeta a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
        SET @mensajeError = @mensajeError + 'El ID del partido a modificar no existe. ';

    IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'El ID de la persona a modificar no existe. ';

    IF @Minuto IS NULL OR @Minuto < 0
        SET @mensajeError = @mensajeError + 'El minuto no puede ser nulo o negativo.';

    IF LTRIM(RTRIM(@Motivo)) = ''
        SET @mensajeError = @mensajeError + 'El motivo es obligatorio.';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE reglamento.TarjetaAsignada
    SET TarjetaID = @TarjetaID, PartidoID = @PartidoID, PersonaID = @PersonaID, Minuto = @Minuto, Motivo = @Motivo
    WHERE TarjetaAsignadaID = @TarjetaAsignadaID;

    PRINT 'Tarjeta asignada modificada exitosamente.';
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Baja_TarjetaAsignada
    @TarjetaAsignadaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM reglamento.TarjetaAsignada WHERE TarjetaAsignadaID = @TarjetaAsignadaID)
        SET @mensajeError = 'El ID de la tarjeta asignada a eliminar no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM reglamento.TarjetaAsignada
    WHERE TarjetaAsignadaID = @TarjetaAsignadaID;

    PRINT 'Tarjeta asginada eliminada exitosamente.';
END


-- Pais

CREATE OR ALTER PROCEDURE Torneo.SP_Alta_Pais
	@nombre VARCHAR(50),
	@PBI DECIMAL(9,2),
	@husoHorario VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF LTRIM(RTRIM(@nombre)) = ''
		SET @mensajeError = @mensajeError + 'El nombre del pais es obligatorio. '

	IF EXISTS (SELECT 1 FROM torneo.Pais WHERE Nombre = @nombre)
		SET @mensajeError = @mensajeError + 'El pais ya se encuentra rergistrado. '

	IF LEN(@mensajeError) > 0
	BEGIN
		RAISERROR (@mensajeError, 16, 1)
		RETURN
	END

	INSERT INTO Torneo.Pais (Nombre, PBI, HusoHorario)
	VALUES (@nombre, @PBI, @husoHorario)

	PRINT 'Pais registrado exitosamente.'
END
GO

CREATE OR ALTER PROCEDURE Torneo.SP_Modificacion_Pais
	@PaisID INT,
	@nombre VARCHAR(50),
	@PBI DECIMAL(9,2),
	@husoHorario VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM Torneo.Pais WHERE PaisID = @PaisID)
		SET @mensajeError = @mensajeError + 'El ID del pais a modificar no existe. '

	IF LTRIM(RTRIM(@nombre)) = ''
		SET @mensajeError = @mensajeError + 'El nombre del pais no debe estar vacio. '

	IF LEN(@mensajeError) > 0
	BEGIN
		RAISERROR(@mensajeError, 16, 1)
		RETURN
	END

	UPDATE Torneo.Pais
	SET Nombre = @nombre,
		PBI = @PBI,
		HusoHorario = @husoHorario
	WHERE PaisID = @PaisID

	PRINT 'Pais modificado exitosamente.'
END
GO

CREATE OR ALTER PROCEDURE Torneo.SP_Baja_Pais
	@PaisID INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM Torneo.Pais WHERE PaisID = @PaisID)
		SET @mensajeError = @mensajeError + 'El ID  del pais a eliminar no existe. '

	IF EXISTS (SELECT 1 FROM Publicidad.InteresPublicitario WHERE PaisID = @PaisID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar el pais porque ya tiene un interes publicitario registrado. '
	
	IF LEN(@mensajeError) > 0
	BEGIN
		RAISERROR(@mensajeError, 16, 1)
		RETURN
	END

	DELETE FROM Torneo.Pais WHERE PaisID = @PaisID

	PRINT 'Pais elminado exitosamente'
END
GO

-- Tarjeta

CREATE OR ALTER PROCEDURE reglamento.SP_Alta_Tarjeta
	@tipo VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF LTRIM(RTRIM(@tipo)) = ''
		SET @mensajeError = @mensajeError + 'El tipo de la tarjeta es obligatorio. '

	IF EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE Tipo = @tipo)
		SET @mensajeError = @mensajeError + 'El tipo de tarjeta ya se encuentra registrado. '

	IF LEN(@mensajeError) > 0
	BEGIN
		RAISERROR (@mensajeError, 16, 1)
		RETURN
	END

	INSERT INTO reglamento.Tarjeta (Tipo)
	VALUES (@tipo)

	PRINT 'Tarjeta registrada exitosamente.'
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Modificacion_Tarjeta
	@TarjetaID INT,
	@tipo VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID)
		SET @mensajeError = @mensajeError + 'El id de la tarjeta no existe. '

	IF LTRIM(RTRIM(@tipo)) = ''
		SET @mensajeError = @mensajeError + 'El tipo de tarjeta no puede quedar vacio. '

	UPDATE reglamento.Tarjeta
	SET Tipo = @tipo
	WHERE TarjetaID = @TarjetaID

	PRINT 'Tarjeta modificada exitosamente'
END
GO

CREATE OR ALTER PROCEDURE reglamento.SP_Baja_Tarjeta
	@TarjetaID INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID)
		SET @mensajeError = @mensajeError + 'La tarjeta no existe. '

	IF EXISTS (SELECT 1 FROM reglamento.TarjetaAsignada WHERE TarjetaID = @TarjetaID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar. Hay partidos que ya la tienen registrada y jugadores que a las que se le asigno'

	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID
    PRINT 'Tarjeta eliminada exitosamente.'
END
GO

-- Convocatoria

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Convocatoria
	@SeleccionID INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
		SET @mensajeError = @mensajeError + 'La seleccion ingresada no existe. '

	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	INSERT INTO torneo.Convocatoria (SeleccionID)
	VALUES (@SeleccionID)

	PRINT 'Convocatoria registrada exitosamente'
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Convocatoria
	@ConvocatoriaID INT,
	@SeleccionID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Convocatoria WHERE ConvocatoriaID = @ConvocatoriaID)
		SET @mensajeError = @mensajeError + 'La convocatoria no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
		SET @mensajeError = @mensajeError + 'La seleccion no existe. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	UPDATE torneo.Convocatoria
	SET SeleccionID = @SeleccionID
	WHERE ConvocatoriaID = @ConvocatoriaID
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Convocatoria
	@ConvocatoriaID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @mensajeError VARCHAR(MAX) = '';

	IF NOT EXISTS (SELECT 1 FROM torneo.Convocatoria WHERE ConvocatoriaID = @ConvocatoriaID)
		SET @mensajeError = @mensajeError + 'La convocatoria no existe'
    
	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1)
        RETURN
    
	END
    DELETE FROM torneo.Convocatoria WHERE ConvocatoriaID = @ConvocatoriaID
    PRINT 'Convocatoria eliminada exitosamente.';
END
GO

-- Cuerpo Tecnico

CREATE OR ALTER PROCEDURE torneo.SP_Alta_CuerpoTecnico
	@PersonaID INT,
	@SeleccionID INT,
	@rol VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
		SET @mensajeError = @mensajeError + 'La persona no existe.'

	IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
		SET @mensajeError = @mensajeError + 'La seleccion no existe. '

	IF EXISTS (SELECT 1 FROM torneo.CuerpoTecnico WHERE PersonaID = @PersonaID AND SeleccionID = @SeleccionID)
		SET @mensajeError = @mensajeError + 'La persona ya esta asignada a esa seleccion. '

	IF LTRIM(RTRIM(@rol)) = ''
		SET @mensajeError = @mensajeError + 'El rol es obligatorio. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	INSERT INTO torneo.CuerpoTecnico (PersonaID, SeleccionID, Rol)
	VALUES (@PersonaID, @SeleccionID, @rol)

	PRINT 'Cuerpo Tecnico registrado exitosamente'
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_CuerpoTecnico
	@PersonaID INT,
	@SeleccionID INT,
	@SeleccionAnterior INT,
	@rol VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
		SET @mensajeError = @mensajeError + 'La persona no existe.'

	IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionAnterior)
		SET @mensajeError = @mensajeError + 'La seleccion original no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.CuerpoTecnico WHERE PersonaID = @PersonaID AND SeleccionID = @SeleccionAnterior)
		SET @mensajeError = @mensajeError + 'No existe esa persona asignada a la seleccion original'

	IF NOT EXISTS (SELECT 1 FROM torneo.Seleccion WHERE SeleccionID = @SeleccionID)
		SET @mensajeError = @mensajeError + 'La seleccion nueva no existe. '

	IF LTRIM(RTRIM(@rol)) = ''
		SET @mensajeError = @mensajeError + 'El rol es obligatorio. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	UPDATE torneo.CuerpoTecnico 
	SET  SeleccionID = @SeleccionID, 
		Rol = @rol
	WHERE PersonaID = @PersonaID AND SeleccionID = @SeleccionAnterior

	PRINT 'Cuerpo Tecnico modificado exitosamente'
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_CuerpoTecnico
	@PersonaID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
		SET @mensajeError = @mensajeError + 'La persona no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.CuerpoTecnico WHERE PersonaID = @PersonaID)
		SET @mensajeError = @mensajeError + 'La persona no pertenece al cuerpo tecnico. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	DELETE FROM torneo.CuerpoTecnico WHERE PersonaID = @PersonaID

	PRINT 'Cuerpo Tecnico eliminado exitosamente'
END
GO

-- Campaña

-- Partido

-- Sustiticion (Cruza partido y 2 jugadores)

-- ALTA PERSONA
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Persona
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @FechaNacimiento DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        SET @mensajeError = @mensajeError + 'El nombre es obligatorio. ';

    IF @Apellido IS NULL OR LTRIM(RTRIM(@Apellido)) = ''
        SET @mensajeError = @mensajeError + 'El apellido es obligatorio. ';

    IF @FechaNacimiento IS NULL
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento es obligatoria. ';

    IF @FechaNacimiento > CAST(GETDATE() AS DATE)
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento no puede ser futura. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Persona (Nombre, Apellido, FechaNacimiento)
    VALUES (@Nombre, @Apellido, @FechaNacimiento);

    PRINT 'Persona registrada exitosamente.';
END
GO

-- MODIFICACION PERSONA
CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Persona
    @PersonaID INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @FechaNacimiento DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'La persona no existe. ';

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        SET @mensajeError = @mensajeError + 'El nombre es obligatorio. ';

    IF @Apellido IS NULL OR LTRIM(RTRIM(@Apellido)) = ''
        SET @mensajeError = @mensajeError + 'El apellido es obligatorio. ';

    IF @FechaNacimiento IS NULL
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento es obligatoria. ';

    IF @FechaNacimiento > CAST(GETDATE() AS DATE)
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento no puede ser futura. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Persona
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        FechaNacimiento = @FechaNacimiento
    WHERE PersonaID = @PersonaID;

    PRINT 'Persona modificada exitosamente.';
END
GO

-- BAJA PERSONA
CREATE OR ALTER PROCEDURE torneo.SP_Baja_Persona
    @PersonaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'La persona no existe. ';

    IF EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La persona es un jugador. ';

    IF EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La persona es un arbitro. ';

    IF EXISTS (SELECT 1 FROM torneo.CuerpoTecnico WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La persona pertenece a un cuerpo tecnico. ';

    IF EXISTS (SELECT 1 FROM torneo.PersonaHabla WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La persona tiene idiomas asociados. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Persona
    WHERE PersonaID = @PersonaID;

    PRINT 'Persona eliminada exitosamente.';
END
GO

-- ALTA FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Formacion
    @EsquemaTactico VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF @EsquemaTactico IS NULL OR LTRIM(RTRIM(@EsquemaTactico)) = ''
        SET @mensajeError = @mensajeError + 'El esquema tactico es obligatorio. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Formacion (EsquemaTactico)
    VALUES (@EsquemaTactico);

    PRINT 'Formacion registrada exitosamente.';
END
GO

-- MODIFICACION FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Formacion
    @FormacionID INT,
    @EsquemaTactico VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1
        FROM torneo.Formacion
        WHERE FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La formacion no existe. ';

    IF @EsquemaTactico IS NULL OR LTRIM(RTRIM(@EsquemaTactico)) = ''
        SET @mensajeError = @mensajeError + 'El esquema tactico es obligatorio. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Formacion
    SET EsquemaTactico = @EsquemaTactico
    WHERE FormacionID = @FormacionID;

    PRINT 'Formacion modificada exitosamente.';
END
GO

-- BAJA FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Baja_Formacion
    @FormacionID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1
        FROM torneo.Formacion
        WHERE FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La formacion no existe. ';

    IF EXISTS (
        SELECT 1
        FROM torneo.TieneFormacion
        WHERE FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La formacion esta asignada a un partido. ';

    IF EXISTS (
        SELECT 1
        FROM torneo.Participa
        WHERE FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La formacion tiene jugadores asociados. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Formacion
    WHERE FormacionID = @FormacionID;

    PRINT 'Formacion eliminada exitosamente.';
END
GO

-- ALTA JUGADOR
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Jugador
    @PersonaID INT,
    @ClubOrigen VARCHAR(50),
    @Dorsal INT,
    @PosicionHabitual VARCHAR(50),
    @ConvocatoriaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Persona
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'La persona no existe. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Jugador
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'La persona ya esta registrada como jugador. ';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Convocatoria
        WHERE ConvocatoriaID = @ConvocatoriaID
    )
        SET @mensajeError = @mensajeError + 'La convocatoria no existe. ';

    IF @ClubOrigen IS NULL OR LTRIM(RTRIM(@ClubOrigen)) = ''
        SET @mensajeError = @mensajeError + 'El club de origen es obligatorio. ';

    IF @PosicionHabitual IS NULL OR LTRIM(RTRIM(@PosicionHabitual)) = ''
        SET @mensajeError = @mensajeError + 'La posicion habitual es obligatoria. ';

    IF @Dorsal IS NULL OR @Dorsal <= 0
        SET @mensajeError = @mensajeError + 'El dorsal debe ser mayor a cero. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Jugador
        WHERE ConvocatoriaID = @ConvocatoriaID
          AND Dorsal = @Dorsal
    )
        SET @mensajeError = @mensajeError + 'El dorsal ya esta asignado en esta convocatoria. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.Jugador
        (PersonaID, ClubOrigen, Dorsal, PosicionHabitual, ConvocatoriaID)
    VALUES
        (@PersonaID, @ClubOrigen, @Dorsal, @PosicionHabitual, @ConvocatoriaID);

    PRINT 'Jugador registrado exitosamente.';
END
GO

-- MODIFICACION JUGADOR
CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Jugador
    @PersonaID INT,
    @ClubOrigen VARCHAR(50),
    @Dorsal INT,
    @PosicionHabitual VARCHAR(50),
    @ConvocatoriaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Jugador
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'El jugador no existe. ';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Convocatoria
        WHERE ConvocatoriaID = @ConvocatoriaID
    )
        SET @mensajeError = @mensajeError + 'La convocatoria no existe. ';

    IF @ClubOrigen IS NULL OR LTRIM(RTRIM(@ClubOrigen)) = ''
        SET @mensajeError = @mensajeError + 'El club de origen es obligatorio. ';

    IF @PosicionHabitual IS NULL OR LTRIM(RTRIM(@PosicionHabitual)) = ''
        SET @mensajeError = @mensajeError + 'La posicion habitual es obligatoria. ';

    IF @Dorsal IS NULL OR @Dorsal <= 0
        SET @mensajeError = @mensajeError + 'El dorsal debe ser mayor a cero. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Jugador
        WHERE ConvocatoriaID = @ConvocatoriaID
          AND Dorsal = @Dorsal
          AND PersonaID <> @PersonaID
    )
        SET @mensajeError = @mensajeError + 'El dorsal ya esta asignado en esta convocatoria. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.Jugador
    SET ClubOrigen = @ClubOrigen,
        Dorsal = @Dorsal,
        PosicionHabitual = @PosicionHabitual,
        ConvocatoriaID = @ConvocatoriaID
    WHERE PersonaID = @PersonaID;

    PRINT 'Jugador modificado exitosamente.';
END
GO

-- BAJA JUGADOR
CREATE OR ALTER PROCEDURE torneo.SP_Baja_Jugador
    @PersonaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Jugador
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'El jugador no existe. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Participa
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: El jugador participa en una formacion. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Gol
        WHERE PersonaID = @PersonaID
           OR AsistentePersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: El jugador tiene goles o asistencias registrados. ';

    IF EXISTS (
        SELECT 1 FROM torneo.Sustitucion
        WHERE JugadorSaleID = @PersonaID
           OR JugadorEntraID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: El jugador tiene sustituciones registradas. ';

    IF EXISTS (
        SELECT 1 FROM reglamento.Suspension
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: El jugador tiene suspensiones registradas. ';

    IF EXISTS (
        SELECT 1 FROM reglamento.TarjetaAsignada
        WHERE PersonaID = @PersonaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: El jugador tiene tarjetas asignadas. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.Jugador
    WHERE PersonaID = @PersonaID;

    PRINT 'Jugador eliminado exitosamente.';
END
GO

-- ALTA TIENE FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Alta_TieneFormacion
    @PartidoID INT,
    @FormacionID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Partido
        WHERE PartidoID = @PartidoID
    )
        SET @mensajeError = @mensajeError + 'El partido no existe. ';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Formacion
        WHERE FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La formacion no existe. ';

    IF EXISTS (
        SELECT 1 FROM torneo.TieneFormacion
        WHERE PartidoID = @PartidoID
          AND FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La formacion ya esta asignada a este partido. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO torneo.TieneFormacion (PartidoID, FormacionID)
    VALUES (@PartidoID, @FormacionID);

    PRINT 'Formacion asignada al partido exitosamente.';
END
GO

-- MODIFICACION TIENE FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_TieneFormacion
    @PartidoID INT,
    @FormacionID INT,
    @NuevoPartidoID INT,
    @NuevaFormacionID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.TieneFormacion
        WHERE PartidoID = @PartidoID
          AND FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La asignacion original no existe. ';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Partido
        WHERE PartidoID = @NuevoPartidoID
    )
        SET @mensajeError = @mensajeError + 'El nuevo partido no existe. ';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Formacion
        WHERE FormacionID = @NuevaFormacionID
    )
        SET @mensajeError = @mensajeError + 'La nueva formacion no existe. ';

    IF EXISTS (
        SELECT 1 FROM torneo.TieneFormacion
        WHERE PartidoID = @NuevoPartidoID
          AND FormacionID = @NuevaFormacionID
          AND NOT (
              PartidoID = @PartidoID
              AND FormacionID = @FormacionID
          )
    )
        SET @mensajeError = @mensajeError + 'La nueva asignacion ya existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE torneo.TieneFormacion
    SET PartidoID = @NuevoPartidoID,
        FormacionID = @NuevaFormacionID
    WHERE PartidoID = @PartidoID
      AND FormacionID = @FormacionID;

    PRINT 'Asignacion de formacion modificada exitosamente.';
END
GO

-- BAJA TIENE FORMACION
CREATE OR ALTER PROCEDURE torneo.SP_Baja_TieneFormacion
    @PartidoID INT,
    @FormacionID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM torneo.TieneFormacion
        WHERE PartidoID = @PartidoID
          AND FormacionID = @FormacionID
    )
        SET @mensajeError = @mensajeError + 'La asignacion no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM torneo.TieneFormacion
    WHERE PartidoID = @PartidoID
      AND FormacionID = @FormacionID;

    PRINT 'Asignacion de formacion eliminada exitosamente.';
END
GO

-- ALTA PIEZA PUBLICITARIA
CREATE OR ALTER PROCEDURE publicidad.SP_Alta_PiezaPublicitaria
    @Contenido VARCHAR(50),
    @Tarifa DECIMAL(10,2),
    @Idioma VARCHAR(50),
    @CampañaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF @Contenido IS NULL OR LTRIM(RTRIM(@Contenido)) = ''
        SET @mensajeError = @mensajeError + 'El contenido es obligatorio. ';

    IF @Tarifa IS NULL OR @Tarifa < 0
        SET @mensajeError = @mensajeError + 'La tarifa debe ser mayor o igual a cero. ';

    IF @Idioma IS NULL OR LTRIM(RTRIM(@Idioma)) = ''
        SET @mensajeError = @mensajeError + 'El idioma es obligatorio. ';

    IF NOT EXISTS (
        SELECT 1 FROM publicidad.Campaña
        WHERE CampañaID = @CampañaID
    )
        SET @mensajeError = @mensajeError + 'La campaña no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    INSERT INTO publicidad.PiezaPublicitaria
        (Contenido, Tarifa, Idioma, CampañaID)
    VALUES
        (@Contenido, @Tarifa, @Idioma, @CampañaID);

    PRINT 'Pieza publicitaria registrada exitosamente.';
END
GO

-- MODIFICACION PIEZA PUBLICITARIA
CREATE OR ALTER PROCEDURE publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID INT,
    @Contenido VARCHAR(50),
    @Tarifa DECIMAL(10,2),
    @Idioma VARCHAR(50),
    @CampañaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM publicidad.PiezaPublicitaria
        WHERE PiezaID = @PiezaID
    )
        SET @mensajeError = @mensajeError + 'La pieza publicitaria no existe. ';

    IF @Contenido IS NULL OR LTRIM(RTRIM(@Contenido)) = ''
        SET @mensajeError = @mensajeError + 'El contenido es obligatorio. ';

    IF @Tarifa IS NULL OR @Tarifa < 0
        SET @mensajeError = @mensajeError + 'La tarifa debe ser mayor o igual a cero. ';

    IF @Idioma IS NULL OR LTRIM(RTRIM(@Idioma)) = ''
        SET @mensajeError = @mensajeError + 'El idioma es obligatorio. ';

    IF NOT EXISTS (
        SELECT 1 FROM publicidad.Campaña
        WHERE CampañaID = @CampañaID
    )
        SET @mensajeError = @mensajeError + 'La campaña no existe. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    UPDATE publicidad.PiezaPublicitaria
    SET Contenido = @Contenido,
        Tarifa = @Tarifa,
        Idioma = @Idioma,
        CampañaID = @CampañaID
    WHERE PiezaID = @PiezaID;

    PRINT 'Pieza publicitaria modificada exitosamente.';
END
GO

-- BAJA PIEZA PUBLICITARIA
CREATE OR ALTER PROCEDURE publicidad.SP_Baja_PiezaPublicitaria
    @PiezaID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (
        SELECT 1 FROM publicidad.PiezaPublicitaria
        WHERE PiezaID = @PiezaID
    )
        SET @mensajeError = @mensajeError + 'La pieza publicitaria no existe. ';

    IF EXISTS (
        SELECT 1 FROM publicidad.Exhibicion
        WHERE PiezaID = @PiezaID
    )
        SET @mensajeError = @mensajeError + 'No se puede eliminar: La pieza publicitaria tiene exhibiciones asociadas. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

    DELETE FROM publicidad.PiezaPublicitaria
    WHERE PiezaID = @PiezaID;

    PRINT 'Pieza publicitaria eliminada exitosamente.';
END
GO