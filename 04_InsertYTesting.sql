
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

USE DB_Mundial_2026
GO

--=======================
-- Pruebas de Pais
--=======================
 
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
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Pais_Prueba INT = (SELECT PaisID FROM torneo.Pais WHERE Nombre = 'Venezuela');

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
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC Torneo.SP_Baja_Pais @PaisID = @ID_Pais_Prueba;
 
-- FRACASO
EXEC Torneo.SP_Baja_Pais @PaisID = 99999;

DECLARE @IDconInteresPublicitario INT = (SELECT TOP 1 p.PaisID FROM torneo.Pais p JOIN publicidad.InteresPublicitario i ON p.PaisID=i.PaisID)

IF @IDconInteresPublicitario IS NULL
    PRINT 'No hay datos en la tabla Interes Publicitario'
ELSE
    EXEC torneo.SP_Baja_Pais @IDconInteresPublicitario

--=======================
-- Pruebas de Tarjeta
--=======================
 
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
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Tarjeta_Prueba INT = (SELECT TarjetaID FROM reglamento.Tarjeta WHERE Tipo = 'Tarjeta De Prueba');
 
-- EXITO
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = 'Tarjeta Modificada';
 
-- FRACASO
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = 99999, @tipo = 'Tarjeta Inexistente';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = '';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba, @tipo = 'Roja';
EXEC reglamento.SP_Modificacion_Tarjeta @TarjetaID = 99999, @tipo = '';
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC reglamento.SP_Baja_Tarjeta @TarjetaID = @ID_Tarjeta_Prueba;
 
-- FRACASO
EXEC reglamento.SP_Baja_Tarjeta @TarjetaID = 99999;
GO
----- agregar una donde ya fue asignada a un partido

--=======================
-- Pruebas de Convocatoria
--=======================
 
PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 1;
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 1;

-- FRACASO
EXEC torneo.SP_Alta_Convocatoria @SeleccionID = 99999;
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Convocatoria_Prueba INT = (SELECT TOP 1 ConvocatoriaID FROM torneo.Convocatoria);
 
-- EXITO
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = @ID_Convocatoria_Prueba, @SeleccionID = 2;
 
-- FRACASO
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = 99999, @SeleccionID = 1;
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = @ID_Convocatoria_Prueba, @SeleccionID = 99999;
EXEC torneo.SP_Modificacion_Convocatoria @ConvocatoriaID = 99999, @SeleccionID = 99999;
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC torneo.SP_Baja_Convocatoria @ConvocatoriaID = @ID_Convocatoria_Prueba;
 
-- FRACASO
EXEC torneo.SP_Baja_Convocatoria @ConvocatoriaID = 99999;
GO

DECLARE @Jugador INT = (SELECT TOP 1 c.ConvocatoriaID  FROM torneo.Jugador j JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID)

EXEC torneo.SP_Baja_Convocatoria @Jugador

--=======================
-- Pruebas de Cuerpo Tecnico
--=======================
 
DECLARE @ID_Persona_A INT = (SELECT TOP 1 PersonaID FROM torneo.Persona);
DECLARE @ID_Persona_B INT = (SELECT TOP 1 PersonaID FROM torneo.Persona);
DECLARE @ID_Persona_C INT = (SELECT TOP 1 PersonaID FROM torneo.Persona);

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
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
-- EXITO
EXEC torneo.SP_Modificacion_CuerpoTecnico
    @PersonaID = @ID_Persona_B,
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
    @PersonaID = @ID_Persona_C,
    @SeleccionID = 2,
    @SeleccionAnterior = 1,
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
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = @ID_Persona_B;
 
-- FRACASO
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = 99999;
EXEC torneo.SP_Baja_CuerpoTecnico @PersonaID = @ID_Persona_C;
GO
 
--=======================
-- Pruebas de Partido
--=======================
 
PRINT 'PRUEBAS DE ALTA'
 
-- EXITO
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Fase de Grupos', @Asistencia = 80000, @ResultadoFinal = '2-1', @FechaHoraLocal = '2026-06-11 15:00', @FechaHoraUTC = '2026-06-11 21:00';
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Octavos de Final', @Asistencia = 75000, @ResultadoFinal = '0-0', @FechaHoraLocal = '2026-07-01 18:00', @FechaHoraUTC = '2026-07-01 22:00';
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = 'Fase De Prueba', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
 
-- FRACASO
EXEC torneo.SP_Alta_Partido @SedeID = 99999, @Fase = 'Fase de Grupos', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
EXEC torneo.SP_Alta_Partido @SedeID = 1, @Fase = '', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
EXEC torneo.SP_Alta_Partido @SedeID = 99999, @Fase = '', @Asistencia = 1000, @ResultadoFinal = '1-1', @FechaHoraLocal = '2026-06-20 12:00', @FechaHoraUTC = '2026-06-20 18:00';
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Partido_Prueba INT = (SELECT MAX(PartidoID) FROM torneo.Partido WHERE Fase = 'Fase De Prueba');
 
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
    @FechaHoraUTC = '2026-06-11 21:00'

PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC torneo.SP_Baja_Partido @PartidoID = @ID_Partido_Prueba;
 
-- FRACASO
EXEC torneo.SP_Baja_Partido @PartidoID = 99999; 
 -- fijarse si dejar las validaciones

 --=======================
-- Pruebas de Sustitucion
--=======================
 
PRINT 'PRUEBAS DE ALTA'
 select * from torneo.Partido
-- EXITO
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 2, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 3, @JugadorSaleID = 2, @JugadorEntraID = 1, @NumeroVentana = 1, @Minuto = 75, @Motivo = 'Lesion';
 
-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 2, @Minuto = 80, @Motivo = 'Precaucion';
 
-- FRACASO
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 99999, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 2, @JugadorSaleID = 1, @JugadorEntraID = 99999, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 3, @JugadorSaleID = 99999, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 3, @JugadorSaleID = 1, @JugadorEntraID = 1, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 3, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 0, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 2, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = -1, @Motivo = 'Tactico';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 2, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = -10, @Minuto = 60, @Motivo = '';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Otro';
EXEC torneo.SP_Alta_Sustitucion @PartidoID = 99999, @JugadorSaleID = 99999, @JugadorEntraID = 99999, @NumeroVentana = 0, @Minuto = -1, @Motivo = '';
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Sustitucion_Prueba INT = (SELECT MAX(SustitucionID) FROM torneo.Sustitucion);
 
-- EXITO
EXEC torneo.SP_Modificacion_Sustitucion
    @SustitucionID = @ID_Sustitucion_Prueba,
    @PartidoID = 1,
    @JugadorSaleID = 2,
    @JugadorEntraID = 1,
    @NumeroVentana = 3,
    @Minuto = 85,
    @Motivo = 'Lesion';
 
-- FRACASO
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = 99999, @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 99999, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 0, @Minuto = 60, @Motivo = 'Tactico';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = '';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba, @PartidoID = 1, @JugadorSaleID = 1, @JugadorEntraID = 2, @NumeroVentana = 1, @Minuto = 60, @Motivo = 'Otro';
EXEC torneo.SP_Modificacion_Sustitucion @SustitucionID = 99999, @PartidoID = 99999, @JugadorSaleID = 99999, @JugadorEntraID = 99999, @NumeroVentana = 0, @Minuto = -1, @Motivo = '';
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC torneo.SP_Baja_Sustitucion @SustitucionID = @ID_Sustitucion_Prueba;
 
-- FRACASO
EXEC torneo.SP_Baja_Sustitucion @SustitucionID = 99999;
GO

--=======================
-- Pruebas de Campaña
--=======================
 
PRINT 'PRUEBAS DE ALTA'

-- EXITO
EXEC publicidad.SP_Alta_Campaña @nombre = 'Locos', @fechaInicio = '2026-05-01', @AnuncianteID = 3;
EXEC publicidad.SP_Alta_Campaña @nombre = 'Soña en grande', @fechaInicio = '2026-06-01', @AnuncianteID = 4;
 
-- EXITO para modificar y eliminar
EXEC publicidad.SP_Alta_Campaña @nombre = 'Aliento', @fechaInicio = '2026-06-15', @AnuncianteID = 4;

-- FRACASO
EXEC publicidad.SP_Alta_Campaña @nombre = '', @fechaInicio = '2026-06-15', @AnuncianteID = 1;
EXEC publicidad.SP_Alta_Campaña @nombre = 'Promo mundial', @fechaInicio = '2026-06-15', @AnuncianteID = 99999;
EXEC publicidad.SP_Alta_Campaña @nombre = '', @fechaInicio = '2026-06-15', @AnuncianteID = 99999;
 
PRINT 'PRUEBAS DE MODIFICACIÓN'
 
DECLARE @ID_Campaña_Prueba INT = (SELECT TOP 1 CampañaID FROM publicidad.Campaña WHERE Nombre = 'Aliento');

-- EXITO
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = @ID_Campaña_Prueba,
    @Nombre = 'Jugamos todos',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = 3;
 
-- FRACASO
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = 99999,
    @Nombre = 'Seguro de sedes',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = 1;
 
EXEC publicidad.SP_Modificacion_Campaña
    @CampañaID = @ID_Campaña_Prueba,
    @Nombre = '',
    @fechaInicio = '2026-07-01',
    @AnuncianteID = 1;
 
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
 
PRINT 'PRUEBAS DE BAJA'
 
-- EXITO
EXEC publicidad.SP_Baja_Campaña @CampañaID = @ID_Campaña_Prueba;
 
-- FRACASO
EXEC publicidad.SP_Baja_Campaña @CampañaID = 99999;
GO

DECLARE @idPieza INT = (SELECT TOP 1 PiezaID FROM publicidad.PiezaPublicitaria)

EXEC publicidad.SP_Baja_Campaña @idPieza
use DB_Mundial_2026
go

-- Tabla IDIOMA
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Idioma @Nombre = 'Ingles';

-- FRACASO
EXEC torneo.SP_Alta_Idioma @Nombre = '';
EXEC torneo.SP_Alta_Idioma @Nombre = 'Ingles';

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Idioma_Prueba INT = (SELECT IdiomaID FROM torneo.Idioma WHERE Nombre = 'Ingles');

-- ÉXITO
EXEC torneo.SP_Modificacion_Idioma
    @IdiomaID = @ID_Idioma_Prueba, 
    @Nombre = 'Portugues'

-- FRACASO 1
EXEC torneo.SP_Modificacion_Idioma 
    @IdiomaID = 99999,
    @Nombre = 'Portugues'

-- FRACASO 2
EXEC torneo.SP_Modificacion_Idioma 
    @IdiomaID = @ID_Idioma_Prueba, 
    @Nombre = ''

    SELECT * FROM torneo.Idioma

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC torneo.SP_Baja_Idioma @IdiomaID = @ID_Idioma_Prueba;

-- FRACASO
EXEC torneo.SP_Baja_Idioma @IdiomaID = 99999;



-- Tabla ANUNCIANTE
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC publicidad.SP_Alta_Anunciante @Pais = 'Colombia';

-- FRACASO
EXEC publicidad.SP_Alta_Anunciante @Pais = '';

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Anunciante_Prueba INT = (SELECT TOP 1 AnuncianteID FROM publicidad.Anunciante WHERE Pais = 'Colombia');

-- ÉXITO
EXEC publicidad.SP_Modificacion_Anunciante
    @AnuncianteID = @ID_Anunciante_Prueba, 
    @Pais = 'Colombia'

-- FRACASO 1
EXEC publicidad.SP_Modificacion_Anunciante 
    @AnuncianteID = 9999,
    @Pais = 'Colombia'

-- FRACASO 2
EXEC publicidad.SP_Modificacion_Anunciante 
    @AnuncianteID = @ID_Anunciante_Prueba,
    @Pais = ''


PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC publicidad.SP_Baja_Anunciante @AnuncianteID = @ID_Anunciante_Prueba;

-- FRACASO
EXEC publicidad.SP_Baja_Anunciante @AnuncianteID = 99999;



-- Tabla Arbitro
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_ALTA_Arbitro @PersonaID = 1, @Pais = 'Colombia', @RolArbitral = 'Principal';

-- FRACASO
EXEC reglamento.SP_Alta_Arbitro @PersonaID = NULL, @Pais = 'Colombia', @RolArbitral = 'Principal';
EXEC reglamento.SP_Alta_Arbitro @PersonaID = 2, @Pais = '', @RolArbitral = 'Principal';
EXEC reglamento.SP_Alta_Arbitro @PersonaID = 2, @Pais = 'Colombia', @RolArbitral = '';

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Arbitro_Prueba INT = (SELECT TOP 1 PersonaID FROM reglamento.Arbitro WHERE Pais = 'Colombia');

-- ÉXITO
EXEC reglamento.SP_Modificacion_Arbitro
    @PersonaID = @ID_Arbitro_Prueba, 
    @Pais = 'Colombia',
    @RolArbitral = 'Principal';

-- FRACASO 1
EXEC reglamento.SP_Modificacion_Arbitro 
    @PersonaID = 9999,
    @Pais = '',
    @RolArbitral = 'Principal';

-- FRACASO 2
EXEC reglamento.SP_Modificacion_Arbitro
    @PersonaID = @ID_Arbitro_Prueba,
    @Pais = '',
    @RolArbitral = 'Principal';

EXEC reglamento.SP_Modificacion_Arbitro 
    @PersonaID = @ID_Arbitro_Prueba,
    @Pais = 'Colombia',
    @RolArbitral = '';

--===================
-- Pruebas de Sede
--===================

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

EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'México', @Capacidad = 83264, @HusoHorario = 'UTC-6';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'MetLife Stadium', @Ciudad = 'Nueva York', @Pais = 'Estados Unidos', @Capacidad = 82500, @HusoHorario = 'UTC-4';

-- EXITO para modificar y eliminar
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio De Prueba', @Ciudad = 'Ciudad Prueba', @Pais = 'Pais Prueba', @Capacidad = 50000, @HusoHorario = 'UTC-0';

-- FRACASO
EXEC torneo.SP_Alta_Sede @NombreEstadio = '', @Ciudad = 'Los Angeles', @Pais = 'Estados Unidos', @Capacidad = 70000, @HusoHorario = 'UTC-8';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Rose Bowl', @Ciudad = 'Los Angeles', @Pais = 'Estados Unidos', @Capacidad = 0, @HusoHorario = 'UTC-8';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'Mexico', @Capacidad = 83264, @HusoHorario = 'UTC-6';
EXEC torneo.SP_Alta_Sede @NombreEstadio = 'Estadio Azteca', @Ciudad = 'Ciudad de Mexico', @Pais = 'Mexico', @Capacidad = 0, @HusoHorario = 'UTC-8';

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Sede_Prueba INT = (SELECT SedeID FROM torneo.Sede WHERE NombreEstadio = 'Estadio De Prueba' AND Ciudad = 'Ciudad Prueba');

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

PRINT 'PRUEBAS DE BAJA'

-- EXITO:
EXEC torneo.SP_Baja_Sede @SedeID = @ID_Sede_Prueba;

-- FRACASO
EXEC torneo.SP_Baja_Sede @SedeID = 99999;
GO

--=======================
-- Pruebas de Seleccion
--=======================

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

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Prueba INT = (SELECT SeleccionID FROM torneo.Seleccion WHERE Pais = 'Seleccion De Prueba');

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

PRINT 'PRUEBAS DE BAJA'

-- EXITO:
EXEC torneo.SP_Baja_Seleccion @SeleccionID = @ID_Prueba;

-- FRACASO
EXEC torneo.SP_Baja_Seleccion @SeleccionID = 99999;
GO

--=================================
-- Pruebas de CuentaConExhibicion
--=================================

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 1, @PartidoID = 1;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 1, @PartidoID = 2;

-- ÉXITO para eliminar
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 2, @PartidoID = 2;

-- FRACASO
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 99999, @PartidoID = 1;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 1, @PartidoID = 99999;
EXEC publicidad.SP_Alta_CuentaConExhibicion @ExhibicionID = 1, @PartidoID = 1;

PRINT 'PRUEBAS DE MODIFICACIÓN omitidas por ser una tabla de una relacion sin atributos propios'

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC reglamento.SP_Baja_Arbitro @PersonaID = 1;

-- FRACASO
EXEC reglamento.SP_Baja_Arbitro @PersonaID = 99999;
GO



-- Tabla PersonaHabla
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = 1, @IdiomaID = 1;

-- FRACASO
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = 999999, @IdiomaID = 1;
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = 2, @IdiomaID = '';
EXEC torneo.SP_Alta_PersonaHabla @PersonaID = 1, @IdiomaID = 1;

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = 1, @IdiomaID = 1;

-- FRACASO
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = 99999, @IdiomaID = 1;
EXEC torneo.SP_Baja_PersonaHabla @PersonaID = 1, @IdiomaID = 99999;
GO


-- Tabla InteresPublicitario
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = 1, @PaisID = 1, @Prioridad = 'alta';

-- FRACASO
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = 99999, @PaisID = 1, @Prioridad = 'alta';
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = 1, @PaisID = 99999, @Prioridad = 'alta';
EXEC publicidad.SP_Alta_InteresPublicitario @AnuncianteID = 1, @PaisID = 1, @Prioridad = '';

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Arbitro_Prueba INT = (SELECT TOP 1 PersonaID FROM reglamento.Arbitro WHERE Pais = 'Colombia');

-- ÉXITO
EXEC publicidad.SP_Alta_InteresPublicitario
    @AnuncianteID = @ID_Arbitro_Prueba, 
    @PaisID = 1,
    @Prioridad = 'baja';

-- FRACASO 1
EXEC publicidad.SP_Alta_InteresPublicitario 
    @AnuncianteID = @ID_Arbitro_Prueba, 
    @PaisID = 9999999,
    @Prioridad = 'baja';

-- FRACASO 2
EXEC publicidad.SP_Alta_InteresPublicitario
    @AnuncianteID = 99999, 
    @PaisID = 1,
    @Prioridad = 'baja';

EXEC publicidad.SP_Alta_InteresPublicitario
    @AnuncianteID = @ID_Arbitro_Prueba, 
    @PaisID = 1,
    @Prioridad = '';

EXEC publicidad.SP_Baja_CuentaConExhibicion @ExhibicionID = 2, @PartidoID = 2;

-- FRACASO
EXEC publicidad.SP_Baja_CuentaConExhibicion @ExhibicionID = 99999, @PartidoID = 99999;
GO

--=======================
-- Pruebas de Participa
--=======================

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Participa @FormacionID = 1, @PersonaID = 1, @Titular = 1, @PosicionCancha = 'Arquero';
EXEC torneo.SP_Alta_Participa @FormacionID = 1, @PersonaID = 2, @Titular = 0, @PosicionCancha = 'Defensor';

-- ÉXITO para modificar y eliminar
EXEC torneo.SP_Alta_Participa @FormacionID = 2, @PersonaID = 1, @Titular = 1, @PosicionCancha = 'Mediocampista';

-- FRACASO
EXEC torneo.SP_Alta_Participa @FormacionID = 99999, @PersonaID = 1, @Titular = 1, @PosicionCancha = 'Delantero';
EXEC torneo.SP_Alta_Participa @FormacionID = 1, @PersonaID = 99999, @Titular = 1, @PosicionCancha = 'Delantero';
EXEC torneo.SP_Alta_Participa @FormacionID = 1, @PersonaID = 1, @Titular = 1, @PosicionCancha = 'Arquero';
EXEC torneo.SP_Alta_Participa @FormacionID = 2, @PersonaID = 2, @Titular = 1, @PosicionCancha = '';
EXEC torneo.SP_Alta_Participa @FormacionID = 9999, @PersonaID = 9999, @Titular = 1, @PosicionCancha = 'Delantero';

PRINT 'PRUEBAS DE MODIFICACIÓN'

-- ÉXITO:
EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 2, 
    @PersonaID = 1, 
    @Titular = 0, 
    @PosicionCancha = 'Delantero';

-- FRACASO
EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 99999,
    @PersonaID = 99999, 
    @Titular = 0, 
    @PosicionCancha = 'Delantero';

EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 2, 
    @PersonaID = 1, 
    @Titular = 0, 
    @PosicionCancha = '';

EXEC torneo.SP_Modificacion_Participa 
    @FormacionID = 99999, 
    @PersonaID = 999999, 
    @Titular = 0, 
    @PosicionCancha = '';

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC torneo.SP_Baja_Participa @FormacionID = 2, @PersonaID = 1;

-- FRACASO
EXEC torneo.SP_Baja_Participa @FormacionID = 99999, @PersonaID = 99999;
GO

-- ==================
-- Pruebas de Juega
-- ==================

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Juega @PartidoID = 1, @SeleccionID = 1;
EXEC torneo.SP_Alta_Juega @PartidoID = 1, @SeleccionID = 2;

-- ÉXITO para eliminar
EXEC torneo.SP_Alta_Juega @PartidoID = 2, @SeleccionID = 1;

-- FRACASO
EXEC torneo.SP_Alta_Juega @PartidoID = 99999, @SeleccionID = 1; 
EXEC torneo.SP_Alta_Juega @PartidoID = 1, @SeleccionID = 99999;
EXEC torneo.SP_Alta_Juega @PartidoID = 1, @SeleccionID = 1;
EXEC torneo.SP_Alta_Juega @PartidoID = 9999, @SeleccionID = 99999;

PRINT 'PRUEBAS DE MODIFICACIÓN omitidas por ser una tabla de una relacion sin atributos propios'

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC publicidad.SP_Baja_InteresPublicitario @InteresID = 1;

-- FRACASO
EXEC publicidad.SP_Baja_InteresPublicitario @InteresID = 99999;
GO


-- Tabla Gol 
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC torneo.SP_Alta_Gol @PartidoID = 1, @PersonaID = 1, @AsistentePersonaID = 2, @Periodo = 'Primer tiempo', @Tipo = 'Penal', @Minuto = 3;

-- FRACASO
EXEC torneo.SP_Alta_Gol @PartidoID = 999999, @PersonaID = 999999, @AsistentePersonaID = 999999, @Periodo = '', @Tipo = '', @Minuto = 0;


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Gol_Prueba INT = (SELECT TOP 1 PersonaID FROM reglamento.Arbitro WHERE Pais = 'Colombia');

-- ÉXITO
EXEC torneo.SP_Modificacion_Gol
    @GolID = 1,
    @PartidoID = @ID_Gol_Prueba, 
    @PersonaID = 1,
    @AsistentePersonaID = 'baja',
    @Periodo = 'Primer tiempo',
    @Tipo = 'Penal',
    @Minuto = 3;

-- Todos los FRACASOs 
EXEC torneo.SP_Modificacion_Gol 
    @GolID = 99999,
    @PartidoID = 99999, 
    @PersonaID = 99999,
    @AsistentePersonaID = '',
    @Periodo = '',
    @Tipo = '',
    @Minuto = NULL;


EXEC torneo.SP_Baja_Juega @PartidoID = 2, @SeleccionID = 1;

-- FRACASO
EXEC torneo.SP_Baja_Juega @PartidoID = 99999, @SeleccionID = 99999;
GO

-- =====================
-- Pruebas de Sancion
-- =====================

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Tarjeta Amarilla', @ArbitroID = 1;
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Tarjeta Roja', @ArbitroID = 2;

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Sancion de Prueba', @ArbitroID = 1;

-- FRACASO
EXEC reglamento.SP_Alta_Sancion @Descripcion = '', @ArbitroID = 1;
EXEC reglamento.SP_Alta_Sancion @Descripcion = 'Advertencia', @ArbitroID = 99999;
EXEC reglamento.SP_Alta_Sancion @Descripcion = '', @ArbitroID = 9999;

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Sancion_Prueba INT = (SELECT SancionID FROM reglamento.Sancion WHERE Descripcion = 'Sancion de Prueba');

-- ÉXITO
EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = 'Sancion Modificada', 
    @ArbitroID = 2;

-- FRACASO
EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = 99999,
    @Descripcion = 'Intento Fallido', 
    @ArbitroID = 1;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = '',
    @ArbitroID = 1;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = @ID_Sancion_Prueba, 
    @Descripcion = 'Intento Fallido', 
    @ArbitroID = 99999;

EXEC reglamento.SP_Modificacion_Sancion 
    @SancionID = 9999, 
    @Descripcion = '', 
    @ArbitroID = 999999;

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC torneo.SP_Baja_Gol @GolID = 1;

-- FRACASO
EXEC torneo.SP_Baja_Gol @GolID = 99999;
GO



-- Tabla TarjetaAsignada 
PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_TarjetaAsignada @TarjetaID = 1, @PartidoID = 1, @PersonaID = 2, @Minuto = 1, @Motivo = 'Penal';

-- FRACASO
EXEC reglamento.SP_Alta_TarjetaAsignada @TarjetaID = 9999999, @PartidoID = 99999, @PersonaID = 99999, @Minuto = 99999, @Motivo = '';


PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Gol_Prueba INT = (SELECT TOP 1 PersonaID FROM reglamento.Arbitro WHERE Pais = 'Colombia');

-- ÉXITO
EXEC reglamento.SP_Alta_TarjetaAsignada 
    @TarjetaID = 1, 
    @PartidoID = 1, 
    @PersonaID = 2, 
    @Minuto = 1, 
    @Motivo = 'Tiro libre';

-- Todos los FRACASOs 
EXEC reglamento.SP_Alta_TarjetaAsignada 
    @TarjetaID = 9999999, 
    @PartidoID = 9999999, 
    @PersonaID = 9999999, 
    @Minuto = 99999, 
    @Motivo = '';

EXEC reglamento.SP_Baja_Sancion @SancionID = @ID_Sancion_Prueba;

-- FRACASO
EXEC reglamento.SP_Baja_Sancion @SancionID = 9999;
GO

-- ========================
-- Pruebas de Suspension
-- ========================

PRINT 'PRUEBAS DE ALTA'

-- ÉXITO
EXEC reglamento.SP_Alta_Suspension @PersonaID = 1, @Motivo = 'Acumulación de amarillas', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = 2, @Motivo = 'Roja directa', @PartidosSuspendido = 2;

-- ÉXITO para modificar y eliminar
EXEC reglamento.SP_Alta_Suspension @PersonaID = 1, @Motivo = 'Suspension de Prueba', @PartidosSuspendido = 1;

-- FRACASO
EXEC reglamento.SP_Alta_Suspension @PersonaID = 99999, @Motivo = 'Juego brusco', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = 1, @Motivo = '', @PartidosSuspendido = 1;
EXEC reglamento.SP_Alta_Suspension @PersonaID = 1, @Motivo = 'Reclamo', @PartidosSuspendido = 0;
EXEC reglamento.SP_Alta_Suspension @PersonaID = 9999, @Motivo = '', @PartidosSuspendido = 0;

PRINT 'PRUEBAS DE MODIFICACIÓN'

DECLARE @ID_Suspension_Prueba INT = (SELECT SuspensionID FROM reglamento.Suspension WHERE Motivo = 'Suspension de Prueba');

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

PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = 1;

-- FRACASO
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = 99999;
GO
EXEC reglamento.SP_Baja_Suspension @SuspensionID = @ID_Suspension_Prueba;

-- FRACASO
EXEC reglamento.SP_Baja_Suspension @SuspensionID = 9999;
GO
