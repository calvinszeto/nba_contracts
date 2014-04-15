source('./cluster/nba_kmeans.r')

test_euclidean_closest <- function() {
    row <- c(1,2) 
    centers <- data.frame(replicate(2, runif(10,0,20)))
    centers[5,] <- c(0.9, 2.2)
    result <- euclidean_closest(row, centers)

    return(result$center == 5 & signif(result$distance, 2) == 0.22)
}

