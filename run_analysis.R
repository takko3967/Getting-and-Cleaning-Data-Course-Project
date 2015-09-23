## Load packages
library(dplyr)
library(data.table)
library(tidyr)

## Downloading & Unzipping file
path <- getwd()
f <- "Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, f))
unzip("Dataset.zip")

## Setting path to dataset folder
pathIn <- file.path(path, "UCI HAR Dataset")
files <- list.files(pathIn, recursive = TRUE)

## Reading data into variables
# Read subject files
dataSubjectTrain <- tbl_df(read.table(file.path(pathIn, "train", "subject_train.txt")))
dataSubjectTest  <- tbl_df(read.table(file.path(pathIn, "test" , "subject_test.txt")))
# Read activity files
dataActivityTrain <- tbl_df(read.table(file.path(pathIn, "train", "Y_train.txt")))
dataActivityTest  <- tbl_df(read.table(file.path(pathIn, "test" , "Y_test.txt")))
#Read data files.
dataTrain <- tbl_df(read.table(file.path(pathIn, "train", "X_train.txt")))
dataTest  <- tbl_df(read.table(file.path(pathIn, "test" , "X_test.txt")))

## Combining Subject and Activity data & rename variables "subject" and "activityNum"
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

## Combining data Train and Test files
Data <- rbind(dataTrain, dataTest)

## Name variables based on features
dataFeatures <- tbl_df(read.table(file.path(pathIn, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(Data) <- dataFeatures$featureName

## Read Activity lables for column names
activityLabels<- tbl_df(read.table(file.path(pathIn, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

## Merge tables to create main data frame
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
Data <- cbind(alldataSubjAct, Data)

## Reading "features.txt" and extracting only the mean and SD
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)

## Subsetting measurements for the mean and SD and add "subject","activityNum" from main dataframe
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
Data<- subset(Data,select=dataFeaturesMeanStd)

## Reading descriptive activity lables into main dataframe 
Data <- merge(activityLabels, Data , by="activityNum", all.x=TRUE)
Data$activityName <- as.character(Data$activityName)

## Apply descriptive names to the dataframe
names(Data)<-gsub("std()", "SD", names(Data))
names(Data)<-gsub("mean()", "MEAN", names(Data))
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Sorting and tidying up data
dataAggr <- aggregate(. ~ subject - activityName, data = Data, mean) 
Tidydata <- tbl_df(arrange(dataAggr,subject,activityName))

## Writing txt file
write.table(Tidydata, "TidyData.txt", row.name=FALSE)
