
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
-- CIFRADO DE DATOS PERSONALES
-- ============================================

-- 1. Crear Master Key
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY
    ENCRYPTION BY PASSWORD = 'Mundial2026_MasterKey';
END
GO

-- 2. Crear certificado
IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'Certificado_Persona')
BEGIN
    CREATE CERTIFICATE Certificado_Persona
    WITH SUBJECT = 'Certificado para proteger datos personales';
END
GO

-- 3. Crear clave simetrica
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'ClaveSimetrica_Persona')
BEGIN
    CREATE SYMMETRIC KEY ClaveSimetrica_Persona
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Certificado_Persona;
END
GO

PRINT 'Infraestructura de cifrado creada correctamente.';
GO

-- Muesto que la clave se genero correctamente
OPEN SYMMETRIC KEY ClaveSimetrica_Persona
DECRYPTION BY CERTIFICATE Certificado_Persona;
GO

SELECT
    KEY_NAME,
    KEY_GUID
FROM sys.openkeys
WHERE KEY_NAME = 'ClaveSimetrica_Persona';
GO

CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;
GO

-- Modifico la tabla de persona
IF COL_LENGTH('torneo.Persona', 'Nombre_Cifrado') IS NULL
    ALTER TABLE torneo.Persona
    ADD Nombre_Cifrado VARBINARY(256) NULL;
GO

IF COL_LENGTH('torneo.Persona', 'Apellido_Cifrado') IS NULL
    ALTER TABLE torneo.Persona
    ADD Apellido_Cifrado VARBINARY(256) NULL;
GO

IF COL_LENGTH('torneo.Persona', 'FechaNacimiento_Cifrada') IS NULL
    ALTER TABLE torneo.Persona
    ADD FechaNacimiento_Cifrada VARBINARY(256) NULL;
GO

SELECT  COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'torneo' AND TABLE_NAME = 'Persona';

-- Tabla persona antes de cifrar los datos sensibles
SELECT *
FROM torneo.Persona;

-- Realizo el cifrado sobre los datos
BEGIN TRY
    OPEN SYMMETRIC KEY ClaveSimetrica_Persona
    DECRYPTION BY CERTIFICATE Certificado_Persona;

    BEGIN TRANSACTION;

    UPDATE torneo.Persona
    SET
        Nombre_Cifrado = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), Nombre), 1, CONVERT(VARBINARY(4), PersonaID)),

        Apellido_Cifrado = EncryptByKey(Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(100), Apellido), 1, CONVERT(VARBINARY(4), PersonaID)),

        FechaNacimiento_Cifrada = EncryptByKey( Key_GUID('ClaveSimetrica_Persona'), CONVERT(VARBINARY(10), CONVERT(VARCHAR(10), FechaNacimiento, 23)),  
        1, CONVERT(VARBINARY(4), PersonaID));

    IF EXISTS (
        SELECT 1
        FROM torneo.Persona
        WHERE
            Nombre_Cifrado IS NULL
            OR Apellido_Cifrado IS NULL
            OR FechaNacimiento_Cifrada IS NULL

            OR CONVERT(VARCHAR(50), DecryptByKey(Nombre_Cifrado, 1, CONVERT(VARBINARY(4), PersonaID))) <> Nombre

            OR CONVERT(VARCHAR(50), DecryptByKey(Apellido_Cifrado, 1, CONVERT(VARBINARY(4), PersonaID))) <> Apellido

            OR CONVERT(DATE, CONVERT(VARCHAR(10), DecryptByKey(FechaNacimiento_Cifrada, 1, CONVERT(VARBINARY(4), PersonaID))), 23) <> FechaNacimiento
    )
    BEGIN
        THROW 50001,
            'Error: la validacion del cifrado de Persona fallo.',
            1;
    END;

    COMMIT TRANSACTION;

    CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;

    PRINT 'Migracion completada correctamente.';
    PRINT 'Todos los datos cifrados fueron validados.';

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF EXISTS (SELECT 1 FROM sys.openkeys WHERE KEY_NAME = 'ClaveSimetrica_Persona')
        CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;
    THROW;
END CATCH;
GO


-- Tabla persona despues del cifrado
SELECT PersonaID, Nombre, Nombre_Cifrado, Apellido, Apellido_Cifrado, FechaNacimiento, FechaNacimiento_Cifrada
FROM torneo.Persona;

-- Eliminamos los campos por los campos cifrados
BEGIN TRY
    BEGIN TRANSACTION;
    ALTER TABLE torneo.Persona
    DROP COLUMN Nombre, Apellido, FechaNacimiento;

    EXEC sp_rename
        'torneo.Persona.Nombre_Cifrado', 'Nombre', 'COLUMN';

    EXEC sp_rename
        'torneo.Persona.Apellido_Cifrado', 'Apellido', 'COLUMN';

    EXEC sp_rename
        'torneo.Persona.FechaNacimiento_Cifrada', 'FechaNacimiento', 'COLUMN';

    ALTER TABLE torneo.Persona
    ALTER COLUMN Nombre VARBINARY(256) NOT NULL;

    ALTER TABLE torneo.Persona
    ALTER COLUMN Apellido VARBINARY(256) NOT NULL;

    ALTER TABLE torneo.Persona
    ALTER COLUMN FechaNacimiento VARBINARY(256) NOT NULL;

    COMMIT TRANSACTION;

    PRINT 'Columnas originales eliminadas correctamente.';
    PRINT 'La tabla Persona ahora almacena los datos personales cifrados.';

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO

-- Tabla despues de eliminar los campos con los datos crudos y se modifican los campos cifrados
SELECT *
FROM torneo.Persona;

-- Muestro los datos descifrados
CREATE OR ALTER VIEW torneo.VW_Persona_Descifrada
AS
SELECT
    PersonaID,
    CONVERT(VARCHAR(50), DecryptByKey(Nombre, 1, CONVERT(VARBINARY(4), PersonaID))) AS Nombre,
    CONVERT(VARCHAR(50), DecryptByKey(Apellido, 1, CONVERT(VARBINARY(4), PersonaID))) AS Apellido,
    CONVERT(DATE, CONVERT(VARCHAR(10), DecryptByKey(FechaNacimiento, 1, CONVERT(VARBINARY(4), PersonaID))), 23) AS FechaNacimiento
FROM torneo.Persona;
GO

OPEN SYMMETRIC KEY ClaveSimetrica_Persona
DECRYPTION BY CERTIFICATE Certificado_Persona;

SELECT *
FROM torneo.VW_Persona_Descifrada;

CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;




-- ============================================
-- Roles de seguidad
-- ============================================

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_Administrador')
    CREATE ROLE rol_Administrador;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_CargadorResultados')
    CREATE ROLE rol_CargadorResultados;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_GestorPublicidad')
    CREATE ROLE rol_GestorPublicidad;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'rol_Consulta')
    CREATE ROLE rol_Consulta;
GO

-- Verificar los roles creados
SELECT name AS Rol, type_desc AS Tipo
FROM sys.database_principals
WHERE name IN ('rol_Administrador', 'rol_CargadorResultados', 'rol_GestorPublicidad', 'rol_Consulta');
GO



-- ============================================
-- PERMISOS DEL ADMINISTRADOR
-- ============================================
GRANT EXECUTE ON SCHEMA::torneo
TO rol_Administrador;

GRANT EXECUTE ON SCHEMA::reglamento
TO rol_Administrador;

GRANT EXECUTE ON SCHEMA::publicidad
TO rol_Administrador;
GO



-- ============================================
-- PERMISOS DEL GESTOR DE PUBLICIDAD
-- ============================================

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

-- Reportes publicitarios
GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_MatrizPrimeTime
TO rol_GestorPublicidad;

GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_OcupacionPublicitaria_XML
TO rol_GestorPublicidad;
GO



-- ============================================
-- PERMISOS DEL CONSULTOR
-- ============================================
-- Reportes del torneo
GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_Goleadores
TO rol_Consulta;

GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_ResultadosEncuentros
TO rol_Consulta;

GRANT EXECUTE ON OBJECT::torneo.SP_Reporte_SeleccionesYPlantillas_XML
TO rol_Consulta;


-- Reportes del reglamento
GRANT EXECUTE ON OBJECT::reglamento.SP_Reporte_DesignacionesArbitrales
TO rol_Consulta;

GRANT EXECUTE ON OBJECT::reglamento.SP_Reporte_Tarjetas_Y_Suspensiones
TO rol_Consulta;


-- Reportes de publicidad
GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_MatrizPrimeTime
TO rol_Consulta;

GRANT EXECUTE ON OBJECT::publicidad.SP_Reporte_OcupacionPublicitaria_XML
TO rol_Consulta;
GO



-- ==========================================
-- Cargador de resultados
-- ==========================================
GRANT EXECUTE ON OBJECT::torneo.SP_RegistrarGol_Y_ActualizarResultado
TO rol_CargadorResultados;

GRANT EXECUTE ON OBJECT::reglamento.SP_ProcesarTarjeta_Y_Suspension
TO rol_CargadorResultados;
GO




-- =====================================================
-- CREAR USUARIOS DE PRUEBA
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_prueba_admin')
    CREATE USER usuario_prueba_admin WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_prueba_cargador')
    CREATE USER usuario_prueba_cargador WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_prueba_publicidad')
    CREATE USER usuario_prueba_publicidad WITHOUT LOGIN;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usuario_prueba_consulta')
    CREATE USER usuario_prueba_consulta WITHOUT LOGIN;
GO

-- =====================================================
-- ASIGNAR CADA USUARIO A SU ROL
-- =====================================================
IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = 'rol_Administrador'
      AND u.name = 'usuario_prueba_admin'
)
    ALTER ROLE rol_Administrador ADD MEMBER usuario_prueba_admin;

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = 'rol_CargadorResultados'
      AND u.name = 'usuario_prueba_cargador'
)
    ALTER ROLE rol_CargadorResultados ADD MEMBER usuario_prueba_cargador;

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = 'rol_GestorPublicidad'
      AND u.name = 'usuario_prueba_publicidad'
)
    ALTER ROLE rol_GestorPublicidad ADD MEMBER usuario_prueba_publicidad;

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_role_members rm
    JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
    WHERE r.name = 'rol_Consulta'
      AND u.name = 'usuario_prueba_consulta'
)
    ALTER ROLE rol_Consulta ADD MEMBER usuario_prueba_consulta;
GO



-- =====================================================
-- TEST DE ACCESOS PERMITIDOS Y DENEGADOS
-- =====================================================
EXECUTE AS USER = 'usuario_prueba_admin';

-- PRUEBA PERMITIDA
EXEC torneo.SP_Alta_Persona
    @Nombre = 'PERMISO',
    @Apellido = 'CONCEDIDO',
    @FechaNacimiento = '1990-05-10';

-- PRUEBA DENEGADA
SELECT * FROM torneo.Persona;

REVERT;
GO

SELECT
    USER_NAME() AS UsuarioBaseDatos,
    SUSER_SNAME() AS LoginActual,
    ORIGINAL_LOGIN() AS LoginOriginal;
GO


OPEN SYMMETRIC KEY ClaveSimetrica_Persona
DECRYPTION BY CERTIFICATE Certificado_Persona;

SELECT *
FROM torneo.VW_Persona_Descifrada;

CLOSE SYMMETRIC KEY ClaveSimetrica_Persona;


--- Prueba de usuraio cargador
SELECT TarjetaAsignadaID,  TarjetaID, PartidoID, PersonaID, Minuto, Motivo
FROM reglamento.TarjetaAsignada
WHERE PersonaID = 10305
  AND PartidoID = 1
ORDER BY TarjetaAsignadaID DESC;


EXECUTE AS USER = 'usuario_prueba_cargador';

-- PRUEBA PERMITIDA
EXEC reglamento.SP_ProcesarTarjeta_Y_Suspension
    @TarjetaID = 2,
    @PartidoID = 1,
    @PersonaID = 10305,
    @Minuto = 45,
    @Motivo = 'Prueba de seguridad';

-- PRUEBA DENEGADA
EXEC torneo.SP_Alta_Jugador;

REVERT;
GO

-- Salida exitosa:
SELECT TarjetaAsignadaID,  TarjetaID, PartidoID, PersonaID, Minuto, Motivo
FROM reglamento.TarjetaAsignada
WHERE PersonaID = 10305
  AND PartidoID = 1
ORDER BY TarjetaAsignadaID DESC;


SELECT AnuncianteID, Pais
FROM publicidad.Anunciante;


--- Prueba de usuraio publicidad
EXECUTE AS USER = 'usuario_prueba_publicidad';

-- PRUEBA PERMITIDA
EXEC publicidad.SP_Alta_Campaña
    @nombre = 'Campaña de prueba',
    @fechaInicio = '2026-11-19',
    @AnuncianteID = 1;

-- PRUEBA DENEGADA
EXEC torneo.SP_Alta_Jugador
    @PersonaID = 10305,
    @ClubOrigen = 'Club de prueba',
    @Dorsal = 99,
    @PosicionHabitual = 'Delantero',
    @ConvocatoriaID = 1;

REVERT;
GO

SELECT *
FROM publicidad.Campaña



--- Prueba de usuraio consulta
EXECUTE AS USER = 'usuario_prueba_consulta';

-- PRUEBA PERMITIDA
EXEC torneo.SP_Reporte_Goleadores;

-- PRUEBA DENEGADA
EXEC torneo.SP_Alta_Persona
    @Nombre = 'Juan',
    @Apellido = 'Perez',
    @FechaNacimiento = '1990-05-10';

REVERT;
GO

