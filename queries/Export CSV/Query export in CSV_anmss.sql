SET search_path = nis2, public;

/* Esempio di query per esportare in CSV (genererà un file nella cartella corrente in formato CSV): */
\copy (SELECT * FROM nis2.vw_acn_profile_csv WHERE organization_name='Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)') TO 'acn_profile_anmss.csv' CSV HEADER;
