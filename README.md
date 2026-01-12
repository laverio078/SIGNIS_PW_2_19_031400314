
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
git clone [https://github.com/tuo-user/nis2-project-work.git](https://github.com/tuo-user/nis2-project-work.git) 
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
