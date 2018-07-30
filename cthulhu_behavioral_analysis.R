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
training1 <- subset(df,df$block == "training1")
training2 <- subset(df,df$block == "training2")
training3 <- subset(df,df$block == "training3")

# summarize performance by subject
pretest_performance = ddply(pretest,.(subject),summarize,mean=mean(correct_response))
posttest_performance = ddply(posttest,.(subject),summarize,mean=mean(correct_response))