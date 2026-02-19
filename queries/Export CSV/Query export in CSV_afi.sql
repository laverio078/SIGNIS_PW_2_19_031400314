SET search_path = nis2, public;

/* Esempio di query per esportare in CSV (genererà un file nella cartella corrente in formato CSV): */
\copy (SELECT * FROM nis2.vw_acn_profile_csv WHERE organization_name='AutoFisco Italia S.p.A.') TO 'acn_profile_AFI.csv' CSV HEADER;
