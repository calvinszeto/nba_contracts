library('kknn')
source("./preprocess/preprocess.r")
source("./cluster/spectral_clustering.r")

# Create matrix of per-game data for all players from season 06-07 to 13-14
players <- for_regression()
# Trim unwanted features
players <- players[,c("Player", "season", "PTS", "TRB", "AST", "BLK", "STL", "FG", "FT", "X3P", "TOV")]
# Run clustering on players
# Change method here to try different algorithms
clustered <- spectral_cluster(players, 13)$data
# Create matrix of salary data for free agents from 06-07 to 12-13
contracts <- contracts()
# Add cluster data to salary data
df <- merge(clustered, contracts[,c("player", "amount", "season")]
    , by.x=c("Player", "season"), by.y=c("player", "season"), all=F)
# Remove duplicates
df <- df[!duplicated(df[,-which(names(df) %in% c("Player", "season", "amount"))]),]
# Scale salaries by millions
df$amount <- df$amount / 1000000
# Add labels to cluster outliers
# TODO: This is the worst piece of code. Fix it sometime.
df$label <- rep(NA, dim(df)[1])
for(row in 1:dim(df)[1]){
    top_limit <- 1.5*IQR(df[df$cluster==df[row, "cluster"],"amount"]) +
        quantile(df[df$cluster==df[row, "cluster"],"amount"])[4]
    bottom_limit <- quantile(df[df$cluster==df[row, "cluster"],"amount"])[2] - 
        1.5*IQR(df[df$cluster==df[row, "cluster"],"amount"])
    df[row ,"label"] <- ifelse((df[row, "amount"]>top_limit | df[row, "amount"]<bottom_limit)
        , paste(as.character(df[row, "Player"]), df[row, "season"]), "")
}

for( c in 1:13) {
    print(summary(df[df$cluster==c,]))
}
