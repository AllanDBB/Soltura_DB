ALTER TABLE solturadb.soltura_users ADD mayorde12 BIT;
GO

BEGIN
	UPDATE solturadb.soltura_users SET mayorde12 = 0;

	-- Declarar variables para el cursor
	DECLARE @userid INT;
	DECLARE @birthday DATE;

	-- Crear cursor con bloqueo de fila para actualización
	DECLARE soltura_users_cursor CURSOR SCROLL_LOCKS FOR
	SELECT userid, birthday
	FROM solturadb.soltura_users WITH (ROWLOCK, UPDLOCK);

	-- Abrir el cursor
	OPEN soltura_users_cursor;

	-- Obtener el primer registro
	FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;

	-- Iterar sobre los registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Verificar si el usuario tiene más de 12 años (cálculo más preciso)
		IF DATEDIFF(DAY, @birthday, GETDATE()) >= 12 * 365.25
		BEGIN
			UPDATE solturadb.soltura_users
			SET mayorde12 = 1
			WHERE userid = @userid;
		END

		FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;
	END

	-- Cerrar y liberar el cursor
	CLOSE soltura_users_cursor;
	DEALLOCATE soltura_users_cursor;
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN mayorde12;
GO