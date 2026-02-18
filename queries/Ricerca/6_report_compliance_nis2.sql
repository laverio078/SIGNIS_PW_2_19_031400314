SET search_path = nis2, public;

/* 6) Report di Compliance NIS2 (Gap Analysis) - ANMSS */
/* Mostra lo stato di attuazione dei controlli ACN per ogni asset */
SELECT * FROM vw_acn_profile_csv
WHERE organization_name = 'Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)'
ORDER BY current_tier, service_name;