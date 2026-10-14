
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Insert y Testing de Store Procedure

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
