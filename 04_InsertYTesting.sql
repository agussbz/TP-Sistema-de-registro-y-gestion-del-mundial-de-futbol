
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Insert y Testing de Store Procedure

-- Pruebas de Persona

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Lionel',
    @Apellido = 'Messi',
    @FechaNacimiento = '1987-06-24';

EXEC torneo.SP_Alta_Persona
    @Nombre = 'Julian',
    @Apellido = 'Alvarez',
    @FechaNacimiento = '2000-01-31';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Persona',
    @Apellido = 'De Prueba',
    @FechaNacimiento = '1995-05-10';

-- FRACASO: Nombre vacio
EXEC torneo.SP_Alta_Persona
    @Nombre = '',
    @Apellido = 'Rios',
    @FechaNacimiento = '1990-01-01';

-- FRACASO: Apellido vacio
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Fernando',
    @Apellido = '',
    @FechaNacimiento = '1990-01-01';

-- FRACASO: Fecha de nacimiento NULL
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Fernando',
    @Apellido = 'Rios',
    @FechaNacimiento = NULL;

-- FRACASO: Fecha de nacimiento futura
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Fernando',
    @Apellido = 'Rios',
    @FechaNacimiento = '2099-01-01';


PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre = 'Persona'
      AND Apellido = 'De Prueba'
);

-- EXITO
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = @ID_Prueba,
    @Nombre = 'Persona Modificada',
    @Apellido = 'De Prueba',
    @FechaNacimiento = '1996-05-10';

-- FRACASO: Persona inexistente
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = 99999,
    @Nombre = 'Fernando',
    @Apellido = 'Rios',
    @FechaNacimiento = '1990-01-01';

-- FRACASO: Nombre vacio
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = @ID_Prueba,
    @Nombre = '',
    @Apellido = 'Rios',
    @FechaNacimiento = '1990-01-01';

-- FRACASO: Apellido vacio
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = @ID_Prueba,
    @Nombre = 'Fernando',
    @Apellido = '',
    @FechaNacimiento = '1990-01-01';

-- FRACASO: Fecha de nacimiento NULL
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = @ID_Prueba,
    @Nombre = 'Fernando',
    @Apellido = 'Rios',
    @FechaNacimiento = NULL;

-- FRACASO: Fecha de nacimiento futura
EXEC torneo.SP_Modificacion_Persona
    @PersonaID = @ID_Prueba,
    @Nombre = 'Fernando',
    @Apellido = 'Rios',
    @FechaNacimiento = '2099-01-01';


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC torneo.SP_Baja_Persona
    @PersonaID = @ID_Prueba;

-- FRACASO: Persona inexistente
EXEC torneo.SP_Baja_Persona
    @PersonaID = 99999;

GO

-- Pruebas de Formacion

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = '4-3-3';

EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = '4-4-2';

EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = '3-5-2';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = 'Formacion de Prueba';

-- FRACASO: Esquema tactico vacio
EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = '';

-- FRACASO: Esquema tactico NULL
EXEC torneo.SP_Alta_Formacion
    @EsquemaTactico = NULL;


PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_Formacion INT = (
    SELECT MAX(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico = 'Formacion de Prueba'
);

-- EXITO
EXEC torneo.SP_Modificacion_Formacion
    @FormacionID = @ID_Prueba_Formacion,
    @EsquemaTactico = '4-2-3-1';

-- FRACASO: Formacion inexistente
EXEC torneo.SP_Modificacion_Formacion
    @FormacionID = 99999,
    @EsquemaTactico = '4-3-3';

-- FRACASO: Esquema tactico vacio
EXEC torneo.SP_Modificacion_Formacion
    @FormacionID = @ID_Prueba_Formacion,
    @EsquemaTactico = '';

-- FRACASO: Esquema tactico NULL
EXEC torneo.SP_Modificacion_Formacion
    @FormacionID = @ID_Prueba_Formacion,
    @EsquemaTactico = NULL;


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC torneo.SP_Baja_Formacion
    @FormacionID = @ID_Prueba_Formacion;

-- FRACASO: Formacion inexistente
EXEC torneo.SP_Baja_Formacion
    @FormacionID = 99999;

GO

-- Pruebas de Jugador

-- Obtener una convocatoria existente
DECLARE @ID_Convocatoria_Jugador INT = (
    SELECT MIN(ConvocatoriaID)
    FROM torneo.Convocatoria
);

-- Obtener las personas cargadas anteriormente
DECLARE @ID_Messi INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre = 'Lionel'
      AND Apellido = 'Messi'
);

DECLARE @ID_Alvarez INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre = 'Julian'
      AND Apellido = 'Alvarez'
);

-- Crear una persona para modificar y eliminar como jugador
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Jugador',
    @Apellido = 'De Prueba',
    @FechaNacimiento = '1998-04-15';

DECLARE @ID_Prueba_Jugador INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre = 'Jugador'
      AND Apellido = 'De Prueba'
);


PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Messi,
    @ClubOrigen = 'Inter Miami',
    @Dorsal = 10,
    @PosicionHabitual = 'Delantero',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Alvarez,
    @ClubOrigen = 'Atletico de Madrid',
    @Dorsal = 9,
    @PosicionHabitual = 'Delantero',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'Club de Prueba',
    @Dorsal = 99,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;


-- FRACASO: Persona inexistente
EXEC torneo.SP_Alta_Jugador
    @PersonaID = 99999,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Persona ya registrada como jugador
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Messi,
    @ClubOrigen = 'Inter Miami',
    @Dorsal = 10,
    @PosicionHabitual = 'Delantero',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Convocatoria inexistente
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = 99999;

-- FRACASO: Club de origen vacio
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = '',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Posicion habitual vacia
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = '',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Dorsal menor o igual a cero
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 0,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Dorsal repetido en la misma convocatoria
EXEC torneo.SP_Alta_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 10,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;


PRINT 'PRUEBAS DE MODIFICACION'

-- EXITO
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'Boca Juniors',
    @Dorsal = 98,
    @PosicionHabitual = 'Defensor',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Jugador inexistente
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = 99999,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Convocatoria inexistente
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = 99999;

-- FRACASO: Club de origen vacio
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = '',
    @Dorsal = 8,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Posicion habitual vacia
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 8,
    @PosicionHabitual = '',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Dorsal menor o igual a cero
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 0,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;

-- FRACASO: Dorsal repetido en la misma convocatoria
EXEC torneo.SP_Modificacion_Jugador
    @PersonaID = @ID_Prueba_Jugador,
    @ClubOrigen = 'River Plate',
    @Dorsal = 10,
    @PosicionHabitual = 'Mediocampista',
    @ConvocatoriaID = @ID_Convocatoria_Jugador;


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC torneo.SP_Baja_Jugador
    @PersonaID = @ID_Prueba_Jugador;

-- FRACASO: Jugador inexistente
EXEC torneo.SP_Baja_Jugador
    @PersonaID = 99999;

-- Eliminar tambien la persona de prueba
EXEC torneo.SP_Baja_Persona
    @PersonaID = @ID_Prueba_Jugador;

GO

-- Pruebas de TieneFormacion

-- Obtener un partido existente
DECLARE @ID_Partido_TF INT = (
    SELECT MIN(PartidoID)
    FROM torneo.Partido
);

-- Obtener las formaciones cargadas anteriormente
DECLARE @ID_Formacion_433 INT = (
    SELECT MIN(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico = '4-3-3'
);

DECLARE @ID_Formacion_442 INT = (
    SELECT MIN(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico = '4-4-2'
);

DECLARE @ID_Formacion_352 INT = (
    SELECT MIN(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico = '3-5-2'
);


PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_433;

EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_442;

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352;

-- FRACASO: Partido inexistente
EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = 99999,
    @FormacionID = @ID_Formacion_433;

-- FRACASO: Formacion inexistente
EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = 99999;

-- FRACASO: Asignacion duplicada
EXEC torneo.SP_Alta_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_433;


PRINT 'PRUEBAS DE MODIFICACION'

-- EXITO: Cambiar la formacion asignada
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Asignacion original inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = 99999,
    @FormacionID = 99999,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Nuevo partido inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = 99999,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Nueva formacion inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = 99999;

-- FRACASO: Nueva asignacion ya existente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = @ID_Formacion_433;


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC torneo.SP_Baja_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352;

-- FRACASO: Asignacion inexistente
EXEC torneo.SP_Baja_TieneFormacion
    @PartidoID = 99999,
    @FormacionID = 99999;

GO

-- Pruebas de PiezaPublicitaria

-- Obtener una campaña existente
DECLARE @ID_Campaña_PP INT = (
    SELECT MIN(CampañaID)
    FROM publicidad.Campaña
);


PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Adidas Mundial 2026',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Coca Cola Mundial 2026',
    @Tarifa = 200000.00,
    @Idioma = 'Ingles',
    @CampañaID = @ID_Campaña_PP;

EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Visa Mundial 2026',
    @Tarifa = 175000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- EXITO para modificar y eliminar
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad de Prueba',
    @Tarifa = 10000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;


-- FRACASO: Contenido vacio
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = '',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Tarifa negativa
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Nike',
    @Tarifa = -1000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Tarifa NULL
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Nike',
    @Tarifa = NULL,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Idioma vacio
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Nike',
    @Tarifa = 150000.00,
    @Idioma = '',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Campaña inexistente
EXEC publicidad.SP_Alta_PiezaPublicitaria
    @Contenido = 'Publicidad Nike',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = 99999;


PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_PP INT = (
    SELECT MAX(PiezaID)
    FROM publicidad.PiezaPublicitaria
    WHERE Contenido = 'Publicidad de Prueba'
);

-- EXITO
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = 'Publicidad de Prueba Modificada',
    @Tarifa = 25000.00,
    @Idioma = 'Ingles',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Pieza publicitaria inexistente
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = 99999,
    @Contenido = 'Publicidad Nike',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Contenido vacio
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = '',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Tarifa negativa
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = 'Publicidad Nike',
    @Tarifa = -1000.00,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Tarifa NULL
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = 'Publicidad Nike',
    @Tarifa = NULL,
    @Idioma = 'Español',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Idioma vacio
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = 'Publicidad Nike',
    @Tarifa = 150000.00,
    @Idioma = '',
    @CampañaID = @ID_Campaña_PP;

-- FRACASO: Campaña inexistente
EXEC publicidad.SP_Modificacion_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP,
    @Contenido = 'Publicidad Nike',
    @Tarifa = 150000.00,
    @Idioma = 'Español',
    @CampañaID = 99999;


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC publicidad.SP_Baja_PiezaPublicitaria
    @PiezaID = @ID_Prueba_PP;

-- FRACASO: Pieza publicitaria inexistente
EXEC publicidad.SP_Baja_PiezaPublicitaria
    @PiezaID = 99999;

GO

-- Pruebas de SeDesignaArbitro

-- Obtener un partido existente
DECLARE @ID_Partido_SDA INT = (
    SELECT MIN(PartidoID)
    FROM torneo.Partido
);

-- Obtener un arbitro existente
DECLARE @ID_Arbitro_SDA INT = (
    SELECT MIN(PersonaID)
    FROM reglamento.Arbitro
);


PRINT 'PRUEBAS DE ALTA'

-- EXITO para modificar y eliminar
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Partido inexistente
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Arbitro inexistente
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = 99999,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Informe vacio
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = '',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Rol arbitral vacio
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Sin incidentes',
    @RolArbitral = '';

-- FRACASO: Arbitro ya designado para el partido
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';


PRINT 'PRUEBAS DE MODIFICACION'

-- EXITO
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Partido finalizado sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Designacion inexistente
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = 99999,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Informe vacio
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = '',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Rol arbitral vacio
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA,
    @Informe = 'Sin incidentes',
    @RolArbitral = '';


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC reglamento.SP_Baja_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA,
    @ArbitroID = @ID_Arbitro_SDA;

-- FRACASO: Designacion inexistente
EXEC reglamento.SP_Baja_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = 99999;

GO

-- Pruebas de Exhibicion

-- Obtener una pieza publicitaria existente
DECLARE @ID_Pieza_Exhibicion INT = (
    SELECT MIN(PiezaID)
    FROM publicidad.PiezaPublicitaria
    WHERE Contenido = 'Publicidad Adidas Mundial 2026'
);


PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 50000;

EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Cartel lateral',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 30000;

-- EXITO para modificar y eliminar
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Espacio de Prueba',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 10000;


-- FRACASO: Espacio vacio
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = '',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 15000;

-- FRACASO: Espacio NULL
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = NULL,
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 15000;

-- FRACASO: Pieza publicitaria inexistente
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Pantalla gigante',
    @PiezaID = 99999,
    @Costo = 15000;

-- FRACASO: Costo negativo
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = -1000;

-- FRACASO: Costo NULL
EXEC publicidad.SP_Alta_Exhibicion
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = NULL;


PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_Exhibicion INT = (
    SELECT MAX(ExhibicionID)
    FROM publicidad.Exhibicion
    WHERE Espacio = 'Espacio de Prueba'
);

-- EXITO
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla de Prueba Modificada',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 25000;

-- FRACASO: Exhibicion inexistente
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = 99999,
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 15000;

-- FRACASO: Espacio vacio
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = '',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 15000;

-- FRACASO: Espacio NULL
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = NULL,
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = 15000;

-- FRACASO: Pieza publicitaria inexistente
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla gigante',
    @PiezaID = 99999,
    @Costo = 15000;

-- FRACASO: Costo negativo
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = -1000;

-- FRACASO: Costo NULL
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exhibicion,
    @Costo = NULL;


PRINT 'PRUEBAS DE BAJA'

-- EXITO
EXEC publicidad.SP_Baja_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion;

-- FRACASO: Exhibicion inexistente
EXEC publicidad.SP_Baja_Exhibicion
    @ExhibicionID = 99999;

GO
