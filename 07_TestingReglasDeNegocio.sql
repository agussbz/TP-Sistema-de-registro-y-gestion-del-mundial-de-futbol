
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Insert y Testing de SP de Reglas de negocio

USE DB_Mundial_2026;
GO

-- =======================================
-- torneo.SP_RegistrarPartidoCompleto
-- =======================================

PRINT '--- 1. SP_RegistrarPartidoCompleto ---';

SELECT 'ANTES - Partido' AS Estado, * FROM torneo.Partido;
SELECT 'ANTES - Juega' AS Estado, * FROM torneo.Juega;

DECLARE 
    @SedeID INT, @Capacidad INT, @LocalID INT, @VisitanteID INT, @PartidoCreadoID INT;

SELECT TOP 1 @SedeID = SedeID, @Capacidad = Capacidad 
FROM torneo.Sede 
WHERE Capacidad IS NOT NULL 
ORDER BY SedeID;

SELECT TOP 1 @LocalID = SeleccionID FROM torneo.Seleccion ORDER BY SeleccionID;
SELECT TOP 1 @VisitanteID = SeleccionID 
FROM torneo.Seleccion WHERE SeleccionID <> @LocalID ORDER BY SeleccionID;

-- VALIDACIONES DE ERROR

-- Sede o Selecciones inexistentes
BEGIN TRY
    EXEC torneo.SP_RegistrarPartidoCompleto 
        @SedeID = -999, @LocalID = @LocalID, @VisitanteID = @VisitanteID,
        @Fase = 'Fase de Grupos', @Asistencia = 100, 
        @FechaHoraLocal = '2026-06-15T16:00:00', @FechaHoraUTC = '2026-06-15T20:00:00';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Una selección jugando contra sí misma
BEGIN TRY
    EXEC torneo.SP_RegistrarPartidoCompleto 
        @SedeID = @SedeID, @LocalID = @LocalID, @VisitanteID = @LocalID,
        @Fase = 'Fase de Grupos', @Asistencia = 100, 
        @FechaHoraLocal = '2026-06-15T16:00:00', @FechaHoraUTC = '2026-06-15T20:00:00';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Asistencia supera la capacidad máxima de la sede
BEGIN TRY
    EXEC torneo.SP_RegistrarPartidoCompleto 
        @SedeID = @SedeID, @LocalID = @LocalID, @VisitanteID = @VisitanteID,
        @Fase = 'Fase de Grupos', @Asistencia = 9999999, 
        @FechaHoraLocal = '2026-06-15T16:00:00', @FechaHoraUTC = '2026-06-15T20:00:00';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- PRUEBA DE EXITO ALTA
BEGIN TRY
    EXEC torneo.SP_RegistrarPartidoCompleto 
        @SedeID = @SedeID, @LocalID = @LocalID, @VisitanteID = @VisitanteID,
        @Fase = 'Fase de Grupos', @Asistencia = 1000, 
        @FechaHoraLocal = '2026-07-19T16:00:00', @FechaHoraUTC = '2026-07-19T20:00:00';
    PRINT ' EXITO: Partido y sus 2 selecciones registrados correctamente.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT 'DESPUÉS DEL ALTA - Partido' AS Estado, * FROM torneo.Partido;
SELECT 'DESPUÉS DEL ALTA - Juega' AS Estado, * FROM torneo.Juega;

-- PRUEBA DE BAJA
SELECT TOP 1 @PartidoCreadoID = PartidoID FROM torneo.Partido ORDER BY PartidoID DESC;

-- Intentar borrar el partido cuando todavía tiene selecciones asociadas en torneo.Juega
BEGIN TRY
    EXEC torneo.SP_Baja_Partido @PartidoID = @PartidoCreadoID;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- ==========================================
-- torneo.SP_ReemplazoUltMomento_Convocatoria
-- ==========================================

PRINT '--- 2. SP_ReemplazoUltMomento_Convocatoria ---';
SELECT 'ANTES - Jugador' AS Estado, * FROM torneo.Jugador;

DECLARE @ConvID INT, @JugadorBajaID INT, @PersonaNuevaID INT, @DorsalOcupado INT, @JugadorConPartidosID INT;

SELECT TOP 1 @ConvID = j.ConvocatoriaID, @JugadorBajaID = j.PersonaID
FROM torneo.Jugador j
WHERE NOT EXISTS (SELECT 1 FROM torneo.Participa pa WHERE pa.PersonaID = j.PersonaID)
  AND NOT EXISTS (SELECT 1 FROM torneo.Gol g WHERE g.PersonaID = j.PersonaID)
ORDER BY j.ConvocatoriaID;

SELECT TOP 1 @DorsalOcupado = Dorsal 
FROM torneo.Jugador 
WHERE ConvocatoriaID = @ConvID AND PersonaID <> @JugadorBajaID;

SELECT TOP 1 @PersonaNuevaID = p.PersonaID
FROM torneo.Persona p
WHERE NOT EXISTS (SELECT 1 FROM torneo.Jugador j WHERE j.PersonaID = p.PersonaID)
ORDER BY p.PersonaID DESC;

-- VALIDACIONES DE ERROR
-- Convocatoria o Jugador inexistente
BEGIN TRY
    EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
        @ConvocatoriaID = -999, @PersonaBajaID = -998, @PersonaAltaID = @PersonaNuevaID,
        @ClubOrigenAlta = 'Club Test', @DorsalAlta = 25, @PosicionHabitualAlta = 'Arquero';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Dorsal duplicado en la misma convocatoria
IF @DorsalOcupado IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
            @ConvocatoriaID = @ConvID, @PersonaBajaID = @JugadorBajaID, @PersonaAltaID = @PersonaNuevaID,
            @ClubOrigenAlta = 'Club Test', @DorsalAlta = @DorsalOcupado, @PosicionHabitualAlta = 'Defensor';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

-- PRUEBA DE EXITO ALTA

IF @ConvID IS NOT NULL AND @JugadorBajaID IS NOT NULL AND @PersonaNuevaID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_ReemplazoUltMomento_Convocatoria
            @ConvocatoriaID = @ConvID, @PersonaBajaID = @JugadorBajaID, @PersonaAltaID = @PersonaNuevaID,
            @ClubOrigenAlta = 'Club Reemplazo OK', @DorsalAlta = 99, @PosicionHabitualAlta = 'Delantero';
        PRINT 'EXITO: Reemplazo de convocatoria ejecutado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

SELECT 'DESPUÉS DEL ALTA - Jugador' AS Estado, * FROM torneo.Jugador WHERE ConvocatoriaID = @ConvID;
GO


-- =======================================
-- torneo.SP_RegistrarAlineacion_Validada
-- =======================================

PRINT '--- 3. SP_RegistrarAlineacion_Validada ---';
SELECT 'ANTES - Participa' AS Estado, * FROM torneo.Participa;

DECLARE @FormacionID INT, @JugadorValidoID INT, @JugadorYaAlineadoID INT;
SELECT TOP 1 @FormacionID = FormacionID FROM torneo.Formacion ORDER BY FormacionID;

-- VALIDACIONES DE ERROR
-- Formación inexistente

BEGIN TRY
    EXEC torneo.SP_RegistrarAlineacion_Validada 
        @FormacionID = -999, @PersonaID = 1, @Titular = 1, @PosicionCancha = 'Defensor';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Jugador ya registrado en esa misma formación

SELECT TOP 1 @FormacionID = FormacionID, @JugadorYaAlineadoID = PersonaID FROM torneo.Participa;
IF @JugadorYaAlineadoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarAlineacion_Validada 
            @FormacionID = @FormacionID, @PersonaID = @JugadorYaAlineadoID, @Titular = 0, @PosicionCancha = 'Suplente';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

-- PRUEBA DE EXITO ALTA

SELECT TOP 1 @JugadorValidoID = j.PersonaID
FROM torneo.Jugador j
WHERE NOT EXISTS (SELECT 1 FROM reglamento.Suspension s WHERE s.PersonaID = j.PersonaID AND s.PartidosSuspendido > 0)
  AND NOT EXISTS (SELECT 1 FROM torneo.Participa pa WHERE pa.FormacionID = @FormacionID AND pa.PersonaID = j.PersonaID);

IF @FormacionID IS NOT NULL AND @JugadorValidoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC torneo.SP_RegistrarAlineacion_Validada 
            @FormacionID = @FormacionID, @PersonaID = @JugadorValidoID, @Titular = 0, @PosicionCancha = 'Suplente';
        PRINT 'EXITO: Jugador agregado a la alineación correctamente.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

SELECT 'DESPUÉS DEL ALTA - Participa' AS Estado, * FROM torneo.Participa WHERE FormacionID = @FormacionID;
GO

-- =======================================
-- torneo.SP_RegistrarCambioPartido
-- =======================================

PRINT '--- 4. SP_RegistrarCambioPartido ---';
SELECT 'ANTES - Sustitucion' AS Estado, * FROM torneo.Sustitucion;

DECLARE @PartidoID INT, @SaleID INT, @EntraID INT, @JugadorOtraSeleccionID INT;
SELECT TOP 1 @PartidoID = PartidoID FROM torneo.Partido ORDER BY PartidoID;

SELECT TOP 1 @SaleID = j1.PersonaID, @EntraID = j2.PersonaID
FROM torneo.Jugador j1
JOIN torneo.Jugador j2 ON j1.ConvocatoriaID = j2.ConvocatoriaID AND j1.PersonaID <> j2.PersonaID;

SELECT TOP 1 @JugadorOtraSeleccionID = j3.PersonaID
FROM torneo.Jugador j3
WHERE j3.ConvocatoriaID <> (SELECT ConvocatoriaID FROM torneo.Jugador WHERE PersonaID = @SaleID);

-- VALIDACIONES DE ERROR
-- El mismo jugador entra y sale

BEGIN TRY
    EXEC torneo.SP_RegistrarCambioPartido 
        @PartidoID = @PartidoID, @JugadorSaleID = @SaleID, @JugadorEntraID = @SaleID,
        @NumeroVentana = 1, @Minuto = 55, @Motivo = 'Táctico';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Número de ventana inválido (> 3)

BEGIN TRY
    EXEC torneo.SP_RegistrarCambioPartido 
        @PartidoID = @PartidoID, @JugadorSaleID = @SaleID, @JugadorEntraID = @EntraID,
        @NumeroVentana = 99, @Minuto = 55, @Motivo = 'Táctico';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- PRUEBA DE EXITO ALTA

BEGIN TRY
    EXEC torneo.SP_RegistrarCambioPartido 
        @PartidoID = @PartidoID, @JugadorSaleID = @SaleID, @JugadorEntraID = @EntraID,
        @NumeroVentana = 1, @Minuto = 65, @Motivo = 'Táctico';
    PRINT 'EXITO: Sustitución registrada correctamente.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT 'DESPUÉS DEL ALTA - Sustitucion' AS Estado, * FROM torneo.Sustitucion;
GO

-- ============================================
-- torneo.SP_RegistrarGol_Y_ActualizarResultado
-- ============================================

PRINT '--- 5. SP_RegistrarGol_Y_ActualizarResultado ---';

DECLARE @PartidoGolID INT, @GoleadorValidoID INT;
SELECT TOP 1 @PartidoGolID = j.PartidoID, @GoleadorValidoID = jug.PersonaID
FROM torneo.Juega j
JOIN torneo.Convocatoria c ON c.SeleccionID = j.SeleccionID
JOIN torneo.Jugador jug ON jug.ConvocatoriaID = c.ConvocatoriaID;

SELECT 'ANTES - Gol' AS Estado, * FROM torneo.Gol WHERE PartidoID = @PartidoGolID;
SELECT 'ANTES - Marcador Partido' AS Estado, PartidoID, Fase, ResultadoFinal FROM torneo.Partido WHERE PartidoID = @PartidoGolID;

-- VALIDACIONES DE ERROR
-- Minuto fuera de rango (negativo)

BEGIN TRY
    EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado 
        @PartidoID = @PartidoGolID, @PersonaID = @GoleadorValidoID,
        @AsistentePersonaID = NULL, @Periodo = 'Primer Tiempo', @Tipo = 'Jugada', @Minuto = -10;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- Goleador y Asistente son la misma persona
BEGIN TRY
    EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado 
        @PartidoID = @PartidoGolID, @PersonaID = @GoleadorValidoID,
        @AsistentePersonaID = @GoleadorValidoID, @Periodo = 'Primer Tiempo', @Tipo = 'Jugada', @Minuto = 20;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- PRUEBA DE EXITO ALTA

BEGIN TRY
    EXEC torneo.SP_RegistrarGol_Y_ActualizarResultado 
        @PartidoID = @PartidoGolID, @PersonaID = @GoleadorValidoID,
        @AsistentePersonaID = NULL, @Periodo = 'Primer Tiempo', @Tipo = 'Jugada', @Minuto = 25;
    PRINT 'EXITO: Gol insertado y ResultadoFinal actualizado en Partido.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT 'DESPUÉS DEL ALTA - Gol' AS Estado, * FROM torneo.Gol WHERE PartidoID = @PartidoGolID;
SELECT 'DESPUÉS DEL ALTA - Marcador Partido' AS Estado, PartidoID, Fase, ResultadoFinal FROM torneo.Partido WHERE PartidoID = @PartidoGolID;
GO

-- ===========================================
-- reglamento.SP_ProcesarTarjeta_Y_Suspension
-- ===========================================

PRINT '--- 6. SP_ProcesarTarjeta_Y_Suspension ---';
SELECT 'ANTES - TarjetaAsignada' AS Estado, * FROM reglamento.TarjetaAsignada;
SELECT 'ANTES - Suspension' AS Estado, * FROM reglamento.Suspension;

DECLARE @TarjetaRojaID INT, @PartidoTarjetaID INT, @JugadorTarjetaID INT;
SELECT TOP 1 @TarjetaRojaID = TarjetaID FROM reglamento.Tarjeta WHERE Tipo LIKE '%Roja%' ORDER BY TarjetaID;
IF @TarjetaRojaID IS NULL SELECT TOP 1 @TarjetaRojaID = TarjetaID FROM reglamento.Tarjeta ORDER BY TarjetaID;

SELECT TOP 1 @PartidoTarjetaID = PartidoID FROM torneo.Partido ORDER BY PartidoID;
SELECT TOP 1 @JugadorTarjetaID = PersonaID FROM torneo.Jugador ORDER BY PersonaID DESC;

-- VALIDACIONES DE ERROR
-- Tarjeta inexistente

BEGIN TRY
    EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension 
        @TarjetaID = -999, @PartidoID = @PartidoTarjetaID, @PersonaID = @JugadorTarjetaID, 
        @Minuto = 40, @Motivo = 'Falta fuerte';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- PRUEBA DE EXITO ALTA
BEGIN TRY
    EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension 
        @TarjetaID = @TarjetaRojaID, @PartidoID = @PartidoTarjetaID, @PersonaID = @JugadorTarjetaID, 
        @Minuto = 80, @Motivo = 'Roja directa por infracción';
    PRINT 'EXITO: Tarjeta asignada y suspensión automática generada.';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT 'DESPUÉS DEL ALTA - TarjetaAsignada' AS Estado, * FROM reglamento.TarjetaAsignada;
SELECT 'DESPUÉS DEL ALTA - Suspension' AS Estado, * FROM reglamento.Suspension;
GO

-- ===========================================
-- reglamento.SP_DesignarArbitro_SinConflicto
-- ===========================================

PRINT '--- 7. SP_DesignarArbitro_SinConflicto ---';
SELECT 'ANTES - SeDesignaArbitro' AS Estado, * FROM reglamento.SeDesignaArbitro;

DECLARE @PartidoArbID INT, @ArbitroNeutralID INT, @ArbitroConConflictoID INT;
SELECT TOP 1 @PartidoArbID = p.PartidoID
FROM torneo.Partido p
WHERE (SELECT COUNT(*) FROM torneo.Juega j WHERE j.PartidoID = p.PartidoID) >= 2;

SELECT TOP 1 @ArbitroConConflictoID = a.PersonaID
FROM reglamento.Arbitro a
JOIN torneo.Seleccion s ON s.Pais = a.Pais
JOIN torneo.Juega j ON j.SeleccionID = s.SeleccionID
WHERE j.PartidoID = @PartidoArbID;

SELECT TOP 1 @ArbitroNeutralID = a.PersonaID
FROM reglamento.Arbitro a
WHERE NOT EXISTS (
    SELECT 1 FROM torneo.Juega j
    JOIN torneo.Seleccion s ON s.SeleccionID = j.SeleccionID
    WHERE j.PartidoID = @PartidoArbID AND s.Pais = a.Pais
)
AND NOT EXISTS (
    SELECT 1 FROM reglamento.SeDesignaArbitro sda
    WHERE sda.PartidoID = @PartidoArbID AND sda.PersonaID = a.PersonaID
);

-- VALIDACIONES DE ERROR
-- Conflicto de nacionalidad
IF @ArbitroConConflictoID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_DesignarArbitro_SinConflicto 
            @PartidoID = @PartidoArbID, @ArbitroID = @ArbitroConConflictoID, 
            @Informe = 'Pendiente', @RolArbitral = 'Principal';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

-- PRUEBA DE EXITO ALTA
IF @PartidoArbID IS NOT NULL AND @ArbitroNeutralID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC reglamento.SP_DesignarArbitro_SinConflicto 
            @PartidoID = @PartidoArbID, @ArbitroID = @ArbitroNeutralID, 
            @Informe = 'Sin incidencias', @RolArbitral = 'Principal';
        PRINT 'EXITO: Árbitro neutral designado al partido correctamente.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

SELECT 'DESPUÉS DEL ALTA - SeDesignaArbitro' AS Estado, * FROM reglamento.SeDesignaArbitro WHERE PartidoID = @PartidoArbID;
GO

-- ============================================
-- publicidad.SP_AsignarCuatroPiezasPorPartido
-- =============================================

PRINT '--- 8. SP_AsignarCuatroPiezasPorPartido ---';

DECLARE @PartidoPubID INT;
SELECT TOP 1 @PartidoPubID = p.PartidoID
FROM torneo.Partido p
WHERE (SELECT COUNT(*) FROM publicidad.CuentaConExhibicion c WHERE c.PartidoID = p.PartidoID) = 0;

SELECT 'ANTES - CuentaConExhibicion' AS Estado, * FROM publicidad.CuentaConExhibicion WHERE PartidoID = @PartidoPubID;

-- VALIDACIONES DE ERROR
-- Partido inexistente
BEGIN TRY
    EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID = -999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- PRUEBA DE EXITO ALTA
IF @PartidoPubID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID = @PartidoPubID;
        PRINT 'EXITO: Se asignaron los 4 paneles publicitarios al partido.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

SELECT 'DESPUÉS DEL ALTA - CuentaConExhibicion' AS Estado, * FROM publicidad.CuentaConExhibicion WHERE PartidoID = @PartidoPubID;

-- VALIDACIÓN DE CUPO LLENO (Intento de duplicar espacios)
IF @PartidoPubID IS NOT NULL
BEGIN
    BEGIN TRY
        EXEC publicidad.SP_AsignarCuatroPiezasPorPartido @PartidoID = @PartidoPubID;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

-- Consultas de ejemplo

-- Jugadores que recibieron tarjetas amarillas
SELECT per.Nombre, per.Apellido, s.Pais AS Seleccion, ta.Minuto, ta.Motivo, p.PartidoID
FROM reglamento.TarjetaAsignada ta
INNER JOIN reglamento.Tarjeta t
    ON ta.TarjetaID = t.TarjetaID
INNER JOIN torneo.Jugador j
    ON ta.PersonaID = j.PersonaID
INNER JOIN torneo.Persona per
    ON j.PersonaID = per.PersonaID
INNER JOIN torneo.Convocatoria c
    ON j.ConvocatoriaID = c.ConvocatoriaID
INNER JOIN torneo.Seleccion s
    ON c.SeleccionID = s.SeleccionID
INNER JOIN torneo.Partido p
    ON ta.PartidoID = p.PartidoID
WHERE t.Tipo = 'Amarilla'
ORDER BY p.PartidoID, ta.Minuto;

-- Jugadores que hicieron goles
SELECT per.Nombre, per.Apellido, s.Pais AS Seleccion, g.Minuto, g.Periodo, g.Tipo, p.ResultadoFinal
FROM torneo.Gol g
INNER JOIN torneo.Jugador j
    ON g.PersonaID = j.PersonaID
INNER JOIN torneo.Persona per
    ON j.PersonaID = per.PersonaID
INNER JOIN torneo.Convocatoria c
    ON j.ConvocatoriaID = c.ConvocatoriaID
INNER JOIN torneo.Seleccion s
    ON c.SeleccionID = s.SeleccionID
INNER JOIN torneo.Partido p
    ON g.PartidoID = p.PartidoID
ORDER BY p.PartidoID, g.Minuto;


-- Partidos con sus selecciones y sede
SELECT p.PartidoID, s1.Pais AS SeleccionLocal, s2.Pais AS SeleccionVisitante, p.ResultadoFinal, p.Fase, se.NombreEstadio, se.Ciudad
FROM torneo.Partido p
INNER JOIN torneo.Juega j1
    ON p.PartidoID = j1.PartidoID
INNER JOIN torneo.Juega j2
    ON p.PartidoID = j2.PartidoID
   AND j1.SeleccionID < j2.SeleccionID
INNER JOIN torneo.Seleccion s1
    ON j1.SeleccionID = s1.SeleccionID
INNER JOIN torneo.Seleccion s2
    ON j2.SeleccionID = s2.SeleccionID
INNER JOIN torneo.Sede se
    ON p.SedeID = se.SedeID
ORDER BY p.PartidoID;



-- Publicidad exhibida en cada partido
SELECT p.PartidoID, se.NombreEstadio, ex.Espacio, pp.Contenido, ca.Nombre AS Campaña, a.Pais AS PaisAnunciante, ex.Costo
FROM publicidad.CuentaConExhibicion ce
INNER JOIN publicidad.Exhibicion ex
    ON ce.ExhibicionID = ex.ExhibicionID
INNER JOIN publicidad.PiezaPublicitaria pp
    ON ex.PiezaID = pp.PiezaID
INNER JOIN publicidad.Campaña ca
    ON pp.CampañaID = ca.CampañaID
INNER JOIN publicidad.Anunciante a
    ON ca.AnuncianteID = a.AnuncianteID
INNER JOIN torneo.Partido p
    ON ce.PartidoID = p.PartidoID
INNER JOIN torneo.Sede se
    ON p.SedeID = se.SedeID
ORDER BY p.PartidoID, ex.Espacio;