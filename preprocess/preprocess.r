seasons_included <- c(
    '03-04','04-05','05-06','06-07','07-08','08-09'
    ,'09-10','10-11','11-12','12-13','13-14')
types_included <- c('per_game', 'per_minute', 'totals')

contracts <- function() {
    salaries <- read.csv('./data/salaries.csv')
    fa <- read.csv('./data/fa.csv')
    # Clean up salaries
    salaries$amount <- gsub('\\$', '', salaries$amount)
    salaries$amount <- gsub(',', '', salaries$amount)
    salaries$amount <- as.integer(salaries$amount)
    salaries$season <- gsub('^(19|20)', '', salaries$season)
    # Cut out salaries which aren't in fa
    # TODO: There is a small bug with this line that is causing duplicates
    salaries <- merge(salaries, fa, by.x=c("player", "season")
        , by.y=c("Player", "Season"), all=F)
    return(salaries)
}

for_regression <- function() {
    df <- data.frame()
    for(season in seasons_included) {
        per_game <- for_regression_by_season(season)
        per_game$season <- season
        if(length(df) == 0) {
            df <- per_game
        } else {
            df <- rbind(df, per_game)
        }
    }
    return(df)
}

for_regression_by_season <- function(season) {
    per_game <- bref_season(season) 
    salaries <- salaries_by_season(season)
    # Remove instances where players received multiple contracts
    # With the max salary they received that season
    without_dup <- salaries[!(salaries$player %in% salaries[duplicated(
        salaries$player), "player"]),]
    # For each duplicated row: find the one with the max salary 
    dup <- unique(salaries[duplicated(salaries$player),"player"])
    for(player in dup) {
        max_salary <- max(salaries[salaries$player == player,"amount"])
        max_row <- salaries[salaries$player == player & salaries$amount == max_salary,]
        without_dup <- rbind(without_dup, max_row)
    }
    with_salaries <- merge(per_game, without_dup[,c("player", "amount")]
        , by.x="Player", by.y="player", all.x=T, all.y=F)
}

# Returns a dataset from Basketball Reference
# for a particular season
bref_season <- function(season, type='per_game') {
    if(!(season %in% seasons_included) | !(type %in% types_included)) {
        return(NULL)
    }
    file <- paste(c('./data/',season,'/',type,'.csv'), collapse='')
    data <- read.csv(file)
    return(remove_duplicates(data))
}

# Removes split rows for players who played for multiple teams in the season
remove_duplicates <- function(data) {
    movers <- data[data$Tm == 'TOT', 'Player'] 
    return(data[!(data$Player %in% movers) | (data$Tm == 'TOT'),])
}

# Returns salary data for a given season
salaries_by_season <- function(season) {
    if(!(season %in% seasons_included)) {
        return(NULL)
    }
    salaries <- read.csv('./data/salaries.csv')
    salaries$amount <- gsub('\\$', '', salaries$amount)
    salaries$amount <- gsub(',', '', salaries$amount)
    salaries$amount <- as.integer(salaries$amount)
    salaries$season <- gsub('^(19|20)', '', salaries$season)
    return(salaries[salaries$season == season,])
}
