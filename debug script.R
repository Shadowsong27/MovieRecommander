# ambigous date format
dateVector <- c()
for (i in 1:20000) {
	tryCatch({
		as.POSIXct(data[i,]$results.release_date)
	}, error = function(e) {
		print(i)
	})
}


problematicDate <- c(5905,6347,6911,8171,9102,10167,10339,13189,14960,15600,16514,17161,17600,17602,18371,18692,18782,18874,19012,19206,19209,19219,19220,19222,19224,19226,19355,19653,19674,19990)
