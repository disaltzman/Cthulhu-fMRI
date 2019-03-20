# load packages
rm(list = ls(all = TRUE))

library(plyr)
library(dplyr)
library(data.table)
library(Rmisc)
library(ggplot2)
library(cowplot)
library(ez)
library(lme4)
library(tidyverse)
library(scales)
library(gdata)
library(quickpsy)
source("https://raw.githubusercontent.com/janhove/janhove.github.io/master/RCode/sortLvls.R")
theme_set(theme_bw())

### read in files
file_names <- list.files(path = ".", pattern = "*.csv", all.files = FALSE,
                         full.names = FALSE, recursive = FALSE) # where you have your files

df <- data.frame(matrix(vector(), 0, 9,dimnames=list(c(),c("acc","block", "correct_response", "trial","fname","response","rt","session","subject"))),stringsAsFactors=F)

# loop to create combined dataframe
for (i in file_names) {
  data <- fread(i, header = TRUE, sep = ",")
  data <- `colnames<-`(data,  c("acc","block", "correct_response", "trial","fname","response","rt","session","subject"))
  df <- rbind(df, data)
}

# split by session 
session1 <- subset(df,session == 1)
session2 <- subset(df,session == 2)
session3 <- subset(df,session == 3)
session4 <- subset(df,session == 4)
sine <- subset(df,session == "S3")

# various housekeeping things
df$correct_response <- as.numeric(df$correct_response)
df$trial <- as.numeric(df$trial)
df$rt <- as.numeric(df$rt)
# chop off session indicator numbers to get base subject number
df$subject2 <- ifelse(nchar(df$subject)==3,substr(df$subject,1,1),substr(df$subject,1,2))

#### SESSION 1 ####

# split by block for session1
pretest1 <- subset(session1,block == "pretest_discrimination")
posttest1 <- subset(session1,block == "posttest_discrimination")
training1.1 <- subset(session1,block == "training1")
training1.2 <- subset(session1,block == "training2")
training1.3 <- subset(session1,block == "training3")
continuum1 <- subset(session1,block == "continuum")

# create pretest performance figure
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step2-step2.wav","2-2",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step3-step3.wav","3-3",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step4-step4.wav","4-4",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step5-step5.wav","5-5",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step6-step6.wav","6-6",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step7-step7.wav","7-7",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_1-step_3.wav","1-3",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_2-step_4.wav","2-4",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_3-step_5.wav","3-5",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_4-step_6.wav","4-6",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_5-step_7.wav","5-7",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_3-step_1.wav","1-3",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_4-step_2.wav","2-4",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_5-step_3.wav","3-5",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_6-step_4.wav","4-6",pretest1$fname2)
pretest1$fname2 <- ifelse(pretest1$fname=="i-y-u_step_7-step_5.wav","5-7",pretest1$fname2)

pretest1_figure = ddply(pretest1,.(fname2),summarize,mean=mean(correct_response))

pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="1-1","same",NA)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="2-2","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="3-3","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="4-4","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="5-5","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="6-6","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="7-7","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="1-3","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="2-4","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="3-5","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="4-6","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$fname2=="5-7","different",pretest1_figure$condition)


pretest1_figure$fname2 <- as.factor(pretest1_figure$fname2)
pretest1_figure$fname3 <- sortLvls.fnc(pretest1_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest1_barplot <- ggplot(pretest1_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 1")

#### create posttest performance figure
# create variable to combine forwards/backwards discrimination steps
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step2-step2.wav","2-2",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step3-step3.wav","3-3",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step4-step4.wav","4-4",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step5-step5.wav","5-5",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step6-step6.wav","6-6",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step7-step7.wav","7-7",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_1-step_3.wav","1-3",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_2-step_4.wav","2-4",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_3-step_5.wav","3-5",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_4-step_6.wav","4-6",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_5-step_7.wav","5-7",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_3-step_1.wav","1-3",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_4-step_2.wav","2-4",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_5-step_3.wav","3-5",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_6-step_4.wav","4-6",posttest1$fname2)
posttest1$fname2 <- ifelse(posttest1$fname=="i-y-u_step_7-step_5.wav","5-7",posttest1$fname2)

# create dataframe with posttest1 accuracy by item
posttest1_figure = ddply(posttest1,.(fname2),summarize,mean=mean(correct_response))

posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="1-1","same",NA)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="2-2","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="3-3","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="4-4","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="5-5","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="6-6","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="7-7","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="1-3","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="2-4","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="3-5","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="4-6","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$fname2=="5-7","different",posttest1_figure$condition)

posttest1_figure$fname2 <- as.factor(posttest1_figure$fname2)
posttest1_figure$fname3 <- sortLvls.fnc(posttest1_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest1_barplot <- ggplot(posttest1_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 1")





#### SESSION 2 ####

# split by block for session2
pretest2 <- subset(session2,block == "pretest_discrimination")
posttest2 <- subset(session2,block == "posttest_discrimination")
training2.1 <- subset(session2,block == "training1")
training2.2 <- subset(session2,block == "training2")
training2.3 <- subset(session2,block == "training3")
continuum2 <- subset(session2,block == "continuum")

# summarize performance by subject
pretest2_performance = ddply(pretest2,.(subject),summarize,mean=mean(correct_response))
posttest2_performance = ddply(posttest2,.(subject),summarize,mean=mean(correct_response))
training2.1_performance = ddply(training2.1,.(subject),summarize,mean=mean(correct_response))
training2.2_performance = ddply(training2.2,.(subject),summarize,mean=mean(correct_response))
training2.3_performance = ddply(training2.3,.(subject),summarize,mean=mean(correct_response))

# create pretest performance figure
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step2-step2.wav","2-2",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step3-step3.wav","3-3",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step4-step4.wav","4-4",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step5-step5.wav","5-5",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step6-step6.wav","6-6",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step7-step7.wav","7-7",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_1-step_3.wav","1-3",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_2-step_4.wav","2-4",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_3-step_5.wav","3-5",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_4-step_6.wav","4-6",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_5-step_7.wav","5-7",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_3-step_1.wav","1-3",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_4-step_2.wav","2-4",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_5-step_3.wav","3-5",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_6-step_4.wav","4-6",pretest2$fname2)
pretest2$fname2 <- ifelse(pretest2$fname=="i-y-u_step_7-step_5.wav","5-7",pretest2$fname2)

pretest2_figure = ddply(pretest2,.(fname2),summarize,mean=mean(correct_response))

pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="1-1","same",NA)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="2-2","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="3-3","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="4-4","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="5-5","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="6-6","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="7-7","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="1-3","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="2-4","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="3-5","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="4-6","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$fname2=="5-7","different",pretest2_figure$condition)

pretest2_figure$fname2 <- as.factor(pretest2_figure$fname2)
pretest2_figure$fname3 <- sortLvls.fnc(pretest2_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest2_barplot <- ggplot(pretest2_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 2")


#### create posttest2 performance figure
# create variable to combine forwards/backwards discrimination steps
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step2-step2.wav","2-2",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step3-step3.wav","3-3",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step4-step4.wav","4-4",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step5-step5.wav","5-5",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step6-step6.wav","6-6",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step7-step7.wav","7-7",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_1-step_3.wav","1-3",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_2-step_4.wav","2-4",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_3-step_5.wav","3-5",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_4-step_6.wav","4-6",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_5-step_7.wav","5-7",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_3-step_1.wav","1-3",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_4-step_2.wav","2-4",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_5-step_3.wav","3-5",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_6-step_4.wav","4-6",posttest2$fname2)
posttest2$fname2 <- ifelse(posttest2$fname=="i-y-u_step_7-step_5.wav","5-7",posttest2$fname2)

# create dataframe with posttest2 accuracy by item
posttest2_figure = ddply(posttest2,.(fname2),summarize,mean=mean(correct_response))

posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="1-1","same",NA)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="2-2","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="3-3","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="4-4","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="5-5","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="6-6","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="7-7","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="1-3","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="2-4","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="3-5","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="4-6","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$fname2=="5-7","different",posttest2_figure$condition)

posttest2_figure$fname2 <- as.factor(posttest2_figure$fname2)
posttest2_figure$fname3 <- sortLvls.fnc(posttest2_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest2_barplot <- ggplot(posttest2_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 2")







#### SESSION 3 ####

# split by block for session3
pretest3 <- subset(session3,block == "pretest_discrimination")
posttest3 <- subset(session3,block == "posttest_discrimination")
training3.1 <- subset(session3,block == "training1")
training3.2 <- subset(session3,block == "training2")
training3.3 <- subset(session3,block == "training3")
continuum3 <- subset(session3,block == "continuum")

# summarize performance by subject
pretest3_performance = ddply(pretest3,.(subject),summarize,mean=mean(correct_response))
posttest3_performance = ddply(posttest3,.(subject),summarize,mean=mean(correct_response))
training3.1_performance = ddply(training3.1,.(subject),summarize,mean=mean(correct_response))
training3.2_performance = ddply(training3.2,.(subject),summarize,mean=mean(correct_response))
training3.3_performance = ddply(training3.3,.(subject),summarize,mean=mean(correct_response))

# create pretest performance figure
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step2-step2.wav","2-2",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step3-step3.wav","3-3",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step4-step4.wav","4-4",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step5-step5.wav","5-5",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step6-step6.wav","6-6",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step7-step7.wav","7-7",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_1-step_3.wav","1-3",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_2-step_4.wav","2-4",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_3-step_5.wav","3-5",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_4-step_6.wav","4-6",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_5-step_7.wav","5-7",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_3-step_1.wav","1-3",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_4-step_2.wav","2-4",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_5-step_3.wav","3-5",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_6-step_4.wav","4-6",pretest3$fname2)
pretest3$fname2 <- ifelse(pretest3$fname=="i-y-u_step_7-step_5.wav","5-7",pretest3$fname2)

pretest3_figure = ddply(pretest3,.(fname2),summarize,mean=mean(correct_response))

pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="1-1","same",NA)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="2-2","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="3-3","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="4-4","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="5-5","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="6-6","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="7-7","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="1-3","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="2-4","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="3-5","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="4-6","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$fname2=="5-7","different",pretest3_figure$condition)


pretest3_figure$fname2 <- as.factor(pretest3_figure$fname2)
pretest3_figure$fname3 <- sortLvls.fnc(pretest3_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest3_barplot <- ggplot(pretest3_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 3")

#### create posttest3 performance figure
# create variable to combine forwards/backwards discrimination steps
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step2-step2.wav","2-2",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step3-step3.wav","3-3",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step4-step4.wav","4-4",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step5-step5.wav","5-5",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step6-step6.wav","6-6",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step7-step7.wav","7-7",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_1-step_3.wav","1-3",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_2-step_4.wav","2-4",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_3-step_5.wav","3-5",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_4-step_6.wav","4-6",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_5-step_7.wav","5-7",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_3-step_1.wav","1-3",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_4-step_2.wav","2-4",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_5-step_3.wav","3-5",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_6-step_4.wav","4-6",posttest3$fname2)
posttest3$fname2 <- ifelse(posttest3$fname=="i-y-u_step_7-step_5.wav","5-7",posttest3$fname2)

# create dataframe with posttest3 accuracy by item
posttest3_figure = ddply(posttest3,.(fname2),summarize,mean=mean(correct_response))

posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="1-1","same",NA)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="2-2","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="3-3","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="4-4","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="5-5","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="6-6","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="7-7","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="1-3","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="2-4","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="3-5","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="4-6","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$fname2=="5-7","different",posttest3_figure$condition)

posttest3_figure$fname2 <- as.factor(posttest3_figure$fname2)
posttest3_figure$fname3 <- sortLvls.fnc(posttest3_figure$fname2, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest3_barplot <- ggplot(posttest3_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 3")


#### SESSION 4 ####

session4_performance = ddply(session4,.(subject,block),summarize,mean=mean(correct_response))

# bar plot for session 4
ggplot(session4_performance,aes(x=subject,y=mean)) + geom_bar(stat="identity",position="dodge",aes(fill=block)) + 
  geom_hline(yintercept=0.8,linetype="dashed")
                              

#### FOR SINE SESSION ####

sine_session <- subset(df,session == "S3")

# split by block
pretest_sine <- subset(sine_session,block == "pretest_discrimination")
posttest_sine <- subset(sine_session,block == "posttest_discrimination")
training_sine.1 <- subset(sine_session,block == "training1")
training_sine.2 <- subset(sine_session,block == "training2")
training_sine.3 <- subset(sine_session,block == "training3")
continuum1_sine <- subset(sine_session,block == "continuum")

# summarize performance by subject
pretest_sine_performance = ddply(pretest_sine,.(subject),summarize,mean=mean(correct_response))
posttest_sine_performance = ddply(posttest_sine,.(subject),summarize,mean=mean(correct_response))
training_sine.1_performance = ddply(training_sine.1,.(subject),summarize,mean=mean(correct_response))
training_sine.2_performance = ddply(training_sine.2,.(subject),summarize,mean=mean(correct_response))
training_sine.3_performance = ddply(training_sine.3,.(subject),summarize,mean=mean(correct_response))


#### OTHER FIGURES ####

### grid of discrimination plots from each day
plot_grid(pretest1_barplot,pretest2_barplot,pretest3_barplot,posttest1_barplot,posttest2_barplot,posttest3_barplot)

# plot by subject performance for each discrimination task across each day
# combine performances across tasks and days
by_subject_performance <- combine(pretest1_performance,posttest1_performance,pretest2_performance,posttest2_performance,
                                  pretest3_performance,posttest3_performance,pretest_sine_performance,posttest_sine_performance)

# add new variable to work around day-specific subject ID's
by_subject_performance$subject2 <- ifelse(nchar(by_subject_performance$subject)==3,substr(by_subject_performance$subject,1,1),substr(by_subject_performance$subject,1,2))

# by subject performance for each discrimination task
ggplot(by_subject_performance,aes(x=subject2,y=mean)) + geom_bar(stat="identity",position="dodge",aes(fill=source))






#### FOR TALK SHOP 11/29 ####

# create training performance figure with training sublock on the X axis and session as grouping variable

# separate training data
training_figure_data <- subset(df,grepl("training",block))

# remove session 4
training_figure_data <- subset(training_figure_data,session!=4)

# subset vowel training
training_figure_data_vowel <- subset(training_figure_data,session!="S3")

# create figure
# version with error bars
stats <- summarySE(data=training_figure_data_vowel, measurevar="correct_response",groupvars=c("block","session"))

test <- ggplot(stats,aes(x=block,y=correct_response,fill=session)) + 
  geom_bar(stat="identity",position="dodge",aes(fill=session)) +
  geom_errorbar(aes(ymin=correct_response-se,ymax=correct_response+se),position=position_dodge(width=0.9)) + 
  scale_y_continuous('Percent accuracy',breaks=c(0.5,0.75,1),labels=c(50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette = "Purples") +
  coord_cartesian(ylim=c(0.4,1)) +
  theme_dark() +
  theme(text = element_text(size=20)) +
  theme(
    panel.background = element_rect(fill = "transparent") # bg of the panel
    , plot.background = element_rect(fill = "transparent", color = NA) # bg of the plot
    , panel.grid.major = element_blank() # get rid of major grid
    , panel.grid.minor = element_blank() # get rid of minor grid
    , legend.background = element_rect(fill = "transparent") # get rid of legend bg
  )
ggsave(test, filename = "/Users/Dave/Desktop/test.png",  bg = "transparent")

# version using dataset without summarizing
ggplot(training_figure_data_vowel,aes(x=block,y=correct_response)) + 
  geom_bar(stat="summary",position="dodge",aes(fill=session),fun.y='mean') +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette = "Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

# overlay individual data points and group mean bars
id <- ddply(training_figure_data_vowel,.(subject2,block,session),summarize,mean=mean(correct_response))

gd <- select(stats,block,session,correct_response)
gd <- rename(gd,mean=correct_response)

# across session
ggplot(id,aes(x=block,y=mean)) +
  geom_point(aes(x=block,color=session),position = position_dodge(width=0.75)) + geom_bar(data=gd,aes(fill=session),stat="identity",alpha=0.7,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette="Purples") +
  scale_color_brewer('Session #',palette="Purples") +
  coord_cartesian(ylim=c(0.4,1)) +
  theme_dark() +
  theme(text=element_text(size=20))

# collapse session
stats2 <- summarySE(data=training_figure_data_vowel, measurevar="correct_response",groupvars=c("block"))
id2 <- ddply(training_figure_data_vowel,.(block,subject2),summarize,mean=mean(correct_response))
gd2 <- select(stats2,block,correct_response)
gd2<- rename(gd2,mean=correct_response)

ggplot(id2,aes(x=block,y=mean)) +
  geom_point(aes(x=block),position = position_dodge(width=0.75)) + geom_bar(data=gd2,aes(fill=block),stat="identity",position="dodge",alpha=0.3) +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  coord_cartesian(ylim=c(0.4,1)) +
  scale_fill_manual('Block',labels=c("1","2","3"),values=c("purple","purple","purple")) +
  guides(fill=FALSE) +
  theme_dark() +
  theme(text=element_text(size=20))

### calculating d' for discrimination performance ###

# subset to just discrimination blocks
discrim_fig_data <- subset(df,grepl("discrimination",block))

# remove session 4
discrim_fig_data <- subset(discrim_fig_data,session!=4)

# subset vowel training
discrim_fig_data_vowel <- subset(discrim_fig_data,session!="S3")

# subset only post-test
discrim_fig_data_vowel <- subset(discrim_fig_data_vowel,grepl("posttest",block))

# create variable to combine forwards/backwards discrimination steps
discrim_fig_data_vowel$fname2 <- ifelse(discrim_fig_data_vowel$fname=="i-y-u_step1-step1.wav","1-1",
                                        ifelse(discrim_fig_data_vowel$fname=="i-y-u_step2-step2.wav","2-2",
                                               ifelse(discrim_fig_data_vowel$fname=="i-y-u_step3-step3.wav","3-3",
                                                      ifelse(discrim_fig_data_vowel$fname=="i-y-u_step4-step4.wav","4-4",
                                                             ifelse(discrim_fig_data_vowel$fname=="i-y-u_step5-step5.wav","5-5",
                                                                    ifelse(discrim_fig_data_vowel$fname=="i-y-u_step6-step6.wav","6-6",
                                                                           ifelse(discrim_fig_data_vowel$fname=="i-y-u_step7-step7.wav","7-7",
                                                                                  ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_1-step_3.wav","1-3",
                                                                                         ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_2-step_4.wav","2-4",
                                                                                                ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_3-step_5.wav","3-5",
                                                                                                       ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_4-step_6.wav","4-6",
                                                                                                              ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_5-step_7.wav","5-7",
                                                                                                                     ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_3-step_1.wav","1-3",
                                                                                                                            ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_4-step_2.wav","2-4",
                                                                                                                                   ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_5-step_3.wav","3-5",
                                                                                                                                          ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_6-step_4.wav","4-6",
                                                                                                                                                 ifelse(discrim_fig_data_vowel$fname=="i-y-u_step_7-step_5.wav","5-7",NA)))))))))))))))))


discrim_fig_data_vowel$condition <- ifelse(discrim_fig_data_vowel$fname2=="1-1","same",
                                           ifelse(discrim_fig_data_vowel$fname2=="2-2","same",
                                                  ifelse(discrim_fig_data_vowel$fname2=="3-3","same",
                                                         ifelse(discrim_fig_data_vowel$fname2=="4-4","same",
                                                                ifelse(discrim_fig_data_vowel$fname2=="5-5","same",
                                                                       ifelse(discrim_fig_data_vowel$fname2=="6-6","same",
                                                                              ifelse(discrim_fig_data_vowel$fname2=="7-7","same",
                                                                                     ifelse(discrim_fig_data_vowel$fname2=="1-3","different",
                                                                                            ifelse(discrim_fig_data_vowel$fname2=="2-4","different",
                                                                                                   ifelse(discrim_fig_data_vowel$fname2=="3-5","different",
                                                                                                          ifelse(discrim_fig_data_vowel$fname2=="4-6","different",
                                                                                                                 ifelse(discrim_fig_data_vowel$fname2=="5-7","different",NA))))))))))))
                                                                                                                        
### calculate d' ###

# make a new data frame that contains the data we need
df1 <- discrim_fig_data_vowel %>%
  group_by(session,subject2,condition) %>%
  summarize(prop_cor = mean(correct_response))

df1 <- df1 %>% mutate(prop_cor=ifelse(condition=="different",prop_cor,1-prop_cor))

df_final <- spread(df1, condition, prop_cor)

colnames(df_final) <- c("Session","Subject","Hit","FA")

#we will use this closure to create two functions: one to change 1 to .99 and 
# one to change 0 to .01 (.99 and .01 still have to be specified though)
cutoff <- function(value) {
  function(x,y) {
    x[x == value] <- y
    x
  }
}

cutoff_1 <- cutoff(1)
cutoff_0 <- cutoff(0)

df_final$Hit <- cutoff_1(df_final$Hit,.99)
df_final$Hit <- cutoff_0(df_final$Hit,.01)
df_final$FA <- cutoff_1(df_final$FA,.99)
df_final$FA <- cutoff_0(df_final$FA,.01)

# make function for d', then apply it to each time point, participant, etc.
d_prime <- function(Hit, FA){
  qnorm(Hit) - qnorm(FA)
}

dprime <- df_final %>%
  group_by(Session,Subject) %>%
  mutate(dprime = d_prime(Hit,FA))

dprime <- dprime %>% select(-c(Hit,FA))

# create dprime by session figure 
dprime_cllpsd <- ddply(dprime,.(Session),summarize,mean=mean(dprime))
colnames(dprime_cllpsd)[2] <- "dprime"

ggplot(dprime,aes(x=Session,y=dprime)) + 
  geom_bar(data=dprime_cllpsd,stat="identity",position="dodge",aes(fill=Session),alpha=0.7) +
  geom_point(aes(color=Session),position = position_dodge(width=0.75)) +
  scale_y_continuous('d Prime',breaks=c(0,.25,.5,.75,1,1.25,1.5,1.75,2,2.25,2.5,2.75),labels=c(0,.25,.5,.75,1,1.25,1.5,1.75,2,2.25,2.5,2.75)) +
  scale_x_discrete('Session',labels=c('1','2','3')) +
  scale_fill_brewer('Session #',palette="Purples") +
  scale_color_brewer('Session #',palette="Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

ggplot(dprime,aes(x=Session,y=dprime)) + 
  geom_boxplot(position="dodge",aes(fill=Session),middle=mean(dprime$dprime)) +
  geom_point(position = position_dodge(width=0.75)) +
  scale_y_continuous('d Prime',breaks=c(-.1,0,0.5,1,1.5,2,2.50,3),labels=c(-.1,0,0.5,1,1.5,2,2.50,3)) +
  scale_x_discrete('Session',labels=c('1','2','3')) +
  scale_fill_brewer('Session #',palette = "Purples") +
  scale_color_brewer('Session #',palette="Purples") +
  theme_dark() +
  theme(text = element_text(size=20))



### calculate d' for each stimulus ###
# make a new data frame that contains the data we need

df4 <- discrim_fig_data_vowel %>%
  group_by(session,subject2,condition,fname2) %>%
  summarize(prop_cor = mean(correct_response))

df4 <- df4 %>% mutate(prop_incor=1-prop_cor)

# we will use this closure to create two functions: one to change 1 to .99 and 
# one to change 0 to .01 (.99 and .01 still have to be specified though)
cutoff <- function(value) {
  function(x,y) {
    x[x == value] <- y
    x
  }
}

cutoff_1 <- cutoff(1)
cutoff_0 <- cutoff(0)

df4$prop_cor <- cutoff_1(df4$prop_cor,.99)
df4$prop_cor <- cutoff_0(df4$prop_cor,.01)
df4$prop_incor <- cutoff_1(df4$prop_incor,.99)
df4$prop_incor <- cutoff_0(df4$prop_incor,.01)

# make function for d', then apply it to each stimulus

### 1-3 ###
dprime_temp_same <- subset(df4,df4$fname2=="1-1" | df4$fname2=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="1-3")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)
  
d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp1 <- dprime_temp3 %>%
  group_by(session,subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp1$stimulus <- "1-3"

### 2-4 ###
dprime_temp_same <- subset(df4,df4$fname2=="2-2" | df4$fname2=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="2-4")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp2 <- dprime_temp3 %>%
  group_by(session,subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp2$stimulus <- "2-4"

### 3-5 ###
dprime_temp_same <- subset(df4,df4$fname2=="3-3" | df4$fname2=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="3-5")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp3 <- dprime_temp3 %>%
  group_by(session,subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp3$stimulus <- "3-5"

### 4-6 ###
dprime_temp_same <- subset(df4,df4$fname2=="4-4" | df4$fname2=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="4-6")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp4 <- dprime_temp3 %>%
  group_by(session,subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp4$stimulus <- "4-6"

### 5-7 ###
dprime_temp_same <- subset(df4,df4$fname2=="5-5" | df4$fname2=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="5-7")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp5 <- dprime_temp3 %>%
  group_by(session,subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp5$stimulus <- "5-7"

dprime_id <- data.frame()
dprime_id <- rbind(dprime_id_temp1,dprime_id_temp2,dprime_id_temp3,dprime_id_temp4,dprime_id_temp4,dprime_id_temp5)


# create dprime by stimulus figure 
# boxplot
ggplot(dprime_id,aes(x=stimulus,y=dprime)) + 
  geom_boxplot(position="dodge",aes(fill=session)) +
  scale_fill_brewer('Session #',palette = "Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

# lineplot
dprime_lineplot <- summarySE(dprime_id, measurevar="dprime",groupvars = c("session","stimulus"))

ggplot(dprime_lineplot,aes(x=stimulus,y=dprime,group=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_brewer('Session',palette="Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

# lineplot with smoooth
ggplot(dprime_id,aes(x=stimulus,y=dprime,group=session,fill=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3) +
  geom_smooth(aes(color=session)) +
  scale_color_brewer('Session',palette="Purples") +
  scale_fill_brewer('Session',palette="Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

  
# create dprime by stimulus figure for session 3 to compare to sine
dprime_id_session3 <- subset(dprime_id,session==3)
ggplot(dprime_id_session3,aes(x=stimulus,y=dprime)) + 
  geom_point() +
  geom_bar(position="dodge",aes(fill=stimulus),stat="summary",fun.y=mean,alpha=0.3) +
  scale_fill_manual('#',labels=c("1","2","3","4","5"),values=c("purple","purple","purple","purple","purple")) +
  guides(fill=FALSE) +
  theme_dark() +
  theme(text = element_text(size=20))


#### PHONETIC CATEGORIZATION ####

# subset continuum data
continuum <- subset(df,df$block=="continuum")

# subset vowel sessions
continuum <- subset(continuum,continuum$session!="S3")

# drop NA trials and trials where people hit the wrong button
continuum <- subset(continuum,continuum$response!="None")
continuum <- subset(continuum,continuum$response!="d")
continuum$response <- tolower(continuum$response)

# create binary response variable
continuum$cb <- ifelse(continuum$subject2==3|continuum$subject2==8|
                       continuum$subject2==11|continuum$subject2==12|
                       continuum$subject2==15|continuum$subject2==16|
                       continuum$subject2==20|continuum$subject2==24|
                       continuum$subject2==27|continuum$subject2==28|
                       continuum$subject2==31|continuum$subject2==32,"cb1","cb2")
continuumCB1 <- subset(continuum,continuum$cb=="cb1")
continuumCB2 <- subset(continuum,continuum$cb=="cb2")
continuumCB1$resp1 <- ifelse(continuumCB1$response=="a",1,0)
continuumCB2$resp1 <- ifelse(continuumCB2$response=="a",0,1)
continuum <- rbind(continuumCB1,continuumCB2)

# create 'step' variable
continuum$step <- substr(continuum$fname,10,10)

# plot by sessions
stats <- summarySE(continuum, measurevar="resp1",groupvars = c("step","session"))
stats <- summarySE(continuum, measurevar="resp1",groupvars = c("step","session","subject2"))

ggplot(stats, aes(x=as.numeric(step), y=resp1,color=factor(session))) +
  geom_point(stat='summary', fun.y='mean', size=3,alpha=0.7) +
  geom_line(stat='summary', fun.y='mean', size=1.25, alpha=0.7) +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  facet_wrap(~subject2) +
  scale_x_continuous('/i/ to /y/ continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  scale_color_brewer('Session', labels=c('1','2','3'),palette="Purples") +
  coord_cartesian(ylim=c(0,1)) + 
  theme_dark() +
  theme(text = element_text(size=20))

# plot day 1 to compare to sine
continuum_vowel_day1 <- subset(continuum,session==1)
stats_vowel <- summarySE(continuum_vowel_day1, measurevar="resp1",groupvars = c("step"))

ggplot(stats_vowel, aes(x=as.numeric(step),y=resp1)) +
  geom_point(stat='summary', fun.y='mean', size=2.5,color="purple") +
  geom_line(stat='summary', fun.y='mean', size=0.75,color="purple") +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  #facet_wrap(~subject2) +
  scale_x_continuous('/i/ to /y/ continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme_dark() +
  theme(text = element_text(size=20))

# fit curves using quickpsy
readyforcurves <- subset(continuum,subject2!=10)
readyforcurves$session <- as.numeric(readyforcurves$session)
readyforcurves$subject2 <- as.numeric(readyforcurves$subject2)
readyforcurves$step <- as.numeric(readyforcurves$step)
readyforcurves <- na.omit(readyforcurves)
session.subject.curves <- quickpsy(readyforcurves, step, resp1, 
                        grouping = .(subject2), 
                        fun = logistic_fun,
                        lapses = FALSE, 
                        guess = FALSE,
                        bootstrap = "nonparametric", 
                        optimization = "optim",
                        B = 1000) 


#### SINE SESSIONS ####

# create training performance figure with training sublock on the X axis and session as grouping variable

# separate training data
training_figure_data <- subset(df,grepl("training",block))

# remove session 4
training_figure_data <- subset(training_figure_data,session!=4)

# subset sine training
training_figure_data_sine <- subset(training_figure_data,session=="S3")

# create figure
# version with error bars
stats3 <- summarySE(data=training_figure_data_sine, measurevar="correct_response",groupvars=c("block"))

ggplot(stats3,aes(x=block,y=correct_response,fill=block)) + 
  geom_bar(stat="identity",position="dodge") +
  geom_errorbar(aes(ymin=correct_response-se,ymax=correct_response+se),position=position_dodge(width=0.9)) + 
  scale_y_continuous('Percent accuracy',breaks=c(0.5,0.75,1),labels=c(50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette = "Purples") +
  coord_cartesian(ylim=c(0.4,1)) +
  theme_dark() +
  theme(text = element_text(size=20))

# overlay individual data points and group mean bars
id3 <- ddply(training_figure_data_sine,.(subject2,block),summarize,mean=mean(correct_response))

gd3 <- select(stats3,block,correct_response)
gd3 <- rename(gd3,mean=correct_response)
#gd <- id %>% 
 # group_by(block) %>% 
  #summarise(mean = mean(mean))

ggplot(id3,aes(x=block,y=mean)) +
  geom_point(aes(x=block),position = position_dodge(width=0.75)) + geom_bar(data=gd3,aes(fill=block),stat="identity",alpha=0.7,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_manual('Session #',labels=c("1","2","3"),values=c("green","green","green")) +
  coord_cartesian(ylim=c(0.4,1)) +
  guides(fill=FALSE,color=FALSE) +
  theme_dark() +
  theme(text=element_text(size=20))

### calculating d' for discrimination performance ###

# subset to just discrimination blocks
discrim_fig_data <- subset(df,grepl("discrimination",block))

# remove session 4
discrim_fig_data <- subset(discrim_fig_data,session!=4)

# subset sine training
discrim_fig_data_sine <- subset(discrim_fig_data,session=="S3")

# subset only post-test
discrim_fig_data_sine <- subset(discrim_fig_data_sine,grepl("posttest",block))

# create variable to combine forwards/backwards discrimination steps
discrim_fig_data_sine$fname2 <- ifelse(discrim_fig_data_sine$fname=="iyu_step_1-step_1.wav","1-1",
                                        ifelse(discrim_fig_data_sine$fname=="iyu_step_2-step_2.wav","2-2",
                                               ifelse(discrim_fig_data_sine$fname=="iyu_step_3-step_3.wav","3-3",
                                                      ifelse(discrim_fig_data_sine$fname=="iyu_step_4-step_4.wav","4-4",
                                                             ifelse(discrim_fig_data_sine$fname=="iyu_step_5-step_5.wav","5-5",
                                                                    ifelse(discrim_fig_data_sine$fname=="iyu_step_6-step_6.wav","6-6",
                                                                           ifelse(discrim_fig_data_sine$fname=="iyu_step_7-step_7.wav","7-7",
                                                                                  ifelse(discrim_fig_data_sine$fname=="iyu_step_1-step_3.wav","1-3",
                                                                                         ifelse(discrim_fig_data_sine$fname=="iyu_step_2-step_4.wav","2-4",
                                                                                                ifelse(discrim_fig_data_sine$fname=="iyu_step_3-step_5.wav","3-5",
                                                                                                       ifelse(discrim_fig_data_sine$fname=="iyu_step_4-step_6.wav","4-6",
                                                                                                              ifelse(discrim_fig_data_sine$fname=="iyu_step_5-step_7.wav","5-7",
                                                                                                                     ifelse(discrim_fig_data_sine$fname=="iyu_step_3-step_1.wav","1-3",
                                                                                                                            ifelse(discrim_fig_data_sine$fname=="iyu_step_4-step_2.wav","2-4",
                                                                                                                                   ifelse(discrim_fig_data_sine$fname=="iyu_step_5-step_3.wav","3-5",
                                                                                                                                          ifelse(discrim_fig_data_sine$fname=="iyu_step_6-step_4.wav","4-6",
                                                                                                                                                 ifelse(discrim_fig_data_sine$fname=="iyu_step_7-step_5.wav","5-7",NA)))))))))))))))))


discrim_fig_data_sine$condition <- ifelse(discrim_fig_data_sine$fname2=="1-1","same",
                                           ifelse(discrim_fig_data_sine$fname2=="2-2","same",
                                                  ifelse(discrim_fig_data_sine$fname2=="3-3","same",
                                                         ifelse(discrim_fig_data_sine$fname2=="4-4","same",
                                                                ifelse(discrim_fig_data_sine$fname2=="5-5","same",
                                                                       ifelse(discrim_fig_data_sine$fname2=="6-6","same",
                                                                              ifelse(discrim_fig_data_sine$fname2=="7-7","same",
                                                                                     ifelse(discrim_fig_data_sine$fname2=="1-3","different",
                                                                                            ifelse(discrim_fig_data_sine$fname2=="2-4","different",
                                                                                                   ifelse(discrim_fig_data_sine$fname2=="3-5","different",
                                                                                                          ifelse(discrim_fig_data_sine$fname2=="4-6","different",
                                                                                                                 ifelse(discrim_fig_data_sine$fname2=="5-7","different",NA))))))))))))

### calculate d' ###

# make a new data frame that contains the data we need
df1 <- discrim_fig_data_sine %>%
  group_by(subject2,condition) %>%
  summarize(prop_cor = mean(correct_response))

df1 <- df1 %>% mutate(prop_cor=ifelse(condition=="different",prop_cor,1-prop_cor))

df_final <- spread(df1, condition, prop_cor)

colnames(df_final) <- c("Subject","Hit","FA")

#we will use this closure to create two functions: one to change 1 to .99 and 
# one to change 0 to .01 (.99 and .01 still have to be specified though)
cutoff <- function(value) {
  function(x,y) {
    x[x == value] <- y
    x
  }
}

cutoff_1 <- cutoff(1)
cutoff_0 <- cutoff(0)

df_final$Hit <- cutoff_1(df_final$Hit,.99)
df_final$Hit <- cutoff_0(df_final$Hit,.01)
df_final$FA <- cutoff_1(df_final$FA,.99)
df_final$FA <- cutoff_0(df_final$FA,.01)

# make function for d', then apply it to each time point, participant, etc.
d_prime <- function(Hit, FA){
  qnorm(Hit) - qnorm(FA)
}

dprime <- df_final %>%
  group_by(Subject) %>%
  mutate(dprime = d_prime(Hit,FA))

dprime <- dprime %>% select(-c(Hit,FA))
dprime$key <- 1

# create dprime by session figure 

ggplot(dprime,aes(x=key,y=dprime)) + 
  geom_boxplot(position="dodge",aes(fill=as.factor(key))) +
  geom_point(position = position_dodge(width=0.75)) +
  scale_fill_manual(values="green") +
  theme_dark() +
  theme(text = element_text(size=20))

### calculate d' for each stimulus ###
# make a new data frame that contains the data we need

df4 <- discrim_fig_data_sine %>%
  group_by(subject2,condition,fname2) %>%
  summarize(prop_cor = mean(correct_response))

df4 <- df4 %>% mutate(prop_incor=1-prop_cor)

# we will use this closure to create two functions: one to change 1 to .99 and 
# one to change 0 to .01 (.99 and .01 still have to be specified though)
cutoff <- function(value) {
  function(x,y) {
    x[x == value] <- y
    x
  }
}

cutoff_1 <- cutoff(1)
cutoff_0 <- cutoff(0)

df4$prop_cor <- cutoff_1(df4$prop_cor,.99)
df4$prop_cor <- cutoff_0(df4$prop_cor,.01)
df4$prop_incor <- cutoff_1(df4$prop_incor,.99)
df4$prop_incor <- cutoff_0(df4$prop_incor,.01)

# make function for d', then apply it to each stimulus

# 1-3 
dprime_temp_same <- subset(df4,df4$fname2=="1-1" | df4$fname2=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="1-3")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp1 <- dprime_temp3 %>%
  group_by(subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp1$stimulus <- "1-3"

# 2-4
dprime_temp_same <- subset(df4,df4$fname2=="2-2" | df4$fname2=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="2-4")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp2 <- dprime_temp3 %>%
  group_by(subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp2$stimulus <- "2-4"

# 3-5
dprime_temp_same <- subset(df4,df4$fname2=="3-3" | df4$fname2=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="3-5")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp3 <- dprime_temp3 %>%
  group_by(subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp3$stimulus <- "3-5"

# 4-6
dprime_temp_same <- subset(df4,df4$fname2=="4-4" | df4$fname2=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="4-6")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp4 <- dprime_temp3 %>%
  group_by(subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp4$stimulus <- "4-6"

# 5-7
dprime_temp_same <- subset(df4,df4$fname2=="5-5" | df4$fname2=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(df4,df4$fname2=="5-7")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3 <- spread(dprime_temp3, condition, mean)

dprime_id_temp5 <- dprime_temp3 %>%
  group_by(subject2) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_id_temp5$stimulus <- "5-7"

dprime_id <- data.frame()
dprime_id <- rbind(dprime_id_temp1,dprime_id_temp2,dprime_id_temp3,dprime_id_temp4,dprime_id_temp4,dprime_id_temp5)


# create dprime by stimulus figure 
ggplot(dprime_id,aes(x=stimulus,y=dprime,fill=stimulus)) + 
  geom_boxplot(position="dodge") +
  scale_fill_manual('#',labels=c("1","2","3","4","5"),values=c("green","green","green","green","green")) +
  guides(fill=FALSE,color=FALSE) +
  theme_dark() +
  theme(text = element_text(size=20))

ggplot(dprime_id,aes(x=stimulus,y=dprime)) + 
  geom_point() +
  geom_bar(position="dodge",aes(fill=stimulus),stat="summary",fun.y=mean,alpha=0.3) +
  scale_fill_manual('#',labels=c("1","2","3","4","5"),values=c("green","green","green","green","green")) +
  guides(fill=FALSE) +
  theme_dark() +
  theme(text = element_text(size=20))

### SINE PHONETIC CATEGORIZATION

# subset continuum data
continuum <- subset(df,df$block=="continuum")

# subset sine sessions
continuum_sine <- subset(continuum,continuum$session=="S3")

# drop NA trials and trials where people hit the wrong button
continuum_sine <- subset(continuum_sine,continuum_sine$response!="None")
continuum_sine <- subset(continuum_sine,continuum_sine$response!="d")
continuum_sine$response <- tolower(continuum_sine$response)

# create binary response variable
continuum_sine$cb <- ifelse(continuum_sine$subject2==3|continuum_sine$subject2==11|continuum_sine$subject2==15|continuum_sine$subject2==20,"cb1","cb2")
continuum_sineCB1 <- subset(continuum_sine,continuum_sine$cb=="cb1")
continuum_sineCB2 <- subset(continuum_sine,continuum_sine$cb=="cb2")
continuum_sineCB1$resp1 <- ifelse(continuum_sineCB1$response=="a",1,0)
continuum_sineCB2$resp1 <- ifelse(continuum_sineCB2$response=="a",0,1)
continuum_sine <- rbind(continuum_sineCB1,continuum_sineCB2)

# create 'step' variable
continuum_sine$step <- substr(continuum_sine$fname,9,9)

stats_sine <- summarySE(continuum_sine, measurevar="resp1",groupvars = c("step"))

ggplot(stats_sine, aes(x=as.numeric(step),y=resp1)) +
  geom_point(stat='summary', fun.y='mean', size=2.5,color="green") +
  geom_line(stat='summary', fun.y='mean', size=0.75,color="green") +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  #facet_wrap(~subject2) +
  scale_x_continuous('/i/ to /y/ continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme_dark() +
  theme(text = element_text(size=20))

#### MIXED EFFECTS MODELS ####

# split data into vowel and sine
vowel.mod.data <- subset(df,session!="S3")
sine.mod.data <- subset(df,session=="S3")

# VOWEL

# create variable to treat each pre and post-test from each session as a unique session
vowel.mod.data <- subset(vowel.mod.data,grepl("discrimination",block)==TRUE)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="pretest_discrimination" & vowel.mod.data$session==1,1,NA)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="posttest_discrimination" & vowel.mod.data$session==1,2,vowel.mod.data$block.session)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="pretest_discrimination" & vowel.mod.data$session==2,3,vowel.mod.data$block.session)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="posttest_discrimination" & vowel.mod.data$session==2,4,vowel.mod.data$block.session)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="pretest_discrimination" & vowel.mod.data$session==3,5,vowel.mod.data$block.session)
vowel.mod.data$block.session <- ifelse(vowel.mod.data$block=="posttest_discrimination" & vowel.mod.data$session==3,6,vowel.mod.data$block.session)

## create variable to combine forwards/backwards discrimination steps
vowel.mod.data$fname2 <- ifelse(vowel.mod.data$fname=="i-y-u_step1-step1.wav","1-1",
                                        ifelse(vowel.mod.data$fname=="i-y-u_step2-step2.wav","2-2",
                                               ifelse(vowel.mod.data$fname=="i-y-u_step3-step3.wav","3-3",
                                                      ifelse(vowel.mod.data$fname=="i-y-u_step4-step4.wav","4-4",
                                                             ifelse(vowel.mod.data$fname=="i-y-u_step5-step5.wav","5-5",
                                                                    ifelse(vowel.mod.data$fname=="i-y-u_step6-step6.wav","6-6",
                                                                           ifelse(vowel.mod.data$fname=="i-y-u_step7-step7.wav","7-7",
                                                                                  ifelse(vowel.mod.data$fname=="i-y-u_step_1-step_3.wav","1-3",
                                                                                         ifelse(vowel.mod.data$fname=="i-y-u_step_2-step_4.wav","2-4",
                                                                                                ifelse(vowel.mod.data$fname=="i-y-u_step_3-step_5.wav","3-5",
                                                                                                       ifelse(vowel.mod.data$fname=="i-y-u_step_4-step_6.wav","4-6",
                                                                                                              ifelse(vowel.mod.data$fname=="i-y-u_step_5-step_7.wav","5-7",
                                                                                                                     ifelse(vowel.mod.data$fname=="i-y-u_step_3-step_1.wav","1-3",
                                                                                                                            ifelse(vowel.mod.data$fname=="i-y-u_step_4-step_2.wav","2-4",
                                                                                                                                   ifelse(vowel.mod.data$fname=="i-y-u_step_5-step_3.wav","3-5",
                                                                                                                                          ifelse(vowel.mod.data$fname=="i-y-u_step_6-step_4.wav","4-6",
                                                                                                                                                 ifelse(vowel.mod.data$fname=="i-y-u_step_7-step_5.wav","5-7",NA)))))))))))))))))


vowel.mod.data$discrim.condition <- ifelse(vowel.mod.data$fname2=="1-1","same",
                                           ifelse(vowel.mod.data$fname2=="2-2","same",
                                                  ifelse(vowel.mod.data$fname2=="3-3","same",
                                                         ifelse(vowel.mod.data$fname2=="4-4","same",
                                                                ifelse(vowel.mod.data$fname2=="5-5","same",
                                                                       ifelse(vowel.mod.data$fname2=="6-6","same",
                                                                              ifelse(vowel.mod.data$fname2=="7-7","same",
                                                                                     ifelse(vowel.mod.data$fname2=="1-3","different",
                                                                                            ifelse(vowel.mod.data$fname2=="2-4","different",
                                                                                                   ifelse(vowel.mod.data$fname2=="3-5","different",
                                                                                                          ifelse(vowel.mod.data$fname2=="4-6","different",
                                                                                                                 ifelse(vowel.mod.data$fname2=="5-7","different",NA))))))))))))

## GLMM for % accuracy in discrimation ##

# prep data
vowel.mod.data <- subset(vowel.mod.data,discrim.condition=="different")
vowel.mod.data$block.session <- as.factor(vowel.mod.data$block.session)
contrasts(vowel.mod.data$block.session) = contr.sum(6)

# run models
model1 <- glmer(correct_response ~ block.session + (1|subject2),
                  data=vowel.mod.data, family='binomial',
                  control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 1500000)))
summary(model1)

# SINE
# create variable to treat each pre and post-test from each session as a unique session
sine.mod.data <- subset(sine.mod.data,grepl("discrimination",block)==TRUE)

## create variable to combine forwards/backwards discrimination steps
sine.mod.data$fname2 <- ifelse(sine.mod.data$fname=="iyu_step_1-step_1.wav","1-1",
                               ifelse(sine.mod.data$fname=="iyu_step_2-step_2.wav","2-2",
                                      ifelse(sine.mod.data$fname=="iyu_step_3-step_3.wav","3-3",
                                             ifelse(sine.mod.data$fname=="iyu_step_4-step_4.wav","4-4",
                                                    ifelse(sine.mod.data$fname=="iyu_step_5-step_5.wav","5-5",
                                                           ifelse(sine.mod.data$fname=="iyu_step_6-step_6.wav","6-6",
                                                                  ifelse(sine.mod.data$fname=="iyu_step_7-step_7.wav","7-7",
                                                                         ifelse(sine.mod.data$fname=="iyu_step_1-step_3.wav","1-3",
                                                                                ifelse(sine.mod.data$fname=="iyu_step_2-step_4.wav","2-4",
                                                                                       ifelse(sine.mod.data$fname=="iyu_step_3-step_5.wav","3-5",
                                                                                              ifelse(sine.mod.data$fname=="iyu_step_4-step_6.wav","4-6",
                                                                                                     ifelse(sine.mod.data$fname=="iyu_step_5-step_7.wav","5-7",
                                                                                                            ifelse(sine.mod.data$fname=="iyu_step_3-step_1.wav","1-3",
                                                                                                                   ifelse(sine.mod.data$fname=="iyu_step_4-step_2.wav","2-4",
                                                                                                                          ifelse(sine.mod.data$fname=="iyu_step_5-step_3.wav","3-5",
                                                                                                                                 ifelse(sine.mod.data$fname=="iyu_step_6-step_4.wav","4-6",
                                                                                                                                        ifelse(sine.mod.data$fname=="iyu_step_7-step_5.wav","5-7",NA)))))))))))))))))


sine.mod.data$discrim.condition <- ifelse(sine.mod.data$fname2=="1-1","same",
                                          ifelse(sine.mod.data$fname2=="2-2","same",
                                                 ifelse(sine.mod.data$fname2=="3-3","same",
                                                        ifelse(sine.mod.data$fname2=="4-4","same",
                                                               ifelse(sine.mod.data$fname2=="5-5","same",
                                                                      ifelse(sine.mod.data$fname2=="6-6","same",
                                                                             ifelse(sine.mod.data$fname2=="7-7","same",
                                                                                    ifelse(sine.mod.data$fname2=="1-3","different",
                                                                                           ifelse(sine.mod.data$fname2=="2-4","different",
                                                                                                  ifelse(sine.mod.data$fname2=="3-5","different",
                                                                                                         ifelse(sine.mod.data$fname2=="4-6","different",
                                                                                                                ifelse(sine.mod.data$fname2=="5-7","different",NA))))))))))))

## GLMM for % accuracy in discrimation ##
# prep data
sine.mod.data <- subset(sine.mod.data,discrim.condition=="different")
sine.mod.data$block <- as.factor(sine.mod.data$block)
contrasts(sine.mod.data$block) = contr.sum(2)

# run models
sine.model1 <- glmer(correct_response ~ block + (block|subject2),
                data=sine.mod.data, family='binomial',
                control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 1500000)))
summary(sine.model1)
