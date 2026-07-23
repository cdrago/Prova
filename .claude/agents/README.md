# Team di agenti — K-means in R

Team di 4 agenti specializzati che collaborano per sviluppare, revisionare e
applicare un algoritmo K-means scritto in R.

## Gli agenti

| Agente | Ruolo | Cosa fa |
|--------|-------|---------|
| `kmeans-sviluppatore` | Sviluppatore | Scrive da zero l'algoritmo K-means in `R/kmeans.R` |
| `kmeans-revisore` | Revisore | Critica il codice, trova bug/edge case e lo migliora |
| `kmeans-applicatore` | Applicatore | Applica il codice al dataset `USArrests` e interpreta i cluster |
| `kmeans-orchestratore` | Orchestratore | Coordina gli altri tre in sequenza e produce il report finale |

## Come si usa

Il modo più semplice è invocare l'**orchestratore**, che delega automaticamente
agli altri tre nell'ordine corretto (sviluppo → revisione → applicazione):

```
Usa l'agente kmeans-orchestratore per creare, revisionare e applicare
il K-means a USArrests.
```

In alternativa si può invocare ogni agente singolarmente, rispettando le
dipendenze: prima lo sviluppatore, poi il revisore, infine l'applicatore.

## Flusso

```
kmeans-orchestratore
   ├─ 1. kmeans-sviluppatore  →  R/kmeans.R
   ├─ 2. kmeans-revisore      →  R/kmeans.R (migliorato)
   └─ 3. kmeans-applicatore   →  R/applica_usarrests.R + output/usarrests_clusters.csv
```

## Artefatti prodotti

- `R/kmeans.R` — implementazione dell'algoritmo K-means (algoritmo di Lloyd)
- `R/applica_usarrests.R` — script che applica il K-means a `USArrests`
- `output/usarrests_clusters.csv` — assegnazione stato → cluster
