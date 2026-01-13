SET search_path = nis2, public;
/* 1) Estrae l'elenco degli asset con criticità alta o critica (criticality >= 4) per l'Agenzia */
SELECT a.asset_id, a.name, a.asset_type, a.identifier, a.criticality, a.metadata
FROM asset a
WHERE a.organization_id = (SELECT organization_id FROM organization WHERE name='Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)')
  AND a.criticality >= 4
ORDER BY a.criticality DESC, a.name;


