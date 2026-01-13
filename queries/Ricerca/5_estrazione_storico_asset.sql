SET search_path = nis2, public;
/* 5) Estrazione  dello storico modifiche (Audit Trail) per l'asset critico 'Oracle Exadata' */
/* Verifica le modifiche avvenute su un asset specifico (es. il Database Veicoli). */
/* Nota: Questa query restituirà risultati solo dopo aver effettuato modifiche (UPDATE) sull'asset */
SELECT * FROM asset_history 
WHERE asset_id = (SELECT asset_id FROM asset WHERE name='Oracle Exadata - DB Veicoli' LIMIT 1) 
ORDER BY changed_at DESC;
