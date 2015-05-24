

# setwd("C:/Users/romualdo/Documents/Romu/personal/desarrolloprof/Data Scientist/Coursera/03-Getting and Cleaning Data/course project")


library(dplyr)
library(stringr)


rm(list=ls())



### Read all   files 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt" )
features <- read.table("UCI HAR Dataset/features.txt" ,  na.strings="?")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt" ,  na.strings="?")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt" ,  na.strings="?")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt" )


subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt" ,  na.strings="?")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt" ,  na.strings="?")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt" )



# set the column names 
colnames(subject_test)<-"subject"
colnames(subject_train)<-"subject"
colnames(y_test)<-"activity"
colnames(y_train)<-"activity"
colnames(x_test)<-features[,2]
colnames(x_train)<-features[,2]

# add the subject to the x_? dataframe.
x_test<-cbind(subject_test,y_test,x_test)
x_train<-cbind(subject_train,y_train,x_train)

#Merges the training and the test sets to create one data set.

dfmerged<-rbind(x_test,x_train)

#Extracts only the measurements on the mean and standard deviation for each measurement.
#obtain the column names for the means and standard desviantion , and then a df with just these columns

means_sd<-c("subject","activity",grep("-mean()",colnames(dfmerged),fixed=TRUE,value=TRUE),grep("-std()",colnames(dfmerged),fixed=TRUE,value=TRUE))
dfJustMeanSd<-dfmerged[,means_sd]

#Uses descriptive activity names to name the activities in the data set
dfJustMeanSd$activity<- factor(dfJustMeanSd$activity,labels =activity_labels[,2])

names(dfJustMeanSd)<-gsub("^t", "Time", names(dfJustMeanSd))
names(dfJustMeanSd)<-gsub("^f", "Frequency", names(dfJustMeanSd))
names(dfJustMeanSd)<-gsub("Acc", "Accelerometer", names(dfJustMeanSd))
names(dfJustMeanSd)<-gsub("Gyro", "Gyroscope", names(dfJustMeanSd))
names(dfJustMeanSd)<-gsub("Mag", "Magnitude", names(dfJustMeanSd))
names(dfJustMeanSd)<-gsub("BodyBody", "Body", names(dfJustMeanSd))

# Appropriately labels the data set with descriptive variable names. 
resultData<-aggregate(. ~subject + activity, dfJustMeanSd, mean)
resultData<-resultData[order(resultData$subject,resultData$activity),]

# write the result file
write.table(resultData, file = "tidyResultdata.txt",row.name=FALSE)
