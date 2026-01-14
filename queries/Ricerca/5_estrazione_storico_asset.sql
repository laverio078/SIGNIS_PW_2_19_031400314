SET search_path = nis2, public;
/* 5) Estrazione  dello storico modifiche (Audit Trail) per l'asset critico 'Oracle Exadata' */
/* Verifica le modifiche avvenute su un asset specifico (es. il Database Veicoli). */
/* Nota: Questa query restituirà risultati solo dopo aver effettuato modifiche (UPDATE) sull'asset */
/* pertanto si  è deciso di inserire una update prima dell'estrazione che mette in 'off' l'asset da 'active' */
UPDATE asset
SET lifecycle_status = 'off'
WHERE identifier = 'DB-RNV-PROD-01'
RETURNING asset_id, name, lifecycle_status;


SELECT * FROM asset_history 
WHERE asset_id = (SELECT asset_id FROM asset WHERE name='Oracle Exadata - DB Veicoli' LIMIT 1) 
ORDER BY changed_at DESC;
