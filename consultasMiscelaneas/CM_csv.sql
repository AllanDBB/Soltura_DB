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
