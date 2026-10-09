
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de tablas y restricciones

use DB_Mundial_2026
go

--==============================
--  Tablas del esquema TORNEO
--==============================

--Tabla SEDE
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Sede')
BEGIN
	CREATE TABLE torneo.Sede (
	SedeID INT identity(1,1) NOT NULL,
	NombreEstadio VARCHAR(70) NOT NULL,
	Ciudad VARCHAR(100) NOT NULL,
	Pais VARCHAR(50),
	Capacidad INT NOT NULL check (Capacidad>0),
	HusoHorario VARCHAR(50) NOT NULL,

	constraint pk_Sede primary key clustered (SedeID)
	)
END
GO

--Tabla PARTIDO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Partido')
BEGIN
	CREATE TABLE torneo.Partido (
	PartidoID INT identity (1, 1) NOT NULL,
	SedeID INT NOT NULL,
	Fase VARCHAR(50) NOT NULL,
	Asistencia INT,
	ResultadoFinal VARCHAR (20),
	fechaHoraLocal DATETIME NOT NULL,
    fechaHoraUTC DATETIME NOT NULL,

	constraint pk_Partido primary key clustered (PartidoID),
	constraint fk_Partido_Sede foreign key (SedeID) REFERENCES torneo.Sede (SedeID),
	)
END
GO

-- Tabla SELECCION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Seleccion')
BEGIN
	CREATE TABLE torneo.Seleccion (
	SeleccionID INT identity(1,1) NOT NULL,
	Pais VARCHAR(50) NOT NULL,
	Confederacion VARCHAR(50) NOT NULL,

	constraint pk_Seleccion primary key clustered (SeleccionID)
	)
END
GO

--Tabla JUEGA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'Torneo' AND TABLE_NAME = 'Juega')
BEGIN
    CREATE TABLE Torneo.Juega
    (
        PartidoID INT NOT NULL,
        SeleccionID INT NOT NULL,
        CONSTRAINT PK_Juega PRIMARY KEY (PartidoID, SeleccionID),
        CONSTRAINT FK_Juega_Partido FOREIGN KEY (PartidoID) REFERENCES Torneo.Partido (PartidoID),
        CONSTRAINT FK_Juega_Seleccion FOREIGN KEY (SeleccionID) REFERENCES Torneo.Seleccion (SeleccionID),
    )
END
GO

-- Tabla CONVOCATORIA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Convocatoria')
BEGIN
	CREATE TABLE Torneo.Convocatoria (
	ConvocatoriaID INT identity (1, 1) NOT NULL,
	SeleccionID INT NOT NULL,

	constraint pk_Convocatoria primary key clustered (ConvocatoriaID),
	constraint fk_Convocatoria_Seleccion foreign key (SeleccionID) REFERENCES torneo.Seleccion (SeleccionID)
	)
END
GO

-- Tabla PERSONA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Persona')
BEGIN
	CREATE TABLE Torneo.Persona (
    PersonaID INT identity (1, 1) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	FechaNacimiento DATE NOT NULL,

	constraint pk_Persona primary key clustered (PersonaID)
	)
END
GO

-- Tabla CUERPO TECNICO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'CuerpoTecnico')
BEGIN
    CREATE TABLE torneo.CuerpoTecnico (
    PersonaID INT NOT NULL,
    SeleccionID INT NOT NULL,
    Rol VARCHAR(50) NOT NULL,

    constraint pk_CuerpoTecnico primary key clustered (PersonaID),
    constraint fk_CuerpoTecnico_Persona foreign key (PersonaID) REFERENCES torneo.Persona (PersonaID),
    constraint fk_CuerpoTecnico_Seleccion foreign key (SeleccionID) REFERENCES torneo.Seleccion (SeleccionID)
    )
END
GO

-- Tabla JUGADOR
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Jugador')
BEGIN
    CREATE TABLE torneo.Jugador (
    PersonaID INT NOT NULL,
    ClubOrigen VARCHAR(50) NOT NULL,
    Dorsal INT NOT NULL,
    PosicionHabitual VARCHAR(50) NOT NULL,
    ConvocatoriaID INT NOT NULL,

    constraint pk_Jugador primary key clustered (PersonaID),
    constraint fk_Jugador_Persona foreign key (PersonaID) REFERENCES torneo.Persona (PersonaID),
    constraint fk_Jugador_Convocatoria foreign key (ConvocatoriaID) REFERENCES torneo.Convocatoria (ConvocatoriaID)
    )
END
GO

-- Tabla FORMACION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Formacion')
BEGIN
    CREATE TABLE Torneo.Formacion
    (
        FormacionID INT IDENTITY(1,1) NOT NULL,
        EsquemaTactico VARCHAR(50) NOT NULL,
        CONSTRAINT PK_Formacion PRIMARY KEY CLUSTERED (FormacionID)
    )
END
GO

--Tabla TIENE FORMACION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'Torneo' AND TABLE_NAME = 'TieneFormacion')
BEGIN
    CREATE TABLE Torneo.TieneFormacion
    (
        PartidoID INT NOT NULL,
        FormacionID INT NOT NULL,
        CONSTRAINT PK_TieneFormacion PRIMARY KEY (PartidoID, FormacionID),
        CONSTRAINT FK_TieneFormacion_Partido FOREIGN KEY (PartidoID) REFERENCES Torneo.Partido (PartidoID),
        CONSTRAINT FK_TieneFormacion_Formacion FOREIGN KEY (FormacionID) REFERENCES Torneo.Formacion (FormacionID)
    )
END
GO

-- Tabla PARTICIPA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Participa')
BEGIN
    CREATE TABLE torneo.Participa (
    FormacionID INT NOT NULL,
    PersonaID INT NOT NULL,
    Titular BIT NOT NULL,
    PosicionCancha VARCHAR(50) NOT NULL,

    constraint pk_Participa primary key clustered (FormacionID, PersonaID),
    constraint fk_Participa_Formacion foreign key (FormacionID) REFERENCES torneo.Formacion(FormacionID),
    constraint fk_Participa_Jugador foreign key (PersonaID) REFERENCES torneo.Jugador(PersonaID)
    )
END
GO

-- Tabla GOL
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Gol')
BEGIN
    CREATE TABLE torneo.Gol (
    GolID INT IDENTITY(1,1) NOT NULL,
    PartidoID INT NOT NULL,
    PersonaID INT NOT NULL,
    AsistentePersonaID INT NULL,
    Periodo VARCHAR(30) NOT NULL,
    Tipo VARCHAR(30) NOT NULL,
    Minuto INT NOT NULL,

    constraint pk_Gol primary key clustered (GolID),
    constraint fk_Gol_Partido foreign key (PartidoID) REFERENCES torneo.Partido(PartidoID),
    constraint fk_Gol_Jugador foreign key (PersonaID) REFERENCES torneo.Jugador(PersonaID),
    constraint fk_Gol_Asistente foreign key (AsistentePersonaID) REFERENCES torneo.Jugador(PersonaID),
    constraint ck_Gol_Minuto check (Minuto >= 0)
    )
END
GO

-- Tabla SUSTITUCION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Sustitucion')
BEGIN
    CREATE TABLE torneo.Sustitucion (
    SustitucionID INT IDENTITY(1,1) NOT NULL,
    PartidoID INT NOT NULL,
    JugadorSaleID INT NOT NULL,
    JugadorEntraID INT NOT NULL,
    NumeroVentana INT NULL,
    Minuto INT NOT NULL,
    Motivo VARCHAR(20) NOT NULL,

    constraint pk_Sustitucion primary key clustered (SustitucionID),
    constraint fk_Sustitucion_Partido foreign key (PartidoID) REFERENCES torneo.Partido(PartidoID),
    constraint fk_Sustitucion_JugadorSale foreign key (JugadorSaleID) REFERENCES torneo.Jugador(PersonaID),
    constraint fk_Sustitucion_JugadorEntra foreign key (JugadorEntraID) REFERENCES torneo.Jugador(PersonaID),

    constraint ck_Sustitucion_Jugadores check (JugadorSaleID <> JugadorEntraID),
    constraint ck_Sustitucion_Ventana check (NumeroVentana > 0),
    constraint ck_Sustitucion_Minuto check (Minuto >= 0),
    constraint ck_Sustitucion_Motivo check (Motivo IN ('Tactico', 'Lesion', 'Precaucion'))
    )
END
GO

-- Tabla PAIS
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Pais')
BEGIN
    CREATE TABLE torneo.Pais
    (
        PaisID INT IDENTITY(1,1) NOT NULL,
        Nombre VARCHAR(50) NOT NULL,
        PBI DECIMAL(9,2) NOT NULL,
        HusoHorario VARCHAR(10) NOT NULL,

        CONSTRAINT PK_Pais PRIMARY KEY CLUSTERED (PaisID)
    )
END

-- Tabla IDIOMA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Idioma')
BEGIN
	CREATE TABLE torneo.Idioma (
	IdiomaID INT identity(1, 1) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,

	constraint pk_Idioma primary key clustered (IdiomaID)
	)
END
GO

-- Tabla PERSONAHABLA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'PersonaHabla')
BEGIN
	CREATE TABLE torneo.PersonaHabla (
	PersonaID INT NOT NULL,
	IdiomaID INT NOT NULL,

	constraint pk_PersonaIdioma primary key clustered (PersonaID, IdiomaID),
	constraint fk_PersonaHabla_Persona foreign key (PersonaID) REFERENCES torneo.Persona (PersonaID),
	constraint fk_PersonaHabla_Idioma foreign key (IdiomaID) REFERENCES torneo.Idioma (IdiomaID)
	)
END
GO

--==============================
--  Tablas del esquema reglamento
--==============================

-- Tabla ARBITRO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE 
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'Arbitro')
BEGIN
	CREATE TABLE reglamento.Arbitro (
	PersonaID INT NOT NULL,
	Pais VARCHAR(50) NOT NULL,
	RolArbitral VARCHAR(50) NOT NULL,

	constraint pk_Arbitro primary key clustered (PersonaID),
	constraint fk_Arbitro_Persona foreign key (PersonaID) REFERENCES torneo.Persona (PersonaID)
	)
END
GO

--Tabla TARJETA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'Tarjeta')
BEGIN
    CREATE TABLE reglamento.Tarjeta
    (
        TarjetaID INT IDENTITY(1,1) NOT NULL,
        Tipo VARCHAR(30) NOT NULL,

        CONSTRAINT PK_Tarjeta PRIMARY KEY CLUSTERED (TarjetaID)
    )
END
GO

-- Tabla SANCION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'Sancion')
BEGIN
    CREATE TABLE reglamento.Sancion
    (
        SancionID INT IDENTITY(1,1) NOT NULL,
        Descripcion VARCHAR(50) NOT NULL,
        ArbitroID INT NOT NULL,

        CONSTRAINT PK_Sancion PRIMARY KEY CLUSTERED (SancionID),
        CONSTRAINT FK_Sancion_Arbitro FOREIGN KEY (ArbitroID) REFERENCES reglamento.Arbitro (PersonaID)
    )
END
GO

--TABLA SE DESIGNA ARBITRO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'SeDesignaArbitro')
BEGIN
    CREATE TABLE reglamento.SeDesignaArbitro
    (
        PartidoID INT NOT NULL,
        ArbitroID INT NOT NULL,
        Informe VARCHAR(50) NOT NULL,
        RolArbitral VARCHAR(50) NOT NULL,
        CONSTRAINT PK_SeDesignaArbitro PRIMARY KEY (PartidoID, ArbitroID),
        CONSTRAINT FK_SeDesignaArbitro_Partido FOREIGN KEY (PartidoID) REFERENCES Torneo.Partido(PartidoID),
        CONSTRAINT FK_SeDesignaArbitro_Arbitro FOREIGN KEY (ArbitroID) REFERENCES reglamento.Arbitro(PersonaID)
    )
END
GO

-- Tabla SUSPENSION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'Suspension')
BEGIN
    CREATE TABLE reglamento.Suspension
    (
        SuspensionID INT IDENTITY(1,1) NOT NULL,
        PersonaID INT NOT NULL,
        Motivo VARCHAR(200) NOT NULL,
        PartidosSuspendido INT NOT NULL,

        CONSTRAINT PK_Suspension PRIMARY KEY CLUSTERED (SuspensionID),
        CONSTRAINT FK_Suspension_Jugador FOREIGN KEY (PersonaID) REFERENCES torneo.Jugador (PersonaID),
        CONSTRAINT CK_Suspension_Partidos CHECK (PartidosSuspendido > 0)
    )
END
GO

-- Tabla TARJETA ASIGNADA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'reglamento' AND TABLE_NAME = 'TarjetaAsignada')
BEGIN
    CREATE TABLE reglamento.TarjetaAsignada
    (
        TarjetaAsignadaID INT IDENTITY(1,1) NOT NULL,
        TarjetaID INT NOT NULL,
        PartidoID INT NOT NULL,
        PersonaID INT NOT NULL,
        Minuto INT NOT NULL,
        Motivo VARCHAR (100) NOT NULL,

        CONSTRAINT PK_TarjetaAsignada PRIMARY KEY CLUSTERED (TarjetaAsignadaID),
        CONSTRAINT FK_TA_Tarjeta FOREIGN KEY (TarjetaID) REFERENCES reglamento.Tarjeta (TarjetaID),
        CONSTRAINT FK_TA_Partido FOREIGN KEY (PartidoID) REFERENCES torneo.Partido (PartidoID),
        CONSTRAINT FK_TA_Jugador FOREIGN KEY (PersonaID) REFERENCES torneo.Jugador (PersonaID),
        CONSTRAINT CK_TA_Minuto CHECK (Minuto> 0)
    )
END
GO


--=================================
--  Tablas del esquema PUBLICIDAD
--=================================

-- Tabla ANUNCIANTE
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'Anunciante')
BEGIN
    CREATE TABLE Publicidad.Anunciante 
    (
        AnuncianteID INT identity (1, 1) NOT NULL,
        Pais VARCHAR(50) NOT NULL,

        CONSTRAINT PK_AnuncianteID PRIMARY KEY CLUSTERED (AnuncianteID) 
    );
END
GO

-- Tabla CAMPAÑA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'Campaña')
BEGIN
    CREATE TABLE Publicidad.Campaña
    (
        CampañaID INT IDENTITY(1,1) NOT NULL,
        Nombre VARCHAR(30) NOT NULL,
        FechaInicio DATE NOT NULL,
        AnuncianteID INT NOT NULL,

        CONSTRAINT PK_Campaña PRIMARY KEY CLUSTERED (CampañaID),
        CONSTRAINT FK_Campaña_Anunciante FOREIGN KEY (AnuncianteID) REFERENCES Publicidad.Anunciante (AnuncianteID)
    )
END
GO

-- Tabla PIEZA PUBLICITARIA
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'PiezaPublicitaria')
BEGIN
    CREATE TABLE Publicidad.PiezaPublicitaria
    (
        PiezaID INT IDENTITY(1,1) NOT NULL,
        Contenido VARCHAR(50) NOT NULL,
        Tarifa DECIMAL (10,2) NOT NULL,
        Idioma VARCHAR(50) NOT NULL,
        CampañaID INT NOT NULL,

        CONSTRAINT PK_PiezaPublicitaria PRIMARY KEY CLUSTERED (PiezaID),
        CONSTRAINT FK_PiezaPublicitaria_Campaña FOREIGN KEY (CampañaID) REFERENCES Publicidad.Campaña (CampañaID)
    )
END
GO

-- Tabla INTERES PUBLICITARIO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'InteresPublicitario')
BEGIN
    CREATE TABLE Publicidad.InteresPublicitario 
    (
        InteresID INT identity (1, 1) NOT NULL,
        Prioridad VARCHAR(50) NOT NULL,
        AnuncianteID INT NOT NULL,
        PaisID INT NOT NULL,

        CONSTRAINT PK_InteresPublicitario PRIMARY KEY CLUSTERED (InteresID),
        CONSTRAINT FK_InteresPublicitario_Anunciante FOREIGN KEY (AnuncianteID) REFERENCES Publicidad.Anunciante (AnuncianteID),
        CONSTRAINT FK_InteresPublicitario_Pais FOREIGN KEY (PaisID) REFERENCES Torneo.Pais (PaisID)
    );
END
GO


-- Tabla EXHIBICION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'Exhibicion')
BEGIN
    CREATE TABLE Publicidad.Exhibicion
    (
        ExhibicionID INT IDENTITY(1,1) NOT NULL,
        Espacio VARCHAR(50) NOT NULL,
        PiezaID INT NOT NULL,
        Costo INT NOT NULL,

        CONSTRAINT PK_Exhibicion PRIMARY KEY CLUSTERED (ExhibicionID),
        CONSTRAINT FK_Exhibicion_PiezaPublicitaria FOREIGN KEY (PiezaID) REFERENCES Publicidad.PiezaPublicitaria (PiezaID)
    )
END
GO

--TABLA CUENTA_CON_EXHIBICION
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
TABLE_SCHEMA = 'publicidad' AND TABLE_NAME = 'CuentaConExhibicion')
BEGIN
    CREATE TABLE Publicidad.CuentaConExhibicion
    (
        ExhibicionID INT NOT NULL,
        PartidoID INT NOT NULL,

        CONSTRAINT PK_CuentaConExhibicion PRIMARY KEY CLUSTERED (ExhibicionID, PartidoID),
        CONSTRAINT FK_CuentaConExhibicion_Exhibicion FOREIGN KEY (ExhibicionID) REFERENCES Publicidad.Exhibicion (ExhibicionID),
        CONSTRAINT FK_CuentaConExhibicion_Partido FOREIGN KEY (PartidoID) REFERENCES torneo.Partido (PartidoID)
    ) 
END
GO
