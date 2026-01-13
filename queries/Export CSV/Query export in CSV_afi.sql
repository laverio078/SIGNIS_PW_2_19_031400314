SET search_path = nis2, public;

/* 14) Esempio di query per esportare in CSV (da eseguire con psql, genererà un file in formato CSV nella cartella/folder corrente): */
\copy (SELECT * FROM nis2.vw_acn_profile_csv WHERE organization_name='AutoFisco Italia S.p.A.') TO 'acn_profile_AFI.csv' CSV HEADER;
