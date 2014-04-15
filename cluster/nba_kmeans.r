# A kmeans function that takes a data frame and clusters it,
# returning the number of total clusters and the given data frame 
# with a feature for the cluster number.
# 
# Named "nba_kmeans" in order to distinguish from the 
# kmeans function that comes with R.

max_clusters <- 50
max_iterations <- 30

nba_kmeans <- function(dat, id="Rk") {
    # Lowest RMSE so far
    best_rmse <- -1
    # Number of clusters that resulted in best score so far
    best_num <- -1
    # Data frame that holds on to best clustering so far
    best_clustering <- NULL 

    # Remove non-numeric columns to get a matrix
    mat <- dat[ , sapply(dat,is.numeric) ]
    
    for (k in 1:max_clusters) {
        # Keep in mind that the first column is the ID column
        num_variables = length(mat) - 1
        # Initialize cluster centers

        for (i in 1:max_iterations) {
            # Set cluster variable for each row as the closest center  
            # Recalculate cluster centers
        }
    }
    
    # Merge the clusters with the original dataset
    return(merge(dat,best_clustering, by="Rk"))
}

# row is the vector to be clustered
# centers is the matrix of cluster centers
euclidean_closest <- function(row, centers) {
    # TODO: Consider ID variable
    min_distance <- -1
    best_cluster <- 0
    for (c in 1:length(centers[,1])) {
        distance <- 0 
        for (v in 1:num_variables) {
            distance = distance + (row[v] - centers[c,v]) ** num_variables
        }
        distance = distance ** (1/num_variables)
        if (min_distance < 0 | distance < min_distance) {
            min_distance <- distance
            best_cluster <- c
        }
    }
    return(c)
}
