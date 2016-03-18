####### Loading Libraries ######
library("httr")
library("jsonlite")
library("TMDb")

# set working directory
setwd("")


####### Retrieve Data from TMDb #######

API_KEY <- "7397adbca913d9c58cd42273c8269da2"
targetMovieID <- "tt0111161"			
# retrieve all movies
movies <- retrieveMovies()
movies2 <- data.frame(lapply(movies, as.character), stringsAsFactors=FALSE)  #coerce into dataframe
write.csv(movies2,file="movies1001-1100") # save for backup

# remove meaningless columns
keep1 <- data.frame(total[,5:11])
keep2 <- data.frame(total[,13:14])
keep3 <- data.frame(total[,16])
keep <- cbind(keep1,keep2,keep3)
write.csv(keep,file="MovieData.csv") # save for back up


####### Helper functions #######
retrieveMovies <- function(){
	movies = data.frame()
	for(i in 1:1000) {
		movies = rbind(movies, data.frame(discover_movie(API_KEY, page = i)))
	}
	return(movies)
}