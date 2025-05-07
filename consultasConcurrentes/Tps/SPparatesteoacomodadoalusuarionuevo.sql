USE soltura;
GO

IF OBJECT_ID('solturadb.sp_insertRedemptionPorParametros', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_insertRedemptionPorParametros; --Lo borra si es el caso para evitar errores al crear el procedimiento
GO

CREATE PROCEDURE solturadb.sp_insertRedemptionPorParametros
    @userId INT,
    @planpersonId INT,
    @benefitId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS --Revisa que los valores recibidos existan y cumplan las restricciones
        (
            SELECT 1
            FROM solturadb.soltura_planperson_users ppu
            JOIN solturadb.soltura_benefits b ON b.planpersonid = ppu.planpersonid
            WHERE ppu.userid = @userId AND ppu.planpersonid = @planpersonId AND b.benefitsid = @benefitId
        )
        BEGIN
            PRINT 'Relacion invalida entre ell usuario, su plan y el beneficio asociado al plan.'; --Si no existe ninguno tal que eso se cumpla hace rollback y termina el procedimiento.
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @redemptionMethodId INT;
        DECLARE @reference1 BIGINT = 100000 + FLOOR(RAND() * 900000); --Valores random solo para dar a entender que ahi iria una referencia
        DECLARE @reference2 BIGINT = 200000 + FLOOR(RAND() * 900000);
        DECLARE @value1 NVARCHAR(100) = CONCAT('Redimido: ', @benefitId);
        DECLARE @value2 NVARCHAR(100) = CONCAT('El Usuario ', @userId, 'lo a redimido.');

        SELECT TOP 1 @redemptionMethodId = redemptionMethodsid
        FROM solturadb.soltura_redemptionMethods
        ORDER BY NEWID(); --Elige un redemptionmethod random para usar con la insercion de redemptions

        INSERT INTO solturadb.soltura_redemptions
            (date, redemptionMethodsid, userid, benefitsid, reference1, reference2, value1, value2, checksum)
        VALUES
            (GETDATE(), @redemptionMethodId, @userId, @benefitId, @reference1, @reference2,
             CONVERT(VARBINARY(100), @value1), CONVERT(VARBINARY(100), @value2),HASHBYTES('SHA2_256', CONCAT(@userId, '089080800',@benefitId, 'valoresparaenloqueserelchecksummm',@reference1, 'denlealcoholalchecksum',@reference2, 'guaro',@value1, 'loqueraaaa',@value2))); 

        COMMIT TRANSACTION;
        PRINT 'Insert efectuado.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Ocurrio un error durante la insercion.';
        THROW;
    END CATCH
END;
GO

GRANT EXECUTE ON solturadb.sp_insertRedemptionPorParametros TO [nombre_usuario];

IF OBJECT_ID('solturadb.sp_getRandomUserPlanBenefit', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_getRandomUserPlanBenefit;
GO

CREATE PROCEDURE solturadb.sp_getRandomUserPlanBenefit --Simplemente saca un valor random con joins para tener relaciones funcionales y que existan. Para usar de ejemplo.
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT TOP 1
            u.userid,
            pp.planpersonid,
            b.benefitsid
        FROM solturadb.soltura_users u
        JOIN solturadb.soltura_planperson_users ppu ON u.userid = ppu.userid
        JOIN solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
        JOIN solturadb.soltura_benefits b ON b.planpersonid = pp.planpersonid
        WHERE b.enabled = 0x01
        ORDER BY NEWID();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Ocurrio un error al obtener datos.';
        THROW;
    END CATCH
END;
GO

EXEC solturadb.sp_getRandomUserPlanBenefit;
GRANT EXECUTE ON solturadb.sp_getRandomUserPlanBenefit TO [nombre_usuario];
