--Tiene que ejecutarse primero el query A para que den los resultados dados claramente si no se ejectutan no dara dirty read por eso se tiene que hacer uno por uno
--Mediante la parte A y B.

---------------------------------------------------------------------------------------------------------------------------------------
--READ UNCOMMITTED: TIENE PROBLEMAS DE LECTURAS SUCIAS, NONREPETABLE READ Y LECTURAS FANTASMAS

--EJECUTAR (A) READ UNCOMMITTED
--READ UNCOMMITED ERROR READ DIRTY
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x01 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--READ COMMITTED: TIENE PROBLEMAS DE NONREPETABLE READ Y LECTURAS FANTASMAS

--EJECUTAR (B) READ COMMITTED
--READ COMMITED ERROR NONREPETABLE READ
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--REPEATABLE READ: TIENE PROBLEMAS DE LECTURAS FANTASMAS

--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_benefits (enabled, name, description, availableuntil, planpersonid, categorybenefitsid, contractDetailId)
VALUES (0x01, 'Nuevo Beneficio', 'Descripción del beneficio', '2025-12-31', 1, 1, 1); --Insertar nuevo valor para que el conte de beneficios activos pase de n a n+1 siendo una lectura fantasma
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