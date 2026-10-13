
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
