--Tiene que ejecutarse primero el query A para que den los resultados dados claramente si no se ejectutan no dara dirty read por eso se tiene que hacer uno por uno
--Mediante la parte A y B.

--EJECUTAR (A) READ UNCOMMITTED
--READ UNCOMMITED ERROR READ DIRTY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --Cambiamos a 0x01 el bit en la otra transaccion entonces este lo llega a leer pero como nunca hace commit lo que leyo la transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
COMMIT;
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

--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT COUNT(*) AS EnabledBenefits FROM solturadb.soltura_benefits WHERE enabled = 0x01;--Contar los beneficios habilitados "N" porque despues se añadira otro generando un fantasma
WAITFOR DELAY '00:00:10';--Simular un retraso para permitir que otra transaccion inserte datos
SELECT COUNT(*) AS EnabledBenefits FROM solturadb.soltura_benefits WHERE enabled = 0x01;--Contar los beneficios habilitados "N" ahora paso a "N+1"
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (D) REPEATABLE READ
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Lee precios actuales pero esto los bloqueara para el otro query generando esos bloqueos prolongados
WAITFOR DELAY '00:00:10';
COMMIT;