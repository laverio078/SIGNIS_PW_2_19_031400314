SET search_path = nis2, public;

/* Matrice RACI */
SELECT 
    s.name AS service_name,
    r.code AS role_code,
    r.description AS role_description,
    concat(p.given_name, ' ', coalesce(p.family_name,'')) AS person_name,
    p.email AS person_email,
    resp.target_type AS responsibility_scope -- Indica se la responsabilità deriva dal servizio o dall'organizzazione.
FROM service s
/* JOIN "Ereditaria": 
   Prende la responsabilità se è assegnata specificamente al servizio
   o se viene ereditata per scala gerarchica (es. il CISO vale per tutti i servizi) */
LEFT JOIN responsability resp 
    ON (resp.target_type = 'service' AND resp.target_id = s.service_id)
    OR (resp.target_type = 'organization' AND resp.target_id = s.organization_id)
LEFT JOIN person p ON p.person_id = resp.person_id
LEFT JOIN role r ON r.role_id = resp.role_id
WHERE s.organization_id = (SELECT organization_id FROM organization WHERE name='Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)')
ORDER BY s.name, r.code;
