#'

#' Demonstrates sampling from a population and calculating the mean if the sample has more than 30 unique values.

#' Errors are captured during repeated sampling.

doit <- function(x) {
    temp_x <- sample(x, replace = TRUE)
    if(length(unique(temp_x)) > 30) {#only take mean if sample was sufficient
         print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        } 
    else {
        stop("Couldn't calculate mean: too few unique values!")
        }
    }

set.seed(1345) # again, to get the same result for illustration

popn <- rnorm(50)

hist(popn)

result <- lapply(1:15, function(i) try(doit(popn), FALSE))