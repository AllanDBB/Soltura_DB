GO
USE soltura; 
GO

CREATE OR ALTER PROCEDURE insertusers_soltura
AS
BEGIN
    DECLARE @i INT = 0;
    DECLARE @num_users INT = 30;
    DECLARE @nombreusado NVARCHAR(50);
    DECLARE @apellidousado NVARCHAR(50);
    DECLARE @birthday DATE;
    CREATE TABLE #nombres (nombre NVARCHAR(50));
    CREATE TABLE #apellidos (apellido NVARCHAR(50));

    INSERT INTO #nombres (nombre) VALUES
        ('Isaac'),('Allan'),('Daniel'),('Natalia'),('Rodrigo'),('David'),('Pedro'),('Brendan'),('Daniela'),('Ramona'),('Juan'),('María'),('Ana'),('José'),('Roberto'),('Miguel'),
        ('Arturo'),('Rodrigo'),('Kevin'),('Gon'),('Samuel'),('Jimena'),('Fernanda'),('Maria'),('Viviana'),('Sofia'),('Lucia'),('Martina'),('Pabla'),('Gilbert'),
        ('Christopher'),('Adriana'),('Anthony'),('Walter'),('Bruce'),('Kim'),('Carmela'),('Jessie'),('Matt'),('Julio'),('Skibidi'),('DonPollo'),
        ('Jane'),('Gregory'),('Eric'),('Chase'),('Cameron'),('Scott'),('Victor'),('Li Wei'),('Zhang Mei'),('Chen Hao'),
		('João'),('Thiago'),('Luana'),('Juliana'),('Vinícius'),('Priscila'),('Larissa'),('Sofia');

    INSERT INTO #apellidos (apellido) VALUES
        ('Villalobos'),('López'),('González'),('Pérez'),('Rodríguez'),('Pines'),('Hernández'),('Martínez'),('Sánchez'),
        ('Ramírez'),('Fernández'),('Cheng'),('Johnson'),('Bonilla'),('Castillo'),('Moltisanti'),('La_Cerva'),('Corrales'),
        ('Soprano'),('White'),('Wayne'),('Gualtieri'),('Freecss'),('Pinkman'),('Flowers'),('Murdock'),('House'),('Foreman'),('Jones'),('Smith'),('Taylor'),('Cooper'),
		('Lee'),('Pilgrim'),('Carter'),('Kennedy'),('Li'),('Zhang'),('Chen'),
		('Silva'),('Oliveira'),('Santos'),('Souza'),('Pereira'),('Costa'),('Rodrigues'),('Alves'),('Lima');

    WHILE @i < @num_users
    BEGIN
        SELECT @nombreusado = nombre FROM #nombres ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
        SELECT @apellidousado = apellido FROM #apellidos ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
        
        SET @birthday = DATEADD(DAY, -1 * FLOOR(RAND() * 365 * 55), DATEFROMPARTS(2007, 1, 1));

        INSERT INTO solturadb.soltura_users
        ([email], [firstname], [lastname], [birthday], [password], [companyid])
        VALUES (
            CONCAT(@nombreusado, '.', @apellidousado, FLOOR(RAND() * 2888), '@gmail.com'),
            @nombreusado,
            @apellidousado,
            @birthday,
            ENCRYPTBYPASSPHRASE('jK3+5wGgL7eA1TRUQUITOPARACONTRASEÑASxT9KzLdq4YfX8jNwB9V', 'ContraseñaSuperSecreta'),
            NULL
        );

        SET @i += 1;
    END

    DROP TABLE IF EXISTS #nombres;
    DROP TABLE IF EXISTS #apellidos;
END
GO

EXEC insertusers_soltura;
GO

SELECT * FROM solturadb.soltura_users;
GO

CREATE OR ALTER PROCEDURE insertcurrencies
AS
BEGIN
    INSERT INTO solturadb.soltura_currency (name, acronym, symbol)
    VALUES 
        ('United States Dollar', 'USD', ''),
        ('Euro', 'EUR', ''),
        ('British Pound', 'GBP', ''),
        ('Japanese Yen', 'JPY', ''),
        ('Swiss Franc', 'CHF', ''),
        ('Canadian Dollar', 'CAD', ''),
        ('Australian Dollar', 'AUD', ''),
        ('Indian Rupee', 'INR', ''),
        ('Chinese Yuan', 'CNY', ''),
        ('Brazilian Real', 'BRL', ''),
        ('Costa Rican Colon', 'CRC', ''),
        ('Russian Ruble', 'RUB', '');
END
GO

EXEC insertcurrencies;

SELECT * FROM solturadb.soltura_currency;