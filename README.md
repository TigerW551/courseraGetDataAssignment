courseraGetDataAssignment
=========================

The file run_analysis.R is R script file to create a tidy data set based on the data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

To run this script file, one should set the current working directory to the root directory of the unzipped files.
Then simply run source("run_analysis.R") in R. The script will generate a tidy data file named newDataSet.txt under the same directory, i.e., the current working directory.

This script results from the assignment of the Coursera course: Getting and Cleaning Data.

The codebook for the original data can be found in the README.txt file coming with the downloaded zip file. The new tidy data set newDataSet.txt contains only (averaged) subset of the original data. The procedure (i.e., codebook for the new data set) is as following:

*) Combine the training and testing data into one data set for the X, y, and subject data

*) Find the column indices of the feature names containing "-mean" and "-std()" using the features data. Note that some duplicated features are removed during this process.

*) Further removed features ending with "()" instead of X, Y, or Z

*) Then subset the data set to include only those identified columns

*) The new data set column names are set to the corresponding descriptive names in the original features (with "()" removed), and prefixed with "avg-"

*) The activity corresponding to each measurement is labeled with the descriptive labels as in the original activity_labels

*) The subject, activity, and the selected measurements are combined into a single data frame

*) All measurements from the same subject for the same activity are averaged, thus the prefix "avg-" mentioned above.
Note that the average won't change the unit of the features, which should be the same as in the original data.

*) The resulting tidy data set are saved to newDataSet.txt

More detailed notes can be found in the script run_analysis.R

*** Note that I don't feel I should revise the original README.txt. The description above make it clear what the new data set contains.
