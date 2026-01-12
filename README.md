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

## 🚀 Metodologia di Deployment

La procedura di installazione è stata automatizzata per ridurre al minimo le configurazioni manuali. L'inizializzazione dell'ambiente segue il workflow descritto di seguito.

### 1. Acquisizione dei Sorgenti
Si proceda alla clonazione del repository contenente gli artefatti di progetto:
```bash
git clone [https://github.com/tuo-user/nis2-project-work.git](https://github.com/tuo-user/nis2-project-work.git)
cd nis2-project-work
