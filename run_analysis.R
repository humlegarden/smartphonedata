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