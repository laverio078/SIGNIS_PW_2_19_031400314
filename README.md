

# Prototipazione di Sistema Informativo per la Compliance NIS2 e ACN

![PostgreSQL](https://img.shields.io/badge/DBMS-PostgreSQL_16-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Orchestrator-Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Status](https://img.shields.io/badge/Status-Project_Work-orange?style=for-the-badge)

Il presente elaborato illustra l'implementazione tecnica di un'architettura database relazionale progettata per supportare gli adempimenti normativi previsti dalla Direttiva UE 2022/2555 (**NIS2**) e dal **Framework Nazionale per la Cybersecurity (ACN)**.

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

La procedura di installazione è stata automatizzata per ridurre al minimo le configurazioni manuali. L'inizializzazione dell'ambiente segue il workflow descritto di seguito.

### 1. Download  dei sorgenti
Procedere alla clonazione, sul sistema di destinazione, del repository contenente gli artefatti di progetto con i seguenti comandi:

> bash

``` 
git clone https://github.com/laverio078/SIGNIS_PW_2_19_031400314.git
cd nis2-project-work
```
---

### **2. Configurazione dell'ambiente target**
Il file docker-compose.yml compose, presente nella directory nis2-project-work, contiene le variabili necessarie all'inizializzazione del database Postgres, dell'interfaccia di amministrazione pgAdmin e dell'interfaccia di gestione dello stack, Portainer.

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

Interfaccia Portainer

### **3. Esecuzione dello stack**

Posizionarsi nella directory nis2-project-work ed eseguire il comando:

```
docker compose up -d 
```

Questo comando avvierà il demone docker seguendo la configurazione descritta nel file docker-compose.yml.

**Nota tecnica**: Durante la fase di avvio, il container PostgreSQL eseguirà automagicamente gli script SQL mappati nella directory `/docker-entrypoint-initdb.d/`, garantendo la creazione dello schema senza doverlo fare a posteriori.

## 🖥 **Interfacce di Amministrazione** 

L'accesso a quanto attivato dal sistema docker è garantito tramite le seguenti interfacce esposte:

### Console database (pgAdmin 4)

 -    **Endpoint:** [http://localhost:5050]
    
 -   **Credenziali di Accesso:** `admin@admin.com` / `root` #se non variate
    
 -   **Stato:** E' necessario configurare l'accesso al database locale dall'interfaccia web con i seguenti parametri nel tab connection della maschera Register - Server:

>  - **Host name/address**: `10.50.0.3` 
>  - **Username**: `admin`  (default)
>  - **Password**: `admintest` (default)

Inserendo le credenziali fornite in fase di setup.

### Monitoraggio Infrastruttura (Portainer)

-   **Endpoint:** [http://localhost:9000]
    
-   **Setup:** Al primo accesso è richiesta la definizione di un utente amministratore per la gestione dell'ambiente locale.

## 💾 Gestione Dati e Reporting

Il sistema include procedure predefinite per la gestione del ciclo di vita del dato e la generazione della reportistica di compliance NIS2.

### Inizializzazione e Reset dei Dati

Qualora si rendesse necessario un ripristino dello stato iniziale o un aggiornamento dello schema, si consiglia di utilizzare l'interfaccia a riga di comando `psql`. L'ordine di esecuzione degli script è vincolante:

1.  **Definizione Schema (DDL):** presente all'interno della root di progetto, quale file `Creazione Schema-Tabelle-Costraints NIS2_v2.sql`
    
2.  **Data Ingestion (DML):** presenti all'interno della directory `queries/Popolazione DB` quali files `mock_data_anmss.sql` (Scenario simulato: Agenzia Nazionale Mobilità), `mock_data_autofisco.sql` (Scenario simulato: Auto Fisco Italia S.p.A.) 
    

### Estrazione Profilo ACN (CSV)

Al fine di ottemperare agli obblighi di trasmissione dati previsti dall'Agenzia per la Cybersicurezza Nazionale, è stata predisposta una vista dedicata (`vw_acn_profile_csv`). L'estrazione del report in formato interoperabile (CSV) può essere effettuata mediante il seguente comando:

Bash

```
PGPASSWORD=adminpassword psql -h localhost -p 5432 -U admin -d nis2 -c "\copy (SELECT * FROM nis2.vw_acn_profile_csv) TO 'report_acn_nis2.csv' WITH CSV HEADER DELIMITER ';'"

```
o eseguendo i file sql predisposti all'interno della directory `queries/Export CSV` con il comando:

    docker exec -i nis2_postgres psql -U admin -d postgres < *query-file.sql*

Il file generato, `report_acn_nis2.csv`, conterrà la mappatura completa di asset, servizi e fornitori.

### Interrogazione dei dati.

E' possibile interrogare lo schema NIS2 del database PostgreSQL tramite interfaccia web (pgAdmin), strumento `Query Tool` o tramite client `psql` disponibile all'interno del container docker dell'RDBMS tramite il comando:

    docker exec -it nis2_postgres psql -U admin -d postgres
    
Per facilitare l'interrogazione dei dati sono state predisposte delle query precompilate presenti all'interno della directory `queries/Ricerca` e comprendono:

 - Estrazione degli asset critici o ad alta criticità
 - Estrazione dell'elenco dei fornitori che supportano i servizi critici e il tipo di contratto in essere
 - Estrazione delle dipendenze della supply chain e dei fornitori per ogni servizio
 - Estrazione dei referenti interni (punti di contatto) per i vari servizi
 - Estrazione dello storico delle modifiche per un asset critico

Per poterle eseguire, è possibile eseguire il client psql interno al container con il comando:

    docker exec -i nis2_postgres psql -U admin -d postgres < *query-file.sql*

O tramite interfaccia **pgAdmin** copiando e incollando il contenuto del file scelto all'interno del `Query Tool` ed eseguendo la query.

----------

## 📂 Struttura dell'Elaborato

L'organizzazione dei file all'interno del progetto rispetta la seguente tassonomia:

```
.
├── Creazione Schema-Tabelle-Costraints NIS2_v2.sql
├── Diagramma ER DB profili NIS2.jpeg
├── Diagramma ER DB profili NIS2.pdf
├── docker-compose.yml
├── NIS2 Documentation
│   ├── 1766054735810.jpeg
│   ├── 290-192A5_01 - Network e information systems.pdf
│   ├── 290-192A5_02 - Network e information systems.pdf
│   ├── 290-192A5_03 - Network e information systems.pdf
│   ├── 297 - Privacy - DORA.zip
│   ├── ACN_Tassonomia_Cyber_CLEAR.pdf
│   ├── CELEX_32022L2555_IT_TXT.pdf
│   ├── DetACN_nis_specifiche_2025_164179_allegato2.pdf
│   ├── DetACN_nis_specifiche_2025_164179_signed.pdf
│   └── Guida alla lettura Specifiche di base.pdf
├── queries
│   ├── Export CSV
│   │   ├── Query export in CSV_afi.sql
│   │   └── Query export in CSV_anmss.sql
│   ├── Popolazione DB
│   │   ├── mock_data_anmss.sql
│   │   └── mock_data_autofisco.sql
│   └── Ricerca
│       ├── 1_estrazione_asset_critici.sql
│       ├── 2_elenco_servizi_critici.sql
│       ├── 3_elenco_dipendenze_supply_chain.sql
│       ├── 4_matrice_RACI.sql
│       └── 5_estrazione_storico_asset.sql
└── README.md


```
