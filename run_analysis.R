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

# to select the mean and std columns, first find all the features containing "mean" 
# ignoring cases using the substring match function grepl() to get a logical vector 
# for subsetting the features
#
features[grepl("Mean", features$V2, ignore.case=T),]

# this results 53 features containing mean, and after looking them over, it's clear that 
# the mean measurements have unique pattern "-mean()" or "-meanFreg()" in their labels. 
# And similiarly, "-std()" for the std measurements
#
# Now we can subset the required features 
#
f_mean <- features[grepl("-mean", features$V2, ignore.case=T), ]
f_std <- features[grepl("-std()", features$V2, ignore.case=T), ]

# Merge mean and std feature index to generate the indices for the required feature
#
f_index <- sort(c(f_mean$V1, f_std$V1))

# To double check we got the right indices, see the output of
#
features[f_index, ]

# Now, we can use the f_index to subset the data set as
#
X <- dataX[, f_index]

# To label the data set with descriptive variable names
# gsub is used to get rid of "()" in the labels since they're useless
#
names(X) <- sapply(features[f_index, ]$V2, function(s){gsub("()","",s,fixed=T)})

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
