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

# create timing for stimuli
for (i in unique(df$subject)){
    # remove practice   
    df <- subset(df,blockname!="P")
    # remove silent trials
    df <- subset(df,fname!="silence.wav")
    # add key for spreading
    df$arbitrary_key[1:135] <- 1:135
    # drop unimportant columns
    df <- select(df,"subject","timing","num_block","arbitrary_key")
    # spread
    df <- spread(df,arbitrary_key,timing)
    df <- df[,3:137]
    # write to table
    write.table(df,file=paste0("IM_timing_subj",i,".txt"),sep=" ",col.names = FALSE, row.names = FALSE)
  }
