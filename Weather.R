
library(Amelia)
library(mice)
library(VIM)
library(Hmisc)
library(corrplot)
library(ROCR)

# Weather data 

setwd("F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Weather")

Weather <- read.csv('F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Weather/WeatherAUS.csv')
summary(Weather)
str(Weather)


#Droping insignificant columns 
#Creating new dataframe for the droped columns 
Weatherdropped <- Weather

Weatherdropped <- Weatherdropped[,-c(1,2,18)]
str(Weatherdropped)


# Finding missing values 

sapply(Weatherdropped,function(x) sum(is.na(x)))



# Graphical Representation of the missing values


#Visual representation of missing data
# mismap function draws the map of the missing value 
missmap(Weatherdropped, main = "Missing values vs observed")

#Reference Handling missing values
##########  USING MICE PACKAGE TO FIND PATTERNS AND PREDICTIVE MEAN METHOD FOR IMPUTATION ###################

md.pattern(Weatherdropped)


mice1_plot <- aggr(Weatherdropped, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(Weatherdropped), cex.axis=.4,
                  gap=3, ylab=c("Missing data","Pattern"))


imputed_WData <- mice(Weatherdropped, m=2, maxit = 50, method = 'pmm', seed = 500)
summary(imputed_Data) 
densityplot(imputed_WData) # Density plot for Imputed data and the observed data 


Weather_new_data <- complete(imputed_WData,1)  # Imputed mean replaced 
sapply(Weather_new_data,function(x) sum(is.na(x))) # 0 missing values replaced with mean
str(Weather_new_data)
###########  CHECKING FOR CORRELATIONS ################

weather_correlation <- Weather_new_data
str(weather_correlation)
hist(Weather_new_data)
boxplot(Weather_new_data)

weather_correlation$Pressure9am <- log(weather_correlation$Pressure9am) #Normalization 
weather_correlation$Pressure3pm <- log(weather_correlation$Pressure3pm) #Normalization 

str(weather_correlation)

hist(weather_correlation)
boxplot(weather_correlation)

weather_model <- weather_correlation
str(weather_model)

weather_correlation$WindSpeed9am <- as.numeric(weather_correlation$WindSpeed9am)
weather_correlation$WindSpeed3pm <- as.numeric(weather_correlation$WindSpeed3pm)
weather_correlation$Humidity9am <- as.numeric(weather_correlation$Humidity9am)
weather_correlation$Humidity3pm <- as.numeric(weather_correlation$Humidity3pm)
weather_correlation$Cloud9am <- as.numeric(weather_correlation$Cloud9am)
weather_correlation$Cloud3pm <- as.numeric(weather_correlation$Cloud3pm)
weather_correlation$RainTomorrow <- as.numeric(weather_correlation$RainTomorrow)


weather_correlation<- as.matrix(weather_correlation) #converting numeric dataframe in to matrix to print correlation


################  CORRELATION MATRIX ######################




Correlation_matrix <- corrplot(cor(weather_correlation), method = "number")
Correlation_matrix
summary(Correlation_matrix)




#################  CHECKING OUTLIERS #############
#Rainfall
boxplot(weather_model$Rainfall)
hist(weather_model$Rainfall)

str(weather_model)
#Sunshine
hist(weather_model$Sunshine)
boxplot(weather_model$Sunshine)

#humidity3
hist(weather_model$Humidity3pm)
boxplot(weather_model$Humidity3pm)

#cloud9
hist(weather_model$Cloud9am)
boxplot(weather_model$Cloud9am)

#cloud3
hist(weather_model$Cloud3pm)
boxplot(weather_model$Cloud3pm)
str(weather_model)

#Training the model ########## TRAINING MODEL ###################

smp_size <- floor(0.75 * nrow(weather_model))
set.seed(123)
train_sup <- sample(seq_len(nrow(weather_model)), size = smp_size)

train <- weather_model[train_sup,]
test <- weather_model[-train_sup,]


#####################   LOGISTIC REGRESSION #################

model <- glm(weather_model$RainTomorrow ~ weather_model$Rainfall + weather_model$Sunshine +
               weather_model$Humidity3pm + weather_model$Cloud9am + weather_model$Cloud3pm,family=binomial(link='logit'),data=weather_model)
print(model)
summary(model)

pred = predict(model, newdata=test[16])
pred
summary(pred)

####### Accuracy for Logistic Regression #############


pr <- prediction(pred, weather_model$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

################# Confusion matrix ##################
# Printing confusion matrix
Con_mat_log <- table((weather_model$RainTomorrow), pred > 0.5)
Con_mat_log













########################  RANDOM FOREST ######################

#Building model Random forest
install.packages("randomForest")
library("randomForest")
m1 <- randomForest(weather_model$RainTomorrow ~ weather_model$Rainfall + weather_model$Sunshine +
                     weather_model$Humidity3pm + weather_model$Cloud9am + weather_model$Cloud3pm, data= weather_model) 
print(m1)
summary(m1)

pred1 = predict(m1, newdata = test[16])
pred1
summary(pred1)

library("caret")
confusionMatrix(table(pred1, test$RainTomorrow))






