/*
Escribir un SELECT que use CASE para crear una columna calculada que agrupe dinámicamente datos (por ejemplo, agrupar cantidades de usuarios por plan en rangos de monto, no use este ejemplo).

*/


-- Agrupa según el tipo de plan, cuántos hay de cada uno y su tipo (individuales, grupo pequeño o grande)
SELECT 
    s.description AS [Plan],
    COUNT(DISTINCT pp.planpersonid) AS TotalPlanes,
    CASE 
        WHEN pp.maxaccounts = 1 THEN 'Individual'
        WHEN pp.maxaccounts BETWEEN 2 AND 4 THEN 'Grupo pequeño'
        WHEN pp.maxaccounts > 4 THEN 'Grupo grande'
        ELSE 'Sin Clasificar'
    END AS TipoPlan
FROM 
    solturadb.soltura_planperson pp
JOIN 
    solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
JOIN 
    solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
GROUP BY 
    s.description,
    CASE 
        WHEN pp.maxaccounts = 1 THEN 'Individual'
        WHEN pp.maxaccounts BETWEEN 2 AND 4 THEN 'Grupo pequeño'
        WHEN pp.maxaccounts > 4 THEN 'Grupo grande'
        ELSE 'Sin Clasificar'
    END
ORDER BY 
    TipoPlan, [Plan];


/* alt: 

WITH PlanData AS (
    SELECT 
        s.description AS [Plan],
        pp.planpersonid,
        CASE 
            WHEN pp.maxaccounts = 1 THEN 'Individual'
            WHEN pp.maxaccounts BETWEEN 2 AND 4 THEN 'Familiar'
            WHEN pp.maxaccounts > 4 THEN 'Corporativo'
            ELSE 'Sin Clasificar'
        END AS TipoPlan
    FROM 
        solturadb.soltura_planperson pp
    JOIN 
        solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
    JOIN 
        solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
)
SELECT 
    [Plan],
    COUNT(DISTINCT planpersonid) AS TotalPlanes,
    TipoPlan
FROM 
    PlanData
GROUP BY 
    [Plan], TipoPlan
ORDER BY 
    TipoPlan, [Plan];

*/