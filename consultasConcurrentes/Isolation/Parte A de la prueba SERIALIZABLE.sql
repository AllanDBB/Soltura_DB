--Tiene que ejecutarse primero el query A para que den los resultados dados claramente si no se ejectutan no dara dirty read por eso se tiene que hacer uno por uno
--Mediante la parte A y B.

---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (A) SERIALIZABLE
--SERIALIZABLE ERROR READ DIRTY NO LO TIENE
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x00 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) SERIALIZABLE
--SERIALIZABLE ERROR NONREPETABLE READ NO LO TIENE
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (C) SERIALIZABLE
--SERIALIZABLE ERROR LECTURAS FANTASMAS NO LO TIENE
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--SERIALIZABLE: Es el bloqueo excesivo que puede ocurrir en sistemas con alta concurrencia
--Este nivel de aislamiento bloquea las filas existenteslo que puede causar bloqueos prolongados y reducir el rendimiento.

--EJECUTAR (D) SERIALIZABLE
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
BEGIN TRANSACTION;
-- Intentar insertar un nuevo precio pero tardara un montoooooon al esperar ese bloqueo prolongado que trae Serializable
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;