--SERIALIZABLE: Es el bloqueo excesivo que puede ocurrir en sistemas con alta concurrencia
--Este nivel de aislamiento bloquea las filas existenteslo que puede causar bloqueos prolongados y reducir el rendimiento.

--EJECUTAR (D) SERIALIZABLE
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
BEGIN TRANSACTION;
-- Intentar insertar un nuevo precio pero tardara un montoooooon al esperar ese bloqueo prolongado que trae Serializable
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;