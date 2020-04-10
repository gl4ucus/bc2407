library(data.table)
library(caTools)
library(readr)
library(Matrix)
library(xgboost)
library(caret)
library(dplyr)
library(DiagrammeR)

setwd("C:/Users/User/Desktop/School/Y2S2/BC2407 Analytics II Advanced Predictive Techniques/Project/Team 2")

dt <- fread("All Crimes.csv")


# Convert Date to Month and Day
dt$Date <- as.Date(dt$Date, "%m/%d/%Y")

dt$Year <- year(dt$Date)
dt$Month <- month(dt$Date)
dt$Day <- mday(dt$Date)
dt$Date <- NULL

dt$Category <- factor(dt$Category)
dt$Descript <- factor(dt$Descript)
dt$PdDistrict <- factor(dt$PdDistrict)
dt$DayOfWeek <- factor(dt$DayOfWeek)


dt[Resolution != "NONE", Solvable := "YES"]
dt[Resolution == "NONE", Solvable := "NO"]
dt$Solvable <- factor(dt$Solvable)
dt$Resolution <- NULL


solvable = dt$Solvable
label = as.integer(dt$Solvable) - 1
dt$Category <- as.integer(dt$Category) - 1
dt$Descript <- as.integer(dt$Descript) - 1
dt$DayOfWeek <- as.integer(dt$DayOfWeek) - 1
dt$PdDistrict <- as.integer(dt$PdDistrict) - 1
dt$Time <- parse_time(dt$Time, "%H:%M")
dt$Time <- as.integer(dt$Time) - 1
dt$Solvable <- NULL

n = nrow(dt)
train.index = sample(n,floor(0.75*n))
train.data = as.matrix(dt[train.index,])
train.label = label[train.index]
test.data = as.matrix(dt[-train.index,])
test.label = label[-train.index]

xgb.train = xgb.DMatrix(data=train.data,label=train.label)
xgb.test = xgb.DMatrix(data=test.data,label=test.label)


num_class = length(levels(solvable)) #Yes or No
# Parameters
xgb_params <- list("objective" = "multi:softprob",
                   "eval_metric" = "mlogloss",
                   "num_class" = num_class) 

watchlist <- list(train = xgb.train, test = xgb.test)

set.seed(2020)
# eXtreme Gradient Boosting Model
bst_model <- xgb.train(params = xgb_params,
                       data = xgb.train,
                       nrounds = 1000,      # 1000 iterations
                       watchlist = watchlist)
