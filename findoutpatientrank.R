## This function takes a hospital name (or part of one) and returns where the hospital ranks in those procedures.
## The rank is not done by state, as that data is not available. Thus it's a nationwide rank.
## If the hospital name is a partial name, it will return any hospital containing that partial name. The procedure name
## must be exact or you will get an error.
## Possible procedure names: gastrointestinal, eye, nervous system, musculoskeletal, skin, genitourinary, 
##                           cardiovascular, respiratory
findoutpatientrank <- function(hospital, procedure){
    ## Read the data
    data <- read.csv("Outpatient_Procedures.csv",colClasses = "character")
    # Check to make sure the hospital passed isn't NA/numeric()
    if(is.na(hospital) | is.numeric(hospital)){
        stop("Improper hospital datatype")
    }
    if(is.na(procedure) | is.numeric(hospital)){
        stop("Improper procedure datatype")
    }
    
    # Convert the hospital name given to all uppercase
    hospital <- toupper(hospital)
    check_hospital <- grep(hospital, data$Hospital.Name) # returns indices that the hospital exists in
    # if check_hospital is length 0, then the hospital isn't in the database
    
    if(length(check_hospital)==0){ # If the hospital name isn't in the data set, it's invalid
        stop("Hospital Not Available")
    }
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
    
    ## Sort the first column in alphabetical order
    # Note that this has to be done because when sorting the second column in ascending order, it
    # goes through from beginning to end.. so when there are ties in the second column I need them
    # to be in alphabetical order and this is the only way to do that.
    sortind_alph <- sort(data$Hospital.Name, index.return=TRUE)$ix
    data <- data[sortind_alph,]
    
    ## Sort the second column in decreasing order, as the most procedures ranks first
    sortind_mor <- sort(data[,2], decreasing = TRUE, na.last = TRUE, index.return=TRUE)$ix
    data <- data[sortind_mor,]
    
    ## Now our data is ranked in ascending order, so now we just have to find out what rank our
    ## specific hospital has and we're good to go!
    rank <- grep(hospital, data$Hospital.Name) # Grab the rank (really the placements)
    
    # Grab the hospital name
    name <- data[rank,]$Hospital.Name
    bound_data <- cbind(name, rank)
    
    ## Now put the data in a dataframe
    framed_data<-data.frame(bound_data)
    colnames(framed_data) <- c("Hospital Name", "Rank")
    framed_data
}