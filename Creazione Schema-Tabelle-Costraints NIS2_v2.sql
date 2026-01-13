/* ============================================================================= */
/* Schema per Project Work NIS2, traccia 2.19: Registro asset/servizi/dipendenze */
/* ============================================================================= */

/* La nomenclatura di campi, tabelle, viste e indici viene realizzata in lingua inglese per facilitarne la portabilità in altri contesti essendo la normativa NIS2 di competenza europea */

/* Pre-requisiti: estensione uuid-ossp, normalmente non attiva. Nota per un eventuale porting: su altri database come SQL Server o MySQL le funzionalità di id univoco sono già presenti e hanno altri nomi.  */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

/* Creazione SCHEMA, consente di mantenere separati i dati dell'applicazione da quelli di funzionamento del db, personalmente preferisco l'approccio MySQL-like a quello Oracle-like' */
CREATE SCHEMA IF NOT EXISTS nis2;
SET search_path = nis2, public;

/* Per ogni tabella si definisce una chiave primaria contenente un uuid completamente casuale di 128-bit */
/* 1) Creazione della tabella "organization"", contiene i campi relativi all'organizzazione funzionale es. Una o più società per cui si crea l'assessment NIS2 ' */
CREATE TABLE organization (
    organization_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,                                 /* Nome dell'organizzazione */ 
    vat varchar(13),                                           /* partita IVA o identificativo */
    address TEXT,                                       /* sede sociale. Nel caso di ditte individuale - se ce ne fossero - si usa la residenza del titolare */
    contact_email varchar(100),                                 /* email di contatto */
    contact_phone varchar(20),                                 /* telefono */
    created_at timestamptz DEFAULT now()                /* timestamp di definizione del record */
);

CREATE UNIQUE INDEX ux_org_name ON organization( name );   /* si definisce un indice univoco sulla colonna "name" per evitare duplicazioni */

/* 2) Creazione della tabella "vendor", corrisponde all'elenco dei fornitori (in NIS2, terze parti) */
CREATE TABLE vendor (
    vendor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  
    name TEXT NOT NULL,                                 /* nome del fornitore o ragione sociale */
    contact_name varchar(120),                                  /* nome del riferimento commerciale o di contatto */
    contact_email varchar(100),                                 /* email */  
    contact_phone varchar(20),                                 /* telefono */
    metadata jsonb DEFAULT '{}'::jsonb,                 /* dettagli contrattuali, SLA, etc. */
    created_at timestamptz DEFAULT now()                /* timestamp di definizione del record */
);

CREATE INDEX idx_vendor_name ON vendor(name);

/* 3) Creazione della tabella "person", corrispondente al "punto di contatto" (o referente interno) della normativa NIS2 ) */
CREATE TABLE person (
    person_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES organization(organization_id) ON DELETE CASCADE,    /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "organization" */
    given_name varchar(60) NOT NULL,                           /* nome del contatto */
    family_name varchar(60),                                   /* cognome */
    email varchar(100),                                         /* email */
    phone varchar(20),                                         /* telefono */
    metadata jsonb DEFAULT '{}'::jsonb,                 /* eventuali metadati necessari per l'identificazione o dettagli sulla tipologia di contatto */
    created_at timestamptz DEFAULT now()                /* timestamp di definizione del record */
);
CREATE INDEX idx_person_email ON person(email);         /* definizione di un indice sul campo email per il recupero rapido del dato*/

/* 4) Creazione della tabella "ruolo" recante la definizione dei ruoli ricoperti dai "punti di contatto" */
CREATE TABLE role (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code varchar(10) NOT NULL,                                 /* Per esempio CTO, CISO, Owner */
    description TEXT,                                   /* Descrizione, per esempio: responsabile della sicurezza, owner di progetto, etc. */
    created_at timestamptz DEFAULT now(),               /* definizione di un indice sul campo email per il recupero rapido del dato */
    UNIQUE(code)                                        /* Si definisce il valore del campo "code" come univoco */
);

/* 5) Creazione della tabella "asset", che contiene l'oggetto di rischio */
CREATE TABLE asset (
    asset_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES organization(organization_id) ON DELETE CASCADE,  /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "organization" */
    asset_type varchar(60) NOT NULL,                           /* Categoria di asset, per esempio 'hardware','software','data','service' */
    name varchar(40) NOT NULL,                                 /* nome dell'oggetto' */
    identifier varchar(40),                                    /* Identificatore specifico, per esempio tag, hostname, seriale */
    criticality SMALLINT DEFAULT 3,                     /* 1 (basso) .. 5 (critico), come predefinito si usa un valore intermedio, 3 */
    lifecycle_status varchar(20) DEFAULT 'active',             /* posizione nel ciclo di vita dell'oggetto, di default si usa active, gli altri valori validi possono essere: "off", "on hold", "decommissioned" */
    metadata jsonb DEFAULT '{}'::jsonb,                 /* Eventuali metadati aggiuntivi specifici dell'oggetto, per esempio, riferimento all'uso che se ne fa */
    created_by UUID REFERENCES person(person_id),       /* Riferimento all'uuid del responsabile */
    created_at timestamptz DEFAULT now()                /* timestamp di definizione del record */
);

CREATE INDEX idx_asset_org ON asset(organization_id);   /* Indice sull'indentificativo organization per il recupero rapido del dato */
CREATE INDEX idx_asset_type ON asset(asset_type);       /* Indice sulla tipologia */
CREATE UNIQUE INDEX ux_asset_org_identifier ON asset(organization_id, identifier) WHERE identifier IS NOT NULL; /* Indice univoco sulla coppia valori (orgId e identificatore specifico) */

/* 6) Creazione della tabella relativa ai servizi  */
CREATE TABLE service (
    service_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES organization(organization_id) ON DELETE CASCADE, /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "organization" */
    name varchar(60) NOT NULL,                                 /* nome */
    description TEXT,                                   /* descrizione del servizio */
    service_owner UUID REFERENCES person(person_id),    /* referente del servizio */
    criticality SMALLINT DEFAULT 3,                     /* livello di criticità: 1 (basso) .. 5 (critico), come predefinito si usa un valore intermedio, 3 */
    business_impact TEXT,                               /* Impatto sul business*/
    metadata jsonb DEFAULT '{}'::jsonb,                 /* Eventuali metadati aggiuntivi specifici del servizio, per esempio, business hours  */
    created_at timestamptz DEFAULT now()                /* timestamp di definizione del record */
);

CREATE INDEX idx_service_org ON service(organization_id);    /* Indice sull'indentificativo organization per il recupero rapido del dato */
CREATE UNIQUE INDEX ux_service_org_name ON service(organization_id, name);  /* Indice univoco sull'orgId */

/* 7) Creazione della tabella di associazione uno-a-molti tra servizio <-> asset (un servizio usa più asset) */
CREATE TABLE service_asset (
    service_id UUID REFERENCES service(service_id) ON DELETE CASCADE,    /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "service" */
    asset_id   UUID REFERENCES asset(asset_id) ON DELETE CASCADE,        /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "asset" */
    role_in_service varchar(60),                                                /* Ruolo ricoperto all'interno del servizio da questo asset per esempio:  'database','webserver','backup' */
    PRIMARY KEY(service_id, asset_id)                                    /* Definisco una chiave primaria complosta dalla coppia (idServizio, idAsset) */
);
CREATE INDEX idx_service_asset_asset ON service_asset(asset_id);        /* Definisco un indice sul campo asset_id */

/* 8) Creazione della tabella di dipendenza tra servizio e fornitore  */
CREATE TABLE dependency (
    dependency_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),          
    service_id UUID REFERENCES service(service_id) ON DELETE CASCADE,    /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "service" */ 
    vendor_id UUID REFERENCES vendor(vendor_id) ON DELETE SET NULL,      /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "vendor" */
    description TEXT,                                                    /* Descrizione, per esempio "il fornitore X offre servizi di tipo IAAS" per le PA */
    dependency_type varchar(60),                                                /* Tipologia di dipendenza, per esempio: 'SaaS','IaaS','PaaS','Managed Service','Supply Chain' */
    sla_reference varchar(60),                                                  /* SLA di riferimento */
    criticality SMALLINT DEFAULT 3,                                      /* livello di criticità: 1 (basso) .. 5 (critico), come predefinito si usa un valore intermedio, 3 */
    metadata jsonb DEFAULT '{}'::jsonb,                                  /* Eventuali metadati aggiuntivi specifici della dipendenza, come commenti  */
    created_at timestamptz DEFAULT now()                                 /* timestamp di definizione del record */
);
CREATE INDEX idx_dependency_service ON dependency(service_id);              /* Definisco un indice sul campo service_id */
CREATE INDEX idx_dependency_vendor ON dependency(vendor_id);                /* Definisco un indice sul campo vendor_id */

/* 9) Creazione della tabella che definisce la matrice di responsabilità  (persona/ruolo su risorsa) */
CREATE TABLE responsability (
    responsability_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES organization(organization_id) ON DELETE CASCADE, /* predispongo una reference per la cancellazione a cascata dei dati qualora venisse cancellato il record padre nella tabella "organization" */ 
    person_id UUID REFERENCES person(person_id) ON DELETE SET NULL,     /* predispongo una reference per l'impostazione a NULL del campo person_id qualora venisse cancellato il record padre nella tabella "person" */
    role_id UUID REFERENCES role(role_id) ON DELETE SET NULL,           /* predispongo una reference per l'impostazione a NULL del campo role_id qualora venisse cancellato il record padre nella tabella "role" */
    target_type varchar(12) NOT NULL,                                          /* Tipologia dell'oggetto, come 'asset','service','dependency' */
    target_id UUID NOT NULL,                                            /* E' una foreign key manuale che viene validata tramite constraints/triggers e fa riferimento all'uuid dell'oggetto */
    valid_from timestamptz DEFAULT now(),                               /* timestamp che indica la data di inizio validità del record */
    valid_to timestamptz,                                               /* timestamp che indica la data di fine validità del record */
    metadata jsonb DEFAULT '{}'::jsonb,                                 /* Eventuali metadati aggiuntivi specifici, come commenti  */
    created_at timestamptz DEFAULT now()                                /* timestamp di definizione del record */
);

CREATE INDEX idx_responsability_target ON responsability(target_type, target_id);    /* Definisco un indice composto dalla coppia (tipologia, identificativo) */
CREATE INDEX idx_responsability_person ON responsability(person_id);                 /* Definisco un indice sul campo person_id */

/* 10) VERSIONING / STORICO GENERICO */
/* (approccio semplice: tabelle *_history che contengono snapshot prima di UPDATE/DELETE). E' un salvataggio puramente applicativo, il salvataggio dei dati in caso di upgrade di sistema, */
/* aggiornamento dell'applicazione o altro, deve sempre avvenire con gli strumenti messi a disposizione dal db server come pg_dump o di terze parti come Percona Backup */

/* Creazione della tabella che contiene le variazioni effettuate sugli asset */
CREATE TABLE asset_history (
    history_id BIGSERIAL PRIMARY KEY,
    asset_id UUID,                                                      /* UUID dell'asset d'origine */
    organization_id UUID,                                               /* UUID dell'organizzazione di origine */
    asset_type varchar(60),                                                    /* tipologia dell'asset - vedi tabella "assets" */
    name varchar(40),                                                          /* nome dell'asset - vedi tabella "assets" */
    identifier varchar(40),                                                    /* identificatore dell'asset - vedi tabella "assets" */
    criticality SMALLINT,                                               /* criticità dell'asset - vedi tabella "assets" */
    lifecycle_status varchar(20),                                              /* stato dell'asset relativamente al suo ciclo di vita - vedi tabella "assets" */
    metadata jsonb,                                                     /* Eventuali metadati aggiuntivi specifici, come commenti  */
    changed_by UUID,                                                    /* identificatore di chi ha effettuato la variazione - vedi tabella "person" */
    operation CHAR(1) NOT NULL,                                         /* Attività svolta su i dati 'I'nsert,'U'pdate,'D'elete */
    changed_at timestamptz DEFAULT now()                                /* timestamp di definizione del record, in questo caso di cambio del dato */
);

/* Creazione della tabella che contiene le variazioni effettuate su i servizi  */
CREATE TABLE service_history (
    history_id BIGSERIAL PRIMARY KEY,
    service_id UUID,                                                    /* UUID del servizio di origine */
    organization_id UUID,                                               /* UUID dell'organizzazione di origine */
    name varchar(60),                                                          /* nome del servizio - vedi tabella "service" */
    description TEXT,                                                   /* descrizione del servizio - vedi tabella "service" */
    service_owner UUID,                                                 /* responsabile del servizio - vedi tabella "service" */
    criticality SMALLINT,                                               /* criticità del servizio - vedi tabella "service" */
    business_impact TEXT,                                               /* impatto sul business del servizio - vedi tabella "service" */
    metadata jsonb,                                                     /* Eventuali metadati aggiuntivi specifici, come commenti  */
    changed_by UUID,                                                    /* identificatore di chi ha effettuato la variazione - vedi tabella "person" */
    operation CHAR(1) NOT NULL,                                         /* Attività svolta su i dati 'I'nsert,'U'pdate,'D'elete */
    changed_at timestamptz DEFAULT now()                                /* timestamp di definizione del record, in questo caso di cambio del dato */
);

/* Creazione della tabella che contiene le variazioni effettuate sulle dipendenze */
CREATE TABLE dependency_history (
    history_id BIGSERIAL PRIMARY KEY,
    dependency_id UUID,                                                 /* UUID della dipendenza di origine */
    service_id UUID,                                                    /* UUID del servizio di origine */
    vendor_id UUID,                                                     /* UUID del fornitore di origine */
    description TEXT,                                                   /* descrizione della dipendenza - vedi tabella "dependency" */
    dependency_type varchar(60),                                               /* tipologia della dipendenza - vedi tabella "dependency" */
    sla_reference varchar(60),                                                 /* sla di riferimento della dipendenza - vedi tabella "dependency" */
    criticality SMALLINT,                                               /* criticità della dipendenza - vedi tabella "dependency" */
    metadata jsonb,                                                     /* Eventuali metadati aggiuntivi specifici, come commenti  */
    changed_by UUID,                                                    /* identificatore di chi ha effettuato la variazione - vedi tabella "person" */
    operation CHAR(1) NOT NULL,                                         /* Attività svolta su i dati 'I'nsert,'U'pdate,'D'elete */
    changed_at timestamptz DEFAULT now()                                /* timestamp di definizione del record, in questo caso di cambio del dato */
);

/* Creazione della tabella che contiene le variazioni effettuate sulle responsabilità */
CREATE TABLE responsability_history (
    history_id BIGSERIAL PRIMARY KEY,
    responsability_id UUID,                                             /* UUID della responsabilità di origine */
    organization_id UUID,                                               /* UUID dell'organizzazione di origine */
    person_id UUID,                                                     /* UUID della persona di origine */
    role_id UUID,                                                       /* UUID del ruolo di origine */
    target_type varchar(12),                                                   /* tipologia di target - vedi tabella "target" */
    target_id UUID,                                                     /* id del target - vedi tabella "target" */
    valid_from timestamptz,                                             /* data di inizio validità - vedi tabella "target" */
    valid_to timestamptz,                                               /* data di fine validità - vedi tabella "target" */
    metadata jsonb,                                                     /* Eventuali metadati aggiuntivi specifici, come commenti  */
    changed_by UUID,                                                    /* identificatore di chi ha effettuato la variazione - vedi tabella "person" */
    operation CHAR(1) NOT NULL,                                         /* Attività svolta su i dati 'I'nsert,'U'pdate,'D'elete */
    changed_at timestamptz DEFAULT now()                                /* timestamp di definizione del record, in questo caso di cambio del dato */
);

/* 11) Definizione dei triggers che consentono la registrazione degli eventi di UPDATE/DELETE per le tabelle chiave */

/* Definizione della funzione che gestisce l'evento di UPDATE/DELETE/INSERT sulla tabella asset, salvando i dati variati sulla tabella asset_history' */
CREATE OR REPLACE FUNCTION fn_asset_audit() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO asset_history(asset_id, organization_id, asset_type, name, identifier, criticality, lifecycle_status, metadata, changed_by, operation, changed_at)
        VALUES (OLD.asset_id, OLD.organization_id, OLD.asset_type, OLD.name, OLD.identifier, OLD.criticality, OLD.lifecycle_status, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'U', now());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO asset_history(asset_id, organization_id, asset_type, name, identifier, criticality, lifecycle_status, metadata, changed_by, operation, changed_at)
        VALUES (OLD.asset_id, OLD.organization_id, OLD.asset_type, OLD.name, OLD.identifier, OLD.criticality, OLD.lifecycle_status, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'D', now());
        RETURN OLD;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO asset_history(asset_id, organization_id, asset_type, name, identifier, criticality, lifecycle_status, metadata, changed_by, operation, changed_at)
        VALUES (NEW.asset_id, NEW.organization_id, NEW.asset_type, NEW.name, NEW.identifier, NEW.criticality, NEW.lifecycle_status, NEW.metadata, current_setting('nis2.current_user_id', true)::uuid, 'I', now());
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_asset_audit
AFTER INSERT OR UPDATE OR DELETE ON asset
FOR EACH ROW EXECUTE PROCEDURE fn_asset_audit();

/* Definizione della funzione che gestisce l'evento di UPDATE/DELETE/INSERT sulla tabella service, salvando i dati variati sulla tabella service_history' */
CREATE OR REPLACE FUNCTION fn_service_audit() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO service_history(service_id, organization_id, name, description, service_owner, criticality, business_impact, metadata, changed_by, operation, changed_at)
        VALUES (OLD.service_id, OLD.organization_id, OLD.name, OLD.description, OLD.service_owner, OLD.criticality, OLD.business_impact, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'U', now());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO service_history(service_id, organization_id, name, description, service_owner, criticality, business_impact, metadata, changed_by, operation, changed_at)
        VALUES (OLD.service_id, OLD.organization_id, OLD.name, OLD.description, OLD.service_owner, OLD.criticality, OLD.business_impact, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'D', now());
        RETURN OLD;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO service_history(service_id, organization_id, name, description, service_owner, criticality, business_impact, metadata, changed_by, operation, changed_at)
        VALUES (NEW.service_id, NEW.organization_id, NEW.name, NEW.description, NEW.service_owner, NEW.criticality, NEW.business_impact, NEW.metadata, current_setting('nis2.current_user_id', true)::uuid, 'I', now());
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_service_audit
AFTER INSERT OR UPDATE OR DELETE ON service
FOR EACH ROW EXECUTE PROCEDURE fn_service_audit();

/* Definizione della funzione che gestisce l'evento di UPDATE/DELETE/INSERT sulla tabella dependency, salvando i dati variati sulla tabella dependency_history' */
CREATE OR REPLACE FUNCTION fn_dependency_audit() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO dependency_history(dependency_id, service_id, vendor_id, description, dependency_type, sla_reference, criticality, metadata, changed_by, operation, changed_at)
        VALUES (OLD.dependency_id, OLD.service_id, OLD.vendor_id, OLD.description, OLD.dependency_type, OLD.sla_reference, OLD.criticality, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'U', now());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO dependency_history(dependency_id, service_id, vendor_id, description, dependency_type, sla_reference, criticality, metadata, changed_by, operation, changed_at)
        VALUES (OLD.dependency_id, OLD.service_id, OLD.vendor_id, OLD.description, OLD.dependency_type, OLD.sla_reference, OLD.criticality, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'D', now());
        RETURN OLD;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO dependency_history(dependency_id, service_id, vendor_id, description, dependency_type, sla_reference, criticality, metadata, changed_by, operation, changed_at)
        VALUES (NEW.dependency_id, NEW.service_id, NEW.vendor_id, NEW.description, NEW.dependency_type, NEW.sla_reference, NEW.criticality, NEW.metadata, current_setting('nis2.current_user_id', true)::uuid, 'I', now());
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dependency_audit
AFTER INSERT OR UPDATE OR DELETE ON dependency
FOR EACH ROW EXECUTE PROCEDURE fn_dependency_audit();

/* Definizione della funzione che gestisce l'evento di UPDATE/DELETE/INSERT sulla tabella responsability, salvando i dati variati sulla tabella responsability_history' */
CREATE OR REPLACE FUNCTION fn_responsability_audit() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO responsability_history(responsability_id, organization_id, person_id, role_id, target_type, target_id, valid_from, valid_to, metadata, changed_by, operation, changed_at)
        VALUES (OLD.responsability_id, OLD.organization_id, OLD.person_id, OLD.role_id, OLD.target_type, OLD.target_id, OLD.valid_from, OLD.valid_to, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'U', now());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO responsability_history(responsability_id, organization_id, person_id, role_id, target_type, target_id, valid_from, valid_to, metadata, changed_by, operation, changed_at)
        VALUES (OLD.responsability_id, OLD.organization_id, OLD.person_id, OLD.role_id, OLD.target_type, OLD.target_id, OLD.valid_from, OLD.valid_to, OLD.metadata, current_setting('nis2.current_user_id', true)::uuid, 'D', now());
        RETURN OLD;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO responsability_history(responsability_id, organization_id, person_id, role_id, target_type, target_id, valid_from, valid_to, metadata, changed_by, operation, changed_at)
        VALUES (NEW.responsability_id, NEW.organization_id, NEW.person_id, NEW.role_id, NEW.target_type, NEW.target_id, NEW.valid_from, NEW.valid_to, NEW.metadata, current_setting('nis2.current_user_id', true)::uuid, 'I', now());
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_responsability_audit
AFTER INSERT OR UPDATE OR DELETE ON responsability
FOR EACH ROW EXECUTE PROCEDURE fn_responsability_audit();

/* Nota: current_setting('nis2.current_user_id') è opzionale. Prima di eseguire operazioni che vogliamo tracciare, possiamo settare: */
/* SET LOCAL nis2.current_user_id = '00000000-0000-0000-0000-000000000000'; */

/* 12) Definizione dei costraint (vincoli) aggiuntivi e degli eventuali controlli */
ALTER TABLE asset ADD CONSTRAINT chk_asset_criticality CHECK (criticality >= 1 AND criticality <= 5);
ALTER TABLE service ADD CONSTRAINT chk_service_criticality CHECK (criticality >= 1 AND criticality <= 5);
ALTER TABLE dependency ADD CONSTRAINT chk_dependency_criticality CHECK (criticality >= 1 AND criticality <= 5);

/* 13) Definizione della vista che serve a generare la porzione di profilo ACN (CSV) richiesto dal progetto */
/* è una vista che unisce: organizzazione -> servizi critici -> asset usati -> dipendenze -> punti di contatto/responsabili */
CREATE OR REPLACE VIEW vw_acn_profile AS
SELECT
  o.organization_id,
  o.name AS organization_name,
  s.service_id,
  s.name AS service_name,
  s.criticality AS service_criticality,
  s.description AS service_description,
  /* assets aggregated as json array */
  (SELECT jsonb_agg(jsonb_build_object(
          'asset_id', a.asset_id,
          'asset_name', a.name,
          'asset_type', a.asset_type,
          'identifier', a.identifier,
          'criticality', a.criticality
      ))
    FROM service_asset sa
    JOIN asset a ON a.asset_id = sa.asset_id
    WHERE sa.service_id = s.service_id
  ) AS assets,
  /* dependencies aggregated */
  (SELECT jsonb_agg(jsonb_build_object(
          'dependency_id', d.dependency_id,
          'vendor_name', v.name,
          'type', d.dependency_type,
          'sla', d.sla_reference,
          'criticality', d.criticality
      ))
    FROM dependency d
    LEFT JOIN vendor v ON v.vendor_id = d.vendor_id
    WHERE d.service_id = s.service_id
  ) AS dependencies,
  /* responsible persons for the service */
  (SELECT jsonb_agg(jsonb_build_object(
        'person_id', p.person_id,
        'name', concat(p.given_name, ' ', COALESCE(p.family_name,'')),
        'email', p.email,
        'phone', p.phone,
        'role', r.code
    ))
   FROM responsability resp
   LEFT JOIN person p ON p.person_id = resp.person_id
   LEFT JOIN role r ON r.role_id = resp.role_id
   WHERE resp.target_type = 'service' AND resp.target_id = s.service_id
  ) AS contacts,
  s.metadata
FROM organization o
JOIN service s ON s.organization_id = o.organization_id;

/* Definizione della vista che produce un un record piatto esportabile in CSV */
CREATE OR REPLACE VIEW vw_acn_profile_csv AS
SELECT
  o.organization_id::text AS organization_id,
  o.name AS organization_name,
  s.service_id::text AS service_id,
  s.name AS service_name,
  s.criticality::text AS service_criticality,
  COALESCE(
    (SELECT string_agg(a.name || ' (' || a.asset_type || ')', '; ')
     FROM service_asset sa JOIN asset a ON a.asset_id = sa.asset_id
     WHERE sa.service_id = s.service_id
    ), '') AS assets_list,
  COALESCE(
    (SELECT string_agg(v.name || ' [' || COALESCE(d.dependency_type,'') || ']', '; ')
     FROM dependency d LEFT JOIN vendor v ON v.vendor_id = d.vendor_id
     WHERE d.service_id = s.service_id
    ), '') AS dependencies_list,
  COALESCE(
    (SELECT string_agg(concat(p.given_name,' ',COALESCE(p.family_name,''),' <',COALESCE(p.email,''),'>'), '; ')
     FROM responsability resp LEFT JOIN person p ON p.person_id = resp.person_id
     WHERE resp.target_type='service' AND resp.target_id = s.service_id
    ), '') AS contacts_list
FROM organization o
JOIN service s ON s.organization_id = o.organization_id;
