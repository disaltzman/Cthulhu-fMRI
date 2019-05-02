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
library(afex)
library(ggrepel)
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

# various housekeeping things
df$correct_response <- as.numeric(df$correct_response)
df$trial <- as.numeric(df$trial)
df$rt <- as.numeric(df$rt)
# chop off session indicator numbers to get base subject number
df$subject2 <- ifelse(nchar(df$subject)==3,substr(df$subject,1,1),substr(df$subject,1,2))
df$subject2 <- as.numeric(df$subject2)

# SESSION 1 DESCRIPTIVES ####

# split by session 
session1 <- subset(df,session == 1)
session2 <- subset(df,session == 2)
session3 <- subset(df,session == 3)
session4 <- subset(df,session == 4)
sine <- subset(df,session == "S3")

# split by block for session1
pretest1 <- subset(session1,block == "pretest_discrimination")
posttest1 <- subset(session1,block == "posttest_discrimination")
training1.1 <- subset(session1,block == "training1")
training1.2 <- subset(session1,block == "training2")
training1.3 <- subset(session1,block == "training3")
continuum1 <- subset(session1,block == "continuum")

# create pretest performance figure
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step2-step2.wav","2-2",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step3-step3.wav","3-3",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step4-step4.wav","4-4",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step5-step5.wav","5-5",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step6-step6.wav","6-6",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step7-step7.wav","7-7",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_1-step_3.wav","1-3",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_2-step_4.wav","2-4",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_3-step_5.wav","3-5",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_4-step_6.wav","4-6",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_5-step_7.wav","5-7",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_3-step_1.wav","1-3",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_4-step_2.wav","2-4",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_5-step_3.wav","3-5",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_6-step_4.wav","4-6",pretest1$discrim.token)
pretest1$discrim.token <- ifelse(pretest1$fname=="i-y-u_step_7-step_5.wav","5-7",pretest1$discrim.token)

pretest1_figure = ddply(pretest1,.(discrim.token),summarize,mean=mean(correct_response))

pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="1-1","same",NA)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="2-2","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="3-3","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="4-4","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="5-5","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="6-6","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="7-7","same",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="1-3","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="2-4","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="3-5","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="4-6","different",pretest1_figure$condition)
pretest1_figure$condition <- ifelse(pretest1_figure$discrim.token=="5-7","different",pretest1_figure$condition)


pretest1_figure$discrim.token <- as.factor(pretest1_figure$discrim.token)
pretest1_figure$fname3 <- sortLvls.fnc(pretest1_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest1_barplot <- ggplot(pretest1_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 1")

#### create posttest performance figure
# create variable to combine forwards/backwards discrimination steps
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step2-step2.wav","2-2",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step3-step3.wav","3-3",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step4-step4.wav","4-4",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step5-step5.wav","5-5",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step6-step6.wav","6-6",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step7-step7.wav","7-7",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_1-step_3.wav","1-3",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_2-step_4.wav","2-4",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_3-step_5.wav","3-5",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_4-step_6.wav","4-6",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_5-step_7.wav","5-7",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_3-step_1.wav","1-3",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_4-step_2.wav","2-4",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_5-step_3.wav","3-5",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_6-step_4.wav","4-6",posttest1$discrim.token)
posttest1$discrim.token <- ifelse(posttest1$fname=="i-y-u_step_7-step_5.wav","5-7",posttest1$discrim.token)

# create dataframe with posttest1 accuracy by item
posttest1_figure = ddply(posttest1,.(discrim.token),summarize,mean=mean(correct_response))

posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="1-1","same",NA)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="2-2","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="3-3","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="4-4","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="5-5","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="6-6","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="7-7","same",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="1-3","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="2-4","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="3-5","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="4-6","different",posttest1_figure$condition)
posttest1_figure$condition <- ifelse(posttest1_figure$discrim.token=="5-7","different",posttest1_figure$condition)

posttest1_figure$discrim.token <- as.factor(posttest1_figure$discrim.token)
posttest1_figure$fname3 <- sortLvls.fnc(posttest1_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest1_barplot <- ggplot(posttest1_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 1")





# SESSION 2 DESCRIPTIVES ####

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
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step2-step2.wav","2-2",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step3-step3.wav","3-3",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step4-step4.wav","4-4",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step5-step5.wav","5-5",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step6-step6.wav","6-6",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step7-step7.wav","7-7",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_1-step_3.wav","1-3",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_2-step_4.wav","2-4",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_3-step_5.wav","3-5",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_4-step_6.wav","4-6",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_5-step_7.wav","5-7",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_3-step_1.wav","1-3",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_4-step_2.wav","2-4",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_5-step_3.wav","3-5",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_6-step_4.wav","4-6",pretest2$discrim.token)
pretest2$discrim.token <- ifelse(pretest2$fname=="i-y-u_step_7-step_5.wav","5-7",pretest2$discrim.token)

pretest2_figure = ddply(pretest2,.(discrim.token),summarize,mean=mean(correct_response))

pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="1-1","same",NA)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="2-2","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="3-3","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="4-4","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="5-5","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="6-6","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="7-7","same",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="1-3","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="2-4","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="3-5","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="4-6","different",pretest2_figure$condition)
pretest2_figure$condition <- ifelse(pretest2_figure$discrim.token=="5-7","different",pretest2_figure$condition)

pretest2_figure$discrim.token <- as.factor(pretest2_figure$discrim.token)
pretest2_figure$fname3 <- sortLvls.fnc(pretest2_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest2_barplot <- ggplot(pretest2_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 2")


#### create posttest2 performance figure
# create variable to combine forwards/backwards discrimination steps
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step2-step2.wav","2-2",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step3-step3.wav","3-3",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step4-step4.wav","4-4",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step5-step5.wav","5-5",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step6-step6.wav","6-6",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step7-step7.wav","7-7",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_1-step_3.wav","1-3",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_2-step_4.wav","2-4",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_3-step_5.wav","3-5",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_4-step_6.wav","4-6",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_5-step_7.wav","5-7",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_3-step_1.wav","1-3",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_4-step_2.wav","2-4",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_5-step_3.wav","3-5",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_6-step_4.wav","4-6",posttest2$discrim.token)
posttest2$discrim.token <- ifelse(posttest2$fname=="i-y-u_step_7-step_5.wav","5-7",posttest2$discrim.token)

# create dataframe with posttest2 accuracy by item
posttest2_figure = ddply(posttest2,.(discrim.token),summarize,mean=mean(correct_response))

posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="1-1","same",NA)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="2-2","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="3-3","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="4-4","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="5-5","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="6-6","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="7-7","same",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="1-3","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="2-4","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="3-5","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="4-6","different",posttest2_figure$condition)
posttest2_figure$condition <- ifelse(posttest2_figure$discrim.token=="5-7","different",posttest2_figure$condition)

posttest2_figure$discrim.token <- as.factor(posttest2_figure$discrim.token)
posttest2_figure$fname3 <- sortLvls.fnc(posttest2_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest2_barplot <- ggplot(posttest2_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 2")







# SESSION 3 DESCRIPTIVES ####

# split by block for session3
pretest3 <- subset(session3,block == "pretest_discrimination")
posttest3 <- subset(session3,block == "posttest_discrimination")
training3.1 <- subset(session3,block == "training1")
training3.2 <- subset(session3,block == "training2")
training3.3 <- subset(session3,block == "training3")
continuum3 <- subset(session3,block == "continuum")

# summarize performance by subject
pretest3_performance = ddply(pretest3,.(subject2),summarize,mean=mean(correct_response))
posttest3_performance = ddply(posttest3,.(subject2),summarize,mean=mean(correct_response))
training3.1_performance = ddply(training3.1,.(subject2),summarize,mean=mean(correct_response))
training3.2_performance = ddply(training3.2,.(subject2),summarize,mean=mean(correct_response))
training3.3_performance = ddply(training3.3,.(subject2),summarize,mean=mean(correct_response))

# create pretest performance figure
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step2-step2.wav","2-2",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step3-step3.wav","3-3",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step4-step4.wav","4-4",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step5-step5.wav","5-5",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step6-step6.wav","6-6",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step7-step7.wav","7-7",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_1-step_3.wav","1-3",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_2-step_4.wav","2-4",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_3-step_5.wav","3-5",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_4-step_6.wav","4-6",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_5-step_7.wav","5-7",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_3-step_1.wav","1-3",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_4-step_2.wav","2-4",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_5-step_3.wav","3-5",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_6-step_4.wav","4-6",pretest3$discrim.token)
pretest3$discrim.token <- ifelse(pretest3$fname=="i-y-u_step_7-step_5.wav","5-7",pretest3$discrim.token)

pretest3_figure = ddply(pretest3,.(discrim.token),summarize,mean=mean(correct_response))

pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="1-1","same",NA)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="2-2","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="3-3","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="4-4","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="5-5","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="6-6","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="7-7","same",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="1-3","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="2-4","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="3-5","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="4-6","different",pretest3_figure$condition)
pretest3_figure$condition <- ifelse(pretest3_figure$discrim.token=="5-7","different",pretest3_figure$condition)


pretest3_figure$discrim.token <- as.factor(pretest3_figure$discrim.token)
pretest3_figure$fname3 <- sortLvls.fnc(pretest3_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

pretest3_barplot <- ggplot(pretest3_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Pre-Test Day 3")

#### create posttest3 performance figure
# create variable to combine forwards/backwards discrimination steps
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step2-step2.wav","2-2",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step3-step3.wav","3-3",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step4-step4.wav","4-4",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step5-step5.wav","5-5",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step6-step6.wav","6-6",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step7-step7.wav","7-7",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_1-step_3.wav","1-3",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_2-step_4.wav","2-4",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_3-step_5.wav","3-5",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_4-step_6.wav","4-6",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_5-step_7.wav","5-7",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_3-step_1.wav","1-3",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_4-step_2.wav","2-4",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_5-step_3.wav","3-5",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_6-step_4.wav","4-6",posttest3$discrim.token)
posttest3$discrim.token <- ifelse(posttest3$fname=="i-y-u_step_7-step_5.wav","5-7",posttest3$discrim.token)

# create dataframe with posttest3 accuracy by item
posttest3_figure = ddply(posttest3,.(discrim.token),summarize,mean=mean(correct_response))

posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="1-1","same",NA)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="2-2","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="3-3","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="4-4","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="5-5","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="6-6","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="7-7","same",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="1-3","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="2-4","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="3-5","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="4-6","different",posttest3_figure$condition)
posttest3_figure$condition <- ifelse(posttest3_figure$discrim.token=="5-7","different",posttest3_figure$condition)

posttest3_figure$discrim.token <- as.factor(posttest3_figure$discrim.token)
posttest3_figure$fname3 <- sortLvls.fnc(posttest3_figure$discrim.token, c(1,3,5,7,9,11,12,2,4,6,8,10))

posttest3_barplot <- ggplot(posttest3_figure,aes(x=fname3,y=mean,fill=condition)) + geom_bar(stat="identity") + ggtitle(label="Post-Test Day 3")


# SESSION 4 DESCRIPTIVES ####

session4_performance = ddply(session4,.(subject,block),summarize,mean=mean(correct_response))

# bar plot for session 4
ggplot(session4_performance,aes(x=subject,y=mean)) + geom_bar(stat="identity",position="dodge",aes(fill=block)) + 
  geom_hline(yintercept=0.8,linetype="dashed")
                              

# SINE SESSION DESCRIPTIVES ####

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


# TRAINING DESCRIPTIVES & ANALYSIS ####

# separate training data
training <- subset(df,grepl("training",block))

# remove session 4
training <- subset(training,session!=4)

# subset vowel training
training.vowel <- subset(training,session!="S3")

# calculate error bars
training.stats <- summarySE(data=training.vowel, measurevar="correct_response",groupvars=c("subject2","block","session"))

# calculate number of blocks completed
training.stats$blocks.complete <- ifelse(training.stats$N<62,1,
                                         ifelse(training.stats$N>61&training.stats$N<120,2,
                                                ifelse(training.stats$N>120&training.stats$N<182,3,NA)))
# summarize
training.stats.avg <- ddply(training.stats,.(block,session,blocks.complete),summarize,mean=mean(correct_response))

#bar graph
ggplot(training.stats,aes(x=block,y=correct_response)) + 
  geom_bar(stat="summary",position="dodge",aes(fill=session),fun.y='mean') +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette = "Purples") +
  theme_dark() +
  theme(text = element_text(size=20))

# overlay individual data points and group mean bars
id <- ddply(training.stats,.(subject2,block,session,blocks.complete),summarize,mean=mean(correct_response))
stats <- summarySE(data=training.stats, measurevar="correct_response",groupvars=c("block","session"))
gd <- select(stats,block,session,correct_response)
gd <- rename(gd,mean=correct_response)

# across session
ggplot(id,aes(x=block,y=mean)) +
  geom_point(aes(x=block,color=session,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=gd,aes(fill=session),stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Session #',palette="Set1") +
  scale_color_brewer('Session #',palette="Set1") +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=20))

# # collapse session
# stats2 <- summarySE(data=training_figure_data_vowel, measurevar="correct_response",groupvars=c("block"))
# id2 <- ddply(training_figure_data_vowel,.(block,subject2),summarize,mean=mean(correct_response))
# gd2 <- select(stats2,block,correct_response)
# gd2<- rename(gd2,mean=correct_response)
# 
# ggplot(id2,aes(x=block,y=mean)) +
#   geom_point(aes(x=block),position = position_dodge(width=0.75)) + geom_bar(data=gd2,aes(fill=block),stat="identity",position="dodge",alpha=0.3) +
#   scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
#   scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
#   coord_cartesian(ylim=c(0.4,1)) +
#   scale_fill_manual('Block',labels=c("1","2","3"),values=c("purple","purple","purple")) +
#   guides(fill=FALSE) +
#   theme_dark() +
#   theme(text=element_text(size=20))

# mixed effects model
training.vowel$block <- as.factor(training.vowel$block)
training.vowel$session <- as.factor(training.vowel$session)
training.vowel$subject2 <- as.factor(training.vowel$subject2)

# add number of completed blocks to the training data
for (i in unique(training.vowel$block)){
  for (s in unique(training.vowel$session)){
    for (f in unique(training.vowel$subject2)){
      blocklength <- length(which(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f))
      training.vowel$blocks.complete <- ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength<62,1,
                                         ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength>61&blocklength<120,2,
                                                ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength>120&blocklength<182,3,
                                                       training.vowel$blocks.complete)))
    }
  }
}
training$blocks.complete <- as.factor(training$blocks.complete)

training.model1 <- glmer(correct_response ~ block*session + (block:session||subject2) +
                           (block||subject2) + (session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)))

training.model2 <- glmer(correct_response ~ block*session + (block:session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)))

training.model3 <- glmer(correct_response ~ block*session +
                           (block||subject2) + (session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)))

training.model4 <- glmer(correct_response ~ block*session + (1|subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 100000)))

afex.training.model <- mixed(correct_response ~ block*session + (1|subject2), family=binomial(link="logit"),data=training.vowel,method="LRT")

anova(training.model1,training.model2,training.model3,training.model4)
summary(training.model3)

# CALCULATING D' FOR VOWEL DISCRIM ####

# subset to just discrimination blocks
discrim <- subset(df,grepl("discrimination",block))

# remove session 4
discrim <- subset(discrim,session!=4)

# subset vowel
discrim.vowel <- subset(discrim,session!="S3")

# create variable to combine forwards/backwards discrimination steps
discrim.vowel$discrim.token <- ifelse(discrim.vowel$fname=="i-y-u_step1-step1.wav","1-1",
                               ifelse(discrim.vowel$fname=="i-y-u_step2-step2.wav","2-2",
                               ifelse(discrim.vowel$fname=="i-y-u_step3-step3.wav","3-3",
                               ifelse(discrim.vowel$fname=="i-y-u_step4-step4.wav","4-4",
                               ifelse(discrim.vowel$fname=="i-y-u_step5-step5.wav","5-5",
                               ifelse(discrim.vowel$fname=="i-y-u_step6-step6.wav","6-6",
                               ifelse(discrim.vowel$fname=="i-y-u_step7-step7.wav","7-7",
                               ifelse(discrim.vowel$fname=="i-y-u_step_1-step_3.wav","1-3",
                               ifelse(discrim.vowel$fname=="i-y-u_step_2-step_4.wav","2-4",
                               ifelse(discrim.vowel$fname=="i-y-u_step_3-step_5.wav","3-5",
                               ifelse(discrim.vowel$fname=="i-y-u_step_4-step_6.wav","4-6",
                               ifelse(discrim.vowel$fname=="i-y-u_step_5-step_7.wav","5-7",
                               ifelse(discrim.vowel$fname=="i-y-u_step_3-step_1.wav","1-3",
                               ifelse(discrim.vowel$fname=="i-y-u_step_4-step_2.wav","2-4",
                               ifelse(discrim.vowel$fname=="i-y-u_step_5-step_3.wav","3-5",
                               ifelse(discrim.vowel$fname=="i-y-u_step_6-step_4.wav","4-6",
                               ifelse(discrim.vowel$fname=="i-y-u_step_7-step_5.wav","5-7",NA)))))))))))))))))


discrim.vowel$condition <- ifelse(discrim.vowel$discrim.token=="1-1","same",
                           ifelse(discrim.vowel$discrim.token=="2-2","same",
                           ifelse(discrim.vowel$discrim.token=="3-3","same",
                           ifelse(discrim.vowel$discrim.token=="4-4","same",
                           ifelse(discrim.vowel$discrim.token=="5-5","same",
                           ifelse(discrim.vowel$discrim.token=="6-6","same",
                           ifelse(discrim.vowel$discrim.token=="7-7","same",
                           ifelse(discrim.vowel$discrim.token=="1-3","different",
                           ifelse(discrim.vowel$discrim.token=="2-4","different",
                           ifelse(discrim.vowel$discrim.token=="3-5","different",
                           ifelse(discrim.vowel$discrim.token=="4-6","different",
                           ifelse(discrim.vowel$discrim.token=="5-7","different",NA))))))))))))

# subset only post-test
# discrim.vowel.pretest <- subset(discrim.vowel,grepl("pretest",block))
# discrim.vowel <- subset(discrim.vowel,grepl("posttest",block))

  # d’ averaging across stimuli ======

# make a new data frame that contains the data we need
dprime.average <- discrim.vowel %>%
  group_by(session,subject2,condition,block) %>%
  summarize(prop_cor=mean(correct_response))

# calculate hits and false alarms on different trials
dprime.average <- dprime.average %>% mutate(prop_cor=ifelse(condition=="different",prop_cor,1-prop_cor))
dprime.average <- spread(dprime.average, condition, prop_cor)
colnames(dprime.average) <- c("Session","Subject","Block","Hit","FA")

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

dprime.average$Hit <- cutoff_1(dprime.average$Hit,.99)
dprime.average$Hit <- cutoff_0(dprime.average$Hit,.01)
dprime.average$FA <- cutoff_1(dprime.average$FA,.99)
dprime.average$FA <- cutoff_0(dprime.average$FA,.01)

# make function for d', then apply it to each time point, participant, etc.
d_prime <- function(Hit, FA){
  qnorm(Hit) - qnorm(FA)
}

dprime <- dprime.average %>%
  group_by(Session,Subject,Block) %>%
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

  # d' for each stimulus ====

# make a new data frame that contains the data we need

dprime.stimulus <- discrim.vowel %>%
  group_by(session,subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

dprime.stimulus <- dprime.stimulus %>% mutate(prop_incor=1-prop_cor)

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

dprime.stimulus$prop_cor <- cutoff_1(dprime.stimulus$prop_cor,.99)
dprime.stimulus$prop_cor <- cutoff_0(dprime.stimulus$prop_cor,.01)
dprime.stimulus$prop_incor <- cutoff_1(dprime.stimulus$prop_incor,.99)
dprime.stimulus$prop_incor <- cutoff_0(dprime.stimulus$prop_incor,.01)

### 1-3 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="1-1" | dprime.stimulus$discrim.token=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="1-3")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp1_3 <- rbind(dprime_temp_same,dprime_temp_different)
  
d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp1_3 <- spread(dprime_temp1_3, condition, mean)

dprime_temp1_3 <- dprime_temp1_3 %>%
  group_by(session,subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp1_3$stimulus <- "1-3"

### 2-4 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="2-2" | dprime.stimulus$discrim.token=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="2-4")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp2_4 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp2_4 <- spread(dprime_temp2_4, condition, mean)

dprime_temp2_4 <- dprime_temp2_4 %>%
  group_by(session,subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp2_4$stimulus <- "2-4"

### 3-5 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="3-3" | dprime.stimulus$discrim.token=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="3-5")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3_5 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3_5 <- spread(dprime_temp3_5, condition, mean)

dprime_temp3_5 <- dprime_temp3_5 %>%
  group_by(session,subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp3_5$stimulus <- "3-5"

### 4-6 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="4-4" | dprime.stimulus$discrim.token=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="4-6")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp4_6 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp4_6 <- spread(dprime_temp4_6, condition, mean)

dprime_temp4_6 <- dprime_temp4_6 %>%
  group_by(session,subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp4_6$stimulus <- "4-6"

### 5-7 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="5-5" | dprime.stimulus$discrim.token=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="5-7")
dprime_temp_different <- ddply(dprime_temp_different,.(session,subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp5_7 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp5_7 <- spread(dprime_temp5_7, condition, mean)

dprime_temp5_7 <- dprime_temp5_7 %>%
  group_by(session,subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp5_7$stimulus <- "5-7"

dprime_id <- data.frame()
dprime_id <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# create dprime by stimulus figure 
# boxplot
# ggplot(dprime_id,aes(x=stimulus,y=dprime)) + 
#   geom_boxplot(position="dodge",aes(fill=session)) +
#   scale_fill_brewer('Session #',palette = "Purples") +
#   theme_dark() +
#   theme(text = element_text(size=20))

# lineplot group average
dprime_lineplot <- summarySE(dprime_id, measurevar="dprime",groupvars = c("session","stimulus","block"))
dprime_lineplot$plotting <- ifelse(dprime_lineplot$session==1&dprime_lineplot$block=="pretest_discrimination",1,
                                   ifelse(dprime_lineplot$session==2&dprime_lineplot$block=="pretest_discrimination",2,
                                          ifelse(dprime_lineplot$session==3&dprime_lineplot$block=="pretest_discrimination",3,
                                                 ifelse(dprime_lineplot$session==1&dprime_lineplot$block=="posttest_discrimination",4,
                                                        ifelse(dprime_lineplot$session==2&dprime_lineplot$block=="posttest_discrimination",5,
                                                               ifelse(dprime_lineplot$session==3&dprime_lineplot$block=="posttest_discrimination",6,""))))))
                                                                      
                                                               
ggplot(dprime_lineplot,aes(x=stimulus,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_brewer('Session',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20))

# lineplot by individual
ggplot(dprime_id,aes(x=stimulus,y=dprime,group=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session),stat='summary', fun.y='mean', size=2) +
  scale_color_brewer('Session',palette="Purples") +
  facet_wrap(~subject2) +
  theme_dark() +
  theme(text = element_text(size=20))

  # find peak discrimination token for each participant =====
peak.discrim <- dprime_id %>% group_by(subject2,session,block) %>% slice(which.max(dprime))
peak.discrim <- select(peak.discrim,"session","subject2","dprime","stimulus","block")
# peak discrim for use as MRI regressor
peak.discrim.regressor <- dprime_id %>% group_by(subject2,session) %>% slice(which.max(dprime))
peak.discrim.regressor <- subset(peak.discrim.regressor,session==3)
peak.discrim.regressor <- select(peak.discrim.regressor,"subject2","dprime")
# combine with category boundaries
load("boundaries.Rda")

# create figure before rounding boundaries
ggplot(boundaries,aes(x=session,y=Boundary,group=factor(subject2)),label=subject2) + 
  geom_point(size=3) +
  geom_line(aes(group=factor(subject2),color=factor(subject2)),size=1.5) +
  geom_label_repel(label=boundaries$subject2) +
  scale_color_discrete(guide=F) +
  ylim(0,7) +
  theme(text = element_text(size=20))

# mixed effects model
bound.model <- mixed(Boundary ~ session + (1|subject2),data=boundaries)
bound.model

# round boundaries
boundaries <- boundaries[rep(1:nrow(boundaries),2),]
boundaries$block[1:78] <- "pretest_discrimination"
boundaries$block[1.1:78.1] <- "posttest_discrimination"
boundaries$Boundary <- round(boundaries$Boundary)

# look at peak discrim token and boundaries
peak.discrim$boundary <- boundaries$Boundary
peak.discrim <- subset(peak.discrim,boundary!=-8)
ggplot(peak.discrim,aes(x=stimulus,y=boundary,color=session,label=subject2)) + 
  scale_y_continuous('boundary') +
  ylim(0,7) + xlab('Peak discrimination stimulus') + geom_label_repel(aes(label=subject2,color=session)) +
  theme(text = element_text(size=20))

# use this information to determine what is between-category and what is within-category
dprime_id$boundary <- NA
for (i in unique(dprime_id$subject2)){
  for (s in unique(dprime_id$session)){
    temp.boundaries <- boundaries[boundaries$subject2==i & boundaries$session==s,"Boundary"]
    dprime_id$boundary <- ifelse(dprime_id$subject2==i & dprime_id$session==s,temp.boundaries,dprime_id$boundary)
  }
}

dprime_id$discrim.type <- ifelse(dprime_id$boundary==0&dprime_id$stimulus=="3-5","BC","WC")
dprime_id$discrim.type <- ifelse(dprime_id$boundary==-8&dprime_id$stimulus=="3-5","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==1&dprime_id$stimulus=="1-3","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==2&dprime_id$stimulus=="1-3","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==3&dprime_id$stimulus=="2-4","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==4&dprime_id$stimulus=="3-5","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==5&dprime_id$stimulus=="4-6","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==6&dprime_id$stimulus=="5-7","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==7&dprime_id$stimulus=="5-7","BC",dprime_id$discrim.type)

# summarize BC and WC
summary(dprime_id)
ggplot(dprime_id,aes(x=discrim.type,fill=discrim.type)) + geom_bar()

# BC d' on Day 3
BC.dprime.day3 <- subset(dprime_id,session==3 & discrim.type=="BC")

# WC d' on Day 3
WC.dprime.day3 <- subset(dprime_id,session==3 & discrim.type=="WC")
WC.dprime.day3 <- ddply(WC.dprime.day3,.(subject2),summarize,dprime=mean(dprime))

# # create dprime by stimulus figure for session 3 to compare to sine
# dprime_id_session3 <- subset(dprime_id,session==3)
# ggplot(dprime_id_session3,aes(x=stimulus,y=dprime)) + 
#   geom_point() +
#   geom_bar(position="dodge",aes(fill=stimulus),stat="summary",fun.y=mean,alpha=0.3) +
#   scale_fill_manual('#',labels=c("1","2","3","4","5"),values=c("purple","purple","purple","purple","purple")) +
#   guides(fill=FALSE) +
#   theme_dark() +
#   theme(text = element_text(size=20))

# create figure where discrim tokens are labeled relative to the individuals boundary
dprime.relative.bound <- data.frame(matrix(vector(), 0, 10,
                                           dimnames=list(c(),c("session","subject2","block", "FA", "Hit","dprime",
                                                               "stimulus","boundary","discrim.type","relative.bound"))))

for (subj in unique(dprime_id$subject2)){
  for(ses in unique(dprime_id$session)){
    temp <- subset(dprime_id,subject2==subj&session==ses)
    B.C. = dprime_id[dprime_id$subject2==subj&dprime_id$discrim.type=="BC"&dprime_id$session==ses,"stimulus"]
    if (B.C.[1,1]=="1-3"){
      temp$relative.bound <- ifelse(temp$stimulus=="1-3"&temp$discrim.type=="BC","BC",
                                       ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC+1",
                                              ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+2",
                                                     ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+3",
                                                            ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+4","")))))
    } else if (B.C.[1,1]=="2-4"){
      temp$relative.bound <- ifelse(temp$stimulus=="2-4"&temp$discrim.type=="BC","BC",
                                       ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-1",
                                              ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+1",
                                                     ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+2",
                                                            ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+3","")))))
    } else if (B.C.[1,1]=="3-5"){
      temp$relative.bound <- ifelse(temp$stimulus=="3-5"&temp$discrim.type=="BC","BC",
                                       ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-2",
                                              ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-1",
                                                     ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+1",
                                                            ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+2","")))))
    } else if (B.C.[1,1]=="4-6"){
      temp$relative.bound <- ifelse(temp$stimulus=="4-6"&temp$discrim.type=="BC","BC",
                                       ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-3",
                                              ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-2",
                                                     ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC-1",
                                                            ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+1","")))))
    } else if (B.C.[1,1]=="5-7"){
      temp$relative.bound <- ifelse(temp$stimulus=="5-7"&temp$discrim.type=="BC","BC",
                                       ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-2",
                                              ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-1",
                                                     ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+1",
                                                            ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+2","")))))
    }
    temp <- as.data.frame(temp)
    dprime.relative.bound <- rbind(dprime.relative.bound,temp)
  }
}

dprime_rb_lineplot <- summarySE(dprime.relative.bound, measurevar="dprime",groupvars = c("session","relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))
dprime_rb_lineplot$plotting <- ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="pretest_discrimination",1,
                                   ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="pretest_discrimination",2,
                                          ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="pretest_discrimination",3,
                                                 ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="posttest_discrimination",4,
                                                        ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="posttest_discrimination",5,
                                                               ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="posttest_discrimination",6,""))))))


ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_brewer('Session',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20))

# mixed effects model on dprime with relative boundary

dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$relative.bound <- as.factor(dprime.relative.bound$relative.bound)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

lmem.relative.bound1 <- mixed(dprime ~ relative.bound*session*block + (session:block||subject2) + (session||subject2) + (block||subject2),
                             data=dprime.relative.bound,expand_re = TRUE,
                             control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound2 <- mixed(dprime ~ relative.bound*session*block + (session:block||subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound3 <- mixed(dprime ~ relative.bound*session*block + (session||subject2) + (block||subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound4 <- mixed(dprime ~ relative.bound*session*block + (1|subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound1

# mixed effects model on dprime with relative boundary restricted to middle tokens
dp.rel.mid <- subset(dprime.relative.bound,relative.bound!="WC-3"&relative.bound!="WC+4")
dp.rel.mid$session <- as.factor(dp.rel.mid$session)
dp.rel.mid$relative.bound <- as.factor(dp.rel.mid$relative.bound)
dp.rel.mid$block <- as.factor(dp.rel.mid$block)

# lmem.relative.bound.mid1 <- mixed(dprime ~ relative.bound*session*block + (block|subject2) + (session|subject2),data=dp.rel.mid,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000))) doesn't converge

# lmem.relative.bound.mid2 <- mixed(dprime ~ relative.bound*session*block + (block||subject2) + (session||subject2),data=dp.rel.mid,expand_re = TRUE,
#                                   control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000))) doesn't converge

lmem.relative.bound.mid3 <- mixed(dprime ~ relative.bound*session*block + (session||subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.relative.bound.mid4 <- mixed(dprime ~ relative.bound*session*block + (block||subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.relative.bound.mid5 <- mixed(dprime ~ relative.bound*session*block + (1|subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

anova(lmem.relative.bound.mid3,lmem.relative.bound.mid4,lmem.relative.bound.mid5)
lmem.relative.bound.mid3

# mixed effects model on dprime with non-relative boundary (2-4 and 3-5 as BC)
dprime.relative.bound$nonrelative.bound <- ifelse(dprime.relative.bound$stimulus=="2-4"|dprime.relative.bound$stimulus=="3-5","BC","WC")

dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$nonrelative.bound <- as.factor(dprime.relative.bound$nonrelative.bound)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

# lmem.nonrelative.bound1 <- mixed(dprime ~ nonrelative.bound*session*block + (block|subject2) + (session|subject2),data=dprime.relative.bound,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
# lmem.nonrelative.bound2 <- mixed(dprime ~ nonrelative.bound*session*block + (block||subject2) + (session||subject2),data=dprime.relative.bound,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.nonrelative.bound3 <- mixed(dprime ~ nonrelative.bound*session*block + (session||subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.nonrelative.bound4 <- mixed(dprime ~ nonrelative.bound*session*block + (block||subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.nonrelative.bound5 <- mixed(dprime ~ nonrelative.bound*session*block + (1|subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

anova(lmem.nonrelative.bound3,lmem.nonrelative.bound4,lmem.nonrelative.bound5)
lmem.nonrelative.bound3

#### PHONETIC CATEGORIZATION ANALYSIS ####

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

# fit curves for session 3 using quickpsy for MVPA
readyforcurves <- subset(continuum,session==3)
readyforcurves$session <- as.numeric(readyforcurves$session)
readyforcurves$subject2 <- as.numeric(readyforcurves$subject2)
readyforcurves$step <- as.numeric(readyforcurves$step)
readyforcurves <- na.omit(readyforcurves)
mvpa.subject.curves <- quickpsy(readyforcurves, step, resp1, 
                          grouping = .(subject2), 
                          fun = logistic_fun,
                          lapses = FALSE, 
                          guess = FALSE,
                          bootstrap = "nonparametric", 
                          optimization = "optim",
                          B = 10000)

# fit curves by session to get boundaries to compare to discrim peaks
session.subject.curves <- quickpsy(readyforcurves, step, resp1, 
                                grouping = .(subject2,session), 
                                fun = logistic_fun,
                                lapses = FALSE, 
                                guess = FALSE,
                                bootstrap = "nonparametric", 
                                optimization = "optim",
                                B = 100)

boundaries <- as.data.frame(session.subject.curves$par)
boundaries[5:6] <- list(NULL)
boundaries <- boundaries %>% spread(parn, par, drop=TRUE)
colnames(boundaries)[3] <- "Boundary"
colnames(boundaries)[4] <- "Slope"


# mixed effects model
# prep data
continuum$step <- as.numeric(continuum$step)
continuum$step <- scale(continuum$step)
continuum$session <- as.factor(continuum$session)
continuum$subject2 <- as.factor(continuum$subject2)

# glmer model
PC.model1 <- mixed(resp1 ~ step*session + (step:session||subject2) + (step||subject2) + (session||subject2),
                  data=continuum,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                  control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

PC.model2 <- mixed(resp1 ~ step*session + (step:session||subject2),
                   data=continuum,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

PC.model3 <- mixed(resp1 ~ step*session + (step||subject2) + (session||subject2),
                   data=continuum, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

PC.model4 <- mixed(resp1 ~ step*session + (1|subject2),
                   data=continuum, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

anova(PC.model1,PC.model2,PC.model3,PC.model4)
PC.model1

# afex model
mixed(resp1 ~ step*session + (step*session||subject2) + (step||subject2) + (session||subject2), family=binomial(link="logit"),data=continuum,method="LRT")

#### SINE SESSION ANALYSIS ####
# Sine Training -----------------------------------------------------------
# separate training data
training <- subset(df,grepl("training",block))

# remove session 4
training <- subset(training,session!=4)

# subset vowel training
training.sine <- subset(training,session=="S3")

# calculate error bars
training.sine.stats <- summarySE(data=training.sine, measurevar="correct_response",groupvars=c("subject2","block"))

# calculate number of blocks completed
training.sine.stats$blocks.complete <- ifelse(training.sine.stats$N<62,1,
                                         ifelse(training.sine.stats$N>61&training.sine.stats$N<120,2,
                                                ifelse(training.sine.stats$N>120&training.sine.stats$N<182,3,NA)))
# summarize
training.sine.avg <- ddply(training.sine.stats,.(block,blocks.complete),summarize,mean=mean(correct_response))

#bar graph
ggplot(training.sine.stats,aes(x=block,y=correct_response)) + 
  geom_bar(stat="summary",position="dodge",fun.y='mean') +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training block',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  theme(text = element_text(size=20))

# overlay individual data points and group mean bars
id <- ddply(training.sine.stats,.(subject2,block,blocks.complete),summarize,mean=mean(correct_response))
stats <- summarySE(data=training.sine.stats, measurevar="correct_response",groupvars=("block"))
gd <- select(stats,block,correct_response)
gd <- rename(gd,mean=correct_response)

# across session
ggplot(id,aes(x=block,y=mean)) +
  geom_point(aes(x=block,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=gd,stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=20))

# mixed effects model
training.sine$block <- as.factor(training.sine$block)
training.sine$subject2 <- as.factor(training.sine$subject2)

afex.training.model.sine <- mixed(correct_response ~ block + (1|subject2), family=binomial(link="logit"),data=training.sine,method="LRT")
afex.training.model.sine
summary(afex.training.model.sine)


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
continuum_sine$cb <- ifelse(continuum_sine$subject2==3|continuum_sine$subject2==11|
                              continuum_sine$subject2==15|continuum_sine$subject2==20|continuum_sine$subject2==31,"cb1","cb2")
continuum_sineCB1 <- subset(continuum_sine,continuum_sine$cb=="cb1")
continuum_sineCB2 <- subset(continuum_sine,continuum_sine$cb=="cb2")
continuum_sineCB1$resp1 <- ifelse(continuum_sineCB1$response=="a",1,0)
continuum_sineCB2$resp1 <- ifelse(continuum_sineCB2$response=="a",0,1)
continuum_sine <- rbind(continuum_sineCB1,continuum_sineCB2)

# create 'step' variable
continuum_sine$step <- substr(continuum_sine$fname,9,9)

stats_sine <- summarySE(continuum_sine, measurevar="resp1",groupvars = c("subject2","step"))

ggplot(stats_sine, aes(x=as.numeric(step),y=resp1)) +
  geom_point(stat='summary', fun.y='mean', size=2.5,color="grey") +
  geom_line(stat='summary', fun.y='mean', size=0.75,color="grey") +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  facet_wrap(~subject2) +
  scale_x_continuous('/i/ to /y/ continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=20))

# fit curves
continuum_sine$step <- as.numeric(continuum_sine$step)
sine.boundaries <- quickpsy(continuum_sine, step, resp1, 
                                                     grouping = .(subject2), 
                                                     fun = logistic_fun,
                                                     lapses = FALSE, 
                                                     guess = FALSE,
                                                     bootstrap = "nonparametric", 
                                                     optimization = "optim",
                                                     B = 100)


sine.boundaries  <- as.data.frame(sine.boundaries$par)
sine.boundaries [4:5] <- list(NULL)
sine.boundaries  <- sine.boundaries  %>% spread(parn, par, drop=TRUE)
colnames(sine.boundaries )[2] <- "Boundary"
colnames(sine.boundaries )[3] <- "Slope"
save(sine.boundaries,file="sine.boundaries.Rda")

# Sine d' -----------------------------------------------------------------
# subset to just discrimination blocks
discrim <- subset(df,grepl("discrimination",block))

# remove session 4
discrim <- subset(discrim,session!=4)

# subset vowel
discrim.sine <- subset(discrim,session=="S3")

# create variable to combine forwards/backwards discrimination steps
discrim.sine$discrim.token <- ifelse(discrim.sine$fname=="iyu_step_1-step_1.wav","1-1",
                                      ifelse(discrim.sine$fname=="iyu_step_2-step_2.wav","2-2",
                                             ifelse(discrim.sine$fname=="iyu_step_3-step_3.wav","3-3",
                                                    ifelse(discrim.sine$fname=="iyu_step_4-step_4.wav","4-4",
                                                           ifelse(discrim.sine$fname=="iyu_step_5-step_5.wav","5-5",
                                                                  ifelse(discrim.sine$fname=="iyu_step_6-step_6.wav","6-6",
                                                                         ifelse(discrim.sine$fname=="iyu_step_7-step_7.wav","7-7",
                                                                                ifelse(discrim.sine$fname=="iyu_step_1-step_3.wav","1-3",
                                                                                       ifelse(discrim.sine$fname=="iyu_step_2-step_4.wav","2-4",
                                                                                              ifelse(discrim.sine$fname=="iyu_step_3-step_5.wav","3-5",
                                                                                                     ifelse(discrim.sine$fname=="iyu_step_4-step_6.wav","4-6",
                                                                                                            ifelse(discrim.sine$fname=="iyu_step_5-step_7.wav","5-7",
                                                                                                                   ifelse(discrim.sine$fname=="iyu_step_3-step_1.wav","1-3",
                                                                                                                          ifelse(discrim.sine$fname=="iyu_step_4-step_2.wav","2-4",
                                                                                                                                 ifelse(discrim.sine$fname=="iyu_step_5-step_3.wav","3-5",
                                                                                                                                        ifelse(discrim.sine$fname=="iyu_step_6-step_4.wav","4-6",
                                                                                                                                               ifelse(discrim.sine$fname=="iyu_step_7-step_5.wav","5-7",NA)))))))))))))))))


discrim.sine$condition <- ifelse(discrim.sine$discrim.token=="1-1","same",
                                  ifelse(discrim.sine$discrim.token=="2-2","same",
                                         ifelse(discrim.sine$discrim.token=="3-3","same",
                                                ifelse(discrim.sine$discrim.token=="4-4","same",
                                                       ifelse(discrim.sine$discrim.token=="5-5","same",
                                                              ifelse(discrim.sine$discrim.token=="6-6","same",
                                                                     ifelse(discrim.sine$discrim.token=="7-7","same",
                                                                            ifelse(discrim.sine$discrim.token=="1-3","different",
                                                                                   ifelse(discrim.sine$discrim.token=="2-4","different",
                                                                                          ifelse(discrim.sine$discrim.token=="3-5","different",
                                                                                                 ifelse(discrim.sine$discrim.token=="4-6","different",
                                                                                                        ifelse(discrim.sine$discrim.token=="5-7","different",NA))))))))))))


dprime.stimulus <- discrim.sine %>%
  group_by(subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

dprime.stimulus <- dprime.stimulus %>% mutate(prop_incor=1-prop_cor)

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

dprime.stimulus$prop_cor <- cutoff_1(dprime.stimulus$prop_cor,.99)
dprime.stimulus$prop_cor <- cutoff_0(dprime.stimulus$prop_cor,.01)
dprime.stimulus$prop_incor <- cutoff_1(dprime.stimulus$prop_incor,.99)
dprime.stimulus$prop_incor <- cutoff_0(dprime.stimulus$prop_incor,.01)

### 1-3 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="1-1" | dprime.stimulus$discrim.token=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="1-3")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp1_3 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp1_3 <- spread(dprime_temp1_3, condition, mean)

dprime_temp1_3 <- dprime_temp1_3 %>%
  group_by(subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp1_3$stimulus <- "1-3"

### 2-4 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="2-2" | dprime.stimulus$discrim.token=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="2-4")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp2_4 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp2_4 <- spread(dprime_temp2_4, condition, mean)

dprime_temp2_4 <- dprime_temp2_4 %>%
  group_by(subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp2_4$stimulus <- "2-4"

### 3-5 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="3-3" | dprime.stimulus$discrim.token=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="3-5")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp3_5 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp3_5 <- spread(dprime_temp3_5, condition, mean)

dprime_temp3_5 <- dprime_temp3_5 %>%
  group_by(subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp3_5$stimulus <- "3-5"

### 4-6 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="4-4" | dprime.stimulus$discrim.token=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="4-6")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp4_6 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp4_6 <- spread(dprime_temp4_6, condition, mean)

dprime_temp4_6 <- dprime_temp4_6 %>%
  group_by(subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp4_6$stimulus <- "4-6"

### 5-7 ###
dprime_temp_same <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="5-5" | dprime.stimulus$discrim.token=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(dprime.stimulus,dprime.stimulus$discrim.token=="5-7")
dprime_temp_different <- ddply(dprime_temp_different,.(subject2,block),summarize,mean=mean(prop_cor))
dprime_temp_different$condition <- "Hit"
dprime_temp5_7 <- rbind(dprime_temp_same,dprime_temp_different)

d_prime <- function(Hit,FA){
  qnorm(Hit) - qnorm(FA)
}

dprime_temp5_7 <- spread(dprime_temp5_7, condition, mean)

dprime_temp5_7 <- dprime_temp5_7 %>%
  group_by(subject2,block) %>%
  mutate(dprime = d_prime(Hit,FA))
dprime_temp5_7$stimulus <- "5-7"

dprime_id <- data.frame()
dprime_id <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# create dprime by stimulus figure 
# boxplot
# ggplot(dprime_id,aes(x=stimulus,y=dprime)) + 
#   geom_boxplot(position="dodge",aes(fill=session)) +
#   scale_fill_brewer('Session #',palette = "Purples") +
#   theme_dark() +
#   theme(text = element_text(size=20))

# lineplot group average
dprime_lineplot <- summarySE(dprime_id, measurevar="dprime",groupvars = c("stimulus","block"))

ggplot(dprime_lineplot,aes(x=stimulus,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,linetype=block),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20))

# lineplot by individual
ggplot(dprime_id,aes(x=stimulus,y=dprime,group=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session),stat='summary', fun.y='mean', size=2) +
  scale_color_brewer('Session',palette="Purples") +
  facet_wrap(~subject2) +
  theme_dark() +
  theme(text = element_text(size=20))

# Sine peak discrim -------------------------------------------------------
peak.discrim <- dprime_id %>% group_by(subject2,block) %>% slice(which.max(dprime))
peak.discrim <- select(peak.discrim,"subject2","dprime","stimulus","block")

# combine with category boundaries
load("sine.boundaries.Rda")

# create histogram of boundaries before rounding
ggplot(sine.boundaries,aes(x=Boundary,group=factor(subject2))) + 
  geom_histogram(binwidth=.5) +
  theme(text = element_text(size=20))

# round boundaries
sine.boundaries <- sine.boundaries[rep(1:nrow(sine.boundaries),2),]
sine.boundaries$block[1:26] <- "pretest_discrimination"
sine.boundaries$block[1.1:26.1] <- "posttest_discrimination"
sine.boundaries$Boundary <- round(sine.boundaries$Boundary)

# look at peak discrim token and boundaries
peak.discrim$boundary <- sine.boundaries$Boundary
peak.discrim <- subset(peak.discrim,boundary!=-9)
ggplot(peak.discrim,aes(x=stimulus,y=boundary,label=subject2)) + 
  scale_y_continuous('Boundary') +
  ylim(0,7) + xlab('Peak discrimination stimulus') + geom_label_repel(aes(label=subject2)) +
  theme(text = element_text(size=20))

# use this information to determine what is between-category and what is within-category
dprime_id$boundary <- NA
for (i in unique(dprime_id$subject2)){
    temp.boundaries <- sine.boundaries[sine.boundaries$subject2==i,"Boundary"]
    dprime_id$boundary <- ifelse(dprime_id$subject2==i,temp.boundaries,dprime_id$boundary)
}


dprime_id$discrim.type <- ifelse(dprime_id$boundary==0&dprime_id$stimulus=="3-5","BC","WC")
dprime_id$discrim.type <- ifelse(dprime_id$boundary==9&dprime_id$stimulus=="3-5","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==1&dprime_id$stimulus=="1-3","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==2&dprime_id$stimulus=="1-3","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==3&dprime_id$stimulus=="2-4","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==4&dprime_id$stimulus=="3-5","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==5&dprime_id$stimulus=="4-6","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==6&dprime_id$stimulus=="5-7","BC",dprime_id$discrim.type)
dprime_id$discrim.type <- ifelse(dprime_id$boundary==7&dprime_id$stimulus=="5-7","BC",dprime_id$discrim.type)

# summarize BC and WC
summary(dprime_id)
ggplot(dprime_id,aes(x=discrim.type,fill=discrim.type)) + geom_bar()

# BC d' on Day 3
BC.dprime.day3 <- subset(dprime_id,session==3 & discrim.type=="BC")

# WC d' on Day 3
WC.dprime.day3 <- subset(dprime_id,session==3 & discrim.type=="WC")
WC.dprime.day3 <- ddply(WC.dprime.day3,.(subject2),summarize,dprime=mean(dprime))

# # create dprime by stimulus figure for session 3 to compare to sine
# dprime_id_session3 <- subset(dprime_id,session==3)
# ggplot(dprime_id_session3,aes(x=stimulus,y=dprime)) + 
#   geom_point() +
#   geom_bar(position="dodge",aes(fill=stimulus),stat="summary",fun.y=mean,alpha=0.3) +
#   scale_fill_manual('#',labels=c("1","2","3","4","5"),values=c("purple","purple","purple","purple","purple")) +
#   guides(fill=FALSE) +
#   theme_dark() +
#   theme(text = element_text(size=20))

# create figure where discrim tokens are labeled relative to the individuals boundary
dprimesine.relative.bound <- data.frame(matrix(vector(), 0,9,
                                           dimnames=list(c(),c("subject2","block", "FA", "Hit","dprime",
                                                               "stimulus","boundary","discrim.type","relative.bound"))))

for (subj in unique(dprime_id$subject2)){
  for (b in unique(dprime_id$block)){
    temp <- subset(dprime_id,subject2==subj&block==b)
    B.C. = dprime_id[dprime_id$subject2==subj&dprime_id$block==b&dprime_id$discrim.type=="BC","stimulus"]
    if (B.C.[1,1]=="1-3"){
      temp$relative.bound <- ifelse(temp$stimulus=="1-3"&temp$discrim.type=="BC","BC",
                                    ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC+1",
                                           ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+2",
                                                  ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+3",
                                                         ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+4","")))))
    } else if (B.C.[1,1]=="2-4"){
      temp$relative.bound <- ifelse(temp$stimulus=="2-4"&temp$discrim.type=="BC","BC",
                                    ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-1",
                                           ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+1",
                                                  ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+2",
                                                         ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+3","")))))
    } else if (B.C.[1,1]=="3-5"){
      temp$relative.bound <- ifelse(temp$stimulus=="3-5"&temp$discrim.type=="BC","BC",
                                    ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-2",
                                           ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-1",
                                                  ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+1",
                                                         ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+2","")))))
    } else if (B.C.[1,1]=="4-6"){
      temp$relative.bound <- ifelse(temp$stimulus=="4-6"&temp$discrim.type=="BC","BC",
                                    ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-3",
                                           ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-2",
                                                  ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC-1",
                                                         ifelse(temp$stimulus=="5-7"&temp$discrim.type=="WC","WC+1","")))))
    } else if (B.C.[1,1]=="5-7"){
      temp$relative.bound <- ifelse(temp$stimulus=="5-7"&temp$discrim.type=="BC","BC",
                                    ifelse(temp$stimulus=="1-3"&temp$discrim.type=="WC","WC-2",
                                           ifelse(temp$stimulus=="2-4"&temp$discrim.type=="WC","WC-1",
                                                  ifelse(temp$stimulus=="3-5"&temp$discrim.type=="WC","WC+1",
                                                         ifelse(temp$stimulus=="4-6"&temp$discrim.type=="WC","WC+2","")))))
    }
    temp <- as.data.frame(temp)
    dprimesine.relative.bound <- rbind(dprimesine.relative.bound,temp)
  }
}

dprime_rb_lineplot <- summarySE(dprimesine.relative.bound, measurevar="dprime",groupvars = c("relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))

ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20))

# mixed effects model on dprime with relative boundary

dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$relative.bound <- as.factor(dprime.relative.bound$relative.bound)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

lmem.relative.bound1 <- mixed(dprime ~ relative.bound*session*block + (session:block||subject2) + (session||subject2) + (block||subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound2 <- mixed(dprime ~ relative.bound*session*block + (session:block||subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound3 <- mixed(dprime ~ relative.bound*session*block + (session||subject2) + (block||subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound4 <- mixed(dprime ~ relative.bound*session*block + (1|subject2),
                              data=dprime.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.relative.bound1

# mixed effects model on dprime with relative boundary restricted to middle tokens
dp.rel.mid <- subset(dprime.relative.bound,relative.bound!="WC-3"&relative.bound!="WC+4")
dp.rel.mid$session <- as.factor(dp.rel.mid$session)
dp.rel.mid$relative.bound <- as.factor(dp.rel.mid$relative.bound)
dp.rel.mid$block <- as.factor(dp.rel.mid$block)

# lmem.relative.bound.mid1 <- mixed(dprime ~ relative.bound*session*block + (block|subject2) + (session|subject2),data=dp.rel.mid,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000))) doesn't converge

# lmem.relative.bound.mid2 <- mixed(dprime ~ relative.bound*session*block + (block||subject2) + (session||subject2),data=dp.rel.mid,expand_re = TRUE,
#                                   control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000))) doesn't converge

lmem.relative.bound.mid3 <- mixed(dprime ~ relative.bound*session*block + (session||subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.relative.bound.mid4 <- mixed(dprime ~ relative.bound*session*block + (block||subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.relative.bound.mid5 <- mixed(dprime ~ relative.bound*session*block + (1|subject2),data=dp.rel.mid,expand_re = TRUE,
                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

anova(lmem.relative.bound.mid3,lmem.relative.bound.mid4,lmem.relative.bound.mid5)
lmem.relative.bound.mid3

# mixed effects model on dprime with non-relative boundary (2-4 and 3-5 as BC)
dprime.relative.bound$nonrelative.bound <- ifelse(dprime.relative.bound$stimulus=="2-4"|dprime.relative.bound$stimulus=="3-5","BC","WC")

dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$nonrelative.bound <- as.factor(dprime.relative.bound$nonrelative.bound)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

# lmem.nonrelative.bound1 <- mixed(dprime ~ nonrelative.bound*session*block + (block|subject2) + (session|subject2),data=dprime.relative.bound,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
# lmem.nonrelative.bound2 <- mixed(dprime ~ nonrelative.bound*session*block + (block||subject2) + (session||subject2),data=dprime.relative.bound,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

lmem.nonrelative.bound3 <- mixed(dprime ~ nonrelative.bound*session*block + (session||subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.nonrelative.bound4 <- mixed(dprime ~ nonrelative.bound*session*block + (block||subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))
lmem.nonrelative.bound5 <- mixed(dprime ~ nonrelative.bound*session*block + (1|subject2),data=dprime.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 150000)))

anova(lmem.nonrelative.bound3,lmem.nonrelative.bound4,lmem.nonrelative.bound5)
lmem.nonrelative.bound3

#### MIXED EFFECTS MODELS FOR DISCRIMINATION ####

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
vowel.mod.data$discrim.token <- ifelse(vowel.mod.data$fname=="i-y-u_step1-step1.wav","1-1",
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


vowel.mod.data$discrim.condition <- ifelse(vowel.mod.data$discrim.token=="1-1","same",
                                           ifelse(vowel.mod.data$discrim.token=="2-2","same",
                                                  ifelse(vowel.mod.data$discrim.token=="3-3","same",
                                                         ifelse(vowel.mod.data$discrim.token=="4-4","same",
                                                                ifelse(vowel.mod.data$discrim.token=="5-5","same",
                                                                       ifelse(vowel.mod.data$discrim.token=="6-6","same",
                                                                              ifelse(vowel.mod.data$discrim.token=="7-7","same",
                                                                                     ifelse(vowel.mod.data$discrim.token=="1-3","different",
                                                                                            ifelse(vowel.mod.data$discrim.token=="2-4","different",
                                                                                                   ifelse(vowel.mod.data$discrim.token=="3-5","different",
                                                                                                          ifelse(vowel.mod.data$discrim.token=="4-6","different",
                                                                                                                 ifelse(vowel.mod.data$discrim.token=="5-7","different",NA))))))))))))

## GLMM for % accuracy in discrimation ##

# prep data
vowel.mod.data <- subset(vowel.mod.data,discrim.condition=="different")

vowel.mod.data$block.session <- as.factor(vowel.mod.data$block.session)
contrasts(vowel.mod.data$block.session) = contr.sum(6)

vowel.mod.data$discrim.token <- as.factor(vowel.mod.data$discrim.token)
contrasts(vowel.mod.data$discrim.token) = contr.sum(5)

# run models
# run using afex to just get main effects and interaction
afexmodel1 <- mixed(correct_response ~ block.session*discrim.token + (1|subject2), family=binomial(link="logit"),data=vowel.mod.data,method="LRT")
summary(afexmodel1)

# run glmer to get simple effects
model1 <- glmer(correct_response ~ block.session + (1|subject2),
                  data=vowel.mod.data, family='binomial',
                  control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 1500000)))
summary(model1)

# analysis with just first pre-test and final post-test
vowel.mod.data2 <- subset(vowel.mod.data,block.session==1|block.session==6)

afexmodel1 <- mixed(correct_response ~ block.session*discrim.token + (1|subject2), family=binomial(link="logit"),data=vowel.mod.data2,method="LRT")
summary(afexmodel1)

# run glmer to get simple effects
model1 <- glmer(correct_response ~ block.session + (1|subject2),
                data=vowel.mod.data, family='binomial',
                control = glmerControl(optimizer="bobyqa", optCtrl = list(maxfun = 1500000)))
summary(model1)

# SINE
# create variable to treat each pre and post-test from each session as a unique session
sine.mod.data <- subset(sine.mod.data,grepl("discrimination",block)==TRUE)

## create variable to combine forwards/backwards discrimination steps
sine.mod.data$discrim.token <- ifelse(sine.mod.data$fname=="iyu_step_1-step_1.wav","1-1",
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


sine.mod.data$discrim.condition <- ifelse(sine.mod.data$discrim.token=="1-1","same",
                                          ifelse(sine.mod.data$discrim.token=="2-2","same",
                                                 ifelse(sine.mod.data$discrim.token=="3-3","same",
                                                        ifelse(sine.mod.data$discrim.token=="4-4","same",
                                                               ifelse(sine.mod.data$discrim.token=="5-5","same",
                                                                      ifelse(sine.mod.data$discrim.token=="6-6","same",
                                                                             ifelse(sine.mod.data$discrim.token=="7-7","same",
                                                                                    ifelse(sine.mod.data$discrim.token=="1-3","different",
                                                                                           ifelse(sine.mod.data$discrim.token=="2-4","different",
                                                                                                  ifelse(sine.mod.data$discrim.token=="3-5","different",
                                                                                                         ifelse(sine.mod.data$discrim.token=="4-6","different",
                                                                                                                ifelse(sine.mod.data$discrim.token=="5-7","different",NA))))))))))))

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

