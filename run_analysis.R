##
## Clean UCI Human Activity Recognition Using Smartphones Data Set 
##

# Read variable names from features.txt - 2nd column contains variable names
features <- read.table('features.txt')
# Extract number of features
nfeatures <- dim(features)[1]

# Select elements where the feature matches 'mean()' or 'std()'
selection <- grepl("(mean|std)\\(", features$V2)
features <- features$V2[selection]

# Create vector of classes to select only the mean and standard deviation fields when reading in the main data
# If classes == 'numeric' the column will be read, if == 'NULL' column will be ignored 
classes <- rep('NULL', nfeatures)   # start with all NULL
# Select elements where the associated feature matches 'mean()' or 'std()' and set those to 'numeric'
classes[ selection ] <- 'numeric' 

# Function to read one set of data (the dataset as a whole contains a test and train part that are merged)
clean_data <- function( data_file, activity_file, subject_file) {
  # Read in dataset, selecting only columns matching 'classes' defined above and assign column names. 
  data <- read.table( data_file, colClasses=classes)
  names(data) <- features
  
  # Read in activity codes
  codes <- read.table( activity_file)
  # Read activity key
  key <- read.table('activity_labels.txt')
  # Create factor with activity codes replaced by names 
  activity <- factor( codes$V1, labels=key$V2)
  
  # Read subject codes
  subject <- read.table( subject_file, col.names='subject')

  # Add activity and subject columns to data.frame and return
  return( cbind( subject, activity, data))
}

# Process both test and training datasets and merge into one
test_data  <- clean_data( 'test/X_test.txt', 'test/y_test.txt', 'test/subject_test.txt')
train_data <- clean_data( 'train/X_train.txt', 'train/y_train.txt', 'train/subject_train.txt')
data <- rbind( test_data, train_data)

# Check for NA values. The given dataset has none, but if this code gets 
# rerun on e.g. future versions of the same dataset we would want to be warned
if(!all(colSums( is.na( data))==0)) { warning( 'Some values in cleaned data are NA')}

# Create data set with the average of each variable for each activity and each subject. 
library(reshape2)
data_melt <- melt( data, id=c('subject','activity'))
ave_data <- dcast( data_melt, subject + activity ~ variable, mean)

# Write data.frame
write.table( ave_data, 'cleandata.txt')

