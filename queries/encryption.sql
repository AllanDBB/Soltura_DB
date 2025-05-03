DROP PROCEDURE IF EXISTS storageprocedureenc;
GO

CREATE PROCEDURE storageprocedureenc 
WITH ENCRYPTION 
AS
BEGIN
	SELECT * 
    FROM solturadb.soltura_users
    ORDER BY solturadb.soltura_users.userid ASC;  

    PRINT 'EJECUTADO';
END;
GO

EXEC storageprocedureenc;

-- Esto deber�a devolver NULL si el SP est� encriptado
SELECT OBJECT_DEFINITION(OBJECT_ID('storageprocedureenc'));

-- Esto deber�a lanzar un error
EXEC sp_helptext 'storageprocedureenc';
