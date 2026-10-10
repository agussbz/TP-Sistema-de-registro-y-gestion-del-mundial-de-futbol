
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


PRINT 'PRUEBAS DE BAJA'

-- ÉXITO:
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = 1;

-- FRACASO
EXEC reglamento.SP_Baja_TarjetaAsignada @TarjetaAsignadaID = 99999;
GO
