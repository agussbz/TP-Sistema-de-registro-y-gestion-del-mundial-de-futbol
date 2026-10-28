-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3: 
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando
-- Fecha de entrega: 23/10/2026

-- Objetivo: Importacion de datos CSV y XML

USE DB_Mundial_2026
GO

-- ==================================================
-- IMPORTACIÓN CSV Árbitros Históricos (referees.csv)
-- ==================================================

CREATE OR ALTER PROCEDURE reglamento.SP_ImportarArbitros_CSV
    @RutaArchivo NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        CREATE TABLE #StagingReferees (
            key_id VARCHAR(20),
            referee_id VARCHAR(20),
            family_name NVARCHAR(100),
            given_name NVARCHAR(100),
            female VARCHAR(10),
            country_name NVARCHAR(100),
            confederation_id VARCHAR(20),
            confederation_name NVARCHAR(150),
            confederation_code VARCHAR(20),
            referee_wikipedia_link NVARCHAR(500)
        );

        DECLARE @SQL NVARCHAR(MAX) = N'
        BULK INSERT #StagingReferees
        FROM ''' + @RutaArchivo + N'''
        WITH (
            FORMAT = ''CSV'',
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0a'',
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @SQL;

        SELECT 
            referee_id,
            CAST(LTRIM(RTRIM(given_name)) AS VARCHAR(50)) AS Nombre,
            CAST(LTRIM(RTRIM(family_name)) AS VARCHAR(50)) AS Apellido,
            CAST(LTRIM(RTRIM(country_name)) AS VARCHAR(50)) AS Pais,
            CASE 
                WHEN ISNULL(LTRIM(RTRIM(given_name)), '') IN ('', 'not available', 'not applicable') THEN 'Error: Nombre vacío o no disponible.'
                WHEN ISNULL(LTRIM(RTRIM(family_name)), '') IN ('', 'not available', 'not applicable') THEN 'Error: Apellido vacío o no disponible.'
                WHEN ISNULL(LTRIM(RTRIM(country_name)), '') IN ('', 'not available', 'not applicable') THEN 'Error: País vacío o no disponible.'
            END AS MotivoRechazo
        INTO #RefereesProcesados
        FROM #StagingReferees;

        SELECT referee_id, Nombre, Apellido, Pais, MotivoRechazo
        FROM #RefereesProcesados
        WHERE MotivoRechazo IS NOT NULL;

        DECLARE @v_Nombre VARCHAR(50), @v_Apellido VARCHAR(50), @v_Pais VARCHAR(50);
        DECLARE @v_PersonaID INT, @v_FechaExistente DATE;

        DECLARE Cur_Arbitros CURSOR LOCAL FAST_FORWARD FOR
            SELECT DISTINCT Nombre, Apellido, Pais
            FROM #RefereesProcesados
            WHERE MotivoRechazo IS NULL;

        OPEN Cur_Arbitros;
        FETCH NEXT FROM Cur_Arbitros INTO @v_Nombre, @v_Apellido, @v_Pais;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRANSACTION;

            SELECT TOP 1 
                @v_PersonaID = PersonaID,
                @v_FechaExistente = FechaNacimiento
            FROM torneo.Persona 
            WHERE Nombre = @v_Nombre AND Apellido = @v_Apellido;

            IF @v_PersonaID IS NULL
            BEGIN
                EXEC torneo.SP_Alta_Persona 
                    @Nombre = @v_Nombre, 
                    @Apellido = @v_Apellido, 
                    @FechaNacimiento = '1980-01-01';

                SELECT TOP 1 @v_PersonaID = PersonaID 
                FROM torneo.Persona 
                WHERE Nombre = @v_Nombre AND Apellido = @v_Apellido;
            END
            ELSE
            BEGIN
                EXEC torneo.SP_Modificacion_Persona 
                    @PersonaID = @v_PersonaID,
                    @Nombre = @v_Nombre, 
                    @Apellido = @v_Apellido, 
                    @FechaNacimiento = @v_FechaExistente;
            END

            IF NOT EXISTS (SELECT 1 FROM reglamento.Arbitro WHERE PersonaID = @v_PersonaID)
            BEGIN
                EXEC reglamento.SP_Alta_Arbitro 
                    @PersonaID = @v_PersonaID, 
                    @Pais = @v_Pais, 
                    @RolArbitral = 'Principal';
            END
            ELSE
            BEGIN
                EXEC reglamento.SP_Modificacion_Arbitro 
                    @PersonaID = @v_PersonaID, 
                    @Pais = @v_Pais, 
                    @RolArbitral = 'Principal';
            END

            COMMIT TRANSACTION;

            SET @v_PersonaID = NULL;
            FETCH NEXT FROM Cur_Arbitros INTO @v_Nombre, @v_Apellido, @v_Pais;
        END

        CLOSE Cur_Arbitros;
        DEALLOCATE Cur_Arbitros;

        DROP TABLE #StagingReferees;
        DROP TABLE #RefereesProcesados;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'Cur_Arbitros') >= -1
        BEGIN
            CLOSE Cur_Arbitros;
            DEALLOCATE Cur_Arbitros;
        END
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO


-- ===================================================
-- IMPORTACIÓN CSV Jugadores Históricos (players.csv)
-- ===================================================

CREATE OR ALTER PROCEDURE torneo.SP_ImportarJugadores_CSV
    @RutaArchivo NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        CREATE TABLE #StagingPlayers (
            key_id VARCHAR(20),
            player_id VARCHAR(20),
            family_name NVARCHAR(100),
            given_name NVARCHAR(100),
            birth_date VARCHAR(50),
            female VARCHAR(10),
            goal_keeper VARCHAR(10),
            defender VARCHAR(10),
            midfielder VARCHAR(10),
            forward VARCHAR(10),
            count_tournaments VARCHAR(20),
            list_tournaments NVARCHAR(200),
            player_wikipedia_link NVARCHAR(500)
        );

        DECLARE @SQL NVARCHAR(MAX) = N'
        BULK INSERT #StagingPlayers
        FROM ''' + @RutaArchivo + N'''
        WITH (
            FORMAT = ''CSV'',
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''0x0a'',
            CODEPAGE = ''65001''
        );';
        EXEC sp_executesql @SQL;

        SELECT 
            player_id,
            CAST(LTRIM(RTRIM(given_name)) AS VARCHAR(50)) AS Nombre,
            CAST(LTRIM(RTRIM(family_name)) AS VARCHAR(50)) AS Apellido,
            TRY_CAST(birth_date AS DATE) AS FechaNacimientoValida,
            birth_date AS FechaOriginalTexto,
            CASE 
                WHEN ISNULL(LTRIM(RTRIM(given_name)), '') IN ('', 'not applicable', 'not available') THEN 'Error: Nombre figura como not applicable o vacío.'
                WHEN ISNULL(LTRIM(RTRIM(family_name)), '') IN ('', 'not applicable', 'not available') THEN 'Error: Apellido vacío o no disponible.'
                WHEN TRY_CAST(birth_date AS DATE) IS NULL THEN 'Error: Fecha de nacimiento inválida (' + ISNULL(birth_date, 'NULL') + ').'
                WHEN TRY_CAST(birth_date AS DATE) > CAST(GETDATE() AS DATE) THEN 'Error: Fecha de nacimiento futura.'
            END AS MotivoRechazo
        INTO #PlayersProcesados
        FROM #StagingPlayers;

        SELECT player_id, Nombre, Apellido, FechaOriginalTexto, MotivoRechazo
        FROM #PlayersProcesados
        WHERE MotivoRechazo IS NOT NULL;

        DECLARE @v_Nombre VARCHAR(50), @v_Apellido VARCHAR(50), @v_FechaNac DATE;
        DECLARE @v_PersonaID INT;

        DECLARE Cur_Jugadores CURSOR LOCAL FAST_FORWARD FOR
            SELECT Nombre, Apellido, MIN(FechaNacimientoValida)
            FROM #PlayersProcesados
            WHERE MotivoRechazo IS NULL
            GROUP BY Nombre, Apellido;

        OPEN Cur_Jugadores;
        FETCH NEXT FROM Cur_Jugadores INTO @v_Nombre, @v_Apellido, @v_FechaNac;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRANSACTION;

            SET @v_PersonaID = (
                SELECT TOP 1 PersonaID 
                FROM torneo.Persona 
                WHERE Nombre = @v_Nombre AND Apellido = @v_Apellido
            );

            IF @v_PersonaID IS NULL
            BEGIN
                EXEC torneo.SP_Alta_Persona 
                    @Nombre = @v_Nombre, 
                    @Apellido = @v_Apellido, 
                    @FechaNacimiento = @v_FechaNac;
            END
            ELSE
            BEGIN
                EXEC torneo.SP_Modificacion_Persona 
                    @PersonaID = @v_PersonaID,
                    @Nombre = @v_Nombre, 
                    @Apellido = @v_Apellido, 
                    @FechaNacimiento = @v_FechaNac;
            END

            COMMIT TRANSACTION;

            FETCH NEXT FROM Cur_Jugadores INTO @v_Nombre, @v_Apellido, @v_FechaNac;
        END

        CLOSE Cur_Jugadores;
        DEALLOCATE Cur_Jugadores;

        DROP TABLE #StagingPlayers;
        DROP TABLE #PlayersProcesados;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'Cur_Jugadores') >= -1
        BEGIN
            CLOSE Cur_Jugadores;
            DEALLOCATE Cur_Jugadores;
        END
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO

-- ===============================================
-- IMPORTACIÓN XML: Fixture Scrapeado de FIFA.com
-- ===============================================

CREATE OR ALTER PROCEDURE torneo.SP_ImportarFixture_XML
    @RutaArchivo NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @XmlContenido XML;
        DECLARE @SQL NVARCHAR(MAX) = N'
            SELECT @XmlOut = CAST(BulkColumn AS XML)
            FROM OPENROWSET(BULK ''' + @RutaArchivo + N''', SINGLE_BLOB) AS x;';
            
        EXEC sp_executesql @SQL, N'@XmlOut XML OUTPUT', @XmlOut = @XmlContenido OUTPUT;

        SELECT 
           LTRIM(RTRIM(XMLPartidos.Partido.query('Estadio').value('.', 'VARCHAR(70)'))) AS Estadio,
           LTRIM(RTRIM(XMLPartidos.Partido.query('Fase').value('.', 'VARCHAR(50)'))) AS Fase,
           LTRIM(RTRIM(XMLPartidos.Partido.query('PaisLocal').value('.', 'VARCHAR(50)'))) AS PaisLocal,
           LTRIM(RTRIM(XMLPartidos.Partido.query('PaisVisitante').value('.', 'VARCHAR(50)'))) AS PaisVisitante,
           TRY_CAST(XMLPartidos.Partido.query('Asistencia').value('.', 'VARCHAR(20)') AS INT) AS Asistencia,
           TRY_CAST(XMLPartidos.Partido.query('FechaHoraLocal').value('.', 'VARCHAR(30)') AS DATETIME) AS FechaHoraLocal,
           TRY_CAST(XMLPartidos.Partido.query('FechaHoraUTC').value('.', 'VARCHAR(30)') AS DATETIME) AS FechaHoraUTC,
           LTRIM(RTRIM(XMLPartidos.Partido.query('Resultado').value('.', 'VARCHAR(20)'))) AS Resultado
        INTO #StagingXML
        FROM @XmlContenido.nodes('Torneo/Partido') AS XMLPartidos(Partido);

        SELECT 
            s.*,
            sede.SedeID,
            loc.SeleccionID AS LocalID,
            vis.SeleccionID AS VisitanteID,
            CASE 
                WHEN sede.SedeID IS NULL THEN 'Error: El estadio no existe en torneo.Sede.'
                WHEN loc.SeleccionID IS NULL THEN 'Error: País Local no existe en torneo.Seleccion.'
                WHEN vis.SeleccionID IS NULL THEN 'Error: País Visitante no existe en torneo.Seleccion.'
                WHEN loc.SeleccionID = vis.SeleccionID THEN 'Error: Una selección no puede jugar contra sí misma.'
                WHEN s.FechaHoraUTC IS NULL OR s.FechaHoraLocal IS NULL THEN 'Error: Fecha/Hora inválida.'
                WHEN ISNULL(s.Asistencia, 0) < 0 THEN 'Error: Asistencia negativa.'
                WHEN ISNULL(s.Fase, '') = '' THEN 'Error: La fase es obligatoria.'
            END AS MotivoRechazo
        INTO #FixtureProcesado
        FROM #StagingXML s
        LEFT JOIN torneo.Sede sede ON s.Estadio = sede.NombreEstadio
        LEFT JOIN torneo.Seleccion loc ON s.PaisLocal = loc.Pais
        LEFT JOIN torneo.Seleccion vis ON s.PaisVisitante = vis.Pais;

        SELECT Estadio, Fase, PaisLocal, PaisVisitante, FechaHoraUTC, MotivoRechazo
        FROM #FixtureProcesado
        WHERE MotivoRechazo IS NOT NULL;

        DECLARE @v_SedeID INT, @v_LocalID INT, @v_VisitanteID INT, @v_Fase VARCHAR(50);
        DECLARE @v_Asistencia INT, @v_FHLocal DATETIME, @v_FHUTC DATETIME, @v_Resultado VARCHAR(20);
        DECLARE @v_PartidoID INT;

        DECLARE Cur_Fixture CURSOR LOCAL FAST_FORWARD FOR
            SELECT SedeID, LocalID, VisitanteID, Fase, ISNULL(Asistencia, 0), FechaHoraLocal, FechaHoraUTC, ISNULL(NULLIF(Resultado, ''), '0-0')
            FROM #FixtureProcesado
            WHERE MotivoRechazo IS NULL;

        OPEN Cur_Fixture;
        FETCH NEXT FROM Cur_Fixture INTO @v_SedeID, @v_LocalID, @v_VisitanteID, @v_Fase, @v_Asistencia, @v_FHLocal, @v_FHUTC, @v_Resultado;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRANSACTION;

            SET @v_PartidoID = (
                SELECT TOP 1 PartidoID 
                FROM torneo.Partido 
                WHERE SedeID = @v_SedeID AND fechaHoraUTC = @v_FHUTC
            );

            IF @v_PartidoID IS NULL
            BEGIN
                EXEC torneo.SP_Alta_Partido 
                    @SedeID = @v_SedeID,
                    @Fase = @v_Fase,
                    @Asistencia = @v_Asistencia,
                    @ResultadoFinal = @v_Resultado,
                    @FechaHoraLocal = @v_FHLocal,
                    @FechaHoraUTC = @v_FHUTC;

                SET @v_PartidoID = SCOPE_IDENTITY();

                EXEC torneo.SP_Alta_Juega @PartidoID = @v_PartidoID, @SeleccionID = @v_LocalID;
                EXEC torneo.SP_Alta_Juega @PartidoID = @v_PartidoID, @SeleccionID = @v_VisitanteID;
            END
            ELSE
            BEGIN
                EXEC torneo.SP_Modificacion_Partido 
                    @PartidoID = @v_PartidoID,
                    @SedeID = @v_SedeID,
                    @Fase = @v_Fase,
                    @Asistencia = @v_Asistencia,
                    @ResultadoFinal = @v_Resultado,
                    @fechaHoraLocal = @v_FHLocal,
                    @fechaHoraUTC = @v_FHUTC;

                IF NOT EXISTS (SELECT 1 FROM torneo.Juega WHERE PartidoID = @v_PartidoID AND SeleccionID = @v_LocalID)
                    EXEC torneo.SP_Alta_Juega @PartidoID = @v_PartidoID, @SeleccionID = @v_LocalID;

                IF NOT EXISTS (SELECT 1 FROM torneo.Juega WHERE PartidoID = @v_PartidoID AND SeleccionID = @v_VisitanteID)
                    EXEC torneo.SP_Alta_Juega @PartidoID = @v_PartidoID, @SeleccionID = @v_VisitanteID;
            END

            COMMIT TRANSACTION;

            FETCH NEXT FROM Cur_Fixture INTO @v_SedeID, @v_LocalID, @v_VisitanteID, @v_Fase, @v_Asistencia, @v_FHLocal, @v_FHUTC, @v_Resultado;
        END

        CLOSE Cur_Fixture;
        DEALLOCATE Cur_Fixture;
        
        DROP TABLE #StagingXML;
        DROP TABLE #FixtureProcesado;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'Cur_Fixture') >= -1
        BEGIN
            CLOSE Cur_Fixture;
            DEALLOCATE Cur_Fixture;
        END
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO


-- ===============================================
-- SCRAPING: "List of FIFA World Cup referees"
-- ===============================================
CREATE OR ALTER PROCEDURE torneo.sp_ImportarFinalesArbitrosWikipediaCompleto
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Object INT;
    DECLARE @URL VARCHAR(500) = 'https://en.wikipedia.org/wiki/List_of_FIFA_World_Cup_referees';
    DECLARE @HtmlTable TABLE (ContenidoHTML VARCHAR(MAX));
    DECLARE @Html VARCHAR(MAX);
    DECLARE @ErrorMensaje VARCHAR(4000);

    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC sp_OACreate 'MSXML2.ServerXMLHttp.6.0', @Object OUT;
        EXEC sp_OAMethod @Object, 'OPEN', NULL, 'GET', @URL, 'FALSE';
        EXEC sp_OAMethod @Object, 'setRequestHeader', NULL, 'User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)';
        EXEC sp_OAMethod @Object, 'SEND';

        INSERT INTO @HtmlTable
        EXEC sp_OAGetProperty @Object, 'RESPONSETEXT';

        EXEC sp_OADestroy @Object;

        SELECT @Html = ContenidoHTML FROM @HtmlTable;

        IF @Html IS NULL OR LEN(@Html) = 0
            THROW 50001, 'No se pudo obtener el HTML de Wikipedia.', 1;

        DECLARE @InicioTabla INT = CHARINDEX('Year</th>', @Html);
        IF @InicioTabla > 0
            SET @Html = SUBSTRING(@Html, @InicioTabla, LEN(@Html));

        CREATE TABLE #Filas (
            FilaID INT IDENTITY(1,1),
            TextoFila VARCHAR(MAX)
        );

        DECLARE @PosTR_Start INT, @PosTR_End INT, @ChunkTR VARCHAR(MAX);
        SET @PosTR_Start = CHARINDEX('<tr', @Html);

        WHILE @PosTR_Start > 0 AND LEN(@Html) > 0
        BEGIN
            SET @PosTR_End = CHARINDEX('</tr>', @Html, @PosTR_Start);
            IF @PosTR_End = 0 BREAK;

            SET @ChunkTR = SUBSTRING(@Html, @PosTR_Start, @PosTR_End - @PosTR_Start + 5);

            IF @ChunkTR LIKE '%<td%' AND @ChunkTR NOT LIKE '%Squads%' AND @ChunkTR NOT LIKE '%Broadcasters%'
            BEGIN
                INSERT INTO #Filas (TextoFila) VALUES (@ChunkTR);
            END;

            SET @Html = SUBSTRING(@Html, @PosTR_End + 5, LEN(@Html));
            SET @PosTR_Start = CHARINDEX('<tr', @Html);
        END;

        DECLARE @Fila VARCHAR(MAX);
        DECLARE @Anio INT;

        DECLARE @TD1 VARCHAR(MAX), @TD2 VARCHAR(MAX), @TD3 VARCHAR(MAX);
        DECLARE @TD4 VARCHAR(MAX) = '—', @TD5 VARCHAR(MAX) = '—', @TD6 VARCHAR(MAX) = '—';

        DECLARE curFilas CURSOR LOCAL FAST_FORWARD FOR 
            SELECT TextoFila FROM #Filas;

        OPEN curFilas;
        FETCH NEXT FROM curFilas INTO @Fila;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @Fila = REPLACE(REPLACE(@Fila, '<br/>', ', '), '<br id=', ', <br id=');

            SET @TD1 = ''; SET @TD2 = ''; SET @TD3 = ''; 
            SET @TD4 = '—'; SET @TD5 = '—'; SET @TD6 = '—';

            DECLARE @P_Start INT = 1, @P_End INT = 1, @CellIndex INT = 1;
            DECLARE @CurrentTD VARCHAR(MAX);

            WHILE @CellIndex <= 6
            BEGIN
                SET @P_Start = CHARINDEX('<td', @Fila, @P_End);
                IF @P_Start = 0 BREAK; 

                SET @P_End = CHARINDEX('</td>', @Fila, @P_Start);
                IF @P_End = 0 BREAK;

                SET @CurrentTD = SUBSTRING(@Fila, @P_Start, @P_End - @P_Start);

                WHILE CHARINDEX('<', @CurrentTD) > 0 AND CHARINDEX('>', @CurrentTD) > CHARINDEX('<', @CurrentTD)
                    SET @CurrentTD = STUFF(@CurrentTD, CHARINDEX('<', @CurrentTD), CHARINDEX('>', @CurrentTD) - CHARINDEX('<', @CurrentTD) + 1, '');

                SET @CurrentTD = LTRIM(RTRIM(REPLACE(REPLACE(@CurrentTD, CHAR(10), ''), CHAR(13), '')));

                IF @CellIndex = 1 SET @TD1 = @CurrentTD;
                IF @CellIndex = 2 SET @TD2 = @CurrentTD;
                IF @CellIndex = 3 SET @TD3 = @CurrentTD;
                IF @CellIndex = 4 SET @TD4 = @CurrentTD;
                IF @CellIndex = 5 SET @TD5 = @CurrentTD;
                IF @CellIndex = 6 SET @TD6 = @CurrentTD;

                SET @CellIndex = @CellIndex + 1;
                SET @P_End = @P_End + 5; 
            END;

            BEGIN
                SET @Anio = CAST(LEFT(@TD1, 4) AS INT);

                IF EXISTS (SELECT 1 FROM torneo.FinalesArbitrosCompleto WHERE Anio = @Anio)
                BEGIN
                    UPDATE torneo.FinalesArbitrosCompleto
                    SET Referee = LEFT(@TD2, 300),
                        AssistantReferees = LEFT(@TD3, 500),
                        FourthOfficial = LEFT(@TD4, 300),
                        ReserveFifthOfficial = LEFT(@TD5, 300),
                        VARAndAssistantVARs = LEFT(@TD6, 500),
                        FechaImportacion = GETDATE()
                    WHERE Anio = @Anio;
                END
                ELSE
                BEGIN
                    INSERT INTO torneo.FinalesArbitrosCompleto (Anio, Referee, AssistantReferees, FourthOfficial, ReserveFifthOfficial, VARAndAssistantVARs)
                    VALUES (@Anio, LEFT(@TD2, 300), LEFT(@TD3, 500), LEFT(@TD4, 300), LEFT(@TD5, 300), LEFT(@TD6, 500));
                END;

            FETCH NEXT FROM curFilas INTO @Fila;
        END;

        CLOSE curFilas;
        DEALLOCATE curFilas;

        DROP TABLE #Filas;

        COMMIT TRANSACTION;
        PRINT 'Importación completa y alineada correctamente.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        IF OBJECT_ID('tempdb..#Filas') IS NOT NULL DROP TABLE #Filas;
        IF @Object IS NOT NULL EXEC sp_OADestroy @Object;

        SET @ErrorMensaje = ERROR_MESSAGE();
        THROW 50002, @ErrorMensaje, 1;
    END CATCH;
END;
GO


-- ==================================================
-- API: Transformación Moneda
-- ==================================================
CREATE OR ALTER PROCEDURE publicidad.ConvertirMonedaAUSD
    @Monto DECIMAL(18,2),
    @MonedaOrigen VARCHAR(10),
    @MontoConvertido DECIMAL(18,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF UPPER(LTRIM(RTRIM(@MonedaOrigen))) = 'USD'
    BEGIN
        SET @MontoConvertido = @Monto;
        RETURN;
    END;

    DECLARE @Object INT;
    DECLARE @URL VARCHAR(500) = 'https://api.frankfurter.dev/v2/rates?base=usd';
    DECLARE @JsonTable TABLE (RespuestaJSON NVARCHAR(MAX));
    DECLARE @JsonData NVARCHAR(MAX);
    DECLARE @TasaCambio DECIMAL(18,6);
    DECLARE @ErrorMensaje VARCHAR(4000);

    BEGIN TRY
        EXEC sp_OACreate 'MSXML2.ServerXMLHttp.6.0', @Object OUT;
        EXEC sp_OAMethod @Object, 'OPEN', NULL, 'GET', @URL, 'FALSE';
        EXEC sp_OAMethod @Object, 'setRequestHeader', NULL, 'User-Agent', 'Mozilla/5.0';
        EXEC sp_OAMethod @Object, 'SEND';

        INSERT INTO @JsonTable
        EXEC sp_OAGetProperty @Object, 'RESPONSETEXT';

        EXEC sp_OADestroy @Object;

        SELECT @JsonData = RespuestaJSON FROM @JsonTable;

        IF @JsonData IS NULL OR LEN(@JsonData) = 0
        BEGIN
            THROW 50001, 'No se pudo obtener respuesta de la API de tipos de cambio.', 1;
        END;

        SELECT @TasaCambio = rate
        FROM OPENJSON(@JsonData)
        WITH (
            quote VARCHAR(10) '$.quote',
            rate DECIMAL(18,6) '$.rate'
        )
        WHERE quote = UPPER(LTRIM(RTRIM(@MonedaOrigen)));

        IF @TasaCambio IS NULL OR @TasaCambio = 0
        BEGIN
            THROW 50002, 'No se encontró la tasa de cambio para la moneda solicitada en la API.', 1;
        END;

        SET @MontoConvertido = ROUND(@Monto / @TasaCambio, 2);

    END TRY
    BEGIN CATCH
        IF @Object IS NOT NULL 
            EXEC sp_OADestroy @Object;

        SET @ErrorMensaje = ERROR_MESSAGE();
        THROW 50003, @ErrorMensaje, 1;
    END CATCH;
END;
GO



