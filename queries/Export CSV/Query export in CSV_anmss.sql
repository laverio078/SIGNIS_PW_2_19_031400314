SET search_path = nis2, public;

/* 14) Esempio di query per esportare in CSV (da eseguire con psql, genererà un file in formato CSV nella cartella/folder corrente): */
\copy (SELECT * FROM nis2.vw_acn_profile_csv WHERE organization_name='Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)') TO 'acn_profile_anmss.csv' CSV HEADER;
