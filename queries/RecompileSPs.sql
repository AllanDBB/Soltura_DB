USE soltura;
GO

-- Procedimiento simple para recompilar todos los SPs
CREATE OR ALTER PROCEDURE solturadb.sp_RecompileAllSPs
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Iniciando recompilación: ' + CONVERT(VARCHAR, GETDATE(), 120);
    
    -- Cursor simple para recorrer todos los procedimientos
    DECLARE @sp_name NVARCHAR(255);
    DECLARE @sql NVARCHAR(500);
    DECLARE @count INT = 0;
    
    -- Seleccionar solo procedimientos personalizados (no de sistema)
    DECLARE sp_cursor CURSOR FOR 
        SELECT SCHEMA_NAME(schema_id) + '.' + name 
        FROM sys.procedures 
        WHERE is_ms_shipped = 0;
    
    OPEN sp_cursor;
    FETCH NEXT FROM sp_cursor INTO @sp_name;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'EXEC sp_recompile ''' + @sp_name + '''';
        EXEC sp_executesql @sql;
        
        SET @count = @count + 1;
        FETCH NEXT FROM sp_cursor INTO @sp_name;
    END
    
    CLOSE sp_cursor;
    DEALLOCATE sp_cursor;
    
    -- También recompilar vistas indexadas
    DECLARE view_cursor CURSOR FOR 
        SELECT SCHEMA_NAME(v.schema_id) + '.' + v.name 
        FROM sys.views v
        JOIN sys.indexes i ON v.object_id = i.object_id
        WHERE i.index_id > 0;
    
    OPEN view_cursor;
    FETCH NEXT FROM view_cursor INTO @sp_name;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'EXEC sp_recompile ''' + @sp_name + '''';
        EXEC sp_executesql @sql;
        
        SET @count = @count + 1;
        FETCH NEXT FROM view_cursor INTO @sp_name;
    END
    
    CLOSE view_cursor;
    DEALLOCATE view_cursor;
    
    PRINT 'Recompilación completada: ' + CONVERT(VARCHAR, GETDATE(), 120);
    PRINT 'Total objetos recompilados: ' + CAST(@count AS VARCHAR);
END;
GO

-- Para crear un trabajo programado simple:
-- 1. SQL Server Management Studio → SQL Server Agent → Jobs
-- 2. Click derecho → New Job
-- 3. Name: "Soltura_RecompileSPs_Weekly"
-- 4. Steps: Agregar paso con "EXEC solturadb.sp_RecompileAllSPs"
-- 5. Schedule: Configurar para cada domingo a las 2:00 AM

-- Para ejecutar manualmente:
-- EXEC solturadb.sp_RecompileAllSPs;