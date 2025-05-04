USE soltura;
GO
--Transaccion C
BEGIN TRANSACTION;
UPDATE solturadb.soltura_users SET email = 'deadlockhater@gmail.com' WHERE userid = 1; -- Bloquea user hasta que se haga el commit. Que lo ocupa A

WAITFOR DELAY '00:00:08';

-- Se bloquea al C ocupar redemptions que esta siendo usado por B y B ocupa lo que esta usando A y A ocupa lo que esta usando C
UPDATE solturadb.soltura_redemptions SET reference1 = 99999 WHERE userid = 1;
COMMIT;