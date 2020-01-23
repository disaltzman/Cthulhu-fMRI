rm(list = ls(all = TRUE))

# Load packages.
# Data manipulation.
library(data.table)
library(dplyr)
library(stringr)
library(rio)
library(tidyverse)
library(janitor)

# Plots.
library(ggplot2)
library(cowplot)

# Analyses.
library(afex)
library(lme4)
library(lmerTest)
library(quickpsy)

theme_set(theme_bw())

# Read in raw data.
file_names <- list.files(path = ".", pattern = "*.csv", all.files = FALSE,
                         full.names = FALSE, recursive = FALSE) # where you have your files


# Create data frame.
df <- data.frame()

# Loop to create combined data frame.
for (i in file_names) {
  data <- fread(i, header = TRUE, sep = ",")
  df <- rbind(df, data)
}

# Set subject as factor.
df$subject_nr <- as.factor(df$subject_nr)

# Subset only catch trials.
catch <- subset(df,grepl("catch",fname)==TRUE)

# Drop practice block.
catch <- subset(catch,block!="P")

# Tranform so that a miss = 0 and hit = 1
catch$response_catch_response <- ifelse(catch$response_catch_response=="None",0,1)

# Summarize.
acc <- Rmisc::summarySE(data=catch, measurevar="response_catch_response",groupvars="subject_nr") # subject level
