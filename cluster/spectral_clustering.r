spectral_cluster <- function(dat, k=NULL) {
    if(is.null(k)) {
        k <- ceiling(sqrt(dim(dat)[1]/2))
    }
    mat <- data.matrix(dat[,sapply(dat,is.numeric)])
    mat[is.na(mat)] <- 0
    results <- specClust(mat, k, iter.max=30)
    clustered_dat <- cbind(results$cluster, dat)
    names(clustered_dat)[1] <- "cluster"
    return(list(data=clustered_dat, kmeans=results))
}


