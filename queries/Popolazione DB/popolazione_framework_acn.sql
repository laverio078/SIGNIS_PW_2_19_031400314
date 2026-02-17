SET search_path = nis2, public;

/* * POPOLAMENTO FRAMEWORK ACN / NIST CSF  */

-- 1. FUNZIONE: IDENTIFY (ID)
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.AM-1', 'IDENTIFY', 'Asset Management', 'I dispositivi fisici e i sistemi all''interno dell''organizzazione sono inventariati'),
('ID.AM-2', 'IDENTIFY', 'Asset Management', 'Le piattaforme software e le applicazioni sono inventariate'),
('ID.AM-3', 'IDENTIFY', 'Asset Management', 'La mappatura delle comunicazioni e dei flussi di dati organizzativi è documentata'),
('ID.AM-4', 'IDENTIFY', 'Asset Management', 'I sistemi informativi esterni sono catalogati'),
('ID.AM-5', 'IDENTIFY', 'Asset Management', 'Prioritizzazione risorse in base a classificazione, criticità e valore aziendale'),
('ID.AM-6', 'IDENTIFY', 'Asset Management', 'Ruoli e responsabilità sicurezza informatica stabiliti per forza lavoro e stakeholder'),
('ID.BE-1', 'IDENTIFY', 'Business Environment', 'Il ruolo dell''organizzazione nella supply chain è identificato'),
('ID.BE-2', 'IDENTIFY', 'Business Environment', 'Posto dell''organizzazione nell''infrastruttura critica identificato'),
('ID.BE-3', 'IDENTIFY', 'Business Environment', 'Priorità della missione e obiettivi stabiliti'),
('ID.BE-5', 'IDENTIFY', 'Business Environment', 'Resilienza organizzativa richiede priorità di sicurezza'),
('ID.GV-1', 'IDENTIFY', 'Governance', 'Policy di sicurezza definita e comunicata'),
('ID.GV-2', 'IDENTIFY', 'Governance', 'Ruoli sicurezza coordinati e allineati'),
('ID.GV-3', 'IDENTIFY', 'Governance', 'Requisiti legali e normativi gestiti'),
('ID.GV-4', 'IDENTIFY', 'Governance', 'Processi di governance affrontano i rischi cyber'),
('ID.RA-1', 'IDENTIFY', 'Risk Assessment', 'Vulnerabilità asset identificate e documentate'),
('ID.RA-2', 'IDENTIFY', 'Risk Assessment', 'Threat Intelligence ricevuta da fonti esterne (es. CSIRT)'),
('ID.RA-3', 'IDENTIFY', 'Risk Assessment', 'Minacce interne ed esterne identificate'),
('ID.RA-5', 'IDENTIFY', 'Risk Assessment', 'Calcolo del rischio basato su minacce, vulnerabilità e impatto'),
('ID.RM-1', 'IDENTIFY', 'Risk Management Strategy', 'Processi gestione rischio stabiliti e concordati'),
('ID.RM-2', 'IDENTIFY', 'Risk Management Strategy', 'Tolleranza al rischio determinata ed espressa'),
('ID.RM-3', 'IDENTIFY', 'Risk Management Strategy', 'Tolleranza al rischio informata dal ruolo nelle infrastrutture critiche'),
('ID.SC-1', 'IDENTIFY', 'Supply Chain Risk Mng', 'Processi gestione rischio supply chain stabiliti'),
('ID.SC-2', 'IDENTIFY', 'Supply Chain Risk Mng', 'Fornitori valutati tramite audit o test'),
('ID.SC-3', 'IDENTIFY', 'Supply Chain Risk Mng', 'Contratti fornitori includono misure di sicurezza appropriate'),
('ID.SC-4', 'IDENTIFY', 'Supply Chain Risk Mng', 'Monitoraggio regolare adempimenti fornitori');

-- 2. FUNZIONE: PROTECT (PR)
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.AC-1', 'PROTECT', 'Access Control', 'Gestione identità e credenziali (IAM) verificata'),
('PR.AC-2', 'PROTECT', 'Access Control', 'Accesso fisico agli asset gestito e protetto'),
('PR.AC-3', 'PROTECT', 'Access Control', 'Accesso remoto gestito (VPN, MFA, Zero Trust)'),
('PR.AC-4', 'PROTECT', 'Access Control', 'Permessi gestiti con principio di minimo privilegio'),
('PR.AC-5', 'PROTECT', 'Access Control', 'Integrità della rete protetta (segmentazione, VLAN)'),
('PR.AC-6', 'PROTECT', 'Access Control', 'Identità verificate e vincolate alle transazioni (Non ripudio)'),
('PR.AC-7', 'PROTECT', 'Access Control', 'Autenticazione utenti/dispositivi basata sul rischio (MFA)'),
('PR.AT-1', 'PROTECT', 'Awareness & Training', 'Personale formato sui rischi cybersecurity'),
('PR.AT-2', 'PROTECT', 'Awareness & Training', 'Personale privilegiato comprende responsabilità specializzate'),
('PR.AT-5', 'PROTECT', 'Awareness & Training', 'Personale fisico/sicurezza comprende proprie responsabilità'),
('PR.DS-1', 'PROTECT', 'Data Security', 'Dati a riposo protetti (Crittografia Storage/DB)'),
('PR.DS-2', 'PROTECT', 'Data Security', 'Dati in transito protetti (TLS, VPN)'),
('PR.DS-3', 'PROTECT', 'Data Security', 'Asset gestiti durante trasferimenti e smaltimento'),
('PR.DS-5', 'PROTECT', 'Data Security', 'Meccanismi Data Loss Prevention (DLP) implementati'),
('PR.IP-1', 'PROTECT', 'Info Protection Processes', 'Baseline configurazione sistemi mantenuta'),
('PR.IP-3', 'PROTECT', 'Info Protection Processes', 'Change Management gestito'),
('PR.IP-4', 'PROTECT', 'Info Protection Processes', 'Backup condotti e testati periodicamente'),
('PR.IP-9', 'PROTECT', 'Info Protection Processes', 'Piani di risposta (Incident Response) mantenuti'),
('PR.IP-12', 'PROTECT', 'Info Protection Processes', 'Piano gestione vulnerabilità implementato'),
('PR.MA-1', 'PROTECT', 'Maintenance', 'Manutenzione asset registrata'),
('PR.MA-2', 'PROTECT', 'Maintenance', 'Manutenzione remota approvata e controllata'),
('PR.PT-1', 'PROTECT', 'Protective Technology', 'Log di audit determinati e rivisti'),
('PR.PT-2', 'PROTECT', 'Protective Technology', 'Supporti rimovibili protetti'),
('PR.PT-4', 'PROTECT', 'Protective Technology', 'Reti di comunicazione e controllo protette');

-- 3. FUNZIONE: DETECT (DE)
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('DE.AE-1', 'DETECT', 'Anomalies & Events', 'Baseline traffico rete mantenuta per rilevare anomalie'),
('DE.AE-2', 'DETECT', 'Anomalies & Events', 'Eventi analizzati per capire metodi di attacco'),
('DE.AE-3', 'DETECT', 'Anomalies & Events', 'Correlazione eventi da più fonti (SIEM)'),
('DE.AE-4', 'DETECT', 'Anomalies & Events', 'Impatto eventi determinato'),
('DE.CM-1', 'DETECT', 'Continuous Monitoring', 'Rete monitorata per eventi cyber'),
('DE.CM-2', 'DETECT', 'Continuous Monitoring', 'Ambiente fisico monitorato'),
('DE.CM-3', 'DETECT', 'Continuous Monitoring', 'Attività personale monitorata (Insider Threat)'),
('DE.CM-4', 'DETECT', 'Continuous Monitoring', 'Rilevamento codice malevolo (malware)'),
('DE.CM-7', 'DETECT', 'Continuous Monitoring', 'Monitoraggio accessi non autorizzati attivo'),
('DE.DP-1', 'DETECT', 'Detection Processes', 'Ruoli rilevamento definiti'),
('DE.DP-4', 'DETECT', 'Detection Processes', 'Processi rilevamento migliorati continuamente');

-- 4. FUNZIONE: RESPOND (RS)
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.RP-1', 'RESPOND', 'Response Planning', 'Piano risposta incidenti eseguito'),
('RS.CO-1', 'RESPOND', 'Communications', 'Personale conosce ruoli in risposta'),
('RS.CO-2', 'RESPOND', 'Communications', 'Segnalazione eventi conforme criteri (es. notifica ACN 24h)'),
('RS.CO-3', 'RESPOND', 'Communications', 'Informazioni condivise secondo piani'),
('RS.CO-5', 'RESPOND', 'Communications', 'Condivisione volontaria con stakeholder (CSIRT)'),
('RS.AN-1', 'RESPOND', 'Analysis', 'Notifiche sistemi rilevamento indagate'),
('RS.AN-2', 'RESPOND', 'Analysis', 'Impatto incidente compreso'),
('RS.AN-3', 'RESPOND', 'Analysis', 'Analisi forense eseguita'),
('RS.AN-4', 'RESPOND', 'Analysis', 'Incidenti categorizzati'),
('RS.MI-1', 'RESPOND', 'Mitigation', 'Incidenti contenuti (isolamento)'),
('RS.MI-2', 'RESPOND', 'Mitigation', 'Incidenti mitigati (patching/rimozione)'),
('RS.MI-3', 'RESPOND', 'Mitigation', 'Vulnerabilità mitigate o accettate come rischi'),
('RS.IM-1', 'RESPOND', 'Improvements', 'Lessons Learned incorporate nei piani'),
('RS.IM-2', 'RESPOND', 'Improvements', 'Strategie risposta aggiornate');

-- 5. FUNZIONE: RECOVER (RC)
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RC.RP-1', 'RECOVER', 'Recovery Planning', 'Piano ripristino eseguito'),
('RC.IM-1', 'RECOVER', 'Improvements', 'Piani ripristino incorporano lezioni apprese'),
('RC.IM-2', 'RECOVER', 'Improvements', 'Strategie ripristino aggiornate'),
('RC.CO-1', 'RECOVER', 'Communications', 'PR gestite per reputazione post-incidente'),
('RC.CO-3', 'RECOVER', 'Communications', 'Attività ripristino comunicate a stakeholder');