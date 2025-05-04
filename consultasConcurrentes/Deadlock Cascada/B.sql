USE soltura;
GO
--Transaccion B
BEGIN TRANSACTION;
-- Bloquea redemptions. que lo ocupa C
UPDATE solturadb.soltura_redemptions SET reference1 = 88888 WHERE userid = 1;

-- Da tiempo para que la otra bloque benefits
WAITFOR DELAY '00:00:08';

-- Ocupa benefits para acabar pero benefits esta bloqueada por que A que ocupa users y C ocupa redemptions y B ocupa benefits y sigue el ciclo
UPDATE solturadb.soltura_benefits SET enabled = 1 WHERE benefitsid = 1;
COMMIT;