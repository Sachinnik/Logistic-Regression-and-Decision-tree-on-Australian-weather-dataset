
Masters of Science (Data Analytics) - Semester 1 project Subject : Data Mining and Machine Learning 1
# Logistic-Regression-and-Decision-tree-on-Australian-weather-dataset
In this project, classification models are used to predict weather its going to rain tomorrow or not.


Australian weather data contains the data for daily climatic conditions for Australia weather and forecast weather next day it is going to rain or not. Data contains 142194 rows and 19 columns. In this data, predictor will be “RainTomorrow” column, which will be considered as dependent variable. The dependent variable has two levels Yes/No, so this is considered as classification problem and classification models will be applied to predict the values.

Data cleaning and pre-processing: In this data, first step is to delete unwanted columns. There lies some columns which for modelling are actually not required for time 
being. Hence those columns are dropped. Missing values were identifies using sapply() function.

Handling missing values: Missing values are handled using "predective mean method". In predictive mean matching values are imputed by calculating mean.mice() function is used from ‘mice’ package to impute mean. In function mice value of m is 2, where two possible imputations will imputed.

Checking outliers: Outliers are checked using boxplots and histograms.

Data reduction and transformation: In this section data is normalized within a particular range. Normalization is a technique used using log() function.

Finding correlations: Correlation between the variables are checked by using corrplot() function from “corrplot” package.

Model Selection: Logistic Regression is applied by using glm() function from “CRAN” package. family=binomial and link = logit is used for Binary classification. Random forest is executed by using randomForest() function from “randomForest” package.

Evaluation: For logistic Regression Accuracy is calculated by using prediction() and performance() function from “ROCR” package. Confusion matrix is printed for both models as a evaluation method.

