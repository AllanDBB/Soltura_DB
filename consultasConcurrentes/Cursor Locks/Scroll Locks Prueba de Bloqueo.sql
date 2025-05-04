USE soltura;
GO
UPDATE solturadb.soltura_users
SET birthday = DATEADD(MONTH, -1, birthday);