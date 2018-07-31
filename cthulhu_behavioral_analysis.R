# load packages
rm(list = ls(all = TRUE))

library(plyr)
library(ddply)
library(data.table)
library(Rmisc)
library(ggplot2)
library(ez)
library(lme4)
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

# split by block
pretest <- as.data.frame(subset(df,df$block == "pretest_discrimination"))
posttest <- subset(df,df$block == "posttest_discrimination")
training1 <- subset(df,block == "training1")
training2 <- subset(df,block == "training2")
training3 <- subset(df,block == "training3")
continuum <- subset(df,block == "continuum")

# summarize performance by subject
pretest_performance = ddply(pretest,.(subject),summarize,mean=mean(correct_response))
posttest_performance = ddply(posttest,.(subject),summarize,mean=mean(correct_response))
training1_performance = ddply(training1,.(subject),summarize,mean=mean(correct_response))
training2_performance = ddply(training2,.(subject),summarize,mean=mean(correct_response))
training3_performance = ddply(training3,.(subject),summarize,mean=mean(correct_response))

# create pretest performance figure
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step1-step1.wav","1-1",NA)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step2-step2.wav","2-2",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step3-step3.wav","3-3",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step4-step4.wav","4-4",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step5-step5.wav","5-5",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step6-step6.wav","6-6",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step7-step7.wav","7-7",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_1-step_3.wav","1-3",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_2-step_4.wav","2-4",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_3-step_5.wav","3-5",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_4-step_6.wav","4-6",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_5-step_7.wav","5-7",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_3-step_1.wav","1-3",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_4-step_2.wav","2-4",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_5-step_3.wav","3-5",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_6-step_4.wav","4-6",pretest$fname2)
pretest$fname2 <- ifelse(pretest$fname=="i-y-u_step_7-step_5.wav","5-7",pretest$fname2)

pretest_figure = ddply(pretest,.(fname2),summarize,mean=mean(correct_response))
pretest_figure$condition <- ifelse(pretest_figure$fname2=="1-1","same",NA)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="2-2","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="3-3","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="4-4","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="5-5","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="6-6","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="7-7","same",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="1-3","different",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="2-4","different",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="3-5","different",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="4-6","different",pretest_figure$condition)
pretest_figure$condition <- ifelse(pretest_figure$fname2=="5-7","different",pretest_figure$condition)


ggplot(pretest_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")

# create posttest performance figure
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step1-step1.wav","1-1",NA)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step2-step2.wav","2-2",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step3-step3.wav","3-3",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step4-step4.wav","4-4",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step5-step5.wav","5-5",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step6-step6.wav","6-6",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step7-step7.wav","7-7",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_1-step_3.wav","1-3",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_2-step_4.wav","2-4",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_3-step_5.wav","3-5",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_4-step_6.wav","4-6",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_5-step_7.wav","5-7",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_3-step_1.wav","1-3",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_4-step_2.wav","2-4",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_5-step_3.wav","3-5",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_6-step_4.wav","4-6",posttest$fname2)
posttest$fname2 <- ifelse(posttest$fname=="i-y-u_step_7-step_5.wav","5-7",posttest$fname2)

posttest_figure = ddply(posttest,.(fname2),summarize,mean=mean(correct_response))
posttest_figure$condition <- ifelse(posttest_figure$fname2=="1-1","same",NA)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="2-2","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="3-3","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="4-4","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="5-5","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="6-6","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="7-7","same",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="1-3","different",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="2-4","different",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="3-5","different",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="4-6","different",posttest_figure$condition)
posttest_figure$condition <- ifelse(posttest_figure$fname2=="5-7","different",posttest_figure$condition)


ggplot(posttest_figure,aes(x=reorder(fname2,-mean),y=mean,fill=condition)) + geom_bar(stat="identity")