# load packages
rm(list = ls(all = TRUE))

library(plyr)
library(dplyr)
library(data.table)
library(Rmisc)
library(ggplot2)
library(ez)
library(lme4)
library(tidyverse)
library(scales)

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

df$correct_response <- as.numeric(df$correct_response)
df$trial <- as.numeric(df$trial)
df$rt <- as.numeric(df$rt)

# drop participants
df <- subset(df,subject!=401)

#### FOR VOWEL SESSIONS ####

# split by session 
session1 <- subset(df,session == 1)
session2 <- subset(df,session == 2)
session3 <- subset(df,session == 3)
session4 <- subset(df,session == 4)



#### SESSION 1 ####

# split by block for session1
pretest1 <- subset(session1,block == "pretest_discrimination")
posttest1 <- subset(session1,block == "posttest_discrimination")
training1.1 <- subset(session1,block == "training1")
training1.2 <- subset(session1,block == "training2")
training1.3 <- subset(session1,block == "training3")
continuum1 <- subset(session1,block == "continuum")

# summarize performance by subject
pretest1_performance = ddply(pretest1,.(subject),summarize,mean=mean(correct_response))
posttest1_performance = ddply(posttest1,.(subject),summarize,mean=mean(correct_response))
training1.1_performance = ddply(training1.1,.(subject),summarize,mean=mean(correct_response))
training1.2_performance = ddply(training1.2,.(subject),summarize,mean=mean(correct_response))
training1.3_performance = ddply(training1.3,.(subject),summarize,mean=mean(correct_response))

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


ggplot(pretest1_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")

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

ggplot(posttest1_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")






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
posttest1_performance = ddply(posttest1,.(subject),summarize,mean=mean(correct_response))
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


ggplot(pretest2_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")

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

ggplot(posttest2_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")








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
posttest1_performance = ddply(posttest1,.(subject),summarize,mean=mean(correct_response))
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


ggplot(pretest3_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")

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

ggplot(posttest3_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")





### SESSION 4 ###

session4_performance = ddply(session4,.(subject,block),summarize,mean=mean(correct_response))

