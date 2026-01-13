/* ============================================================================= */
/* PROJECT WORK: POPOLAMENTO MOCK DATA - SCENARIO - AUTO FISCO ITALIA S.P.A.     */
/* ============================================================================= */
/* Oggetto: Script di caricamento dati per "Auto Fisco Italia S.p.a."            */
/* Scenario: Soggetto Essenziale (Fiscalità e Registro Automobilitstico)         */
/* ============================================================================= */

SET search_path = nis2, public;

DO $$
DECLARE
    /* Variabili ID */
    v_org_id UUID;
    
    /* Ruoli (Potrebbero essere già definiti nella tabella ROLE da altri popolamenti) */
    v_role_ciso UUID;
    v_role_cio UUID;
    v_role_dpo UUID;
    v_role_tax_mgr UUID;
    
    /* Personale */
    v_person_conti UUID;
    v_person_ferri UUID;
    v_person_galli UUID;
    
    /* Fornitori */
    v_vendor_payment UUID;
    v_vendor_mainframe UUID;
    v_vendor_cloud UUID;
    
    /* Servizi & Asset */
    v_serv_registro_veicoli UUID;
    v_serv_riscossione_bollo UUID;
    v_serv_interscambio UUID;
    v_asset_mainframe_z UUID;
    v_asset_db_tax UUID;
    v_asset_hsm UUID;
    v_asset_web_portal UUID;
    
BEGIN

    /* ------------------------------------------------------------------------- */
    /* 1. GESTIONE DEI RUOLI CON CONTROLLO PER EVITARE DUPLICATI                 */
    /* ------------------------------------------------------------------------- */
    
    /* CISO: Verifico se il ruolo esiste già, altrimenti viene creato */
    SELECT role_id INTO v_role_ciso FROM role WHERE code = 'CISO';
    IF v_role_ciso IS NULL THEN
        INSERT INTO role (code, description) VALUES ('CISO', 'Chief Information Security Officer') RETURNING role_id INTO v_role_ciso;
    END IF;

    /* DPO: Cerchiamo se esiste già */
    SELECT role_id INTO v_role_dpo FROM role WHERE code = 'DPO';
    IF v_role_dpo IS NULL THEN
        INSERT INTO role (code, description) VALUES ('DPO', 'Data Protection Officer') RETURNING role_id INTO v_role_dpo;
    END IF;

    /* CIO: Nuovo per questo script, ma controlliamo per sicurezza */
    SELECT role_id INTO v_role_cio FROM role WHERE code = 'CIO';
    IF v_role_cio IS NULL THEN
        INSERT INTO role (code, description) VALUES ('CIO', 'Chief Information Officer') RETURNING role_id INTO v_role_cio;
    END IF;

    /* TAX-MGR: Ruolo specifico, probabilmente non esiste */
    SELECT role_id INTO v_role_tax_mgr FROM role WHERE code = 'TAX-MGR';
    IF v_role_tax_mgr IS NULL THEN
        INSERT INTO role (code, description) VALUES ('TAX-MGR', 'Responsabile Divisione Riscossione Tributi') RETURNING role_id INTO v_role_tax_mgr;
    END IF;


    /* ------------------------------------------------------------------------- */
    /* 2. DEFINIZIONE ORGANIZZAZIONE  (in questo caso società para-pubblic       */
    /* ------------------------------------------------------------------------- */
    INSERT INTO organization (name, vat, address, contact_email, contact_phone)
    VALUES (
        'AutoFisco Italia S.p.A.', 
        'IT99887766554', 
        'Via della Zecca 100, 00144 Roma (RM)', 
        'compliance@autofisco-italia.it', 
        '+39 06 99988877'
    ) RETURNING organization_id INTO v_org_id;

    RAISE NOTICE 'Generata organizzazione AutoFisco Italia con ID: %', v_org_id;


    /* ------------------------------------------------------------------------- */
    /* 3. INSERIMENTO DEL PERSONALE                                              */
    /* ------------------------------------------------------------------------- */
    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Alessandro', 'Conti', 'alessandro.conti@autofisco-italia.it', '+39 335 112233', '{"department": "Sicurezza"}'::jsonb) 
    RETURNING person_id INTO v_person_conti;

    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Beatrice', 'Ferri', 'beatrice.ferri@autofisco-italia.it', '+39 335 445566', '{"department": "IT"}'::jsonb) 
    RETURNING person_id INTO v_person_ferri;

    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Giorgio', 'Galli', 'giorgio.galli@autofisco-italia.it', '+39 335 778899', '{"department": "Riscossione"}'::jsonb) 
    RETURNING person_id INTO v_person_galli;


    /* ------------------------------------------------------------------------- */
    /* 4. ASSEGNAZIONE DELLE RESPONSABILITÀ                                      */
    /* ------------------------------------------------------------------------- */
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_conti, v_role_ciso, 'organization', v_org_id);
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_ferri, v_role_cio, 'organization', v_org_id);
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_galli, v_role_tax_mgr, 'organization', v_org_id);


    /* ------------------------------------------------------------------------- */
    /* 5. FORNITORI (Inserimento standard, ID univoci non creano conflitto)      */
    /* ------------------------------------------------------------------------- */
    /* Pur avendo fornitori comuni, potrebbero non esserlo del tutto e comunque 
       è preferibile mantere una separazione fra le organizzazioni come se nessuna 
       sapesse dell'altra. */
       
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('PayTech Solutions S.p.A.', 'Supporto Merchant', 'helpdesk@paytech-sol.it', '{"service": "Gateway PagoPA"}'::jsonb) RETURNING vendor_id INTO v_vendor_payment;
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('Legacy Systems Italia S.r.l.', 'Ing. Cobol', 'support@legacy-systems.it', '{"contract": "Gold SLA"}'::jsonb) RETURNING vendor_id INTO v_vendor_mainframe;
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('CloudSecure Italy', 'Sales Team', 'info@cloudsecure.it', '{"certification": "ISO 27001"}'::jsonb) RETURNING vendor_id INTO v_vendor_cloud;


    /* ------------------------------------------------------------------------- */
    /* 6. SERVIZI                                                                */
    /* ------------------------------------------------------------------------- */
    INSERT INTO service (organization_id, name, description, service_owner, criticality) VALUES (v_org_id, 'Registro Unico Veicoli (RUV)', 'Database nazionale centralizzato', v_person_ferri, 5) RETURNING service_id INTO v_serv_registro_veicoli;
    INSERT INTO service (organization_id, name, description, service_owner, criticality) VALUES (v_org_id, 'Piattaforma Riscossione Bollo', 'Sistema incasso tasse', v_person_galli, 5) RETURNING service_id INTO v_serv_riscossione_bollo;
    INSERT INTO service (organization_id, name, description, service_owner, criticality) VALUES (v_org_id, 'Gateway API Interforze', 'Scambio dati Polizia', v_person_conti, 4) RETURNING service_id INTO v_serv_interscambio;


    /* ------------------------------------------------------------------------- */
    /* 7. ASSET                                                                  */
    /* ------------------------------------------------------------------------- */
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Mainframe IBM z16', 'MF-RUV-CORE-01', 5, v_person_ferri) RETURNING asset_id INTO v_asset_mainframe_z;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'software', 'Oracle RAC Financial DB', 'DB-TAX-FIN-01', 5, v_person_ferri) RETURNING asset_id INTO v_asset_db_tax;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Thales HSM Payment', 'HSM-PAY-SEC-01', 5, v_person_conti) RETURNING asset_id INTO v_asset_hsm;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'service', 'Cluster Frontend K8s', 'K8S-WEB-PORTAL', 3, v_person_ferri) RETURNING asset_id INTO v_asset_web_portal;


    /* ------------------------------------------------------------------------- */
    /* 8. RELAZIONI                                                              */
    /* ------------------------------------------------------------------------- */
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_registro_veicoli, v_asset_mainframe_z, 'core');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_riscossione_bollo, v_asset_db_tax, 'ledger');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_riscossione_bollo, v_asset_hsm, 'crypto');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_riscossione_bollo, v_asset_web_portal, 'frontend');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_interscambio, v_asset_mainframe_z, 'data_source');

    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_registro_veicoli, v_vendor_mainframe, 'Manutenzione HW/SW', 'Support', 5);
    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_riscossione_bollo, v_vendor_payment, 'Gateway Transazioni', 'FinTech', 5);
    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_riscossione_bollo, v_vendor_cloud, 'Hosting Portale', 'IaaS', 3);

    RAISE NOTICE 'Popolamento scenario AutoFisco Italia completato con successo.';

END $$;
