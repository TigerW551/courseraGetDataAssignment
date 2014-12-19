courseraGetDataAssignment
=========================

The file run_analysis.R is R script file to create a tidy data set based on the data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

To run this script file, one should set the current working directory to the root directory of the unzipped files.
Then simply run source("run_analysis.R") in R. The script will generate a tidy data file named newDataSet.txt under the same directory, i.e. the current working directory.

This script results from the assignment of the Coursera course: Getting and Cleaning Data.

The codebook for original data can be found in the README.txt file coming with the downloaded zip file. The new tidy data set newDataSet.txt created by the run_analysis.R script only contains a subset of the original data. The procedure is as following:

*) Combine the training and testing into one data set for the X, y, and subject data
*) Find the column indices of the feature names containing "-mean" and "-std()" using the features data
*) Then subset the data set to including only the columns identified
*) The new data set column names sets to the corresponding descriptive features names (with "()" removed)
*) The activity corresponding to each measurement is labeled with the descriptive labels as in the original activity_labels
*) The subject, activity, and the selected measurements are combined into a single data frame
*) All measurements from the same subject for the same activity are averaged (note that, the feature labels are not modified with "avg" etc.)
