--EJECUTAR (D) REPEATABLE READ
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Lee precios actuales pero esto los bloqueara para el otro query generando esos bloqueos prolongados
WAITFOR DELAY '00:00:10';
COMMIT;