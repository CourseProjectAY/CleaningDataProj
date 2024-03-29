# the 'run_analysis.R' script does the following:

# 1) Merges the training and the test sets to create one data set.

make_subject_data <- function() {
    subject_test_data <- read.table('./UCI HAR Dataset/test/subject_test.txt')
    subject_train_data <- read.table('./UCI HAR Dataset/train/subject_train.txt')
    subject_merged_data <- rbind(subject_train_data, subject_test_data)
    names(subject_merged_data) <- "subject"
    subject_merged_data
}

make_X_data <- function() {
    X_test_data <- read.table('./UCI HAR Dataset/test/X_test.txt')
    X_train_data <- read.table('./UCI HAR Dataset/train/X_train.txt')
    X_merged_data  <- rbind(X_train_data, X_test_data)
}

make_y_data <- function() {
    y_test_data <- read.table('./UCI HAR Dataset/test/y_test.txt')
    y_train_data <- read.table('./UCI HAR Dataset/train/y_train.txt')
    y_merged_data  <- rbind(y_train_data, y_test_data)
}

subject_dataset <- make_subject_data()
X_dataset <- make_X_data()
y_dataset <- make_y_data()

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

get_selected_measurements <- function() {
    features <- read.table('./UCI HAR Dataset/features.txt', header=FALSE, col.names=c('id', 'name'))
    feature_selected_columns <- grep('mean\\(\\)|std\\(\\)', features$name)
    filtered_dataset <- X_dataset[, feature_selected_columns]
    names(filtered_dataset) <- features[features$id %in% feature_selected_columns, 2]
    filtered_dataset
}

X_filtered_dataset <- get_selected_measurements()

# 3) Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header=FALSE, col.names=c('id', 'name'))


# 4) Appropriately labels the data set with descriptive activity names. 

y_dataset[, 1] = activity_labels[y_dataset[, 1], 2]
names(y_dataset) <- "activity"


# 5.1) Creates an intermediate dataset with all required measurements.

whole_dataset <- cbind(subject_dataset, y_dataset, X_filtered_dataset)
write.csv(whole_dataset, "./output/whole_dataset_with_descriptive_activity_names.csv")


# 5.2) Creates the final, independent tidy data set with the average of each variable for each activity and each subject.

measurements <- whole_dataset[, 3:dim(whole_dataset)[2]]
tidy_dataset <- aggregate(measurements, list(whole_dataset$subject, whole_dataset$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.csv(tidy_dataset, "./output/final_tidy_dataset.csv")
write.table(tidy_dataset, "./output/final_tidy_dataset.txt")
