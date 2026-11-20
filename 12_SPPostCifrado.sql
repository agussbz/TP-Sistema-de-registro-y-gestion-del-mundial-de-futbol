
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
-- seguridad.SP_ConfigurarRolesYPermisos
-- ============================================

CREATE OR ALTER PROCEDURE seguridad.SP_ConfigurarRolesYPermisos
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    -- ========================================
    -- 1. CREAR ROLES
    -- ========================================

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_Administrador')
        EXEC('CREATE ROLE rol_Administrador');

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_CargadorResultados')
        EXEC('CREATE ROLE rol_CargadorResultados');

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_GestorPublicidad')
        EXEC('CREATE ROLE rol_GestorPublicidad');

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_Consulta')
        EXEC('CREATE ROLE rol_Consulta');


    -- ========================================
    -- 2. PERMISOS DEL ADMINISTRADOR
    -- ========================================

    GRANT EXECUTE ON SCHEMA::torneo
    TO rol_Administrador;

    GRANT EXECUTE ON SCHEMA::reglamento
    TO rol_Administrador;

    GRANT EXECUTE ON SCHEMA::publicidad
    TO rol_Administrador;


    -- ========================================
    -- 3. PERMISOS DEL GESTOR DE PUBLICIDAD
    -- ========================================

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_Anunciante
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Modificacion_Anunciante
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_Anunciante
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_Campaña
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Modificacion_Campaña
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_Campaña
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_Exhibicion
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Modificacion_Exhibicion
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_Exhibicion
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_PiezaPublicitaria
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Modificacion_PiezaPublicitaria
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_PiezaPublicitaria
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_InteresPublicitario
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Modificacion_InteresPublicitario
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_InteresPublicitario
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Alta_CuentaConExhibicion
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Baja_CuentaConExhibicion
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_AsignarCuatroPiezasPorPartido
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_MatrizPrimeTime
    TO rol_GestorPublicidad;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_OcupacionPublicitaria_XML
    TO rol_GestorPublicidad;


    -- ========================================
    -- 4. PERMISOS DEL CONSULTOR
    -- ========================================

    GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_Goleadores
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_ResultadosEncuentros
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_SeleccionesYPlantillas_XML
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::reglamento.SP_Reporte_DesignacionesArbitrales
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::reglamento.SP_Reporte_Tarjetas_Y_Suspensiones
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_MatrizPrimeTime
    TO rol_Consulta;

    GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_OcupacionPublicitaria_XML
    TO rol_Consulta;


    -- ========================================
    -- 5. PERMISOS DEL CARGADOR
    -- ========================================

    GRANT EXECUTE ON OBJECT::torneo.SP_RegistrarGol_Y_ActualizarResultado
    TO rol_CargadorResultados;

    GRANT EXECUTE ON OBJECT::reglamento.SP_ProcesarTarjeta_Y_Suspension
    TO rol_CargadorResultados;

    PRINT 'Roles y permisos configurados correctamente.';

END;
GO



-- ============================================
-- seguridad.SP_AsignarUsuarioRol
-- ============================================
CREATE OR ALTER PROCEDURE seguridad.SP_AsignarUsuarioRol
    @Usuario SYSNAME,
    @Rol SYSNAME
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Usuario AND type IN ('S', 'U'))
    BEGIN
        THROW 50001, 'El usuario indicado no existe.', 1;
    END;

    IF @Rol NOT IN ('rol_Administrador', 'rol_CargadorResultados', 'rol_GestorPublicidad', 'rol_Consulta')
    BEGIN
        THROW 50002, 'El rol indicado no esta permitido.', 1;
    END;

    IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Rol AND type = 'R')
    BEGIN
        THROW 50003, 'El rol indicado no existe.', 1;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_role_members RM
        INNER JOIN sys.database_principals R
            ON RM.role_principal_id = R.principal_id
        INNER JOIN sys.database_principals U
            ON RM.member_principal_id = U.principal_id
        WHERE R.name = @Rol
          AND U.name = @Usuario
    )
    BEGIN
        DECLARE @SQL NVARCHAR(MAX);

        SET @SQL = N'ALTER ROLE ' + QUOTENAME(@Rol) + N' ADD MEMBER ' + QUOTENAME(@Usuario) + N';';

        EXEC sp_executesql @SQL;
    END;

    PRINT 'Usuario asignado correctamente al rol.';

END;
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
