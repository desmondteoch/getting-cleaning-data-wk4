## clean accelerometer data from Galaxy SII
# set wd
setwd("C:/Users/desmo/OneDrive/HSA/Coursera/R")
library(dplyr)

# read train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read data description
var_names <- read.table("./UCI HAR Dataset/features.txt")

# read activity labels
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# merge train and test data
X_merge <- rbind(X_train, X_test)
Y_merge <- rbind(Y_train, Y_test)
sub_merge <- rbind(sub_train, sub_test)

# extract mean and sd
select_var <- var_names[grep("mean\\(\\)|std\\(\\)", var_names[,2]),]
X_merge <- X_merge[,select_var[,1]]

# add in Y data description
colnames(Y_merge) <- "activity"
Y_merge$activitylabel <- factor(Y_merge$activity, labels = as.character(act_labels[,2]))
activitylabel <- Y_merge[,-1]

# match X dataset to data description
colnames(X_merge) <- var_names[select_var[,1],2]

# create independent tidy dataset with average value of each var per activity per subject
colnames(sub_merge) <- "subject"
total <- cbind(X_merge, activitylabel, sub_merge)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)


## end