library('ggplot2')
source("./preprocess/preprocess.r")
source("./cluster/regular_kmeans.r")

# Create matrix of per-game data for all players from season 06-07 to 13-14
players <- for_regression()
# Trim unwanted features
players <- players[,c("Player", "season", "PTS", "TRB", "AST", "BLK", "STL", "FG", "FT", "X3P", "TOV")]
# Run clustering on players
clustered <- regular_kmeans_with_pca(players, 13)$data
# Create matrix of salary data for free agents from 06-07 to 12-13
contracts <- contracts()
# Add cluster data to salary data
df <- merge(clustered, contracts[,c("player", "amount", "season")]
    , by.x=c("Player", "season"), by.y=c("player", "season"), all=F)
# Plot salary vs. cluster
df$amount <- df$amount / 1000000
plot <- ggplot(df, aes(factor(cluster), amount))
plot <- plot + geom_boxplot() + labs(
    title="Salary Boxplots for Newly Signed Players"
    , x="Cluster", y="Post-Free-Agency Salary (millions)")
plot <- plot + geom_text(aes(label=ifelse((amount>4*IQR(amount))
    ,paste(as.character(Player), season),"")), hjust=0, vjust=-1,  size=4) 
print(plot)
