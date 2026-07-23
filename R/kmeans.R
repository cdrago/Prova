# kmeans.R
# Implementazione "a mano" dell'algoritmo K-means (algoritmo di Lloyd).
# Autore: Sviluppatore R - team K-means
# NOTA: questa implementazione NON usa stats::kmeans per il calcolo.

# ---------------------------------------------------------------------------
# Funzione ausiliaria: assegnazione vettorializzata dei punti ai centroidi.
# Restituisce, per ogni riga di 'data', l'indice del centroide piu' vicino.
#
# Usiamo la distanza euclidea AL QUADRATO: per trovare il centroide piu'
# vicino non serve la radice quadrata (e' monotona), risparmiando calcoli.
#
# La vettorializzazione e' fatta ciclando sui k centroidi (tipicamente k << n)
# invece che sugli n punti: per ogni centroide una sola operazione matriciale
# (sweep + rowSums) calcola in blocco le distanze da tutti i punti. Questo
# sostituisce il precedente doppio loop O(n) di chiamate a sweep.
# ---------------------------------------------------------------------------
.assegna_cluster <- function(data, centri) {
  # data:   matrice n x p
  # centri: matrice k x p (una riga per centroide)
  n <- nrow(data)
  k <- nrow(centri)
  # Matrice n x k delle distanze al quadrato punto-centroide.
  d2 <- matrix(NA_real_, nrow = n, ncol = k)
  for (j in seq_len(k)) {
    # sweep sottrae il centroide j da ogni riga di 'data'.
    differenze <- sweep(data, 2, centri[j, ], FUN = "-")
    d2[, j] <- rowSums(differenze^2)
  }
  # Per ogni riga, indice della colonna con distanza minima. max.col su -d2
  # equivale a which.min per riga; ties.method = "first" replica il
  # comportamento deterministico di which.min sui pareggi.
  max.col(-d2, ties.method = "first")
}

# ---------------------------------------------------------------------------
# Funzione principale: kmeans_custom
# ---------------------------------------------------------------------------
kmeans_custom <- function(data, k, max_iter = 100, tol = 1e-6, seed = NULL) {

  # -------------------------------------------------------------------------
  # 1) VALIDAZIONE DEGLI INPUT E GESTIONE DEI CASI LIMITE
  # -------------------------------------------------------------------------

  # Se e' un data.frame lo convertiamo in matrice; controllando prima che
  # tutte le colonne siano numeriche, altrimenti la conversione produrrebbe
  # silenziosamente una matrice di tipo carattere.
  if (is.data.frame(data)) {
    # Verifichiamo che ogni colonna sia numerica (numeric o integer).
    colonne_non_numeriche <- !vapply(data, is.numeric, logical(1))
    if (any(colonne_non_numeriche)) {
      stop("I dati contengono colonne non numeriche: ",
           paste(names(data)[colonne_non_numeriche], collapse = ", "),
           ". K-means richiede dati esclusivamente numerici.")
    }
    data <- as.matrix(data)
  }

  # A questo punto 'data' deve essere una matrice.
  if (!is.matrix(data)) {
    stop("'data' deve essere una matrice o un data.frame numerico.")
  }

  # La matrice deve essere numerica (non carattere ne' logica).
  if (!is.numeric(data)) {
    stop("'data' deve contenere solo valori numerici. ",
         "Trovato tipo: ", typeof(data), ".")
  }

  # Non ammettiamo valori mancanti o non finiti (NA, NaN, Inf): renderebbero
  # indefinito il calcolo delle medie e delle distanze.
  if (any(!is.finite(data))) {
    stop("'data' contiene valori mancanti o non finiti (NA/NaN/Inf). ",
         "Rimuovere o imputare tali valori prima di eseguire il clustering.")
  }

  # Numero di righe (osservazioni) e colonne (feature).
  n <- nrow(data)
  p <- ncol(data)

  # k deve essere un singolo intero positivo.
  if (length(k) != 1L || !is.numeric(k) || is.na(k) || k < 1 || k != as.integer(k)) {
    stop("'k' deve essere un singolo numero intero positivo.")
  }
  k <- as.integer(k)

  # Caso limite: k maggiore del numero di osservazioni. Non e' possibile
  # formare k cluster non vuoti con meno di k punti distinti.
  if (k > n) {
    stop("'k' (", k, ") e' maggiore del numero di righe dei dati (", n, "). ",
         "Il numero di cluster non puo' superare il numero di osservazioni.")
  }

  # Validazione di max_iter e tol.
  if (length(max_iter) != 1L || !is.numeric(max_iter) || is.na(max_iter) || max_iter < 1) {
    stop("'max_iter' deve essere un numero intero positivo.")
  }
  max_iter <- as.integer(max_iter)

  if (length(tol) != 1L || !is.numeric(tol) || is.na(tol) || tol < 0) {
    stop("'tol' deve essere un numero non negativo.")
  }

  # Impostiamo il seme per la riproducibilita', solo se fornito.
  # IMPORTANTE: set.seed() modifica lo stato GLOBALE del generatore di numeri
  # casuali. Per non alterare la sequenza casuale del chiamante trattiamo il
  # seme come LOCALE: salviamo lo stato corrente di .Random.seed e lo
  # ripristiniamo all'uscita della funzione (anche in caso di errore) tramite
  # on.exit. Cosi' la funzione e' riproducibile senza effetti collaterali.
  if (!is.null(seed)) {
    if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
      seme_precedente <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
      on.exit(assign(".Random.seed", seme_precedente, envir = globalenv()),
              add = TRUE)
    } else {
      # Il RNG non era ancora stato inizializzato: all'uscita rimuoviamo la
      # variabile creata da set.seed per ripristinare lo stato originale.
      on.exit(
        if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
          rm(".Random.seed", envir = globalenv())
        },
        add = TRUE)
    }
    set.seed(seed)
  }

  # -------------------------------------------------------------------------
  # 2) INIZIALIZZAZIONE DEI CENTROIDI
  #    Scegliamo k punti casuali (senza rimpiazzo) tra le osservazioni.
  # -------------------------------------------------------------------------
  indici_iniziali <- sample.int(n, k, replace = FALSE)
  # 'centers' e' una matrice k x p. drop = FALSE mantiene la struttura di
  # matrice anche quando p == 1 (una sola feature).
  centers <- data[indici_iniziali, , drop = FALSE]

  # Vettore che conterra' l'assegnazione di cluster per ogni punto (viene
  # popolato dalla fase di assegnazione nel ciclo principale).
  cluster <- integer(n)

  # Contatore delle iterazioni effettivamente eseguite.
  iterations <- 0L

  # -------------------------------------------------------------------------
  # 3) CICLO PRINCIPALE (algoritmo di Lloyd)
  # -------------------------------------------------------------------------
  for (iter in seq_len(max_iter)) {
    iterations <- iter

    # ---- 3a) FASE DI ASSEGNAZIONE ----
    # Assegniamo ogni punto al centroide piu' vicino (distanza al quadrato).
    # Calcolo vettorializzato tramite l'helper .assegna_cluster.
    cluster <- .assegna_cluster(data, centers)

    # ---- 3b) FASE DI AGGIORNAMENTO ----
    # Ricalcoliamo ogni centroide come media dei punti a esso assegnati.
    nuovi_centers <- matrix(NA_real_, nrow = k, ncol = p)

    # ---- GESTIONE CLUSTER VUOTO (strategia) ----
    # Se un cluster resta senza punti la sua media sarebbe indefinita.
    # Strategia adottata: ri-inizializziamo quel centroide sul punto "peggio
    # servito", cioe' quello piu' lontano dal proprio centroide corrente, cosi'
    # da dargli almeno un'osservazione alla prossima iterazione ed evitare
    # cluster degeneri. Se piu' cluster sono vuoti nella stessa iterazione,
    # escludiamo i punti gia' scelti (vettore 'punti_usati') per non generare
    # centroidi duplicati.
    #
    # 'dist_dai_propri' e' calcolata in modo vettorializzato: centers[cluster, ]
    # e' la matrice (n x p) dei centroidi assegnati a ciascun punto, quindi la
    # differenza con 'data' da' direttamente lo scarto punto-centroide.
    # La calcoliamo pigramente (solo se esiste almeno un cluster vuoto).
    dist_dai_propri <- NULL
    punti_usati <- integer(0)

    for (j in seq_len(k)) {
      punti_del_cluster <- which(cluster == j)

      if (length(punti_del_cluster) == 0L) {
        if (is.null(dist_dai_propri)) {
          dist_dai_propri <-
            rowSums((data - centers[cluster, , drop = FALSE])^2)
        }
        # Escludiamo i punti gia' riassegnati ad altri cluster vuoti.
        candidati <- dist_dai_propri
        candidati[punti_usati] <- -Inf
        punto_piu_lontano <- which.max(candidati)
        punti_usati <- c(punti_usati, punto_piu_lontano)
        nuovi_centers[j, ] <- data[punto_piu_lontano, ]
      } else {
        # Media colonna per colonna dei punti assegnati al cluster j.
        # drop = FALSE garantisce una matrice anche con un solo punto.
        nuovi_centers[j, ] <-
          colMeans(data[punti_del_cluster, , drop = FALSE])
      }
    }

    # ---- 3c) CONTROLLO DI CONVERGENZA ----
    # Misuriamo di quanto si sono spostati i centroidi rispetto all'iterazione
    # precedente. Se lo spostamento massimo e' inferiore alla tolleranza,
    # consideriamo l'algoritmo convergente e usciamo dal ciclo.
    spostamento <- max(abs(nuovi_centers - centers))
    centers <- nuovi_centers

    if (spostamento <= tol) {
      break
    }
  }

  # -------------------------------------------------------------------------
  # 3d) ASSEGNAZIONE FINALE COERENTE
  #     Nel ciclo, 'cluster' viene calcolato rispetto ai centroidi dell'inizio
  #     iterazione, poi 'centers' viene aggiornato: al termine del ciclo le due
  #     quantita' risultano sfasate di un passo. Rifacciamo un'ultima
  #     assegnazione rispetto ai centroidi FINALI, cosi' che 'cluster',
  #     'centers' e 'withinss' siano tra loro coerenti (ogni punto e' associato
  #     al centroide finale piu' vicino). A convergenza questo passo lascia le
  #     assegnazioni invariate.
  # -------------------------------------------------------------------------
  cluster <- .assegna_cluster(data, centers)

  # -------------------------------------------------------------------------
  # 4) CALCOLO DELLE STATISTICHE FINALI (within-cluster sum of squares)
  #    withinss[j] = somma delle distanze euclidee al quadrato tra i punti
  #    del cluster j e il loro centroide.
  # -------------------------------------------------------------------------
  withinss <- numeric(k)
  for (j in seq_len(k)) {
    punti_del_cluster <- which(cluster == j)
    if (length(punti_del_cluster) > 0L) {
      differenze <- sweep(data[punti_del_cluster, , drop = FALSE],
                          2, centers[j, ], FUN = "-")
      withinss[j] <- sum(differenze^2)
    } else {
      # Cluster vuoto: contributo nullo alla somma dei quadrati.
      withinss[j] <- 0
    }
  }

  # Somma totale della varianza intra-cluster.
  tot_withinss <- sum(withinss)

  # -------------------------------------------------------------------------
  # 5) RESTITUZIONE DEL RISULTATO
  # -------------------------------------------------------------------------
  # Riportiamo i nomi delle colonne originali sui centroidi, se presenti.
  if (!is.null(colnames(data))) {
    colnames(centers) <- colnames(data)
  }

  list(
    cluster      = cluster,        # vettore di lunghezza n con l'indice cluster
    centers      = centers,        # matrice k x p dei centroidi finali
    iterations   = iterations,     # numero di iterazioni eseguite
    withinss     = withinss,       # SS intra-cluster per ciascun cluster
    tot_withinss = tot_withinss    # SS intra-cluster totale
  )
}
