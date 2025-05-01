
-- Verificar que existe el proceso
USE soltura;
GO

-- Verificar si el procedimiento existe
SELECT name, schema_id, object_id FROM sys.procedures 
WHERE name = 'sp_RecompileAllSPs';

-- Verificar el esquema
SELECT name FROM sys.schemas 
WHERE schema_id = SCHEMA_ID('solturadb');



USE soltura
GO

-- Declarar variable para almacenar la cuenta del SQL Server Agent
DECLARE @AgentAccount NVARCHAR(128);

-- Obtener automáticamente la cuenta del SQL Server Agent
SELECT @AgentAccount = service_account 
FROM sys.dm_server_services
WHERE servicename LIKE '%SQL Server Agent%';

IF @AgentAccount IS NOT NULL
BEGIN
    PRINT 'Cuenta del SQL Server Agent detectada: ' + @AgentAccount;
    
    -- Otorgar permiso de ejecución al SQL Server Agent para el procedimiento
    DECLARE @GrantProcSql NVARCHAR(MAX) = 'GRANT EXECUTE ON solturadb.sp_RecompileAllSPs TO [' + @AgentAccount + ']';
    EXEC sp_executesql @GrantProcSql;
    PRINT 'Permiso concedido sobre sp_RecompileAllSPs';
    
    -- Otorgar permiso para ejecutar sp_recompile en master
    USE master;
    DECLARE @GrantMasterSql NVARCHAR(MAX) = 'GRANT EXECUTE ON sys.sp_recompile TO [' + @AgentAccount + ']';
    EXEC sp_executesql @GrantMasterSql;
    PRINT 'Permiso concedido sobre sp_recompile en master';
    
    -- Volver a la base de datos soltura
    USE soltura;
    
    -- Verificar que el procedimiento existe
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_RecompileAllSPs' AND schema_id = SCHEMA_ID('solturadb'))
    BEGIN
        PRINT 'El procedimiento solturadb.sp_RecompileAllSPs existe y está listo para ser usado por el SQL Server Agent';
    END
    ELSE
    BEGIN
        PRINT '¡ADVERTENCIA! El procedimiento solturadb.sp_RecompileAllSPs no existe. Debe crearlo antes de configurar el Job.';
    END
END
ELSE
BEGIN
    PRINT 'No se pudo detectar la cuenta del SQL Server Agent. Verifique que el servicio esté en ejecución.';
END