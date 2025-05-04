USE soltura;
GO
--Casos en que bloqueara y por lo tanto no se deberia de usar:
--Durante toda la lectura del cursos va bloqueando cada linea que se va viendo entonces si se ocupa hacer updates en esas filas constantemente es mejor no usarlos
--En caso de updates, Puede generar que otros querys tarden mas haciendo sus operaciones al tener que esperar que el dato se desbloquee esto cuando se actualice algun dato 
--Por el UPDLOCK que convirte el update lock a exclusive lock que solo permite que el query del cursor lo cambie
--Si el volumen de datos es muy grande los cursores son lentos y van consumiendo muchaa memoria

--Casos que se podrian usar:
--Si no hay nadie que ocupe de manera concurrente esas filas y sabes que no hara que tarden mas
--Si es poca las filas que hay que pasar por el cursor

--EJEMPLO DE USO (en caso de que se podria usar):
ALTER TABLE solturadb.soltura_users ADD tipo_usuario INT;
GO
BEGIN
	DECLARE @userid INT;
	DECLARE @birthday DATE;
	DECLARE @mes INT;

	DECLARE cursor_usuarios CURSOR SCROLL_LOCKS FOR
	SELECT userid, birthday
	FROM solturadb.soltura_users WITH (ROWLOCK, UPDLOCK);

	OPEN cursor_usuarios;
	FETCH NEXT FROM cursor_usuarios INTO @userid, @birthday;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @mes = MONTH(@birthday);

		IF @mes = 1
			UPDATE solturadb.soltura_users SET tipo_usuario = 1 WHERE userid = @userid;
		ELSE IF @mes = 7
			UPDATE solturadb.soltura_users SET tipo_usuario = 2 WHERE userid = @userid;
		ELSE
			UPDATE solturadb.soltura_users SET tipo_usuario = 0 WHERE userid = @userid;

		FETCH NEXT FROM cursor_usuarios INTO @userid, @birthday;
	END

	CLOSE cursor_usuarios;
	DEALLOCATE cursor_usuarios;
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN tipo_usuario;
GO
SELECT * FROM solturadb.soltura_users;






--Es mas facil simplemente recorrer los usuarios y ver si cumple en cierto mes dado entonces se le pondra un valor entero y esto no se podria hacer con un simple update
--Y el bloqueo servira para evitar errores si alguien cambia el mes de nacimiento.

--En este caso pondremos 1 en mayor de doce si es mayor de 12, pero si no se pone 0, notese que esto se haria simple con un update con condiciones pero en vez de eso
--Recorremos toda la lista de manera ineficiente y generando bloqueos a la demas gente
USE soltura;
GO
ALTER TABLE solturadb.soltura_users ADD mayorde12 BIT;
GO
BEGIN
	UPDATE solturadb.soltura_users SET mayorde12 = 0;
	DECLARE @userid INT;
	DECLARE @birthday DATE;

	-- Crear cursor con bloqueos de filas
	DECLARE soltura_users_cursor CURSOR SCROLL_LOCKS FOR
	SELECT userid, birthday
	FROM solturadb.soltura_users WITH (ROWLOCK, UPDLOCK);

	OPEN soltura_users_cursor; --ABRIMOS EL CURSOR

	FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;
	WHILE @@FETCH_STATUS = 0 --Va fila por fila
	BEGIN
		-- Verificar si el usuario tiene mas de 12 años y si es asi les pone 1
		IF DATEDIFF(DAY, @birthday, GETDATE()) >= 12 * 365.25
		BEGIN
			UPDATE solturadb.soltura_users
			SET mayorde12 = 1
			WHERE userid = @userid;
		END
		WAITFOR DELAY '00:00:01';
		FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;
	END
	CLOSE soltura_users_cursor; --CERRAMOS EL CURSOR
	DEALLOCATE soltura_users_cursor; --Libera toda la memoria asociada al cursor
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN mayorde12;
GO
--Este seria el codigo optimizado y eficiente demostrando que en este caso no era necesario un cursor y mas bien no solo relentiza esta operaciones si no las demas tambien
ALTER TABLE solturadb.soltura_users ADD mayorde12 BIT;
GO
BEGIN
	UPDATE solturadb.soltura_users
	SET mayorde12 = 1
	WHERE DATEDIFF(DAY, birthday, GETDATE()) >= 12 * 365.25;
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN mayorde12;
GO






-- CASO SIN SCROLL LOCKS HACIENDO QUE NO SE BLOQUEE Y SE PUEDA ACCEDER A LA INFO DESDE EL OTRO QUERY
ALTER TABLE solturadb.soltura_users ADD mayorde12 BIT;
GO

BEGIN
	UPDATE solturadb.soltura_users SET mayorde12 = 0;

	DECLARE @userid INT;
	DECLARE @birthday DATE;

	DECLARE soltura_users_cursor CURSOR FOR
	SELECT userid, birthday
	FROM solturadb.soltura_users;

	OPEN soltura_users_cursor;

	FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF DATEDIFF(DAY, @birthday, GETDATE()) >= 12 * 365.25
		BEGIN
			UPDATE solturadb.soltura_users
			SET mayorde12 = 1
			WHERE userid = @userid;
		END
		WAITFOR DELAY '00:00:01';
		FETCH NEXT FROM soltura_users_cursor INTO @userid, @birthday;
	END

	CLOSE soltura_users_cursor;
	DEALLOCATE soltura_users_cursor;
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN mayorde12;
GO
--Este seria el codigo optimizado y eficiente demostrando que en este caso no era necesario un cursor y mas bien no solo relentiza esta operaciones si no las demas tambien
ALTER TABLE solturadb.soltura_users ADD mayorde12 BIT;
GO
BEGIN
	UPDATE solturadb.soltura_users
	SET mayorde12 = 1
	WHERE DATEDIFF(DAY, birthday, GETDATE()) >= 12 * 365.25;
END
SELECT * FROM solturadb.soltura_users;
ALTER TABLE solturadb.soltura_users DROP COLUMN mayorde12;
GO
