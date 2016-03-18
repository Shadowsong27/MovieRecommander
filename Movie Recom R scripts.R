####### Main #######
main <- function() {

	library("httr")
	library("jsonlite")
	library("TMDb")

	setwd("~/Desktop/Interview")

	print("Welcome to Movie Recommender")

	# take in the API key
	targetMovieID <- readline(prompt="Please enter the IMDb ID: ") #tt0993846 The wolf of wallstreet
	API_KEY <- readline(prompt="Plase enter the API_KEY: ") # 7397adbca913d9c58cd42273c8269da2

	#targetMovieID <- "tt0993846"
	#API_KEY <- "7397adbca913d9c58cd42273c8269da2"
	# load the database and problematic date vector
	data <- read.csv("MovieData.csv")
	problematicDate <- c(5905,6347,6911,8171,9102,10167,10339,13189,14960,15600,16514,
						 17161,17600,17602,18371,18692,18782,18874,19012,19206,19209,
						 19219,19220,19222,19224,19226,19355,19653,19674,19990)
	

	# obtain the movie info
	targetMovie <- movie(api_key = API_KEY, targetMovieID)

	#######  initialise the user preference

	# date preference

	print("Recommendation Settings:")

	print("Do you enjoy a classic? Please key in a date and we will only recommend movies made after that")
	print("Enter 0 if no preference, the format should be YYYY-MM-DD")

	preferDate <- readline()

	preferredMovieData <- removeClassic(data, problematicDate, preferDate) # this will be used as the primary analysing data

	# vote count preference


	##### inquiry statement #####
	preferredMovieData <- preferredMovieData[preferredMovieData$results.vote_count >= 100,]


	###### Building Similarity Index ######

	preferredMovieData <- calculateSim(targetMovie,preferredMovieData,c(0.3,0.3,0.3))

	print(preferredMovieData)

	
}


calculateSim <- function(m,pre,user) {
		genre_weight <- user[1]
		popularity_weight <- user[2]
		language_weight <- user[3]


		collectionID <- m$belongs_to_collection
		genres <- m$genres$id
		overview <- m$overview
		vote_count <- m$vote_count
		company <- m$production_companies
		runtime <- m$runtime
		language <- m$original_language
		vote_average <- m$vote_average



		pre <- pre[,-c(1,3,6)] # remove uncessary info in prefered movie list
		pre$SI <- 0 # initialise a column
		pre <- calGenre(genres,pre,genre_weight)
		pre <- calPopularity(vote_count,pre,popularity_weight) # cal popularity using vote count
		pre <- calLanguage(language,pre,language_weight)
		# yet to implement similarity of overview
		# yet to implement similarity of runtime

	# after three filter retrieve the first 100 based on similarity

	order.SI <- order(pre$SI,decreasing=TRUE) # sort based on SI
	select <- order.SI[1:100] # select first 100
	pre <- pre[select,] # update prefered movie list

	# sort based on vote_average 

	order.average <- order(pre$total...16.,decreasing=TRUE)
	select <- order.average[1:10] # first ten good movies
	pre <- pre[select,]

	# add to a id list
	recommend_id <- pre$results.id
	recommend_name <- pre$results.title
	return(recommend_name)

}

##

calGenre <- function(genres,pre,weight) {
	no_of_genres <- length(genres)
	single_weight <- weight / no_of_genres # dividing weight
	no_of_rows <- nrow(pre)
	for (i in genres) {
		for (j in 1:no_of_rows) {
			if(grepl(as.character(i),as.character(pre[j,]$results.genre_ids))) {
				pre[j,]$SI <- pre[j,]$SI + single_weight
			}
		}
	}
	return(pre) # added genre similarity
}

calLanguage <- function(language,pre,weight) {
	no_of_rows <- nrow(pre)

	for (i in 1:no_of_rows) {
		#if (!is.na(pre[i,]$results.original_language)) {
			if(language == as.character(pre[i,]$results.original_language)) {
				pre[i,]$SI <- pre[i,]$SI + weight
			}
		#}
		
	}
	return(pre)
}


calPopularity <- function(popularity,pre,weight) {
	no_of_rows <- nrow(pre)
	MAX_VOTE <- max(pre$results.vote_count)
	for (i in 1:no_of_rows) {
		pre[i,]$SI <- pre[i,]$SI + weight * pre[i,]$results.vote_count / MAX_VOTE
	}
	return(pre) # added genre similarity
}

####### Data Pruning ########

# release date

removeClassic <- function(data,problematicDate,date) {
	if (date == 0) {
		return(data)
	} else {
		clean <- data[-problematicDate,] # remove the problematic Date
		return(clean[as.POSIXct(clean$results.release_date) > as.POSIXct(date),])
	}
}




