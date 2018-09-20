## This function takes the name of a hospital (or partial name) and a procedure name and outputs the number of procedures
## That hospital has done. If multiple hospitals have the partial name, it will return any hospital containing that name.
outpatientprocedures <- function(hospital, procedure){
    ## Read the data
    data <- read.csv("Outpatient_Procedures.csv",colClasses = "character")
    
    ## Check to make sure the hospital given is in our database and grab indices
    hospital <- toupper(hospital)
    check_hospital <- grep(hospital, data$Hospital.Name) 
    
    ## Check to make sure the hospital were valid
    if(length(check_hospital)==0){ 
        stop("Hospital Not Available")
    }
    if (!(procedure %in% c("gastrointestinal","eye","nervous system", "musculoskeletal", "skin", 
                           "genitourinary", "cardiovascular", "respiratory"))){
        stop("Procedure Not Available")
    }
    
    ## Remove excess data and just keep the procedure necessary
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
    
    framed_data <- data.frame(data[check_hospital,])
    colnames(framed_data) <- c("Hospital Name","Number of Procedures")
    framed_data
    
}