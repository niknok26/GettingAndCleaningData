##
##   Coursera 
##   Data Science
##   Getting and Cleaning Data Course Project
##   Programming Assignment run_analysis.R
##   Dennis Magsajo

## The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal 
## is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no 
## questions related to the project. 
## 
## You will be required to submit: 
## 1) a tidy data set as described below, 
## 2) a link to a Github repository with your script for performing the analysis, and 
## 3) a code book that describes the variables, the data, and any transformations or work that you performed
## to clean up the data called CodeBook.md. 
## 
## You should also include a README.md in the repo with your scripts.
## This repo explains how all of the scripts work and how they are connected.
##
## GOALS of the script
#  1. Merges the training and the test sets to create one data set.
#  2. Extracts only the measurements on the mean and standard deviation for each measurement.
#  3. Uses descriptive activity names to name the activities in the data set
#  4. Appropriately labels the data set with descriptive variable names.
#  5. From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.

# Load R Libraries
require(dplyr)


## Read the different source files
# Read in the features.  This will be used as variables
features <- read.table("./UCI HAR Dataset/features.txt",col.names=c("code","name"))
# Read in the activity labels. They will be used later as replacement to the numeric activity values
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("code","activity"))

# Tidy up the feature names to a more friendly  >> GOAL 4 <<
features$name <- gsub("\\(|\\)|,","",features$name)
features$name <- gsub("-|\\.","_",features$name)
features$name <- gsub("^t","time_",features$name)
features$name <- gsub("^f","FFT_",features$name)
features$name <- gsub("BodyBody","Body",features$name)
features$name <- gsub("^angle","angle_",features$name)


# Load everything in one object in one go #  >> GOAL 1 <<
bigData <-  
          # Combine the rows of the two data sets read below into one big data set
          rbind(
              # Combine the 3 files read into columns
              cbind(
                # Read data from test
                #source="test",
                read.table("./UCI HAR Dataset/test/subject_test.txt",col.names=c("subject")),
                read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("activity")),
                read.table("./UCI HAR Dataset/test/X_test.txt",col.names=as.character(features$name))
              ),
              # Combine the 3 files read into columns
              cbind(
                # Read data from train
                #source="train",
                read.table("./UCI HAR Dataset/train/subject_train.txt",col.names=c("subject")),
                read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("activity")),
                read.table("./UCI HAR Dataset/train/X_train.txt",col.names=as.character(features$name))
              )
            )

bigData <- bigData %>% 
            # Replace numeric activity values to proper labels
            # >> GOAL 3 <<
            mutate(activity = activityLabels[ bigData$activity,2 ]) %>%
            
            # Take out columns that are not for mean() or std() or meanFreq(), 
            # but retain the first two columns: subject (column 1) and activity (column 2).
            # Concatenate column 1 and 2 with the rest of the columns that satisfy the condition.
            # >> GOAL 2 <<
            select(c(1,2,2 + grep(".*[Mm][Ee][Aa][Nn].*|.*[Ss][Tt][Dd].*",features$name))) %>%
            
            # Group by subject and activity
            # Summarize to take the average(mean) based on grouping for all other variables
            # >> GOAL 5 <<
            group_by(subject,activity) %>%
            summarize_each(funs(mean))

# Write file to tidy_output.txt
write.csv(bigData,"./tidy_output.csv")
