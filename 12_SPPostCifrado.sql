
-- Universidad: Universidad Nacional de La Matanza
-- Materia: Base de Datos Aplicadas, COM 02
-- Integrantes Grupo 3:
-- Borfitz, Maia Agustina
-- Gomez, Erin Agustina
-- Pereyra Almanza, Ignacio Raul
-- Meynet, Mauro Fernando

-- Objetivo: Stored Procedures de Reportes

USE DB_Mundial_2026;
GO


-- ============================================
-- MODIFICACION DE STORE PROCEDURES POST CIFRADO
-- ============================================
CREATE OR ALTER PROCEDURE torneo.SP_Alta_Persona
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @FechaNacimiento DATE
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';
    DECLARE @PersonaID INT;

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        SET @mensajeError = @mensajeError + 'El nombre es obligatorio. ';

    IF @Apellido IS NULL OR LTRIM(RTRIM(@Apellido)) = ''
        SET @mensajeError = @mensajeError + 'El apellido es obligatorio. ';

    IF @FechaNacimiento IS NULL
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento es obligatoria. ';

    IF @FechaNacimiento > CAST(GETDATE() AS DATE)
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento no puede ser futura. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        OPEN SYMMETRIC KEY ClaveSimetrica_Persona
        DECRYPTION BY CERTIFICATE Certificado_Persona;

        INSERT INTO torneo.Persona
            (Nombre, Apellido, FechaNacimiento)
        VALUES
            (0x00, 0x00, 0x00);

        SET @PersonaID = SCOPE_IDENTITY();

        -- Ciframos los tres datos utilizando PersonaID
        UPDATE torneo.Persona
        SET
            Nombre = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), @Nombre), 1, CONVERT(VARBINARY(4), @PersonaID)),

            Apellido = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), @Apellido), 1, CONVERT(VARBINARY(4), @PersonaID)),

            FechaNacimiento = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(10), CONVERT(VARCHAR(10), @FechaNacimiento, 23)),
                1, CONVERT(VARBINARY(4), @PersonaID)
            )
        WHERE PersonaID = @PersonaID;

        CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;

        COMMIT TRANSACTION;

        PRINT 'Persona registrada exitosamente.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE KEY_NAME = 'ClaveSimetrica_Persona')
            CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;
        THROW;
    END CATCH;
END
GO


CREATE OR ALTER PROCEDURE torneo.SP_Modificacion_Persona
    @PersonaID INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @FechaNacimiento DATE
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @mensajeError VARCHAR(MAX) = '';

    IF NOT EXISTS (SELECT 1 FROM torneo.Persona WHERE PersonaID = @PersonaID)
        SET @mensajeError = @mensajeError + 'La persona no existe. ';

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        SET @mensajeError = @mensajeError + 'El nombre es obligatorio. ';

    IF @Apellido IS NULL OR LTRIM(RTRIM(@Apellido)) = ''
        SET @mensajeError = @mensajeError + 'El apellido es obligatorio. ';

    IF @FechaNacimiento IS NULL
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento es obligatoria. ';

    IF @FechaNacimiento > CAST(GETDATE() AS DATE)
        SET @mensajeError = @mensajeError + 'La fecha de nacimiento no puede ser futura. ';

    IF LEN(@mensajeError) > 0
    BEGIN
        RAISERROR(@mensajeError, 16, 1);
        RETURN;
    END;

    BEGIN TRY

        OPEN SYMMETRIC KEY ClaveSimetrica_Persona
        DECRYPTION BY CERTIFICATE Certificado_Persona;

        UPDATE torneo.Persona
        SET
            Nombre = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), @Nombre), 1, CONVERT(VARBINARY(4), @PersonaID)),

            Apellido = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), @Apellido), 1, CONVERT(VARBINARY(4), @PersonaID)),

            FechaNacimiento = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(10), CONVERT(VARCHAR(10), @FechaNacimiento, 23)),
                1, CONVERT(VARBINARY(4), @PersonaID)
            )
        WHERE PersonaID = @PersonaID;

        CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;

        PRINT 'Persona modificada exitosamente.';

    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE KEY_NAME = 'ClaveSimetrica_Persona')
            CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;

        THROW;
    END CATCH;
END
GO



CREATE OR ALTER PROCEDURE torneo.SP_Reporte_Goleadores
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        OPEN SYMMETRIC KEY ClaveSimetrica_Persona
        DECRYPTION BY CERTIFICATE Certificado_Persona;

        ;WITH Goleadores AS
        (
            SELECT s.SeleccionID, s.Pais AS Seleccion,
                CONVERT(VARCHAR(50), DecryptByKey(per.Nombre, 1, CONVERT(VARBINARY(4), per.PersonaID))) AS Nombre,
                CONVERT(VARCHAR(50), DecryptByKey(per.Apellido, 1, CONVERT(VARBINARY(4), per.PersonaID))) AS Apellido,
                j.PersonaID, j.Dorsal, p.Fase,
                COUNT(g.GolID) AS GolesEnFase
            FROM torneo.Gol g

            INNER JOIN torneo.Jugador j ON g.PersonaID = j.PersonaID
            INNER JOIN torneo.Persona per ON j.PersonaID = per.PersonaID
            INNER JOIN torneo.Convocatoria c ON j.ConvocatoriaID = c.ConvocatoriaID
            INNER JOIN torneo.Seleccion s ON c.SeleccionID = s.SeleccionID
            INNER JOIN torneo.Partido p ON g.PartidoID = p.PartidoID

            GROUP BY s.SeleccionID, s.Pais, j.PersonaID, j.Dorsal,
                p.Fase, per.PersonaID, per.Nombre, per.Apellido
        )

        SELECT Seleccion, CONCAT(Nombre, ' ', Apellido) AS Jugador, Dorsal, Fase, GolesEnFase,
            SUM(GolesEnFase) OVER (PARTITION BY PersonaID) AS TotalGolesTorneo,
            SUM(GolesEnFase) OVER (PARTITION BY SeleccionID) AS TotalGolesSeleccion
        FROM Goleadores
        ORDER BY TotalGolesTorneo DESC, Seleccion, Fase;

        CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;

    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT 1 FROM sys.openkeys WHERE KEY_NAME = 'ClaveSimetrica_Persona')
            CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;
        THROW;
    END CATCH;
END;
GO
