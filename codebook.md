---
title: "CodeBook.Rmd"
output: html_document
---
# List of Data Variables and their descriptions
## Identifiers

* `subject` - The ID of the test subject
* `activityName` - The type of activity performed when the corresponding measurements were taken
* `activityNum` - The factor corresponding to the activity performed when the corresponding measurements were taken

## Measurements

* `timeBodyAccelerometer-MEAN()-X`                
* `timeBodyAccelerometer-MEAN()-Y`                 
* `timeBodyAccelerometer-MEAN()-Z`                
* `timeBodyAccelerometer-SD()-X`                   
* `timeBodyAccelerometer-SD()-Y`                  
* `timeBodyAccelerometer-SD()-Z`                   
* `timeGravityAccelerometer-MEAN()-X`             
* `timeGravityAccelerometer-MEAN()-Y`              
* `timeGravityAccelerometer-MEAN()-Z`             
* `timeGravityAccelerometer-SD()-X`                
* `timeGravityAccelerometer-SD()-Y`               
* `timeGravityAccelerometer-SD()-Z`                
* `timeBodyAccelerometerJerk-MEAN()-X`            
* `timeBodyAccelerometerJerk-MEAN()-Y`             
* `timeBodyAccelerometerJerk-MEAN()-Z`            
* `timeBodyAccelerometerJerk-SD()-X`               
* `timeBodyAccelerometerJerk-SD()-Y`              
* `timeBodyAccelerometerJerk-SD()-Z`               
* `timeBodyGyroscope-MEAN()-X`                    
* `timeBodyGyroscope-MEAN()-Y`                     
* `timeBodyGyroscope-MEAN()-Z`                    
* `timeBodyGyroscope-SD()-X`                       
* `timeBodyGyroscope-SD()-Y`                      
* `timeBodyGyroscope-SD()-Z`                       
* `timeBodyGyroscopeJerk-MEAN()-X`                
* `timeBodyGyroscopeJerk-MEAN()-Y`                 
* `timeBodyGyroscopeJerk-MEAN()-Z`                
* `timeBodyGyroscopeJerk-SD()-X`                   
* `timeBodyGyroscopeJerk-SD()-Y`                  
* `timeBodyGyroscopeJerk-SD()-Z`                   
* `timeBodyAccelerometerMagnitude-MEAN()`         
* `timeBodyAccelerometerMagnitude-SD()`            
* `timeGravityAccelerometerMagnitude-MEAN()`      
* `timeGravityAccelerometerMagnitude-SD()`         
* `timeBodyAccelerometerJerkMagnitude-MEAN()`     
* `timeBodyAccelerometerJerkMagnitude-SD()`        
* `timeBodyGyroscopeMagnitude-MEAN()`             
* `timeBodyGyroscopeMagnitude-SD()`                
* `timeBodyGyroscopeJerkMagnitude-MEAN()`         
* `timeBodyGyroscopeJerkMagnitude-SD()`            
* `frequencyBodyAccelerometer-MEAN()-X`           
* `frequencyBodyAccelerometer-MEAN()-Y`            
* `frequencyBodyAccelerometer-MEAN()-Z`           
* `frequencyBodyAccelerometer-SD()-X`              
* `frequencyBodyAccelerometer-SD()-Y`             
* `frequencyBodyAccelerometer-SD()-Z`              
* `frequencyBodyAccelerometerJerk-MEAN()-X`       
* `frequencyBodyAccelerometerJerk-MEAN()-Y`        
* `frequencyBodyAccelerometerJerk-MEAN()-Z`       
* `frequencyBodyAccelerometerJerk-SD()-X`          
* `frequencyBodyAccelerometerJerk-SD()-Y`         
* `frequencyBodyAccelerometerJerk-SD()-Z`          
* `frequencyBodyGyroscope-MEAN()-X`               
* `frequencyBodyGyroscope-MEAN()-Y`                
* `frequencyBodyGyroscope-MEAN()-Z`               
* `frequencyBodyGyroscope-SD()-X`                  
* `frequencyBodyGyroscope-SD()-Y`                 
* `frequencyBodyGyroscope-SD()-Z`                  
* `frequencyBodyAccelerometerMagnitude-MEAN()`    
* `frequencyBodyAccelerometerMagnitude-SD()`       
* `frequencyBodyAccelerometerJerkMagnitude-MEAN()`
* `frequencyBodyAccelerometerJerkMagnitude-SD()`   
* `frequencyBodyGyroscopeMagnitude-MEAN()`        
* `frequencyBodyGyroscopeMagnitude-SD()`           
* `frequencyBodyGyroscopeJerkMagnitude-MEAN()`    
* `frequencyBodyGyroscopeJerkMagnitude-SD()`

## Activity Labels

* `WALKING` (value `1`): subject was walking during the test
* `WALKING_UPSTAIRS` (value `2`): subject was walking up a staircase during the test
* `WALKING_DOWNSTAIRS` (value `3`): subject was walking down a staircase during the test
* `SITTING` (value `4`): subject was sitting during the test
* `STANDING` (value `5`): subject was standing during the test
* `LAYING` (value `6`): subject was laying down during the test

## Description of abbreviations of measurements in steps below
leading t or f is based on time or frequency measurements.
Body = related to body movement.
Gravity = acceleration of gravity
Acc = accelerometer measurement
Gyro = gyroscopic measurements
Jerk = sudden movement acceleration
Mag = magnitude of movement
mean and SD are calculated for each subject for each activity for each mean and SD measurements.
The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

## Set of variables estimated from the signals

mean(): Mean value
std(): Standard deviation

# Steps taken to clean data
## Load packages

```r
library(dplyr)
library(data.table)
library(tidyr)
```
## Downloading & Unzipping file

```r
path <- getwd()
f <- "Dataset.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, f))
unzip("Dataset.zip")
```
## Setting path to dataset folder

```r
pathIn <- file.path(path, "UCI HAR Dataset")
files <- list.files(pathIn, recursive = TRUE)
files
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```
For the purposes of this project, the files in the Inertial Signals folders are not used.

## Reading data into variables
### Read subject files

```r
dataSubjectTrain <- tbl_df(read.table(file.path(pathIn, "train", "subject_train.txt")))
dataSubjectTest  <- tbl_df(read.table(file.path(pathIn, "test" , "subject_test.txt")))
```
### Read activity files

```r
dataActivityTrain <- tbl_df(read.table(file.path(pathIn, "train", "Y_train.txt")))
dataActivityTest  <- tbl_df(read.table(file.path(pathIn, "test" , "Y_test.txt")))
```
### Read data files.

```r
dataTrain <- tbl_df(read.table(file.path(pathIn, "train", "X_train.txt")))
dataTest  <- tbl_df(read.table(file.path(pathIn, "test" , "X_test.txt")))
```

## Combining data
### Combining Subject and Activity data & rename variables "subject" and "activityNum"

```r
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")
```
### Combining data Train and Test files

```r
Data <- rbind(dataTrain, dataTest)
```
### Name variables based on features

```r
dataFeatures <- tbl_df(read.table(file.path(pathIn, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(Data) <- dataFeatures$featureName
```
### Read Activity labels for column names

```r
activityLabels<- tbl_df(read.table(file.path(pathIn, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
```
### Merge tables to create main data frame

```r
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
Data <- cbind(alldataSubjAct, Data)
```

## Extracting the mean and SD
### Reading "features.txt" and extracting only the mean and SD

```r
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)
```
### Subsetting measurements for the mean and SD and add "subject","activityNum" from main dataframe

```r
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
Data<- subset(Data,select=dataFeaturesMeanStd)
```

## Adding descriptive labels
### Reading descriptive activity labels into main dataframe 

```r
Data <- merge(activityLabels, Data , by="activityNum", all.x=TRUE)
Data$activityName <- as.character(Data$activityName)
```
### Apply descriptive names to the dataframe

```r
names(Data)<-gsub("std()", "SD", names(Data))
names(Data)<-gsub("mean()", "MEAN", names(Data))
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
```

## Sorting and tidying up data

```r
dataAggr <- aggregate(. ~ subject - activityName, data = Data, mean) 
Tidydata <- tbl_df(arrange(dataAggr,subject,activityName))
```
### Writing txt file

```r
write.table(Tidydata, "TidyData.txt", row.name=FALSE)
```

