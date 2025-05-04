---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) READ COMMITTED
--READ COMMITED ERROR NONREPETABLE READ
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
-- Primera lectura: Calcular el promedio de los precios
SELECT AVG(amount) AS ValorPromedioAntes FROM solturadb.soltura_planprices; --Calcula el promedio por primera vez
WAITFOR DELAY '00:00:10'; --Retraso para poder hacer el cambio
SELECT AVG(amount) AS ValorPromedioDespues FROM solturadb.soltura_planprices; --Cambio el valor del promedio del costo al ver que aumento aunque no deberia de generar ese read diferente
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR PRIMERO ESTA
--EJECUTAR (C) READ COMMITED 
--READ COMMITED ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
DECLARE @TotalUsers INT;
SELECT @TotalUsers = COUNT(DISTINCT planpricesid) FROM solturadb.soltura_planprices;

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount) / @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Las ganancias antes del insert / numeros de usuarios dara un promedio verdadero en este momento

WAITFOR DELAY '00:00:10';

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount)/ @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Ahora que se hizo el insert el promedio dara mas que el verdadero al tener un usuario no contado

COMMIT;