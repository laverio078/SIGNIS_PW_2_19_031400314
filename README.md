

# Prototipazione del Sistema di gestione integrata per i profili NIS2 (SIGNIS)

![PostgreSQL](https://img.shields.io/badge/DBMS-PostgreSQL_16-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Orchestrator-Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Status](https://img.shields.io/badge/Status-Project_Work-orange?style=for-the-badge)

Il presente elaborato illustra l'implementazione tecnica di un'architettura database relazionale progettata per supportare gli adempimenti normativi previsti dalla Direttiva UE 2022/2555 (**NIS2**) e dal **Framework Nazionale per la Cybersecurity (CIS/CINI)**.

Il progetto verte sulla realizzazione di un registro centralizzato per la gestione degli asset, dei servizi essenziali e delle dipendenze dalla catena di approvvigionamento (*Supply Chain*), integrando meccanismi di audit trail e funzionalità di reporting automatizzato.

## 📑 Sommario
- [Quadro Architetturale](#-quadro-architetturale)
- [Requisiti di Sistema](#-requisiti-di-sistema)
- [Metodologia di Deployment](#-metodologia-di-deployment)
- [Interfacce di Amministrazione](#-interfacce-di-amministrazione)
- [Gestione Dati e Reporting](#-gestione-dati-e-reporting)
- [Struttura dell'Elaborato](#-struttura-dellelaborato)

---

## 🏛 Quadro Architetturale

L'infrastruttura tecnologica è stata ingegnerizzata mediante un approccio a microservizi containerizzati, orchestrati tramite **Docker Compose**. L'architettura logica si compone dei seguenti moduli:

| Modulo Funzionale | Componente Tecnologico | Descrizione Tecnica |
| :--- | :--- | :--- |
| **Persistence Layer** | **PostgreSQL 16 (Alpine)** | RDBMS oggetto dello studio, configurato con estensione `uuid-ossp` per la gestione delle chiavi primarie distribuite. Esposto sulla porta `5432`. |
| **Management Interface** | **pgAdmin 4** | Console di amministrazione web-based per l'interrogazione e la manutenzione dello schema dati. Esposta sulla porta `5050`. |
| **Container Orchestration** | **Portainer CE** | Dashboard per il monitoraggio delle risorse e del ciclo di vita dei container. Esposta sulle porte `9000` (HTTP) e `9443` (HTTPS). |

---

## ⚙ Requisiti di Sistema

Per garantire la corretta esecuzione dell'ambiente simulato, il sistema ospite deve soddisfare i seguenti prerequisiti software:

* **Runtime Environment:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) o Docker Engine (v20.10+).
* **Orchestrator:** Plugin Docker Compose (v2.0+).
* **Client SQL (Opzionale):** Utilità `psql` o client grafico (es. DBeaver) per operazioni di debug avanzato.

---

## 🚀 Istruzioni per il rilascio

La procedura di installazione è stata automatizzata per ridurre al minimo le configurazioni manuali, tuttavia, qualora non si volesse impiegare il docker compose fornito, è possibile utilizzare una qualsiasi installazione di PostgreSQL (è stata impiegata la versione 16) e seguire le istruzioni per la costruzione dello schema di riferimento e del bulk loading sia delle tabelle di funzionamento (framework ACN) che dei mock data.

L'inizializzazione dell'ambiente segue il workflow descritto di seguito.

### 1. Download  dei sorgenti
Procedere alla clonazione, sul sistema di destinazione, del repository contenente gli artefatti di progetto con i seguenti comandi:

> bash

``` 
git clone https://github.com/laverio078/SIGNIS_PW_2_19_031400314.git
cd SIGNIS_PW_2_19_031400314
```
---

### **2. Configurazione dell'ambiente target**
Il file docker-compose.yml compose, presente nella directory SIGNIS_PW_2_19_031400314, contiene le variabili necessarie all'inizializzazione del database Postgres, dell'interfaccia di amministrazione pgAdmin e dell'interfaccia di gestione dello stack, Portainer. 

**ATTENZIONE**: è stata impostata una network specifica per il db server in modo da superare il limite del docker server nella gestione automatica delle network che su molte installazioni impedisce lo start. Se la network specificata non è compatibile o da errori, variarla a proprio piacimento.

**Servizio PostgreSQL**

Le credenziali di default sono le seguenti:

 - `POSTGRES_USER`: admin
 - `POSTGRES_PASSWORD`: adminpassword 

Il servizio Postgres viene bloccato per default sull'IP interno allo stack `10.50.0.3` in modo da non consentire errori all'utente in fase di configurazione.

**Interfaccia pgAdmin**

Le credenziali di default per l'accesso sono le seguenti:

 - `PGADMIN_DEFAULT_EMAIL`: admin@admin.com 
 - `PGADMIN_DEFAULT_PASSWORD`: root

effettua un remap della porta 80 interna al container sulla 5050, pertanto se necessario modificare la riga seguente adattandola alle proprie necessità operative:

    ports:
      - "5050:80"

E' raccomandato variare le credenziali di accesso in ambienti di produzione, utilizzando password che rispecchino le best practices o le policy dell'ambiente di destinazione.

**Interfaccia Portainer**

effettua un remap della porta 9443 interna al container sulla 9443, pertanto se necessario modificare la riga seguente adattandola alle proprie necessità operative:

    ports:
      - "9443:9443"

Al primo accesso sarà necessario impostare la password per l'utente admin (**attenzione** sono richiesti almeno 12 caratteri).

### **3. Esecuzione dello stack**

Posizionarsi nella directory SIGNIS_PW_2_19_031400314 ed eseguire il comando:

> bash

```
sudo docker compose up -d 
```

Questo comando avvierà il demone docker seguendo la configurazione descritta nel file docker-compose.yml.

**Nota tecnica**: Durante la fase di avvio, il container PostgreSQL eseguirà automagicamente gli script SQL mappati nella directory `/docker-entrypoint-initdb.d/`, garantendo la creazione dello schema senza doverlo fare a posteriori. Qualora sia necessario far ripartire lo stack, senza cancellare i dati esistenti, si dovrà rimuovere dal `docker-file.yml` la riga numero 18, `- "./Creazione Schema-Tabelle-Costraints NIS2_v2.sql:/docker-entrypoint-initdb.d/init.sql"` e la riga numero 19, `- "./Popolazione DB/0_popolazione_framework_acn.sql:/docker-entrypoint-initdb.d/02_framework.sql"` altrimenti il sistema cercherà di ricreare uno schema già esistente e ripopolare una tabella già riempita generando errori di conflitto per chiavi duplicate.

Per disattivare lo stack rimuovendo tutti i dati esistenti sarà sufficiente eseguire il comando:

> bash

```
sudo docker compose down -v
```

altrimenti sarà sufficiente il comando:

> bash

```
sudo docker compose down
```

## 🖥 **Interfacce di Amministrazione** 

L'accesso a quanto attivato dal sistema docker è garantito tramite le seguenti interfacce esposte:

### Console database (pgAdmin 4)

 -   **Endpoint:** [http://localhost:5050]
    
 -   **Credenziali di Accesso:** `admin@admin.com` / `root` #se non variate
    
 -   **Stato:** E' necessario configurare l'accesso al database locale dall'interfaccia web con i seguenti parametri nel tab connection della maschera Register - Server:

>  - **Host name/address**: `db` 
>  - **Username**: `admin`  (default)
>  - **Password**: `admintest` (default)

Inserendo le credenziali fornite in fase di setup.

### Monitoraggio Infrastruttura (Portainer)

-   **Endpoint:** [http://localhost:9443]
    
-   **Setup:** Al primo accesso è richiesta la definizione di un utente amministratore per la gestione dell'ambiente locale.

## 💾 Gestione Dati e Reporting

Il sistema include procedure predefinite per la gestione del ciclo di vita del dato e la generazione della reportistica di compliance NIS2.

### Inizializzazione e Reset dei Dati

Qualora si rendesse necessario un ripristino dello stato iniziale o un aggiornamento dello schema, si consiglia di utilizzare i comandi docker per resettare l'ambiente già citati prima. 

Qualora si volesse impiegare un db server già presente, è possibile usare l'interfaccia a riga di comando `psql` seguendo l'ordine di esecuzione degli script (è vincolante) e cambiando i riferimenti di accesso (hostname, port, user, password, database ):

1.  **Definizione Schema (DDL):** presente all'interno della root di progetto, quale file `Creazione_Schema-Tabelle-Costraints_NIS2_v2.sql`
    
2.  **Data Ingestion (DML):** presenti all'interno della directory `queries/Popolazione DB` quali files `0_popolazione_framework_acn.sql` da eseguire prima di di caricare i mock data.

> bash

```
PGPASSWORD='<password>' psql -h <hostname> -p <port> -U <user> -d <database> -f Creazione_Schema-Tabelle-Costraints_NIS2_v2.sql
cd "queries/Popolazione DB"
PGPASSWORD='<password>' psql -h <hostname> -p <port> -U <user> -d <database> -f  0_popolazione_framework_acn.sql

```

### Caricamento Mock data

Il caricamento dei mock data è stato previsto come automatico all'interno dello stack docker da parte del docker compose, quindi se si impiega questo metodo, non sarà necessario interagire con il db per il caricamento, al contrario, se si preferisce usare un db server esterno è possibile caricare i dati come indicato di seguito.

**Data Ingestion (DML):** sono presenti all'interno della directory `queries/Popolazione DB` quali files  `mock_data_anmss.sql` (Scenario simulato: Agenzia Nazionale Mobilità), `mock_data_autofisco.sql` (Scenario simulato: Auto Fisco Italia S.p.A.) 

I dati possono essere caricati in Postgres tramite il client psql (da installare sulla propria macchina) come segue:

> bash

```
PGPASSWORD='<password>' psql -h <hostname> -p <port> -U <user> -d <database> -f mock_data_autofisco.sql
PGPASSWORD='<password>' psql -h <hostname> -p <port> -U <user> -d <database> -f mock_data_anmss.sql

```    


### Estrazione Profilo ACN (CSV)

Al fine di ottemperare agli obblighi di trasmissione dati previsti dall'Agenzia per la Cybersicurezza Nazionale, è stata predisposta una vista dedicata (`vw_acn_profile_csv`). L'estrazione del report in formato interoperabile (CSV), utilizzando quanto fornito nello stack docker, può essere effettuata mediante il seguente comando:

> bash

```
cd "queries/Export CSV"
PGPASSWORD=adminpassword psql -h localhost -p 5432 -U admin -d postgres < "*query_export.sql*"

```
Il file generato, `report_acn_nis2.csv`, conterrà la mappatura completa di asset, servizi e fornitori per tutte le organizzazioni presenti.

Qualora sia stato utilizzato un server esterno per caricare i dati sarà necessario sostituire i riferimenti a utente, password, host, porta e database e adattarli a quanto presente nel proprio ambiente.

Altrimenti è possibile utilizzare il client psql presente nel container docker eseguendo i file sql predisposti all'interno della directory `queries/Export CSV` con il comando:

> bash

```
cd "queries/Export CSV"
sudo docker run --rm   --network signis_pw_2_19_031400314_custom_nis2_net   -v "$(pwd):/workdir"   -w /workdir   -e PGPASSWORD=adminpassword   postgres:16-alpine   psql -h nis2_postgres -U admin -d postgres -f "*query_export.sql*"
```

Il file generato, `acn_profile_anmss.csv`, conterrà la mappatura completa di asset, servizi e fornitori per l'organizzazione ANMSS , mentre il file `acn_profile_AFI.csv` conterrà quelli dell'AFI (Auto Fisco Italia).


### Interrogazione dei dati.

E' possibile interrogare lo schema NIS2 del database PostgreSQL presente nello stack docker tramite il client psql installato sulla propria macchina o con il client `psql` disponibile all'interno del container docker dell'RDBMS tramite i comandi:

**psql**

> bash

```
PGPASSWORD=adminpassword psql -h localhost -p 5432 -U admin -d postgres

```

**Docker**

> bash

```
sudo docker exec -it nis2_postgres psql -U admin -d postgres

```

o tramite l'interfaccia web (pgAdmin), strumento `Query Tool`.

Per facilitare l'interrogazione dei dati sono state predisposte delle query precompilate (numerate a 1 a 6) presenti all'interno della directory `queries/Ricerca` e comprendono:

 - Estrazione degli asset critici o ad alta criticità
 - Estrazione dell'elenco dei fornitori che supportano i servizi critici e il tipo di contratto in essere
 - Estrazione delle dipendenze della supply chain e dei fornitori per ogni servizio
 - Estrazione dei referenti interni (punti di contatto) per i vari servizi
 - Estrazione dello storico delle modifiche per un asset critico
 - Estrazione del report di compliance ai controlli del framework CIS/CINI

Per poterle eseguire, è possibile eseguire il client psql sulla propria macchina o quello interno al container con i comandi:

**psql**

> bash

```
PGPASSWORD=adminpassword psql -h localhost -p 5432 -U admin -d postgres < *query-file.sql*

```

**Docker**

> bash

```
sudo docker exec -i nis2_postgres psql -U admin -d postgres < *query-file.sql*
```

O tramite l'interfaccia **pgAdmin** copiando e incollando il contenuto del file scelto all'interno del `Query Tool` ed eseguendo la query scelta.

**NOTA:** Qualora sia stato utilizzato un server esterno per caricare i dati sarà necessario sostituire i riferimenti a utente, password, host, porta e database e adattarli a quanto presente nel proprio ambiente.

----------

## 📂 Struttura dell'Elaborato

L'organizzazione dei file all'interno del progetto rispetta la seguente tassonomia:

```
.
├── Creazione_Schema-Tabelle-Costraints_NIS2_v2.sql
├── Diagramma ER DB profili NIS2.jpeg
├── Diagramma ER DB profili NIS2.pdf
├── docker-compose.yml
├── documentazione
│   ├── 290-192A5_01 - Network e information systems.pdf
│   ├── 290-192A5_02 - Network e information systems.pdf
│   ├── 290-192A5_03 - Network e information systems.pdf
│   ├── ACN_Tassonomia_Cyber_CLEAR.pdf
│   ├── CELEX_32022L2555_IT_TXT.pdf
│   ├── DetACN_nis_specifiche_2025_164179_allegato2.pdf
│   ├── DetACN_nis_specifiche_2025_164179_signed.pdf
│   ├── FNCDP_-_Edizione_2025_v.2.1_-_Core.xls
│   ├── Framework_nazionale_cybersecurity_data_protection.pdf
│   ├── Guida alla lettura Specifiche di base.pdf
│   ├── Linee guida ACN rafforzamento resilienza.pdf
│   └── NIST.CSWP.29
├── queries
│   ├── Export CSV
│   │   ├── Query export in CSV_afi.sql
│   │   └── Query export in CSV_anmss.sql
│   ├── Popolazione DB
│   │   ├── 0_popolazione_framework_acn.sql
│   │   ├── mock_data_anmss.sql
│   │   └── mock_data_autofisco.sql
│   └── Ricerca
│       ├── 1_estrazione_asset_critici.sql
│       ├── 1_estrazione_asset_critici_afi.sql
│       ├── 2_elenco_servizi_critici.sql
│       ├── 2_elenco_servizi_critici_afi.sql
│       ├── 3_elenco_dipendenze_supply_chain.sql
│       ├── 3_elenco_dipendenze_supply_chain_afi.sql
│       ├── 4_matrice_RACI.sql
│       ├── 4_matrice_RACI_afi.sql
│       ├── 5_estrazione_storico_asset.sql
│       ├── 5_estrazione_storico_asset_afi.sql
│       ├── 6_report_compliance_nis2.sql
│       └── 6_report_compliance_nis2_afi.sql
└── README.md


```
