#loading required library files
library(reshape2)

# read data into data frames
sub_train <- read.table("subject_train.txt")
sub_test <- read.table("subject_test.txt")
x_train <- read.table("X_train.txt")
x_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")
features <- read.table("features.txt")

# add column name for subject, measurement and lable files
names(sub_train) <- "subjID"
names(sub_test) <- "subjID"
names(x_train) <- features$V2
names(x_test) <- features$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# merging files into one dataset
train <- cbind(sub_train, y_train, x_train) # column binding train dataset with new variable train
test <- cbind(sub_test, y_test, x_test) # column binding test dataset with new variable test
merged <- rbind(train, test) # merging all dataset and creating new dataset called merged.


# Extracting only the column related to the mean and standard deviation.
# separating column containing word mean and std.

locate_mean_sd <- grepl("mean\\(\\)", names(merged)) |
  grepl("std\\(\\)", names(merged))
locate_mean_sd[1:2] <- TRUE # keeping first two column as well.
merged <- merged[, locate_mean_sd] # selecting only required column previous merged datasets.

# naming descriptive activity in dataset and appropriately labelling it.
# converting the activity column from integer to factor
merged$activity <- factor(merged$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# create the tidy data set
tidy <- merged %>%
  melt(id=c("subjID","activity")) %>% 
  dcast(subjID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)
