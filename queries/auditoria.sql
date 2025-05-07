-- Script para almacenar la auditoría de redenciones
-- En este estamos usando: executa as y distinct.

USE soltura;
GO

-- Crear un log severity.
Insert into solturadb.soltura_logseverity(name)
values('grave');

-- Crear un log source.
INSERT INTO solturadb.soltura_logsources DEFAULT VALUES;

-- Crear LogTypes (tipos de registro)
INSERT INTO solturadb.soltura_logtypes
    (name, ref1description, ref2description, val1description, val2description, payment_logtypescol)
VALUES
    ('SEGURIDAD_USUARIO', 
     'ID Usuario', 
     'ID Operación', 
     'Estado anterior', 
     'Estado nuevo',
     'Autenticación');

-- Vamos a crear un usuario, con el que podamos hacer una auditoría y probar el EXECUTE AS
-- se le dan solo permisos de lectura a las tablas de redenciones, usuarios y beneficios.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AuditUser')
BEGIN
    CREATE USER AuditUser WITHOUT LOGIN;
    
    -- Dar permisos mínimos
    GRANT SELECT ON solturadb.soltura_redemptions TO AuditUser;
    GRANT SELECT ON solturadb.soltura_users TO AuditUser;
    GRANT SELECT ON solturadb.soltura_benefits TO AuditUser;
    GRANT INSERT ON solturadb.soltura_logs TO AuditUser;
END
GO

-- Procedimiento con EXECUTE AS que utiliza la tabla de logs que existen
CREATE OR ALTER PROCEDURE solturadb.sp_SimpleAudit
    @days INT = 7
WITH EXECUTE AS 'AuditUser'
AS
BEGIN
    DECLARE @log_description NVARCHAR(120); -- Descripción del log
    DECLARE @total_count INT; -- Total de redenciones en el período
    DECLARE @most_redeemed_benefit_id INT; -- ID del beneficio más redimido
    DECLARE @most_active_user_id INT; -- ID del usuario más activo
    
    SELECT @total_count = COUNT(DISTINCT r.redemptionid) -- OJO estamos el distinct para evitar contar redenciones duplicadas :D
    FROM solturadb.soltura_redemptions r
    WHERE r.date >= DATEADD(DAY, -@days, GETDATE());
    
    -- Esto solo es para buscar el beneficio más redimido
    SELECT TOP 1 @most_redeemed_benefit_id = benefitsid
    FROM solturadb.soltura_redemptions
    WHERE date >= DATEADD(DAY, -@days, GETDATE())
    GROUP BY benefitsid
    ORDER BY COUNT(*) DESC;
    
    -- Buscar el usuario más activio
    SELECT TOP 1 @most_active_user_id = userid
    FROM solturadb.soltura_redemptions
    WHERE date >= DATEADD(DAY, -@days, GETDATE())
    GROUP BY userid
    ORDER BY COUNT(*) DESC;
    
    SET @log_description = 'Audit: ' + CAST(@total_count AS VARCHAR) + ' redemptions in last ' + CAST(@days AS VARCHAR) + ' days';
    
    INSERT INTO solturadb.soltura_logs
       (description, posttime, computer, username, trace,
        referenceid1, referenceid2, value1, value2,
        checksum, logtypesid, logsourcesid, logseverityid)
    VALUES
       (@log_description,
        GETDATE(),
        HOST_NAME(),
        ORIGINAL_LOGIN(),
        'EXECUTE AS Audit',
        @most_active_user_id,  -- referenceid1 = El usuario más activo
        @most_redeemed_benefit_id,  -- referenceid2 = El beneficio más redimido
        @total_count,  -- value1 = total de redenciones
        @days,
        HASHBYTES('SHA2_256', @log_description),
        1,  
        1,  
        1   
       );
       
    SELECT 
        'Executing as: ' + USER_NAME() AS ExecutionContext,
        @total_count AS TotalRedemptions,
        @most_active_user_id AS MostActiveUserID,
        @most_redeemed_benefit_id AS MostRedeemedBenefitID,
        'Audit log created successfully' AS Status;
END;
GO

-- Dar permiso de ejecución al procedimiento almacenado
GRANT EXECUTE ON solturadb.sp_SimpleAudit TO PUBLIC;
GO

-- Ejecutar con distintos períodos de tiempo al sp 
EXEC solturadb.sp_SimpleAudit @days = 30;