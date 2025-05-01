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