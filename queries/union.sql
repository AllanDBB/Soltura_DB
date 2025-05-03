-- UNION entre planes individuales y empresariales
SELECT 
    'Individual' AS TipoPlan, --Claramente vamos a ponerle a todos los que cumplan esto individual pues no tienen mas de 1 cuenta
    s.description AS NombrePlan, --Se trae el subscriptions description para ponerlo como el nombre del plan
    pp.amount AS Precio, --Se trae el precio 
    c.acronym AS Moneda --Como se trajo la tabla de currencies puede sacar el acronym (simbolo)
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid -- si plan prices subscription id coincide con un subscription id (para traerse la info de la subs id)
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid --Aca obtiene la currencie asociada a el plan price
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid -- obtiene el precio que matchea el plan person 
WHERE p.maxaccounts = 1 --Aca obtenemos los planes individuales al no tener mas de una cuenta en un plan personal
UNION --Una los datos encontrados anteriormente con los que vamos a encontrar ahora
SELECT 
    'Empresarial' AS TipoPlan, --Claramente vamos a ponerle a todos los que cumplan esto empresarial pues tienen mas de 1 cuenta
    s.description AS NombrePlan,--Se trae el subscriptions description para ponerlo como el nombre del plan
    pp.amount AS Precio, --Se trae el precio 
    c.acronym AS Moneda--Como se trajo la tabla de currencies puede sacar el acronym (simbolo)
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid-- si plan prices subscription id coincide con un subscription id (para traerse la info de la subs id)
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid--Aca obtiene la currencie asociada a el plan price
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid-- obtiene el precio que matchea el plan person 
WHERE p.maxaccounts > 1 --Se le va a traer SIEMPRE Y CUANDO SE CUMPLA que tenga varias cuentas asociadas no solo 1
ORDER BY TipoPlan, Precio; --Ordenara todo por el tipo del plan y de precio menor a mayor