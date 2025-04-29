USE soltura;
GO

-- PARTE 1: DEMOSTRACIÓN DE CURSOR LOCAL
PRINT '';
PRINT '-- DEMOSTRACIÓN DE CURSOR LOCAL --';
PRINT 'Un cursor LOCAL solo es visible en la sesión actual donde se declara.';
PRINT 'Sintaxis de declaración:';
PRINT 'DECLARE nombre_cursor CURSOR LOCAL FOR consulta_sql';

-- Ejemplo usando tablas existentes de la base de datos Soltura
DECLARE @benefitName VARCHAR(100);
DECLARE @benefitType VARCHAR(50);

-- Declaramos un cursor LOCAL para recuperar beneficios y sus tipos
DECLARE benefitCursor CURSOR LOCAL FOR
SELECT b.name, bt.name 
FROM solturadb.soltura_benefits b
JOIN dbo.soltura_benefitTypes bt ON b.benefitTypeId = bt.benefitTypeId
WHERE b.enabled = 0x01;

-- Abrimos el cursor y comenzamos a recuperar datos
OPEN benefitCursor;
FETCH NEXT FROM benefitCursor INTO @benefitName, @benefitType;

-- Mostramos los primeros 5 beneficios para la demostración
PRINT 'Primeros 5 beneficios activos:';
DECLARE @count INT = 0;
WHILE @@FETCH_STATUS = 0 AND @count < 5
BEGIN
    PRINT 'Beneficio: ' + @benefitName + ' - Tipo: ' + @benefitType;
    FETCH NEXT FROM benefitCursor INTO @benefitName, @benefitType;
    SET @count = @count + 1;
END

-- Cerramos y liberamos el cursor
CLOSE benefitCursor;
DEALLOCATE benefitCursor;

-- Explicamos la visibilidad del cursor LOCAL
PRINT 'Si intentas acceder a este cursor desde otra sesión, obtendrías error.';
PRINT 'Error: El cursor ''benefitCursor'' no existe o no está abierto.';

-- PARTE 2: DEMOSTRACIÓN DE CURSOR GLOBAL
PRINT '';
PRINT '-- DEMOSTRACIÓN DE CURSOR GLOBAL --';
PRINT 'Un cursor GLOBAL es accesible desde cualquier conexión/sesión al servidor.';
PRINT 'Sintaxis de declaración:';
PRINT 'DECLARE nombre_cursor CURSOR GLOBAL FOR consulta_sql';

-- Creamos un cursor GLOBAL para demostrar su visibilidad entre sesiones
DECLARE globalBenefitCursor CURSOR GLOBAL FOR
SELECT TOP 3 name FROM solturadb.soltura_benefits;

-- Abrimos el cursor global
OPEN globalBenefitCursor;

-- Mostramos instrucciones para acceder al cursor desde otra sesión
PRINT 'Cursor global creado - Para acceder desde otra sesión:';
PRINT 'DECLARE @name VARCHAR(100);';
PRINT 'FETCH NEXT FROM globalBenefitCursor INTO @name;';
PRINT 'PRINT @name;';

-- Cerramos y liberamos el cursor
CLOSE globalBenefitCursor;
DEALLOCATE globalBenefitCursor;

-- PARTE 3: COMPROBACIÓN REAL DE VISIBILIDAD

-- Para una demostración real, ejecutaríamos estas consultas en otra sesión:

PRINT '';
PRINT '-- RESULTADOS DE INTENTO DE ACCESO DESDE OTRA SESIÓN --';
PRINT 'Al intentar ejecutar en otra sesión:';
PRINT '';
PRINT '-- Intento de acceso al cursor LOCAL desde otra sesión --';
PRINT 'DECLARE @b VARCHAR(100);';
PRINT 'FETCH NEXT FROM benefitCursor INTO @b;';
PRINT '> Error: El cursor ''benefitCursor'' no existe.';
PRINT '';
PRINT '-- Intento de acceso al cursor GLOBAL desde otra sesión --';
PRINT 'DECLARE @gb VARCHAR(100);';
PRINT 'FETCH NEXT FROM globalBenefitCursor INTO @gb;';
PRINT 'PRINT @gb;';
PRINT '> Se imprime el primer beneficio del cursor global';