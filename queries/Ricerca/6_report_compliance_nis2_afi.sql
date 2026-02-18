SET search_path = nis2, public;

/* 6) Report di Compliance NIS2 (Gap Analysis) - AutoFisco Italia */
/* Mostra lo stato di attuazione dei controlli ACN per ogni asset */
SELECT * FROM vw_acn_profile_csv
WHERE organization_name = 'AutoFisco Italia S.p.A.'
ORDER BY current_tier, service_name;