USE soltura;
GO

-- PASO 1: Crear tabla de auditoría para pagos/redenciones
PRINT '';
PRINT '-- DEMOSTRACIÓN DE TRIGGER PARA AUDITORÍA DE PAGOS --';
PRINT 'Un TRIGGER es código que se ejecuta automáticamente en respuesta a ciertos eventos.';
PRINT 'En este ejemplo, usaremos un TRIGGER para auditar operaciones de redención de beneficios.';

-- Crear tabla de auditoría si no existe
IF OBJECT_ID('solturadb.soltura_payment_audit', 'U') IS NULL
BEGIN
    CREATE TABLE solturadb.soltura_payment_audit (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        action_type VARCHAR(20) NOT NULL,
        redemption_id INT NOT NULL,
        user_id INT NOT NULL,
        benefit_id INT NOT NULL,
        amount_info VARCHAR(100) NULL,
        action_date DATETIME NOT NULL DEFAULT GETDATE(),
        action_user VARCHAR(100) NOT NULL,
        client_ip VARCHAR(50) NULL,
        additional_info NVARCHAR(MAX) NULL
    );
    PRINT 'Tabla de auditoría creada: soltura_payment_audit';
END
ELSE
    PRINT 'Usando tabla de auditoría existente';

-- Eliminar el trigger si ya existe para poder recrearlo
IF OBJECT_ID('tr_redemption_payment_audit', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER tr_redemption_payment_audit;
    PRINT 'Trigger existente eliminado';
END

-- PASO 2: Crear trigger para auditar inserciones en redenciones (pagos)
PRINT 'Creando trigger de auditoría para inserciones de redenciones:';
GO -- ¡IMPORTANTE! Separar el CREATE TRIGGER en su propio lote

CREATE TRIGGER tr_redemption_payment_audit
ON solturadb.soltura_redemptions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insertar registro en la tabla de auditoría para cada redención insertada
    INSERT INTO solturadb.soltura_payment_audit
        (action_type, redemption_id, user_id, benefit_id, amount_info, action_user, client_ip, additional_info)
    SELECT
        'INSERT',                                     -- Tipo de acción (inserción)
        i.redemptionid,                               -- ID de la redención
        i.userid,                                     -- Usuario que realizó la redención
        i.benefitsid,                                 -- Beneficio redimido
        'Ref: ' + CAST(i.reference1 AS VARCHAR) +     -- Información de monto/referencia
            ISNULL(' - ' + CAST(i.reference2 AS VARCHAR), ''),
        SYSTEM_USER,                                  -- Usuario de base de datos que ejecutó la acción
        CONVERT(VARCHAR(50), CONNECTIONPROPERTY('client_net_address')),  -- IP del cliente
        'Valor: ' + i.value1 + ' - ' + ISNULL(i.value2, 'N/A') +        -- Información adicional
            ' - Timestamp: ' + CONVERT(VARCHAR, i.date, 120)
    FROM 
        inserted i;
    
    -- Recuperar información del beneficio para contexto en el mensaje
    DECLARE @benefitName VARCHAR(100), @userName VARCHAR(100);
    
    SELECT TOP 1
        @benefitName = b.name,
        @userName = CAST(i.userid AS VARCHAR) -- En un sistema real, obtendrías el nombre real del usuario
    FROM
        inserted i
        JOIN solturadb.soltura_benefits b ON i.benefitsid = b.benefitsid;
    
    -- Enviar mensaje de confirmación
    PRINT '✓ Trigger ejecutado: Auditoría de pago registrada para:';
    PRINT '  - Beneficio: ' + @benefitName;
    PRINT '  - Usuario ID: ' + @userName;
    PRINT '  - Fecha: ' + CONVERT(VARCHAR, GETDATE(), 120);
END;
GO

-- PASO 3: Probar el trigger con una inserción
PRINT '';
PRINT 'Probando trigger con una nueva redención de beneficio:';

-- Obtener IDs existentes para usar en la inserción
-- Usamos un enfoque más directo para obtener IDs válidos
DECLARE @testUserId INT, @testBenefitId INT, @testMethodId INT;

-- Obtener un usuario válido (evitando usar planpersonuserid que causó el error)
SELECT TOP 1 @testUserId = userid 
FROM solturadb.soltura_planperson_users
ORDER BY planpersonid;

-- Obtener un beneficio válido
SELECT TOP 1 @testBenefitId = benefitsid 
FROM solturadb.soltura_benefits
WHERE enabled = 0x01
ORDER BY benefitsid;

-- Obtener un método de redención válido
SELECT TOP 1 @testMethodId = redemptionMethodsid 
FROM solturadb.soltura_redemptionMethods;

-- Mostrar datos que se insertarán
PRINT 'Insertando redención con:';
PRINT ' - Usuario ID: ' + CAST(@testUserId AS VARCHAR);
PRINT ' - Beneficio ID: ' + CAST(@testBenefitId AS VARCHAR);
PRINT ' - Método ID: ' + CAST(@testMethodId AS VARCHAR);

-- Realizar inserción que disparará el trigger
INSERT INTO solturadb.soltura_redemptions
    (date, redemptionMethodsid, userid, benefitsid, reference1, reference2, value1, value2, checksum)
VALUES
    (GETDATE(), @testMethodId, @testUserId, @testBenefitId, 
     99999, 88888, 'Prueba de trigger de auditoría', 'Beneficio redimido mediante demostración', 0x0123456789);

-- PASO 4: Verificar los resultados
PRINT '';
PRINT 'Verificando resultados - Últimos registros de auditoría:';
SELECT TOP 5 * 
FROM solturadb.soltura_payment_audit
ORDER BY audit_id DESC;

-- PASO 5: Mostrar el flujo completo para demostración
PRINT '';
PRINT 'Flujo completo de la ejecución del trigger:';
PRINT '1. Usuario realiza una redención de beneficio';
PRINT '2. Se inserta un registro en soltura_redemptions';
PRINT '3. El trigger AFTER INSERT se dispara automáticamente';
PRINT '4. El trigger captura todos los datos importantes';
PRINT '5. Se escribe un registro de auditoría con metadatos adicionales';