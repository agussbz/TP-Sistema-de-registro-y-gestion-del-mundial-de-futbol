
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Store Procedure

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
