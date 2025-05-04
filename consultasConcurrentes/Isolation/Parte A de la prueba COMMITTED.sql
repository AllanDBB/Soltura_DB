---------------------------------------------------------------------------------------------------------------------------------------
--READ COMMITTED: TIENE PROBLEMAS DE NONREPETABLE READ Y LECTURAS FANTASMAS

--EJECUTAR (B) READ COMMITTED
--READ COMMITED ERROR NONREPETABLE READ
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--READ COMMITED: TIENE PROBLEMAS DE LECTURAS FANTASMAS
--EJECUTAR SEGUNDO ESTA
--EJECUTAR (C) READ COMMITED 
--READ COMMITED  ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;