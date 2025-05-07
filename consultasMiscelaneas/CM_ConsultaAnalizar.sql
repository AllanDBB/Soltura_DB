/*
Imagine una cosulta que el sistema va a necesitar para mostrar cierta información, o reporte o pantalla, y que esa consulta vaya a requerir:
4 JOINs entre tablas.
2 funciones agregadas (ej. SUM, AVG).
3 subconsultas or 3 CTEs
Un CASE, CONVERT, ORDER BY, HAVING, una función escalar, y operadores como IN, NOT IN, EXISTS.
Escriba dicha consulta y ejecutela con el query analizer, utilizando el analizador de pesos y costos del plan de ejecución, reacomode la consulta para que sea más eficiente sin necesidad de agregar nuevos índices.

*/

--OG
use soltura
go 
WITH BeneficiosPopulares AS (
   
    SELECT 
        b.benefitsid,
        b.name,
        COUNT(r.redemptionid) AS redemption_count
    FROM solturadb.soltura_benefits b
    JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    WHERE EXISTS (
        SELECT 1 FROM solturadb.soltura_planperson pp 
        WHERE pp.planpersonid = b.planpersonid
    )
    GROUP BY b.benefitsid, b.name
    HAVING COUNT(r.redemptionid) > 0
),

PlanesConUsuarios AS (
   
    SELECT 
        pp.planpricesid,
        COUNT(DISTINCT ppu.userid) AS user_count
    FROM solturadb.soltura_planperson pp
    JOIN solturadb.soltura_planperson_users ppu ON pp.planpersonid = ppu.planpersonid
    WHERE pp.planpricesid NOT IN (
        SELECT planpricesid 
        FROM solturadb.soltura_planprices 
        WHERE amount <= 0
    )
    GROUP BY pp.planpricesid
),

RedencionesPorPlan AS (
   
    SELECT 
        pp.planpricesid,
        COUNT(r.redemptionid) AS redemption_count,
        CONVERT(VARCHAR(10), MAX(r.date), 120) AS last_redemption_date
    FROM solturadb.soltura_redemptions r
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
    GROUP BY pp.planpricesid
)

SELECT 
    s.subscriptionid,
    s.description AS plan_name,
    
    AVG(pp.amount) AS average_price,
    SUM(CASE 
        WHEN pc.user_count > 100 THEN 1 
        ELSE 0 
    END) AS popular_plans_count,
    
    CONVERT(VARCHAR(10), 
        CASE 
            WHEN AVG(pp.amount) < 20 THEN 'Económico'
            WHEN AVG(pp.amount) BETWEEN 20 AND 50 THEN 'Estándar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bp.name AS most_popular_benefit,
    rp.last_redemption_date
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN PlanesConUsuarios pc ON pp.planpricesid = pc.planpricesid
LEFT JOIN RedencionesPorPlan rp ON pp.planpricesid = rp.planpricesid
LEFT JOIN (
    SELECT TOP 1 b.* 
    FROM BeneficiosPopulares b
    ORDER BY b.redemption_count DESC
) bp ON 1=1 
WHERE pc.user_count > 0
GROUP BY 
    s.subscriptionid,
    s.description,
    bp.name,
    rp.last_redemption_date,
    pc.user_count
HAVING AVG(pp.amount) > 0 
ORDER BY 
    price_category DESC,
    average_price DESC;



-- OPTIMIZADA
WITH BeneficiosPopulares AS (
    SELECT 
        b.benefitsid,
        b.name,
        COUNT(r.redemptionid) AS redemption_count
    FROM solturadb.soltura_benefits b
    JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    WHERE EXISTS (
        SELECT 1 FROM solturadb.soltura_planperson pp 
        WHERE pp.planpersonid = b.planpersonid
    )
    GROUP BY b.benefitsid, b.name
    HAVING COUNT(r.redemptionid) > 0
),

PlanesConUsuarios AS (
    SELECT 
        pp.planpricesid, 
        COUNT(DISTINCT ppu.userid) AS user_count
    FROM solturadb.soltura_planperson pp
    JOIN solturadb.soltura_planperson_users ppu ON pp.planpersonid = ppu.planpersonid
    WHERE pp.planpricesid NOT IN (
        SELECT planpricesid 
        FROM solturadb.soltura_planprices 
        WHERE amount <= 0
    )
    GROUP BY pp.planpricesid
),

RedencionesPorPlan AS (
    SELECT 
        pp.planpricesid,  

        COUNT(r.redemptionid) AS redemption_count,
        CONVERT(VARCHAR(10), MAX(r.date), 120) AS last_redemption_date
    FROM solturadb.soltura_redemptions r
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
    GROUP BY pp.planpricesid
)

SELECT 
    s.subscriptionid,
    s.description AS plan_name,
    AVG(pp.amount) AS average_price,
    SUM(CASE 
        WHEN pc.user_count > 100 THEN 1 
        ELSE 0 
    END) AS popular_plans_count,
    CONVERT(VARCHAR(10), 
        CASE 
            WHEN AVG(pp.amount) < 20 THEN 'Económico'
            WHEN AVG(pp.amount) BETWEEN 20 AND 50 THEN 'Estándar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bp.name AS most_popular_benefit,
    rp.last_redemption_date
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN PlanesConUsuarios pc ON pp.planpricesid = pc.planpricesid
LEFT JOIN RedencionesPorPlan rp ON pp.planpricesid = rp.planpricesid
LEFT JOIN (
    SELECT TOP 1 b.* 
    FROM BeneficiosPopulares b
    ORDER BY b.redemption_count DESC
) bp ON 1=1 
WHERE pc.user_count > 0
GROUP BY 
    s.subscriptionid,
    s.description,
    bp.name,
    rp.last_redemption_date,
    pc.user_count
HAVING AVG(pp.amount) > 0 
ORDER BY 
    price_category DESC,
    average_price DESC;

