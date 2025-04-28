# Soltura_DB

## ÍNDICE
1. [Integrantes](#integrantes)
2. [Documentación para el diseño](#documentación-para-el-diseño)
3. [Población de datos](#población-de-datos)
4. [Demostraciones T-SQL](#demostraciones-t-sql)
5. [Mantenimiento de la seguridad](#mantenimiento-de-la-seguridad)
6. [Consultas misceláneas](#consultas-misceláneas)
7. [Concurrencia](#concurrencia)
8. [Soltura ft. PaymentAssistant](#soltura-ft-paymentassistant)

---
# Integrantes:
- **Daniel Arce Campos** - Carnet: 2024174489
- **Allan David Bolaños Barrientos** - Carnet: !!!
- **Natalia Orozco Delgado** - Carnet: 2024099161
- **Isaac Villalobos Apellido2** - Carnet: !!!!
---

# Documentación para el diseño

---
# Población de datos
Script de llenado de base de datos cumpliendo los requerimientos de monedas, usuarios, suscripciones, catálogos base del sistema, empresas proveedoras de servicios y los planes de servicios.

```sql

USE soltura;
GO

-- Limpieza de las tablas en orden para evitar conflictos
DELETE FROM solturadb.soltura_redemptions;
DELETE FROM solturadb.soltura_planperson_users;
DELETE FROM solturadb.soltura_benefits;
DELETE FROM solturadb.soltura_planperson;
DELETE FROM solturadb.soltura_planprices;
DELETE FROM solturadb.soltura_contractDetails;
DELETE FROM solturadb.soltura_contracts;
DELETE FROM solturadb.soltura_companiesContactinfo;
DELETE FROM solturadb.soltura_associatedCompanies;
DELETE FROM solturadb.soltura_schedules;
DELETE FROM solturadb.soltura_categorybenefits;
DELETE FROM solturadb.soltura_redemptionMethods;
DELETE FROM solturadb.soltura_companyinfotypes;
DELETE FROM solturadb.soltura_subscriptions;
DELETE FROM dbo.soltura_benefitSubTypes;
DELETE FROM dbo.soltura_benefitTypes;

-- Resetear los contadores autoincrementables
DBCC CHECKIDENT ('solturadb.soltura_redemptions', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_benefits', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_planperson', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_planprices', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_contractDetails', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_contracts', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_companiesContactinfo', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_associatedCompanies', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_schedules', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_categorybenefits', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_redemptionMethods', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_companyinfotypes', RESEED, 0);
DBCC CHECKIDENT ('solturadb.soltura_subscriptions', RESEED, 0);

-- 1. Creación de monedas
IF NOT EXISTS(SELECT 1 FROM solturadb.soltura_currency WHERE name = 'United States Dollar')
BEGIN
    INSERT INTO solturadb.soltura_currency (name, acronym, symbol)
    VALUES 
        ('United States Dollar', 'USD', '$'),
        ('Costa Rican Colon', 'CRC', '₡'),
        ('Euro', 'EUR', '€'),
        ('Mexican Peso', 'MXN', '$'),
        ('Canadian Dollar', 'CAD', '$');
END

-- 2. Creación de tipos y subtipos de beneficios
INSERT INTO dbo.soltura_benefitTypes (benefitTypeId, name) VALUES 
    (1, 'Membresía Completa'),
    (2, 'Acceso Limitado'),
    (3, 'Descuento'),
    (4, 'Gratuidad'),
    (5, 'Consulta Individual'),
    (6, 'Servicio Premium');

INSERT INTO dbo.soltura_benefitSubTypes (benefitSubTypeId, name) VALUES
    (1, 'Mensual'),
    (2, 'Trimestral'),
    (3, 'Semestral'),
    (4, 'Anual'),
    (5, 'Por Visita'),
    (6, 'Por Hora'),
    (7, 'Porcentaje'),
    (8, 'Monto Fijo'),
    (9, 'Ilimitado');

-- 3. Creación de categorías de beneficios
INSERT INTO solturadb.soltura_categorybenefits (name, enabled) VALUES 
    ('Gimnasios', 0x01),
    ('Salud', 0x01),
    ('Educación', 0x01),
    ('Entretenimiento', 0x01),
    ('Gastronomía', 0x01),
    ('Transporte', 0x01),
    ('Hospedaje', 0x01),
    ('Coworking', 0x01);

-- 4. Creación de empresas proveedoras de servicios 
-- Inserción de direcciones
INSERT INTO solturadb.soltura_addresses (line1, line2, zipcode, cityid, geoposition)
VALUES 
    ('Avenida Central', 'Edificio Torre A', '10101', 1, geometry::STGeomFromText('POINT(-84.08 9.93)', 4326)),
    ('Calle 5', 'Torre Médica', '10102', 2, geometry::STGeomFromText('POINT(-84.15 9.92)', 4326)),
    ('Boulevard Los Yoses', 'Campus Principal', '10103', 1, geometry::STGeomFromText('POINT(-84.10 9.94)', 4326)),
    ('Avenida Escazú', 'Local 102', '10104', 2, geometry::STGeomFromText('POINT(-84.05 9.92)', 4326)),
    ('Paseo Colón', 'Plaza Gastro', '10105', 1, geometry::STGeomFromText('POINT(-84.07 9.93)', 4326)),
    ('Terminal Central', NULL, '10201', 3, geometry::STGeomFromText('POINT(-84.22 10.02)', 4326)),
    ('Zona de Negocios', 'Torre Profesional', '10301', 4, geometry::STGeomFromText('POINT(-84.33 10.09)', 4326));

-- Inserción de empresas asociadas
INSERT INTO solturadb.soltura_associatedCompanies (name, addressId) VALUES 
    ('FitLife Gym', 1),         
    ('MediPlus', 2),            
    ('EduTech Academy', 3),     
    ('CinePlex', 4),           
    ('GastroClub', 5),         
    ('MobilityPass', 6),        
    ('WorkHub', 7);             

-- 5. Tipos de información de contacto
INSERT INTO solturadb.soltura_companyinfotypes (name) VALUES
    ('Email'),
    ('Teléfono'),
    ('Sitio Web'),
    ('Horario');

-- 6. Información de contacto para empresas
-- Utilizando un procedimiento para generar información de contacto
DECLARE @company_count INT = 7;
DECLARE @i INT = 1;
DECLARE @email_domains TABLE (domain VARCHAR(50));
INSERT INTO @email_domains VALUES ('gmail.com'),('outlook.com'),('yahoo.com'),('company.com'),('business.com');

WHILE @i <= @company_count
BEGIN
    DECLARE @domain VARCHAR(50);
    SELECT TOP 1 @domain = domain FROM @email_domains ORDER BY NEWID();
    
    -- Email
    INSERT INTO solturadb.soltura_companiesContactinfo (value, enabled, lastupdate, companyinfotypeId, associatedCompaniesid)
    VALUES ('info@company' + CAST(@i AS VARCHAR) + '.' + @domain, 0x01, GETDATE(), 1, @i);
    
    -- Teléfono
    INSERT INTO solturadb.soltura_companiesContactinfo (value, enabled, lastupdate, companyinfotypeId, associatedCompaniesid)
    VALUES ('+506 2222-' + RIGHT('000' + CAST(1000 + @i * 111 AS VARCHAR), 4), 0x01, GETDATE(), 2, @i);
    
    -- Sitio web
    INSERT INTO solturadb.soltura_companiesContactinfo (value, enabled, lastupdate, companyinfotypeId, associatedCompaniesid)
    VALUES ('www.company' + CAST(@i AS VARCHAR) + '.com', 0x01, GETDATE(), 3, @i);
    
    -- Horario
    INSERT INTO solturadb.soltura_companiesContactinfo (value, enabled, lastupdate, companyinfotypeId, associatedCompaniesid)
    VALUES ('Lun-Vie: ' + CAST(7 + (@i % 3) AS VARCHAR) + ':00am - ' + CAST(7 + @i AS VARCHAR) + ':00pm', 0x01, GETDATE(), 4, @i);
    
    SET @i = @i + 1;
END

-- 7. Contratos con empresas proveedoras
INSERT INTO solturadb.soltura_contracts (name, date, expirationdate, associatedCompaniesid) 
VALUES
    ('Contrato FitLife 2025', '2025-01-01', '2025-12-31', 1),
    ('Acuerdo MediPlus 2025', '2025-01-15', '2026-01-15', 2),
    ('Convenio EduTech 2025', '2025-02-01', '2026-01-31', 3),
    ('Alianza CinePlex 2025', '2025-01-10', '2025-12-31', 4),
    ('Contrato GastroClub 2025', '2025-01-05', '2025-12-31', 5),
    ('Acuerdo MobilityPass 2025', '2025-01-01', '2025-12-31', 6),
    ('Convenio WorkHub 2025', '2025-01-01', '2025-12-31', 7);

-- 8. Detalles de contratos (usando un procedimiento para crear múltiples servicios por contrato)
DECLARE @contract_id INT = 1;
DECLARE @service_names TABLE (serviceid INT, name VARCHAR(100), description VARCHAR(200), price DECIMAL(10,2), soltura_pct DECIMAL(5,2), company_pct DECIMAL(5,2));

INSERT INTO @service_names VALUES
(1, 'Membresía Premium', 'Acceso completo a todas las instalaciones', 50.00, 0.20, 0.80),
(1, 'Pase Mensual', 'Acceso mensual a gimnasios', 30.00, 0.15, 0.85),
(1, 'Entrenamiento Personal', 'Sesiones con entrenador personal', 25.00, 0.25, 0.75),

(2, 'Consulta General', 'Consulta con médico general', 45.00, 0.25, 0.75),
(2, 'Exámenes Básicos', 'Panel de exámenes básicos', 60.00, 0.20, 0.80),
(2, 'Servicios Dentales', 'Limpieza y revisión dental', 55.00, 0.15, 0.85),

(3, 'Curso Completo', 'Curso completo de cualquier idioma', 200.00, 0.30, 0.70),
(3, 'Módulo Individual', 'Módulo individual de aprendizaje', 50.00, 0.25, 0.75),
(3, 'Biblioteca Digital', 'Acceso a biblioteca digital', 15.00, 0.20, 0.80),

(4, 'Entrada Premium', 'Entrada a cualquier película premium', 15.00, 0.18, 0.82),
(4, 'Combo Familiar', 'Combo para 4 personas con snacks', 40.00, 0.20, 0.80),
(4, 'Pase VIP', 'Acceso a salas VIP', 20.00, 0.22, 0.78),

(5, 'Descuento Restaurantes', 'Descuento en restaurantes de la cadena', 25.00, 0.15, 0.85),
(5, 'Café Gratis', 'Café gratis en establecimientos asociados', 5.00, 0.10, 0.90),
(5, 'Experiencia Gourmet', 'Degustación en restaurantes selectos', 45.00, 0.18, 0.82),

(6, 'Transporte Urbano', 'Acceso a transporte público ilimitado', 30.00, 0.12, 0.88),
(6, 'Alquiler Vehículos', 'Descuento en alquiler de vehículos', 40.00, 0.15, 0.85),
(6, 'Servicio Taxi', 'Descuento en servicios de taxi', 20.00, 0.10, 0.90),

(7, 'Acceso Diario', 'Acceso diario a espacio de coworking', 15.00, 0.20, 0.80),
(7, 'Membresía Mensual', 'Acceso mensual a espacios de trabajo', 120.00, 0.25, 0.75),
(7, 'Sala de Reuniones', 'Uso de salas de reuniones', 30.00, 0.18, 0.82);

INSERT INTO solturadb.soltura_contractDetails (name, description, contractid, price, solturaPercentage, companyPercentage)
SELECT name, description, serviceid, price, soltura_pct, company_pct
FROM @service_names;

-- 9. Métodos de redención
INSERT INTO solturadb.soltura_redemptionMethods (name, code) VALUES
    ('QR Code', 'Escanea el código QR en el establecimiento'),
    ('Código Digital', 'Usa este código en el establecimiento o sitio web'),
    ('Cupón', 'Presenta este cupón en el establecimiento'),
    ('Verificación ID', 'Muestra tu identificación en el establecimiento'),
    ('App Móvil', 'Redime a través de nuestra aplicación móvil');

-- 10. Creación de planes de suscripción
INSERT INTO solturadb.soltura_subscriptions ([description], [logourl]) VALUES 
    ('Joven Deportista', 'https://soltura.com/images/plans/joven-deportista.png'),
    ('Familia de Verano', 'https://soltura.com/images/plans/familia-verano.png'),
    ('Viajero Frecuente', 'https://soltura.com/images/plans/viajero-frecuente.png'),
    ('Nómada Digital', 'https://soltura.com/images/plans/nomada-digital.png'),
    ('Ejecutivo Plus', 'https://soltura.com/images/plans/ejecutivo-plus.png'),
    ('Estudiante Universitario', 'https://soltura.com/images/plans/estudiante.png'),
    ('Adulto Mayor Activo', 'https://soltura.com/images/plans/adulto-mayor.png'),
    ('Wellness Total', 'https://soltura.com/images/plans/wellness-total.png'),
    ('Plan Corporativo', 'https://soltura.com/images/plans/corporativo.png');

-- 11. Configuración de horarios para los planes (corregido con enddate no NULL)
INSERT INTO solturadb.soltura_schedules (name, recurrencytype, endtype, repetitions, enddate) VALUES
    ('Mensual', 'Monthly', 'Date', NULL, '2026-12-31'),
    ('Trimestral', 'Monthly', 'Event', 3, '2026-12-31'),
    ('Semestral', 'Monthly', 'Event', 6, '2026-12-31'),
    ('Anual', 'Monthly', 'Event', 12, '2026-12-31');

-- 12. Precios de planes en diferentes monedas
DECLARE @subscription_count INT = 9;
DECLARE @s INT = 1;

WHILE @s <= @subscription_count
BEGIN
    INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
    VALUES 
    (9.99 + (@s * 10), 1, GETDATE(), '2026-01-01', 0x01, 1, @s);
    
    INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
    VALUES 
    ((9.99 + (@s * 10)) * 500, 1, GETDATE(), '2026-01-01', 0x01, 2, @s);
    
    SET @s = @s + 1;
END

-- 13. Creación de planperson 
DECLARE @planprices_count INT;
SELECT @planprices_count = COUNT(*) FROM solturadb.soltura_planprices;

DECLARE @p INT = 1;
DECLARE @maxplanperson INT = 25; 
DECLARE @scheduleId INT;
DECLARE @planpriceId INT;
DECLARE @maxAccounts INT;

WHILE @p <= @maxplanperson
BEGIN
    SET @scheduleId = 1 + ((@p - 1) % 4);
    
    SET @planpriceId = 1 + ((@p - 1) % @planprices_count);
    
    SET @maxAccounts = CASE 
        WHEN @p % 3 = 0 THEN 4  
        WHEN @p % 3 = 1 THEN 2  
        ELSE 1                   
    END;
    
    INSERT INTO solturadb.soltura_planperson 
        (acquisition, enabled, scheduleid, planpricesid, expirationdate, maxaccounts)
    VALUES 
        (DATEADD(DAY, -1 * (@p * 3), GETDATE()), 0x01, @scheduleId, @planpriceId, DATEADD(YEAR, 1, GETDATE()), @maxAccounts);
    
    SET @p = @p + 1;
END

-- 14. Asignar usuarios a planes 
DECLARE @u INT = 1;
DECLARE @planpersonId INT;

WHILE @u <= 25  
BEGIN
    SET @planpersonId = 1 + ((@u - 1) % @maxplanperson);
    
    DECLARE @currentAccounts INT;
    SELECT @currentAccounts = COUNT(*) 
    FROM solturadb.soltura_planperson_users 
    WHERE planpersonid = @planpersonId;
    
    DECLARE @maxPermittedAccounts INT;
    SELECT @maxPermittedAccounts = maxaccounts 
    FROM solturadb.soltura_planperson 
    WHERE planpersonid = @planpersonId;
    
    IF @currentAccounts < @maxPermittedAccounts
    BEGIN
        INSERT INTO solturadb.soltura_planperson_users (planpersonid, userid)
        VALUES (@planpersonId, @u);
    END
    ELSE
    BEGIN
        DECLARE @alternativePlanId INT;
        
        SELECT TOP 1 @alternativePlanId = pp.planpersonid
        FROM solturadb.soltura_planperson pp
        LEFT JOIN (
            SELECT planpersonid, COUNT(*) as usercount 
            FROM solturadb.soltura_planperson_users 
            GROUP BY planpersonid
        ) as counts ON pp.planpersonid = counts.planpersonid
        WHERE ISNULL(counts.usercount, 0) < pp.maxaccounts
        ORDER BY NEWID();
        
        INSERT INTO solturadb.soltura_planperson_users (planpersonid, userid)
        VALUES (@alternativePlanId, @u);
    END
    
    SET @u = @u + 1;
END

-- 15. Creación de beneficios para los diferentes planes
DECLARE @planperson_count INT;
SELECT @planperson_count = COUNT(*) FROM solturadb.soltura_planperson;

DECLARE @contractDetail_count INT;
SELECT @contractDetail_count = COUNT(*) FROM solturadb.soltura_contractDetails;

DECLARE @category_count INT;
SELECT @category_count = COUNT(*) FROM solturadb.soltura_categorybenefits;

DECLARE @b INT = 1;
DECLARE @total_benefits INT = 75; 

WHILE @b <= @total_benefits
BEGIN
    DECLARE @planpersonId_b INT = 1 + ((@b - 1) % @planperson_count);
    DECLARE @categoryId INT = 1 + ((@b - 1) % @category_count);
    DECLARE @contractDetailId INT = 1 + ((@b - 1) % @contractDetail_count);
    DECLARE @benefitTypeId INT = 1 + ((@b - 1) % 6);
    DECLARE @benefitSubTypeId INT = 1 + ((@b - 1) % 9);
    
    DECLARE @benefitName NVARCHAR(100);
    DECLARE @benefitDesc NVARCHAR(255);
    
    SELECT @benefitName = 
        CASE @categoryId
            WHEN 1 THEN 'Beneficio Gimnasio ' + CAST(@b AS VARCHAR)
            WHEN 2 THEN 'Beneficio Salud ' + CAST(@b AS VARCHAR)
            WHEN 3 THEN 'Beneficio Educación ' + CAST(@b AS VARCHAR)
            WHEN 4 THEN 'Beneficio Entretenimiento ' + CAST(@b AS VARCHAR)
            WHEN 5 THEN 'Beneficio Gastronomía ' + CAST(@b AS VARCHAR)
            WHEN 6 THEN 'Beneficio Transporte ' + CAST(@b AS VARCHAR)
            WHEN 7 THEN 'Beneficio Hospedaje ' + CAST(@b AS VARCHAR)
            WHEN 8 THEN 'Beneficio Coworking ' + CAST(@b AS VARCHAR)
            ELSE 'Beneficio General ' + CAST(@b AS VARCHAR)
        END;
        
    SELECT @benefitDesc = 
        CASE @categoryId
            WHEN 1 THEN 'Descripción del beneficio de gimnasio ' + CAST(@b AS VARCHAR)
            WHEN 2 THEN 'Descripción del beneficio de salud ' + CAST(@b AS VARCHAR)
            WHEN 3 THEN 'Descripción del beneficio de educación ' + CAST(@b AS VARCHAR)
            WHEN 4 THEN 'Descripción del beneficio de entretenimiento ' + CAST(@b AS VARCHAR)
            WHEN 5 THEN 'Descripción del beneficio de gastronomía ' + CAST(@b AS VARCHAR)
            WHEN 6 THEN 'Descripción del beneficio de transporte ' + CAST(@b AS VARCHAR)
            WHEN 7 THEN 'Descripción del beneficio de hospedaje ' + CAST(@b AS VARCHAR)
            WHEN 8 THEN 'Descripción del beneficio de coworking ' + CAST(@b AS VARCHAR)
            ELSE 'Descripción del beneficio general ' + CAST(@b AS VARCHAR)
        END;
    
    INSERT INTO solturadb.soltura_benefits
        (enabled, name, description, availableuntil, planpersonid, categorybenefitsid, contractDetailId, benefitTypeId, benefitSubTypeId)
    VALUES
        (0x01, @benefitName, @benefitDesc, '2026-01-01', @planpersonId_b, @categoryId, @contractDetailId, @benefitTypeId, @benefitSubTypeId);
        
    SET @b = @b + 1;
END

-- 16. Registro de algunas redenciones de beneficios 
DECLARE @r INT = 1;
DECLARE @redemptions_count INT = 20;
DECLARE @benefit_count INT;

SELECT @benefit_count = COUNT(*) FROM solturadb.soltura_benefits;
DECLARE @user_count INT = 25; 

WHILE @r <= @redemptions_count
BEGIN
    DECLARE @userId_r INT = 1 + ((@r - 1) % @user_count);
    DECLARE @benefitId_r INT = 1 + ((@r - 1) % @benefit_count);
    DECLARE @redemptionMethodId INT = 1 + ((@r - 1) % 5);
    DECLARE @reference1 INT = 100000 + @r;
    DECLARE @reference2 INT = 200000 + @r; 
    DECLARE @value1 VARCHAR(100) = 'Redención ' + CAST(@r AS VARCHAR) + ' en empresa';
    DECLARE @value2 VARCHAR(100) = 'Detalle adicional ' + CAST(@r AS VARCHAR);
    
    INSERT INTO solturadb.soltura_redemptions
        (date, redemptionMethodsid, userid, benefitsid, reference1, reference2, value1, value2, checksum)
    VALUES
        (DATEADD(DAY, -1 * (@r % 30), GETDATE()), @redemptionMethodId, @userId_r, @benefitId_r, @reference1, @reference2, @value1, @value2, 0x0123456789);
        
    SET @r = @r + 1;
END

-- 17. Crear índices para mejorar el rendimiento
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_soltura_planperson_users_userid' AND object_id = OBJECT_ID('solturadb.soltura_planperson_users'))
CREATE NONCLUSTERED INDEX IX_soltura_planperson_users_userid 
ON solturadb.soltura_planperson_users(userid);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_soltura_benefits_categoryid' AND object_id = OBJECT_ID('solturadb.soltura_benefits'))
CREATE NONCLUSTERED INDEX IX_soltura_benefits_categoryid 
ON solturadb.soltura_benefits(categorybenefitsid);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_soltura_benefits_typeid' AND object_id = OBJECT_ID('solturadb.soltura_benefits'))
CREATE NONCLUSTERED INDEX IX_soltura_benefits_typeid 
ON solturadb.soltura_benefits(benefitTypeId);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_soltura_redemptions_userid' AND object_id = OBJECT_ID('solturadb.soltura_redemptions'))
CREATE NONCLUSTERED INDEX IX_soltura_redemptions_userid 
ON solturadb.soltura_redemptions(userid);

-- Verificación final de datos
SELECT 'Monedas' AS Tabla, COUNT(*) AS Cantidad FROM solturadb.soltura_currency
UNION ALL
SELECT 'Empresas Asociadas', COUNT(*) FROM solturadb.soltura_associatedCompanies
UNION ALL
SELECT 'Contratos', COUNT(*) FROM solturadb.soltura_contracts
UNION ALL
SELECT 'Detalles de Contratos', COUNT(*) FROM solturadb.soltura_contractDetails
UNION ALL
SELECT 'Planes de Suscripción', COUNT(*) FROM solturadb.soltura_subscriptions
UNION ALL
SELECT 'Personas con Plan', COUNT(*) FROM solturadb.soltura_planperson
UNION ALL
SELECT 'Usuarios con Plan', COUNT(*) FROM solturadb.soltura_planperson_users
UNION ALL
SELECT 'Beneficios', COUNT(*) FROM solturadb.soltura_benefits
UNION ALL
SELECT 'Redenciones', COUNT(*) FROM solturadb.soltura_redemptions;

-- Resumen de beneficios por tipo de suscripción
SELECT s.description AS 'Plan', 
       COUNT(DISTINCT b.benefitsid) AS 'Total Beneficios',
       STRING_AGG(b.name, ', ') WITHIN GROUP (ORDER BY b.name) AS 'Ejemplos de Beneficios'
FROM solturadb.soltura_benefits b
JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
JOIN solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
GROUP BY s.description
ORDER BY s.description;
```

---
# Demostraciones T-SQL
1 y 2. Cursor local y global 
```sql
USE soltura;
GO

-- PARTE 1: CURSOR LOCAL

DECLARE @benefitName VARCHAR(100);
DECLARE @benefitType VARCHAR(50);

DECLARE benefitCursor CURSOR LOCAL FOR
SELECT b.name, bt.name 
FROM solturadb.soltura_benefits b
JOIN dbo.soltura_benefitTypes bt ON b.benefitTypeId = bt.benefitTypeId
WHERE b.enabled = 0x01;

OPEN benefitCursor;
FETCH NEXT FROM benefitCursor INTO @benefitName, @benefitType;

PRINT 'Primeros 5 beneficios activos:';
DECLARE @count INT = 0;
WHILE @@FETCH_STATUS = 0 AND @count < 5
BEGIN
    PRINT 'Beneficio: ' + @benefitName + ' - De tipo: ' + @benefitType;
    FETCH NEXT FROM benefitCursor INTO @benefitName, @benefitType;
    SET @count = @count + 1;
END

CLOSE benefitCursor;
DEALLOCATE benefitCursor;

PRINT '(Al acceder desde otra sesión) Error: El cursor ''benefitCursor'' no existe o no está abierto.';





-- PARTE 2: CURSOR GLOBAL


DECLARE globalBenefitCursor CURSOR GLOBAL FOR
SELECT TOP 3 name FROM solturadb.soltura_benefits;


OPEN globalBenefitCursor;

-- Para acceder al cursor desde otra sesión
PRINT 'Cursor global creado - Para acceder desde otra sesión:';
PRINT 'DECLARE @name VARCHAR(100);';
PRINT 'FETCH NEXT FROM globalBenefitCursor INTO @name;';
PRINT 'PRINT @name;';


CLOSE globalBenefitCursor;
DEALLOCATE globalBenefitCursor;

-- VISIBILIDAD

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
```
3. Trigger
4. sp_recompile
5. MERGE
6. COALESCE
7. SUBSTRING
8. LTRIM
9. AVG
10. TOP
11. &&
``` sql
    -- && en T-SQL (explicación)
&& no se usa en T-SQL, en su lugar se utiliza AND para operaciones lógicas.
Ejemplo: WHERE condicion1 = 1 AND condicion2 = 2

```
12. SCHEMABINDING 
13. WITH ENCRYPTION
14. EXECUTE AS
15. UNION 
16. DISTINCT 


---
# Mantenimiento de la Seguridad


--- 
# Consultas Misceláneas

---
# Concurrencia

---
# Soltura ft. PaymentAssistant
