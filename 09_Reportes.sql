
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 20/11/2026

-- Objetivo: Stored Procedures de Reportes

USE DB_Mundial_2026;
GO

-- ============================================
-- 1. Goleadores por selección, fase y torneo
-- ============================================

CREATE OR ALTER PROCEDURE torneo.SP_Reporte_Goleadores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.Pais AS Seleccion,
        CONCAT(per.Nombre, ' ', per.Apellido) AS Jugador,
        j.Dorsal,
        p.Fase,
        COUNT(g.GolID) AS GolesEnFase,
        SUM(COUNT(g.GolID)) OVER (PARTITION BY j.PersonaID) AS TotalGolesTorneo,
        SUM(COUNT(g.GolID)) OVER (PARTITION BY s.SeleccionID) AS TotalGolesSeleccion
    FROM torneo.Gol g

    INNER JOIN torneo.Jugador j ON g.PersonaID = j.PersonaID
    INNER JOIN torneo.Persona per ON j.PersonaID = per.PersonaID
    INNER JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID
    INNER JOIN torneo.Seleccion s ON c.SeleccionID = s.SeleccionID
    INNER JOIN torneo.Partido p ON g.PartidoID = p.PartidoID

    GROUP BY s.SeleccionID, s.Pais, j.PersonaID, per.Nombre, per.Apellido, j.Dorsal, p.Fase
    ORDER BY TotalGolesTorneo DESC, s.Pais, p.Fase;
END;
GO

-- ====================================================
-- 2. Tarjetas por selección y jugador, y suspensiones
-- ====================================================

CREATE OR ALTER PROCEDURE reglamento.SP_Reporte_Tarjetas_Y_Suspensiones
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.Pais AS Seleccion,
        CONCAT(per.Nombre, ' ', per.Apellido) AS Jugador,
        j.Dorsal,
        j.PosicionHabitual,
        SUM(CASE WHEN t.Tipo LIKE '%Amarilla%' THEN 1 ELSE 0 END) AS CantidadAmarillas,
        SUM(CASE WHEN t.Tipo LIKE '%Roja%' THEN 1 ELSE 0 END) AS CantidadRojas,
        CASE 
            WHEN SUM(CASE WHEN t.Tipo LIKE '%Roja%' THEN 1 ELSE 0 END) > 0 THEN ISNULL(MAX(sus.PartidosSuspendido), 1)
            WHEN SUM(CASE WHEN t.Tipo LIKE '%Amarilla%' THEN 1 ELSE 0 END) >= 2 THEN 1 -- O el cálculo de partidos por amarillas
            ELSE 0
        END AS PartidosSuspensionActivos,
        CASE 
            WHEN SUM(CASE WHEN t.Tipo LIKE '%Roja%' THEN 1 ELSE 0 END) > 0 THEN 'Expulsión por Roja Directa'
            WHEN SUM(CASE WHEN t.Tipo LIKE '%Amarilla%' THEN 1 ELSE 0 END) >= 2 THEN 'Acumulación de amarillas'
            ELSE 'Sin suspensión activa'
        END AS DetalleSuspension
    FROM reglamento.TarjetaAsignada ta
    INNER JOIN reglamento.Tarjeta t ON ta.TarjetaID = t.TarjetaID
    INNER JOIN torneo.Jugador j ON ta.PersonaID = j.PersonaID
    INNER JOIN torneo.Persona per ON j.PersonaID = per.PersonaID
    INNER JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID
    INNER JOIN torneo.Seleccion s ON c.SeleccionID = s.SeleccionID
    LEFT JOIN reglamento.Suspension sus ON j.PersonaID = sus.PersonaID
    GROUP BY s.Pais, j.PersonaID, per.Nombre, per.Apellido, j.Dorsal, j.PosicionHabitual
    ORDER BY PartidosSuspensionActivos DESC, CantidadRojas DESC, CantidadAmarillas DESC;
END;
GO

-- ==================================================================
-- 3. Designaciones arbitrales y tarjetas que señaló en cada partido
-- ==================================================================

CREATE OR ALTER PROCEDURE reglamento.SP_Reporte_DesignacionesArbitrales
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CONCAT(per.Nombre, ' ', per.Apellido) AS Arbitro,
        a.Pais AS NacionalidadArbitro,
        sda.RolArbitral AS RolEnPartido,
        p.PartidoID,
        p.Fase,
        CAST(p.FechaHoraLocal AS DATE) AS FechaPartido,
        sda.Informe,
        (SELECT COUNT(*) FROM reglamento.TarjetaAsignada ta 
         INNER JOIN reglamento.Tarjeta t ON ta.TarjetaID = t.TarjetaID 
         WHERE ta.PartidoID = p.PartidoID AND t.Tipo LIKE '%Amarilla%') AS AmonestacionesEnPartido,
        (SELECT COUNT(*) FROM reglamento.TarjetaAsignada ta 
         INNER JOIN reglamento.Tarjeta t ON ta.TarjetaID = t.TarjetaID 
         WHERE ta.PartidoID = p.PartidoID AND t.Tipo LIKE '%Roja%') AS ExpulsionesEnPartido
    FROM reglamento.SeDesignaArbitro sda

    INNER JOIN reglamento.Arbitro a ON sda.ArbitroID = a.PersonaID
    INNER JOIN torneo.Persona per ON a.PersonaID = per.PersonaID
    INNER JOIN torneo.Partido p ON sda.PartidoID = p.PartidoID

    ORDER BY Arbitro, p.PartidoID;
END;
GO

-- ===================================================
-- 4. Ocupación publicitaria por sede y partido (XML)
-- ===================================================

CREATE OR ALTER PROCEDURE publicidad.SP_Reporte_OcupacionPublicitaria_XML
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        se.NombreEstadio AS [@Estadio],
        se.Ciudad AS [@Ciudad],
        se.Pais AS [@PaisSede],
        (
            SELECT 
                p.PartidoID AS [@PartidoID],
                p.Fase AS [@Fase],
                SUM(ex.Costo + pp.Tarifa) AS [@IngresosTotalesPartido],
                (
                    SELECT 
                        ex.Espacio AS [Espacio],
                        a.Pais AS [PaisAnunciante],
                        ca.Nombre AS [Campaña],
                        pp.Contenido AS [PiezaPublicitaria],
                        ex.Costo AS [CostoEspacio],
                        pp.Tarifa AS [TarifaPieza],
                        (ex.Costo + pp.Tarifa) AS [SubtotalIngreso]
                    FROM publicidad.CuentaConExhibicion ce2
                    INNER JOIN publicidad.Exhibicion ex ON ce2.ExhibicionID = ex.ExhibicionID
                    INNER JOIN publicidad.PiezaPublicitaria pp ON ex.PiezaID = pp.PiezaID
                    INNER JOIN publicidad.Campaña ca ON pp.CampañaID = ca.CampañaID
                    INNER JOIN publicidad.Anunciante a ON ca.AnuncianteID = a.AnuncianteID
                    WHERE ce2.PartidoID = p.PartidoID
                    FOR XML PATH('PanelExhibido'), TYPE
                ) AS [EspaciosPublicitarios]
            FROM torneo.Partido p

            INNER JOIN publicidad.CuentaConExhibicion ce ON p.PartidoID = ce.PartidoID
            INNER JOIN publicidad.Exhibicion ex ON ce.ExhibicionID = ex.ExhibicionID
            INNER JOIN publicidad.PiezaPublicitaria pp ON ex.PiezaID = pp.PiezaID

            WHERE p.SedeID = se.SedeID
            GROUP BY p.PartidoID, p.Fase
            FOR XML PATH('Partido'), TYPE
        ) AS [Partidos]
    FROM torneo.Sede se
    WHERE EXISTS (
        SELECT 1 FROM torneo.Partido p2 
        INNER JOIN publicidad.CuentaConExhibicion ce3 ON p2.PartidoID = ce3.PartidoID
        WHERE p2.SedeID = se.SedeID
    )
    FOR XML PATH('Sede'), ROOT('OcupacionPublicitariaPorSede');
END;
GO

-- =========================
-- 5. Matriz de Prime Time
-- =========================

CREATE OR ALTER PROCEDURE publicidad.SP_Reporte_MatrizPrimeTime
AS
BEGIN
    SET NOCOUNT ON;

    WITH CalculoHorarioMercado AS (
        SELECT 
            p.PartidoID,
            p.Fase,
            CONVERT(VARCHAR(16), p.FechaHoraUTC, 120) AS FechaHoraUTC,
            pa.Nombre AS PaisMercado,
            CASE 
                WHEN DATEPART(HOUR, DATEADD(HOUR, 
                    TRY_CAST(REPLACE(REPLACE(pa.HusoHorario, 'UTC', ''), '+', '') AS INT), 
                    p.FechaHoraUTC)) BETWEEN 19 AND 23 
                THEN 'EN PRIME TIME'
                ELSE '-'
            END AS EstadoPrimeTime
        FROM torneo.Partido p
        CROSS JOIN torneo.Pais pa
    )
    SELECT 
        PartidoID,
        Fase,
        FechaHoraUTC,
        ISNULL([Argentina], '-') AS [Argentina (UTC-3)],
        ISNULL([Brasil], '-') AS [Brasil (UTC-3)],
        ISNULL([Estados Unidos], '-') AS [Estados Unidos (UTC-4)],
        ISNULL([Colombia], '-') AS [Colombia (UTC-5)],
        ISNULL([México], '-') AS [México (UTC-6)],
        ISNULL([España], '-') AS [España (UTC+1)],
        ISNULL([Inglaterra], '-') AS [Inglaterra (UTC+0)],
        ISNULL([Japón], '-') AS [Japón (UTC+9)]
    FROM CalculoHorarioMercado
    PIVOT (
        MAX(EstadoPrimeTime)
        FOR PaisMercado IN ([Argentina], [Brasil], [Estados Unidos], [Colombia], [México], [España], [Inglaterra], [Japón])
    ) AS Pvt
    ORDER BY PartidoID;
END;
GO

-- ==================================
-- 6. Selecciones y plantillas (XML)
-- ==================================

CREATE OR ALTER PROCEDURE torneo.SP_Reporte_SeleccionesYPlantillas_XML
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.SeleccionID AS [@SeleccionID],
        s.Pais AS [@Seleccion],
        s.Confederacion AS [@Confederacion],
        (
            SELECT 
                j.Dorsal AS [@Dorsal],
                CONCAT(per.Nombre, ' ', per.Apellido) AS [NombreCompleto],
                j.PosicionHabitual AS [Posicion],
                j.ClubOrigen AS [Club]
            FROM torneo.Convocatoria c
            INNER JOIN torneo.Jugador j ON c.ConvocatoriaID = j.ConvocatoriaID
            INNER JOIN torneo.Persona per ON j.PersonaID = per.PersonaID
            WHERE c.SeleccionID = s.SeleccionID
            ORDER BY j.Dorsal
            FOR XML PATH('Convocado'), ROOT('PlantillaConvocados'), TYPE
        )
    FROM torneo.Seleccion s
    ORDER BY s.Pais
    FOR XML PATH('Seleccion'), ROOT('SeleccionesMundial2026');
END;
GO

-- ================================
-- 7. Resultados de los encuentros
-- ================================

CREATE OR ALTER PROCEDURE torneo.SP_Reporte_ResultadosEncuentros
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.PartidoID AS [Nro Partido],
        p.Fase,
        CONVERT(VARCHAR(16), p.FechaHoraLocal, 120) AS [Fecha y Hora Local],
        se.NombreEstadio AS Estadio,
        CONCAT(se.Ciudad, ' (', se.Pais, ')') AS Sede,
        s1.Pais AS [Selección 1],
        ISNULL(p.ResultadoFinal, '0-0') AS [Marcador],
        s2.Pais AS [Selección 2],
        p.Asistencia AS [Espectadores],
        CONCAT(CAST((p.Asistencia * 100.0 / NULLIF(se.Capacidad, 0)) AS DECIMAL(5,1)), '%') AS [% Ocupación Estadio]
    FROM torneo.Partido p

    INNER JOIN torneo.Sede se ON p.SedeID = se.SedeID
    INNER JOIN torneo.Juega j1 ON p.PartidoID = j1.PartidoID
    INNER JOIN torneo.Juega j2 ON p.PartidoID = j2.PartidoID AND j1.SeleccionID < j2.SeleccionID
    INNER JOIN torneo.Seleccion s1 ON j1.SeleccionID = s1.SeleccionID
    INNER JOIN torneo.Seleccion s2 ON j2.SeleccionID = s2.SeleccionID

    ORDER BY p.FechaHoraLocal, p.PartidoID;
END;
GO

-- ===========================
-- Ejecucion de los reportes
-- ===========================

PRINT '1. Ejecutando Reporte de Goleadores...';
EXEC torneo.SP_Reporte_Goleadores;

PRINT '2. Ejecutando Reporte de Tarjetas y Suspensiones Activas...';
EXEC reglamento.SP_Reporte_Tarjetas_Y_Suspensiones;

PRINT '3. Ejecutando Reporte de Designaciones Arbitrales...';
EXEC reglamento.SP_Reporte_DesignacionesArbitrales;

PRINT '4. Ejecutando Reporte de Ocupación Publicitaria (XML)...';
EXEC publicidad.SP_Reporte_OcupacionPublicitaria_XML;

PRINT '5. Ejecutando Matriz de Prime Time (PIVOT)...';
EXEC publicidad.SP_Reporte_MatrizPrimeTime;

PRINT '6. Ejecutando Reporte de Selecciones y Plantillas con Vector Anidado (XML)...';
EXEC torneo.SP_Reporte_SeleccionesYPlantillas_XML;

PRINT '7. Ejecutando Reporte Ilustrativo de Resultados de Encuentros...';
EXEC torneo.SP_Reporte_ResultadosEncuentros;
GO