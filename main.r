source("./preprocess/preprocess.r")
source("./cluster/regular_kmeans.r")

# Create matrix of per-game data for all players from season 06-07 to 13-14
players <- for_regression()
# Trim unwanted features
players <- players[,c("Player", "season", "PTS", "TRB", "AST", "BLK", "STL", "FG", "FT", "X3P", "TOV")]
# Run clustering on players
clustered <- regular_kmeans(players, 15)
# Create matrix of salary data for free agents from 06-07 to 12-13
contracts <- contracts()
# Add cluster data to salary data
df <- merge(clustered, contracts[,c("player", "amount", "season")]
    , by.x=c("Player", "season"), by.y=c("player", "season"), all=F)
# Plot salary vs. cluster
num_clusters <- max(df$cluster)
boxplot(df[df$cluster==1,"amount"], xlim=c(1, num_clusters)
    , ylim=c(0, 23000000))
for(cluster in 2:num_clusters) {
    boxplot(df[df$cluster==cluster,"amount"], at=cluster, add=TRUE)
}
# TODO: Add labels to plot
