-- TOP para mostrar top 5 planes más populares
SELECT TOP 5 
    s.description AS 'Plan',
    COUNT(ppu.userid) AS 'Número de Usuarios'
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid
JOIN solturadb.soltura_planperson_users ppu ON p.planpersonid = ppu.planpersonid
GROUP BY s.description
ORDER BY COUNT(ppu.userid) DESC;