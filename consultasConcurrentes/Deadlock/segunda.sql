--Transaccion Segunda
BEGIN TRANSACTION;
-- Bloquea redemptions.
UPDATE solturadb.soltura_redemptions SET reference1 = 88888 WHERE userid = 1;

-- Da tiempo para que la otra bloque benefits
WAITFOR DELAY '00:00:05';

-- Ocupa benefits para acabar pero benefits esta bloqueada por una que ocupa redemptions lo que implica que nunca podra salir
UPDATE solturadb.soltura_benefits SET enabled = 1 WHERE benefitsid = 1;
COMMIT;