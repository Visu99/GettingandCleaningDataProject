# Author: Vish Yella
# Date  : 11/21/2015
# Description:   Prepares tidy data and writes to a file from raw data collected from the accelerometers from the Samsung Galaxy S smartphone.
# Pre-requisites:  
#       Required Libaries:  this script uses functions from below packages.  Please install these before running this script:
#               library(dplyr)
#               library(stringr)
#               library(ddply)
#               library(plyr)

#       Required Data: 
#               The data for this script should be obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#               The "getdata-projectfiles-UCI HAR Dataset.zip" must be downloaded and extracted to the folder where this script is located
#               'UCI HAR Dataset' folder should be present in current working directory


run_analysis <-function() {

        #Load all files from current directory
        features<-fread("./UCI HAR Dataset/features.txt")
        
        x_testDF      <- fread("UCI HAR Dataset/test/X_test.txt")
        subject_testDF<- fread("UCI HAR Dataset/test/subject_test.txt")
        y_testDF      <- fread("UCI HAR Dataset/test/y_test.txt")
        
        x_trainDF      <- fread("UCI HAR Dataset/train/X_train.txt")
        subject_trainDF<- fread("UCI HAR Dataset/train/subject_train.txt")
        y_trainDF      <- fread("UCI HAR Dataset/train/y_train.txt")


        #Load raw data into data frames
        
        # Step 1 and 2
        
        #Load TEST data set
        featuresVector<-features$V2
        colnames(x_testDF)<-featuresVector
        colnames(subject_testDF) <- c("person")
        colnames(y_testDF)       <- c("activity")
        #extract only the columns containing mean() and std() 
        selectTestDF      <-select(x_testDF, contains("mean()"), contains("std()"))
        testSummary       <-cbind(subject_testDF, y_testDF, selectTestDF )
        
        #Load TRAIN data set
        colnames(x_trainDF)<-featuresVector
        colnames(subject_trainDF) <- c("person")
        colnames(y_trainDF)       <- c("activity")
        #extract only the columns containing mean() and std() 
        selectTrainDF    <-select(x_trainDF, contains("mean()"), contains("std()"))
        trainSummary     <-cbind(subject_trainDF, y_trainDF, selectTrainDF)

        
        #Combine the test and train data sets 
        combinedDF <- rbind(testSummary, trainSummary)

        #load the activity descriptions from activity_labels.txt file
        activityLabels<-fread("./UCI HAR Dataset/activity_labels.txt")
        colnames(activityLabels) <- c("activity","description")
        
        #Give descriptive names to all variables using lookups from activity_labels file
        refinedDF <- merge(activityLabels, combinedDF,  by="activity")
        
        #order and sort the refinedDF
        orderedDF <- group_by(refinedDF, refinedDF$person, refinedDF$description)
        sortedDF  <- orderedDF[order(refinedDF$description, refinedDF$person),]
        
        #create a character vector of features using column names
        #from the previous selectedTestDF data frame
        measures<-colnames(selectTestDF)
        
        # Step 3
        #convert the feature names into variable names using melt function
        tallDF  <- melt(sortedDF, id=c("activity", "description", "person"), measure.vars = measures)

        # Step 4 - give descriptive names
        
        #rename the activity variable to a readable lower case
        tallDF <- mutate(tallDF, activityDescription = tolower(description) )
        #create a new variable for the person variable to a descriptive name"
        tallDF <- mutate(tallDF, personID = paste("person", str_trim(person) , sep="") )  
        #rename variable to a more descriptive one
        tallDF <- rename(tallDF, c("variable"="measuredVariable"))
        
        
        
        
        
        #Step 5 - calculate mean
                
        #calculate the mean for each activity-person-variable combination
        finalDF <- ddply(tallDF, c("activity","activityDescription","person", "personID", "measuredVariable" ), summarise, mean = mean(value) )
 
        #rename mean variable to a more descriptive one
        finalDF <- rename(finalDF, c("mean"="meanOfObservations"))
        
        finalDF  <- finalDF[order(finalDF$activityDescription, finalDF$person),]
        
        #extract only required ones in logical order
        finalDF<-finalDF[, c("activityDescription", "personID","measuredVariable", "meanOfObservations")]
        
        
        
        #write the summary to a flat file (separated by tabs for better readability)
        write.table(finalDF, file="tidyData.txt", sep ="\t", row.names =  FALSE)

}

