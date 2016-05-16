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

# Load R Lifbraries
require(dplyr)


## Read the different source files
# Read in the features.  This will be used as variables
features <- read.table("./UCI HAR Dataset/features.txt",col.names=c("code","name"))
# Read in the activity labels. They will be used later as replacement to the numeric activity values
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("code","activity"))

#test.InertialSignals.body_acc_x_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
#test.InertialSignals.body_acc_y_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
#test.InertialSignals.body_acc_z_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
#test.InertialSignals.body_gyro_x_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
#test.InertialSignals.body_gyro_y_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
#test.InertialSignals.body_gyro_z_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")
#test.InertialSignals.total_acc_x_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
#test.InertialSignals.total_acc_y_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
#test.InertialSignals.total_acc_z_test.txt <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")

#train.InertialSignals.body_acc_x_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
#train.InertialSignals.body_acc_y_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
#train.InertialSignals.body_acc_z_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
#train.InertialSignals.body_gyro_x_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
#train.InertialSignals.body_gyro_y_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
#train.InertialSignals.body_gyro_z_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
#train.InertialSignals.total_acc_x_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
#train.InertialSignals.total_acc_y_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
#train.InertialSignals.total_acc_z_train.txt <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")

# Load Test Data
# Version 1, reading into individual objects
#testSubject <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt",col.names=c("subject")))
#testX <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))
#testY <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("y"), colClasses = c("numeric")))
#bigTest <- tbl_df(cbind(source ="test", subject=testSubject, X=testX, Y=testY))

# Version 2, reading into 1 big object for test
#bigTest <-tbl_df( cbind(
#                        source="test",
#                        read.table("./UCI HAR Dataset/test/subject_test.txt",col.names=c("subject")),
#                        read.table("./UCI HAR Dataset/test/y_test.txt",col.names = c("activity")),
#                        read.table("./UCI HAR Dataset/test/X_test.txt",col.names=as.character(features$name))
#                      )
#                )

# Load Train Data
# Version 1, reading into individual objects
#trainSubject <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt",col.names=c("subject")))
#trainX <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))
#trainY <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("y"), colClasses = c("numeric")))
#bigTrain <- tbl_df(cbind(source ="train", subject=trainSubject, X=trainX, Y=trainY))

# Version 2, reading into 1 big object for train
#bigTrain <-tbl_df( cbind(
#                        source="train",
#                        read.table("./UCI HAR Dataset/train/subject_train.txt",col.names=c("subject")),
#                        read.table("./UCI HAR Dataset/train/y_train.txt",col.names = c("activity")),
#                        read.table("./UCI HAR Dataset/train/X_train.txt",col.names=as.character(features$name))
#                      )
#                )

# Combine Data
# Version 2, bind two big test and train objects
#bigData <- rbind(bigTest,bigTrain)

#Version 3, load everything in one object in one go #  >> GOAL 1 <<
bigData <- tbl_df( 
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
          )

bigData <- bigData %>% 
            # Replace numeric activity values to proper labels
            # >> GOAL 3 <<
            mutate(activity = activityLabels[ bigData$activity,2 ]) %>%
            # Take out columns that are not for mean() or std(), 
            # but retain the first two columns: subject (column 1) and activity (column 2).
            # Concatenate column 1 and 2 with the rest of the columns that satisfy the condition.
            # >> GOAL 2 <<
            select(c(1,2,2 + grep(".*mean\\(\\).*|.*std\\(\\).*",features$name)))
            
bigData <-  bigData %>%
            # Group by subject and activity
            # Summarize to take the average(mean) based on grouping for all other variables
            # >> GOAL 5 <<
            group_by(subject,activity) %>%
            summarize_each(funs(mean))
