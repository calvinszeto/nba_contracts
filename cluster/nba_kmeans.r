# A kmeans function that takes a data frame and clusters it,
# returning the number of total clusters and the given data frame 
# with a feature for the cluster number.
# 
# Named "nba_kmeans" in order to distinguish from the 
# kmeans function that comes with R.

max_iterations <- 30
num_clusters <- 15

# Assumes that the ID variable is labeled "Rk"
nba_kmeans <- function(dat) {
    mat <- data.matrix(dat[,sapply(dat,is.numeric)])
    mat[is.na(mat)] <- 0

    print(c("Cluster ", num_clusters))
    # TODO: Deal with the ID column
    num_rows = dim(mat)[1]
    num_variables = dim(mat)[2]
    results <- NULL

    # Initialize cluster centers
    centers <- data.frame(replicate(num_variables-1,rep(NA,num_clusters)))
    for (v in 1:num_variables) {
        # Assuming the first column is the ID column
        if (v == 1) {
            next
        } else {
            # We want to do each variable column so the random
            # centers make some sense
            vals <- runif(num_clusters, min(mat[,v]), max(mat[,v]))
        }
        centers[,v-1] <- vals
    }

    # Create an rx2 matrix for holding the Rk and clusterings
    clustering <- data.frame(dat$Rk, rep(NA, num_rows), rep(NA, num_rows))
    colnames(clustering) <- c("Rk", "Cluster", "Distance")

    # Calculate new cluster centers
    for (i in 1:max_iterations) {
        print(c("Iteration ", i))
        # Set cluster variable for each row as the closest center  
        results_list <- apply(mat[,-(1:1)], 1, euclidean_closest, centers)
        # Convert to dataframe
        results_df <- data.frame(matrix(unlist(results_list), nrow=num_rows,
            byrow=T))
        names(results_df) <- c("center", "distance")
        clustering$Cluster <- results_df$center
        clustering$Distance <- results_df$distance
        results <- merge(dat, clustering, by="Rk")
        # Check for empty clusters
        repeat {
            has_empty <- FALSE
            for (c in 1:num_clusters) {
                cluster <- results[results$Cluster == c,]
                if(dim(cluster)[1] == 0) {
                    # Insert a random point into this cluster
                    random_point <- ceiling(runif(1, 1, dim(results)[1]))
                    print(c("Cluster ", c, " is empty, replacing with ", random_point))
                    results[random_point, "Cluster"] <- c
                    has_empty <- TRUE
                }
            }
            if(has_empty == FALSE) {
                break
            }
        }
        # Recalculate cluster centers
        center_changed <- FALSE
        for (c in 1:num_clusters) {
            # Average all data points that belong to this cluster
            cluster <- results[results$Cluster == c,]
            cluster_mat <- data.matrix(cluster[ , 
                sapply(results,is.numeric) & !(names(results) %in% c("Rk", "Cluster", "Distance"))])
            cluster_mat[is.na(cluster_mat)] <- 0
            new_center <- apply(cluster_mat, 2, mean)
            # TODO: If new center is different from old center, set flag
            if(euclidean_closest(new_center, centers[c,])$distance > 1) {
                center_changed = TRUE
            }
            # Store new center
            centers[c,] <- new_center
        }

        # If the centers don't change past a certain margin, we are satisfied
        if(!center_changed) break
    }
    
    # Merge the clusters with the original dataset
    return(merge(dat,clustering, by="Rk"))
}

# row is the vector to be clustered
# centers is the matrix of cluster centers
# Remove the ID variable before using this function
euclidean_closest <- function(row, centers) {
    num_variables <- length(row)
    min_distance <- -1
    best_cluster <- 0
    for (c in 1:dim(centers)[1]) {
        distance <- 0 
        for (v in 1:dim(centers)[2]) {
            distance <- distance + (row[v] - centers[c,v]) ** 2
        }
        # We skip the sqrt step because we only want to minimize sum-of-squares
        if (min_distance < 0 | distance < min_distance) {
            min_distance <- distance
            best_cluster <- c
        }
    }
    return(list(center=best_cluster, distance=min_distance))
}
