
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Store Procedure



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
        SET @mensajeError = @mensajeError + 'El nombre del Idioma no puede quedar vacío. ';

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
        SET @mensajeError = @mensajeError + 'El nombre del pais no puede quedar vacío. ';

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

    IF EXISTS (SELECT 1 FROM publicidad.Campaña WHERE AnuncianteID = @AnuncianteID)
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
        SET @mensajeError = @mensajeError + 'El nombre del estadio no puede quedar vacío. ';

    IF LTRIM(RTRIM(@RolArbitral)) = ''
        SET @mensajeError = @mensajeError + 'El rol del arbitro no puede quedar vacío. ';

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