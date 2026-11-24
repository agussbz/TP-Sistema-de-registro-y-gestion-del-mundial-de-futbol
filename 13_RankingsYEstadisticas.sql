-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 09/10/2026

-- Objetivo: Creacion de Rankings y Estadisticas

USE DB_Mundial_2026;
GO

-- ==================================================
-- RANKING DE GOLEADORES DEL MUNDIAL
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_RankingGoleadores
    @Top INT,
    @Seleccion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top <= 0
    BEGIN
        THROW 50001, 'La cantidad debe ser mayor a cero.', 1;
    END;

    IF @Seleccion IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM torneo.Seleccion
           WHERE Pais = @Seleccion
       )
    BEGIN
        THROW 50002, 'La seleccion ingresada no existe.', 1;
    END;

    ;WITH Goleadores AS
    (
        SELECT
            p.PersonaID,
            p.Nombre,
            p.Apellido,
            s.Pais AS Seleccion,
            j.Dorsal,
            COUNT(*) AS Goles,
            COUNT(DISTINCT g.PartidoID) AS PartidosConGol
        FROM torneo.Gol g
        INNER JOIN torneo.Persona p
            ON p.PersonaID = g.PersonaID
        INNER JOIN torneo.Jugador j
            ON j.PersonaID = g.PersonaID
        INNER JOIN torneo.Convocatoria c
            ON c.ConvocatoriaID = j.ConvocatoriaID
        INNER JOIN torneo.Seleccion s
            ON s.SeleccionID = c.SeleccionID
        WHERE @Seleccion IS NULL
           OR s.Pais = @Seleccion
        GROUP BY
            p.PersonaID,
            p.Nombre,
            p.Apellido,
            s.Pais,
            j.Dorsal
    )

    SELECT TOP (@Top)
        DENSE_RANK() OVER (
            ORDER BY Goles DESC
        ) AS Ranking,
        Nombre,
        Apellido,
        Seleccion,
        Goles
    FROM Goleadores
    ORDER BY Goles DESC, Apellido, PersonaID;
END;
GO

-- PRUEBA DE EXITO - TOP 10 GOLEADORES --

EXEC torneo.SP_RankingGoleadores
    @Top = 10;
GO


-- ==================================================
-- RANKING DE ASISTIDORES DEL MUNDIAL
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_RankingAsistidores
    @Top INT = 10,
    @Seleccion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top <= 0
    BEGIN
        THROW 50001, 'La cantidad debe ser mayor a cero.', 1;
    END;

    IF @Seleccion IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM torneo.Seleccion
           WHERE Pais = @Seleccion
       )
    BEGIN
        THROW 50002, 'La seleccion ingresada no existe.', 1;
    END;

    ;WITH Asistidores AS
    (
        SELECT
            p.PersonaID,
            p.Nombre,
            p.Apellido,
            s.Pais AS Seleccion,
            j.Dorsal,
            COUNT(*) AS Asistencias,
            COUNT(DISTINCT g.PartidoID) AS PartidosConAsistencia
        FROM torneo.Gol g
        INNER JOIN torneo.Persona p
            ON p.PersonaID = g.AsistentePersonaID
        INNER JOIN torneo.Jugador j
            ON j.PersonaID = g.AsistentePersonaID
        INNER JOIN torneo.Convocatoria c
            ON c.ConvocatoriaID = j.ConvocatoriaID
        INNER JOIN torneo.Seleccion s
            ON s.SeleccionID = c.SeleccionID
        WHERE g.AsistentePersonaID IS NOT NULL
          AND (@Seleccion IS NULL OR s.Pais = @Seleccion)
        GROUP BY
            p.PersonaID,
            p.Nombre,
            p.Apellido,
            s.Pais,
            j.Dorsal
    )

    SELECT TOP (@Top)
        DENSE_RANK() OVER (
            ORDER BY Asistencias DESC
        ) AS Ranking,
        Nombre,
        Apellido,
        Seleccion,
        Asistencias
    FROM Asistidores
    ORDER BY Asistencias DESC, Apellido, PersonaID;
END;
GO

-- PRUEBA DE EXITO - TOP 10 ASISTIDORES --

EXEC torneo.SP_RankingAsistidores
    @top = 10;
GO

USE DB_Mundial_2026;
GO

-- ==================================================
-- RANKING DE VALLAS INVICTAS POR SELECCION
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_RankingVallasInvictas
    @Top INT = 48
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top <= 0
    BEGIN
        THROW 50001, 'La cantidad debe ser mayor a cero.', 1;
    END;

    ;WITH GolesPorSeleccion AS
    (
        SELECT
            g.PartidoID,
            c.SeleccionID,
            COUNT(*) AS Goles
        FROM torneo.Gol g
        INNER JOIN torneo.Jugador j
            ON g.PersonaID = j.PersonaID
        INNER JOIN torneo.Convocatoria c
            ON j.ConvocatoriaID = c.ConvocatoriaID
        GROUP BY g.PartidoID, c.SeleccionID
    ),
    Resultados AS
    (
        SELECT
            j1.SeleccionID,
            p.PartidoID,
            ISNULL(g.Goles, 0) AS GolesRecibidos

        FROM torneo.Juega j1

        INNER JOIN torneo.Juega j2
            ON j1.PartidoID = j2.PartidoID
            AND j1.SeleccionID <> j2.SeleccionID

        INNER JOIN torneo.Partido p
            ON j1.PartidoID = p.PartidoID

        LEFT JOIN GolesPorSeleccion g
            ON p.PartidoID = g.PartidoID
            AND j2.SeleccionID = g.SeleccionID

        WHERE p.ResultadoFinal IS NOT NULL
    ),
    Estadisticas AS
    (
        SELECT
            s.Pais AS Seleccion,
            s.Confederacion,

            COUNT(r.PartidoID) AS PJ,

            SUM(CASE
                WHEN r.GolesRecibidos = 0 THEN 1
                ELSE 0
            END) AS VallasInvictas,

            SUM(CASE
                WHEN r.GolesRecibidos > 0 THEN 1
                ELSE 0
            END) AS PartidosConGolesRecibidos,

            SUM(r.GolesRecibidos) AS GC,

            CAST(
                SUM(CASE
                    WHEN r.GolesRecibidos = 0 THEN 1
                    ELSE 0
                END) * 100.0 / COUNT(r.PartidoID)
                AS DECIMAL(5,2)
            ) AS PorcentajeVallasInvictas,

            CAST(
                SUM(r.GolesRecibidos) * 1.0
                / COUNT(r.PartidoID)
                AS DECIMAL(5,2)
            ) AS PromedioGC

        FROM torneo.Seleccion s

        INNER JOIN Resultados r
            ON s.SeleccionID = r.SeleccionID

        GROUP BY
            s.SeleccionID,
            s.Pais,
            s.Confederacion
    )

    SELECT TOP (@Top)

        ROW_NUMBER() OVER (
            ORDER BY
                VallasInvictas DESC,
                PorcentajeVallasInvictas DESC,
                PromedioGC ASC,
                Seleccion ASC
        ) AS Posicion,

        Seleccion,
        PJ,
        VallasInvictas,
        GC

    FROM Estadisticas

    ORDER BY Posicion;
END;
GO

-- PRUEBA DE EXITO - RANKING COMPLETO --

EXEC torneo.SP_RankingVallasInvictas;
GO

-- ==================================================
-- TABLA DE POSICIONES POR GRUPO
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_TablaPosicionesGrupos
    @Grupo CHAR(1) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Grupo IS NOT NULL
       AND @Grupo NOT IN ('A','B','C','D','E','F',
                          'G','H','I','J','K','L')
    BEGIN
        THROW 50001, 'El grupo ingresado no es valido.', 1;
    END;

    ;WITH GolesPorSeleccion AS
    (
        SELECT
            g.PartidoID,
            c.SeleccionID,
            COUNT(*) AS Goles
        FROM torneo.Gol g
        INNER JOIN torneo.Jugador j
            ON j.PersonaID = g.PersonaID
        INNER JOIN torneo.Convocatoria c
            ON c.ConvocatoriaID = j.ConvocatoriaID
        GROUP BY
            g.PartidoID,
            c.SeleccionID
    ),

    Resultados AS
    (
        SELECT
            j1.SeleccionID,
            j1.PartidoID,
            ISNULL(g1.Goles, 0) AS GF,
            ISNULL(g2.Goles, 0) AS GC
        FROM torneo.Juega j1
        INNER JOIN torneo.Juega j2
            ON j1.PartidoID = j2.PartidoID
           AND j1.SeleccionID <> j2.SeleccionID
        INNER JOIN torneo.Partido p
            ON p.PartidoID = j1.PartidoID
        LEFT JOIN GolesPorSeleccion g1
            ON g1.PartidoID = j1.PartidoID
           AND g1.SeleccionID = j1.SeleccionID
        LEFT JOIN GolesPorSeleccion g2
            ON g2.PartidoID = j2.PartidoID
           AND g2.SeleccionID = j2.SeleccionID
        WHERE p.Fase = 'Fase de Grupos'
          AND p.ResultadoFinal IS NOT NULL
    ),

    Estadisticas AS
    (
        SELECT
            s.SeleccionID,
            s.Grupo,
            s.Pais AS Seleccion,

            COUNT(r.PartidoID) AS PJ,

            SUM(CASE WHEN r.GF > r.GC
                THEN 1 ELSE 0 END) AS PG,

            SUM(CASE WHEN r.GF = r.GC
                THEN 1 ELSE 0 END) AS PE,

            SUM(CASE WHEN r.GF < r.GC
                THEN 1 ELSE 0 END) AS PP,

            ISNULL(SUM(r.GF), 0) AS GF,

            ISNULL(SUM(r.GC), 0) AS GC,

            ISNULL(SUM(r.GF - r.GC), 0) AS DIF,

            SUM(CASE
                WHEN r.GF > r.GC THEN 3
                WHEN r.GF = r.GC THEN 1
                ELSE 0
            END) AS PTS

        FROM torneo.Seleccion s
        LEFT JOIN Resultados r
            ON r.SeleccionID = s.SeleccionID
        WHERE s.Grupo IS NOT NULL
          AND (@Grupo IS NULL OR s.Grupo = @Grupo)
        GROUP BY
            s.SeleccionID,
            s.Grupo,
            s.Pais
    )

    SELECT
        Grupo,
        ROW_NUMBER() OVER (
            PARTITION BY Grupo
            ORDER BY PTS DESC,
                     DIF DESC,
                     GF DESC,
                     Seleccion ASC
        ) AS Posicion,
        Seleccion,
        PJ,
        PG,
        PE,
        PP,
        GF,
        GC,
        DIF,
        PTS
    FROM Estadisticas
    ORDER BY Grupo, Posicion;

END;
GO

-- PRUEBA DE EXITO - TABLA GENERAL DE GRUPOS --

EXEC torneo.SP_TablaPosicionesGrupos;
GO

-- ==================================================
-- RESULTADOS DE FASES ELIMINATORIAS
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_FaseEliminatoria
    @Fase VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Fase IS NOT NULL AND @Fase NOT IN (
        'Dieciseisavos',
        'Octavos',
        'Cuartos',
        'Semifinal',
        'Tercer Puesto',
        'Final'
    )
    BEGIN
        THROW 50001, 'La fase ingresada no es valida.', 1;
    END;

    ;WITH GolesPorSeleccion AS
    (
        SELECT
            g.PartidoID,
            c.SeleccionID,
            COUNT(*) AS Goles
        FROM torneo.Gol g
        INNER JOIN torneo.Jugador j
            ON g.PersonaID = j.PersonaID
        INNER JOIN torneo.Convocatoria c
            ON j.ConvocatoriaID = c.ConvocatoriaID
        GROUP BY g.PartidoID, c.SeleccionID
    )
    SELECT
        p.PartidoID,
        p.Fase,
        s1.Pais AS Seleccion1,
        ISNULL(g1.Goles, 0) AS Goles,
        ISNULL(g2.Goles, 0) AS Goles,
        s2.Pais AS Seleccion2,

        CASE
            WHEN ISNULL(g1.Goles, 0) > ISNULL(g2.Goles, 0)
                THEN s1.Pais
            WHEN ISNULL(g2.Goles, 0) > ISNULL(g1.Goles, 0)
                THEN s2.Pais
            ELSE 'Empate'
        END AS Ganador,

        se.NombreEstadio AS Estadio,
        p.FechaHoraUTC,
        p.Asistencia

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

    LEFT JOIN GolesPorSeleccion g1
        ON p.PartidoID = g1.PartidoID
        AND j1.SeleccionID = g1.SeleccionID

    LEFT JOIN GolesPorSeleccion g2
        ON p.PartidoID = g2.PartidoID
        AND j2.SeleccionID = g2.SeleccionID

    WHERE p.Fase IN (
        'Dieciseisavos',
        'Octavos',
        'Cuartos',
        'Semifinal',
        'Tercer Puesto',
        'Final'
    )
    AND (@Fase IS NULL OR p.Fase = @Fase)
    AND p.ResultadoFinal IS NOT NULL

    ORDER BY
        CASE p.Fase
            WHEN 'Dieciseisavos' THEN 1
            WHEN 'Octavos' THEN 2
            WHEN 'Cuartos' THEN 3
            WHEN 'Semifinal' THEN 4
            WHEN 'Tercer Puesto' THEN 5
            WHEN 'Final' THEN 6
        END,
        p.FechaHoraUTC;
END;
GO

-- PRUEBA DE EXITO - TODAS LAS FASES ELIMINATORIAS --

EXEC torneo.SP_FaseEliminatoria;
GO

-- ==================================================
-- CAMINO DE UNA SELECCION EN EL MUNDIAL
-- ==================================================

CREATE OR ALTER PROCEDURE torneo.SP_CaminoDeSeleccion
    @Seleccion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SeleccionID INT;

    SELECT @SeleccionID = SeleccionID
    FROM torneo.Seleccion
    WHERE Pais = @Seleccion;

    IF @SeleccionID IS NULL
    BEGIN
        THROW 50001, 'La seleccion ingresada no existe.', 1;
    END;

    ;WITH GolesPorSeleccion AS
    (
        SELECT
            g.PartidoID,
            c.SeleccionID,
            COUNT(*) AS Goles
        FROM torneo.Gol g
        INNER JOIN torneo.Jugador j
            ON g.PersonaID = j.PersonaID
        INNER JOIN torneo.Convocatoria c
            ON j.ConvocatoriaID = c.ConvocatoriaID
        GROUP BY g.PartidoID, c.SeleccionID
    )
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY p.FechaHoraUTC, p.PartidoID
        ) AS NumeroPartido,

        p.Fase,
        @Seleccion AS Seleccion,
        s.Pais AS Rival,

        CONCAT(
            ISNULL(g1.Goles, 0), '-',
            ISNULL(g2.Goles, 0)
        ) AS Marcador,

        CASE
            WHEN ISNULL(g1.Goles, 0) > ISNULL(g2.Goles, 0)
                THEN 'Victoria'
            WHEN ISNULL(g1.Goles, 0) < ISNULL(g2.Goles, 0)
                THEN 'Derrota'
            ELSE 'Empate'
        END AS Resultado,

        se.NombreEstadio AS Estadio,
        p.FechaHoraUTC,
        p.Asistencia

    FROM torneo.Partido p

    INNER JOIN torneo.Juega j1
        ON p.PartidoID = j1.PartidoID

    INNER JOIN torneo.Juega j2
        ON p.PartidoID = j2.PartidoID
        AND j1.SeleccionID <> j2.SeleccionID

    INNER JOIN torneo.Seleccion s
        ON j2.SeleccionID = s.SeleccionID

    INNER JOIN torneo.Sede se
        ON p.SedeID = se.SedeID

    LEFT JOIN GolesPorSeleccion g1
        ON p.PartidoID = g1.PartidoID
        AND j1.SeleccionID = g1.SeleccionID

    LEFT JOIN GolesPorSeleccion g2
        ON p.PartidoID = g2.PartidoID
        AND j2.SeleccionID = g2.SeleccionID

    WHERE j1.SeleccionID = @SeleccionID
        AND p.ResultadoFinal IS NOT NULL

    ORDER BY p.FechaHoraUTC, p.PartidoID;
END;
GO

-- PRUEBA DE EXITO --

EXEC torneo.SP_CaminoDeSeleccion
    @Seleccion = 'Argentina';
GO
