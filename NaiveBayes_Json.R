data_stream=read.csv("C:/Users/Pranesh.N/Desktop/Analytics/Recommendation Engine/Testdata.csv")
str(data_stream)
names(data_stream)

# This block is unnecessary if sampling is not employed

data_stream1=subset(data_stream,select=c(1,3,5,6))
names(data_stream1)

# Random sampling for model building

data_stream2=data_stream1[sample(1:nrow(data_stream1), 15,replace=FALSE),]
str(data_stream2)
plot(as.factor(data_stream2$Problem))
title(main="Problem count",xlab="Problem Category",ylab="Occurence")

# Require package e1071 to model data using Naive Bayes"

inst_pack<-function(e1071)
{
  if(!require(1071,character.only=TRUE))
  {
    install.packages(e1071)
    library(e1071)
  }
}

# Model building
# If sampling is not employed, data object to be mapped to original

install.packages("e1071")
library(e1071)
data_stream2$Resolution.notes=as.factor(data_stream2$Resolution.notes)
Nb_model=naiveBayes(Resolution.notes~Problem+Platform+Category,data=data_stream2,laplace = 1)
summary(Nb_model)

# Prediction
# Taking a subset to predict from original data set..... only to check model is working or not

RanSample <- data_stream2[sample(1:nrow(data_stream2), 7,replace=FALSE),]
View(RanSample)

# Classification based on Nb_model on all records and generating output file

Mod_Prediction<-predict(Nb_model, data_stream2, type = "raw")
final=cbind(data_stream2,Mod_Prediction)
write.csv(final,file="C:/Users/Pranesh.N/Desktop/Analytics/Recommendation Engine/Rev Output04082016.csv")


# to generate json file

names(final)
final1=subset(final,select=-c(2,3,4))
names(final1)
install.packages("jsonlite")
library(jsonlite)
fmtd_toJson<-toJSON(final1)
cat(fmtd_toJson)
