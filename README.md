# Soltura_DB

## ÍNDICE
- [Soltura\_DB](#soltura_db)
  - [ÍNDICE](#índice)
- [Integrantes:](#integrantes)
- [Documentación para el diseño](#documentación-para-el-diseño)
  - [MongoDB](#mongodb)
- [Población de datos](#población-de-datos)
- [Demostraciones T-SQL](#demostraciones-t-sql)
  - [1 y 2. Cursor local y global](#1-y-2-cursor-local-y-global)
  - [3. Trigger](#3-trigger)
  - [4. MERGE Y SP\_RECOMPILE.](#4-merge-y-sp_recompile)
      - [1. SQL Server Management Studio → SQL Server Agent → Jobs](#1-sql-server-management-studio--sql-server-agent--jobs)
      - [2. Click derecho → New Job y Name: "Soltura\_RecompileSPs\_Weekly"](#2-click-derecho--new-job-y-name-soltura_recompilesps_weekly)
      - [3. Steps: Agregar paso con "EXEC solturadb.sp\_RecompileAllSPs"](#3-steps-agregar-paso-con-exec-solturadbsp_recompileallsps)
      - [4. Schedule: Configurar para cada domingo a las 2:00 AM](#4-schedule-configurar-para-cada-domingo-a-las-200-am)
      - [5. Finalmente se verá así:](#5-finalmente-se-verá-así)
  - [5 COALESCE, SUBSTRING, LTRIM, SCHEMABINDING](#5-coalesce-substring-ltrim-schemabinding)
  - [6 AVG](#6-avg)
  - [7 TOP](#7-top)
  - [8 WITH ENCRYPTION](#8-with-encryption)
  - [9 EXECUTE AS y DISTINCT](#9-execute-as-y-distinct)
  - [10 UNION](#10-union)
- [Mantenimiento de la Seguridad](#mantenimiento-de-la-seguridad)
  - [Usuario sin acceso del todo.](#usuario-sin-acceso-del-todo)
  - [Usuario sin acceso al select.](#usuario-sin-acceso-al-select)
  - [Rol usuario con acceso a SP, pero nada más](#rol-usuario-con-acceso-a-sp-pero-nada-más)
  - [Ahora, RLS](#ahora-rls)
  - [Ahora con el certificado, llave simétrica, asimétrica y cifrados](#ahora-con-el-certificado-llave-simétrica-asimétrica-y-cifrados)
    - [Creada la master key, se puede crear el certificado:](#creada-la-master-key-se-puede-crear-el-certificado)
    - [Crear llave asimétrica:](#crear-llave-asimétrica)
    - [Crear llave simétrica:](#crear-llave-simétrica)
    - [Ahora para cifrar con la llave:](#ahora-para-cifrar-con-la-llave)
    - [Para descrifrar usando las llaves:](#para-descrifrar-usando-las-llaves)
- [Consultas Misceláneas](#consultas-misceláneas)
  - [Vista indexada dínamica](#vista-indexada-dínamica)
  - [Procedimiento almacenado transaccional](#procedimiento-almacenado-transaccional)
  - [Consulta con CASE para agrupamiento](#consulta-con-case-para-agrupamiento)
  - [Consulta compleja optimizada](#consulta-compleja-optimizada)
  - [Consulta con operaciones EXCEPT Y INTERSECT](#consulta-con-operaciones-except-y-intersect)
  - [Procedimientos almacenados anidados](#procedimientos-almacenados-anidados)
  - [Consulta sobre obtener un JSON](#consulta-sobre-obtener-un-json)
  - [SP transaccional que Actualice los contratos](#sp-transaccional-que-actualice-los-contratos)
  - [Consulta y exportar a CSV.](#consulta-y-exportar-a-csv)
  - [Bitácora en otro SQL Server.](#bitácora-en-otro-sql-server)
- [Concurrencia](#concurrencia)
  - [Deadlocks entre Dos Transacciones](#deadlocks-entre-dos-transacciones)
  - [Deadlocks en Cascada](#deadlocks-en-cascada)
  - [Niveles de Isolacion](#niveles-de-isolacion)
  - [Cursor de Update](#cursor-de-update)
  - [Transacción de Volumen](#transacción-de-volumen)
  - [Transacciones Por Segundo Máximo](#transacciones-por-segundo-máximo)
  - [Triplicar las Transacciones Por Segundo Máximo](#triplicar-las-transacciones-por-segundo-máximo)
- [Soltura ft. PaymentAssistant](#soltura-ft-paymentassistant)
  - [Script para migrar los usuarios](#script-para-migrar-los-usuarios)
  - [Script para migrar los modulos](#script-para-migrar-los-modulos)
  - [Script para migrar los permisos](#script-para-migrar-los-permisos)
  - [Script para migrar los permisos de usuarios](#script-para-migrar-los-permisos-de-usuarios)
  - [Script para migrar las suscripciones](#script-para-migrar-las-suscripciones)
  - [Script para migrar los precios de planes](#script-para-migrar-los-precios-de-planes)
  - [Script para insertar banner y home page sobre el nuevo cambio de sistema](#script-para-insertar-banner-y-home-page-sobre-el-nuevo-cambio-de-sistema)








---
# Integrantes:
- **Daniel Arce Campos** - Carnet: 2024174489
- **Allan David Bolaños Barrientos** - Carnet: 2024145458
- **Natalia Orozco Delgado** - Carnet: 2024099161
- **Isaac Villalobos Bonilla** - Carnet: 2024124285
---

# Documentación para el diseño
La base de datos se diseño conforme al fixed diagram pdf

## MongoDB
Este es el modelo para la colección de paquetes informativos de Soltura, es un esquema que valida que cada documento insertado debe tener identificador unico para reconocer el paquete informativo, un estado para conocer si sigue activo o ya no, la lista de categorias para clasificar el contenido del paquete, la fecha en la que se publico en la web, el link de referencia donde el usuario puede ver información mas detallada como soporte tecnico y finalmente un titulo.
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": [
    "_id",
    "activo",
    "categorias",
    "contenido",
    "fecha_publicacion",
    "link_referencia",
    "titulo"
  ],
  "properties": {
    "_id": {
      "$ref": "#/$defs/ObjectId"
    },
    "activo": {
      "type": "boolean"
    },
    "categorias": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "contenido": {
      "type": "string"
    },
    "fecha_publicacion": {
      "$ref": "#/$defs/Date"
    },
    "link_referencia": {
      "type": "string"
    },
    "titulo": {
      "type": "string"
    }
  },
  "$defs": {
    "ObjectId": {
      "type": "object",
      "properties": {
        "$oid": {
          "type": "string",
          "pattern": "^[0-9a-fA-F]{24}$"
        }
      },
      "required": [
        "$oid"
      ],
      "additionalProperties": false
    },
    "Date": {
      "type": "object",
      "properties": {
        "$date": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "$date"
      ],
      "additionalProperties": false
    }
  }
}
```
Este es el modelo para la colección de la media de Soltura
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": [
    "_id",
    "activo",
    "descripcion",
    "link_guia",
    "tipo",
    "titulo"
  ],
  "properties": {
    "_id": {
      "$ref": "#/$defs/ObjectId"
    },
    "activo": {
      "type": "boolean"
    },
    "descripcion": {
      "type": "string"
    },
    "fecha_migracion": {
      "$ref": "#/$defs/Date"
    },
    "fecha_publicacion": {
      "$ref": "#/$defs/Date"
    },
    "imagen_url": {
      "type": "string"
    },
    "link_guia": {
      "type": "string"
    },
    "tipo": {
      "type": "string"
    },
    "titulo": {
      "type": "string"
    }
  },
  "$defs": {
    "ObjectId": {
      "type": "object",
      "properties": {
        "$oid": {
          "type": "string",
          "pattern": "^[0-9a-fA-F]{24}$"
        }
      },
      "required": [
        "$oid"
      ],
      "additionalProperties": false
    },
    "Date": {
      "type": "object",
      "properties": {
        "$date": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "$date"
      ],
      "additionalProperties": false
    }
  }
}
```
Este es el modelo para la colección de promociones de Soltura
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": [
    "_id",
    "activo",
    "condiciones",
    "descripcion",
    "fecha_fin",
    "fecha_inicio",
    "imagen_url",
    "titulo"
  ],
  "properties": {
    "_id": {
      "$ref": "#/$defs/ObjectId"
    },
    "activo": {
      "type": "boolean"
    },
    "condiciones": {
      "type": "string"
    },
    "descripcion": {
      "type": "string"
    },
    "fecha_fin": {
      "$ref": "#/$defs/Date"
    },
    "fecha_inicio": {
      "$ref": "#/$defs/Date"
    },
    "imagen_url": {
      "type": "string"
    },
    "titulo": {
      "type": "string"
    }
  },
  "$defs": {
    "ObjectId": {
      "type": "object",
      "properties": {
        "$oid": {
          "type": "string",
          "pattern": "^[0-9a-fA-F]{24}$"
        }
      },
      "required": [
        "$oid"
      ],
      "additionalProperties": false
    },
    "Date": {
      "type": "object",
      "properties": {
        "$date": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "$date"
      ],
      "additionalProperties": false
    }
  }
}
```
Este es el modelo para la colección de reviews de Soltura
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": [
    "_id",
    "cliente_id",
    "comentario",
    "fecha",
    "puntaje",
    "servicios_usados"
  ],
  "properties": {
    "_id": {
      "$ref": "#/$defs/ObjectId"
    },
    "cliente_id": {
      "type": "integer"
    },
    "comentario": {
      "type": "string"
    },
    "fecha": {
      "$ref": "#/$defs/Date"
    },
    "puntaje": {
      "type": "integer"
    },
    "servicios_usados": {
      "type": "string"
    }
  },
  "$defs": {
    "ObjectId": {
      "type": "object",
      "properties": {
        "$oid": {
          "type": "string",
          "pattern": "^[0-9a-fA-F]{24}$"
        }
      },
      "required": [
        "$oid"
      ],
      "additionalProperties": false
    },
    "Date": {
      "type": "object",
      "properties": {
        "$date": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "$date"
      ],
      "additionalProperties": false
    }
  }
}
```

Este es el modelo para la resolución de quejas de Soltura
```json
{
  "caso_id": "001245",
  "cliente_id": "523",
  "descripcion": "El cliente reportó que no le reconocieron la membresia de Smartifit.",
  "fecha_resolucion": { "$date": "2025-05-05T11:00:00.000Z" },
  "resultado": "Reembolso realizado",
  "resuelto_por": "Laura Rojas",
  "satisfaccion_cliente": 5
}
```
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
DBCC CHECKIDENT ('solturadb.soltura_redemptions', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_benefits', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_planperson', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_planprices', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_contractDetails', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_contracts', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_companiesContactinfo', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_associatedCompanies', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_schedules', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_categorybenefits', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_redemptionMethods', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_companyinfotypes', RESEED, 1);
DBCC CHECKIDENT ('solturadb.soltura_subscriptions', RESEED, 1);


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

INSERT INTO solturadb.soltura_countries (name, language, currencyid) VALUES 
('United States', 'en', 1),  
('Costa Rica', 'es', 2),   
('Puerto Rico', 'es', 1), 
('Panamá', 'es', 1);  
       
INSERT INTO solturadb.soltura_states (name, countryid) VALUES 
('San José', 2),       
('Alajuela', 2),
('California', 1),
('Texas', 1),
('San Juan', 3),
('Ciudad de Panamá', 4);

INSERT INTO solturadb.soltura_cities (name, stateid) VALUES 
('San José', 1),
('Escazú', 1),
('San Ramón', 2),
('Grecia', 2),
('Los Angeles', 3),
('San Francisco', 3),
('Dallas', 4),
('Austin', 4),
('Guaynabo', 5),
('San Miguelito', 6);

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

-- Inserción de usuarios
DECLARE @i INT = 1;
DECLARE @total_addresses INT;
SELECT @total_addresses = COUNT(*) FROM solturadb.soltura_addresses;

WHILE @i <= 30
BEGIN
    DECLARE @random_email NVARCHAR(100) = CONCAT('usuario', @i, '@gmail.com');
    DECLARE @random_firstname NVARCHAR(50) = CONCAT('Nombre', @i);
    DECLARE @random_lastname NVARCHAR(50) = CONCAT('Apellido', @i);
    DECLARE @random_birthday DATE = DATEADD(DAY, -1 * FLOOR(RAND() * 365 * 30), GETDATE());
    DECLARE @random_password VARBINARY(256) = HASHBYTES('SHA2_256', CONCAT('Contraseña', @i));
    DECLARE @random_address_id INT = FLOOR(RAND() * @total_addresses) + 1;

    INSERT INTO solturadb.soltura_users (email, firstname, lastname, birthday, password)
    VALUES (@random_email, @random_firstname, @random_lastname, @random_birthday, @random_password);

    INSERT INTO solturadb.soltura_useraddress (userid, addressid, useraddressid)
    VALUES (SCOPE_IDENTITY(), @random_address_id, @i);

    SET @i = @i + 1;
END

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
SET @i = 1;
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
        (DATEADD(DAY, -1 * (@r % 30), GETDATE()), @redemptionMethodId, @userId_r, @benefitId_r, @reference1, @reference2,
         CONVERT(varbinary(100), @value1), CONVERT(varbinary(100), @value2), 0x0123456789);
        
    SET @r = @r + 1;
END

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
## 1 y 2. Cursor local y global 
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
## 3. Trigger
En este script, se crea un trigger, que consiste en que cada vez que se crea un nuevo contrato se automatiza la creación del contract detail con la información del contrado recién insertado. Alguno de los valores se ponen de manera predeterminada para que luego segun el acuerdo se ajusta los precios y el porcentaje. La idea del trigger es facilitar a Soltura la tarea de tener que crear la tabla de contract details, sino que ya se crea y solo editan los datos del precio y porcentajes
```sql
CREATE TRIGGER trg_insert_default_detail
ON solturadb.soltura_contracts
--Este trigger se ejecuta después de insertar un nuevo contrato 
AFTER INSERT
AS
BEGIN
    --Insertamos las filas en la tabla de detalles de contrato
    INSERT INTO solturadb.soltura_contractDetails (name, description, contractid, price, solturaPercentage, companyPercentage)
    SELECT 
        --Ponemos datos por defecto para el detalle del contrato
        --Lo que se busca es que SolturaDB no tenga que crear un contractDetail, sino solo editrar sus datos segun los acuerdos
        'Detalle inicial', 
        'Detalle automático generado al crear el contrato', 
        i.contractid, 
        0.00, 
        0.00, 
        0.00  
    FROM inserted i; --Se insertan los detalles con los datos del contrado recien insertado
END;
GO

--Insertamos un contrato para probar el trigger
INSERT INTO solturadb.soltura_contracts (name, date, expirationdate, associatedCompaniesid)
VALUES 
('Contrato Prueba Trigger', '2023-10-01', '2024-10-01', 1);
GO
SELECT * FROM solturadb.soltura_contractDetails;
```

## 4. MERGE Y SP_RECOMPILE.

En este primero funciona, el merge como principal, en el segundo ya hablamos del SP_Recompile.

En este script, el "SP_RECOMPILE" se está utilizando para forzar la recompilación del plan de ejecución almacenado.
Ya que se están modificando los datos, esto sucede, que si más adelante, existen datos masivos, ese incremento, el SQL server podría usar un plan de ejecucuón obsoleto y modificar mal los datos. Entonces, cómo dependen entre sí las estadísticas, lo mejor es actualizar el plan que está en el caché

Y el merge garantaiza que todos los precios se actualicen en una única transacción. Es decir TODOS o ninguno, entonces, evita hacer múltiples operaciones.
```sql

-- Resulta y acontece que el CEO tomo una mala decisión y quiere ganar más plata, entonces va a suber los precios de los planes en un n% (en este ejemplo 5)
-- Así que profe, observe la magia, cómo ganamos más dineros.

-- Esta tabla se crea temporalmente, para almacenar los nuevos precios de los planes
CREATE TABLE #NuevosPreciosPlan (
    planpricesid INT PRIMARY KEY,
    nueva_cantidad DECIMAL(10,2),
    ultima_actualizacion DATETIME
);

-- Ahora insertamos los nuevos precios en la tabla temporal basada en los precios actuales
INSERT INTO #NuevosPreciosPlan (planpricesid, nueva_cantidad, ultima_actualizacion)
SELECT 
    pp.planpricesid,
    pp.amount * 1.05, -- 5% de aumento por inflación (Wink wink "inflación")....
    GETDATE()
FROM solturadb.soltura_planprices pp
WHERE pp.[current] = 0x01
  AND pp.endate > GETDATE(); -- Importante solo los planes activos

-- Aquí es dónde se usa el sp_recompile para forzar la recompilación de los planes de precios
EXEC sp_recompile 'solturadb.soltura_planprices';

-- Y ahora actualizamos los precios de los planes y mandamos los cambios
DECLARE @AuditChanges TABLE (
    planpricesid INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME
);

-- El merge aquí, es quien se encarga de actualizar los precios de los planes
MERGE solturadb.soltura_planprices AS target
USING #NuevosPreciosPlan AS source -- Basado en la tabla temporal
ON (target.planpricesid = source.planpricesid)
WHEN MATCHED THEN
    UPDATE SET 
        target.amount = source.nueva_cantidad,
        target.posttime = source.ultima_actualizacion
OUTPUT 
    inserted.planpricesid, 
    deleted.amount, 
    inserted.amount, 
    GETDATE()
INTO @AuditChanges;

-- Originalmente en nuestro diagrama, no habíamos pensando en un historial de precios,
-- así que aquí lo creamos (no nos baje por favor.)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'soltura_price_history' AND schema_id = SCHEMA_ID('solturadb'))
BEGIN
    CREATE TABLE solturadb.soltura_price_history (
        historyid INT IDENTITY(1,1) PRIMARY KEY,
        planpricesid INT NOT NULL,
        precio_anterior DECIMAL(10,2) NOT NULL,
        precio_nuevo DECIMAL(10,2) NOT NULL,
        fecha_cambio DATETIME NOT NULL,
        usuario_cambio NVARCHAR(128) DEFAULT SUSER_SNAME(),
        FOREIGN KEY (planpricesid) REFERENCES solturadb.soltura_planprices(planpricesid)
    );
END

-- Registrar los cambios en la tabla de historial
INSERT INTO solturadb.soltura_price_history (planpricesid, precio_anterior, precio_nuevo, fecha_cambio)
SELECT planpricesid, precio_anterior, precio_nuevo, fecha_cambio
FROM @AuditChanges;

-- Recompilamos los objetos que dependen de la tabla de precios
EXEC sp_recompile 'solturadb.soltura_benefits';

SELECT 
    pp.planpricesid,
    s.description AS 'Plan',
    c.symbol AS 'Moneda',
    ph.precio_anterior AS 'Precio Anterior',
    pp.amount AS 'Nuevo Precio',
    FORMAT((pp.amount - ph.precio_anterior) / ph.precio_anterior, 'P2') AS 'Porcentaje Incremento',
    ph.fecha_cambio AS 'Fecha Actualización'
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_price_history ph ON pp.planpricesid = ph.planpricesid
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid
WHERE ph.fecha_cambio = (SELECT MAX(fecha_cambio) FROM solturadb.soltura_price_history)
ORDER BY s.description, c.symbol;

-- Limpiar la tabla temporal después de usarla (No hay que dejar evidencias)....
DROP TABLE #NuevosPreciosPlan;
```

SP_RECOMPILE SOLO:
En este usamos el procedimiento para forzar la recompilación de TODOS los planes de ejecución almacenados en caché. Pero la pregunta es 
¿Cómo recompilar todos los SPs existentes cada cierto tiempo?

Se puede crear un procedimiento master: en este caso el procedimiento sp_RecompileAllSPs que utiliza cursores para iterar sobre:
- Todos los procedimientos almacenados personalizados
- Todas las vistas indexadas
  
Y luego sería programar un mantenimiento para ejecutarse automáticamente:

#### 1. SQL Server Management Studio → SQL Server Agent → Jobs 

![SQL server agent jobs](assets/image-1.png)

#### 2. Click derecho → New Job y Name: "Soltura_RecompileSPs_Weekly"
![alt text](assets/image.png)

#### 3. Steps: Agregar paso con "EXEC solturadb.sp_RecompileAllSPs"
![alt text](assets/image-2.png)

#### 4. Schedule: Configurar para cada domingo a las 2:00 AM
![alt text](assets/image-3.png)

#### 5. Finalmente se verá así:
![alt text](assets/image-4.png)

IMPORTANTE: Puede suceder que, sí no se había activado el SQL Agent, pueda tener problemas con los permisos, así que se adjunta un script en: "scripts/fixAgentSQL.sql" que al correrlo otorga los permisos necesarios.
```sql
USE soltura;
GO

-- Procedimiento simple para recompilar todos los SPs
CREATE OR ALTER PROCEDURE solturadb.sp_RecompileAllSPs
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Iniciando recompilación: ' + CONVERT(VARCHAR, GETDATE(), 120);
    
    -- Cursor simple para recorrer todos los procedimientos
    DECLARE @sp_name NVARCHAR(255);
    DECLARE @sql NVARCHAR(500);
    DECLARE @count INT = 0;
    
    -- Seleccionar solo procedimientos personalizados (no de sistema)
    DECLARE sp_cursor CURSOR FOR 
        SELECT SCHEMA_NAME(schema_id) + '.' + name 
        FROM sys.procedures 
        WHERE is_ms_shipped = 0;
    
    OPEN sp_cursor;
    FETCH NEXT FROM sp_cursor INTO @sp_name;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'EXEC sp_recompile ''' + @sp_name + '''';
        EXEC sp_executesql @sql;
        
        SET @count = @count + 1;
        FETCH NEXT FROM sp_cursor INTO @sp_name;
    END
    
    CLOSE sp_cursor;
    DEALLOCATE sp_cursor;
    
    -- También recompilar vistas indexadas
    DECLARE view_cursor CURSOR FOR 
        SELECT SCHEMA_NAME(v.schema_id) + '.' + v.name 
        FROM sys.views v
        JOIN sys.indexes i ON v.object_id = i.object_id
        WHERE i.index_id > 0;
    
    OPEN view_cursor;
    FETCH NEXT FROM view_cursor INTO @sp_name;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'EXEC sp_recompile ''' + @sp_name + '''';
        EXEC sp_executesql @sql;
        
        SET @count = @count + 1;
        FETCH NEXT FROM view_cursor INTO @sp_name;
    END
    
    CLOSE view_cursor;
    DEALLOCATE view_cursor;
    
    PRINT 'Recompilación completada: ' + CONVERT(VARCHAR, GETDATE(), 120);
    PRINT 'Total objetos recompilados: ' + CAST(@count AS VARCHAR);
END;
GO
```
---
## 5 COALESCE, SUBSTRING, LTRIM, SCHEMABINDING
Aquí usamos efectivamente el schemabinding para enlazar la vista directamente al esquema de las tablas subyacentes.
Luego el coalesce para manejar valores NULL proporcionando un valor alternativo.
El LTRIM para eliminar espacios en blanco del lado izquierdo de una cadena.
Y el substring para extraer una parte específica de una cadena, en este caso el dominio de correo electrónico.
```sql
--
-- Este script crea una vista que muestra la información de contacto de las empresas asociadas,
-- usamos: schemabinding, coalesce, ltrim, substring.
--
--
CREATE VIEW solturadb.vw_CompanyContactInfo 
WITH SCHEMABINDING 
AS
SELECT 
    ac.associatedCompaniesid,
    ac.name AS CompanyName,
    -- Usa COALESCE para mostrar "Sin información" si el valor es NULL y que no se muestre el NULL en la consulta
    COALESCE(
        -- Usa LTRIM para eliminar espacios iniciales en los valores (Esto porque a veces vienen con espacios)
        LTRIM(CAST(ci.value AS NVARCHAR(255))), 
        'Sin información'
    ) AS ContactValue,
    CASE 
        WHEN cit.name = 'Email' THEN 
            -- Usa SUBSTRING para extraer el dominio después del @ (Para que salga bien bonito el dominio)
            CASE 
                WHEN CHARINDEX('@', CAST(ci.value AS NVARCHAR(255))) > 0 
                THEN SUBSTRING(
                    CAST(ci.value AS NVARCHAR(255)), 
                    CHARINDEX('@', CAST(ci.value AS NVARCHAR(255))) + 1,
                    LEN(CAST(ci.value AS NVARCHAR(255))) - CHARINDEX('@', CAST(ci.value AS NVARCHAR(255)))
                )
                ELSE 'Formato inválido'
            END
        ELSE NULL
    END AS EmailDomain,
    cit.name AS ContactType,
    ci.lastupdate AS LastUpdated
FROM solturadb.soltura_associatedCompanies ac
JOIN solturadb.soltura_companiesContactinfo ci ON ac.associatedCompaniesid = ci.associatedCompaniesid
JOIN solturadb.soltura_companyinfotypes cit ON ci.companyinfotypeId = cit.companyinfotypeId
WHERE ci.enabled = 0x01
GO

-- Consulta que utiliza la vista
SELECT 
    CompanyName,
    MAX(CASE WHEN ContactType = 'Email' THEN ContactValue END) AS Email,
    MAX(CASE WHEN ContactType = 'Email' THEN EmailDomain END) AS Domain,
    MAX(CASE WHEN ContactType = 'Teléfono' THEN ContactValue END) AS Phone,
    MAX(CASE WHEN ContactType = 'Sitio Web' THEN ContactValue END) AS Website,
    MAX(CASE WHEN ContactType = 'Horario' THEN ContactValue END) AS Schedule
FROM solturadb.vw_CompanyContactInfo
GROUP BY CompanyName
ORDER BY CompanyName;


-- Probar que el schema binding funciona:
ALTER TABLE solturadb.soltura_companyinfotypes
ALTER COLUMN name VARCHAR(150);
```
## 6 AVG
Con el AVG estamos agrupando para sacar un promedio de montos pagados.
```sqlv
-- AVG con agrupamiento (promedio de montos pagados por suscripción)
SELECT 
    s.description AS 'Plan',
    c.acronym AS 'Moneda',
    AVG(pp.amount) AS 'Precio Promedio'
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid
GROUP BY s.description, c.acronym
ORDER BY AVG(pp.amount) DESC;
```
## 7 TOP
Con el TOP estamos ahora sacando los planes más populars.
```sql
-- TOP para mostrar top 5 planes más populares
SELECT TOP 5 
    s.description AS 'Plan',
    COUNT(ppu.userid) AS 'Número de Usuarios'
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid
JOIN solturadb.soltura_planperson_users ppu ON p.planpersonid = ppu.planpersonid
GROUP BY s.description
ORDER BY COUNT(ppu.userid) DESC;
```
3.  &&
``` sql
    -- && en T-SQL (explicación)
&& no se usa en T-SQL, en su lugar se utiliza AND para operaciones lógicas.
Ejemplo: WHERE condicion1 = 1 AND condicion2 = 2

```
## 8 WITH ENCRYPTION
``` sql
DROP PROCEDURE IF EXISTS storageprocedureenc;
GO

CREATE PROCEDURE storageprocedureenc 
WITH ENCRYPTION 
AS
BEGIN
	SELECT * 
    FROM solturadb.soltura_users
    ORDER BY solturadb.soltura_users.userid ASC;  

    PRINT 'EJECUTADO';
END;
GO

EXEC storageprocedureenc;

-- Esto debería devolver NULL si el SP está encriptado
SELECT OBJECT_DEFINITION(OBJECT_ID('storageprocedureenc'));

-- Esto debería lanzar un error
EXEC sp_helptext 'storageprocedureenc';

```
## 9 EXECUTE AS y DISTINCT
En el procedimiento utilizamos WITH EXECUTE AS 'AuditUser' para ejecutar todo el código con los permisos limitados del usuario AuditUser 
y aplicamos DISTINCT en la consulta principal (COUNT(DISTINCT r.redemptionid)) para asegurar que cada redención se cuente exactamente una vez,

```sql
-- Script para almacenar la auditoría de redenciones
-- En este estamos usando: executa as y distinct.

USE soltura;
GO

-- Vamos a crear un usuario, con el que podamos hacer una auditoría y probar el EXECUTE AS
-- se le dan solo permisos de lectura a las tablas de redenciones, usuarios y beneficios.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AuditUser')
BEGIN
    CREATE USER AuditUser WITHOUT LOGIN;
    
    -- Dar permisos mínimos
    GRANT SELECT ON solturadb.soltura_redemptions TO AuditUser;
    GRANT SELECT ON solturadb.soltura_users TO AuditUser;
    GRANT SELECT ON solturadb.soltura_benefits TO AuditUser;
    GRANT INSERT ON solturadb.soltura_logs TO AuditUser;
END
GO

-- Procedimiento con EXECUTE AS que utiliza la tabla de logs que existen
CREATE OR ALTER PROCEDURE solturadb.sp_SimpleAudit
    @days INT = 7
WITH EXECUTE AS 'AuditUser'
AS
BEGIN
    DECLARE @log_description NVARCHAR(120); -- Descripción del log
    DECLARE @total_count INT; -- Total de redenciones en el período
    DECLARE @most_redeemed_benefit_id INT; -- ID del beneficio más redimido
    DECLARE @most_active_user_id INT; -- ID del usuario más activo
    
    SELECT @total_count = COUNT(DISTINCT r.redemptionid) -- OJO estamos el distinct para evitar contar redenciones duplicadas :D
    FROM solturadb.soltura_redemptions r
    WHERE r.date >= DATEADD(DAY, -@days, GETDATE());
    
    -- Esto solo es para buscar el beneficio más redimido
    SELECT TOP 1 @most_redeemed_benefit_id = benefitsid
    FROM solturadb.soltura_redemptions
    WHERE date >= DATEADD(DAY, -@days, GETDATE())
    GROUP BY benefitsid
    ORDER BY COUNT(*) DESC;
    
    -- Buscar el usuario más activio
    SELECT TOP 1 @most_active_user_id = userid
    FROM solturadb.soltura_redemptions
    WHERE date >= DATEADD(DAY, -@days, GETDATE())
    GROUP BY userid
    ORDER BY COUNT(*) DESC;
    
    SET @log_description = 'Audit: ' + CAST(@total_count AS VARCHAR) + ' redemptions in last ' + CAST(@days AS VARCHAR) + ' days';
    
    INSERT INTO solturadb.soltura_logs
       (description, posttime, computer, username, trace,
        referenceid1, referenceid2, value1, value2,
        checksum, logtypesid, logsourcesid, logseverityid)
    VALUES
       (@log_description,
        GETDATE(),
        HOST_NAME(),
        ORIGINAL_LOGIN(),
        'EXECUTE AS Audit',
        @most_active_user_id,  -- referenceid1 = El usuario más activo
        @most_redeemed_benefit_id,  -- referenceid2 = El beneficio más redimido
        @total_count,  -- value1 = total de redenciones
        @days,
        HASHBYTES('SHA2_256', @log_description),
        1,  
        1,  
        1   
       );
       
    SELECT 
        'Executing as: ' + USER_NAME() AS ExecutionContext,
        @total_count AS TotalRedemptions,
        @most_active_user_id AS MostActiveUserID,
        @most_redeemed_benefit_id AS MostRedeemedBenefitID,
        'Audit log created successfully' AS Status;
END;
GO

-- Dar permiso de ejecución al procedimiento almacenado
GRANT EXECUTE ON solturadb.sp_SimpleAudit TO PUBLIC;
GO

-- Ejecutar con distintos períodos de tiempo al sp 
EXEC solturadb.sp_SimpleAudit @days = 30;
```
## 10 UNION 
```sql
-- UNION entre planes individuales y empresariales
SELECT 
    'Individual' AS TipoPlan, --Claramente vamos a ponerle a todos los que cumplan esto individual pues no tienen mas de 1 cuenta
    s.description AS NombrePlan, --Se trae el subscriptions description para ponerlo como el nombre del plan
    pp.amount AS Precio, --Se trae el precio 
    c.acronym AS Moneda --Como se trajo la tabla de currencies puede sacar el acronym (simbolo)
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid -- si plan prices subscription id coincide con un subscription id (para traerse la info de la subs id)
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid --Aca obtiene la currencie asociada a el plan price
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid -- obtiene el precio que matchea el plan person 
WHERE p.maxaccounts = 1 --Aca obtenemos los planes individuales al no tener mas de una cuenta en un plan personal
UNION --Una los datos encontrados anteriormente con los que vamos a encontrar ahora
SELECT 
    'Empresarial' AS TipoPlan, --Claramente vamos a ponerle a todos los que cumplan esto empresarial pues tienen mas de 1 cuenta
    s.description AS NombrePlan,--Se trae el subscriptions description para ponerlo como el nombre del plan
    pp.amount AS Precio, --Se trae el precio 
    c.acronym AS Moneda--Como se trajo la tabla de currencies puede sacar el acronym (simbolo)
FROM solturadb.soltura_planprices pp
JOIN solturadb.soltura_subscriptions s ON pp.subscriptionid = s.subscriptionid-- si plan prices subscription id coincide con un subscription id (para traerse la info de la subs id)
JOIN solturadb.soltura_currency c ON pp.currencyid = c.currencyid--Aca obtiene la currencie asociada a el plan price
JOIN solturadb.soltura_planperson p ON pp.planpricesid = p.planpricesid-- obtiene el precio que matchea el plan person 
WHERE p.maxaccounts > 1 --Se le va a traer SIEMPRE Y CUANDO SE CUMPLA que tenga varias cuentas asociadas no solo 1
ORDER BY TipoPlan, Precio; --Ordenara todo por el tipo del plan y de precio menor a mayor
```
---

# Mantenimiento de la Seguridad

## Usuario sin acceso del todo.
Para poder crear un usuario en la base de datos que **NO** tenga acceso, creamos un user asociado a un login de la siguiente forma:

![Create](assets/security_images/create-userNoacces.png)

Posteriormente nos vemos a 'status' y removemos el permiso de acceso.

![Create](assets/security_images/denyAccess-User.png)

Si se desea que del todo **NO** se pueda conectar, le quitamos el permiso al inicio de sesión.

![Create](assets/security_images/denyLogin.png)

## Usuario sin acceso al select.
Para empezar vamos a crear los usuarios:

```sql
-- Crear usuario con permisos para select 
CREATE LOGIN selectPermsLogin WITH PASSWORD = '123456';
CREATE USER selectPermsUser FOR LOGIN selectPermsLogin;

-- Crear usuario SIN select, este mae se mete a mi base de datos y lo demando -.- 
CREATE LOGIN noSelectPermsLogin WITH PASSWORD = '123456';
CREATE USER noSelectPermsUser FOR LOGIN noSelectPermsLogin;
```

Ahora creamos los roles y asignamos a los usuarios:
```sql
-- Rol con permiso de SELECT
CREATE ROLE rolSelect;

-- Rol sin permisos explícitos
CREATE ROLE rolNoSelect;

-- Asignar usuarios a roles
EXEC sp_addrolemember 'rolSelect', 'selectPermsUser';
EXEC sp_addrolemember 'rolNoSelect', 'noSelectPermsUser';
GO
```

Y aquí es dónde decidimos los permisos que un usuario puede tener, en este caso le doy select al de rolSelect en users.
```sql
GRANT SELECT ON solturadb.soltura_users TO rolSelect;
```

Si nosotros iniciamos con "noSelectPermsLogin" e intenteamos hacer el select, pasará lo siguiente:

![alt text](assets/security_images/noselecterror.png)

Por el contrario si iniciamos con el usuario que si tiene los permisos, y queremos corroborar las tablas, solo tiene acceso a user:

![alt text](assets/security_images/soloUsers.png)

Y si ejecutamos el select podremos ver que funciona correctamente:

![alt text](assets/security_images/workSelect.png)

## Rol usuario con acceso a SP, pero nada más
Entonces, si se desea que el usuario pueda usar un SP para ver una tabla, pero no darle accesos directos se puede hacer :D

Para no crear otro usuario, voy a usar el mismo que creamos antes de "noSelectPermsUser", este no tiene permisos de nada.

Y voy a crear un SP simple para ver la tabla de usuarios.
```sql
CREATE PROCEDURE sp_consultarUsers
WITH EXECUTE AS OWNER
AS
BEGIN
    SELECT * FROM solturadb.soltura_users;
END;
GO
```

Y ahora, al usuario, le vamos a dar permisos de usar el SP.
```sql
GRANT EXECUTE ON sp_consultarUsers TO noSelectPermsUser;
```

Entonces, si lo probamos, vamos a ver que ni si quiera reconoce la tabla que puse arriba para el select, pero si puedo ejecutar el SP.

![alt text](assets/security_images/spPerms.png)


## Ahora, RLS
Si se quiere implementar un Row Level Security, entonces:
Hago el ejemplo para que un usuario SOLO pueda tener sus datos de suscripcción.

- Primero se necesita crear la función "predicado", la cuál me permite escoger que filas accesa y cuáles no
```sql
CREATE OR ALTER FUNCTION [solturadb].[SecurityPredicatePlanperson](@UserId INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
    SELECT 1 AS result
    WHERE @UserId = CAST(SESSION_CONTEXT(N'UserId') AS INT);
GO
```

- Acá, se crea entonces la función predicado, lo que involucra crear ahora la política que nos permite el acecso

```sql
CREATE SECURITY POLICY [solturadb].[PlanpersonFilter]
ADD FILTER PREDICATE [solturadb].[SecurityPredicatePlanperson]([userid]) -- Filtra por el predicado que pusimos
ON [solturadb].[soltura_planperson_users]
WITH (STATE = ON);
GO
```
- Y por último se crea el contexto, que es lo que nos permite por medio de un SP, ejecutarlo 
  
```sql
CREATE OR ALTER PROCEDURE [solturadb].[SetUserContext]
    @UserId INT
AS
BEGIN
    EXEC sp_set_session_context @key = N'UserId', @value = @UserId;
END;
GO
```

Entonces, ya si se desea usar, en este caso, que puse el userId para no crear usuarios para probar un ejemplo:
```sql
EXEC [solturadb].[SetUserContext] @UserId = 1; -- Ponemos el contexto para el userId 1.

-- Se puede cambiar el userId para probar con otros usuarios.

-- Ahora, si el usuario 1 ejecuta un select a la tabla, solo verá sus datos.
SELECT pu.planpersonid, pu.userid, pp.acquisition, pp.enabled, s.description AS 'Plan'
FROM [solturadb].[soltura_planperson_users] pu
JOIN [solturadb].[soltura_planperson] pp ON pu.planpersonid = pp.planpersonid
JOIN [solturadb].[soltura_planprices] ppr ON pp.planpricesid = ppr.planpricesid
JOIN [solturadb].[soltura_subscriptions] s ON ppr.subscriptionid = s.subscriptionid;
```

Y lo vemos así:

![alt text](assets/security_images/rls.png)

## Ahora con el certificado, llave simétrica, asimétrica y cifrados

Como vimos en clase un certificado se usa para cifrar, firmar y proteger otros objetos o llaves.
Por otra parte las llaves asimétricas son similares, solo que no son 1:1.

Lo primero, es que hay que tener definido la master key, que por default no está.
```sql
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '123456'; -- La master key protege todo lo demás digamos.
GO
```

### Creada la master key, se puede crear el certificado:
```sql
CREATE CERTIFICATE CertificadoSoltura
WITH SUBJECT = 'Certificado para seguridad en Soltura',
EXPIRY_DATE = '2030-12-31';

SELECT * FROM sys.certificates WHERE name = 'CertificadoSoltura';
GO
```

Evidencia:

![alt text](assets/security_images/certificado.png)

### Crear llave asimétrica:
```sql
CREATE ASYMMETRIC KEY LlaveAsimSoltura
WITH ALGORITHM = RSA_2048; -- Esto es el algoritmo y cantidad de bits para cifrar, tmb existe: 512, 1024.
GO

SELECT * FROM sys.asymmetric_keys WHERE name = 'LlaveAsimSoltura';
```

Evidencia:

![alt text](assets/security_images/Asim.png)

### Crear llave simétrica:
```sql
-- Esta se puede crear cifrando con certificado o con una llave asimétrica:
-- 1) Con certificado:
CREATE SYMMETRIC KEY LlaveSimSoltura
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertificadoSoltura; 
GO

-- 2) Con llave asimétrica:
CREATE SYMMETRIC KEY LlaveSimSoltura2
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY LlaveAsimSoltura;
GO

SELECT * FROM sys.symmetric_keys WHERE name = 'LlaveSimSoltura';
```

Y se ve así:

![alt text](assets/security_images/Sim.png)


### Ahora para cifrar con la llave:
```sql
CREATE OR ALTER PROCEDURE [solturadb].[SP_CifrarPassword]
    @UserId INT,
    @Password NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM solturadb.soltura_users WHERE userid = @UserId)
    BEGIN
        RAISERROR('Usuario no encontrado', 16, 1);
        RETURN;
    END
    
    -- Abrir la llave simétrica
    OPEN SYMMETRIC KEY LlaveSimSoltura
    DECRYPTION BY CERTIFICATE CertificadoSoltura;
    
    -- Cifrar el password y actualizar el usuario
    UPDATE solturadb.soltura_users
    SET password = EncryptByKey(Key_GUID('LlaveSimSoltura'), @Password)
    WHERE userid = @UserId;
    
    -- Cerrar la llave
    CLOSE SYMMETRIC KEY LlaveSimSoltura;
    
    PRINT 'Contraseña cifrada y guardada correctamente';
END;
GO
```

### Para descrifrar usando las llaves:
```sql
CREATE OR ALTER PROCEDURE [solturadb].[SP_VerificarPassword]
    @UserId INT,
    @Password NVARCHAR(50),
    @EsCorrecta BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @EsCorrecta = 0;
    
    DECLARE @PasswordGuardado NVARCHAR(50);
    
    -- Abrir la llave simétrica
    OPEN SYMMETRIC KEY LlaveSimSoltura
    DECRYPTION BY CERTIFICATE CertificadoSoltura;
    
    -- Obtener y descifrar el password almacenado
    SELECT @PasswordGuardado = CONVERT(NVARCHAR(50), 
        DecryptByKey(password))
    FROM solturadb.soltura_users
    WHERE userid = @UserId;
    
    -- Cerrar la llave
    CLOSE SYMMETRIC KEY LlaveSimSoltura;
    
    -- Verificar la contraseña
    IF @PasswordGuardado = @Password
        SET @EsCorrecta = 1;
END;
GO
```

Un ejemplo de uso:
```sql
-- para cifrar una contraseña de un usuario:
EXEC solturadb.SP_CifrarPassword @UserId = 1, @Password = '1234567';

-- Y para verficar la contraseña de un usuario:
DECLARE @Resultado BIT;
EXEC solturadb.SP_VerificarPassword @UserId = 1, @Password = '1234567', @EsCorrecta = @Resultado OUTPUT;
SELECT @Resultado AS PasswordCorrecto;
```
---
# Consultas Misceláneas
## Vista indexada dínamica
```sql
--La vista indexada
CREATE VIEW solturadb.vw_UserSubscriptionDetails
WITH SCHEMABINDING
AS
SELECT 
    u.userid,
    u.firstname,
    u.lastname,
    pp.planpersonid,
    s.subscriptionid,
    s.description AS subscription_description,
    ppr.amount AS subscription_price,
    ppr.currencyid,
    b.benefitsid,
    b.name AS benefit_name,
    b.description AS benefit_description,
    b.availableuntil
FROM 
    solturadb.soltura_users u
JOIN 
    solturadb.soltura_planperson_users ppu ON u.userid = ppu.userid
JOIN 
    solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
JOIN 
    solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
JOIN 
    solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
JOIN 
    solturadb.soltura_benefits b ON pp.planpersonid = b.planpersonid;
GO


CREATE UNIQUE CLUSTERED INDEX IX_vw_UserSubscriptionDetails
ON solturadb.vw_UserSubscriptionDetails (userid, planpersonid, benefitsid);
GO



-- Para probar que es dinámica hacemos esta inserción

INSERT INTO solturadb.soltura_benefits
    (enabled, name, description, availableuntil, planpersonid, categorybenefitsid, contractDetailId, benefitTypeId, benefitSubTypeId)
VALUES
    (0x01, 'Nuevo Beneficio', 'Descripción del nuevo beneficio', '2026-12-31', 1, 1, 1, 1, 1);
GO

-- Consultar la vista para verificar que el nuevo beneficio aparece
SELECT *
FROM solturadb.vw_UserSubscriptionDetails
WHERE planpersonid = 1;
GO
```

## Procedimiento almacenado transaccional

```sql

-- Procedimiento
CREATE PROCEDURE solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription NVARCHAR(255),
    @LogoUrl NVARCHAR(255),
    @Amount DECIMAL(10, 2),
    @CurrencyId INT,
    @RecurrencyType SMALLINT, 
    @UserId INT,
    @MaxAccounts INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        
        BEGIN TRANSACTION;

        -- 1. Tabla 1
        DECLARE @SubscriptionId INT;
        INSERT INTO solturadb.soltura_subscriptions ([description], [logourl])
        VALUES (@SubscriptionDescription, @LogoUrl);
        SET @SubscriptionId = SCOPE_IDENTITY();

        -- 2. Tabla 2
        DECLARE @PlanPriceId INT;
        INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
        VALUES (@Amount, @RecurrencyType, GETDATE(), '2026-01-01', 0x01, @CurrencyId, @SubscriptionId);
        SET @PlanPriceId = SCOPE_IDENTITY();

        -- 3. Tabla 3
        INSERT INTO solturadb.soltura_planperson (acquisition, enabled, scheduleid, planpricesid, expirationdate, maxaccounts)
        VALUES (GETDATE(), 0x01, 1, @PlanPriceId, DATEADD(YEAR, 1, GETDATE()), @MaxAccounts);

     
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO




-- Prueba
EXEC solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription = 'Plan Familiar',
    @LogoUrl = 'https://soltura.com/images/plans/plan-familiar.png',
    @Amount = 49.99,
    @CurrencyId = 1, 
    @RecurrencyType = 1,
    @UserId = 1,
    @MaxAccounts = 5;

SELECT * FROM solturadb.soltura_planperson WHERE planpricesid = (SELECT planpricesid FROM solturadb.soltura_planprices WHERE subscriptionid = (SELECT subscriptionid FROM solturadb.soltura_subscriptions WHERE [description] = 'Plan Familiar'));

```

## Consulta con CASE para agrupamiento

```sql

-- Agrupa según el tipo de plan, cuántos hay de cada uno y su tipo (individuales, grupo pequeño o grande)
SELECT 
    s.description AS [Plan],
    COUNT(DISTINCT pp.planpersonid) AS TotalPlanes,
    CASE 
        WHEN pp.maxaccounts = 1 THEN 'Individual'
        WHEN pp.maxaccounts BETWEEN 2 AND 4 THEN 'Grupo pequeño'
        WHEN pp.maxaccounts > 4 THEN 'Grupo grande'
        ELSE 'Sin Clasificar'
    END AS TipoPlan
FROM 
    solturadb.soltura_planperson pp
JOIN 
    solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
JOIN 
    solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
GROUP BY 
    s.description,
    CASE 
        WHEN pp.maxaccounts = 1 THEN 'Individual'
        WHEN pp.maxaccounts BETWEEN 2 AND 4 THEN 'Grupo pequeño'
        WHEN pp.maxaccounts > 4 THEN 'Grupo grande'
        ELSE 'Sin Clasificar'
    END
ORDER BY 
    TipoPlan, [Plan];
```

## Consulta compleja optimizada

```sql

--OG
use soltura
go 
WITH BeneficiosPopulares AS (
   
    SELECT 
        b.benefitsid,
        b.name,
        COUNT(r.redemptionid) AS redemption_count
    FROM solturadb.soltura_benefits b
    JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    WHERE EXISTS (
        SELECT 1 FROM solturadb.soltura_planperson pp 
        WHERE pp.planpersonid = b.planpersonid
    )
    GROUP BY b.benefitsid, b.name
    HAVING COUNT(r.redemptionid) > 0
),

PlanesConUsuarios AS (
   
    SELECT 
        pp.planpricesid,
        COUNT(DISTINCT ppu.userid) AS user_count
    FROM solturadb.soltura_planperson pp
    JOIN solturadb.soltura_planperson_users ppu ON pp.planpersonid = ppu.planpersonid
    WHERE pp.planpricesid NOT IN (
        SELECT planpricesid 
        FROM solturadb.soltura_planprices 
        WHERE amount <= 0
    )
    GROUP BY pp.planpricesid
),

RedencionesPorPlan AS (
   
    SELECT 
        pp.planpricesid,
        COUNT(r.redemptionid) AS redemption_count,
        CONVERT(VARCHAR(10), MAX(r.date), 120) AS last_redemption_date
    FROM solturadb.soltura_redemptions r
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
    GROUP BY pp.planpricesid
)

SELECT 
    s.subscriptionid,
    s.description AS plan_name,
    
    AVG(pp.amount) AS average_price,
    SUM(CASE 
        WHEN pc.user_count > 100 THEN 1 
        ELSE 0 
    END) AS popular_plans_count,
    
    CONVERT(VARCHAR(10), 
        CASE 
            WHEN AVG(pp.amount) < 20 THEN 'Económico'
            WHEN AVG(pp.amount) BETWEEN 20 AND 50 THEN 'Estándar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bp.name AS most_popular_benefit,
    rp.last_redemption_date
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN PlanesConUsuarios pc ON pp.planpricesid = pc.planpricesid
LEFT JOIN RedencionesPorPlan rp ON pp.planpricesid = rp.planpricesid
LEFT JOIN (
    SELECT TOP 1 b.* 
    FROM BeneficiosPopulares b
    ORDER BY b.redemption_count DESC
) bp ON 1=1 
WHERE pc.user_count > 0
GROUP BY 
    s.subscriptionid,
    s.description,
    bp.name,
    rp.last_redemption_date,
    pc.user_count
HAVING AVG(pp.amount) > 0 
ORDER BY 
    price_category DESC,
    average_price DESC;



-- OPTIMIZADA
WITH BeneficiosPopulares AS (
    SELECT 
        b.benefitsid,
        b.name,
        COUNT(r.redemptionid) AS redemption_count
    FROM solturadb.soltura_benefits b
    JOIN solturadb.soltura_redemptions r ON b.benefitsid = r.benefitsid
    WHERE EXISTS (
        SELECT 1 FROM solturadb.soltura_planperson pp 
        WHERE pp.planpersonid = b.planpersonid
    )
    GROUP BY b.benefitsid, b.name
    HAVING COUNT(r.redemptionid) > 0
),

PlanesConUsuarios AS (
    SELECT 
        pp.planpricesid, 
        COUNT(DISTINCT ppu.userid) AS user_count
    FROM solturadb.soltura_planperson pp
    JOIN solturadb.soltura_planperson_users ppu ON pp.planpersonid = ppu.planpersonid
    WHERE pp.planpricesid NOT IN (
        SELECT planpricesid 
        FROM solturadb.soltura_planprices 
        WHERE amount <= 0
    )
    GROUP BY pp.planpricesid
),

RedencionesPorPlan AS (
    SELECT 
        pp.planpricesid,  

        COUNT(r.redemptionid) AS redemption_count,
        CONVERT(VARCHAR(10), MAX(r.date), 120) AS last_redemption_date
    FROM solturadb.soltura_redemptions r
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
    GROUP BY pp.planpricesid
)

SELECT 
    s.subscriptionid,
    s.description AS plan_name,
    AVG(pp.amount) AS average_price,
    SUM(CASE 
        WHEN pc.user_count > 100 THEN 1 
        ELSE 0 
    END) AS popular_plans_count,
    CONVERT(VARCHAR(10), 
        CASE 
            WHEN AVG(pp.amount) < 20 THEN 'Económico'
            WHEN AVG(pp.amount) BETWEEN 20 AND 50 THEN 'Estándar'
            ELSE 'Premium'
        END
    ) AS price_category,
    bp.name AS most_popular_benefit,
    rp.last_redemption_date
FROM solturadb.soltura_subscriptions s
JOIN solturadb.soltura_planprices pp ON s.subscriptionid = pp.subscriptionid
JOIN PlanesConUsuarios pc ON pp.planpricesid = pc.planpricesid
LEFT JOIN RedencionesPorPlan rp ON pp.planpricesid = rp.planpricesid
LEFT JOIN (
    SELECT TOP 1 b.* 
    FROM BeneficiosPopulares b
    ORDER BY b.redemption_count DESC
) bp ON 1=1 
WHERE pc.user_count > 0
GROUP BY 
    s.subscriptionid,
    s.description,
    bp.name,
    rp.last_redemption_date,
    pc.user_count
HAVING AVG(pp.amount) > 0 
ORDER BY 
    price_category DESC,
    average_price DESC;

```


## Consulta con operaciones EXCEPT Y INTERSECT

```sql
WITH UsuariosConPlanes AS (
    SELECT DISTINCT u.userid
    FROM solturadb.soltura_users u
    JOIN solturadb.soltura_planperson_users ppu ON u.userid = ppu.userid
    JOIN solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
    JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
),


UsuariosConRedenciones AS (
    SELECT DISTINCT u.userid
    FROM solturadb.soltura_users u
    JOIN solturadb.soltura_redemptions r ON u.userid = r.userid
    JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
    JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
),

-- Intersección: Usuarios con planes Y redenciones, acá usamos el INTERSECT
Interseccion AS (
    SELECT userid FROM UsuariosConPlanes
    INTERSECT
    SELECT userid FROM UsuariosConRedenciones
),

-- Para las diferencias note que en SQL no se usa SET DIFFERENCE, sino EXCEPT pero cumple el mismo propósito

-- Diferencia 1: Usuarios con planes PERO SIN redenciones
PlanesSinRedenciones AS (
    SELECT userid FROM UsuariosConPlanes
    EXCEPT
    SELECT userid FROM UsuariosConRedenciones
),

-- Diferencia 2: Usuarios con redenciones PERO SIN planes 
RedencionesSinPlanes AS (
    SELECT userid FROM UsuariosConRedenciones
    EXCEPT
    SELECT userid FROM UsuariosConPlanes
)

-- Agrupamos para que la consulta se vea más linda
SELECT 
    'INTERSECTION: Usuarios con planes Y redenciones' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM Interseccion

UNION ALL

SELECT 
    'SET DIFFERENCE: Usuarios con planes PERO SIN redenciones' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM PlanesSinRedenciones

UNION ALL

SELECT 
    'SET DIFFERENCE: Usuarios con redenciones PERO SIN planes' AS categoria,
    COUNT(*) AS total_usuarios,
    STRING_AGG(CAST(userid AS VARCHAR), ', ') AS lista_userids
FROM RedencionesSinPlanes;
```

## Procedimientos almacenados anidados
```sql
USE soltura;
GO
CREATE PROCEDURE [solturadb].[SP_DesactivarSchedules]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
      
        UPDATE solturadb.soltura_schedules
        SET enddate = GETDATE() -- Finalizar el schedule al poner la enddate en el presente
        WHERE scheduleid IN (
            SELECT DISTINCT scheduleid
            FROM solturadb.soltura_planperson
            WHERE planpersonid IN (
                SELECT DISTINCT planpersonid
                FROM solturadb.soltura_benefits
                WHERE categorybenefitsid = @CategoryId
            )
        );

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO

CREATE PROCEDURE [solturadb].[SP_DesactivarSuscripcionesYPlanes]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
        -- Desactivar los planes asociados a los beneficios de la categoría
        UPDATE solturadb.soltura_planperson
        SET enabled = 0x00
        WHERE planpersonid IN (
            SELECT DISTINCT planpersonid
            FROM solturadb.soltura_benefits
            WHERE categorybenefitsid = @CategoryId
        );

        -- Desactivar las suscripciones asociadas a los planes
        UPDATE solturadb.soltura_subscriptions
        SET [description] = CONCAT([description], ' - Desactivada')
        WHERE subscriptionid IN (
            SELECT DISTINCT ppr.subscriptionid
            FROM solturadb.soltura_planprices ppr
            JOIN solturadb.soltura_planperson pp ON ppr.planpricesid = pp.planpricesid
            WHERE pp.planpersonid IN (
                SELECT DISTINCT planpersonid
                FROM solturadb.soltura_benefits
                WHERE categorybenefitsid = @CategoryId
            )
        );

       
        EXEC [solturadb].[SP_DesactivarSchedules] @CategoryId;

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE [solturadb].[SP_DesactivarCategoria]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT;
    DECLARE @InicieTransaccion BIT = 0;

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
        -- Desactivar la categoría
        UPDATE solturadb.soltura_categorybenefits
        SET enabled = 0x00
        WHERE categorybenefitsid = @CategoryId;

        -- Desactivar los beneficios asociados a la categoría
        UPDATE solturadb.soltura_benefits
        SET enabled = 0x00
        WHERE categorybenefitsid = @CategoryId;

        -- Llamar al procedimiento para desactivar schedules
        EXEC [solturadb].[SP_DesactivarSchedules] @CategoryId;

        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        THROW;
    END CATCH;
END;
GO


--PRUEBAS


-- exitosa
SELECT 
    cb.categorybenefitsid AS CategoriaID,
    cb.name AS Categoria,
    cb.enabled AS CategoriaHabilitada,
    b.benefitsid AS BeneficioID,
    b.name AS Beneficio,
    b.enabled AS BeneficioHabilitado,
    pp.planpersonid AS PlanPersonID,
    pp.enabled AS PlanHabilitado,
    s.subscriptionid AS SuscripcionID,
    s.description AS Suscripcion,
    sch.scheduleid AS ScheduleID,
    sch.enddate AS ScheduleEndDate
FROM solturadb.soltura_categorybenefits cb
LEFT JOIN solturadb.soltura_benefits b ON cb.categorybenefitsid = b.categorybenefitsid
LEFT JOIN solturadb.soltura_planperson pp ON b.planpersonid = pp.planpersonid
LEFT JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
LEFT JOIN solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
LEFT JOIN solturadb.soltura_schedules sch ON pp.scheduleid = sch.scheduleid
WHERE cb.categorybenefitsid = 999 --CAMBIAR ID DEPENDIENDO DE LA PRUEBA!!!
ORDER BY cb.categorybenefitsid, b.benefitsid, pp.planpersonid, s.subscriptionid, sch.scheduleid;

EXEC [solturadb].[SP_DesactivarCategoria] @CategoryId = 2; -- ID de prueba

-- correr de nuevo el select para ver que ahora todo está deshabilitado


-- fallido
EXEC [solturadb].[SP_DesactivarCategoria] @CategoryId = 999; -- ID inexistente
-- correr el select con 999 y ver que no da nada, pero no hay errores por el rollback y try/catch
```
## Consulta sobre obtener un JSON
Si es posible generar un JSON mediante una consulta SQL entonces, digamos por ejemplo, la pantalla de “Dashboard del Usuario” podría requerir esta consulta para mostrar de forma estructurada los planes activos del usuario, sus beneficios asociados, el historial de redenciones recientes y la información de precios y proveedores.
```sql
-- Consulta para generar JSON de dashboard de planes del usuario
DECLARE @UserID INT = 1;  

SELECT 
    u.userid,
    u.userid AS user_id,  
    JSON_QUERY(( -- Esto es un subquery para obtener las suscripciones del usuario
        SELECT 
            pp.planpersonid,
            pp.acquisition AS subscription_date,
            pp.expirationdate AS expiration_date,
            CAST(CASE WHEN pp.enabled = 0x01 THEN 1 ELSE 0 END AS BIT) AS is_active,
            s.description AS plan_name,
            s.logourl AS plan_logo,
            ppr.amount AS price,
            ISNULL(c.symbol, '$') + ' ' + CAST(ppr.amount AS NVARCHAR) AS formatted_price,
            ISNULL(c.acronym, 'USD') AS currency_code,
            (
                SELECT 
                    b.benefitsid,
                    b.name AS benefit_name,
                    b.description AS benefit_description,
                    cb.name AS category_name,
                    bt.name AS benefit_type,
                    bst.name AS benefit_subtype,
                    cd.companyPercentage AS discount_percentage,
                    ac.name AS provider_name,
                    (
                        SELECT TOP 1 value 
                        FROM solturadb.soltura_companiesContactinfo ci 
                        WHERE ci.associatedCompaniesid = ac.associatedCompaniesid 
                        AND ci.companyinfotypeId = (SELECT companyinfotypeId FROM solturadb.soltura_companyinfotypes WHERE name = 'Sitio Web')
                    ) AS provider_website
                FROM solturadb.soltura_benefits b
                JOIN solturadb.soltura_categorybenefits cb ON b.categorybenefitsid = cb.categorybenefitsid
                JOIN solturadb.soltura_contractDetails cd ON b.contractDetailId = cd.contractDetailid
                JOIN solturadb.soltura_contracts c ON cd.contractid = c.contractid
                JOIN solturadb.soltura_associatedCompanies ac ON c.associatedCompaniesid = ac.associatedCompaniesid
                LEFT JOIN dbo.soltura_benefitTypes bt ON b.benefitTypeId = bt.benefitTypeId
                LEFT JOIN dbo.soltura_benefitSubTypes bst ON b.benefitSubTypeId = bst.benefitSubTypeId
                WHERE b.planpersonid = pp.planpersonid
                FOR JSON PATH
            ) AS benefits
        FROM solturadb.soltura_planperson_users ppu
        JOIN solturadb.soltura_planperson pp ON ppu.planpersonid = pp.planpersonid
        JOIN solturadb.soltura_planprices ppr ON pp.planpricesid = ppr.planpricesid
        JOIN solturadb.soltura_subscriptions s ON ppr.subscriptionid = s.subscriptionid
        LEFT JOIN solturadb.soltura_currency c ON ppr.currencyid = c.currencyid
        WHERE ppu.userid = u.userid
        FOR JSON PATH
    )) AS subscriptions,
    (SELECT COUNT(*) FROM solturadb.soltura_planperson_users ppu WHERE ppu.userid = u.userid) AS total_plans,
    (
        SELECT TOP 5
            r.redemptionid,
            r.date AS redemption_date,
            b.name AS benefit_name,
            ac.name AS provider_name,
            rm.name AS redemption_method
        FROM solturadb.soltura_redemptions r
        JOIN solturadb.soltura_benefits b ON r.benefitsid = b.benefitsid
        JOIN solturadb.soltura_redemptionMethods rm ON r.redemptionMethodsid = rm.redemptionMethodsid
        JOIN solturadb.soltura_contractDetails cd ON b.contractDetailId = cd.contractDetailid
        JOIN solturadb.soltura_contracts c ON cd.contractid = c.contractid
        JOIN solturadb.soltura_associatedCompanies ac ON c.associatedCompaniesid = ac.associatedCompaniesid
        WHERE r.userid = u.userid
        ORDER BY r.date DESC
        FOR JSON PATH
    ) AS recent_redemptions
FROM solturadb.soltura_users u
WHERE u.userid = @UserID
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER; -- Y esto devuelve el JSON, lo del without_array_wrapper es para que no devuelva un array, sino un objeto JSON
```

##  SP transaccional que Actualice los contratos
```sql
USE soltura;
GO

-- Tipo de tabla simplificado para detalles de contrato
CREATE TYPE solturadb.ContractDetailsType AS TABLE (
    DetailId INT NULL,              
    Name NVARCHAR(30) NOT NULL,
    Description NVARCHAR(100) NOT NULL,
    Price REAL NOT NULL,
    SolturaPercentage REAL NOT NULL,
    CompanyPercentage REAL NOT NULL
);
GO

-- Procedimiento simplificado para actualizar contratos
CREATE OR ALTER PROCEDURE solturadb.SP_UpdateProviderContract
    @CompanyName NVARCHAR(20),              
    @AddressId INT,                         
    @ContractName NVARCHAR(30),            
    @ExpirationDate DATETIME2(0),          
    @ContractDetails solturadb.ContractDetailsType READONLY  
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CompanyId INT;
    DECLARE @ContractId INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Verificar/insertar proveedor
        SELECT @CompanyId = associatedCompaniesid 
        FROM solturadb.soltura_associatedCompanies 
        WHERE name = @CompanyName;
        
        IF @CompanyId IS NULL
        BEGIN
            INSERT INTO solturadb.soltura_associatedCompanies (name, addressId)
            VALUES (@CompanyName, @AddressId);
            SET @CompanyId = SCOPE_IDENTITY();
        END
        
        -- 2. Verificar/insertar contrato
        SELECT @ContractId = contractid 
        FROM solturadb.soltura_contracts 
        WHERE associatedCompaniesid = @CompanyId AND name = @ContractName;
        
        IF @ContractId IS NULL
        BEGIN
            INSERT INTO solturadb.soltura_contracts (name, date, expirationdate, associatedCompaniesid)
            VALUES (@ContractName, GETDATE(), @ExpirationDate, @CompanyId);
            SET @ContractId = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE solturadb.soltura_contracts
            SET expirationdate = @ExpirationDate
            WHERE contractid = @ContractId;
        END
        
        -- 3. Procesar detalles del contrato
        UPDATE cd
        SET cd.name = src.Name,
            cd.description = src.Description,
            cd.price = src.Price,
            cd.solturaPercentage = src.SolturaPercentage,
            cd.companyPercentage = src.CompanyPercentage
        FROM solturadb.soltura_contractDetails cd
        JOIN @ContractDetails src ON cd.contractDetailid = src.DetailId
        WHERE src.DetailId IS NOT NULL;
        
        -- Insertar nuevos detalles
        INSERT INTO solturadb.soltura_contractDetails 
            (name, description, contractid, price, solturaPercentage, companyPercentage)
        SELECT 
            Name, Description, @ContractId, Price, SolturaPercentage, CompanyPercentage
        FROM @ContractDetails
        WHERE DetailId IS NULL;
        
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Este crea un nuevo contrato y actualiza los detalles del contrato
DECLARE @ContractDetails solturadb.ContractDetailsType;

INSERT INTO @ContractDetails (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (NULL, 'Descuento Básico', 'Descuento para todos los clientes', 25.00, 20.00, 80.00),
    (NULL, 'Servicio Premium', 'Servicio avanzado mensual', 75.00, 20.00, 80.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31',
    @ContractDetails = @ContractDetails;


-- Este actualiza un contrato existente y sus detalles
DECLARE @NuevaClausula solturadb.ContractDetailsType;

INSERT INTO @NuevaClausula (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (NULL, 'Cláusula de Exclusividad', 
     'El proveedor se compromete a no ofrecer descuentos similares a otras plataformas por 6 meses', 
     0.00, 50.00, 50.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31', 
    @ContractDetails = @NuevaClausula;


-- Ejemplo para editar una cláusula existente
DECLARE @EditarClausula solturadb.ContractDetailsType;

DECLARE @ClausulaId INT = 3;

INSERT INTO @EditarClausula (DetailId, Name, Description, Price, SolturaPercentage, CompanyPercentage)
VALUES 
    (@ClausulaId, 'Cláusula de Exclusividad Modificada', 
     'El proveedor se compromete a no ofrecer descuentos similares a otras plataformas por 12 meses', 
     0.00, 60.00, 40.00);

EXEC solturadb.SP_UpdateProviderContract
    @CompanyName = 'Proveedor Simple',
    @AddressId = 1,
    @ContractName = 'Contrato Básico',
    @ExpirationDate = '2025-12-31',
    @ContractDetails = @EditarClausula;

```

## Consulta y exportar a CSV.
Es posible exportar a .csv, pero se ocupa hacerlo uno digamos,
entonces hay un pequeño script para conseguir las empresas y los contactos de empresas.
```sql
-- Script para unir Empresa con su contacto y su tipo de contacto. Para exportar a CSV.
USE soltura;
GO

SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM solturadb.soltura_associatedCompanies)
BEGIN
    RETURN;
END

SELECT 'ID_Empresa,Nombre_Empresa,Tipo_Contacto,Valor_Contacto,Ultima_Actualizacion' AS CsvRow
UNION ALL
SELECT 
    CAST(ac.associatedCompaniesid AS VARCHAR) + ',' + 
    '"' + REPLACE(ac.name, '"', '""') + '",' + 
    '"' + REPLACE(cit.name, '"', '""') + '",' + 
    '"' + REPLACE(CAST(ci.value AS VARCHAR), '"', '""') + '",' + 
    '"' + CONVERT(VARCHAR, ci.lastupdate, 120) + '"'
FROM solturadb.soltura_associatedCompanies ac
JOIN solturadb.soltura_companiesContactinfo ci ON ac.associatedCompaniesid = ci.associatedCompaniesid
JOIN solturadb.soltura_companyinfotypes cit ON ci.companyinfotypeId = cit.companyinfotypeId
WHERE ci.enabled = 0x01;
GO
```

Pero para exportar es necesario dar clic derecho en los resultados y seleccionar "Guardar resultados como":

![alt text](assets/consultas_miscelaneas/save.png)

Y finalmente nos sale que es de tipo .csv

![alt text](assets/consultas_miscelaneas/saveName.png)


## Bitácora en otro SQL Server.

Por supuesto, di hay que crear otro servidor, entonces, por docker:
```powershell
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Soltura12345" -p 1434:1433 --name sql_bitacora -d mcr.microsoft.com/mssql/server:2019-latest 
```
Una vez instanciado el nuevo servidor.

En ese servidor, creo entonces la tabla de Bitacora
```sql
CREATE DATABASE BitacoraDB;
GO

USE BitacoraDB;
GO

CREATE TABLE dbo.BitacoraEventos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sp NVARCHAR(100),
    mensaje NVARCHAR(MAX),
    fecha DATETIME DEFAULT GETDATE()
);
GO
```

Una vez creado, utilizamos el LinkedServer para poder vincular los servidores de SQL. La idea es que, si se ejecuta se siga tal y como se ha puesto, sería solo ejecutar.
Aunque, si por a o b anteriormente, tuvieron que usar un puerto distinto, cambiarlo en el @datasrc, al igual que el @provider para T-SQL por default es SQLNCLI.
```sql
EXEC sp_addlinkedserver 
    @server = 'LinkedBitacora', 
    @srvproduct = '',
    @provider = 'SQLNCLI', 
    @datasrc = 'localhost,1434';

-- Configura login para conectarse al servidor remoto
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'LinkedBitacora',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'sa',
    @rmtpassword = 'Soltura12345';


SELECT * FROM OPENQUERY(LinkedBitacora, 'SELECT name FROM sys.databases');
```

Ahora, como la pregunta dice, vamos a hacer el SP genérico, así cualquier otro puede usarlo y dejar log.
```sql
CREATE PROCEDURE solturadb.sp_RegistrarBitacoraLinked
    @NombreSP NVARCHAR(128),
    @Mensaje NVARCHAR(MAX),
    @Severity INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO LinkedBitacora.BitacoraDB.dbo.BitacoraEventos (nombre_sp, mensaje, fecha)
        VALUES (@NombreSP, @Mensaje, SYSDATETIME());
    END TRY
    BEGIN CATCH
    END CATCH
END;
```
------
Es importante. La conexión entre los servidores puede no ocurrir por el error de DTC, me sucedió a mí, para solucionarlo:
1. Verificación del Servicio Distributed Transaction Coordinator (DTC)
Acceder al Panel de Servicios:

Presione Windows + R para abrir el cuadro de diálogo "Ejecutar".
Escriba services.msc y presione Enter.
Buscar el Servicio DTC:

En la lista de servicios, busque "Distributed Transaction Coordinator".
Asegúrese de que el estado del servicio sea "Running". Si no está en ejecución, haga clic derecho sobre el servicio y seleccione "Iniciar".

2. Configuración de DTC
Abrir Component Services:

Busque "Component Services" en el menú de inicio y ábralo.
Navegar a la Configuración de DTC:

En el panel de navegación, expanda Component Services -> Computers -> My Computer -> Distributed Transaction Coordinator.
Modificar Propiedades de Local DTC:

Haga clic derecho en "Local DTC" y seleccione "Properties".
Configurar la Pestaña de Seguridad:

En la pestaña "Security", asegúrese de que las siguientes opciones estén habilitadas:
Network DTC Access: Habilitar el acceso a DTC a través de la red.
Allow Remote Clients: Permitir que los clientes remotos accedan al DTC.
Allow Inbound: Permitir conexiones entrantes.
Allow Outbound: Permitir conexiones salientes.
Asegúrese de que la opción No Authentication Required esté seleccionada, o que la opción de autenticación sea compatible con su configuración de seguridad.
Aplicar Cambios:

Haga clic en "OK" para aplicar los cambios realizados en la configuración de DTC.

------

Ahora sí

Entonces, ahora para probarlo, usaremos, el SP que habíamos creado en CM_SPTransaccional con unos ligeros cambios.
```sql
IF OBJECT_ID('solturadb.sp_RegistrarNuevoPlan', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_RegistrarNuevoPlan;
GO

CREATE PROCEDURE solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription NVARCHAR(255),
    @LogoUrl NVARCHAR(255),
    @Amount DECIMAL(10, 2),
    @CurrencyId INT,
    @RecurrencyType SMALLINT, 
    @UserId INT,
    @MaxAccounts INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Insertar en Subscriptions
        DECLARE @SubscriptionId INT;
        INSERT INTO solturadb.soltura_subscriptions ([description], [logourl])
        VALUES (@SubscriptionDescription, @LogoUrl);
        SET @SubscriptionId = SCOPE_IDENTITY();

        -- 2. Insertar en PlanPrices
        DECLARE @PlanPriceId INT;
        INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
        VALUES (@Amount, @RecurrencyType, GETDATE(), '2026-01-01', 0x01, @CurrencyId, @SubscriptionId);
        SET @PlanPriceId = SCOPE_IDENTITY();

        -- 3. Insertar en PlanPerson
        INSERT INTO solturadb.soltura_planperson (acquisition, enabled, scheduleid, planpricesid, expirationdate, maxaccounts)
        VALUES (GETDATE(), 0x01, 1, @PlanPriceId, DATEADD(YEAR, 1, GETDATE()), @MaxAccounts);

        COMMIT TRANSACTION;

        -- Registro exitoso en la bitácora
        DECLARE @SuccessMessage NVARCHAR(MAX);
        SET @SuccessMessage = N'Registro exitoso de nuevo plan: ' + @SubscriptionDescription; 

        EXEC solturadb.sp_RegistrarBitacoraLinked  --- Desde aquí entonces llamamos el SP para dejar log.
            @NombreSP = 'sp_RegistrarNuevoPlan', 
            @Mensaje = @SuccessMessage, 
            @Severity = 0; -- 0 para indicar éxito

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        EXEC solturadb.sp_RegistrarBitacoraLinked 
            @NombreSP = 'sp_RegistrarNuevoPlan', 
            @Mensaje = @ErrorMessage, 
            @Severity = @ErrorSeverity;

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END;
GO
```
Ejecutamos una prueba (la misma del archivo CM_SPTransaccional.sql)
```sql
-- Prueba
EXEC solturadb.sp_RegistrarNuevoPlan
    @SubscriptionDescription = 'Plan Familiar',
    @LogoUrl = 'https://soltura.com/images/plans/plan-familiar.png',
    @Amount = 49.99,
    @CurrencyId = 1, 
    @RecurrencyType = 1,
    @UserId = 1,
    @MaxAccounts = 5;
```

Y desde la otra base de datos obtenemos:
![alt text](assets/consultas_miscelaneas/linked.png)

Y como se observa se creo el log :)

---



# Concurrencia
## Deadlocks entre Dos Transacciones
Primero ejectuamos este query que pedira de acceder a benefits pero benefits estara bloqueada por El segundo query que pedira redemptions pero Redemptions es ocupado por el primero entonces se vuelve una victima del deadlock.
```sql
USE soltura;
GO
--Transaccion Primera
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0 WHERE benefitsid = 1; -- Bloquea benefits hasta que se haga el commit

WAITFOR DELAY '00:00:05';

-- Ocupa redemptions para acabar pero redemptions esta bloqueada por una que ocupa benefits lo que implica que nunca podra salir
UPDATE solturadb.soltura_redemptions SET reference1 = 99999 WHERE userid = 1;

COMMIT;
```
```sql
USE soltura;
GO
--Transaccion Segunda
BEGIN TRANSACTION;
-- Bloquea redemptions.
UPDATE solturadb.soltura_redemptions SET reference1 = 88888 WHERE userid = 1;

-- Da tiempo para que la otra bloque benefits
WAITFOR DELAY '00:00:05';

-- Ocupa benefits para acabar pero benefits esta bloqueada por una que ocupa redemptions lo que implica que nunca podra salir
UPDATE solturadb.soltura_benefits SET enabled = 1 WHERE benefitsid = 1;
COMMIT;
```
Dara un error:
![image](https://github.com/user-attachments/assets/1486abd4-65b3-48e1-8cd6-d13c10d1bdc6)
## Deadlocks en Cascada
Este deadlock es interesante porque se bloquea al A ocupar users que esta siendo usado por C y C ocupa lo que esta usando B y B ocupa lo que esta usando A, como una serpiente comiendose la cola.
```sql
USE soltura;
GO
--Transaccion A
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0 WHERE benefitsid = 1; -- Bloquea benefits hasta que se haga el commit, lo que ocupa B

WAITFOR DELAY '00:00:08';

-- Se bloquea al A ocupar users que esta siendo usado por C y C ocupa lo que esta usando B y B ocupa lo que esta usando A
UPDATE solturadb.soltura_users SET email = 'deadlocklover@gmail.com' WHERE userid = 1;
COMMIT;

```
```sql
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
```
```sql
USE soltura;
GO
--Transaccion C
BEGIN TRANSACTION;
UPDATE solturadb.soltura_users SET email = 'deadlockhater@gmail.com' WHERE userid = 1; -- Bloquea user hasta que se haga el commit. Que lo ocupa A

WAITFOR DELAY '00:00:08';

-- Se bloquea al C ocupar redemptions que esta siendo usado por B y B ocupa lo que esta usando A y A ocupa lo que esta usando C
UPDATE solturadb.soltura_redemptions SET reference1 = 99999 WHERE userid = 1;
COMMIT;
```
Dara el siguiente error en B: ![image](https://github.com/user-attachments/assets/fea881f0-4a14-41b0-ac97-77274cf7314e)
![WhatsApp Image 2025-05-03 at 11 37 00_3230305a](https://github.com/user-attachments/assets/81437f7a-df22-4421-9810-62a97bc7596b)
## Niveles de Isolacion
NIVEL READ UNCOMMITTED: TIENE PROBLEMAS DE LECTURAS SUCIAS, NONREPETABLE READ Y LECTURAS FANTASMAS
```sql
UPDATE solturadb.soltura_benefits SET enabled = 0x01 WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (A) READ UNCOMMITTED
--READ UNCOMMITED ERROR READ DIRTY
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x00 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) READ UNCOMMITTED
--READ UNCOMMITTED ERROR NONREPETABLE READ
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR SEGUNDO
--EJECUTAR (C) READ UNCOMMITTED
--READ UNCOMMITTED ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (D) READ UNCOMMITTED
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS no los genera al ser read uncommitted
BEGIN TRANSACTION;
-- Intentar insertar un nuevo precio pero tardara un montoooooon al esperar ese bloqueo prolongado que trae Serializable
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;
```
```sql
--EJECUTAR (A) READ UNCOMMITTED
--READ UNCOMMITED ERROR READ DIRTY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; --Cambiamos a 0x01 el bit en la otra transaccion entonces este lo llega a leer pero como nunca hace commit lo que leyo la transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (B) READ UNCOMMITTED
--READ UNCOMMITED ERROR NONREPETABLE READ
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
-- Primera lectura: Calcular el promedio de los precios
SELECT AVG(amount) AS ValorPromedioAntes FROM solturadb.soltura_planprices; --Calcula el promedio por primera vez
WAITFOR DELAY '00:00:10'; --Retraso para poder hacer el cambio
SELECT AVG(amount) AS ValorPromedioDespues FROM solturadb.soltura_planprices; --Cambio el valor del promedio del costo al ver que aumento aunque no deberia de generar ese read diferente
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR PRIMERO
--EJECUTAR (C) READ UNCOMMITTED
--READ UNCOMMITTED ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
DECLARE @TotalUsers INT;
SELECT @TotalUsers = COUNT(DISTINCT planpricesid) FROM solturadb.soltura_planprices;

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount) / @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Las ganancias antes del insert / numeros de usuarios dara un promedio verdadero en este momento

WAITFOR DELAY '00:00:10';

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount)/ @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Ahora que se hizo el insert el promedio dara mas que el verdadero al tener un usuario no contado

COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (D) REPEATABLE READ
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Lee precios actuales pero esto los bloqueara para el otro query generando esos bloqueos prolongados
WAITFOR DELAY '00:00:10';
COMMIT;
```
Caso A: Aunque se hace un rollback evitando que se cambie el enable de 1 a 0, como tiene lectura sucia lee 0.

![image](https://github.com/user-attachments/assets/03c8e017-c53d-4095-bbb6-d272154ce3dc)

Caso B: No se puede repetir la lectura entonces al ser sumado el costo total para usuarios de los planes cuando se inserta un valor en medio se genera un nonrepeatable read.

![image](https://github.com/user-attachments/assets/ab103650-3511-44e4-9d9b-c2e3d59d3129)

Caso C: Calcula un promedio erroneo al haber sacado el numero de usuarios antes y como se inserto un nuevo usuario pagando genera que el promedio se vuelva mas dinero/menos usuarios reales.

![image](https://github.com/user-attachments/assets/59aeadb1-1b23-48f0-a2dd-96c437bc0de8)

Caso D: El error no se ve, ya que el bloqueo no es prolongado no genera tiempos exagerados de espera. se ejecuta de manera rapida.

NIVEL READ COMMITTED: TIENE DE NONREPETABLE READ Y LECTURAS FANTASMAS
```sql
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (A) READ COMMITTED
--READ UNCOMMITED ERROR READ DIRTY
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
UPDATE solturadb.soltura_benefits SET enabled = 0x01 WHERE benefitsid = 1;
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x00 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--READ COMMITTED: TIENE PROBLEMAS DE NONREPETABLE READ Y LECTURAS FANTASMAS

--EJECUTAR (B) READ COMMITTED
--READ COMMITED ERROR NONREPETABLE READ
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--READ COMMITED: TIENE PROBLEMAS DE LECTURAS FANTASMAS
--EJECUTAR SEGUNDO ESTA
--EJECUTAR (C) READ COMMITED 
--READ COMMITED  ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;

--Tiene que ejecutarse primero el query A para que den los resultados dados claramente si no se ejectutan no dara dirty read por eso se tiene que hacer uno por uno
--Mediante la parte A y B.
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (D) READ COMMITTED
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;
```
```sql
--Tiene que ejecutarse primero el query A para que den los resultados dados claramente si no se ejectutan no dara dirty read por eso se tiene que hacer uno por uno
--Mediante la parte A y B.
--EJECUTAR (A) READ COMMITTED
-- READ COMMITTED ERROR READ DIRTY NO OCURRE PUES SOLO LEE COMMITTED
SET TRANSACTION ISOLATION LEVEL  READ COMMITTED; --Cambiamos a 0x01 el bit en la otra transaccion entonces este lo llega a leer pero como nunca hace commit lo que leyo la transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) READ COMMITTED
--READ COMMITED ERROR NONREPETABLE READ
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
-- Primera lectura: Calcular el promedio de los precios
SELECT AVG(amount) AS ValorPromedioAntes FROM solturadb.soltura_planprices; --Calcula el promedio por primera vez
WAITFOR DELAY '00:00:10'; --Retraso para poder hacer el cambio
SELECT AVG(amount) AS ValorPromedioDespues FROM solturadb.soltura_planprices; --Cambio el valor del promedio del costo al ver que aumento aunque no deberia de generar ese read diferente
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (C) READ COMMITTED
-- READ COMMITTED ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL  READ COMMITTED;
BEGIN TRANSACTION;
DECLARE @TotalUsers INT;
SELECT @TotalUsers = COUNT(DISTINCT planpricesid) FROM solturadb.soltura_planprices;

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount) / @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Las ganancias antes del insert / numeros de usuarios dara un promedio verdadero en este momento

WAITFOR DELAY '00:00:10';

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount)/ @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Ahora que se hizo el insert el promedio dara mas que el verdadero al tener un usuario no contado
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (D) READ COMMITTED
SET TRANSACTION ISOLATION LEVEL  READ COMMITTED;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Sin el serializable no provocara tantos bloqueos y molestias
WAITFOR DELAY '00:00:10';
COMMIT;
```
Caso A: Aunque se hace un rollback evitando que se cambie el enable de 1 a 0, como tiene no lectura sucia lee 1.

![image](https://github.com/user-attachments/assets/9dc2bac5-eb81-408e-9629-bfa2a85b975a)

Caso B: No se puede repetir la lectura entonces al ser sumado el costo total para usuarios de los planes cuando se inserta un valor en medio se genera un nonrepeatable read.

![image](https://github.com/user-attachments/assets/ab103650-3511-44e4-9d9b-c2e3d59d3129)

Caso C: Calcula un promedio erroneo al haber sacado el numero de usuarios antes y como se inserto un nuevo usuario pagando genera que el promedio se vuelva mas dinero/menos usuarios reales.

![image](https://github.com/user-attachments/assets/59aeadb1-1b23-48f0-a2dd-96c437bc0de8)

Caso D: El error no se ve, ya que el bloqueo no es prolongado no genera tiempos exagerados de espera. se ejecuta de manera rapida.

NIVEL REPEATABLE READ: TIENE PROBLEMAS DE LECTURAS FANTASMAS.
```sql
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (A) REPEATABLE READ
--REPEATABLE READ ERROR READ DIRTY no sucede al ser REPEATABLE READ
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x00 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) REPEATABLE READ
--REPEATABLE READ ERROR NONREPETABLE READ como dice el nombre REPEATABLE READ se puede repetir el read no sucede ese error
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--REPEATABLE READ: TIENE PROBLEMAS DE LECTURAS FANTASMAS
--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (D) REPEATABLE READ
--REPEATABLE READ PROBLEMAS DE BLOQUEOS PROLONGADOS no sucede
BEGIN TRANSACTION;
-- Intentar insertar un nuevo precio pero tardara un montoooooon al esperar ese bloqueo prolongado que trae Serializable
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;
```
```sql
--EJECUTAR (A) REPEATABLE READ error no sucede
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; --Cambiamos a 0x01 el bit en la otra transaccion entonces este lo llega a leer pero como nunca hace commit lo que leyo la transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (B) REPEATABLE READ
--REPEATABLE READ ERROR NONREPETABLE READ no sucede
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
-- Primera lectura: Calcular el promedio de los precios
SELECT AVG(amount) AS ValorPromedioAntes FROM solturadb.soltura_planprices; --Calcula el promedio por primera vez
WAITFOR DELAY '00:00:10'; --Retraso para poder hacer el cambio
SELECT AVG(amount) AS ValorPromedioDespues FROM solturadb.soltura_planprices; --Cambio el valor del promedio del costo al ver que aumento aunque no deberia de generar ese read diferente
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (C) REPEATABLE READ
--REPEATABLE READ ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
DECLARE @TotalUsers INT;
SELECT @TotalUsers = COUNT(DISTINCT planpricesid) FROM solturadb.soltura_planprices;

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount) / @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Las ganancias antes del insert / numeros de usuarios dara un promedio verdadero en este momento

WAITFOR DELAY '00:00:10';

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount)/ @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Ahora que se hizo el insert el promedio dara mas que el verdadero al tener un usuario no contado

COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (D) REPEATABLE READ
--REPEATABLE READ PROBLEMAS DE BLOQUEOS PROLONGADOS no sucede
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Lee precios actuales pero esto los bloqueara para el otro query generando esos bloqueos prolongados
WAITFOR DELAY '00:00:10';
COMMIT;
```
Caso A: Aunque se hace un rollback evitando que se cambie el enable de 1 a 0, como tiene no lectura sucia lee 1.

![image](https://github.com/user-attachments/assets/9dc2bac5-eb81-408e-9629-bfa2a85b975a)

Caso B: Se puede repetir la lectura entonces no habra pobremas con el avg que proporciona la lectura dado.

![image](https://github.com/user-attachments/assets/1048345f-47aa-4201-ae35-7bbafa22503a)

Caso C: Calcula un promedio erroneo al haber sacado el numero de usuarios antes y como se inserto un nuevo usuario pagando genera que el promedio se vuelva mas dinero/menos usuarios reales.

![image](https://github.com/user-attachments/assets/59aeadb1-1b23-48f0-a2dd-96c437bc0de8)

Caso D: El error no se ve, ya que el bloqueo no es prolongado no genera tiempos exagerados de espera. se ejecuta de manera rapida.

NIVEL SERIALIZABLE: TIENE PROBLEMAS DE BLOQUEOS PROLONGADOS.
```sql
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (A) SERIALIZABLE
--SERIALIZABLE ERROR READ DIRTY NO LO TIENE
--Cambiamos a 0x01 el bit entonces el otro lo llega a leer pero nunca hacemos commit por lo que leyo la otra transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
UPDATE solturadb.soltura_benefits SET enabled = 0x00 WHERE benefitsid = 1;
WAITFOR DELAY '00:00:05';
ROLLBACK;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (B) SERIALIZABLE
--SERIALIZABLE ERROR NONREPETABLE READ NO LO TIENE
--Cambiar el valor de amount haciendo que el promedio cambie y se muestra un valor diferente.
BEGIN TRANSACTION;
UPDATE solturadb.soltura_planprices SET amount = amount + 10 WHERE planpricesid = 1; --Le subimos el precio haciendo que el promedio de mayor pero esto genera que el read haya cambiado en el tiempo
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--EJECUTAR (C) SERIALIZABLE
--SERIALIZABLE ERROR LECTURAS FANTASMAS NO LO TIENE
BEGIN TRANSACTION;
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (100.00, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
WAITFOR DELAY '00:00:05';
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------
--SERIALIZABLE: Es el bloqueo excesivo que puede ocurrir en sistemas con alta concurrencia
--Este nivel de aislamiento bloquea las filas existenteslo que puede causar bloqueos prolongados y reducir el rendimiento.

--EJECUTAR (D) SERIALIZABLE
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
BEGIN TRANSACTION;
-- Intentar insertar un nuevo precio pero tardara un montoooooon al esperar ese bloqueo prolongado que trae Serializable
INSERT INTO solturadb.soltura_planprices (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
VALUES (99.99, 1, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 0x01, 1, 1);
COMMIT;
```
```sql
--EJECUTAR (A) SERIALIZABLE
--SERIALIZABLE ERROR READ DIRTY
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; --Cambiamos a 0x01 el bit en la otra transaccion entonces este lo llega a leer pero como nunca hace commit lo que leyo la transaccion fue erroneo (dirty read)
BEGIN TRANSACTION;
SELECT * FROM solturadb.soltura_benefits WHERE benefitsid = 1;
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (B) SERIALIZABLE
--SERIALIZABLE ERROR NONREPETABLE READ
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
-- Primera lectura: Calcular el promedio de los precios
SELECT AVG(amount) AS ValorPromedioAntes FROM solturadb.soltura_planprices; --Calcula el promedio por primera vez
WAITFOR DELAY '00:00:10'; --Retraso para poder hacer el cambio
SELECT AVG(amount) AS ValorPromedioDespues FROM solturadb.soltura_planprices; --Cambio el valor del promedio del costo al ver que aumento aunque no deberia de generar ese read diferente
COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (C) SERIALIZABLE
--SERIALIZABLE ERROR LECTURAS FANTASMAS
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
DECLARE @TotalUsers INT;
SELECT @TotalUsers = COUNT(DISTINCT planpricesid) FROM solturadb.soltura_planprices;

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount) / @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Las ganancias antes del insert / numeros de usuarios dara un promedio verdadero en este momento

WAITFOR DELAY '00:00:10';

SELECT 
    @TotalUsers AS Usuarios_Totales,
    SUM(amount) AS Ganancias_Totales,
    SUM(amount)/ @TotalUsers AS GananciaPorUsuario
FROM solturadb.soltura_planprices; --Ahora que se hizo el insert el promedio dara mas que el verdadero al tener un usuario no contado

COMMIT;
---------------------------------------------------------------------------------------------------------------------------------------

--EJECUTAR (D) SERIALIZABLE
--SERIALIZABLE PROBLEMAS DE BLOQUEOS PROLONGADOS
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT *  FROM solturadb.soltura_planprices WHERE [current] = 0x01; --Lee precios actuales pero esto los bloqueara para el otro query generando esos bloqueos prolongados
WAITFOR DELAY '00:00:10';
COMMIT;
```
Caso A: Aunque se hace un rollback evitando que se cambie el enable de 1 a 0, como tiene no lectura sucia lee 1.

![image](https://github.com/user-attachments/assets/9dc2bac5-eb81-408e-9629-bfa2a85b975a)

Caso B: Se puede repetir la lectura entonces no habra pobremas con el avg que proporciona la lectura dado.

![image](https://github.com/user-attachments/assets/1048345f-47aa-4201-ae35-7bbafa22503a)

Caso C: El promedio al no permitir phantoms se calcula de manera perfecta en ambos casos.

![image](https://github.com/user-attachments/assets/4b9a44d2-fc43-4542-9f72-41197452bcf5)

Caso D: El error ocurre en cuanto tiempo al tener bloqueos tan prolongados, terminara haciendo que se relentice muchisimo los querys relacionados y cualquier serializable. Solo usarse en casos de total hermeticidad.

## Cursor de Update
En este caso probaremos el cursor cuando se bloquea y bloquea tambien los updates de manera que veremos lo que puede llegar a relentizar a los updates.
Prueba con Scroll Locks y UPDLOCKS activo:
```sql
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
```
Este seria el query que se ejecutaria a la vez y tardara muchisimo porque tiene que esperar a que el cursor termine.
```sql
USE soltura;
GO
UPDATE solturadb.soltura_users
SET birthday = DATEADD(MONTH, -1, birthday);
```

Este seria el caso sin el scroll locks ni updlocks:
```sql
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
```
Este seria el query que se ejecutaria a la vez y no tardara porque no tiene que esperar a que el cursor termine. Se ejecuta de una vez.
```sql
USE soltura;
GO
UPDATE solturadb.soltura_users
SET birthday = DATEADD(MONTH, -1, birthday);
```

Notese que el cursor aun sin bloqueo es muy mala opcion y deberia de hacerse con un simple update pero si uno no lo tiene contemplado puede atrasar toda la base de datos por algo simple. Ejemplo de la solucion optima:
```sql
USE soltura;
GO
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
```

CASOS DE USO PARA EL SCROLL LOCKS:
Rowlock: Bloqueara la fila en la que esta parado el cursor, esto genera problemas porque aunque no afecte a la columna fila que estoy intentando usar el rowlock la bloqueara y no me dejara usarla hasta que acabe con ella haciendola muy poco optima. Se debe evitar cuando se tienen varios querys que acceden a diferentes columnas en la misma fila.
Updlock: No permitira que se actualice nada en la fila que recorre el cursor causando perdida de tiempo para otros querys que quieren acceder y cambiar un simple dato.
No se deberia usar: para datos que son accedidos constantemente por varios querys, generando bloqueos que retrasan a otras operaciones, tampoco se deben de usar en volumen de datos grandes al ser lentos y consumir mucha memoria.
Se podria usar (pero mejor no): Si no hay otros querys queriendo acceder a la informacion puede llegar a ser util para simplificar la logica detras de los algoritmos que vayamos a implementar y tambien puede ser util si hay pocas filas por las que pase el cursor esto porque aunque bloquee unas filas al ser pocas sera poco significativo.

## Transacción de Volumen
Nuestra transacción de volumen se basara en el canje de los beneficios antes adquiridos al notarse que será la operacion más usada y la razón por la cual el usuario quiere usar nuestros servicios, a esta la estresaremos para ver su capacidad maxima y mejorarla.
```sql
USE soltura;
GO

IF OBJECT_ID('solturadb.sp_insertRedemptionPorParametros', 'P') IS NOT NULL
    DROP PROCEDURE solturadb.sp_insertRedemptionPorParametros; --Lo borra si es el caso para evitar errores al crear el procedimiento
GO

CREATE PROCEDURE solturadb.sp_insertRedemptionPorParametros
    @userId INT,
    @planpersonId INT,
    @benefitId INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS --Revisa que los valores recibidos existan y cumplan las restricciones
        (
            SELECT 1
            FROM solturadb.soltura_planperson_users ppu
            JOIN solturadb.soltura_benefits b ON b.planpersonid = ppu.planpersonid
            WHERE ppu.userid = @userId AND ppu.planpersonid = @planpersonId AND b.benefitsid = @benefitId
        )
        BEGIN
            PRINT 'Relacion invalida entre ell usuario, su plan y el beneficio asociado al plan.'; --Si no existe ninguno tal que eso se cumpla hace rollback y termina el procedimiento.
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @redemptionMethodId INT;
        DECLARE @reference1 BIGINT = 100000 + FLOOR(RAND() * 900000); --Valores random solo para dar a entender que ahi iria una referencia
        DECLARE @reference2 BIGINT = 200000 + FLOOR(RAND() * 900000);
        DECLARE @value1 NVARCHAR(100) = CONCAT('Redimido: ', @benefitId);
        DECLARE @value2 NVARCHAR(100) = CONCAT('El Usuario ', @userId, 'lo a redimido.');

        SELECT TOP 1 @redemptionMethodId = redemptionMethodsid
        FROM solturadb.soltura_redemptionMethods
        ORDER BY NEWID(); --Elige un redemptionmethod random para usar con la insercion de redemptions

        INSERT INTO solturadb.soltura_redemptions
            (date, redemptionMethodsid, userid, benefitsid, reference1, reference2, value1, value2, checksum)
        VALUES
            (GETDATE(), @redemptionMethodId, @userId, @benefitId, @reference1, @reference2,
             CONVERT(VARBINARY(100), @value1), CONVERT(VARBINARY(100), @value2),HASHBYTES('SHA2_256', CONCAT(@userId, '089080800',@benefitId, 'valoresparaenloqueserelchecksummm',@reference1, 'denlealcoholalchecksum',@reference2, 'guaro',@value1, 'loqueraaaa',@value2))); 

        COMMIT TRANSACTION;
        PRINT 'Insert efectuado.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Ocurrio un error durante la insercion.';
        THROW;
    END CATCH
END;
GO
```
## Transacciones Por Segundo Máximo
Las transacciones por segundo que se podrian obtener con un backend que consiga un usuario con un plan y un beneficio a canjear y mandarlo a redimir logra unas transacciones por segundo de entre 100 y 120 por segundo
El backend asociado (creado mediante nodejs):
```nodejs
const express = require('express');
const sql = require('mssql');
const app = express();
const PORT = 3000;

const config = { //Parametros a configurar (un usuario, password, servido, puerto)
    user: 'nombre_usuario',
    password: 'password',
    server: 'localhost',
    port: 1433,
    database: 'soltura',
    options: {
        encrypt: true,
        trustServerCertificate: true,
    }
};

app.get('/redemption', async (req, res) => {
    // se Crea un pool manualmente y cerrarlo después (esto hace que solo se use una vez por solicitud)
    const pool = new sql.ConnectionPool(config);
    try {
        await pool.connect();

        // Obtener datos aleatorios para enviar a la transaccion
        const randomResult = await pool.request()
            .execute('solturadb.sp_getRandomUserPlanBenefit');

        if (!randomResult.recordset || randomResult.recordset.length === 0) //  Verifica si hay alguna combinacion valida.
            {
            return res.status(404).send('No se encontró combinación válida.');
        }

        // Extraer los datos necesarios de la respuesta
        const { userid, planpersonid, benefitsid } = randomResult.recordset[0];

        // Ejecuta la redencion pero mandando un usuario, el plan asociado al usuario y que beneficio quiere redimir.
        await pool.request()
            .input('userId', sql.Int, userid)
            .input('planpersonId', sql.Int, planpersonid)
            .input('benefitId', sql.Int, benefitsid)
            .execute('solturadb.sp_insertRedemptionPorParametros');

        res.json({
            mensaje: 'Redención realizada correctamente (sin reutilizar pool).',
            datos: { userid, planpersonid, benefitsid }
        });
    } catch (err) {
        console.error('Error al ejecutar la redención sin pool:', err);
        res.status(500).send('Error en redención.');
    } finally {
        pool.close(); // Cerrar el pool después de cada solicitud (para asegurarse de que no se mantenga usando)
    }
});

app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
```
*Todas estas pruebas fueron efectuadas mediante Jmeter, el archivo de configuracion es node.jmx.*
![image](https://github.com/user-attachments/assets/2556b768-e13d-4be0-87f0-7ea242970a7f)
## Triplicar las Transacciones Por Segundo Máximo
Logramos mejorar la velocidad de estas transacciones por segundo en un x9, al hacer uso de una pool de conexiones a las cuales los usuarios acceden de esta manera se evita que esten constantemente abriendo y cerrando conexiones poniendo cargar al servidor, mejor reutilizan las conexiones anteriores hasta que se completen todas.
Este es el codigo del back end con pools en node.js
```nodejs
const express = require('express');
const sql = require('mssql');
const app = express();
const PORT = 3000;

const config = { //Parametros a configurar (un usuario, password, servido, puerto)
  user: 'nombre_usuario',
  password: 'password',
  server: 'localhost',
  port: 1433,
  database: 'soltura',
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  pool: {
    max: 35,
    min: 30,
    idleTimeoutMillis: 30000,
  },
};

// Crear pool de conexiones para reutilizarlas una vez inicializadas.
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log("Conectado a la base de datos");
    return pool;
  })
  .catch(err => {
    console.error("Error de conexión a la base de datos:", err);
    process.exit(1);
  });


app.get('/redemption', async (req, res) => {
  try {
    const pool = await poolPromise; // Esperar a dar un pool de conexiones inicializado.

    // Obtener datos aleatorios para enviar a la transaccion
    const randomResult = await pool.request()
      .execute('solturadb.sp_getRandomUserPlanBenefit');

    if (!randomResult.recordset || randomResult.recordset.length === 0)  //  Verifica si hay alguna combinacion valida.
      {
      return res.status(404).send('No se encontró combinación válida.');
    }

    const { userid, planpersonid, benefitsid } = randomResult.recordset[0];// Extraer los datos necesarios de la respuesta

    // Ejecuta la redencion pero mandando un usuario, el plan asociado al usuario y que beneficio quiere redimir.
    await pool.request()
      .input('userId', sql.Int, userid)
      .input('planpersonId', sql.Int, planpersonid)
      .input('benefitId', sql.Int, benefitsid)
      .execute('solturadb.sp_insertRedemptionPorParametros');

    res.json({
      mensaje: 'Redención realizada correctamente.',
      datos: {
        userId: userid,
        planpersonId: planpersonid,
        benefitId: benefitsid
      }
    });

  } catch (err) {
    console.error('Error en redención:', err);
    res.status(500).send('Error al procesar la redención.');
  }
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
```
*Todas estas pruebas fueron efectuadas mediante Jmeter, el archivo de configuracion es node.jmx.*

![image](https://github.com/user-attachments/assets/9c5ca9eb-a7f0-44f4-a7cb-ea57734f0de9)

---
# Soltura ft. PaymentAssistant
Para la realización de esta última parte se utilizo Python Notebook con Pandas como herramienta para migrar la base de datos Payment Assistant a Soltura. A continuación se demostraran los scripts necesarios para migrar los datos solicitados en las instrucciones. También se demuestra el script para los inserts a MongoDB del banner y home page sobre el cambio de sistemas.
## Script para migrar los usuarios
En este codigo nos conectamos en ambas bases de datos con los datos respectivos de su servidor, luego se crean la tablas para los usuarios migrados y otra que maneja que deben cambiar su contraseña, ya que se les asigna una temporal. Extrae los datos de los usuarios de Payment y los inserta en los de Soltura, manteniendo sus datos originales 
```python
import pandas as pd
import pymysql
import pyodbc
import hashlib

# Conexión a las bases de datos
mysql_conn = pymysql.connect(
    host='localhost', user='root', password='123', database='paymentdb'
)
sqlserver_conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;'
)

try:
    #Se cren las tablas de usuarios migrados y los de cambio de contraseña
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='soltura_migrated_users' AND xtype='U')
            CREATE TABLE solturadb.soltura_migrated_users (
                migratedid INT IDENTITY PRIMARY KEY,
                email NVARCHAR(255) UNIQUE NOT NULL,
                firstname NVARCHAR(100),
                lastname NVARCHAR(100),
                birthdate DATE,
                companyid INT NULL,
                fecha_registro DATETIME DEFAULT '2025-12-15', -- Fecha en la que se hará la migración
                password VARBINARY(32) NOT NULL
            )
        """)
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='soltura_passwordchange' AND xtype='U')
            CREATE TABLE solturadb.soltura_passwordchange (
                passwordchangeid INT IDENTITY PRIMARY KEY,
                changerequired BIT DEFAULT 1,
                userid INT NOT NULL,
                FOREIGN KEY (userid) REFERENCES solturadb.soltura_users(userid)
            )
        """)
        sqlserver_conn.commit()

    #Extraer los datos de users desde MySQL
    payment_users = pd.read_sql(
        "SELECT userid, email, firstname, lastname, birthday, NULL AS companyid FROM payment_users",
        mysql_conn
    )

    #Se generan contraseñas nuevas para los usuarios migrados
    def generate_hashed_password(index):
        texto = f"Contraseña{index}"
        return hashlib.sha256(texto.encode('utf-8')).digest()
    payment_users['hashed_password'] = [generate_hashed_password(i) for i in range(len(payment_users))]

    #Se insertan los usuarios en soltura_users y soltura_migrated_users
    with sqlserver_conn.cursor() as cursor:
        for _, row in payment_users.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_users (email, firstname, lastname, birthday, password, companyid)
                VALUES (?, ?, ?, ?, ?, ?)
            """, row['email'], row['firstname'], row['lastname'], row['birthday'], row['hashed_password'], row['companyid'])

            cursor.execute("""
                INSERT INTO solturadb.soltura_migrated_users (email, firstname, lastname, birthdate, companyid, password)
                VALUES (?, ?, ?, ?, ?, ?)
            """, row['email'], row['firstname'], row['lastname'], row['birthday'], row['companyid'], row['hashed_password'])

        sqlserver_conn.commit()

    print("Usuarios migrados insertados correctamente.")

    #Se insertan los usuarios en la tabla de cambio de contraseña
    #Se insertan buscandolos por su correo electrónico en la tabla de usuarios migrados con su nuevo user id
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            INSERT INTO solturadb.soltura_passwordchange (userid, changerequired)
            SELECT u.userid, 1
            FROM solturadb.soltura_users u
            WHERE email IN (SELECT email FROM solturadb.soltura_migrated_users)
            ORDER BY u.userid
        """)
        sqlserver_conn.commit()

    print("Estado de cambio de contraseña registrado correctamente.")

except Exception as e:
    print(f"Error: {e}")

finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para migrar los modulos
Esta tabla es necesaria para luego poder migrar los permisos, ya que tiene como llave foranea el modulo, entonces se debe transferir a Soltura. Se conecta a las bases ded datos, extrae los datos y los migra en la tabla de modulos de Soltura iterando columna por columna
``` python
import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla modules
    module_df = pd.read_sql("SELECT moduleid, name FROM payment_modules", mysql_conn)
    

    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in module_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_modules (moduleid, name)
                VALUES (?, ?)
            """, row['moduleid'], row['name'])
        
        sqlserver_conn.commit()
    
    print(f" Migración exitosa. {len(module_df)} módulos migrados")

except Exception as e:
    print(f" Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para migrar los permisos
Este codigo trae de Payment la data de permisos, necesaria para que cada usuario pueda conservar sus permisos en Soltura. En el codigo se conectan a las bases de datos y extraen los datos de permissions, para que luego las vayan insertando en la misma tabla pero de Soltura iterando por las columnas
``` python
import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla permissiones
    permission_df = pd.read_sql("SELECT permissionid, description, code, moduleid FROM payment_permissions", mysql_conn)
    
    #Aumentamos el tamaño de la columna 'code'
    with sqlserver_conn.cursor() as cursor:
        cursor.execute("""
            ALTER TABLE solturadb.soltura_permissions 
            ALTER COLUMN code NVARCHAR(50)
        """)
        sqlserver_conn.commit()
        print("Columna code ampliada ")
    
    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in permission_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_permissions (description, code, moduleid)
                VALUES (?, ?, ?)
            """, row['description'], row['code'], row['moduleid'])
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa. {len(permission_df)} permisos migrados")

except Exception as e:
    print(f"Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para migrar los permisos de usuarios
Una vez que migramos los permisos de Payment, ya podemos migrar los permisos de usuario porque ocupabamos la llave foranea de permisos. Extraemos los datos de permisos de usuarios de Payment y antes de insertalos, iteramos en cada tabla verificando si el username de Payment es el mismo que el correo de Soltura en la tabla de users, ya que en ambas plataformas se maneja correo y username como lo mismo, si son iguales cuado se inserta en la tabla de permisos de usuario se le asigna el user id de la tabla de users. De esta manera se mantiene la relación de llaves foraneas con los datos migrados
``` python
import pandas as pd
import pymysql
import pyodbc

# Conexión a las bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    # Renombrar la columna rolepermissionid a userpermissionid
    with sqlserver_conn.cursor() as cursor:
        try:
            cursor.execute("""
                EXEC sp_rename 'solturadb.soltura_userpermissions.rolepermissionid', 'userpermissionid', 'COLUMN'
            """)
            sqlserver_conn.commit()
        except Exception as rename_error:
            print(f"Nota: No se pudo renombrar la columna: {rename_error}")

    # Extraer los datos de userpermissions desde MySQL
    userpermissions_df = pd.read_sql("SELECT * FROM payment_userpermissions", mysql_conn)
    print(f"Columnas en el origen: {userpermissions_df.columns.tolist()}")

    # Migrar los datos a SQL Server de la tabla soltura_userpermissions
    with sqlserver_conn.cursor() as cursor:
        for _, row in userpermissions_df.iterrows():
            #Se verifica si el username existe en la tabla soltura_users
            cursor.execute("""
                SELECT userid FROM solturadb.soltura_users WHERE email = ?
            """, (row['username'],))

            #Si existe una coincidencia, se obtiene el userid correspondiente
            user_row = cursor.fetchone()  
            if user_row:  
                userid_correcto = user_row[0]
            else:
                userid_correcto = row['userid']  

            # Se inserta los datos migrados y con el userid correcto por si ya existia el usuario en users
            cursor.execute("""
                INSERT INTO solturadb.soltura_userpermissions (enabled, deleted, lastupdate, username, checksum, userid, permissionid)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (row['enabled'], row['deleted'], row['lastupdate'], row['username'], row['checksum'], userid_correcto, row['permissionid']))

        sqlserver_conn.commit()

    print(f"Migración exitosa. {len(userpermissions_df)} permisos de usuario migrados")

except Exception as e:
    print(f"Error: {e}")

finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para migrar las suscripciones
Para poder migrar los precios de planes, debemos primero migrar los datos de suscripciones. Entonces luego de conectarse a ambas bases de datos, obtiene los valores de suscripciones y los inserta en la misma tabla de Soltura
``` python
import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    #Extrae los datos de la tabla subscriptions
    address_df = pd.read_sql("SELECT subscriptionid, description, logourl FROM payment_subscriptions", mysql_conn)
    
    #Migra los datos a SQL Server iterando columna por columna
    with sqlserver_conn.cursor() as cursor:
        for _, row in address_df.iterrows():
            cursor.execute("""
                INSERT INTO solturadb.soltura_subscriptions (description, logourl)
                VALUES (?, ?)
            """, row['description'], row['logourl'])
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa. {len(address_df)} subscripciones migradas")

except Exception as e:
    print(f"Error: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para migrar los precios de planes
Una vez con los datos de las suscripciones migrados, se puede extrar la info de los precios de planes de Soltura. Para mantener la relacion de la nueva llave forane de suscription  en Soltura, utilizamos diccionarios donde compara los nombres de suscripciones y si es el mismo extrae el id, para que de esta manera al insertar los datos de la tabla, usamos el id correcto, manteniendo la relacion con los datos migrados en Soltura
```python
import pandas as pd
import pymysql
import pyodbc
from datetime import datetime

#Se conecta a las dos bases de datos
mysql_conn = pymysql.connect(host='localhost', user='root', password='123', database='paymentdb')  
sqlserver_conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=DANIEL2005\SQLEXPRESS;DATABASE=soltura;Trusted_Connection=yes;')

try:
    # Consulta para extraer los datos de la tabla prices de Payment
    #Se realiza un join con la tabla subscriptions para obtener el nombre de la suscripción para no perder la referencia
    planprices_df = pd.read_sql("""
        SELECT pp.planpricesid, pp.amount, pp.recurrencytype, pp.posttime, pp.endate, 
               pp.current, pp.currencyid, pp.subscriptionid, s.description as subscription_name
        FROM payment_planprices pp
        JOIN payment_subscriptions s ON pp.subscriptionid = s.subscriptionid
    """, mysql_conn)
    
    
    #Se extraen el id y description de las suscripciones en Soltura
    soltura_subscriptions = pd.read_sql("""
        SELECT subscriptionid, description 
        FROM solturadb.soltura_subscriptions
    """, sqlserver_conn)
    
    #Con diccionarois se relacionan los nombres de las suscripciones con sus IDs
    #Para poder asociar los datos migrados con los de Soltura
    subscription_map = {}
    for _, row in soltura_subscriptions.iterrows():
        if row['description']:  # Verificar que la descripción no sea None
            subscription_map[row['description'].lower()] = row['subscriptionid']
    
    

    with sqlserver_conn.cursor() as cursor:
        for _, row in planprices_df.iterrows():
            #Busca el ID de la suscripción en el diccionario usando el nombre 
            subscription_name = row['subscription_name'].lower() if row['subscription_name'] else ''
            soltura_subscription_id = subscription_map.get(subscription_name)
            
            if not soltura_subscription_id:
                continue
            
            try:
                #Inserta los datos migrados con el ID de la suscripción de Soltura
                cursor.execute("""
                    INSERT INTO solturadb.soltura_planprices 
                    (amount, recurrencytype, posttime, endate, [current], currencyid, subscriptionid)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, 
                row['amount'],
                row['recurrencytype'],
                row['posttime'],
                row['endate'],
                row['current'],
                row['currencyid'],
                soltura_subscription_id)  #Usa el ID correspondiente
                
            except Exception as insert_error:
                print(f"Error al insertar precio de plan: {insert_error}")
        
        sqlserver_conn.commit()
    
    print(f"Migración exitosa")

except Exception as e:
    print(f"Error durante la migración: {e}")
finally:
    mysql_conn.close()
    sqlserver_conn.close()
```
## Script para insertar banner y home page sobre el nuevo cambio de sistema
Por ultimo, para la creación del home page y del banner que va a utilizar Soltura, usamos este script que se debe insertar en la base de MongoDB en el collection de media. Esto tiene un id para identificarlo, el tipo de media que es, el titulo que va a contener, su descripción para que los clientes comprendan, la fecha de la migración de la base de datos, un link para que los usuarios de Payment se guien en el proceso de migrar a Soltura y por último el home page tiene un url de la imagen que va a contener  
```json
[{
  "_id": {
    "$oid": "6819a7c258f557cf57129530"
  },
  "tipo": "banner",
  "titulo": "¡Soltura ha llegado!",
  "descripcion": "Payment Assist ahora es Soltura. Descubre los nuevos beneficios.",
  "fecha_migracion": {
    "$date": "2025-12-15T00:00:00.000Z"
  },
  "link_guia": "https://soltura.com/guia-migracion-de-bases",
  "activo": true
},
{
  "_id": {
    "$oid": "6819a86d58f557cf57129535"
  },
  "tipo": "home_page",
  "titulo": "Bienvenido a Soltura",
  "descripcion": "La pagina de pagos ahora es parte de Soltura. Con más beneficios y más comodidad.",
  "fecha_publicacion": {
    "$date": "2025-12-15T00:00:00.000Z"
  },
  "link_guia": "https://soltura.com/guia-migracion-de-bases",
  "activo": true,
  "imagen_url": "https://soltura.com/assets/img/home-page-soltura.jpg"
}]
```











