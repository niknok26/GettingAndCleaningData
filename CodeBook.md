# Coursera: Data Science Specialization
## Getting and Cleaning Data Course Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

## Original Source Data (INPUT)
Original data is taken from the downloaded file [getdata-projectfiles-UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) containing the following folders and files:

* __UCI HAR Dataset (folder)__
    + activity_labels.txt: Contains the activity labels (i.e. "WALKING","STANDING",etc.)
    + features_info.txt: Description of features used
    + features.txt: Complete list of features (used as variable names for the dataset)
    + README.txt: Overview of how the data/activity came about
    + __test(folder)__ : Data for test subjects
        - __Intertial Signals(folder)__
            * body_acc_x_test.txt
            * body_acc_y_test.txt
            * body_acc_z_test.txt
            * body_gyro_x_test.txt
            * body_gyro_y_test.txt
            * body_gyro_z_test.txt
            * total_acc_x_test.txt
            * total_acc_y_test.txt
            * total_acc_z_test.txt
        - subject_test.txt: List of test subjects (used as a column for subjects)
        - X_test.txt: List of measures as listed in features.txt
        - y_test.txt: List of activities(numeric) and mapped to activity_labels.txt
    + __train(folder)__: Data for train subjects
        - __Intertial Signals(folder)__
            * body_acc_x_train.txt
            * body_acc_y_train.txt
            * body_acc_z_train.txt
            * body_gyro_x_train.txt
            * body_gyro_y_train.txt
            * body_gyro_z_train.txt
            * total_acc_x_train.txt
            * total_acc_y_train.txt
            * total_acc_z_train.txt
        - subject_train.txt: List of test subjects (used as a column for subjects)
        - X_train.txt: List of measures as listed in features.txt
        - y_train.txt: List of activities(numeric) and mapped to activity_labels.txt

## Script Flow _run_analysis.R_ (PROCESS)
1. The zipfile in the link above is downloaded to a working directory, where it is extracted.  The resulting directory structure should be identical to what is specified above.  The zipfile contains and maintains the directory structure.  Commands that rely on folders/files assume that the zip file was properly extracted.

2. Source files extracted in STEP 1 would need to be loaded into R objects for some tidying. There first two R objects would contain the activity labels and features.

~~~~
# Read in the features.  This will be used as variables
features <- read.table("./UCI HAR Dataset/features.txt",col.names=c("code","name"))
# Read in the activity labels. They will be used later as replacement to the numeric activity values
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("code","activity"))
~~~~
3. Tidy up the names from the _features.txt_.  The names will be used for the column names of the dataset, and there are characters that are either not allowed, or are not ideal for column names.  The following code strips/replaces certain characters for the character strings.

~~~~
# Tidy up the feature names to a more friendly  >> GOAL 4 <<
features$name <- gsub("\\(|\\)|,","",features$name)
features$name <- gsub("-|\\.","_",features$name)
~~~~

4. The third and main object will contain the result data set with all the tranformations indicated in the excercise.  The object features$name that was made tidy in the previous step will be used to define the column names of the data set. 

~~~~
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
~~~~
_Note: The files under the folder Intertial Signals need to be loaded as it is not necessary for this excercise_

5. As part of the excercise, the values of the "activity" attribute would need to be changed from a numeric code, to a more readable string.  The string values were loaded in STEP 2 to the _activityLables_ object.  The _mutate_ function call will be used to replace the numeric codes to string values.

~~~~
bigData <- bigData %>% 
            # Replace numeric activity values to proper labels
            # >> GOAL 3 <<
            mutate(activity = activityLabels[ bigData$activity,2 ]) %>%
            ...
            ...
~~~~

6. The activity will only be concerned with variables computing for the _mean_ or _std_ of the measures.  Columns would need to be selected corresponing to these computations (retaining subject and activity).  This effectively reduces the variables of the data set.

~~~~
            ...
            ...
            # Take out columns that are not for mean() or std(), 
            # but retain the first two columns: subject (column 1) and activity (column 2).
            # Concatenate column 1 and 2 with the rest of the columns that satisfy the condition.
            # >> GOAL 2 <<
            select(c(1,2,2 + grep(".*[Mm][Ee][Aa][Nn].*|.*[Ss][Tt][Dd].*",features$name))) %>%
            ...
            ...
~~~~

7. The mean for the measures of the remaining columns are taken per subject, per activity.  This is achieved by the following piece of code.

~~~~
            ...
            ...
            # Group by subject and activity
            # Summarize to take the average(mean) based on grouping for all other variables
            # >> GOAL 5 <<
            group_by(subject,activity) %>%
            summarize_each(funs(mean))
~~~~

8. The final result data set is written to a CSV file, _tidy_output.csv_.

~~~~
# Write file to tidy_output.txt
write.csv(bigData,"./tidy_output.csv")
~~~~

## New Dataset for Further Analysis (OUTPUT)
The R workspace will contain the following objects after STEP 2 of the process above.

* __activityLabels__: _This object contains the labels do be used to replace the numeric activity values for the dataset_
    + _code_ : numeric code that will map(key) to the numeric values on the data set.
    + _activity_ : character string representation of the different activities

~~~~
    'data.frame':	6 obs. of  2 variables:
    $ code    : int  1 2 3 4 5 6
    $ activity: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1
~~~~

* __features__: _This object contains the features to be used as column/variable names for the data set.  This will eventually be replaced by more readable names by one of the processing steps._
    + _code_ : numeric code of the features (key)
    + _name_ : character string for each of the different kinds of measure for the subjects

~~~~
'data.frame':	561 obs. of  2 variables:
 $ code: int  1 2 3 4 5 6 7 8 9 10 ...
 $ name: chr  "tBodyAcc_mean_X" "tBodyAcc_mean_Y" "tBodyAcc_mean_Z" "tBodyAcc_std_X" ...
~~~~

* __bigData__: 

~~~~
Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	180 obs. of  88 variables:
 $ subject                          : int  1 1 1 1 1 1 2 2 2 2 ...
 $ activity                         : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ tBodyAcc_mean_X                  : num  0.222 0.261 0.279 0.277 0.289 ...
 $ tBodyAcc_mean_Y                  : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ tBodyAcc_mean_Z                  : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
 ...
 ...
~~~~

