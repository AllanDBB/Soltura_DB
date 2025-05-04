--EJECUTAR DE PRIMERO
--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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