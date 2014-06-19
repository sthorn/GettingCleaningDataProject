# Getting and Cleaning Data course project

## run\_analysis.R

The file run\_analysis.R performs the following steps:

* Read features (variable names) from features.txt
  * Extract the number of features
  * Extract features whose names match mean() or std() with R's grepl()
* Create a vector of 'classes' to be used with read.table's colClasses argument, which reads in only the mean() and std() columns  
* Read test and training datasets
  * Set data.frame's column names to those extracted from features.txt
  * Read activity codes and activity names from file
  * Create factor of activity names
  * Add column for these activities to data.frame with cbind()
  * Read subject codes from file and add column to data.frame with cbind()
* Merge test and training datasets with rbind
* Print warning if any NA values are found
* Write data.frame to cleandata.txt
* Create new data.frame with the average of each variable for each subject and activity 
  * Use reshape2's melt() and dcast() functions  
