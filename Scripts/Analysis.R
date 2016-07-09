
# Environment ----

setwd("C:/Users/Ryan/Dropbox/RProjects/Mooc")
library(dplyr)
library(ggplot)
library(caTools)
library(tidyr)
library(ROCR)

# load training data ----
train.enrollment<- read.csv("train/train/enrollment_train.csv",
                      stringsAsFactors=F)

train.log<- read.csv("train/train/log_train.csv",
                     stringsAsFactors=F)

train.truth<- read.csv("train/train/truth_train.csv",
                       stringsAsFactors=F,
                       header=F)
names(train.truth)<- c("enrollment_id","drop")

object<- read.csv("object/object.csv", stringsAsFactors=F)

test.log<- read.csv("test/test/log_test.csv", stringsAsFactors=F)

test.enrollment <- read.csv("test/test/enrollment_test.csv",stringsAsFactors=F)

#20.6% drop rate 79.4% completion
table(train.truth[,2])

length(unique(object$course_id))

# Course 1 ----
courseid<- "1pvLqtotBsKv7QSOsLicJDQMHx3lui6d"
object1<- subset(object,course_id==courseid)
enrollment1<- subset(train.enrollment,course_id=courseid)
log1<- subset(train.log, object %in% object1$module_id)

log1.trim<-log1 %>%
  mutate(Occurence=1) %>%
  select(enrollment_id, object,Occurence) %>%
  group_by(enrollment_id,object) %>%
  summarise(Cnt = sum(Occurence))

Data<- spread(log1.trim,object,Cnt, fill = 0)
Data<- left_join(Data,train.truth)

Logmdl<- glm(drop~.-enrollment_id,data=Data, family=binomial)
Predict1<- predict(Logmdl,newdata=Data, type="response")
table(Data$drop,Predict1>0.5)

ROCRpred<-prediction(Predict1,Data$drop)
ROCRperf<- performance(ROCRpred,"tpr","fpr")
performance(ROCRpred,"auc")@y.values


testEnrollment1<- subset(test.enrollment,course_id=courseid)
testlog1<- subset(test.log, object %in% object1$module_id)

testlog1.trim<-testlog1 %>%
  mutate(Occurence=1) %>%
  select(enrollment_id, object,Occurence) %>%
  group_by(enrollment_id,object) %>%
  summarise(Cnt = sum(Occurence))

TestData<-spread(testlog1.trim,object,Cnt,fill=0)
TestPredict1<- predict(Logmdl,newdata=TestData,type="response")
TestPredict1<-data.frame(enrollment_id=TestData$enrollment_id,
                         Prediction=TestPredict1)

Submit<- data.frame(X1=test.enrollment[,1])
Submit<- left_join(Submit,TestPredict1, by=c("X1"="enrollment_id"))

Submit$Prediction<-ifelse(is.na(Submit$Prediction),0,Submit$Prediction)
names(Submit)<-NULL
write.csv(Submit,"Submit.csv",row.names=F)
