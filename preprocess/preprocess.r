seasons_included <- c('03-04','04-05','05-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13')

totals <- function(season) {
    if(!(season %in% seasons_included)) {
        return(NULL)
    }
    file <- paste(c('./data/',season,'/totals.csv'), collapse='')
    totals <- read.csv(file)
    return(remove_duplicates(totals))
}

per_game <- function(season) {
    return(NULL)
}

per_minute <- function(season) {
    return(NULL)
}

remove_duplicates <- function(data) {
    movers <- data[data$Tm == 'TOT', 'Player'] 
    return(data[!(data$Player %in% movers) | (data$Tm == 'TOT'),])
}
