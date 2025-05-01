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