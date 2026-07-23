# applica_usarrests.R
# -------------------------------------------------------------------------
# APPLICAZIONE della funzione kmeans_custom() al dataset USArrests.
# Autore: Applicatore - team K-means
#
# Scopo: eseguire il clustering K-means "fatto a mano" (algoritmo di Lloyd,
# implementato in R/kmeans.R) sui 50 stati USA descritti dal dataset
# USArrests, interpretare i gruppi ottenuti e validarli confrontandoli con
# l'implementazione di riferimento stats::kmeans.
#
# NOTA OPERATIVA: questo script e' PRONTO ALL'USO ma NON e' stato eseguito
# in fase di sviluppo perche' R/Rscript non e' disponibile nell'ambiente di
# creazione. I valori numerici finali (centroidi, dimensioni dei cluster,
# assegnazioni per stato) si ottengono eseguendo lo script; qui sotto sono
# descritti in commento solo i risultati ATTESI a livello qualitativo.
# Per eseguirlo:  Rscript R/applica_usarrests.R   (dalla radice del repo)
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# 1) CARICAMENTO DELLA FUNZIONE E DEI DATI
# -------------------------------------------------------------------------
# Carichiamo l'implementazione custom del K-means. Il percorso e' relativo
# alla radice del repository: eseguire lo script da li' (o adeguare il path).
source("R/kmeans.R")

# USArrests e' incluso in R di base (package 'datasets'). Contiene, per
# ciascuno dei 50 stati USA (anno 1973):
#   - Murder   : arresti per omicidio    (per 100.000 abitanti)
#   - Assault  : arresti per aggressione  (per 100.000 abitanti)
#   - UrbanPop : percentuale di popolazione urbana (%)
#   - Rape     : arresti per violenza sessuale (per 100.000 abitanti)
data("USArrests")

# Diagnostica di base sui dati (nessun NA atteso in USArrests).
cat("Dimensioni del dataset USArrests:", nrow(USArrests), "righe x",
    ncol(USArrests), "colonne\n")
cat("Variabili:", paste(colnames(USArrests), collapse = ", "), "\n\n")


# -------------------------------------------------------------------------
# 2) STANDARDIZZAZIONE DELLE VARIABILI
# -------------------------------------------------------------------------
# PERCHE' STANDARDIZZARE:
# Le quattro variabili hanno unita' di misura e scale MOLTO diverse. Ad
# esempio Assault assume valori dell'ordine delle centinaia (decine-350),
# mentre Murder e Rape sono nell'ordine delle decine e UrbanPop e' una
# percentuale (circa 30-90). Il K-means si basa sulla distanza euclidea:
# senza standardizzazione la variabile con la varianza numericamente piu'
# grande (Assault) dominerebbe il calcolo delle distanze, e le altre tre
# diventerebbero quasi irrilevanti. Cluster determinati di fatto dalla sola
# Assault non sarebbero informativi.
#
# scale() sottrae la media e divide per la deviazione standard, colonna per
# colonna: ogni variabile ha cosi' media 0 e deviazione standard 1, e tutte
# contribuiscono in modo comparabile alla distanza. e' la prassi standard
# per il K-means su feature eterogenee.
USArrests_scaled <- scale(USArrests)

# scale() restituisce una matrice numerica (con attributi center/scale):
# kmeans_custom() accetta direttamente una matrice numerica.
cat("Variabili standardizzate (media ~0, sd ~1 per colonna).\n")
cat("Medie post-scaling (attese ~0):\n")
print(round(colMeans(USArrests_scaled), 6))
cat("\n")


# -------------------------------------------------------------------------
# 3) SEED PER LA RIPRODUCIBILITA'
# -------------------------------------------------------------------------
# Il K-means inizializza i centroidi in modo casuale (in kmeans_custom si
# campionano k osservazioni come centroidi iniziali). Fissiamo un seed cosi'
# che l'inizializzazione - e quindi il risultato - sia riproducibile.
# kmeans_custom accetta l'argomento 'seed' e lo gestisce in modo LOCALE
# (ripristina lo stato del RNG all'uscita, senza effetti collaterali).
SEED <- 123
set.seed(SEED)  # fissiamo anche il RNG globale, usato dal confronto stats::kmeans


# -------------------------------------------------------------------------
# 4) SCELTA DI k ED ESECUZIONE DEL CLUSTERING
# -------------------------------------------------------------------------
# PERCHE' k = 4:
# La scelta e' motivata sia concettualmente sia empiricamente.
# - Concettualmente, e' naturale interpretare gli stati su una scala di
#   criminalita' articolata in piu' livelli (es. bassa / medio-bassa /
#   medio-alta / alta), eventualmente modulati dal grado di urbanizzazione.
#   Quattro gruppi offrono una granularita' leggibile senza frammentare
#   eccessivamente 50 osservazioni.
# - Empiricamente, k = 4 e' una scelta comune e ben documentata in
#   letteratura per USArrests; una analisi del "gomito" (elbow) sulla
#   varianza intra-cluster totale (tot_withinss) tipicamente mostra un
#   rendimento decrescente oltre k = 3-4.
# In via ESPLORATIVA (opzionale) calcoliamo sotto tot_withinss per piu'
# valori di k, per documentare l'andamento (curva a gomito).

K <- 4

# Curva a gomito esplorativa: tot_withinss al variare di k da 1 a 8.
# (Solo diagnostico; non incide sul risultato principale con k = 4.)
cat("Curva a gomito esplorativa (tot_withinss per k = 1..8):\n")
for (kk in 1:8) {
  fit_kk <- kmeans_custom(USArrests_scaled, k = kk, seed = SEED)
  cat(sprintf("  k = %d  ->  tot_withinss = %.3f\n", kk, fit_kk$tot_withinss))
}
cat("\n")

# Esecuzione principale con k = 4.
fit <- kmeans_custom(USArrests_scaled, k = K, seed = SEED)


# -------------------------------------------------------------------------
# 5) STAMPA DEI RISULTATI
# -------------------------------------------------------------------------
cat("=====================================================\n")
cat(" RISULTATI K-MEANS CUSTOM su USArrests (k =", K, ")\n")
cat("=====================================================\n\n")

cat("Iterazioni fino a convergenza:", fit$iterations, "\n\n")

# Dimensione dei cluster (quante osservazioni per gruppo).
cat("Dimensione dei cluster:\n")
print(table(fit$cluster))
cat("\n")

# Centroidi (in scala standardizzata): valori positivi indicano una feature
# sopra la media nazionale, negativi sotto la media.
cat("Centroidi (scala standardizzata):\n")
print(round(fit$centers, 3))
cat("\n")

# Within-cluster sum of squares per cluster e totale.
cat("Within-cluster SS per cluster:\n")
print(round(fit$withinss, 3))
cat("Tot. within-cluster SS:", round(fit$tot_withinss, 3), "\n\n")

# Assegnazione stato -> cluster.
assegnazioni <- data.frame(
  Stato   = rownames(USArrests),
  Cluster = fit$cluster,
  stringsAsFactors = FALSE
)
# Ordiniamo per cluster per una lettura piu' comoda.
assegnazioni <- assegnazioni[order(assegnazioni$Cluster, assegnazioni$Stato), ]

cat("Assegnazione di ciascuno stato al cluster:\n")
print(assegnazioni, row.names = FALSE)
cat("\n")


# -------------------------------------------------------------------------
# 6) SALVATAGGIO DEI RISULTATI SU CSV
# -------------------------------------------------------------------------
# Creiamo la cartella output/ se non esiste (recursive = TRUE non fallisce
# se e' gia' presente; showWarnings = FALSE silenzia l'avviso in tal caso).
if (!dir.exists("output")) {
  dir.create("output", recursive = TRUE, showWarnings = FALSE)
}

csv_path <- "output/usarrests_clusters.csv"
write.csv(assegnazioni, file = csv_path, row.names = FALSE)
cat("Risultati salvati in:", csv_path, "\n\n")


# -------------------------------------------------------------------------
# 7) CONFRONTO CON stats::kmeans (VALIDAZIONE DI COERENZA)
# -------------------------------------------------------------------------
# stats::kmeans e' l'implementazione di riferimento di R. La usiamo per
# validare che il nostro K-means custom produca un partizionamento COERENTE.
# ATTENZIONE: le etichette dei cluster (1,2,3,4) sono arbitrarie e non
# confrontabili direttamente tra le due implementazioni: cio' che conta e'
# la STRUTTURA del partizionamento (quali stati stanno insieme), non il
# numero dell'etichetta. Per questo confrontiamo con una tabella di
# contingenza (cross-tab): se le due partizioni concordano, ogni riga/colonna
# della tabella avra' i conteggi concentrati in una sola cella.
set.seed(SEED)
fit_ref <- stats::kmeans(USArrests_scaled, centers = K, nstart = 25)

cat("Confronto con stats::kmeans (tabella di contingenza):\n")
cat("(concordanza = conteggi concentrati in una cella per riga/colonna)\n")
print(table(custom = fit$cluster, stats = fit_ref$cluster))
cat("\n")

cat("Tot. within-cluster SS  - custom :", round(fit$tot_withinss, 3), "\n")
cat("Tot. within-cluster SS  - stats  :", round(fit_ref$tot.withinss, 3), "\n")
cat("(valori attesi simili; stats::kmeans con nstart=25 puo' trovare un\n")
cat(" ottimo leggermente migliore, quindi tot_withinss <= a quello custom)\n\n")

cat("Script completato.\n")


# =========================================================================
# INTERPRETAZIONE QUALITATIVA ATTESA (commento, NON valori calcolati)
# =========================================================================
# Poiche' lo script non e' stato eseguito, non riportiamo numeri precisi.
# Sulla base della struttura nota di USArrests, ci si aspetta che il K-means
# con k = 4 sui dati standardizzati produca gruppi interpretabili lungo due
# assi principali: il LIVELLO DI CRIMINALITA' violenta (Murder, Assault,
# Rape, fortemente correlate tra loro) e il grado di URBANIZZAZIONE
# (UrbanPop). Tipicamente emergono cluster del tipo:
#
#   - ALTA CRIMINALITA' + molto urbani: stati come Florida, California,
#     Nevada, Illinois, New York, Arizona - centroidi con Murder/Assault/
#     Rape ben sopra la media (valori standardizzati positivi) e UrbanPop
#     alto.
#
#   - ALTA CRIMINALITA' ma meno urbani: stati del Sud come Mississippi,
#     South Carolina, North Carolina, Georgia, Alabama, Louisiana -
#     criminalita' violenta sopra la media ma UrbanPop piu' basso.
#
#   - CRIMINALITA' MEDIO-BASSA / urbanizzazione medio-alta: stati piu'
#     "tranquilli" ma urbanizzati.
#
#   - BASSA CRIMINALITA' (stati piu' sicuri): stati rurali del Nord e del
#     Midwest come North Dakota, Vermont, New Hampshire, Maine, Wisconsin,
#     Iowa, Minnesota - tutte le feature di criminalita' sotto la media
#     (valori standardizzati negativi).
#
# In sintesi: gli stati ad ALTA criminalita' tendono a raggrupparsi insieme
# e quelli a BASSA criminalita' insieme, con la dimensione dell'urbanizzazione
# a separare ulteriormente i gruppi ad alta criminalita'. Il confronto con
# stats::kmeans dovrebbe mostrare un partizionamento sostanzialmente coerente
# (stessi stati raggruppati insieme, a meno del rietichettamento dei cluster).
# =========================================================================
