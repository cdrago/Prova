# =============================================================================
# K-means su USArrests con validazione
# -----------------------------------------------------------------------------
# 1. Preparazione dati (standardizzazione)
# 2. Implementazione da zero di K-means (Lloyd + inizializzazione k-means++)
#    e confronto con stats::kmeans
# 3. Scelta di k: metodo del gomito, silhouette media, Calinski-Harabasz,
#    gap statistic
# 4. Validazione interna: silhouette, Dunn, Calinski-Harabasz, Davies-Bouldin
# 5. Validazione di stabilita': bootstrap con indice di Jaccard per cluster
#    e Adjusted Rand Index (ARI) tra partizioni
# 6. Confronto con clustering gerarchico (Ward) tramite ARI
# 7. Interpretazione: centroidi nella scala originale e grafici
#
# Dipendenze: solo R base + pacchetto 'cluster' (incluso tra i "recommended").
# Esecuzione:  Rscript kmeans_usarrests.R
# Output:      testo su console + grafici in output/kmeans_usarrests.pdf
# =============================================================================

suppressPackageStartupMessages(library(cluster))

set.seed(123)
dir.create("output", showWarnings = FALSE)

# -----------------------------------------------------------------------------
# 1. Dati
# -----------------------------------------------------------------------------
data("USArrests")
cat("== Struttura dei dati ==\n")
str(USArrests)
cat("\nValori mancanti:", sum(is.na(USArrests)), "\n")
print(summary(USArrests))

# Le variabili hanno scale molto diverse (Assault ~ centinaia, Murder ~ unita'):
# K-means usa la distanza euclidea, quindi si standardizza.
X <- scale(USArrests)

# -----------------------------------------------------------------------------
# 2. K-means implementato da zero
# -----------------------------------------------------------------------------

# Inizializzazione k-means++ (Arthur & Vassilvitskii, 2007)
kmeanspp_init <- function(X, k) {
  n <- nrow(X)
  centers <- matrix(NA_real_, k, ncol(X))
  centers[1, ] <- X[sample.int(n, 1), ]
  d2 <- rowSums((X - matrix(centers[1, ], n, ncol(X), byrow = TRUE))^2)
  if (k > 1) for (j in 2:k) {
    centers[j, ] <- X[sample.int(n, 1, prob = d2 / sum(d2)), ]
    d2 <- pmin(d2, rowSums((X - matrix(centers[j, ], n, ncol(X), byrow = TRUE))^2))
  }
  centers
}

# Distanze euclidee al quadrato fra righe di X e righe di C (n x k)
sq_dist <- function(X, C) {
  outer(rowSums(X^2), rep(1, nrow(C))) +
    outer(rep(1, nrow(X)), rowSums(C^2)) - 2 * X %*% t(C)
}

# Algoritmo di Lloyd con nstart ripartenze; restituisce la soluzione con
# minima devianza entro i gruppi (WSS)
my_kmeans <- function(X, k, nstart = 25, iter_max = 100, tol = 1e-9) {
  X <- as.matrix(X)
  best <- NULL
  for (s in seq_len(nstart)) {
    C <- kmeanspp_init(X, k)
    cl_old <- rep(0L, nrow(X))
    for (it in seq_len(iter_max)) {
      D <- sq_dist(X, C)
      cl <- max.col(-D, ties.method = "first")
      # gestione cluster vuoti: riassegna il punto piu' lontano dal suo centro
      for (j in setdiff(seq_len(k), unique(cl))) {
        far <- which.max(D[cbind(seq_len(nrow(X)), cl)])
        cl[far] <- j
      }
      C_new <- t(sapply(seq_len(k), function(j) colMeans(X[cl == j, , drop = FALSE])))
      if (k == 1) C_new <- matrix(C_new, nrow = 1)
      converged <- all(cl == cl_old) || sum((C_new - C)^2) < tol
      C <- C_new
      cl_old <- cl
      if (converged) break
    }
    wss <- sapply(seq_len(k), function(j)
      sum(sweep(X[cl == j, , drop = FALSE], 2, C[j, ])^2))
    tot <- sum(wss)
    if (is.null(best) || tot < best$tot.withinss) {
      best <- list(cluster = setNames(cl, rownames(X)), centers = C,
                   withinss = wss, tot.withinss = tot,
                   totss = sum(sweep(X, 2, colMeans(X))^2),
                   size = tabulate(cl, k), iter = it)
    }
  }
  best$betweenss <- best$totss - best$tot.withinss
  colnames(best$centers) <- colnames(X)
  best
}

# -----------------------------------------------------------------------------
# Funzioni di validazione (implementate esplicitamente)
# -----------------------------------------------------------------------------

# Adjusted Rand Index (Hubert & Arabie, 1985)
ari <- function(a, b) {
  tab <- table(a, b)
  c2 <- function(x) x * (x - 1) / 2
  sij <- sum(c2(tab)); sa <- sum(c2(rowSums(tab))); sb <- sum(c2(colSums(tab)))
  expected <- sa * sb / c2(sum(tab))
  (sij - expected) / ((sa + sb) / 2 - expected)
}

# Indice di Dunn: min distanza inter-cluster / max diametro intra-cluster
dunn_index <- function(D, cl) {
  D <- as.matrix(D); ks <- sort(unique(cl))
  diam <- max(sapply(ks, function(j) {
    idx <- which(cl == j); if (length(idx) < 2) 0 else max(D[idx, idx])
  }))
  sep <- min(combn(ks, 2, function(p) min(D[cl == p[1], cl == p[2]])))
  sep / diam
}

# Calinski-Harabasz: [B/(k-1)] / [W/(n-k)]
ch_index <- function(fit, n) {
  k <- length(fit$size)
  (fit$betweenss / (k - 1)) / (fit$tot.withinss / (n - k))
}

# Davies-Bouldin (piu' basso = meglio)
db_index <- function(X, cl, centers) {
  ks <- sort(unique(cl))
  S <- sapply(ks, function(j) {
    Xi <- X[cl == j, , drop = FALSE]
    mean(sqrt(rowSums(sweep(Xi, 2, centers[j, ])^2)))
  })
  M <- as.matrix(dist(centers))
  mean(sapply(seq_along(ks), function(i)
    max(((S[i] + S) / M[i, ])[-i])))
}

# -----------------------------------------------------------------------------
# 2b. Verifica dell'implementazione contro stats::kmeans
# -----------------------------------------------------------------------------
cat("\n== Verifica implementazione (k = 4) ==\n")
fit_my <- my_kmeans(X, 4, nstart = 25)
fit_r  <- kmeans(X, centers = 4, nstart = 25, iter.max = 100)
cat(sprintf("WSS totale  my_kmeans: %.4f   stats::kmeans: %.4f\n",
            fit_my$tot.withinss, fit_r$tot.withinss))
cat(sprintf("ARI tra le due partizioni: %.4f (1 = identiche a meno delle etichette)\n",
            ari(fit_my$cluster, fit_r$cluster)))

# -----------------------------------------------------------------------------
# 3. Scelta del numero di cluster k
# -----------------------------------------------------------------------------
cat("\n== Scelta di k ==\n")
D <- dist(X)
n <- nrow(X)
K <- 2:10
fits <- lapply(K, function(k) my_kmeans(X, k, nstart = 25))
wss_all <- c(my_kmeans(X, 1, nstart = 1)$tot.withinss,
             sapply(fits, `[[`, "tot.withinss"))
crit <- data.frame(
  k          = K,
  WSS        = sapply(fits, `[[`, "tot.withinss"),
  Silhouette = sapply(fits, function(f) mean(silhouette(f$cluster, D)[, 3])),
  CH         = sapply(fits, ch_index, n = n),
  DB         = sapply(fits, function(f) db_index(X, f$cluster, f$centers)),
  Dunn       = sapply(fits, function(f) dunn_index(D, f$cluster))
)
print(round(crit, 4), row.names = FALSE)

# Gap statistic (Tibshirani, Walther & Hastie, 2001), B = 100 riferimenti uniformi
gap <- clusGap(X, FUNcluster = function(x, k) list(cluster = my_kmeans(x, k, nstart = 10)$cluster),
               K.max = 10, B = 100, verbose = FALSE)
k_gap <- maxSE(gap$Tab[, "gap"], gap$Tab[, "SE.sim"], method = "firstSEmax")

votes <- c(
  Silhouette = crit$k[which.max(crit$Silhouette)],
  CH         = crit$k[which.max(crit$CH)],
  DB         = crit$k[which.min(crit$DB)],
  Dunn       = crit$k[which.max(crit$Dunn)],
  Gap        = k_gap
)
cat("\nk suggerito da ciascun criterio:\n"); print(votes)
cat("\nNota: i criteri non sono necessariamente concordi; la scelta finale\n",
    "combina indici, stabilita' e interpretabilita'.\n", sep = "")

# -----------------------------------------------------------------------------
# 4. Validazione di stabilita' via bootstrap
# -----------------------------------------------------------------------------
# Per ogni replica bootstrap si riesegue K-means sul campione e si assegna
# OGNI osservazione originale al centroide bootstrap piu' vicino; si confronta
# con la partizione di riferimento tramite ARI e, cluster per cluster, con il
# massimo indice di Jaccard (approccio analogo a fpc::clusterboot, Hennig 2007).
boot_stability <- function(X, k, B = 200) {
  ref <- my_kmeans(X, k, nstart = 25)
  ari_b <- numeric(B)
  jac <- matrix(NA_real_, B, k)
  for (b in seq_len(B)) {
    idx <- sample.int(nrow(X), replace = TRUE)
    fb <- my_kmeans(X[idx, ], k, nstart = 10)
    cl_b <- max.col(-sq_dist(X, fb$centers), ties.method = "first")
    ari_b[b] <- ari(ref$cluster, cl_b)
    jac[b, ] <- sapply(seq_len(k), function(j) {
      A <- ref$cluster == j
      max(sapply(seq_len(k), function(h) {
        Bh <- cl_b == h; sum(A & Bh) / sum(A | Bh)
      }))
    })
  }
  list(ari = ari_b, jaccard = jac)
}

cat("\n== Stabilita' bootstrap (B = 200) ==\n")
stab <- lapply(2:6, function(k) boot_stability(X, k, B = 200))
stab_tab <- data.frame(
  k            = 2:6,
  ARI_medio    = sapply(stab, function(s) mean(s$ari)),
  ARI_sd       = sapply(stab, function(s) sd(s$ari)),
  Jaccard_min  = sapply(stab, function(s) min(colMeans(s$jaccard)))
)
print(round(stab_tab, 3), row.names = FALSE)
cat("Riferimento (Hennig 2007): Jaccard medio < 0.5 cluster 'dissolto',\n",
    ">= 0.75 cluster stabile, >= 0.85 altamente stabile.\n", sep = "")

# -----------------------------------------------------------------------------
# 5. Modello finale
# -----------------------------------------------------------------------------
# k = 4: per silhouette e CH e' secondo solo a k = 2, e' stabile al bootstrap
# (Jaccard >= 0.85 per tutti i cluster) e piu' interpretabile. Modificabile qui.
k_final <- 4
final <- my_kmeans(X, k_final, nstart = 50)

cat(sprintf("\n== Modello finale: k = %d ==\n", k_final))
cat("Dimensioni cluster:", final$size, "\n")
cat(sprintf("Devianza spiegata (BSS/TSS): %.1f%%\n", 100 * final$betweenss / final$totss))

sil <- silhouette(final$cluster, D)
cat(sprintf("Silhouette media: %.3f\n", mean(sil[, 3])))
cat("Silhouette media per cluster:\n")
print(round(tapply(sil[, 3], sil[, 1], mean), 3))
neg <- rownames(X)[sil[, 3] < 0]
cat("Stati con silhouette negativa (probabilmente mal assegnati):",
    if (length(neg)) paste(neg, collapse = ", ") else "nessuno", "\n")

cat(sprintf("Dunn: %.3f   CH: %.2f   DB: %.3f\n",
            dunn_index(D, final$cluster), ch_index(final, n),
            db_index(X, final$cluster, final$centers)))

js <- colMeans(stab[[k_final - 1]]$jaccard)
cat("Jaccard medio bootstrap per cluster:", round(js, 3), "\n")

# Centroidi riportati nella scala originale
centers_orig <- sweep(sweep(final$centers, 2, attr(X, "scaled:scale"), `*`),
                      2, attr(X, "scaled:center"), `+`)
cat("\nCentroidi (scala originale):\n")
print(round(centers_orig, 2))

cat("\nAssegnazione degli stati:\n")
for (j in seq_len(k_final))
  cat(sprintf("Cluster %d (%d): %s\n", j, final$size[j],
              paste(names(final$cluster)[final$cluster == j], collapse = ", ")))

# -----------------------------------------------------------------------------
# 6. Confronto con clustering gerarchico di Ward
# -----------------------------------------------------------------------------
hc <- hclust(D, method = "ward.D2")
cl_hc <- cutree(hc, k_final)
cat(sprintf("\nARI K-means vs Ward (k = %d): %.3f\n", k_final, ari(final$cluster, cl_hc)))
print(table(KMeans = final$cluster, Ward = cl_hc))

# -----------------------------------------------------------------------------
# 7. Grafici
# -----------------------------------------------------------------------------
pdf("output/kmeans_usarrests.pdf", width = 10, height = 7)
pal <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e",
         "#e6ab02", "#a6761d", "#666666", "#1f78b4", "#b2df8a")

op <- par(mfrow = c(2, 2))
plot(1:10, wss_all, type = "b", pch = 19, xlab = "k", ylab = "WSS",
     main = "Metodo del gomito")
plot(crit$k, crit$Silhouette, type = "b", pch = 19, xlab = "k",
     ylab = "Silhouette media", main = "Silhouette media")
plot(crit$k, crit$CH, type = "b", pch = 19, xlab = "k",
     ylab = "Calinski-Harabasz", main = "Calinski-Harabasz")
plot(gap, main = "Gap statistic", xlab = "k")
abline(v = k_gap, lty = 2)
par(op)

boxplot(lapply(stab, `[[`, "ari"), names = 2:6, xlab = "k",
        ylab = "ARI vs partizione di riferimento",
        main = "Stabilita' bootstrap (B = 200)", col = "grey90")

plot(sil, col = pal[1:k_final], border = NA,
     main = sprintf("Silhouette, K-means k = %d", k_final))

pc <- prcomp(X)
ve <- 100 * pc$sdev^2 / sum(pc$sdev^2)
plot(pc$x[, 1:2], col = pal[final$cluster], pch = 19,
     xlab = sprintf("PC1 (%.1f%%)", ve[1]), ylab = sprintf("PC2 (%.1f%%)", ve[2]),
     main = "Cluster sulle prime due componenti principali")
text(pc$x[, 1:2], labels = rownames(X), pos = 3, cex = 0.55, col = pal[final$cluster])
points(sweep(final$centers, 2, pc$center) %*% pc$rotation[, 1:2], pch = 4, cex = 2.5, lwd = 3)
legend("topright", legend = paste("Cluster", 1:k_final), col = pal[1:k_final], pch = 19)

plot(hc, cex = 0.6, main = "Ward.D2 (confronto)", xlab = "", sub = "")
rect.hclust(hc, k = k_final, border = "red")
invisible(dev.off())

cat("\nGrafici salvati in output/kmeans_usarrests.pdf\n")
sessionInfo()$R.version$version.string |> cat("\n")
