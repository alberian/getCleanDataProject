library(data.table)
library(plyr)
library(dplyr)
features <- read.table("features.txt")
col_lab <- grep("mean()|std()",features$V2, value = TRUE)
col_lab <- col_lab[!grepl("meanFreq()",col_lab)]

test <- read.table("test/X_test.txt")
colnames(test) <- features$V2
test_mean <- test[,col_lab]

test_lab <- read.table("test/y_test.txt")
names(test_lab) <- c("activity")
test_mean <- cbind(test_mean,test_lab)

test_sub <- read.table("test/subject_test.txt")
names(test_sub) <- c("subject")
test_mean <- cbind(test_mean,test_sub)


train <- read.table("train/X_train.txt")
colnames(train) <- features$V2
train_mean <- train[,col_lab]

train_lab <- read.table("train/y_train.txt")
names(train_lab) <- c("activity")
train_mean <- cbind(train_mean,train_lab)

train_sub <- read.table("train/subject_train.txt")
names(train_sub) <- c("subject")
train_mean <- cbind(train_mean,train_sub)


mrg <- rbind(train_mean,test_mean)


activity_lab <- read.table("activity_labels.txt")
colnames(activity_lab) <- c("activity","activity_label")
final <- merge(mrg, activity_lab, by = "activity")
final$activity <- NULL

summary <- final %>% group_by(subject,activity_label) %>% summarise_each(funs(mean))

write.table(final,"tidy.txt", row.names = FALSE)
write.table(summary, "tidy_summary.txt", row.names = FALSE)

