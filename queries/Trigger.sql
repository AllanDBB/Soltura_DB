CREATE TRIGGER trg_insert_default_detail
ON solturadb.soltura_contracts
--Este trigger se ejecuta despues de insertar un nuevo contrato 
AFTER INSERT
AS
BEGIN
    --Insertamos las filas en la tabla de detalles de contrato
    INSERT INTO solturadb.soltura_contractDetails (name, description, contractid, price, solturaPercentage, companyPercentage)
    SELECT 
        --Ponemos datos por defecto para el detalle del contrato
        --Lo que se busca es que SolturaDB no tenga que crear un contractDetail, sino solo editrar sus datos segun los acuerdos
        'Nombre inicial', 
        'Detalle automatico generado al crear el contrato', 
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