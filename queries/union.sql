-- UNION entre planes individuales y empresariales
SELECT 
    'Individual' AS TipoPlan,
    s.description AS NombrePlan,
    pp.amount AS Precio,
    c.acronym AS Moneda
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid
WHERE p.maxaccounts = 1 -- Planes individuales

UNION

SELECT 
    'Empresarial' AS TipoPlan,
    s.description AS NombrePlan,
    pp.amount AS Precio,
    c.acronym AS Moneda
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid
WHERE p.maxaccounts > 1 
ORDER BY TipoPlan, Precio;