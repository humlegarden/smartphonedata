---
title: "README"
author: "Me"
date: "1/19/2021"
output: html_document
---



## 1. Introduction

## 2. Data cleaning process

## 3. script: run_analysis.R

=============================================


### 1. Introduction

The original accelerometer dataset can be downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The data consist of 7352 records in the training set and 2947 records in the test set. Each record is associated with an id number for the volunteer (subject) which produced the record, and a second id number for the activity the subject was performing (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING). Each record consists of 561 features (normalized time and frequency domain variables, processed from raw accelerometer and gyroscope data).

For further details see below:


```
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
```


### 2. Data cleaning process

Test and training data were read into the following objects:
activities_test, activities_train       (activity id for each record)
subject_test, subject_train             (subject id for each record)
featuredata_test, featuredata_train     (561 data points for each record
                                        representing each feature)

The test and training data were combined into objects activities,
subject, and featuredata, and column labels were attached (with the columns
for featuredata drawn from the file "features.txt")

activities, subject, and featuredata were combined into one data frame called
alldata. (10299 x 563)

The activities column, subject column, and all feature columns referring to mean or std were extracted into data frame alldata_mean_std.

The activity id's were converted into descriptive words ("WALKING", "WALKING_UPSTAIRS", etc).

The 561 features were converted into values of an attribute called "feature", resulting in a 813621 x 4 data frame.

Finally, the data were grouped first by subject, then by activity, then by feature, and a new data frame summary_avg (14220 x 4) was produced by taking the mean of each subject-activity-feature group.


### 3. script: run_analysis.R


```
Warning in readLines("run_analysis.R"): incomplete final line found on
'run_analysis.R'
```

```
## Script to tidy data from the study
## "Human Activity Recognition Using Smartphones Dataset"
## for submission as the Course Project

library(tidyr)
library(dplyr)

activity_labels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                     "SITTING", "STANDING", "LAYING")

## Read data files from directory; UCI-HAR-Dataset files should
## be located in the working directory
activities_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
featuredata_test <- read.table("./test/X_test.txt")
activities_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
featuredata_train <- read.table("./train/X_train.txt")

feature_labels <- read.table("./features.txt", stringsAsFactors = FALSE)

# Merge training and test data into one data set;
# label the data set with descriptive variable names
activity <- rbind(activities_train, activities_test)
subject <- rbind(subject_train, subject_test)
featuredata <- rbind(featuredata_train, featuredata_test)

# Label each component of the data set with descriptive variable names
# and combine the components into one data frame
colnames(activity) <- "activity"
colnames(subject) <- "subject"
colnames(featuredata) <- feature_labels$V2
alldata <- cbind(subject, activity, featuredata)

# Search feature (column) labels for those containing "mean" or "std"
meanstd_i <- grep("[Mm]ean|[Ss]td", colnames(alldata))

# select: Extract features referencing means and standard deviations
# mutate: Use descriptive activity names to name the activities 
alldata_mean_std <- alldata %>%
               select(subject, activity, all_of(meanstd_i)) %>%
               mutate(activity=activity_labels[activity])

# Tidy the data by making feature labels into
# values of variable name "feature",
# returning a data frame with only four columns:
# subject, activity, feature, and value
alldata_mean_std <- pivot_longer(alldata_mean_std, 3:ncol(alldata_mean_std),
                                 names_to = "feature")

# Group data by subject, activity, and feature in order to
# create independent tidy data set with average of each variable
# for each activity and each subject
grouped_data <- group_by(alldata_mean_std, subject, activity, feature)
summary_avg <- summarize(grouped_data, mean=mean(value))
write.table(summary_avg, file="finaldata", row.names=FALSE)
```

The script creates a new data frame with the average of each variable for each 
activity and each subject, and writes it to a file called "finaldata".




