
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

	IF EXISTS (SELECT 1 FROM torneo.Pais WHERE Nombre = @nombre)
		SET @mensajeError = @mensajeError + 'El nombre del pais ya se encuentra registrado. '

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
	@tipo VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM reglamento.Tarjeta WHERE TarjetaID = @TarjetaID)
		SET @mensajeError = @mensajeError + 'El id de la tarjeta no existe. '

	IF LTRIM(RTRIM(@tipo)) = ''
		SET @mensajeError = @mensajeError + 'El tipo de tarjeta no puede quedar vacio. '

	IF LEN(@mensajeError) > 0
	BEGIN
		RAISERROR (@mensajeError, 16, 1)
		RETURN
	END

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
		SET @mensajeError = @mensajeError + 'La persona no existe. '

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

CREATE OR ALTER PROCEDURE publicidad.SP_Alta_Campaña
	@nombre VARCHAR(30),
	@fechaInicio DATE,
	@AnuncianteID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF LTRIM(RTRIM(@nombre)) = ''
		SET @mensajeError = @mensajeError + 'El nombre es obligatorio. '

	IF NOT EXISTS (SELECT 1 FROM publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
		SET @mensajeError = @mensajeError + 'El anunciate no existe'

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	INSERT INTO publicidad.Campaña (Nombre, FechaInicio, AnuncianteID)
	VALUES (@nombre, @fechaInicio, @AnuncianteID)

	PRINT 'Campaña registrada exitosamente'
END
GO

CREATE OR ALTER PROCEDURE publicidad.SP_Modificacion_Campaña
	@CampañaID INT, 
	@Nombre VARCHAR(30),
	@fechaInicio DATE,
	@AnuncianteID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM publicidad.Campaña WHERE CampañaID = @CampañaID)
		SET @mensajeError = @mensajeError + 'La campaña no existe. '

	IF LTRIM(RTRIM(@nombre)) = ''
		SET @mensajeError = @mensajeError + 'El nombre es obligatorio. '

	IF NOT EXISTS (SELECT 1 FROM publicidad.Anunciante WHERE AnuncianteID = @AnuncianteID)
		SET @mensajeError = @mensajeError + 'El anunciante no existe'

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	UPDATE publicidad.Campaña
	SET Nombre = @Nombre, FechaInicio = @fechaInicio, AnuncianteID = @AnuncianteID
	WHERE CampañaID = @CampañaID
END
GO

CREATE OR ALTER PROCEDURE publicidad.SP_Baja_Campaña
	@CampañaID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM publicidad.Campaña WHERE CampañaID = @CampañaID)
		SET @mensajeError = @mensajeError + 'La campaña no existe. '

	IF EXISTS (SELECT 1 FROM publicidad.PiezaPublicitaria WHERE CampañaID = @CampañaID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar porque cuenta con una pieza publicitaria asociada'
    
	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END
	
	DELETE publicidad.Campaña WHERE CampañaID = @CampañaID
	PRINT 'Campaña eliminada exitosamente'
END
GO

-- Partido

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Partido
	@SedeID INT,
	@Fase VARCHAR(50),
	@Asistencia INT,
	@ResultadoFinal VARCHAR(50),
	@FechaHoraLocal DATETIME,
	@FechaHoraUTC DATETIME
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Sede WHERE SedeID = @SedeID)
		SET @mensajeError = @mensajeError + 'La sede no existe. '

	IF LTRIM(RTRIM(@Fase)) = ''
		SET @mensajeError = @mensajeError + 'La fase es obligatoria. '

	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	INSERT INTO torneo.Partido (SedeID, Fase, Asistencia, ResultadoFinal, FechaHoraLocal, FechaHoraUTC)
	VALUES (@SedeID, @Fase, @Asistencia, @ResultadoFinal, @FechaHoraLocal, @FechaHoraUTC)
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Partido
	@PartidoID INT,
	@SedeID INT,
	@Fase VARCHAR(50),
	@Asistencia INT,
	@ResultadoFinal VARCHAR(20),
	@fechaHoraLocal DATETIME,
	@fechaHoraUTC DATETIME
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'El partido no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Sede WHERE SedeID = @SedeID)
		SET @mensajeError = @mensajeError + 'La sede no existe. '

	IF LTRIM(RTRIM(@Fase)) = ''
		SET @mensajeError = @mensajeError + 'La fase es obligatoria'

	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	UPDATE torneo.Partido
	SET SedeID = @SedeID, Fase = @Fase, Asistencia = @Asistencia, ResultadoFinal = @ResultadoFinal, fechaHoraLocal = @fechaHoraLocal, fechaHoraUTC = @fechaHoraUTC
	WHERE PartidoID = @PartidoID
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Partido
	@PartidoID INT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Partido WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'El partido no existe. '

	IF EXISTS (SELECT 1 FROM torneo.Juega WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar porque tiene selecciones asociadas. '

	IF	EXISTS (SELECT 1 FROM torneo.TieneFormacion WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar porque tiene formaciones asociadas. '

	IF EXISTS (SELECT 1 FROM publicidad.CuentaConExhibicion WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'No se puede eliminar porque tiene exhibiciones asociadas. '

	IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END

	DELETE torneo.Partido WHERE PartidoID = @PartidoID
	PRINT 'Partido eliminado exitosamente'
END
GO

-- Sustiticion 

CREATE OR ALTER PROCEDURE torneo.SP_Alta_Sustitucion
	@PartidoID INT,
	@JugadorSaleID INT,
	@JugadorEntraID INT,
	@NumeroVentana INT,
	@Minuto INT,
	@Motivo VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Sustitucion WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'El partido no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @JugadorEntraID)
		SET @mensajeError = @mensajeError + 'El jugador que entra no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @JugadorSaleID)
		SET @mensajeError = @mensajeError + 'El jugador que sale no existe. '

	IF @JugadorEntraID = @JugadorSaleID
		SET @mensajeError = @mensajeError + 'Los jugadores no pueden ser los mismos. '

	IF @NumeroVentana < 0
		SET @mensajeError = @mensajeError + 'El numero de ventana debe ser mayor que cero. '

	IF @Minuto < 0
		SET @mensajeError = @mensajeError + 'El minuto no puede ser negativo. '

	IF LTRIM(RTRIM(@motivo)) = ''
		SET @mensajeError = @mensajeError + 'El motivo no puede ser negativo. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1)
        RETURN
    END

	INSERT INTO torneo.Sustitucion (PartidoID, JugadorSaleID, JugadorEntraID, NumeroVentana, Minuto, Motivo)
	VALUES (@PartidoID, @JugadorSaleID, @JugadorEntraID, @NumeroVentana, @Minuto, @Motivo)

	PRINT 'Sustitucion registrada exitosamente'
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Sustitucion
	@SustitucionID INT,
	@PartidoID INT,
	@JugadorSaleID INT,
	@JugadorEntraID INT,
	@NumeroVentana INT,
	@Minuto INT,
	@Motivo VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @mensajeError VARCHAR(MAX) = ''

	IF NOT EXISTS (SELECT 1 FROM torneo.Sustitucion WHERE SustitucionID = @SustitucionID)
		SET @mensajeError = @mensajeError + 'La sustitucion no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Sustitucion WHERE PartidoID = @PartidoID)
		SET @mensajeError = @mensajeError + 'El partido no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @JugadorEntraID)
		SET @mensajeError = @mensajeError + 'El jugador que entra no existe. '

	IF NOT EXISTS (SELECT 1 FROM torneo.Jugador WHERE PersonaID = @JugadorSaleID)
		SET @mensajeError = @mensajeError + 'El jugador que sale no existe. '

	IF @JugadorEntraID = @JugadorSaleID
		SET @mensajeError = @mensajeError + 'Los jugadores no pueden ser los mismos. '

	IF @NumeroVentana < 0
		SET @mensajeError = @mensajeError + 'El numero de ventana debe ser mayor que cero. '

	IF @Minuto < 0
		SET @mensajeError = @mensajeError + 'El minuto no puede ser negativo. '

	IF LTRIM(RTRIM(@motivo)) = ''
		SET @mensajeError = @mensajeError + 'El motivo no puede ser negativo. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1)
        RETURN
    END

	INSERT INTO torneo.Sustitucion (PartidoID, JugadorSaleID, JugadorEntraID, NumeroVentana, Minuto, Motivo)
	VALUES (@PartidoID, @JugadorSaleID, @JugadorEntraID, @NumeroVentana, @Minuto, @Motivo)

	PRINT 'Sustitucion modificada exitosamente'
END
GO

CREATE OR ALTER PROCEDURE torneo.SP_Baja_Sustitucion
    @SustitucionID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @mensajeError VARCHAR(MAX) = ''

    IF NOT EXISTS (
        SELECT 1 FROM torneo.Sustitucion
        WHERE SustitucionID = @SustitucionID
    )
        SET @mensajeError = @mensajeError + 'La sustitucion no existe. '

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1)
        RETURN
    END

    DELETE FROM torneo.Sustitucion
    WHERE SustitucionID = @SustitucionID

    PRINT 'Sustitucion eliminada exitosamente.'
END
GO