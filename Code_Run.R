library(data.table)
setwd("D:/Coursera/Getting and Cleaning Data/UCI HAR Dataset")

###Read subject files
subject_test <- read.table("./test/subject_test.txt",header = F)
subject_train <- read.table("./train/subject_train.txt",header = F)

###Reading Activity files
Activity_test <-read.table("./test/y_test.txt",header = F)
Activity_train <-read.table("./train/y_train.txt",header = F)
names(y_test) <- "activity"
names(y_train) <- "activity"

###Read features files
Feature_test <-read.table("./test/X_test.txt",header = F)
Feature_train <-read.table("./train/X_train.txt",header = F)

####Get factor of Activity names
activity_labels <- read.table("./activity_labels.txt", header=F)

#####Read Feature Names
featuresNames <- read.table("./features.txt",header = F)

#####Merg dataframes: Features Test&Train,Activity Test&Train, Subject Test&Train
FeaturesData <- rbind(Feature_test, Feature_train)
SubjectData <- rbind(subject_test, subject_train)
ActivityData <- rbind(Activity_test, Activity_train)

####Renaming colums in ActivityData & ActivityLabels dataframes
names(ActivityData) <- "ActivityN"
names(activity_labels) <- c("ActivityN", "Activity")

####Get factor of Activity names
Activity <- merge(ActivityData, activity_labels, by.x="ActivityN", by.y="ActivityN")

####Rename SubjectData columns
names(SubjectData) <- "Subject"
#Rename FeaturesData columns using columns from FeaturesNames
names(FeaturesData) <- featuresNames$V2

###Create one large Dataset with only these variables: SubjectData,  Activity,  FeaturesData
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)

###Create New datasets by extracting only the measurements on the mean and standard deviation for each measurement
subFeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)

#####Rename the columns of the large dataset using more descriptive activity names
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))

####Create a second, independent tidy data set with the average of each variable for each activity and each subject
SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]

#Save this tidy dataset to local file
write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)
