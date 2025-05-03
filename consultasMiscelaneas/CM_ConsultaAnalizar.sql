/*
Imagine una cosulta que el sistema va a necesitar para mostrar cierta informaci�n, o reporte o pantalla, y que esa consulta vaya a requerir:
4 JOINs entre tablas.
2 funciones agregadas (ej. SUM, AVG).
3 subconsultas or 3 CTEs
Un CASE, CONVERT, ORDER BY, HAVING, una funci�n escalar, y operadores como IN, NOT IN, EXISTS.
Escriba dicha consulta y ejecutela con el query analizer, utilizando el analizador de pesos y costos del plan de ejecuci�n, reacomode la consulta para que sea m�s eficiente sin necesidad de agregar nuevos �ndices.

*/


--OG

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
            WHEN AVG(pp.amount) < 20 THEN 'Econ�mico'
            WHEN AVG(pp.amount) BETWEEN 20 AND 50 THEN 'Est�ndar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bp.name AS most_popular_benefit,
    rp.last_redemption_date,
    'PLAN-' + UPPER(LEFT(s.description, 3)) AS plan_code_short
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
WITH PlanesValidos AS (
    SELECT 
        planpricesid,
        subscriptionid,
        amount
    FROM solturadb.soltura_planprices
    WHERE amount > 0
),

BeneficioMasPopular AS (
    SELECT TOP 1
        b.benefitsid,
        b.name,
        b.planpersonid,
        COUNT(r.redemptionid) AS redemption_count
    FROM solturadb.soltura_benefits b
    JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
    GROUP BY b.benefitsid, b.name, b.planpersonid
    ORDER BY COUNT(r.redemptionid) DESC
),

AgregacionPlanes AS (
    SELECT
        pv.planpricesid,
        pv.subscriptionid,
        pv.amount,
        COUNT(DISTINCT ppu.userid) AS user_count,
        COUNT(DISTINCT r.redemptionid) AS redemption_count,
        MAX(r.date) AS last_redemption_date
    FROM PlanesValidos pv
    JOIN solturadb.soltura_planperson pp ON pv.planpricesid = pp.planpricesid
    LEFT JOIN solturadb.soltura_planperson_users ppu ON pp.planpersonid = ppu.planpersonid
    LEFT JOIN solturadb.soltura_benefits b ON pp.planpersonid = b.planpersonid
    LEFT JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    GROUP BY pv.planpricesid, pv.subscriptionid, pv.amount
    HAVING COUNT(DISTINCT ppu.userid) > 0
)

SELECT 
    s.subscriptionid,
    s.description AS plan_name,
    AVG(ap.amount) AS average_price,
    SUM(CASE WHEN ap.user_count > 100 THEN 1 ELSE 0 END) AS popular_plans_count,
    CONVERT(VARCHAR(10), 
        CASE 
            WHEN AVG(ap.amount) < 20 THEN 'Econ�mico'
            WHEN AVG(ap.amount) BETWEEN 20 AND 50 THEN 'Est�ndar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bmp.name AS most_popular_benefit,
    CONVERT(VARCHAR(10), MAX(ap.last_redemption_date), 120) AS last_redemption_date,
    'PLAN-' + UPPER(LEFT(s.description, 3)) AS plan_code_short
FROM solturadb.soltura_subscriptions s
JOIN AgregacionPlanes ap ON s.subscriptionid = ap.subscriptionid
CROSS JOIN BeneficioMasPopular bmp
GROUP BY 
    s.subscriptionid,
    s.description,
    bmp.name,
    ap.user_count
ORDER BY 
    price_category DESC,
    average_price DESC;


-- Excecution plan en los botones superiores de la toolbar y ver stats espec�ficas con el profiler :p