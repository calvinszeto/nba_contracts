seasons_included <- c('03-04','04-05','05-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13')
types_included <- c('per_game', 'per_minute', 'totals')

# Returns a dataset from Basketball Reference (http://www.basketball-reference.com)
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
