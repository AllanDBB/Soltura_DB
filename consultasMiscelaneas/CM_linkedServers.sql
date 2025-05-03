
-- Crear base en el otro servidor
CREATE DATABASE BitacoraDB;
GO

USE BitacoraDB;
GO

CREATE TABLE dbo.BitacoraEventos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sp NVARCHAR(100),
    mensaje NVARCHAR(MAX),
    fecha DATETIME DEFAULT GETDATE()
);
GO

-- Crear el linked server en el servidor local
EXEC sp_addlinkedserver 
    @server = 'LinkedBitacora', 
    @srvproduct = '',
    @provider = 'SQLNCLI', 
    @datasrc = 'localhost,1434';

-- Configura login para conectarse al servidor remoto
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'LinkedBitacora',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'sa',
    @rmtpassword = 'Soltura12345';

-- Verificar la conexión al linked server
SELECT * FROM OPENQUERY(LinkedBitacora, 'SELECT name FROM sys.databases');

-- Crear el procedimiento almacenado en el servidor local
CREATE PROCEDURE solturadb.sp_RegistrarBitacoraLinked
    @NombreSP NVARCHAR(128),
    @Mensaje NVARCHAR(MAX),
    @Severity INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO LinkedBitacora.BitacoraDB.dbo.BitacoraEventos (nombre_sp, mensaje, fecha)
        VALUES (@NombreSP, @Mensaje, SYSDATETIME());
    END TRY
    BEGIN CATCH
    END CATCH
END;
GO