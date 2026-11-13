-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Insert y Testing de Store Procedure

USE DB_Mundial_2026
GO

-- =======================
-- Pruebas de Persona
-- =======================

SELECT * FROM torneo.Persona

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

SELECT * FROM torneo.Persona

PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre IN ('Persona', 'Persona Modificada')
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

SELECT * FROM torneo.Persona

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Baja INT = (
    SELECT MAX(PersonaID)
    FROM torneo.Persona
    WHERE Nombre IN ('Persona', 'Persona Modificada')
      AND Apellido = 'De Prueba'
);

-- EXITO
EXEC torneo.SP_Baja_Persona
    @PersonaID = @ID_Baja;

-- FRACASO: Persona inexistente
EXEC torneo.SP_Baja_Persona
    @PersonaID = 99999;
GO


SELECT * FROM torneo.Persona

-- =======================
-- Pruebas de Formacion
-- =======================

SELECT * FROM torneo.Formacion

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

SELECT * FROM torneo.Formacion

PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_Formacion INT = (
    SELECT MAX(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico IN ('Formacion de Prueba', '4-2-3-1')
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

SELECT * FROM torneo.Formacion

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Baja_Formacion INT = (
    SELECT MAX(FormacionID)
    FROM torneo.Formacion
    WHERE EsquemaTactico IN ('Formacion de Prueba', '4-2-3-1')
);

-- EXITO
EXEC torneo.SP_Baja_Formacion
    @FormacionID = @ID_Baja_Formacion;

-- FRACASO: Formacion inexistente
EXEC torneo.SP_Baja_Formacion
    @FormacionID = 99999;
GO

SELECT * FROM torneo.Formacion

--=======================
-- Pruebas de Pais
--=======================

SELECT * FROM torneo.Pais

PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC Torneo.SP_Alta_Pais @nombre = 'Argentina', @PBI = 640000.50, @husoHorario = 'UTC-3';
EXEC Torneo.SP_Alta_Pais @nombre = 'Brasil', @PBI = 920000.00, @husoHorario = 'UTC-3';
 
-- EXITO para modificar y eliminar
EXEC Torneo.SP_Alta_Pais @nombre = 'Venezuela', @PBI = 1000.00, @husoHorario = 'UTC-0';
 
-- FRACASO
EXEC Torneo.SP_Alta_Pais @nombre = '', @PBI = 1000.00, @husoHorario = 'UTC-0';
EXEC Torneo.SP_Alta_Pais @nombre = 'Argentina', @PBI = 1000.00, @husoHorario = 'UTC-3';
EXEC Torneo.SP_Alta_Pais @nombre = '   ', @PBI = 1000.00, @husoHorario = 'UTC-0';

SELECT * FROM torneo.Pais

PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Pais_Prueba INT = (
    SELECT MAX(PaisID) 
    FROM torneo.Pais 
    WHERE Nombre IN ('Venezuela', 'España')
);

-- EXITO
EXEC Torneo.SP_Modificacion_Pais
    @PaisID = @ID_Pais_Prueba,
    @nombre = 'España',
    @PBI = 2000.00,
    @husoHorario = 'UTC-1';
 
-- FRACASO
EXEC Torneo.SP_Modificacion_Pais
    @PaisID = 99999,
    @nombre = 'Colombia',
    @PBI = 100.00,
    @husoHorario = 'UTC-3';
 
EXEC Torneo.SP_Modificacion_Pais
    @PaisID = @ID_Pais_Prueba,
    @nombre = '',
    @PBI = 100.00,
    @husoHorario = 'UTC-3';
 
EXEC Torneo.SP_Modificacion_Pais
    @PaisID = @ID_Pais_Prueba,
    @nombre = 'Brasil',
    @PBI = 100.00,
    @husoHorario = 'UTC-3';
 
EXEC Torneo.SP_Modificacion_Pais
    @PaisID = 99999,
    @nombre = '',
    @PBI = 100.00,
    @husoHorario = 'UTC-3';

SELECT * FROM torneo.Pais 

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Pais_Baja INT = (
    SELECT MAX(PaisID) 
    FROM torneo.Pais 
    WHERE Nombre IN ('Venezuela', 'España')
);
 
-- EXITO
EXEC Torneo.SP_Baja_Pais @PaisID = @ID_Pais_Baja;
 
-- FRACASO
EXEC Torneo.SP_Baja_Pais @PaisID = 99999;

DECLARE @IDconInteresPublicitario INT = (SELECT TOP 1 p.PaisID FROM torneo.Pais p JOIN publicidad.InteresPublicitario i ON p.PaisID=i.PaisID)

IF @IDconInteresPublicitario IS NULL
    PRINT 'No hay datos en la tabla Interes Publicitario'
ELSE
    EXEC torneo.SP_Baja_Pais @IDconInteresPublicitario;
GO

SELECT * FROM torneo.Pais

--=======================
-- Pruebas de Tarjeta
--=======================

SELECT * FROM reglamento.Tarjeta

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC reglamento.SP_Alta_Tarjeta @tipo = 'Amarilla';
EXEC reglamento.SP_Alta_Tarjeta @tipo = 'Roja';
 
-- EXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Tarjeta @tipo = 'Tarjeta De Prueba';
 
-- FRACASO
EXEC reglamento.SP_Alta_Tarjeta @tipo = '';
EXEC reglamento.SP_Alta_Tarjeta @tipo = 'Amarilla';
EXEC reglamento.SP_Alta_Tarjeta @tipo = '   ';


SELECT * FROM reglamento.Tarjeta
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Tarjeta_Prueba INT = (SELECT TarjetaID FROM reglamento.Tarjeta WHERE Tipo in ('Tarjeta De Prueba', 'Tarjeta Modificada'));
 
-- EXITO
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = 'Tarjeta Modificada';
 
-- FRACASO
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = 99999, @tipo = 'Tarjeta Inexistente';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = '';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = 'Roja';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = 99999, @tipo = '';

SELECT * FROM reglamento.Tarjeta
 
PRINT 'PRUEBAS DE BAJA'
 
DECLARE @ID_Tarjeta_Baja INT = (SELECT TarjetaID FROM reglamento.Tarjeta WHERE Tipo in ('Tarjeta De Prueba', 'Tarjeta Modificada'));

-- EXITO
EXEC reglamento.SP_Baja_Tarjeta @TarjetaID = @ID_Tarjeta_Baja;
 
-- FRACASO
EXEC reglamento.SP_Baja_Tarjeta @TarjetaID = 99999;
GO

SELECT * FROM reglamento.Tarjeta

--=======================
-- Pruebas de Seleccion
--=======================

SELECT * FROM torneo.Seleccion

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_Seleccion @Pais = 'Argentina', @Confederacion = 'CONMEBOL';
EXEC torneo.SP_Alta_Seleccion @Pais = 'Brasil', @Confederacion = 'CONMEBOL';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Seleccion @Pais = 'Seleccion De Prueba', @Confederacion = 'Test';

-- FRACASO
EXEC torneo.SP_Alta_Seleccion @Pais = '', @Confederacion = 'CONMEBOL';
EXEC torneo.SP_Alta_Seleccion @Pais = 'Argentina', @Confederacion = '';
EXEC torneo.SP_Alta_Seleccion @Pais = 'Argentina', @Confederacion = 'CONMEBOL';


SELECT * FROM torneo.Seleccion

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Prueba INT = (SELECT SeleccionID FROM torneo.Seleccion WHERE Pais in ('Seleccion De Prueba', 'Seleccion de Prueba Modificada'));

-- EXITO
EXEC torneo.SP_Modificacion_Seleccion 
    @SeleccionID = @ID_Prueba, 
    @Pais = 'Seleccion de Prueba Modificada', 
    @Confederacion = 'Test modificado';

-- FRACASO
EXEC torneo.SP_Modificacion_Seleccion 
    @SeleccionID = 99999,
    @Pais = 'Holanda', 
    @Confederacion = 'UEFA'; 

EXEC torneo.SP_Modificacion_Seleccion 
    @SeleccionID = @ID_Prueba, 
    @Pais = '',
    @Confederacion = 'UEFA'; 

EXEC torneo.SP_Modificacion_Seleccion 
    @SeleccionID = @ID_Prueba, 
    @Pais = 'Holanda',
    @Confederacion = ''; 

SELECT * FROM torneo.Seleccion

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Baja INT = (SELECT SeleccionID FROM torneo.Seleccion WHERE Pais in ('Seleccion De Prueba', 'Seleccion de Prueba Modificada'));

-- EXITO:
EXEC torneo.SP_Baja_Seleccion @SeleccionID = @ID_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Seleccion @SeleccionID = 99999;
GO

SELECT * FROM torneo.Seleccion

--========================
-- Pruebas de Convocatoria
--========================

SELECT * FROM torneo.Convocatoria
 
PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 1;
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 2;

-- FRACASO
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 99999;
 

SELECT * FROM torneo.Convocatoria

PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Convocatoria_Prueba INT = (SELECT MAX(ConvocatoriaID) FROM torneo.Convocatoria);
 
-- EXITO
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = @ID_Convocatoria_Prueba, @SeleccionID = 3;

-- FRACASO: Convocatoria inexistente
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = 99999, @SeleccionID = 1;

-- FRACASO: Selección inexistente
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = @ID_Convocatoria_Prueba, @SeleccionID = 99999;

SELECT * FROM torneo.Convocatoria
 
PRINT 'PRUEBAS DE BAJA'
 
DECLARE @ID_Baja_Convocatoria INT = (SELECT MAX(ConvocatoriaID) FROM torneo.Convocatoria);

-- EXITO
EXEC torneo.SP_Baja_Convocatoria @ConvocatoriaID = @ID_Baja_Convocatoria;
 
-- FRACASO
EXEC torneo.SP_Baja_Convocatoria @ConvocatoriaID = 99999;

-- FRACASO: Intentar borrar una convocatoria que tiene jugadores asociados
DECLARE @ConvConJugadores INT = (
    SELECT TOP 1 c.ConvocatoriaID 
    FROM torneo.Convocatoria c 
    JOIN torneo.Jugador j ON c.ConvocatoriaID = j.ConvocatoriaID
);

IF @ConvConJugadores IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_Baja_Convocatoria @ConvocatoriaID = @ConvConJugadores;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END
ELSE
    PRINT 'No hay convocatorias con jugadores para probar el bloqueo de baja.';
GO

SELECT * FROM torneo.Convocatoria

--==========================
-- Pruebas de Cuerpo Tecnico
--==========================
 
DECLARE @ID_Persona_A INT = (SELECT TOP 1 PersonaID FROM torneo.Persona);
DECLARE @ID_Persona_B INT = (SELECT MAX(PersonaID) FROM torneo.Persona);
DECLARE @ID_Persona_C INT = (SELECT MIN(PersonaID) FROM torneo.Persona);

SELECT * FROM torneo.CuerpoTecnico

PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = @ID_Persona_A, @SeleccionID = 1, @rol = 'Director Tecnico';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = @ID_Persona_B, @SeleccionID = 1, @rol = 'Asistente';
 
-- FRACASO
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = 99999, @SeleccionID = 1, @rol = 'Asistente';
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = @ID_Persona_C, @SeleccionID = 99999, @rol = 'Asistente';
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = @ID_Persona_A, @SeleccionID = 1, @rol = 'Director Tecnico';
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = @ID_Persona_C, @SeleccionID = 1, @rol = 'Director Tecnico';
EXEC torneo.SP_Alta_CuerpoTecnico @PersonaID = 99999, @SeleccionID = 99999, @rol = '';

SELECT * FROM torneo.CuerpoTecnico
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
-- EXITO
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_B,
    @SeleccionID = 2,
    @SeleccionAnterior = 1,
    @rol = 'Asistente';

EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_C,
    @SeleccionID = 2,
    @SeleccionAnterior = 1,
    @rol = 'Asistente';
 
-- FRACASO
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = 99999,
    @SeleccionID = 2,
    @SeleccionAnterior = 1,
    @rol = 'Asistente';
 
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_B,
    @SeleccionID = 2,
    @SeleccionAnterior = 99999,
    @rol = 'Asistente';
 
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_B,
    @SeleccionID = 99999,
    @SeleccionAnterior = 2,
    @rol = 'Asistente';
 
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_B,
    @SeleccionID = 2,
    @SeleccionAnterior = 2,
    @rol = '';

SELECT * FROM torneo.CuerpoTecnico
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = @ID_Persona_B;
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = @ID_Persona_C;

-- FRACASO
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = 99999;
GO
 
SELECT * FROM torneo.CuerpoTecnico


--===================
-- Pruebas de Sede
--===================

SELECT * FROM torneo.Sede

PRINT 'PRUEBAS DE ALTA'

--EXITO

EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'México', @Capacidad = 83264, @HusoHorario = 'UTC-6';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'MetLife Stadium', @Ciudad = 'Nueva York', @Pais = 'Estados Unidos', @Capacidad = 82500, @HusoHorario = 'UTC-4';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio De Prueba', @Ciudad = 'Ciudad Prueba', @Pais = 'Pais Prueba', @Capacidad = 50000, @HusoHorario = 'UTC-0';

-- FRACASO
EXEC torneo.SP_Alta_Sede @NombreEstadio = '', @Ciudad = 'Los Angeles', @Pais = 'Estados Unidos', @Capacidad = 70000, @HusoHorario = 'UTC-8';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Rose Bowl', @Ciudad = 'Los Angeles', @Pais = 'Estados Unidos', @Capacidad = 0, @HusoHorario = 'UTC-8';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'Mexico', @Capacidad = 83264, @HusoHorario = 'UTC-6';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'Mexico', @Capacidad = 0, @HusoHorario = 'UTC-8';

SELECT * FROM torneo.Sede

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Sede_Prueba INT = (SELECT SedeID FROM torneo.Sede WHERE NombreEstadio in ('Estadio De Prueba', 'Estadio de Prueba Modificado') AND Ciudad in ('Ciudad Prueba', 'Ciudad Modificada'));

-- EXITO
EXEC torneo.SP_Modificacion_Sede 
    @SedeID = @ID_Sede_Prueba, 
    @NombreEstadio = 'Estadio de Prueba Modificado', 
    @Ciudad = 'Ciudad Modificada',
    @Pais = 'Pais Modificado',
    @Capacidad = 60000,
    @HusoHorario = 'UTC-1';

-- FRACASO
EXEC torneo.SP_Modificacion_Sede 
    @SedeID = 99999,
    @NombreEstadio = 'Estadio', 
    @Ciudad = 'Ciudad',
    @Pais = 'Pais',
    @Capacidad = 40000,
    @HusoHorario = 'UTC-3';

EXEC torneo.SP_Modificacion_Sede 
    @SedeID = @ID_Sede_Prueba, 
    @NombreEstadio = '',
    @Ciudad = 'Ciudad Modificada',
    @Pais = 'Pais Modificado',
    @Capacidad = 60000,
    @HusoHorario = 'UTC-1';

EXEC torneo.SP_Modificacion_Sede 
    @SedeID = @ID_Sede_Prueba, 
    @NombreEstadio = 'Estadio de Prueba Modificado', 
    @Ciudad = 'Ciudad Modificada',
    @Pais = 'Pais Modificado',
    @Capacidad = -100,
    @HusoHorario = 'UTC-1';

EXEC torneo.SP_Modificacion_Sede 
    @SedeID = 99999, 
    @NombreEstadio = '', 
    @Ciudad = 'Ciudad Modificada',
    @Pais = 'Pais Modificado',
    @Capacidad = -100,
    @HusoHorario = 'UTC-1';

SELECT * FROM torneo.Sede

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Sede_Baja INT = (SELECT SedeID FROM torneo.Sede WHERE NombreEstadio in ('Estadio De Prueba', 'Estadio de Prueba Modificado') AND Ciudad in ('Ciudad Prueba', 'Ciudad Modificada'));

-- EXITO:
EXEC torneo.SP_Baja_Sede @SedeID = @ID_Sede_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Sede @SedeID = 99999;
GO

SELECT * FROM torneo.Sede

--=======================
-- Pruebas de Partido
--=======================

SELECT * FROM torneo.Partido
 
PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Fase de Grupos', @Asistencia = 80000, @ResultadoFinal = '2-1', @FechaHoraLocal = '2026-06-11 15:00', @FechaHoraUTC = '2026-06-11 21:00';
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Fase de Grupos', @Asistencia = 75000, @ResultadoFinal = '0-0', @FechaHoraLocal = '2026-06-13 18:00', @FechaHoraUTC = '2026-06-13 22:00';
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Fase De Prueba', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
 
-- FRACASO
EXEC torneo.SP_Alta_Partido @SedeID = 99999, @Fase = 'Fase de Grupos', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = '', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
EXEC torneo.SP_Alta_Partido @SedeID = 99999, @Fase = '', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
 
SELECT * FROM torneo.Partido

PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Partido_Prueba INT = (SELECT MAX(PartidoID) FROM torneo.Partido WHERE Fase in ('Fase De Prueba', 'Fase De Prueba Modificada'));
 
-- EXITO
EXEC torneo.SP_Modificacion_Partido
    @PartidoID = @ID_Partido_Prueba,
    @SedeID = 1,
    @Fase = 'Fase De Prueba Modificada',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @fechaHoraLocal = '2026-06-21 12:00',
    @fechaHoraUTC = '2026-06-21 18:00';
 
-- FRACASO
EXEC torneo.SP_Modificacion_Partido
    @PartidoID = 99999,
    @SedeID = 1,
    @Fase = 'Fase',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @fechaHoraLocal = '2026-06-21 12:00',
    @fechaHoraUTC = '2026-06-21 18:00';
 
EXEC torneo.SP_Modificacion_Partido
    @PartidoID = @ID_Partido_Prueba,
    @SedeID = 99999,
    @Fase = 'Fase',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @fechaHoraLocal = '2026-06-21 12:00',
    @fechaHoraUTC = '2026-06-21 18:00';
 
EXEC torneo.SP_Modificacion_Partido
    @PartidoID = @ID_Partido_Prueba,
    @SedeID = 1,
    @Fase = '',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @fechaHoraLocal = '2026-06-21 12:00',
    @fechaHoraUTC = '2026-06-21 18:00';
 
EXEC torneo.SP_Modificacion_Partido
    @PartidoID = 99999,
    @SedeID = 99999,
    @Fase = '',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @fechaHoraLocal = '2026-06-21 12:00',
    @fechaHoraUTC = '2026-06-21 18:00';

EXEC torneo.SP_Modificacion_Partido
    @PartidoID = @ID_Partido_Prueba,
    @SedeID = 1,
    @Fase = 'Promo mundial',
    @Asistencia = 2000,
    @ResultadoFinal = '3-2',
    @FechaHoraLocal = '2026-06-11 15:00', 
    @FechaHoraUTC = '2026-06-11 21:00';

SELECT * FROM torneo.Partido

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Partido_Baja INT = (SELECT MAX(PartidoID) FROM torneo.Partido WHERE Fase in ('Fase De Prueba', 'Fase De Prueba Modificada'));
 
-- EXITO
EXEC torneo.SP_Baja_Partido @PartidoID = @ID_Partido_Baja;
 
-- FRACASO
EXEC torneo.SP_Baja_Partido @PartidoID = 99999; 
GO

SELECT * FROM torneo.Partido

--=======================
-- Pruebas de Jugador
--=======================

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

SELECT * FROM torneo.Jugador

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

SELECT * FROM torneo.Jugador

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

SELECT * FROM torneo.Jugador

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

SELECT * FROM torneo.Jugador

--=======================
-- Pruebas de Sustitucion
--=======================

DECLARE @ID_Partido_Sust_1 INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Partido_Sust_2 INT = (SELECT MAX(PartidoID) FROM torneo.Partido);

DECLARE @ID_Jugador_Sale INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jugador_Entra INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

SELECT * FROM torneo.Sustitucion

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_2, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Entra, @JugadorEntraID = @ID_Jugador_Sale, @NumeroVentana = 1, @Minuto = 75, @Motivo = 'Lesion';
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 2, @Minuto = 80, @Motivo = 'Precaucion';
 
-- FRACASO
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 99999, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_2, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = 99999, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = 99999, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Sale, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 0, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_2, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = -1, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_2, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = -10, @Minuto = 60, @Motivo = '';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Otro';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 99999, @JugadorSaleID = 99999, @JugadorEntraID = 99999, @NumeroVentana = 0, @Minuto = -1, @Motivo = '';

SELECT * FROM torneo.Sustitucion

PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Sustitucion_Prueba INT = (
    SELECT MAX(SustitucionID) 
    FROM torneo.Sustitucion 
    WHERE NumeroVentana IN (2, 3) AND Minuto IN (80, 85)
);
 
-- EXITO
EXEC torneo.SP_Modificacion_Sustitucion
    @SustitucionID = @ID_Sustitucion_Prueba,
    @PartidoID = @ID_Partido_Sust_1,
    @JugadorSaleID = @ID_Jugador_Sale,
    @JugadorEntraID = @ID_Jugador_Entra,
    @NumeroVentana = 3,
    @Minuto = 85,
    @Motivo = 'Lesion';
 
-- FRACASO
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = 99999, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = 99999, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = 99999, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = 99999, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Sale, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 0, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = -1, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = '';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = @ID_Partido_Sust_1, @JugadorSaleID = @ID_Jugador_Sale, @JugadorEntraID = @ID_Jugador_Entra, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Otro';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = 99999, @PartidoID = 99999, @JugadorSaleID = 99999, @JugadorEntraID = 99999, @NumeroVentana = 0, @Minuto = -1, @Motivo = '';

SELECT * FROM torneo.Sustitucion

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Sustitucion_Baja INT = (
    SELECT MAX(SustitucionID) 
    FROM torneo.Sustitucion 
    WHERE NumeroVentana IN (2, 3) AND Minuto IN (80, 85)
);
 
-- EXITO
EXEC torneo.SP_Baja_Sustitucion @SustitucionID = @ID_Sustitucion_Baja;
 
-- FRACASO
EXEC torneo.SP_Baja_Sustitucion @SustitucionID = 99999;
GO

SELECT * FROM torneo.Sustitucion

--=======================
-- Tabla ANUNCIANTE
--=======================

SELECT * FROM publicidad.Anunciante

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC publicidad.SP_Alta_Anunciante @Pais = 'Colombia';
EXEC publicidad.SP_Alta_Anunciante @Pais = 'Argentina';

-- ÉXITO para modificar y eliminar
EXEC publicidad.SP_Alta_Anunciante @Pais = 'Anunciante De Prueba';

-- FRACASO
EXEC publicidad.SP_Alta_Anunciante @Pais = '';

SELECT * FROM publicidad.Anunciante

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Anunciante_Prueba INT = (
    SELECT MAX(AnuncianteID) 
    FROM publicidad.Anunciante 
    WHERE Pais IN ('Anunciante De Prueba', 'Anunciante Modificado')
);

-- ÉXITO
EXEC publicidad.SP_Modificacion_Anunciante
    @AnuncianteID = @ID_Anunciante_Prueba, 
    @Pais = 'Anunciante Modificado';

-- FRACASO 1
EXEC publicidad.SP_Modificacion_Anunciante 
    @AnuncianteID = 9999,
    @Pais = 'Colombia';

-- FRACASO 2
EXEC publicidad.SP_Modificacion_Anunciante 
    @AnuncianteID = @ID_Anunciante_Prueba,
    @Pais = '';

-- FRACASO 3 (Ambos errores juntos)
EXEC publicidad.SP_Modificacion_Anunciante 
    @AnuncianteID = 9999,
    @Pais = '';

SELECT * FROM publicidad.Anunciante

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Anunciante_Baja INT = (
    SELECT MAX(AnuncianteID) 
    FROM publicidad.Anunciante 
    WHERE Pais IN ('Anunciante De Prueba', 'Anunciante Modificado')
);

-- ÉXITO:
EXEC publicidad.SP_Baja_Anunciante @AnuncianteID = @ID_Anunciante_Baja;

-- FRACASO
EXEC publicidad.SP_Baja_Anunciante @AnuncianteID = 99999;
GO

SELECT * FROM publicidad.Anunciante

--====================
-- Pruebas de Campaña
--====================

DECLARE @ID_Anunciante_Camp INT = (SELECT MIN(AnuncianteID) FROM publicidad.Anunciante);

SELECT * FROM publicidad.Campaña

PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC publicidad.SP_Alta_Campaña @nombre = 'Locos', @fechaInicio = '2026-05-01', @AnuncianteID = @ID_Anunciante_Camp;
EXEC publicidad.SP_Alta_Campaña @nombre = 'Soña en grande', @fechaInicio = '2026-06-01', @AnuncianteID = @ID_Anunciante_Camp;

-- EXITO para modificar y eliminar
EXEC publicidad.SP_Alta_Campaña @nombre = 'Aliento', @fechaInicio = '2026-06-15', @AnuncianteID = 4;

-- FRACASO
EXEC publicidad.SP_Alta_Campaña @nombre = '', @fechaInicio = '2026-06-15', @AnuncianteID = @ID_Anunciante_Camp;
EXEC publicidad.SP_Alta_Campaña @nombre = 'Promo mundial', @fechaInicio = '2026-06-15', @AnuncianteID = 99999;
EXEC publicidad.SP_Alta_Campaña @nombre = '', @fechaInicio = '2026-06-15', @AnuncianteID = 99999;

SELECT * FROM publicidad.Campaña

PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Campaña_Prueba INT = (
    SELECT MAX(CampañaID) 
    FROM publicidad.Campaña 
    WHERE Nombre IN ('Aliento', 'Jugamos todos')
);
DECLARE @ID_Anunciante_Mod INT = (SELECT MIN(AnuncianteID) FROM publicidad.Anunciante);

-- EXITO
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = @ID_Campaña_Prueba,
    @Nombre = 'Jugamos todos',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = @ID_Anunciante_Mod;
 
-- FRACASO
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = 99999,
    @Nombre = 'Seguro de sedes',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = @ID_Anunciante_Mod;
 
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = @ID_Campaña_Prueba,
    @Nombre = '',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = @ID_Anunciante_Mod;
 
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = @ID_Campaña_Prueba,
    @Nombre = 'Promo mundial',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = 99999;
 
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = 99999,
    @Nombre = '',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = 99999;

SELECT * FROM publicidad.Campaña

 
PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Campaña_Baja INT = (
    SELECT MAX(CampañaID) 
    FROM publicidad.Campaña 
    WHERE Nombre IN ('Aliento', 'Jugamos todos')
);
 
-- EXITO
EXEC publicidad.SP_Baja_Campaña @CampañaID = @ID_Campaña_Baja;
 
-- FRACASO
EXEC publicidad.SP_Baja_Campaña @CampañaID = 99999;
GO

SELECT * FROM publicidad.Campaña

--=======================
-- Tabla IDIOMA
--=======================

SELECT * FROM torneo.Idioma

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Idioma @Nombre = 'Ingles';
EXEC torneo.SP_Alta_Idioma @Nombre = 'Español';

-- ÉXITO para modificar y eliminar
EXEC torneo.SP_Alta_Idioma @Nombre = 'Idioma De Prueba';

-- FRACASO
EXEC torneo.SP_Alta_Idioma @Nombre = '';
EXEC torneo.SP_Alta_Idioma @Nombre = 'Ingles';

SELECT * FROM torneo.Idioma

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Idioma_Prueba INT = (
    SELECT MAX(IdiomaID) 
    FROM torneo.Idioma 
    WHERE Nombre IN ('Idioma De Prueba', 'Portugues')
);

-- ÉXITO
EXEC torneo.SP_Modificacion_Idioma
    @IdiomaID = @ID_Idioma_Prueba, 
    @Nombre = 'Portugues';

-- FRACASO 1
EXEC torneo.SP_Modificacion_Idioma 
    @IdiomaID = 99999,
    @Nombre = 'Portugues';

-- FRACASO 2
EXEC torneo.SP_Modificacion_Idioma 
    @IdiomaID = @ID_Idioma_Prueba, 
    @Nombre = '';
    
SELECT * FROM torneo.Idioma

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Idioma_Baja INT = (
    SELECT MAX(IdiomaID) 
    FROM torneo.Idioma 
    WHERE Nombre IN ('Idioma De Prueba', 'Portugues')
);

-- ÉXITO:
EXEC torneo.SP_Baja_Idioma @IdiomaID = @ID_Idioma_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Idioma @IdiomaID = 99999;
GO

SELECT * FROM torneo.Idioma

--=======================
-- Tabla Arbitro
--=======================

EXEC torneo.SP_Alta_Persona
    @Nombre = 'Arbitro',
    @Apellido = 'De Prueba',
    @FechaNacimiento = '1985-03-20';

DECLARE @ID_Persona_Arb1 INT = (SELECT MIN(PersonaID) FROM torneo.Persona);
DECLARE @ID_Persona_Arb2 INT = (SELECT TOP 1 PersonaID FROM torneo.Persona WHERE PersonaID > @ID_Persona_Arb1 ORDER BY PersonaID);
DECLARE @ID_Prueba_Arbitro INT = (SELECT MAX(PersonaID) FROM torneo.Persona WHERE Nombre = 'Arbitro' AND Apellido = 'De Prueba');

SELECT * FROM reglamento.Arbitro

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_Arbitro @PersonaID = @ID_Persona_Arb1, @Pais = 'Colombia', @RolArbitral = 'Principal';
EXEC reglamento.SP_Alta_Arbitro @PersonaID = @ID_Persona_Arb2, @Pais = 'Brasil', @RolArbitral = 'Asistente';

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Arbitro @PersonaID = @ID_Prueba_Arbitro, @Pais = 'Chile', @RolArbitral = 'Cuarto Arbitro';

-- FRACASO
EXEC reglamento.SP_Alta_Arbitro @PersonaID = NULL, @Pais = 'Colombia', @RolArbitral = 'Principal';
EXEC reglamento.SP_Alta_Arbitro @PersonaID = @ID_Prueba_Arbitro, @Pais = '', @RolArbitral = 'Principal';
EXEC reglamento.SP_Alta_Arbitro @PersonaID = @ID_Prueba_Arbitro, @Pais = 'Colombia', @RolArbitral = '';

SELECT * FROM reglamento.Arbitro

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Arbitro_Mod INT = (SELECT MAX(PersonaID) FROM torneo.Persona WHERE Nombre = 'Arbitro' AND Apellido = 'De Prueba');

-- ÉXITO
EXEC reglamento.SP_Modificacion_Arbitro
    @PersonaID = @ID_Arbitro_Mod, 
    @Pais = 'Uruguay',
    @RolArbitral = 'VAR';

-- FRACASO 1
EXEC reglamento.SP_Modificacion_Arbitro 
    @PersonaID = 9999,
    @Pais = '',
    @RolArbitral = 'Principal';

-- FRACASO 2
EXEC reglamento.SP_Modificacion_Arbitro
    @PersonaID = @ID_Arbitro_Mod,
    @Pais = '',
    @RolArbitral = 'Principal'

EXEC reglamento.SP_Modificacion_Arbitro 
    @PersonaID = @ID_Arbitro_Mod,
    @Pais = 'Colombia',
    @RolArbitral = '';

SELECT * FROM reglamento.Arbitro

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Arbitro_Baja INT = (SELECT MAX(PersonaID) FROM torneo.Persona WHERE Nombre = 'Arbitro' AND Apellido = 'De Prueba');

-- ÉXITO:
EXEC reglamento.SP_Baja_Arbitro @PersonaID = @ID_Arbitro_Baja;

-- FRACASO
EXEC reglamento.SP_Baja_Arbitro @PersonaID = 99999;

EXEC torneo.SP_Baja_Persona @PersonaID = @ID_Arbitro_Baja;
GO

SELECT * FROM reglamento.Arbitro

--=======================
-- Pruebas de TieneFormacion
--=======================

DECLARE @ID_Partido_TF INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Partido_TF_2 INT = (SELECT MAX(PartidoID) FROM torneo.Partido);

-- Obtener las formaciones cargadas antes
DECLARE @ID_Formacion_433 INT = (SELECT MIN(FormacionID) FROM torneo.Formacion WHERE EsquemaTactico = '4-3-3');
DECLARE @ID_Formacion_442 INT = (SELECT MIN(FormacionID) FROM torneo.Formacion WHERE EsquemaTactico = '4-4-2');
DECLARE @ID_Formacion_352 INT = (SELECT MIN(FormacionID) FROM torneo.Formacion WHERE EsquemaTactico = '3-5-2');

SELECT * FROM torneo.TieneFormacion

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

SELECT * FROM torneo.TieneFormacion

PRINT 'PRUEBAS DE MODIFICACION'

-- EXITO: Cambiar el partido asignado a esa formación para que se vea el cambio
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF_2,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Asignacion original inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = 99999,
    @FormacionID = 99999,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Nuevo partido inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF_2,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = 99999,
    @NuevaFormacionID = @ID_Formacion_352;

-- FRACASO: Nueva formacion inexistente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF_2,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF_2,
    @NuevaFormacionID = 99999;

-- FRACASO: Nueva asignacion ya existente
EXEC torneo.SP_Modificacion_TieneFormacion
    @PartidoID = @ID_Partido_TF_2,
    @FormacionID = @ID_Formacion_352,
    @NuevoPartidoID = @ID_Partido_TF,
    @NuevaFormacionID = @ID_Formacion_433;

SELECT * FROM torneo.TieneFormacion

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

SELECT * FROM torneo.TieneFormacion

--==============================
-- Pruebas de PiezaPublicitaria
--==============================

-- Obtener una campaña existente
DECLARE @ID_Campaña_PP INT = (
    SELECT MIN(CampañaID)
    FROM publicidad.Campaña
);

SELECT * FROM publicidad.PiezaPublicitaria

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

SELECT * FROM publicidad.PiezaPublicitaria

PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_PP INT = (
    SELECT MAX(PiezaID)
    FROM publicidad.PiezaPublicitaria
    WHERE Contenido IN ('Publicidad de Prueba', 'Publicidad de Prueba Modificada')
);

DECLARE @ID_Campaña_PP_Mod INT = (SELECT MIN(CampañaID) FROM publicidad.Campaña);

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

SELECT * FROM publicidad.PiezaPublicitaria

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Baja_PP INT = (
    SELECT MAX(PiezaID)
    FROM publicidad.PiezaPublicitaria
    WHERE Contenido IN ('Publicidad de Prueba', 'Publicidad de Prueba Modificada')
);

-- EXITO
EXEC publicidad.SP_Baja_PiezaPublicitaria
    @PiezaID = @ID_Baja_PP;

-- FRACASO: Pieza publicitaria inexistente
EXEC publicidad.SP_Baja_PiezaPublicitaria
    @PiezaID = 99999;
GO

SELECT * FROM publicidad.PiezaPublicitaria

--=======================
-- Pruebas de SeDesignaArbitro
--=======================

DECLARE @ID_Partido_SDA_1 INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Partido_SDA_2 INT = (SELECT MAX(PartidoID) FROM torneo.Partido);
DECLARE @ID_Arbitro_SDA_1 INT = (SELECT MIN(PersonaID) FROM reglamento.Arbitro);
DECLARE @ID_Arbitro_SDA_2 INT = (SELECT MAX(PersonaID) FROM reglamento.Arbitro);

SELECT * FROM reglamento.SeDesignaArbitro

PRINT 'PRUEBAS DE ALTA'

-- EXITO (Queda cargado en la tabla)
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_1,
    @ArbitroID = @ID_Arbitro_SDA_1,
    @Informe = 'Correcto desempeño',
    @RolArbitral = 'Arbitro principal';

-- EXITO para modificar y eliminar
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_2,
    @ArbitroID = @ID_Arbitro_SDA_2,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro asistente';

-- FRACASO: Partido inexistente
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = @ID_Arbitro_SDA_1,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Arbitro inexistente
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_1,
    @ArbitroID = 99999,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Informe vacio
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_1,
    @ArbitroID = @ID_Arbitro_SDA_1,
    @Informe = '',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Rol arbitral vacio
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_1,
    @ArbitroID = @ID_Arbitro_SDA_1,
    @Informe = 'Sin incidentes',
    @RolArbitral = '';

-- FRACASO: Arbitro ya designado para el partido
EXEC reglamento.SP_Alta_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_1,
    @ArbitroID = @ID_Arbitro_SDA_1,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

SELECT * FROM reglamento.SeDesignaArbitro

PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Partido_SDA_Mod INT = (SELECT MAX(PartidoID) FROM torneo.Partido);
DECLARE @ID_Arbitro_SDA_Mod INT = (SELECT MAX(PersonaID) FROM reglamento.Arbitro);

-- EXITO
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_Mod,
    @ArbitroID = @ID_Arbitro_SDA_Mod,
    @Informe = 'Partido finalizado sin incidentes',
    @RolArbitral = 'VAR';

-- FRACASO: Designacion inexistente
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = 99999,
    @Informe = 'Sin incidentes',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Informe vacio
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_Mod,
    @ArbitroID = @ID_Arbitro_SDA_Mod,
    @Informe = '',
    @RolArbitral = 'Arbitro principal';

-- FRACASO: Rol arbitral vacio
EXEC reglamento.SP_Modificacion_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_Mod,
    @ArbitroID = @ID_Arbitro_SDA_Mod,
    @Informe = 'Sin incidentes',
    @RolArbitral = '';

SELECT * FROM reglamento.SeDesignaArbitro

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Partido_SDA_Baja INT = (SELECT MAX(PartidoID) FROM torneo.Partido);
DECLARE @ID_Arbitro_SDA_Baja INT = (SELECT MAX(PersonaID) FROM reglamento.Arbitro);

-- EXITO
EXEC reglamento.SP_Baja_SeDesignaArbitro
    @PartidoID = @ID_Partido_SDA_Baja,
    @ArbitroID = @ID_Arbitro_SDA_Baja;

-- FRACASO: Designacion inexistente
EXEC reglamento.SP_Baja_SeDesignaArbitro
    @PartidoID = 99999,
    @ArbitroID = 99999;
GO

SELECT * FROM reglamento.SeDesignaArbitro

--=======================
-- Pruebas de Exhibicion
--=======================

-- Obtener una pieza publicitaria existente
DECLARE @ID_Pieza_Exhibicion INT = (
    SELECT MIN(PiezaID)
    FROM publicidad.PiezaPublicitaria
);

SELECT * FROM publicidad.Exhibicion

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

SELECT * FROM publicidad.Exhibicion

PRINT 'PRUEBAS DE MODIFICACION'

DECLARE @ID_Prueba_Exhibicion INT = (
    SELECT MAX(ExhibicionID)
    FROM publicidad.Exhibicion
    WHERE Espacio IN ('Espacio de Prueba', 'Pantalla de Prueba Modificada')
);
DECLARE @ID_Pieza_Exh_Mod INT = (SELECT MIN(PiezaID) FROM publicidad.PiezaPublicitaria);

-- EXITO
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla de Prueba Modificada',
    @PiezaID = @ID_Pieza_Exh_Mod,
    @Costo = 25000;

-- FRACASO: Exhibicion inexistente
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = 99999,
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exh_Mod,
    @Costo = 15000;

-- FRACASO: Espacio vacio
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = '',
    @PiezaID = @ID_Pieza_Exh_Mod,
    @Costo = 15000;

-- FRACASO: Espacio NULL
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = NULL,
    @PiezaID = @ID_Pieza_Exh_Mod,
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
    @PiezaID = @ID_Pieza_Exh_Mod,
    @Costo = -1000;

-- FRACASO: Costo NULL
EXEC publicidad.SP_Modificacion_Exhibicion
    @ExhibicionID = @ID_Prueba_Exhibicion,
    @Espacio = 'Pantalla gigante',
    @PiezaID = @ID_Pieza_Exh_Mod,
    @Costo = NULL;

SELECT * FROM publicidad.Exhibicion

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Baja_Exhibicion INT = (
    SELECT MAX(ExhibicionID)
    FROM publicidad.Exhibicion
    WHERE Espacio IN ('Espacio de Prueba', 'Pantalla de Prueba Modificada')
);

-- EXITO
EXEC publicidad.SP_Baja_Exhibicion
    @ExhibicionID = @ID_Baja_Exhibicion;

-- FRACASO: Exhibicion inexistente
EXEC publicidad.SP_Baja_Exhibicion
    @ExhibicionID = 99999;
GO

SELECT * FROM publicidad.Exhibicion

--=================================
-- Pruebas de CuentaConExhibicion
--=================================

DECLARE @ID_Exh_CCE_1 INT = (SELECT MIN(ExhibicionID) FROM publicidad.Exhibicion);
DECLARE @ID_Exh_CCE_2 INT = (SELECT MAX(ExhibicionID) FROM publicidad.Exhibicion);
DECLARE @ID_Part_CCE_1 INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Part_CCE_2 INT = (SELECT MAX(PartidoID) FROM torneo.Partido);

SELECT * FROM publicidad.CuentaConExhibicion

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_1, @PartidoID = @ID_Part_CCE_1;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_1, @PartidoID = @ID_Part_CCE_2;

-- ÉXITO para eliminar
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_2, @PartidoID = @ID_Part_CCE_2;

-- FRACASO
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 99999, @PartidoID = @ID_Part_CCE_1;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_1, @PartidoID = 99999;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_1, @PartidoID = @ID_Part_CCE_1;

PRINT 'PRUEBAS DE MODIFICACIÓN omitidas por ser una tabla de una relacion sin atributos propios'

SELECT * FROM publicidad.CuentaConExhibicion

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Exh_CCE_Baja INT = (SELECT MAX(ExhibicionID) FROM publicidad.Exhibicion);
DECLARE @ID_Part_CCE_Baja INT = (SELECT MAX(PartidoID) FROM torneo.Partido);

-- ÉXITO:
EXEC publicidad.SP_Baja_CuentaConExhibicion @ExhibicionID = @ID_Exh_CCE_Baja, @PartidoID = @ID_Part_CCE_Baja;

-- FRACASO
EXEC publicidad.SP_Baja_CuentaConExhibicion @ExhibicionID = 99999, @PartidoID = 99999;
GO

SELECT * FROM publicidad.CuentaConExhibicion

--========================
-- Tabla PersonaHabla
--========================

DECLARE @ID_Pers_PH_1 INT = (SELECT MIN(PersonaID) FROM torneo.Persona);
DECLARE @ID_Pers_PH_2 INT = (SELECT MAX(PersonaID) FROM torneo.Persona);
DECLARE @ID_Idioma_PH_1 INT = (SELECT MIN(IdiomaID) FROM torneo.Idioma);
DECLARE @ID_Idioma_PH_2 INT = (SELECT MAX(IdiomaID) FROM torneo.Idioma);

SELECT * FROM torneo.PersonaHabla

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO (Queda cargado)
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = @ID_Pers_PH_1, @IdiomaID = @ID_Idioma_PH_1;

-- ÉXITO para eliminar
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = @ID_Pers_PH_2, @IdiomaID = @ID_Idioma_PH_2;

-- FRACASO
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = 999999, @IdiomaID = @ID_Idioma_PH_1;
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = @ID_Pers_PH_2, @IdiomaID = 999999;
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = @ID_Pers_PH_1, @IdiomaID = @ID_Idioma_PH_1;

SELECT * FROM torneo.PersonaHabla


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Pers_PH_Baja INT = (SELECT MAX(PersonaID) FROM torneo.Persona);
DECLARE @ID_Idioma_PH_Baja INT = (SELECT MAX(IdiomaID) FROM torneo.Idioma);

-- ÉXITO:
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = @ID_Pers_PH_Baja, @IdiomaID = @ID_Idioma_PH_Baja;

-- FRACASO
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = 99999, @IdiomaID = @ID_Idioma_PH_Baja;
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = @ID_Pers_PH_Baja, @IdiomaID = 99999;
GO

SELECT * FROM torneo.PersonaHabla

--=================================
-- Tabla InteresPublicitario
--=================================

DECLARE @ID_Anun_IP INT = (SELECT MIN(AnuncianteID) FROM publicidad.Anunciante);
DECLARE @ID_Pais_IP INT = (SELECT MIN(PaisID) FROM torneo.Pais);

SELECT * FROM publicidad.InteresPublicitario

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO (Queda cargado)
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = @ID_Anun_IP, @PaisID = @ID_Pais_IP, @Prioridad = 'Alta';

-- ÉXITO para modificar y eliminar
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = @ID_Anun_IP, @PaisID = @ID_Pais_IP, @Prioridad = 'Prioridad De Prueba';

-- FRACASO
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = 99999, @PaisID = @ID_Pais_IP, @Prioridad = 'Alta';
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = @ID_Anun_IP, @PaisID = 99999, @Prioridad = 'Alta';
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = @ID_Anun_IP, @PaisID = @ID_Pais_IP, @Prioridad = '';

SELECT * FROM publicidad.InteresPublicitario

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Interes_Prueba INT = (
    SELECT MAX(InteresID) 
    FROM publicidad.InteresPublicitario
    WHERE Prioridad IN ('Prioridad De Prueba', 'Baja Modificada')
);
DECLARE @ID_Anun_IP_Mod INT = (SELECT MIN(AnuncianteID) FROM publicidad.Anunciante);
DECLARE @ID_Pais_IP_Mod INT = (SELECT MIN(PaisID) FROM torneo.Pais);

-- ÉXITO
EXEC publicidad.SP_Modificacion_InteresPublicitario
    @InteresID = @ID_Interes_Prueba, 
    @AnuncianteID = @ID_Anun_IP_Mod,
    @PaisID = @ID_Pais_IP_Mod,
    @Prioridad = 'Baja Modificada';

-- FRACASO 1
EXEC publicidad.SP_Modificacion_InteresPublicitario 
    @InteresID = @ID_Interes_Prueba, 
    @AnuncianteID = @ID_Anun_IP_Mod, 
    @PaisID = 9999999,
    @Prioridad = 'Baja';

-- FRACASO 2
EXEC publicidad.SP_Modificacion_InteresPublicitario
    @InteresID = 99999, 
    @AnuncianteID = @ID_Anun_IP_Mod,
    @PaisID = @ID_Pais_IP_Mod,
    @Prioridad = 'Baja';

EXEC publicidad.SP_Modificacion_InteresPublicitario
    @InteresID = @ID_Interes_Prueba, 
    @AnuncianteID = @ID_Anun_IP_Mod,
    @PaisID = @ID_Pais_IP_Mod,
    @Prioridad = '';

SELECT * FROM publicidad.InteresPublicitario

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Interes_Baja INT = (
    SELECT MAX(InteresID) 
    FROM publicidad.InteresPublicitario
    WHERE Prioridad IN ('Prioridad De Prueba', 'Baja Modificada')
);

-- EXITO
EXEC publicidad.SP_Baja_InteresPublicitario @InteresID = @ID_Interes_Baja;

-- FRACASO
EXEC publicidad.SP_Baja_InteresPublicitario @InteresID = 99999;
GO

SELECT * FROM publicidad.InteresPublicitario


--=======================
-- Pruebas de Participa
--=======================

DECLARE @ID_Form_Part_1 INT = (SELECT MIN(FormacionID) FROM torneo.Formacion);
DECLARE @ID_Form_Part_2 INT = (SELECT MAX(FormacionID) FROM torneo.Formacion);
DECLARE @ID_Jug_Part_1 INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jug_Part_2 INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

SELECT * FROM torneo.Participa

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_1, @PersonaID = @ID_Jug_Part_1, @Titular = 1, @PosicionCancha = 'Delantero Derecho';
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_1, @PersonaID = @ID_Jug_Part_2, @Titular = 0, @PosicionCancha = 'Centrodelantero';

-- ÉXITO para modificar y eliminar
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_2, @PersonaID = @ID_Jug_Part_1, @Titular = 1, @PosicionCancha = 'Mediocampista';

-- FRACASO
EXEC torneo.SP_Alta_Participa @FormacionID = 99999, @PersonaID = @ID_Jug_Part_1, @Titular = 1, @PosicionCancha = 'Delantero';
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_1, @PersonaID = 99999, @Titular = 1, @PosicionCancha = 'Delantero';
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_1, @PersonaID = @ID_Jug_Part_1, @Titular = 1, @PosicionCancha = 'Delantero Derecho';
EXEC torneo.SP_Alta_Participa @FormacionID = @ID_Form_Part_2, @PersonaID = @ID_Jug_Part_2, @Titular = 1, @PosicionCancha = '';
EXEC torneo.SP_Alta_Participa @FormacionID = 9999, @PersonaID = 9999, @Titular = 1, @PosicionCancha = 'Delantero';

SELECT * FROM torneo.Participa


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Form_Part_Mod INT = (SELECT MAX(FormacionID) FROM torneo.Formacion);
DECLARE @ID_Jug_Part_Mod INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);

-- ÉXITO:
EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = @ID_Form_Part_Mod, 
    @PersonaID = @ID_Jug_Part_Mod, 
    @Titular = 0, 
    @PosicionCancha = 'Enganche Modificado';

-- FRACASO
EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 99999,
    @PersonaID = 99999, 
    @Titular = 0, 
    @PosicionCancha = 'Delantero';

EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = @ID_Form_Part_Mod, 
    @PersonaID = @ID_Jug_Part_Mod, 
    @Titular = 0, 
    @PosicionCancha = '';

EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 99999, 
    @PersonaID = 999999, 
    @Titular = 0, 
    @PosicionCancha = '';

SELECT * FROM torneo.Participa


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Form_Part_Baja INT = (SELECT MAX(FormacionID) FROM torneo.Formacion);
DECLARE @ID_Jug_Part_Baja INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);

-- ÉXITO:
EXEC torneo.SP_Baja_Participa @FormacionID = @ID_Form_Part_Baja, @PersonaID = @ID_Jug_Part_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Participa @FormacionID = 99999, @PersonaID = 99999;
GO

SELECT * FROM torneo.Participa

-- ==================
-- Pruebas de Juega
-- ==================

DECLARE @ID_Part_Juega_1 INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Part_Juega_2 INT = (SELECT MAX(PartidoID) FROM torneo.Partido);
DECLARE @ID_Sel_Juega_1 INT = (SELECT MIN(SeleccionID) FROM torneo.Seleccion);
DECLARE @ID_Sel_Juega_2 INT = (SELECT MAX(SeleccionID) FROM torneo.Seleccion);

SELECT * FROM torneo.Juega

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Juega @PartidoID = @ID_Part_Juega_1, @SeleccionID = @ID_Sel_Juega_1;
EXEC torneo.SP_Alta_Juega @PartidoID = @ID_Part_Juega_1, @SeleccionID = @ID_Sel_Juega_2;

-- ÉXITO para eliminar
EXEC torneo.SP_Alta_Juega @PartidoID = @ID_Part_Juega_2, @SeleccionID = @ID_Sel_Juega_1;

-- FRACASO
EXEC torneo.SP_Alta_Juega @PartidoID = 99999, @SeleccionID = @ID_Sel_Juega_1; 
EXEC torneo.SP_Alta_Juega @PartidoID = @ID_Part_Juega_1, @SeleccionID = 99999;
EXEC torneo.SP_Alta_Juega @PartidoID = @ID_Part_Juega_1, @SeleccionID = @ID_Sel_Juega_1;
EXEC torneo.SP_Alta_Juega @PartidoID = 9999, @SeleccionID = 99999;

PRINT 'PRUEBAS DE MODIFICACIÓN omitidas por ser una tabla de una relacion sin atributos propios'

SELECT * FROM torneo.Juega


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Part_Juega_Baja INT = (SELECT MAX(PartidoID) FROM torneo.Partido);
DECLARE @ID_Sel_Juega_Baja INT = (SELECT MIN(SeleccionID) FROM torneo.Seleccion);

-- ÉXITO:
EXEC torneo.SP_Baja_Juega @PartidoID = @ID_Part_Juega_Baja, @SeleccionID = @ID_Sel_Juega_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Juega @PartidoID = 99999, @SeleccionID = 99999;
GO

SELECT * FROM torneo.Juega

--=================================
-- Tabla Gol 
--=================================

DECLARE @ID_Part_Gol INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Jug_Gol_1 INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jug_Gol_2 INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

SELECT * FROM torneo.Gol

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO (Queda cargado)
EXEC torneo.SP_Alta_Gol @PartidoID = @ID_Part_Gol, @PersonaID = @ID_Jug_Gol_1, @AsistentePersonaID = @ID_Jug_Gol_2, @Periodo = 'Primer tiempo', @Tipo = 'Jugada colectiva', @Minuto = 23;

-- ÉXITO para modificar y eliminar
EXEC torneo.SP_Alta_Gol @PartidoID = @ID_Part_Gol, @PersonaID = @ID_Jug_Gol_1, @AsistentePersonaID = @ID_Jug_Gol_2, @Periodo = 'Primer tiempo', @Tipo = 'Penal', @Minuto = 3;

-- FRACASO
EXEC torneo.SP_Alta_Gol @PartidoID = 999999, @PersonaID = 999999, @AsistentePersonaID = 999999, @Periodo = '', @Tipo = '', @Minuto = NULL;

SELECT * FROM torneo.Gol


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Gol_Prueba INT = (SELECT MAX(GolID) FROM torneo.Gol);
DECLARE @ID_Part_Gol_Mod INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Jug_Gol_Mod1 INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jug_Gol_Mod2 INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

-- ÉXITO (Cambia periodo, tipo y minuto para evidenciar el cambio)
EXEC torneo.SP_Modificacion_Gol
    @GolID = @ID_Gol_Prueba,
    @PartidoID = @ID_Part_Gol_Mod, 
    @PersonaID = @ID_Jug_Gol_Mod1,
    @AsistentePersonaID = @ID_Jug_Gol_Mod2,
    @Periodo = 'Segundo tiempo',
    @Tipo = 'Tiro libre',
    @Minuto = 85;

-- Todos los FRACASOs 
EXEC torneo.SP_Modificacion_Gol 
    @GolID = 99999,
    @PartidoID = 99999, 
    @PersonaID = 99999,
    @AsistentePersonaID = 99999,
    @Periodo = '',
    @Tipo = '',
    @Minuto = NULL;

SELECT * FROM torneo.Gol


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Gol_Baja INT = (SELECT MAX(GolID) FROM torneo.Gol);

-- ÉXITO:
EXEC torneo.SP_Baja_Gol @GolID = @ID_Gol_Baja;

-- FRACASO
EXEC torneo.SP_Baja_Gol @GolID = 99999;
GO

SELECT * FROM torneo.Gol

-- =====================
-- Pruebas de Sancion
-- =====================

DECLARE @ID_Arb_Sanc_1 INT = (SELECT MIN(PersonaID) FROM reglamento.Arbitro);
DECLARE @ID_Arb_Sanc_2 INT = (SELECT MAX(PersonaID) FROM reglamento.Arbitro);

SELECT * FROM reglamento.Sancion

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Tarjeta Amarilla', @ArbitroID = @ID_Arb_Sanc_1;
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Tarjeta Roja', @ArbitroID = @ID_Arb_Sanc_2;

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Sancion de Prueba', @ArbitroID = @ID_Arb_Sanc_1;

-- FRACASO
EXEC reglamento.SP_Alta_Sancion @Descripcion = '', @ArbitroID = @ID_Arb_Sanc_1;
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Advertencia', @ArbitroID = 99999;
EXEC reglamento.SP_Alta_Sancion @Descripcion = '', @ArbitroID = 9999;

SELECT * FROM reglamento.Sancion


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Sancion_Prueba INT = (
    SELECT MAX(SancionID) 
    FROM reglamento.Sancion 
    WHERE Descripcion IN ('Sancion de Prueba', 'Sancion Modificada')
);
DECLARE @ID_Arb_Sanc_Mod INT = (SELECT MAX(PersonaID) FROM reglamento.Arbitro);

-- ÉXITO
EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = 'Sancion Modificada', 
    @ArbitroID = @ID_Arb_Sanc_Mod;

-- FRACASO
EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = 99999,
    @Descripcion = 'Intento Fallido', 
    @ArbitroID = @ID_Arb_Sanc_Mod;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = '',
    @ArbitroID = @ID_Arb_Sanc_Mod;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = 'Intento Fallido', 
    @ArbitroID = 99999;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = 9999, 
    @Descripcion = '', 
    @ArbitroID = 999999;

SELECT * FROM reglamento.Sancion


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Sancion_Baja INT = (
    SELECT MAX(SancionID) 
    FROM reglamento.Sancion 
    WHERE Descripcion IN ('Sancion de Prueba', 'Sancion Modificada')
);

-- ÉXITO:
EXEC reglamento.SP_Baja_Sancion @SancionID = @ID_Sancion_Baja;

-- FRACASO
EXEC reglamento.SP_Baja_Sancion @SancionID = 9999;
GO

SELECT * FROM reglamento.Sancion

--=================================
-- Tabla TarjetaAsignada 
--=================================

DECLARE @ID_Tarj_TA INT = (SELECT MIN(TarjetaID) FROM reglamento.Tarjeta);
DECLARE @ID_Part_TA INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Jug_TA_1 INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jug_TA_2 INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

SELECT * FROM reglamento.TarjetaAsignada

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO (Queda cargada)
EXEC reglamento.SP_Alta_TarjetaAsignada @TarjetaID = @ID_Tarj_TA, @PartidoID = @ID_Part_TA, @PersonaID = @ID_Jug_TA_1, @Minuto = 35, @Motivo = 'Falta táctica';

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_TarjetaAsignada @TarjetaID = @ID_Tarj_TA, @PartidoID = @ID_Part_TA, @PersonaID = @ID_Jug_TA_2, @Minuto = 10, @Motivo = 'Penal';

-- FRACASO
EXEC reglamento.SP_Alta_TarjetaAsignada @TarjetaID = 9999999, @PartidoID = 99999, @PersonaID = 99999, @Minuto = -5, @Motivo = '';

SELECT * FROM reglamento.TarjetaAsignada


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_TarjetaAsig_Prueba INT = (SELECT MAX(TarjetaAsignadaID) FROM reglamento.TarjetaAsignada);
DECLARE @ID_Tarj_TA_Mod INT = (SELECT MIN(TarjetaID) FROM reglamento.Tarjeta);
DECLARE @ID_Part_TA_Mod INT = (SELECT MIN(PartidoID) FROM torneo.Partido);
DECLARE @ID_Jug_TA_Mod INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

-- ÉXITO
EXEC reglamento.SP_Modificacion_TarjetaAsignada
    @TarjetaAsignadaID = @ID_TarjetaAsig_Prueba,
    @TarjetaID = @ID_Tarj_TA_Mod, 
    @PartidoID = @ID_Part_TA_Mod, 
    @PersonaID = @ID_Jug_TA_Mod, 
    @Minuto = 55, 
    @Motivo = 'Protesta reiterada';

-- Todos los FRACASOs 
EXEC reglamento.SP_Modificacion_TarjetaAsignada
    @TarjetaAsignadaID = 999999,
    @TarjetaID = 9999999, 
    @PartidoID = 9999999, 
    @PersonaID = 9999999, 
    @Minuto = -10, 
    @Motivo = '';

SELECT * FROM reglamento.TarjetaAsignada


PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_TarjetaAsig_Baja INT = (SELECT MAX(TarjetaAsignadaID) FROM reglamento.TarjetaAsignada);

-- ÉXITO:
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = @ID_TarjetaAsig_Baja;

-- FRACASO
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = 99999;
GO

SELECT * FROM reglamento.TarjetaAsignada

-- ========================
-- Pruebas de Suspension
-- ========================

DECLARE @ID_Jug_Susp_1 INT = (SELECT MIN(PersonaID) FROM torneo.Jugador);
DECLARE @ID_Jug_Susp_2 INT = (SELECT MAX(PersonaID) FROM torneo.Jugador);

SELECT * FROM reglamento.Suspension

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_Suspension @PersonaID = @ID_Jug_Susp_1, @Motivo = 'Acumulación de amarillas', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = @ID_Jug_Susp_2, @Motivo = 'Roja directa', @PartidosSuspendido = 2;

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Suspension @PersonaID = @ID_Jug_Susp_1, @Motivo = 'Suspension de Prueba', @PartidosSuspendido = 1;

-- FRACASO
EXEC reglamento.SP_Alta_Suspension @PersonaID = 99999, @Motivo = 'Juego brusco', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = @ID_Jug_Susp_1, @Motivo = '', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = @ID_Jug_Susp_1, @Motivo = 'Reclamo', @PartidosSuspendido = 0;
EXEC reglamento.SP_Alta_Suspension @PersonaID = 9999, @Motivo = '', @PartidosSuspendido = 0;

SELECT * FROM reglamento.Suspension


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Suspension_Prueba INT = (
    SELECT MAX(SuspensionID) 
    FROM reglamento.Suspension 
    WHERE Motivo IN ('Suspension de Prueba', 'Motivo Modificado')
);

-- ÉXITO
EXEC reglamento.SP_Modificacion_Suspension 
    @SuspensionID = @ID_Suspension_Prueba, 
    @Motivo = 'Motivo Modificado', 
    @PartidosSuspendido = 3;

-- FRACASO
EXEC reglamento.SP_Modificacion_Suspension 
    @SuspensionID = 99999,
    @Motivo = 'Intento Fallido', 
    @PartidosSuspendido = 1;

EXEC reglamento.SP_Modificacion_Suspension 
    @SuspensionID = @ID_Suspension_Prueba, 
    @Motivo = '',
    @PartidosSuspendido = 1;

EXEC reglamento.SP_Modificacion_Suspension 
    @SuspensionID = @ID_Suspension_Prueba, 
    @Motivo = 'Intento Fallido', 
    @PartidosSuspendido = -1;

EXEC reglamento.SP_Modificacion_Suspension 
    @SuspensionID = 9999, 
    @Motivo = '', 
    @PartidosSuspendido = -10;

SELECT * FROM reglamento.Suspension

PRINT 'PRUEBAS DE BAJA'

DECLARE @ID_Suspension_Baja INT = (
    SELECT MAX(SuspensionID) 
    FROM reglamento.Suspension 
    WHERE Motivo IN ('Suspension de Prueba', 'Motivo Modificado')
);

-- ÉXITO
EXEC reglamento.SP_Baja_Suspension @SuspensionID = @ID_Suspension_Baja;

-- FRACASO
EXEC reglamento.SP_Baja_Suspension @SuspensionID = 9999;
GO

SELECT * FROM reglamento.Suspension
