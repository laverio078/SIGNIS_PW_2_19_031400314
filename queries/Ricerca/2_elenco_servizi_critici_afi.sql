SET search_path = nis2, public;

/* Elenco servizi critici (Asset e Fornitori) */
SELECT 
    s.name AS service_name,
    s.criticality AS service_criticality,
    a.name AS asset_name,
    a.asset_type AS asset_type,
    v.name AS vendor_name,
    d.dependency_type AS dependency_type
FROM service s
/* Join con gli Asset */
LEFT JOIN service_asset sa ON sa.service_id = s.service_id
LEFT JOIN asset a ON a.asset_id = sa.asset_id
/* Join con le Dipendenze (Fornitori) */
LEFT JOIN dependency d ON d.service_id = s.service_id
LEFT JOIN vendor v ON v.vendor_id = d.vendor_id
WHERE s.organization_id = (SELECT organization_id FROM organization WHERE name='AutoFisco Italia S.p.A.')
  AND s.criticality >= 4
ORDER BY s.name, a.name, v.name;
