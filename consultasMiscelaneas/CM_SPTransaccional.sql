
/*
Crear un procedimiento almacenado transaccional que realice una operación del sistema, relacionado a subscripciones, pagos, servicios, transacciones o planes, y que dicha operación requiera insertar y/o actualizar al menos 3 tablas.
*/



-- Procedimiento
CREATE PROCEDURE solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription NVARCHAR(255),
    @LogoUrl NVARCHAR(255),
    @Amount DECIMAL(10, 2),
    @CurrencyId INT,
    @RecurrencyType SMALLINT, 
    @UserId INT,
    @MaxAccounts INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        BEGIN TRANSACTION;

        -- 1. Tabla 1
        DECLARE @SubscriptionId INT;
        INSERT INTO solturadb.soltura_subscriptions ([description], [logourl])
        VALUES (@SubscriptionDescription, @LogoUrl);
        SET @SubscriptionId = SCOPE_IDENTITY();

        -- 2. Tabla 2
        DECLARE @PlanPriceId INT;
        INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
        VALUES (@Amount, @RecurrencyType, GETDATE(), '2026-01-01', 0x01, @CurrencyId, @SubscriptionId);
        SET @PlanPriceId = SCOPE_IDENTITY();

        -- 3. Tabla 3
        INSERT INTO solturadb.soltura_planperson (acquisition, enabled, scheduleid, planpricesid, expirationdate, maxaccounts)
        VALUES (GETDATE(), 0x01, 1, @PlanPriceId, DATEADD(YEAR, 1, GETDATE()), @MaxAccounts);

     
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO




-- Prueba
EXEC solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription = 'Plan Familiar',
    @LogoUrl = 'https://soltura.com/images/plans/plan-familiar.png',
    @Amount = 49.99,
    @CurrencyId = 1, 
    @RecurrencyType = 1,
    @UserId = 1,
    @MaxAccounts = 5;

SELECT * FROM solturadb.soltura_planperson WHERE planpricesid = (SELECT planpricesid FROM solturadb.soltura_planprices WHERE subscriptionid = (SELECT subscriptionid FROM solturadb.soltura_subscriptions WHERE [description] = 'Plan Familiar'));