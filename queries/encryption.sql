
-- WITH ENCRYPTION para proteger el código del SP
CREATE OR ALTER PROCEDURE solturadb.sp_SecretBusinessLogic
WITH ENCRYPTION
AS
BEGIN
    -- Este procedimiento contiene lógica de negocio confidencial
    -- y su código ahora está protegido contra inspección
    SELECT TOP 5 * FROM solturadb.soltura_benefits 
    ORDER BY NEWID(); -- Solo como ejemplo
    
    PRINT 'La lógica de negocio confidencial ha sido ejecutada';
END;
GO

-- Intentar ver el código (esto no mostrará el código, solo NULL)
PRINT 'Intentando ver el código encriptado:';
SELECT OBJECT_DEFINITION(OBJECT_ID('solturadb.sp_SecretBusinessLogic')) AS 'Código encriptado';