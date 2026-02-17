/* * PROJECT WORK: MOCK DATA - SCENARIO AUTOMOTIVE / PA 
 * Ente: Agenzia Nazionale Mobilità (ANMSS)
 * Note: Dati anonimizzati per ambiente di test
 */

SET search_path = nis2, public;

DO $$
DECLARE
    -- ID Variabili
    v_org_id UUID;
    v_role_ciso UUID; v_role_rtd UUID; v_role_sysadmin UUID; v_role_fleet_mgr UUID;
    v_person_rossi UUID; v_person_bianchi UUID; v_person_verdi UUID;
    v_vendor_telematics UUID; v_vendor_cloud_infra UUID; v_vendor_sw_registry UUID;
    v_serv_registro_veicoli UUID; v_serv_smart_road UUID; v_serv_prenotazioni UUID;
    v_asset_mainframe_db UUID; v_asset_iot_gateway UUID; v_asset_web_cluster UUID; v_asset_storage_cams UUID;
    
BEGIN

    -- 1. GESTIONE RUOLI (Check esistenza per evitare dup)
    SELECT role_id INTO v_role_ciso FROM role WHERE code = 'CISO';
    IF v_role_ciso IS NULL THEN INSERT INTO role (code, description) VALUES ('CISO', 'Chief Information Security Officer') RETURNING role_id INTO v_role_ciso; END IF;

    SELECT role_id INTO v_role_rtd FROM role WHERE code = 'RTD';
    IF v_role_rtd IS NULL THEN INSERT INTO role (code, description) VALUES ('RTD', 'Responsabile Transizione Digitale') RETURNING role_id INTO v_role_rtd; END IF;

    SELECT role_id INTO v_role_sysadmin FROM role WHERE code = 'SYSADMIN';
    IF v_role_sysadmin IS NULL THEN INSERT INTO role (code, description) VALUES ('SYSADMIN', 'Amministratore Sistemi ITS') RETURNING role_id INTO v_role_sysadmin; END IF;

    SELECT role_id INTO v_role_fleet_mgr FROM role WHERE code = 'OPS-MGR';
    IF v_role_fleet_mgr IS NULL THEN INSERT INTO role (code, description) VALUES ('OPS-MGR', 'Responsabile Centro Operativo Viabilità') RETURNING role_id INTO v_role_fleet_mgr; END IF;


    -- 2. DEFINIZIONE ENTE
    INSERT INTO organization (name, vat, address, contact_email, contact_phone)
    VALUES ('Agenzia Nazionale per la Mobilità e la Sicurezza Stradale (ANMSS)', 'IT00112233445', 'Viale dell''Automobile 50, 10100 Torino (TO)', 'sicurezza@anmss.gov.it', '+39 011 55667788') 
    RETURNING organization_id INTO v_org_id;

    -- 3. STAFF TECNICO
    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Marco', 'Rossi', 'marco.rossi@anmss.gov.it', '+39 335 101010', '{"department": "Cybersecurity Automotive"}'::jsonb) RETURNING person_id INTO v_person_rossi;

    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Elena', 'Bianchi', 'elena.bianchi@anmss.gov.it', '+39 335 202020', '{"department": "Omologazioni"}'::jsonb) RETURNING person_id INTO v_person_bianchi;

    INSERT INTO person (organization_id, given_name, family_name, email, phone, metadata)
    VALUES (v_org_id, 'Roberto', 'Verdi', 'roberto.verdi@anmss.gov.it', '+39 335 303030', '{"department": "Infrastrutture Smart Road"}'::jsonb) RETURNING person_id INTO v_person_verdi;

    -- Assegnazione Responsabilità
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_rossi, v_role_ciso, 'organization', v_org_id);
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_bianchi, v_role_fleet_mgr, 'organization', v_org_id);
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_verdi, v_role_sysadmin, 'organization', v_org_id);


    -- 4. SUPPLY CHAIN
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('Infomobility Tech S.p.A.', 'Ing. Can Bus', 'support@infomobility-tech.it', '{"specialization": "Industrial IoT", "certification": "TISAX"}'::jsonb) RETURNING vendor_id INTO v_vendor_telematics;
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('SecureDrive Cloud S.r.l.', 'Cloud Admin', 'noc@securedrive-cloud.it', '{"service_type": "IaaS High Performance"}'::jsonb) RETURNING vendor_id INTO v_vendor_cloud_infra;
    INSERT INTO vendor (name, contact_name, contact_email, metadata) VALUES ('MotorSoft Gestionale PA', 'Assistenza Clienti', 'help@motorsoft-pa.it', '{"contract": "Mainframe Maintenance"}'::jsonb) RETURNING vendor_id INTO v_vendor_sw_registry;


    -- 5. SERVIZI & ASSET
    INSERT INTO service (organization_id, name, description, service_owner, criticality, business_impact) VALUES (v_org_id, 'Registro Nazionale Veicoli (RNV)', 'DB centralizzato immatricolazioni', v_person_bianchi, 5, 'Blocco totale compravendite e controlli') RETURNING service_id INTO v_serv_registro_veicoli;
    INSERT INTO service (organization_id, name, description, service_owner, criticality, business_impact) VALUES (v_org_id, 'Piattaforma Smart Road & V2X', 'Gestione segnaletica variabile', v_person_verdi, 4, 'Rischi sicurezza stradale') RETURNING service_id INTO v_serv_smart_road;
    INSERT INTO service (organization_id, name, description, service_owner, criticality, business_impact) VALUES (v_org_id, 'Portale Prenotazione Revisioni', 'Front-end web cittadini', v_person_bianchi, 2, 'Disservizio cittadino') RETURNING service_id INTO v_serv_prenotazioni;

    -- Inventario
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'software', 'Oracle Exadata - DB Veicoli', 'DB-RNV-PROD-01', 5, v_person_verdi) RETURNING asset_id INTO v_asset_mainframe_db;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Industrial IoT Gateway Traffic', 'IOT-GW-A1-MILANO', 5, v_person_verdi) RETURNING asset_id INTO v_asset_iot_gateway;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Cluster K8s Frontend', 'K8S-CL-WEB-01', 3, v_person_verdi) RETURNING asset_id INTO v_asset_web_cluster;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Storage Area Network (Video)', 'SAN-CAM-TRAFFIC', 3, v_person_rossi) RETURNING asset_id INTO v_asset_storage_cams;
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'hardware', 'Workstation Analisi Forense CISO', 'WS-SEC-ROSSI', 4, v_person_verdi);
    INSERT INTO asset (organization_id, asset_type, name, identifier, criticality, created_by) VALUES (v_org_id, 'software', 'Licenza AI Traffic Analyzer', 'LIC-AI-TRF-99', 4, v_person_verdi);

    -- Collegamento Servizi-Asset
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_registro_veicoli, v_asset_mainframe_db, 'core_database');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_registro_veicoli, v_asset_web_cluster, 'api_gateway');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_smart_road, v_asset_iot_gateway, 'edge_computing_node');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_smart_road, v_asset_storage_cams, 'data_lake_video');
    INSERT INTO service_asset (service_id, asset_id, role_in_service) VALUES (v_serv_prenotazioni, v_asset_web_cluster, 'web_frontend');

    -- Dipendenze
    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_registro_veicoli, v_vendor_sw_registry, 'Manutenzione correttiva applicativo legacy RNV', 'Supply Chain', 5);
    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_smart_road, v_vendor_telematics, 'Gestione rete sensori V2X e pannelli', 'Managed Service / IoT', 5);
    INSERT INTO dependency (service_id, vendor_id, description, dependency_type, criticality) VALUES (v_serv_prenotazioni, v_vendor_cloud_infra, 'Hosting scalabile portale pubblico', 'IaaS', 3);

    -- Assegnazione Responsabilità puntuale (Test query RACI)
    INSERT INTO responsability (organization_id, person_id, role_id, target_type, target_id) VALUES (v_org_id, v_person_verdi, v_role_sysadmin, 'service', v_serv_smart_road);

    /* * SECURITY PROFILE & COMPLIANCE 
     * Inserimento valutazioni Tier e Gap Analysis
     */
    
    -- 1. IoT Gateway: Problema fisico grave
    INSERT INTO security_profile (asset_id, subcategory_code, implementation_tier_current, status_current, implementation_tier_target, gap_analysis)
    VALUES (v_asset_iot_gateway, 'PR.AC-2', 'Tier 1', 'Non Implementato', 'Tier 3', 'FIXME: Armadi su strada ancora con chiavi standard (triangolari). Manca tamper switch.');
    
    -- 2. IoT Gateway: Segmentazione OK
    INSERT INTO security_profile (asset_id, subcategory_code, implementation_tier_current, status_current, implementation_tier_target, gap_analysis)
    VALUES (v_asset_iot_gateway, 'PR.AC-5', 'Tier 3', 'Implementato', 'Tier 3', 'Traffico su APN privato segregato. Nessun accesso internet pubblico.');

    -- 3. Web Cluster: Patching OK
    INSERT INTO security_profile (asset_id, subcategory_code, implementation_tier_current, status_current, implementation_tier_target, gap_analysis)
    VALUES (v_asset_web_cluster, 'PR.IP-12', 'Tier 3', 'Implementato', 'Tier 3', 'Pipeline CI/CD attiva con scansione Trivy su immagini docker.');
    
    -- 4. Web Cluster: Supply Chain Cloud KO
    INSERT INTO security_profile (asset_id, subcategory_code, implementation_tier_current, status_current, implementation_tier_target, gap_analysis)
    VALUES (v_asset_web_cluster, 'ID.SC-2', 'Tier 2', 'Parziale', 'Tier 3', 'Audit fornitore Cloud scaduto > 12 mesi. Sollecitare report SOC2 Type II.');

    RAISE NOTICE 'Caricamento scenario ANMSS completato.';

END $$;