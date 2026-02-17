SET search_path = nis2, public;

/* ============================================================================= */
/* POPOLAMENTO COMPLETO FRAMEWORK ACN / NIST CSF v1.1                            */
/* ============================================================================= */
/* Questo script popola la tabella di lookup 'acn_subcategory' con le 5 Funzioni */
/* Core, le 23 Categorie e le relative Sottocategorie principali.                */
/* ============================================================================= */

/* ----------------------------------------------------------------------------- */
/* 1. FUNZIONE: IDENTIFY (ID) - Identificare                                     */
/* ----------------------------------------------------------------------------- */

/* Categoria: Asset Management (ID.AM) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.AM-1', 'IDENTIFY', 'Asset Management', 'I dispositivi fisici e i sistemi all''interno dell''organizzazione sono inventariati'),
('ID.AM-2', 'IDENTIFY', 'Asset Management', 'Le piattaforme software e le applicazioni sono inventariate'),
('ID.AM-3', 'IDENTIFY', 'Asset Management', 'La mappatura delle comunicazioni e dei flussi di dati organizzativi è documentata'),
('ID.AM-4', 'IDENTIFY', 'Asset Management', 'I sistemi informativi esterni sono catalogati'),
('ID.AM-5', 'IDENTIFY', 'Asset Management', 'Le risorse (hardware, dispositivi, dati, tempo, personale e software) sono priorizzate in base alla loro classificazione, criticità e valore aziendale'),
('ID.AM-6', 'IDENTIFY', 'Asset Management', 'I ruoli e le responsabilità per la sicurezza informatica sono stabiliti per l''intera forza lavoro e per gli stakeholder esterni (es. fornitori, clienti, partner)');

/* Categoria: Business Environment (ID.BE) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.BE-1', 'IDENTIFY', 'Business Environment', 'Il ruolo dell''organizzazione nella catena di fornitura è identificato e comunicato'),
('ID.BE-2', 'IDENTIFY', 'Business Environment', 'Il posto dell''organizzazione nell''infrastruttura critica e nel settore di appartenenza è identificato'),
('ID.BE-3', 'IDENTIFY', 'Business Environment', 'Le priorità della missione, degli obiettivi e delle attività dell''organizzazione sono stabilite e comunicate'),
('ID.BE-5', 'IDENTIFY', 'Business Environment', 'La resilienza organizzativa richiede priorità e requisiti di sicurezza delle informazioni');

/* Categoria: Governance (ID.GV) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.GV-1', 'IDENTIFY', 'Governance', 'La politica di sicurezza delle informazioni è definita e comunicata'),
('ID.GV-2', 'IDENTIFY', 'Governance', 'I ruoli e le responsabilità per la sicurezza delle informazioni sono coordinati e allineati con i ruoli interni ed esterni'),
('ID.GV-3', 'IDENTIFY', 'Governance', 'I requisiti legali e normativi relativi alla cybersecurity sono compresi e gestiti'),
('ID.GV-4', 'IDENTIFY', 'Governance', 'I processi di governance e gestione del rischio affrontano i rischi di cybersecurity');

/* Categoria: Risk Assessment (ID.RA) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.RA-1', 'IDENTIFY', 'Risk Assessment', 'Le vulnerabilità degli asset sono identificate e documentate'),
('ID.RA-2', 'IDENTIFY', 'Risk Assessment', 'Le informazioni sulle minacce e la Cyber Threat Intelligence sono ricevute da forum di condivisione delle informazioni e fonti esterne (es. CSIRT Italia)'),
('ID.RA-3', 'IDENTIFY', 'Risk Assessment', 'Le minacce, sia interne che esterne, sono identificate e documentate'),
('ID.RA-5', 'IDENTIFY', 'Risk Assessment', 'Le minacce, le vulnerabilità, le probabilità e gli impatti sono utilizzati per determinare il rischio');

/* Categoria: Risk Management Strategy (ID.RM) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.RM-1', 'IDENTIFY', 'Risk Management Strategy', 'I processi di gestione del rischio sono stabiliti, gestiti e concordati dalle parti interessate'),
('ID.RM-2', 'IDENTIFY', 'Risk Management Strategy', 'La tolleranza al rischio organizzativo è determinata ed espressa chiaramente'),
('ID.RM-3', 'IDENTIFY', 'Risk Management Strategy', 'La determinazione della tolleranza al rischio è informata dal ruolo dell''organizzazione nelle infrastrutture critiche');

/* Categoria: Supply Chain Risk Management (ID.SC) - CRUCIALE PER NIS2 */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('ID.SC-1', 'IDENTIFY', 'Supply Chain Risk Mng', 'I processi di gestione del rischio della catena di fornitura sono identificati, stabiliti, valutati, gestiti e concordati'),
('ID.SC-2', 'IDENTIFY', 'Supply Chain Risk Mng', 'I fornitori e le terze parti sono valutati utilizzando audit, test o altre forme di valutazione'),
('ID.SC-3', 'IDENTIFY', 'Supply Chain Risk Mng', 'I contratti con i fornitori/partner sono utilizzati per implementare misure appropriate progettate per soddisfare gli obiettivi di sicurezza'),
('ID.SC-4', 'IDENTIFY', 'Supply Chain Risk Mng', 'I fornitori e i partner sono monitorati regolarmente per confermare che abbiano adempiuto ai loro obblighi contrattuali');


/* ----------------------------------------------------------------------------- */
/* 2. FUNZIONE: PROTECT (PR) - Proteggere                                      */
/* ----------------------------------------------------------------------------- */

/* Categoria: Identity Management & Access Control (PR.AC) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.AC-1', 'PROTECT', 'Access Control', 'Le identità e le credenziali sono gestite e verificate all''interno dell''organizzazione (IAM)'),
('PR.AC-2', 'PROTECT', 'Access Control', 'L''accesso fisico agli asset è gestito e protetto'),
('PR.AC-3', 'PROTECT', 'Access Control', 'L''accesso remoto è gestito (VPN, MFA, Zero Trust)'),
('PR.AC-4', 'PROTECT', 'Access Control', 'I permessi di accesso e le autorizzazioni sono gestiti incorporando i principi di minimo privilegio'),
('PR.AC-5', 'PROTECT', 'Access Control', 'L''integrità della rete è protetta (es. segmentazione di rete, VLAN)'),
('PR.AC-6', 'PROTECT', 'Access Control', 'Le identità sono verificate e vincolate alle transazioni e alle interazioni (Non ripudio)'),
('PR.AC-7', 'PROTECT', 'Access Control', 'Gli utenti, i dispositivi e gli altri asset sono autenticati (es. single-factor, multi-factor) in base al rischio della transazione');

/* Categoria: Awareness and Training (PR.AT) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.AT-1', 'PROTECT', 'Awareness & Training', 'Tutto il personale è formato sui rischi di sicurezza informatica'),
('PR.AT-2', 'PROTECT', 'Awareness & Training', 'Il personale privilegiato (es. Admin) comprende ruoli e responsabilità specializzati'),
('PR.AT-5', 'PROTECT', 'Awareness & Training', 'Il personale fisico e di sicurezza comprende le proprie responsabilità');

/* Categoria: Data Security (PR.DS) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.DS-1', 'PROTECT', 'Data Security', 'I dati a riposo sono protetti (Crittografia Storage/DB)'),
('PR.DS-2', 'PROTECT', 'Data Security', 'I dati in transito sono protetti (TLS, VPN)'),
('PR.DS-3', 'PROTECT', 'Data Security', 'Gli asset sono formalmente gestiti durante trasferimenti, rimozioni e smaltimento'),
('PR.DS-5', 'PROTECT', 'Data Security', 'Sono implementati meccanismi contro la perdita di dati (Data Loss Prevention - DLP)');

/* Categoria: Information Protection Processes and Procedures (PR.IP) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.IP-1', 'PROTECT', 'Info Protection Processes', 'Viene creata e mantenuta una configurazione di base (Baseline) dei sistemi'),
('PR.IP-3', 'PROTECT', 'Info Protection Processes', 'I processi di gestione delle modifiche (Change Management) sono mantenuti'),
('PR.IP-4', 'PROTECT', 'Info Protection Processes', 'I backup delle informazioni sono condotti, mantenuti e testati periodicamente'),
('PR.IP-9', 'PROTECT', 'Info Protection Processes', 'I piani di risposta agli asset (Incident Response) sono gestiti e mantenuti'),
('PR.IP-12', 'PROTECT', 'Info Protection Processes', 'Un piano di gestione delle vulnerabilità è sviluppato e implementato');

/* Categoria: Maintenance (PR.MA) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.MA-1', 'PROTECT', 'Maintenance', 'La manutenzione e la riparazione degli asset sono eseguite e registrate'),
('PR.MA-2', 'PROTECT', 'Maintenance', 'La manutenzione remota degli asset organizzativi è approvata, registrata e controllata');

/* Categoria: Protective Technology (PR.PT) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('PR.PT-1', 'PROTECT', 'Protective Technology', 'I record di audit/log sono determinati, documentati, implementati e rivisti'),
('PR.PT-2', 'PROTECT', 'Protective Technology', 'I supporti rimovibili sono protetti e il loro uso limitato'),
('PR.PT-4', 'PROTECT', 'Protective Technology', 'Le reti di comunicazione e controllo sono protette');


/* ----------------------------------------------------------------------------- */
/* 3. FUNZIONE: DETECT (DE) - Rilevare                                         */
/* ----------------------------------------------------------------------------- */

/* Categoria: Anomalies and Events (DE.AE) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('DE.AE-1', 'DETECT', 'Anomalies & Events', 'Viene mantenuta una baseline del traffico di rete atteso per rilevare anomalie'),
('DE.AE-2', 'DETECT', 'Anomalies & Events', 'Gli eventi rilevati sono analizzati per comprendere obiettivi e metodi di attacco'),
('DE.AE-3', 'DETECT', 'Anomalies & Events', 'I dati degli eventi sono raccolti e correlati da più fonti (SIEM/Log Management)'),
('DE.AE-4', 'DETECT', 'Anomalies & Events', 'L''impatto degli eventi è determinato');

/* Categoria: Security Continuous Monitoring (DE.CM) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('DE.CM-1', 'DETECT', 'Continuous Monitoring', 'La rete è monitorata per rilevare potenziali eventi di cybersecurity'),
('DE.CM-2', 'DETECT', 'Continuous Monitoring', 'L''ambiente fisico è monitorato per rilevare potenziali eventi'),
('DE.CM-3', 'DETECT', 'Continuous Monitoring', 'L''attività del personale è monitorata per rilevare potenziali eventi (Insider Threat)'),
('DE.CM-4', 'DETECT', 'Continuous Monitoring', 'Il codice malevolo (malware) viene rilevato'),
('DE.CM-7', 'DETECT', 'Continuous Monitoring', 'Il monitoraggio per accessi non autorizzati e connessioni è attivo');

/* Categoria: Detection Processes (DE.DP) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('DE.DP-1', 'DETECT', 'Detection Processes', 'I ruoli e le responsabilità per il rilevamento sono definiti'),
('DE.DP-4', 'DETECT', 'Detection Processes', 'I processi di rilevamento degli eventi sono continuamente migliorati');


/* ----------------------------------------------------------------------------- */
/* 4. FUNZIONE: RESPOND (RS) - Rispondere                                      */
/* ----------------------------------------------------------------------------- */

/* Categoria: Response Planning (RS.RP) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.RP-1', 'RESPOND', 'Response Planning', 'Il piano di risposta agli incidenti è eseguito durante o dopo un evento');

/* Categoria: Communications (RS.CO) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.CO-1', 'RESPOND', 'Communications', 'Il personale conosce i propri ruoli nell''ordine di risposta'),
('RS.CO-2', 'RESPOND', 'Communications', 'Gli eventi sono segnalati in conformità con i criteri stabiliti (es. Notifica ACN entro 24h)'),
('RS.CO-3', 'RESPOND', 'Communications', 'Le informazioni sono condivise in conformità con i piani di risposta'),
('RS.CO-5', 'RESPOND', 'Communications', 'La condivisione volontaria delle informazioni avviene con stakeholder esterni (es. CSIRT)');

/* Categoria: Analysis (RS.AN) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.AN-1', 'RESPOND', 'Analysis', 'Le notifiche dai sistemi di rilevamento sono indagate'),
('RS.AN-2', 'RESPOND', 'Analysis', 'L''impatto dell''incidente è compreso'),
('RS.AN-3', 'RESPOND', 'Analysis', 'L''analisi forense è eseguita'),
('RS.AN-4', 'RESPOND', 'Analysis', 'Gli incidenti sono categorizzati coerentemente con i piani di risposta');

/* Categoria: Mitigation (RS.MI) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.MI-1', 'RESPOND', 'Mitigation', 'Gli incidenti sono contenuti (es. isolamento host, blocco traffico)'),
('RS.MI-2', 'RESPOND', 'Mitigation', 'Gli incidenti sono mitigati (es. rimozione malware, patch)'),
('RS.MI-3', 'RESPOND', 'Mitigation', 'Le vulnerabilità appena identificate sono mitigate o accettate come rischi');

/* Categoria: Improvements (RS.IM) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RS.IM-1', 'RESPOND', 'Improvements', 'I piani di risposta incorporano le lezioni apprese (Lessons Learned)'),
('RS.IM-2', 'RESPOND', 'Improvements', 'Le strategie di risposta sono aggiornate');


/* ----------------------------------------------------------------------------- */
/* 5. FUNZIONE: RECOVER (RC) - Ripristinare                                    */
/* ----------------------------------------------------------------------------- */

/* Categoria: Recovery Planning (RC.RP) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RC.RP-1', 'RECOVER', 'Recovery Planning', 'Il piano di ripristino è eseguito durante o dopo un evento');

/* Categoria: Improvements (RC.IM) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RC.IM-1', 'RECOVER', 'Improvements', 'I piani di ripristino incorporano le lezioni apprese'),
('RC.IM-2', 'RECOVER', 'Improvements', 'Le strategie di ripristino sono aggiornate');

/* Categoria: Communications (RC.CO) */
INSERT INTO acn_subcategory (code, function_name, category_name, description) VALUES 
('RC.CO-1', 'RECOVER', 'Communications', 'Le pubbliche relazioni sono gestite per riparare la reputazione dopo un incidente'),
('RC.CO-3', 'RECOVER', 'Communications', 'Le attività di ripristino sono comunicate agli stakeholder interni ed esterni');