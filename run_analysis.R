# R script for the Getting & Cleaning Data course in JHU Data Science coursera
#

# The zipped data file was downloaded on 12/10/2014 from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# unzipped files were put under the folder "./UCI HAR Dataset"

# use the dataset subdirectory or the current working directory (required in the assignment)
#
path <- "./UCI HAR Dataset"
if (!file.exists(path)) path <- "."

# load the data table into R using read.table()
#

activity_labels <- read.table(paste(path, "activity_labels.txt", sep="/"))
features <- read.table(paste(path, "features.txt", sep="/"), sep=" ", stringsAsFactors=T)

X_train <- read.table(paste(path, "train/X_train.txt", sep="/"))
y_train <- read.table(paste(path, "train/y_train.txt", sep="/"))
subject_train <- read.table(paste(path, "train/subject_train.txt", sep="/"))

X_test <- read.table(paste(path, "test/X_test.txt", sep="/"))
y_test <- read.table(paste(path, "test/y_test.txt", sep="/"))
subject_test <- read.table(paste(path, "test/subject_test.txt", sep="/"))

# RStudio Data window displays the dimension of all the data frames, which is as expected
#
# There are 7352 obs. in the training set and 2947 obs. in the testing set
#
# Now, merge the training and testing sets together by simply concatenating the 
# two sets using rbind

dataX <- rbind(X_train, X_test)
dataY <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)$V1

# to select the mean and std columns, find all the features containing "-mean()" or "-std()",
# ignoring cases using the substring match function grepl() to get a logical vector 
# for subsetting the features
#
# Now we can subset the required features 
#
f_meanStd <- features[grepl("-mean\\(\\)|-std\\(\\)", features$V2, ignore.case=T), ]

# exam the features in f_meanStd, we noticed that some column names contain "BodyBody" which
# are not included in the cookbook and probably by mistake, thus are removed
#
f_index <- f_meanStd[!grepl("BodyBody", f_meanStd$V2), ]

# Now, we can use the f_index to subset the data set as
#
X <- dataX[, f_index$V1]

# To label the data set with descriptive variable names
# gsub is used to get rid of "()" in the labels since they're useless and troublesome,
# furthermore, prefix "avg-" is added to feature names to indicate that it's average value
#
g <- function(s){ paste("avg", gsub("()","",s,fixed=T), sep="-") }
names(X) <- sapply(features[f_index$V1, ]$V2, g)

# To use the activity_labels to name the activities in the data set, 
# we can get the activity label for each measurement as
#
activity <- activity_labels[dataY$V1, 2]

# Finally, combine the data set and corresponding activity labels into one data set
#
data <- cbind(subject, activity, X)

# Use group_by and summarise_each in dplyr package to compute the mean of each group
#
library(dplyr)
avgData <- summarise_each(group_by(data, subject, activity), funs(mean))

# We may want to coerce it to a regular data frame
#
avgData <- as.data.frame(avgData)

# Finally write the new data set to a file named newDataSet.txt
#
write.table(avgData, file="newDataSet.txt", row.name=FALSE)
