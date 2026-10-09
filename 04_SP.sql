
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Stored Procedures ABM

USE DB_Mundial_2026
GO

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