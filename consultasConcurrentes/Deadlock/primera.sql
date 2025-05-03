--Transaccion Primera
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0 WHERE benefitsid = 1; -- Bloquea benefits hasta que se haga el commit

WAITFOR DELAY '00:00:05';

-- Ocupa redemptions para acabar pero redemptions esta bloqueada por una que ocupa benefits lo que implica que nunca podra salir
UPDATE solturadb.soltura_redemptions SET reference1 = 99999 WHERE userid = 1;

COMMIT;