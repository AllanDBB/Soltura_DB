/*
Crear una consulta con al menos 3 JOINs que analice información donde podría ser importante obtener un SET DIFFERENCE y un INTERSECTION

*/



WITH UsuariosConPlanes AS (
    SELECT DISTINCT u.userid
    FROM solturadb.soltura_users u
    JOIN solturadb.soltura_planperson_users ppu ON u.userid = ppu.userid
    JOIN solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
    JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
),


UsuariosConRedenciones AS (
    SELECT DISTINCT u.userid
    FROM solturadb.soltura_users u
    JOIN solturadb.soltura_redemptions r ON u.userid = r.userid
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
),

-- Intersección: Usuarios con planes Y redenciones, acá usamos el INTERSECT
Interseccion AS (
    SELECT userid FROM UsuariosConPlanes
    INTERSECT
    SELECT userid FROM UsuariosConRedenciones
),

-- Para las diferencias note que en SQL no se usa SET DIFFERENCE, sino EXCEPT pero cumple el mismo propósito

-- Diferencia 1: Usuarios con planes PERO SIN redenciones
PlanesSinRedenciones AS (
    SELECT userid FROM UsuariosConPlanes
    EXCEPT
    SELECT userid FROM UsuariosConRedenciones
),

-- Diferencia 2: Usuarios con redenciones PERO SIN planes 
RedencionesSinPlanes AS (
    SELECT userid FROM UsuariosConRedenciones
    EXCEPT
    SELECT userid FROM UsuariosConPlanes
)

-- Agrupamos para que la consulta se vea más linda
SELECT 
    'INTERSECTION: Usuarios con planes Y redenciones' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM Interseccion

UNION ALL

SELECT 
    'SET DIFFERENCE: Usuarios con planes PERO SIN redenciones' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM PlanesSinRedenciones

UNION ALL

SELECT 
    'SET DIFFERENCE: Usuarios con redenciones PERO SIN planes' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM RedencionesSinPlanes;