regular_kmeans <- function(dat) {
    mat <- data.matrix(dat[,sapply(dat,is.numeric)])
    mat[is.na(mat)] <- 0
    results <- kmeans(mat, ceiling(sqrt(dim(dat)[1]/2)))
    clustered_dat <- cbind(results$cluster, dat)
    names(clustered_dat)[1] <- "cluster"
    return(clustered_dat)
}
