
##
## Run to produce a tidy dataset based on data collected from
## the accelerometers from the Samsung Galaxy S smartphone
##


##################################################################
## Merges the training and the test sets to create one data set ##
##################################################################

## Import data files

# subjects
subject_train <- read.table("train/subject_train.txt", header = F)
subject_test <- read.table("test/subject_test.txt", header = F)

# features
X_train <- read.table("train/X_train.txt", header = F, sep = "")
X_test <- read.table("test/X_test.txt", header = F, sep = "")

# labels
y_train <- read.table("train/y_train.txt", header = F)
y_test <- read.table("test/y_test.txt", header = F)


## Merge the subjects files
subjects <- rbind(subject_train, subject_test)
names(subjects) <- "subject_ID"

## Merge the features files
X <- rbind(X_train, X_test)

## Create global dataset
dataset <- cbind(subjects, X)


############################################################################################
## Extracts only the measurements on the mean and standard deviation for each measurement ##
############################################################################################

## Import feature names
features <- read.table("features.txt", stringsAsFactors = F)
names(features) <- c("num", "name")

## Add feature names to the global dataset
names(dataset)[-1] <- features$name

## keep mean and std for each measurement

# identify columns to keep
keep <- c(1, which(grepl("\\-mean\\(\\)|\\-std\\(\\)", names(dataset))))

# update global dataset
dataset <- dataset[, keep]


############################################################################
## Uses descriptive activity names to name the activities in the data set ##
############################################################################

## Import activity labels
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = F)
names(activity_labels) <- c("activity_id", "activity_label")

## Merge train and test labels
y <- rbind(y_train, y_test)
names(y) <- "activity_id"

y <- merge(y, activity_labels, by = "activity_id", sort = FALSE)


#######################################################################
## Appropriately labels the data set with descriptive activity names ##
#######################################################################

dataset <- cbind(dataset, y)

write.table(dataset, "tidy_dataset.txt", row.names = FALSE)


######################################################################
## Creates a second, independent tidy data set with the average of  ##
## each variable for each activity and each subject                 ##
######################################################################

n <- ncol(dataset)

ave_dataset <- aggregate(dataset[, -c(1, n-1, n)],
                         by = list(subject_ID = dataset$subject_ID, activity = dataset$activity_label),
                         mean)

write.table(ave_dataset, "ave_tidy_dataset.txt", row.names = FALSE)

