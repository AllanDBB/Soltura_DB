---------------------------------------------------------------------------------------------------------------------------------------
--REPEATABLE READ: TIENE PROBLEMAS DE LECTURAS FANTASMAS
--EJECUTAR DE SEGUNDO
--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;