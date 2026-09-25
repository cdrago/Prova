# PCA del dataset USArrests con FactoMineR
# Dataset: 50 stati USA, 4 variabili (Murder, Assault, UrbanPop, Rape)

library(FactoMineR)
library(factoextra)

data("USArrests")
str(USArrests)
summary(USArrests)

# PCA su dati standardizzati (scale.unit = TRUE): le variabili hanno
# unità di misura e varianze molto diverse (es. Assault vs Murder)
res.pca <- PCA(USArrests, scale.unit = TRUE, ncp = 4, graph = FALSE)

# Riepilogo generale
summary(res.pca)

# Autovalori e varianza spiegata
print(res.pca$eig)

# Variabili: coordinate, cos2 e contributi
print(round(res.pca$var$coord, 3))
print(round(res.pca$var$cos2, 3))
print(round(res.pca$var$contrib, 2))

# Descrizione automatica delle dimensioni
print(dimdesc(res.pca, axes = 1:2))

# Grafici
pdf("pca_usarrests_plots.pdf", width = 8, height = 7)
print(fviz_eig(res.pca, addlabels = TRUE))
print(fviz_pca_var(res.pca, col.var = "contrib", repel = TRUE))
print(fviz_pca_ind(res.pca, col.ind = "cos2", repel = TRUE))
print(fviz_pca_biplot(res.pca, repel = TRUE))
dev.off()
