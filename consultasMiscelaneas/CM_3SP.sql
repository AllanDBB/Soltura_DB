/*
Crear un procedimiento almacenado transaccional que llame a otro SP transaccional, el cual a su vez llame a otro SP transaccional. 
Cada uno debe modificar al menos 2 tablas. Se debe demostrar que es posible hacer COMMIT y ROLLBACK con ejemplos exitosos y fallidos sin que haya interrumpción
de la ejecución correcta de ninguno de los SP en ninguno de los niveles del llamado.
*/


USE soltura;
GO
CREATE PROCEDURE [solturadb].[SP_DesactivarSchedules]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
      
        UPDATE solturadb.soltura_schedules
        SET enddate = GETDATE() -- Finalizar el schedule al poner la enddate en el presente
        WHERE scheduleid IN (
            SELECT DISTINCT scheduleid
            FROM solturadb.soltura_planperson
            WHERE planpersonid IN (
                SELECT DISTINCT planpersonid
                FROM solturadb.soltura_benefits
                WHERE categorybenefitsid = @CategoryId
            )
        );

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO

CREATE PROCEDURE [solturadb].[SP_DesactivarSuscripcionesYPlanes]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
        -- Desactivar los planes asociados a los beneficios de la categoría
        UPDATE solturadb.soltura_planperson
        SET enabled = 0x00
        WHERE planpersonid IN (
            SELECT DISTINCT planpersonid
            FROM solturadb.soltura_benefits
            WHERE categorybenefitsid = @CategoryId
        );

        -- Desactivar las suscripciones asociadas a los planes
        UPDATE solturadb.soltura_subscriptions
        SET [description] = CONCAT([description], ' - Desactivada')
        WHERE subscriptionid IN (
            SELECT DISTINCT ppr.subscriptionid
            FROM solturadb.soltura_planprices ppr
            JOIN solturadb.soltura_planperson pp ON ppr.planpricesid = pp.planpricesid
            WHERE pp.planpersonid IN (
                SELECT DISTINCT planpersonid
                FROM solturadb.soltura_benefits
                WHERE categorybenefitsid = @CategoryId
            )
        );

       
        EXEC [solturadb].[SP_DesactivarSchedules] @CategoryId;

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE [solturadb].[SP_DesactivarCategoria]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
        -- Desactivar la categoría
        UPDATE solturadb.soltura_categorybenefits
        SET enabled = 0x00
        WHERE categorybenefitsid = @CategoryId;

        -- Desactivar los beneficios asociados a la categoría
        UPDATE solturadb.soltura_benefits
        SET enabled = 0x00
        WHERE categorybenefitsid = @CategoryId;

        -- Llamar al procedimiento para desactivar schedules
        EXEC [solturadb].[SP_DesactivarSchedules] @CategoryId;

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO


--PRUEBAS


-- exitosa
SELECT 
    cb.categorybenefitsid AS CategoriaID,
    cb.name AS Categoria,
    cb.enabled AS CategoriaHabilitada,
    b.benefitsid AS BeneficioID,
    b.name AS Beneficio,
    b.enabled AS BeneficioHabilitado,
    pp.planpersonid AS PlanPersonID,
    pp.enabled AS PlanHabilitado,
    s.subscriptionid AS SuscripcionID,
    s.description AS Suscripcion,
    sch.scheduleid AS ScheduleID,
    sch.enddate AS ScheduleEndDate
FROM solturadb.soltura_categorybenefits cb
LEFT JOIN solturadb.soltura_benefits b ON cb.categorybenefitsid = b.categorybenefitsid
LEFT JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
LEFT JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
LEFT JOIN solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
LEFT JOIN solturadb.soltura_schedules sch ON pp.scheduleid = sch.scheduleid
WHERE cb.categorybenefitsid = 999 --CAMBIAR ID DEPENDIENDO DE LA PRUEBA!!!
ORDER BY cb.categorybenefitsid, b.benefitsid, pp.planpersonid, s.subscriptionid, sch.scheduleid;

EXEC [solturadb].[SP_DesactivarCategoria] @CategoryId = 2; -- ID de prueba

-- correr de nuevo el select para ver que ahora todo está deshabilitado


-- fallido
EXEC [solturadb].[SP_DesactivarCategoria] @CategoryId = 999; -- ID inexistente
-- correr el select con 999 y ver que no da nada, pero no hay errores por el rollback y try/catch