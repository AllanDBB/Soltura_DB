USE soltura;
GO

-- Tipo de tabla simplificado para detalles de contrato
CREATE TYPE solturadb.ContractDetailsType AS TABLE (
    DetailId INT NULL,              
    Name NVARCHAR(30) NOT NULL,
    Description NVARCHAR(100) NOT NULL,
    Price REAL NOT NULL,
    SolturaPercentage REAL NOT NULL,
    CompanyPercentage REAL NOT NULL
);
GO

-- Procedimiento simplificado para actualizar contratos
CREATE OR ALTER PROCEDURE solturadb.SP_UpdateProviderContract
    @CompanyName NVARCHAR(20),              
    @AddressId INT,                         
    @ContractName NVARCHAR(30),            
    @ExpirationDate DATETIME2(0),          
    @ContractDetails solturadb.ContractDetailsType READONLY  
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CompanyId INT;
    DECLARE @ContractId INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Verificar/insertar proveedor
        SELECT @CompanyId = associatedCompaniesid 
        FROM solturadb.soltura_associatedCompanies 
        WHERE name = @CompanyName;
        
        IF @CompanyId IS NULL
        BEGIN
            INSERT INTO solturadb.soltura_associatedCompanies (name, addressId)
            VALUES (@CompanyName, @AddressId);
            SET @CompanyId = SCOPE_IDENTITY();
        END
        
        -- 2. Verificar/insertar contrato
        SELECT @ContractId = contractid 
        FROM solturadb.soltura_contracts 
        WHERE associatedCompaniesid = @CompanyId AND name = @ContractName;
        
        IF @ContractId IS NULL
        BEGIN
            INSERT INTO solturadb.soltura_contracts (name, date, expirationdate, associatedCompaniesid)
            VALUES (@ContractName, GETDATE(), @ExpirationDate, @CompanyId);
            SET @ContractId = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE solturadb.soltura_contracts
            SET expirationdate = @ExpirationDate
            WHERE contractid = @ContractId;
        END
        
        -- 3. Procesar detalles del contrato
        -- Actualizar detalles existentes
        UPDATE cd
        SET cd.name = src.Name,
            cd.description = src.Description,
            cd.price = src.Price,
            cd.solturaPercentage = src.SolturaPercentage,
            cd.companyPercentage = src.CompanyPercentage
        FROM solturadb.soltura_contractDetails cd
        JOIN @ContractDetails src ON cd.contractDetailid = src.DetailId
        WHERE src.DetailId IS NOT NULL;
        
        -- Insertar nuevos detalles
        INSERT INTO solturadb.soltura_contractDetails 
            (name, description, contractid, price, solturaPercentage, companyPercentage)
        SELECT 
            Name, Description, @ContractId, Price, SolturaPercentage, CompanyPercentage
        FROM @ContractDetails
        WHERE DetailId IS NULL;
        
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Este crea un nuevo contrato y actualiza los detalles del contrato
DECLARE @ContractDetails solturadb.ContractDetailsType;

INSERT INTO @ContractDetails (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (NULL, 'Descuento Básico', 'Descuento para todos los clientes', 25.00, 20.00, 80.00),
    (NULL, 'Servicio Premium', 'Servicio avanzado mensual', 75.00, 20.00, 80.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31',
    @ContractDetails = @ContractDetails;


-- Este actualiza un contrato existente y sus detalles
DECLARE @NuevaClausula solturadb.ContractDetailsType;

INSERT INTO @NuevaClausula (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (NULL, 'Cláusula de Exclusividad', 
     'El proveedor se compromete a no ofrecer descuentos similares a otras plataformas por 6 meses', 
     0.00, 50.00, 50.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31', 
    @ContractDetails = @NuevaClausula;


-- Ejemplo para editar una cláusula existente
DECLARE @EditarClausula solturadb.ContractDetailsType;

DECLARE @ClausulaId INT = 3;

INSERT INTO @EditarClausula (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (@ClausulaId, 'Cláusula de Exclusividad Modificada', 
     'El proveedor se compromete a no ofrecer descuentos similares a otras plataformas por 12 meses', 
     0.00, 60.00, 40.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31',
    @ContractDetails = @EditarClausula;

