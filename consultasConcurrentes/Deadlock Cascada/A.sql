--Transaccion A
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0 WHERE benefitsid = 1; -- Bloquea benefits hasta que se haga el commit, lo que ocupa B

WAITFOR DELAY '00:00:08';

-- Se bloquea al A ocupar users que esta siendo usado por C y C ocupa lo que esta usando B y B ocupa lo que esta usando A
UPDATE solturadb.soltura_users SET email = 'deadlocklover@gmail.com' WHERE userid = 1;
COMMIT;
