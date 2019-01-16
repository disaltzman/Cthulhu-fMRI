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

# enter names of stimuli
stimulus_names = c('vowelstep1','vowelstep3','vowelstep5','vowelstep7','sinestep1','sinestep3','sinestep5','sinestep7')

# remove practice   
df <- subset(df,blockname!="P")

false_alarms <- 0
false_alarms <- as.data.frame(false_alarms)

# create timing for stimuli
for (i in unique(df$subject)){
  for (f in stimulus_names){
  temp_data <- subset(df,grepl("catch",fname)==FALSE)
  temp_data <- subset(temp_data,grepl(f,fname))
  temp_data <- subset(temp_data,subject==i)
  false_alarms_temp <- subset(temp_data,response!="None")
  false_alarms <- bind_rows(false_alarms,false_alarms_temp)
  temp_data$arbitrary_key[1:15] <- 1:15
  temp_data <- subset(temp_data,response=="None")
  temp_data <- select(temp_data,"subject","timing","num_block","arbitrary_key")
  temp_data <- spread(temp_data,arbitrary_key,timing)
  t <- assign(paste0(f,"_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
                                                            "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
                                                            "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
                                                            "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`))
  write.table(t,file=paste0(f,"_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
  }
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

# create timing for false alarms
for (i in unique(df$subject)){
  FA_temp_data <- subset(false_alarms,subject==i)
  FA_temp_data$false_alarms <- NULL
  FA_temp_data <- select(FA_temp_data,"subject","timing","num_block")
  FA_temp_data$arbitrary_key[1:nrow(FA_temp_data)] <- 1:nrow(FA_temp_data)
  FA_temp_data <- spread(FA_temp_data,arbitrary_key,timing)
  t <- assign(paste0("falsealarm_timing_subj",i),data.frame("1"=temp_data$`1`,"2"=temp_data$`2`,"3"=temp_data$`3`,
  "4"=temp_data$`4`,"5"=temp_data$`5`,"6"=temp_data$`6`,"7"=temp_data$`7`,"8"=temp_data$`8`,
  "9"=temp_data$`9`,"10"=temp_data$`10`,"11"=temp_data$`11`,
  "12"=temp_data$`12`,"13"=temp_data$`13`,"14"=temp_data$`14`,"15"=temp_data$`15`,"16"=temp_data$`16`,
  "17"=temp_data$`17`,"18"=temp_data$`18`,"19"=temp_data$`19`,"20"=temp_data$`20`))
  write.table(FA_temp_data,file=paste0("zfalsealarm_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
}