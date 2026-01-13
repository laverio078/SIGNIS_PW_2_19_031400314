SET search_path = nis2, public;
/* 3) Elenco dipendenze Supply Chain e Fornitori per servizio */
SELECT d.dependency_id, s.name AS service_name, v.name AS vendor_name, d.dependency_type, d.sla_reference, d.criticality
FROM dependency d
JOIN service s ON s.service_id = d.service_id
LEFT JOIN vendor v ON v.vendor_id = d.vendor_id
WHERE s.organization_id = (SELECT organization_id FROM organization WHERE name='Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)')
ORDER BY d.criticality DESC;
