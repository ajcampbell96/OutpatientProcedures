outpatientrank <- function(procedure, num){
    ## Read the data
    data <- read.csv("Outpatient_Procedures.csv",colClasses = "character")
    
    # Check to make sure procedure exists
    if (!(procedure %in% c("gastrointestinal","eye","nervous system", "musculoskeletal", "skin", 
                           "genitourinary", "cardiovascular", "respiratory"))){
        stop("Procedure Not Available")
    }
    # Switch to grab the appropriate data. The switch takes the variable, procedure, and looks through the following
    # cases to see if they match. It finds the one that matches and does the stuff to the right of the '='.
    # This way I can just use the variable 'data' after the switch regardless of what procedure was passed in
    switch(procedure,
           "gastrointestinal" = data <- data[,c(2,4)],
           "eye" = data <- data[,c(2,5)],
           "nervous system" = data <- data[,c(2,6)],
           "musculoskeletal" = data <- data[,c(2,7)],
           "skin" = data <- data[,c(2,8)],
           "genitourinary" = data <- data[,c(2,9)],
           "cardiovascular" = data <- data[,c(2,10)],
           "respiratory" = data <- data[,c(2,11)]
    )
    # Convert the second column (mortalities) to numeric characters for sorting
    data[,2] <- suppressWarnings(as.numeric(data[,2]))
    
    # First we have to sort data in alphabetical order
    sortind_alp <- sort(data$Hospital.Name, index.return=TRUE)$ix
    data <- data[sortind_alp,]
    # Now that it's in alphabetical order, we can sort it by mortality
    sortind_mor <- sort(data[,2], decreasing=TRUE, na.last = TRUE, index.return=TRUE)$ix # sort mortality rates from lowest to greatest
    data <- data[sortind_mor,] # sort it according to the index
    
    # Now we will do the "best" and "worst" case
    if (num == "best"){
        return.name <- data$Hospital.Name[1] # Return the first name
    }
    else if (num == "worst"){
        return.name <- data$Hospital.Name[length(data$Hospital.Name)] # Return the first name
    }
    # Now we do a numeric case
    else if (is.numeric(num) & num > 0 & num <= length(data$Hospital.Name)){
        return.name <- data$Hospital.Name[num]
    }
    else{
        return(NA)
    }
    return.name
}