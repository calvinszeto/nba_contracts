total_clusters <- 25

find_optimal_k <- function(dat) {
    wss <- data.frame(clusters=rep(NA, total_clusters), SSE=rep(NA, total_clusters))
    for(c in 1:total_clusters) {
        wss[c,] <- c(c, regular_kmeans_with_pca(dat, c)$kmeans$tot.withinss)
    }
    plot(wss$clusters , wss$SSE, type="b", xlab="Number of Clusters", ylab="SSE", main="SSE vs. Number of Clusters")
    return(wss)
}

regular_kmeans <- function(dat, k=NULL) {
    if(is.null(k)) {
        k <- ceiling(sqrt(dim(dat)[1]/2))
    }
    mat <- data.matrix(dat[,sapply(dat,is.numeric)])
    mat[is.na(mat)] <- 0
    results <- kmeans(mat, k, iter.max=30)
    clustered_dat <- cbind(results$cluster, dat)
    names(clustered_dat)[1] <- "cluster"
    return(list(data=clustered_dat, kmeans=results))
}

regular_kmeans_with_pca <- function(dat, k=NULL) {
    if(is.null(k)) {
        k <- ceiling(sqrt(dim(dat)[1]/2))
    }
    mat <- data.matrix(dat[,sapply(dat,is.numeric)])
    mat[is.na(mat)] <- 0
    pca <- princomp(mat)
    mat <- cbind(pca$scores[,1]
        , pca$scores[,2])
    results <- kmeans(mat, k, iter.max=30)
    clustered_dat <- cbind(results$cluster, dat)
    names(clustered_dat)[1] <- "cluster"
    return(list(data=clustered_dat, kmeans=results))
}
