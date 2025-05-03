-- Consulta para generar JSON de dashboard de planes del usuario
DECLARE @UserID INT = 1;  

SELECT 
    u.userid,
    u.userid AS user_id,  
    JSON_QUERY(( -- Esto es un subquery para obtener las suscripciones del usuario
        SELECT 
            pp.planpersonid,
            pp.acquisition AS subscription_date,
            pp.expirationdate AS expiration_date,
            CAST(CASE WHEN pp.enabled = 0x01 THEN 1 ELSE 0 END AS BIT) AS is_active,
            s.description AS plan_name,
            s.logourl AS plan_logo,
            ppr.amount AS price,
            ISNULL(c.symbol, '$') + ' ' + CAST(ppr.amount AS NVARCHAR) AS formatted_price,
            ISNULL(c.acronym, 'USD') AS currency_code,
            (
                SELECT 
                    b.benefitsid,
                    b.name AS benefit_name,
                    b.description AS benefit_description,
                    cb.name AS category_name,
                    bt.name AS benefit_type,
                    bst.name AS benefit_subtype,
                    cd.companyPercentage AS discount_percentage,
                    ac.name AS provider_name,
                    (
                        SELECT TOP 1 value 
                        FROM solturadb.soltura_companiesContactinfo ci 
                        WHERE ci.associatedCompaniesid = ac.associatedCompaniesid 
                        AND ci.companyinfotypeId = (SELECT companyinfotypeId FROM solturadb.soltura_companyinfotypes WHERE name = 'Sitio Web')
                    ) AS provider_website
                FROM solturadb.soltura_benefits b
                JOIN solturadb.soltura_categorybenefits cb ON b.categorybenefitsid = cb.categorybenefitsid
                JOIN solturadb.soltura_contractDetails cd ON b.contractDetailId = cd.contractDetailid
                JOIN solturadb.soltura_contracts c ON cd.contractid = c.contractid
                JOIN solturadb.soltura_associatedCompanies ac ON c.associatedCompaniesid = ac.associatedCompaniesid
                LEFT JOIN dbo.soltura_benefitTypes bt ON b.benefitTypeId = bt.benefitTypeId
                LEFT JOIN dbo.soltura_benefitSubTypes bst ON b.benefitSubTypeId = bst.benefitSubTypeId
                WHERE b.planpersonid = pp.planpersonid
                FOR JSON PATH
            ) AS benefits
        FROM solturadb.soltura_planperson_users ppu
        JOIN solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
        JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
        JOIN solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
        LEFT JOIN solturadb.soltura_currency c ON ppr.currencyid = c.currencyid
        WHERE ppu.userid = u.userid
        FOR JSON PATH
    )) AS subscriptions,
    (SELECT COUNT(*) FROM solturadb.soltura_planperson_users ppu WHERE ppu.userid = u.userid) AS total_plans,
    (
        SELECT TOP 5
            r.redemptionid,
            r.date AS redemption_date,
            b.name AS benefit_name,
            ac.name AS provider_name,
            rm.name AS redemption_method
        FROM solturadb.soltura_redemptions r
        JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
        JOIN solturadb.soltura_redemptionMethods rm ON r.redemptionMethodsid = rm.redemptionMethodsid
        JOIN solturadb.soltura_contractDetails cd ON b.contractDetailId = cd.contractDetailid
        JOIN solturadb.soltura_contracts c ON cd.contractid = c.contractid
        JOIN solturadb.soltura_associatedCompanies ac ON c.associatedCompaniesid = ac.associatedCompaniesid
        WHERE r.userid = u.userid
        ORDER BY r.date DESC
        FOR JSON PATH
    ) AS recent_redemptions
FROM solturadb.soltura_users u
WHERE u.userid = @UserID
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER; -- Y esto devuelve el JSON, lo del without_array_wrapper es para que no devuelva un array, sino un objeto JSON