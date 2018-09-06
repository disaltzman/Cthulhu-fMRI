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

df <- data.frame(matrix(vector(), 0,10,dimnames=list(c(),c("blockname","num_block","first_trial_time","fname",
"response","rt","subject","time_current_stimulus","time_to_pad","timing"))),stringsAsFactors=F)

# loop to create combined dataframe
for (i in file_names) {
  data <- fread(i, header = TRUE, sep = ",")
  data <- `colnames<-`(data,  c("blockname","num_block","first_trial_time","fname","response","rt","subject","time_current_stimulus","time_to_pad","timing"))
  df <- rbind(df, data)
}

# remove practice
df <- subset(df,blockname!="P")

# create timing for vowelstep1.wav
for (i in unique(df$subject)){
        temp_data <- subset(df,fname=="vowelstep1.wav")
        temp_data <- subset(temp_data,subject==i)
        temp_data <- select(temp_data,"subject","timing","num_block")
        temp_data$arbitrary_key[1:15] <- 1:15 
        temp_data <- spread(temp_data,arbitrary_key,timing)
        t <- assign(paste0("vowelstep1_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                             "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                             "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                             "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
        write.table(t,file=paste0("vowelstep1_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for vowelstep3.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="vowelstep3.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("vowelstep3_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                            "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                            "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                            "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("vowelstep3_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for vowelstep5.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="vowelstep5.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("vowelstep5_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                            "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                            "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                            "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("vowelstep5_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for vowelstep7.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="vowelstep7.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("vowelstep7_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                            "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                            "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                            "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("vowelstep7_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for sinestep1.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="sinestep1.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("sinestep1_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                            "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                            "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                            "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("sinestep1_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for sinestep3.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="sinestep3.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("sinestep3_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                           "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                           "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                           "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("sinestep3_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for sinestep5.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="sinestep5.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("sinestep5_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                           "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                           "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                           "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("sinestep5_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for sinestep7.wav
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="sinestep7.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("sinestep7_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                           "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                           "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                           "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("sinestep7_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for silent trials
for (i in unique(df$subject)){
  temp_data <- subset(df,fname=="silence.wav")
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:25] <- 1:25 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("silence_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                           "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                           "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                           "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`,
                                                         "16"=temp_data$`16`,"17"=temp_data$`17`,"18"=temp_data$`18`,"19"=temp_data$`19`,
                                                         "20"=temp_data$`20`,"21"=temp_data$`21`,"22"=temp_data$`22`,"23"=temp_data$`23`,
                                                         "24"=temp_data$`24`,"25"=temp_data$`25`))
  write.table(t,file=paste0("silence_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

# create timing for catch trials
for (i in unique(df$subject)){
  temp_data <- filter(df,grepl("catch",fname))
  temp_data <- subset(temp_data,subject==i)
  temp_data <- select(temp_data,"subject","timing","num_block")
  temp_data$arbitrary_key[1:15] <- 1:15 
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0("catch_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                         "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                         "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                         "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0("catch_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}

### 