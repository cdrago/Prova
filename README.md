# Prova

# solo una prova

## K-means su USArrests (R)

Script: `kmeans_usarrests.R` — eseguire con `Rscript kmeans_usarrests.R`
(richiede solo R base e il pacchetto `cluster`).

Contenuto:
- K-means implementato da zero (Lloyd + inizializzazione k-means++), verificato contro `stats::kmeans`;
- scelta di k: gomito, silhouette, Calinski-Harabasz, Davies-Bouldin, Dunn, gap statistic;
- validazione di stabilità via bootstrap (ARI e Jaccard per cluster);
- confronto con clustering gerarchico di Ward (ARI);
- grafici in `output/kmeans_usarrests.pdf`.
