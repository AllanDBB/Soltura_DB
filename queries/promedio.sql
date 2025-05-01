-- AVG con agrupamiento (promedio de montos pagados por suscripción)
SELECT 
    s.description AS 'Plan',
    c.acronym AS 'Moneda',
    AVG(pp.amount) AS 'Precio Promedio'
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid
GROUP BY s.description, c.acronym
ORDER BY AVG(pp.amount) DESC;