SET search_path = nis2, public;
/* Estrazione  dello storico modifiche (Audit Trail) per l'asset critico 'Thales HSM Payment' (sistema di firma) */
/* Verifica le modifiche avvenute su un asset specifico (es. il Thales HSM Payment). */
/* Nota: Questa query restituirà risultati solo dopo aver effettuato modifiche (UPDATE) sull'asset */
/* pertanto è stata inserita una update prima dell'estrazione che mette in 'on-hold' l'asset da 'active' */
UPDATE asset
SET lifecycle_status = 'on hold'
WHERE identifier = 'HSM-PAY-SEC-01'
RETURNING asset_id, name, lifecycle_status;

SELECT * FROM asset_history 
WHERE asset_id = (SELECT asset_id FROM asset WHERE name='Thales HSM Payment' LIMIT 1) 
ORDER BY changed_at DESC;
