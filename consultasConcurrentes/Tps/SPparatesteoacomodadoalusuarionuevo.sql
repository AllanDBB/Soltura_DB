IF OBJECT_ID('solturadb.sp_insertRedemptionPorParametros', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_insertRedemptionPorParametros;
GO

CREATE PROCEDURE solturadb.sp_insertRedemptionPorParametros
    @userId INT,
    @planpersonId INT,
    @benefitId INT
AS
BEGIN
    -- Validar que los parámetros están relacionados correctamente
    IF NOT EXISTS (
        SELECT 1
        FROM solturadb.soltura_planperson_users ppu
        JOIN solturadb.soltura_benefits b ON b.planpersonid = ppu.planpersonid
        WHERE ppu.userid = @userId AND ppu.planpersonid = @planpersonId AND b.benefitsid = @benefitId
    )
    BEGIN
        PRINT 'Relación inválida entre usuario, plan y beneficio.';
        RETURN;
    END

    DECLARE @redemptionMethodId INT;
    DECLARE @reference1 BIGINT = 100000 + FLOOR(RAND() * 900000);
    DECLARE @reference2 BIGINT = 200000 + FLOOR(RAND() * 900000);
    DECLARE @value1 NVARCHAR(100) = CONCAT('Redención de beneficio ', @benefitId);
    DECLARE @value2 NVARCHAR(100) = CONCAT('Usuario ', @userId, ' redimió el beneficio.');

    -- Método de redención aleatorio
    SELECT TOP 1 @redemptionMethodId = redemptionMethodsid
    FROM solturadb.soltura_redemptionMethods
    ORDER BY NEWID();

    -- Insertar redención
    INSERT INTO solturadb.soltura_redemptions
        (date, redemptionMethodsid, userid, benefitsid, reference1, reference2, value1, value2, checksum)
    VALUES
        (GETDATE(), @redemptionMethodId, @userId, @benefitId, @reference1, @reference2,
         CONVERT(VARBINARY(100), @value1), CONVERT(VARBINARY(100), @value2), 0x0123456789);

    PRINT 'Redención insertada correctamente.';
END;
GO

GRANT EXECUTE ON solturadb.sp_insertRedemptionPorParametros TO [nombre_usuario];



IF OBJECT_ID('solturadb.sp_getRandomUserPlanBenefit', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_getRandomUserPlanBenefit;
GO

CREATE PROCEDURE solturadb.sp_getRandomUserPlanBenefit
AS
BEGIN
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
END;
GO
EXEC solturadb.sp_getRandomUserPlanBenefit;
GRANT EXECUTE ON solturadb.sp_getRandomUserPlanBenefit TO [nombre_usuario];