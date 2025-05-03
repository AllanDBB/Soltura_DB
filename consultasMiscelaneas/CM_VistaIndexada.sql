/*
Crear una vista indexada con al menos 4 tablas (ej. usuarios, suscripciones, pagos, servicios). La vista debe ser dinámica, no una vista materializada con datos estáticos. Demuestre que si es dinámica.
*/
--La vista indexada
CREATE VIEW solturadb.vw_UserSubscriptionDetails
WITH SCHEMABINDING
AS
SELECT 
    u.userid,
    u.firstname,
    u.lastname,
    pp.planpersonid,
    s.subscriptionid,
    s.description AS subscription_description,
    ppr.amount AS subscription_price,
    ppr.currencyid,
    b.benefitsid,
    b.name AS benefit_name,
    b.description AS benefit_description,
    b.availableuntil
FROM 
    solturadb.soltura_users u
JOIN 
    solturadb.soltura_planperson_users ppu ON u.userid = ppu.userid
JOIN 
    solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
JOIN 
    solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
JOIN 
    solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
JOIN 
    solturadb.soltura_benefits b ON pp.planpersonid = b.planpersonid;
GO


CREATE UNIQUE CLUSTERED INDEX IX_vw_UserSubscriptionDetails
ON solturadb.vw_UserSubscriptionDetails (userid, planpersonid, benefitsid);
GO



-- Para probar que es dinámica hacemos esta inserción

INSERT INTO solturadb.soltura_benefits
    (enabled, name, description, availableuntil, planpersonid, categorybenefitsid, contractDetailId, benefitTypeId, benefitSubTypeId)
VALUES
    (0x01, 'Nuevo Beneficio', 'Descripción del nuevo beneficio', '2026-12-31', 1, 1, 1, 1, 1);
GO

-- Consultar la vista para verificar que el nuevo beneficio aparece
SELECT *
FROM solturadb.vw_UserSubscriptionDetails
WHERE planpersonid = 1;
GO