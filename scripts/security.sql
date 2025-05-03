use soltura



--- 2 Conceder solo permisos de SELECT sobre una tabla a un usuario específico. Será posible crear roles y que existan roles que si puedan hacer ese select sobre esa tabla y otros Roles que no puedan? Demuestrelo con usuarios y roles pertinentes.
-- Crear usuario con permisos para select 
CREATE LOGIN selectPermsLogin WITH PASSWORD = '123456';
CREATE USER selectPermsUser FOR LOGIN selectPermsLogin;

-- Crear usuario SIN select, este mae se mete a mi base de datos y lo demando -.- 
CREATE LOGIN noSelectPermsLogin WITH PASSWORD = '123456';
CREATE USER noSelectPermsUser FOR LOGIN noSelectPermsLogin;

-- Rol con permiso de SELECT
CREATE ROLE rolSelect;

-- Rol sin permisos explícitos
CREATE ROLE rolNoSelect;

-- Asignar usuarios a roles
EXEC sp_addrolemember 'rolSelect', 'selectPermsUser';
EXEC sp_addrolemember 'rolNoSelect', 'noSelectPermsUser';
GO

-- Ahora, se asignan los permisos según lo que queremos. En este caso, se le da permisos de SELECT al rol rolSelect, y no se le da nada al rolNoSelect.
GRANT SELECT ON solturadb.soltura_users TO rolSelect;


--- 3 Permitir ejecución de ciertos SPs y denegar acceso directo a las tablas que ese SP utiliza, será que aunque tengo las tablas restringidas, puedo ejecutar el SP?

-- Para este ejemplo, sigo con el usuario que no tiene acceso a nada, ni users, ni nada, pero le vamos a dar permisos de ejecutar el SP.

-- Entonces, creo el SPs
CREATE PROCEDURE sp_consultarUsers
WITH EXECUTE AS OWNER
AS
BEGIN
    SELECT * FROM solturadb.soltura_users;
END;
GO


-- Y ahora, al usuario que no tiene permisos : noSelectPermsUser, le vamos a dar chance de que use los sp.
GRANT EXECUTE ON sp_consultarUsers TO noSelectPermsUser;



--- 4 habrá alguna forma de implementar RLS, row level security
-- Se implementará un RLS para que un usuario solo vea sus datos, digamos.

-- Se crea la función de predicado para filtrar planes de usuarios
CREATE OR ALTER FUNCTION [solturadb].[SecurityPredicatePlanperson](@UserId INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
    SELECT 1 AS result
    WHERE @UserId = CAST(SESSION_CONTEXT(N'UserId') AS INT);
GO

-- Entonces, ahora sí, aplicamos la política de seguridad a la tabla planperson_users
CREATE SECURITY POLICY [solturadb].[PlanpersonFilter]
ADD FILTER PREDICATE [solturadb].[SecurityPredicatePlanperson]([userid])
ON [solturadb].[soltura_planperson_users]
WITH (STATE = ON);
GO

-- Y ahora, para que el RLS exista, necesita su context, entonces, lo asignamos al userId (Para no tener que crear mil usuarios, lo hago con userId.)
CREATE OR ALTER PROCEDURE [solturadb].[SetUserContext]
    @UserId INT
AS
BEGIN
    EXEC sp_set_session_context @key = N'UserId', @value = @UserId;
END;
GO

-- Ejemplo:
EXEC [solturadb].[SetUserContext] @UserId = 1; -- Ponemos el contexto para el userId 1.

-- Se puede cambiar el userId para probar con otros usuarios.

-- Ahora, si el usuario 1 ejecuta un select a la tabla, solo verá sus datos.
SELECT pu.planpersonid, pu.userid, pp.acquisition, pp.enabled, s.description AS 'Plan'
FROM [solturadb].[soltura_planperson_users] pu
JOIN [solturadb].[soltura_planperson] pp ON pu.planpersonid = pp.planpersonid
JOIN [solturadb].[soltura_planprices] ppr ON pp.planpricesid = ppr.planpricesid
JOIN [solturadb].[soltura_subscriptions] s ON ppr.subscriptionid = s.subscriptionid;


--- 5 certificado, llave simétrica, asimétrica y cifrados

-- Antes de crear un certificado, llaves o cualquier vara así, se necesita una master key en la db.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123456'; -- La master key protege todo lo demás digamos.
GO

-- Ahora, se puede crear un certificado
CREATE CERTIFICATE CertificadoSoltura
WITH SUBJECT = 'Certificado para seguridad en Soltura',
EXPIRY_DATE = '2030-12-31';

-- Y se verifica:
SELECT * FROM sys.certificates WHERE name = 'CertificadoSoltura';
GO

-- Para crear llave simétrica:
CREATE ASYMMETRIC KEY LlaveAsimSoltura
WITH ALGORITHM = RSA_2048; -- Esto es el algoritmo y cantidad de bits para cifrar, tmb existe: 512, 1024.
GO

-- Verificar:
SELECT * FROM sys.asymmetric_keys WHERE name = 'LlaveAsimSoltura';


-- Ahora la creación de la llave simétrica:
-- Esta se puede crear cifrando con certificado o con una llave asimétrica:
-- 1) Con certificado:
CREATE SYMMETRIC KEY LlaveSimSoltura
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertificadoSoltura; 
GO

-- 2) Con llave asimétrica:
CREATE SYMMETRIC KEY LlaveSimSoltura2
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY LlaveAsimSoltura;
GO

-- Verificar:
SELECT * FROM sys.symmetric_keys WHERE name = 'LlaveSimSoltura';


-- Ahora Cifrar datos sensibles usando cifrado simétrico y proteger la llave privada con las llaves asimétrica definidas en un certificado del servidor.
CREATE OR ALTER PROCEDURE [solturadb].[SP_CifrarPassword]
    @UserId INT,
    @Password NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM solturadb.soltura_users WHERE userid = @UserId)
    BEGIN
        RAISERROR('Usuario no encontrado', 16, 1);
        RETURN;
    END
    
    -- Abrir la llave simétrica
    OPEN SYMMETRIC KEY LlaveSimSoltura
    DECRYPTION BY CERTIFICATE CertificadoSoltura;
    
    -- Cifrar el password y actualizar el usuario
    UPDATE solturadb.soltura_users
    SET password = EncryptByKey(Key_GUID('LlaveSimSoltura'), @Password)
    WHERE userid = @UserId;
    
    -- Cerrar la llave
    CLOSE SYMMETRIC KEY LlaveSimSoltura;
    
    PRINT 'Contraseña cifrada y guardada correctamente';
END;
GO


--Crear un SP que descifre los datos protegidos usando las llaves anteriores.
CREATE OR ALTER PROCEDURE [solturadb].[SP_VerificarPassword]
    @UserId INT,
    @Password NVARCHAR(50),
    @EsCorrecta BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @EsCorrecta = 0;
    
    DECLARE @PasswordGuardado NVARCHAR(50);
    
    -- Abrir la llave simétrica
    OPEN SYMMETRIC KEY LlaveSimSoltura
    DECRYPTION BY CERTIFICATE CertificadoSoltura;
    
    -- Obtener y descifrar el password almacenado
    SELECT @PasswordGuardado = CONVERT(NVARCHAR(50), 
        DecryptByKey(password))
    FROM solturadb.soltura_users
    WHERE userid = @UserId;
    
    -- Cerrar la llave
    CLOSE SYMMETRIC KEY LlaveSimSoltura;
    
    -- Verificar la contraseña
    IF @PasswordGuardado = @Password
        SET @EsCorrecta = 1;
END;
GO

-- Entonces, para cifrar una contraseña de un usuario:
EXEC solturadb.SP_CifrarPassword @UserId = 1, @Password = '1234567';

-- Y para verficar la contraseña de un usuario:
DECLARE @Resultado BIT;
EXEC solturadb.SP_VerificarPassword @UserId = 1, @Password = '1234567', @EsCorrecta = @Resultado OUTPUT;
SELECT @Resultado AS PasswordCorrecto;