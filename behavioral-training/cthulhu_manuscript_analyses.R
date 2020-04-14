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
library(RColorBrewer)

# Analyses.
library(afex)
library(lme4)
library(lmerTest)
library(quickpsy)
library(lsmeans)

theme_set(theme_bw())

# Read in raw data.
file_names <- list.files(path = ".", pattern = "*.csv", all.files = FALSE,
                         full.names = FALSE, recursive = FALSE) # where you have your files


df <- data.frame(matrix(vector(), 0, 9,dimnames=list(c(),c("acc","block", "correct_response", "trial","fname","response","rt","session","subject"))),stringsAsFactors=F)

# Loop to create combined dataframe.
for (i in file_names) {
  data <- fread(i, header = TRUE, sep = ",")
  data <- `colnames<-`(data,  c("acc","block", "correct_response", "trial","fname","response","rt","session","subject"))
  df <- rbind(df, data)
}


# Set variables as approproiate types.
df$correct_response <- as.numeric(df$correct_response)
df$trial <- as.numeric(df$trial)
df$rt <- as.numeric(df$rt)

# Chop off session indicator numbers to get base subject number.
df$subject2 <- ifelse(nchar(df$subject)==3,substr(df$subject,1,1),substr(df$subject,1,2))
df$subject2 <- as.numeric(df$subject2)

# Cleanup.
rm(data)

# VOWEL TRAINING DESCRIPTIVES & ANALYSIS ####

# Separate training data.
training <- subset(df,grepl("training",block))

# Remove session 4 (not analyzed).
training <- subset(training,session!=4)

# Subset vowel training.
training.vowel <- subset(training,session!="S3")

# Summarize performance by subject for visualization.
training.stats.subj <- Rmisc::summarySE(data=training.vowel, measurevar="correct_response",groupvars=c("subject2","block","session")) # subject level

# Calculate number of blocks completed.
training.stats.subj$blocks.complete <- ifelse(training.stats.subj$N<62,1,
                                         ifelse(training.stats.subj$N>61&training.stats.subj$N<120,2,
                                                ifelse(training.stats.subj$N>120&training.stats.subj$N<182,3,NA)))

# Summarize training performance across subjects.
training.stats.avg <- Rmisc::summarySE(data=training.vowel, measurevar="correct_response",groupvars=c("block","session"))

# Training performance figure.
vowel.training.fig<-ggplot(training.stats.subj,aes(x=block,y=correct_response)) +
  geom_point(aes(x=block,color=session,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=training.stats.avg,aes(fill=session),stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Training day',palette="Set1") +
  scale_color_brewer('Training day',palette="Set1") +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=16))

# Day 3 figure for comparison.
vow_train_day3<-ggplot(subset(training.stats.subj,session==3),aes(x=block,y=correct_response)) +
  geom_point(aes(x=block,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=subset(training.stats.avg,session==3),stat="identity",fill="#4DAF4A",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=16))

# Set up mixed-effects models using afex.
training.vowel$block <- as.factor(training.vowel$block)
training.vowel$session <- as.factor(training.vowel$session)
training.vowel$subject2 <- as.factor(training.vowel$subject2)

training.model1 <- mixed(correct_response ~ block*session + (block:session||subject2) + (block||subject2) + (session||subject2), 
                         family=binomial(link="logit"),data=training.vowel,method="LRT",expand_re = TRUE,
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.model2 <- mixed(correct_response ~ block*session + (block:session||subject2), 
                         family=binomial(link="logit"),data=training.vowel,method="LRT",expand_re = TRUE,
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.model3 <- mixed(correct_response ~ block*session +
                           (block||subject2) + (session||subject2),
                         family=binomial(link="logit"),data=training.vowel,method="LRT",expand_re = TRUE,
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.model4 <- mixed(correct_response ~ block*session + (1|subject2),
                         family=binomial(link="logit"),data=training.vowel,method="LRT",expand_re = TRUE,
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

# Compare models.
anova(training.model1,training.model2,training.model3,training.model4)
training.model2

# VOWEL PHONETIC CATEGORIZATION ANALYSIS ####

# Subset continuum categorization data.
continuum <- subset(df,df$block=="continuum")

# Subset vowel sessions. 
continuum.vowel <- subset(continuum,continuum$session!="S3")

# Drop NA trials and trials where participants pressed the wrong key
continuum.vowel <- subset(continuum.vowel,continuum.vowel$response!="None")
continuum.vowel <- subset(continuum.vowel,continuum.vowel$response!="d")
continuum.vowel$response <- tolower(continuum.vowel$response)

# Create binary response variable.
continuum.vowel$cb <- ifelse(continuum.vowel$subject2==3|continuum.vowel$subject2==8|
                         continuum.vowel$subject2==11|continuum.vowel$subject2==12|
                         continuum.vowel$subject2==15|continuum.vowel$subject2==16|
                         continuum.vowel$subject2==20|continuum.vowel$subject2==24|
                         continuum.vowel$subject2==27|continuum.vowel$subject2==28|
                         continuum.vowel$subject2==31|continuum.vowel$subject2==32,"cb1","cb2")
continuum.vowelCB1 <- subset(continuum.vowel,continuum.vowel$cb=="cb1")
continuum.vowelCB2 <- subset(continuum.vowel,continuum.vowel$cb=="cb2")
continuum.vowelCB1$resp1 <- ifelse(continuum.vowelCB1$response=="a",1,0)
continuum.vowelCB2$resp1 <- ifelse(continuum.vowelCB2$response=="a",0,1)
continuum.vowel <- rbind(continuum.vowelCB1,continuum.vowelCB2)

# Create continuum step variable.
continuum.vowel$step <- substr(continuum.vowel$fname,10,10)

# Get summary of continuum categorization performance.
stats <- Rmisc::summarySE(continuum.vowel, measurevar="resp1",groupvars = c("step","session"))

# Plot continuum categorization performance.
PC.fig<-ggplot(stats, aes(x=as.numeric(step), y=resp1,color=factor(session))) +
  geom_point(stat='summary', fun.y='mean', size=3,alpha=0.7) +
  geom_line(stat='summary', fun.y='mean', size=1.25, alpha=0.7) +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  scale_color_brewer('Training day', labels=c('1','2','3'),palette="Set1") +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=16))

# RT figure.
stats <- Rmisc::summarySE(continuum.vowel, measurevar="rt",groupvars = c("step","session"))

ggplot(stats, aes(x=as.numeric(step),y=rt,color=factor(session))) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=rt-se,ymax=rt+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  theme(text = element_text(size=16))

# curve fitting to get boundaries
continuum.vowel$subject2 <- as.numeric(continuum.vowel$subject2)
continuum.vowel$step <- as.numeric(continuum.vowel$step)

# fit curves by session to get boundaries to compare to discrim peaks
session.subject.curves <- quickpsy(continuum.vowel, step, resp1, 
                                   grouping = .(subject2,session), 
                                   fun = logistic_fun,
                                   lapses = FALSE, 
                                   guess = FALSE,
                                   bootstrap = "nonparametric", 
                                   optimization = "optim",
                                   B = 1000)

session.curves <- quickpsy(continuum.vowel, step, resp1, 
                                   grouping = .(session), 
                                   fun = logistic_fun,
                                   lapses = FALSE, 
                                   guess = FALSE,
                                   bootstrap = "nonparametric", 
                                   optimization = "optim",
                                   B = 1000)

boundaries <- as.data.frame(session.subject.curves$par)
boundaries[5:6] <- list(NULL)
boundaries <- boundaries %>% spread(parn, par, drop=TRUE)
colnames(boundaries)[3] <- "Boundary"
colnames(boundaries)[4] <- "Slope"
save(boundaries,file="boundaries.Rda")

# mixed effects model
# prep data
continuum.vowel$step <- as.numeric(continuum.vowel$step)
continuum.vowel$step <- scale(continuum.vowel$step)
continuum.vowel$session <- as.factor(continuum.vowel$session)
continuum.vowel$subject2 <- as.factor(continuum.vowel$subject2)

# glmer model
PC.model1 <- mixed(resp1 ~ step*session + (step:session||subject2) + (step||subject2) + (session||subject2),
                   data=continuum.vowel,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa", calc.derivs = FALSE,optCtrl = list(maxfun = 150000)))

PC.model2 <- mixed(resp1 ~ step*session + (step:session||subject2),
                   data=continuum.vowel,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

PC.model3 <- mixed(resp1 ~ step*session + (step||subject2) + (session||subject2),
                   data=continuum.vowel, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

PC.model4 <- mixed(resp1 ~ step*session + (1|subject2),
                   data=continuum.vowel, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

# Compare models.
anova(PC.model1,PC.model2,PC.model3,PC.model4)
PC.model1

# VOWEL D' ====

# Subset to just discrimination blocks.
discrim <- subset(df,grepl("discrimination",block))

# Remove session 4.
discrim <- subset(discrim,session!=4)

# Subset vowel.
discrim.vowel <- subset(discrim,session!="S3")

# Create variable to combine forwards/backwards discrimination steps
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

# Make a new data frame that contains the data we need.
discrim.vowel <- discrim.vowel %>%
  group_by(session,subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

# Create proportion incorrect for use later in calculating d'.
discrim.vowel <- discrim.vowel %>% mutate(prop_incor=1-prop_cor)

# We will use this closure to create two functions: one to change 1 to .99 and 
# one to change 0 to .01 (.99 and .01 still have to be specified though).
cutoff <- function(value) {
  function(x,y) {
    x[x == value] <- y
    x
  }
}

cutoff_1 <- cutoff(1)
cutoff_0 <- cutoff(0)

# Apply function.
discrim.vowel$prop_cor <- cutoff_1(discrim.vowel$prop_cor,.99)
discrim.vowel$prop_cor <- cutoff_0(discrim.vowel$prop_cor,.01)
discrim.vowel$prop_incor <- cutoff_1(discrim.vowel$prop_incor,.99)
discrim.vowel$prop_incor <- cutoff_0(discrim.vowel$prop_incor,.01)

# d' for 1-3.
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-1" | discrim.vowel$discrim.token=="3-3")
dprime_temp_same <- dprime_temp_same %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-3")
dprime_temp_different <- dprime_temp_different %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_cor))
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

# d' for 2-4.
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-2" | discrim.vowel$discrim.token=="4-4")
dprime_temp_same <- dprime_temp_same %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-4")
dprime_temp_different <- dprime_temp_different %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_cor))
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

# d' for 3-5.
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-3" | discrim.vowel$discrim.token=="5-5")
dprime_temp_same <- dprime_temp_same %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-5")
dprime_temp_different <- dprime_temp_different %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_cor))
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

# d' for 4-6.
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-4" | discrim.vowel$discrim.token=="6-6")
dprime_temp_same <- dprime_temp_same %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-6")
dprime_temp_different <- dprime_temp_different %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_cor))
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

# d' for 5-7.
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-5" | discrim.vowel$discrim.token=="7-7")
dprime_temp_same <- dprime_temp_same %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-7")
dprime_temp_different <- dprime_temp_different %>% group_by(session,subject2,block) %>% summarize(mean=mean(prop_cor))
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

# Combine into one dataframe and cleanup.
dprime_individ <- data.frame()
dprime_individ <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# VOWEL PEAK DISCRIMINATION & RELATIVE BOUNDARY ####

# Get peak d' value for each subject.
peak.discrim <- dprime_individ %>% group_by(subject2,session,block) %>% slice(which.max(dprime))
peak.discrim <- select(peak.discrim,"session","subject2","dprime","stimulus","block")

# Combine with category boundaries.
load("boundaries.Rda")

# Round boundaries.
boundaries <- boundaries[rep(1:nrow(boundaries),2),]
boundaries$block[1:(nrow(boundaries)/2)] <- "pretest_discrimination"
boundaries$block[(1+nrow(boundaries)/2):nrow(boundaries)] <- "posttest_discrimination"
boundaries$Boundary <- round(boundaries$Boundary)

# Look at peak discrim token and boundaries.
peak.discrim$boundary <- boundaries$Boundary
peak.discrim <- subset(peak.discrim,boundary!=-8)

# Use this information to determine what is between-category and what is within-category.
dprime_individ$boundary <- NA
for (i in unique(dprime_individ$subject2)){
  for (s in unique(dprime_individ$session)){
    temp.boundaries <- boundaries[boundaries$subject2==i & boundaries$session==s,"Boundary"]
    dprime_individ$boundary <- ifelse(dprime_individ$subject2==i & dprime_individ$session==s,temp.boundaries,dprime_individ$boundary)
  }
}

dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==0&dprime_individ$stimulus=="3-5","BC","WC")
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==-8&dprime_individ$stimulus=="3-5","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==1&dprime_individ$stimulus=="1-3","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==2&dprime_individ$stimulus=="1-3","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==3&dprime_individ$stimulus=="2-4","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==4&dprime_individ$stimulus=="3-5","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==5&dprime_individ$stimulus=="4-6","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==6&dprime_individ$stimulus=="5-7","BC",dprime_individ$discrim.type)
dprime_individ$discrim.type <- ifelse(dprime_individ$boundary==7&dprime_individ$stimulus=="5-7","BC",dprime_individ$discrim.type)

# Create figure where discrim tokens are labeled relative to the individuals boundary.
dprime.relative.bound <- data.frame(matrix(vector(), 0, 10,
                                           dimnames=list(c(),c("session","subject2","block", "FA", "Hit","dprime",
                                                               "stimulus","boundary","discrim.type","relative.bound"))))

for (subj in unique(dprime_individ$subject2)){
  for(ses in unique(dprime_individ$session)){
    temp <- subset(dprime_individ,subject2==subj&session==ses)
    B.C. = dprime_individ[dprime_individ$subject2==subj&dprime_individ$discrim.type=="BC"&dprime_individ$session==ses,"stimulus"]
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

# Summarize for plotting.
dprime_rb_lineplot <- Rmisc::summarySE(dprime.relative.bound, measurevar="dprime",groupvars = c("session","relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))

# Create new variable to plot things more clearly.
dprime_rb_lineplot$plotting <- ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="pretest_discrimination",1,
ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="pretest_discrimination",2,
ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="pretest_discrimination",3,
ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="posttest_discrimination",4,
ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="posttest_discrimination",5,
ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="posttest_discrimination",6,""))))))

# Add factor to allow for translucent intervening lines and bold pre-test day 1 and post-test day 3 lines.
dprime_rb_lineplot$plotting2 <- as.factor(ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="pretest_discrimination"|
                                                   dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="posttest_discrimination",1,0))

# d' relative boundary figure.
dprime.relative.fig<-ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session,alpha=plotting2),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block,alpha=plotting2),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session,alpha=plotting2),width=.25,size=1.25) +
  scale_color_brewer('Training day',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  scale_alpha_manual(guide=FALSE,values=c(0.25,1)) +
  theme(text = element_text(size=16)) + 
  xlab("Token") + ylab("d' score")

# d' acoustic boundary figure.
dprime_ab_lineplot <- Rmisc::summarySE(dprime.relative.bound, measurevar="dprime",groupvars = c("session","stimulus","block"))

dprime_ab_lineplot$plotting <- ifelse(dprime_ab_lineplot$session==1&dprime_ab_lineplot$block=="pretest_discrimination",1,
ifelse(dprime_ab_lineplot$session==2&dprime_ab_lineplot$block=="pretest_discrimination",2,
ifelse(dprime_ab_lineplot$session==3&dprime_ab_lineplot$block=="pretest_discrimination",3,
ifelse(dprime_ab_lineplot$session==1&dprime_ab_lineplot$block=="posttest_discrimination",4,
ifelse(dprime_ab_lineplot$session==2&dprime_ab_lineplot$block=="posttest_discrimination",5,
ifelse(dprime_ab_lineplot$session==3&dprime_ab_lineplot$block=="posttest_discrimination",6,""))))))

# Add factor to allow for translucent intervening lines and bold pre-test day 1 and post-test day 3 lines.
dprime_ab_lineplot$plotting2 <- as.factor(ifelse(dprime_ab_lineplot$session==1&dprime_ab_lineplot$block=="pretest_discrimination"|
                                         dprime_ab_lineplot$session==3&dprime_ab_lineplot$block=="posttest_discrimination",1,0))

dprime.acoustic.fig <- ggplot(dprime_ab_lineplot,aes(x=stimulus,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session,alpha=plotting2),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block,alpha=plotting2),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session,alpha=plotting2),width=.25,size=1.25) +
  scale_color_brewer('Training day',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  scale_alpha_manual(guide=FALSE,values=c(0.25,1)) +
  theme(text = element_text(size=16)) + 
  xlab("Stimulus") + ylab("d' score")

# Just pre-test and final post-test for clarity.
day3_vow_discrim<-ggplot(subset(dprime_ab_lineplot,session==1&block=="pretest_discrimination"|session==3&block=="posttest_discrimination"),
              aes(x=stimulus,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_manual('Training day',values=c("#E41A1C","#4DAF4A")) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=16)) + 
  xlab("Stimulus") + ylab("d' score")
  
# Set up mixed-effects model on d' with relative boundary.
dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$discrim.type <- as.factor(dprime.relative.bound$discrim.type)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

lmem.relative.bound1 <- mixed(dprime ~ discrim.type*session*block + (session:block||subject2) + (session||subject2) + (block||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.relative.bound2 <- mixed(dprime ~ discrim.type*session*block + (session:block||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.relative.bound3 <- mixed(dprime ~ discrim.type*session*block + (session||subject2) + (block||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.relative.bound4 <- mixed(dprime ~ discrim.type*session*block + (1|subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

# compare models
anova(lmem.relative.bound1,lmem.relative.bound2,lmem.relative.bound3,lmem.relative.bound4)
lmem.relative.bound4

# mixed effects model on dprime with non-relative boundary (3-5 as BC)
dprime.relative.bound$acoustic.bound <- ifelse(dprime.relative.bound$stimulus=="3-5","BC","WC")

# set up factors
dprime.relative.bound$session <- as.factor(dprime.relative.bound$session)
dprime.relative.bound$acoustic.bound <- as.factor(dprime.relative.bound$acoustic.bound)
dprime.relative.bound$block <- as.factor(dprime.relative.bound$block)

lmem.acoustic.bound1 <- mixed(dprime ~ acoustic.bound*session*block + (block:session||subject2) + (block||subject2) + (session||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound2 <- mixed(dprime ~ acoustic.bound*session*block + (block||subject2) + (session||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 500000)))

lmem.acoustic.bound3 <- mixed(dprime ~ acoustic.bound*session*block + (session||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound4 <- mixed(dprime ~ acoustic.bound*session*block + (block||subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound5 <- mixed(dprime ~ acoustic.bound*session*block + (1|subject2),
data=dprime.relative.bound,expand_re = TRUE,
control = lmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

# compare models
anova(lmem.acoustic.bound1,lmem.acoustic.bound2,lmem.acoustic.bound3,lmem.acoustic.bound4,lmem.acoustic.bound5)
lmem.acoustic.bound5

# Compare acoustic boundary model and relative boundary model.
anova(lmem.acoustic.bound5,lmem.relative.bound4) # acoustic boundary model has superior fit.

# SINE TRAINING ####

# Separate training data.
training <- subset(df,grepl("training",block))

# Remove session 4 (not analyzed).
training <- subset(training,session!=4)

# Subset Sine training.
training.sine <- subset(training,session=="S3")

# Summarize performance by subject for visualization.
training.stats.subj <- Rmisc::summarySE(data=training.sine, measurevar="correct_response",groupvars=c("subject2","block")) # subject level

# Calculate number of blocks completed.
training.stats.subj$blocks.complete <- ifelse(training.stats.subj$N<62,1,
                                              ifelse(training.stats.subj$N>61&training.stats.subj$N<120,2,
                                                     ifelse(training.stats.subj$N>120&training.stats.subj$N<182,3,NA)))

# Summarize training performance across subjects.
training.stats.avg <- Rmisc::summarySE(data=training.sine, measurevar="correct_response",groupvars=c("block"))

# Create figure showing training performance across sessions and difficulty levels.
sine_training_fig <- ggplot(training.stats.subj,aes(x=block,y=correct_response)) +
  geom_point(aes(x=block,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=training.stats.avg,stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=16))

# Set up mixed-effects models.
training.sine$block <- as.factor(training.sine$block)
training.sine$subject2 <- as.factor(training.sine$subject2)

training.model.sine1 <- mixed(correct_response ~ block + (block|subject2), family=binomial(link="logit"),data=training.sine,method="LRT")
training.model.sine2 <- mixed(correct_response ~ block + (1|subject2), family=binomial(link="logit"),data=training.sine,method="LRT")

# Compare models.
anova(training.model.sine1,training.model.sine2)
training.model.sine1

# SINE PHONETIC CATEGORIZATION ####

# Subset continuum data.
continuum <- subset(df,df$block=="continuum")

# Subset sine sessions.
continuum.sine <- subset(continuum,continuum$session=="S3")

# Drop NA trials and trials where participants pressed the wrong key.
continuum.sine <- subset(continuum.sine,continuum.sine$response!="None")
continuum.sine <- subset(continuum.sine,continuum.sine$response!="d")
continuum.sine$response <- tolower(continuum.sine$response)

# Create binary response variable.
continuum.sine$cb <- ifelse(continuum.sine$subject2==3|continuum.sine$subject2==11|
                              continuum.sine$subject2==15|continuum.sine$subject2==20|continuum.sine$subject2==31,"cb1","cb2")
continuum.sineCB1 <- subset(continuum.sine,continuum.sine$cb=="cb1")
continuum.sineCB2 <- subset(continuum.sine,continuum.sine$cb=="cb2")
continuum.sineCB1$resp1 <- ifelse(continuum.sineCB1$response=="a",1,0)
continuum.sineCB2$resp1 <- ifelse(continuum.sineCB2$response=="a",0,1)
continuum.sine <- rbind(continuum.sineCB1,continuum.sineCB2)

# Create continuum step variable.
continuum.sine$step <- substr(continuum.sine$fname,9,9)

# Create data for figure.
stats_sine <- Rmisc::summarySE(continuum.sine, measurevar="resp1",groupvars = c("step"))

sine_PC_fig <- ggplot(stats_sine, aes(x=as.numeric(step),y=resp1)) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  #facet_wrap(~subject2) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  scale_y_continuous(breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=16)) +
  labs(y=expression(Percent~'/y/'['Sine']~responses))

# RT figure.
stats_sine <- Rmisc::summarySE(continuum.sine, measurevar="rt",groupvars = c("step"))

ggplot(stats_sine, aes(x=as.numeric(step),y=rt)) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=rt-se,ymax=rt+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  theme(text = element_text(size=16))

# Compare index of "categoricality" by doing t.test on slopes of psychometric functions.
boundaries <- subset(boundaries,session==3)
boundaries$sine_slopes <- sine.boundaries$Slope
t.test(boundaries$Slope,boundaries$sine_slopes,paired=TRUE)

# Combine RT stats to make one figure.
stats_sine$version <- "Sine-wave"
stats_sine$session <- 3
stats$version <- "Vowel"
rt_combined <- rbind(stats,stats_sine)

ggplot(rt_combined, aes(x=as.numeric(step),color=as.factor(session),y=rt)) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=rt-se,ymax=rt+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  facet_wrap(~version) +
  theme(text = element_text(size=16),legend.position = "NONE")


# Set up mixed-effects models.
PC.sine.model1 <- mixed(resp1 ~ step + (step|subject2), family=binomial(link="logit"),data=continuum.sine,method="LRT")
PC.sine.model2 <- mixed(resp1 ~ step + (1|subject2), family=binomial(link="logit"),data=continuum.sine,method="LRT")

# Compare models.
anova(PC.sine.model1,PC.sine.model2)
PC.sine.model1

# SINE d' ####

# Subset discrimination trials.
discrim <- subset(df,grepl("discrimination",block))

# Remove session 4.
discrim <- subset(discrim,session!=4)

# Subset Sine trials.
discrim.sine <- subset(discrim,session=="S3")

# Create variable to combine forwards/backwards discrimination steps.
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

# Summarize.
discrim.sine <- discrim.sine %>%
  group_by(subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

# Create proportion of incorrect trials for later calculations.
discrim.sine <- discrim.sine %>% mutate(prop_incor=1-prop_cor)

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

discrim.sine$prop_cor <- cutoff_1(discrim.sine$prop_cor,.99)
discrim.sine$prop_cor <- cutoff_0(discrim.sine$prop_cor,.01)
discrim.sine$prop_incor <- cutoff_1(discrim.sine$prop_incor,.99)
discrim.sine$prop_incor <- cutoff_0(discrim.sine$prop_incor,.01)

### 1-3 ###
dprime_temp_same <- subset(discrim.sine,discrim.sine$discrim.token=="1-1" | discrim.sine$discrim.token=="3-3")
dprime_temp_same <- dprime_temp_same %>% group_by(subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.sine,discrim.sine$discrim.token=="1-3")
dprime_temp_different <- dprime_temp_different %>% group_by(subject2,block) %>% summarize(mean=mean(prop_cor)) 
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
dprime_temp_same <- subset(discrim.sine,discrim.sine$discrim.token=="2-2" | discrim.sine$discrim.token=="4-4")
dprime_temp_same <- dprime_temp_same %>% group_by(subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.sine,discrim.sine$discrim.token=="2-4")
dprime_temp_different <- dprime_temp_different %>% group_by(subject2,block) %>% summarize(mean=mean(prop_cor)) 
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
dprime_temp_same <- subset(discrim.sine,discrim.sine$discrim.token=="3-3" | discrim.sine$discrim.token=="5-5")
dprime_temp_same <- dprime_temp_same %>% group_by(subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.sine,discrim.sine$discrim.token=="3-5")
dprime_temp_different <- dprime_temp_different %>% group_by(subject2,block) %>% summarize(mean=mean(prop_cor)) 
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
dprime_temp_same <- subset(discrim.sine,discrim.sine$discrim.token=="4-4" | discrim.sine$discrim.token=="6-6")
dprime_temp_same <- dprime_temp_same %>% group_by(subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.sine,discrim.sine$discrim.token=="4-6")
dprime_temp_different <- dprime_temp_different %>% group_by(subject2,block) %>% summarize(mean=mean(prop_cor)) 
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
dprime_temp_same <- subset(discrim.sine,discrim.sine$discrim.token=="5-5" | discrim.sine$discrim.token=="7-7")
dprime_temp_same <- dprime_temp_same %>% group_by(subject2,block) %>% summarize(mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.sine,discrim.sine$discrim.token=="5-7")
dprime_temp_different <- dprime_temp_different %>% group_by(subject2,block) %>% summarize(mean=mean(prop_cor)) 
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

# Combine into dataframe and cleanup.
dprime.sine.stimulus <- data.frame()
dprime.sine.stimulus <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# Figure out token at which max d' occurs.
peak.discrim.sine <- dprime.sine.stimulus %>% group_by(subject2,block) %>% slice(which.max(dprime))
peak.discrim.sine <- select(peak.discrim.sine,"subject2","dprime","stimulus","block")

# Combine with category boundaries.
load("sine.boundaries.Rda")

# Round boundaries.
sine.boundaries <- sine.boundaries[rep(1:nrow(sine.boundaries),2),]
sine.boundaries$block[1:26] <- "pretest_discrimination"
sine.boundaries$block[1.1:26.1] <- "posttest_discrimination"
sine.boundaries$Boundary <- round(sine.boundaries$Boundary)

# Look at peak discrim token and boundaries.
peak.discrim.sine$boundary <- sine.boundaries$Boundary
peak.discrim.sine <- subset(peak.discrim.sine,boundary!=-9)

# Use this information to determine what is between-category and what is within-category.
dprime.sine.stimulus$boundary <- NA
for (i in unique(dprime.sine.stimulus$subject2)){
  temp.boundaries <- sine.boundaries[sine.boundaries$subject2==i,"Boundary"]
  dprime.sine.stimulus$boundary <- ifelse(dprime.sine.stimulus$subject2==i,temp.boundaries,dprime.sine.stimulus$boundary)
}

dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==0&dprime.sine.stimulus$stimulus=="3-5","BC","WC")
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==9&dprime.sine.stimulus$stimulus=="3-5","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==1&dprime.sine.stimulus$stimulus=="1-3","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==2&dprime.sine.stimulus$stimulus=="1-3","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==3&dprime.sine.stimulus$stimulus=="2-4","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==4&dprime.sine.stimulus$stimulus=="3-5","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==5&dprime.sine.stimulus$stimulus=="4-6","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==6&dprime.sine.stimulus$stimulus=="5-7","BC",dprime.sine.stimulus$discrim.type)
dprime.sine.stimulus$discrim.type <- ifelse(dprime.sine.stimulus$boundary==7&dprime.sine.stimulus$stimulus=="5-7","BC",dprime.sine.stimulus$discrim.type)

# Create dataframe for figure where discrim tokens are labeled relative to the individuals boundary.
dprimesine.relative.bound <- data.frame(matrix(vector(), 0,9,
                                               dimnames=list(c(),c("subject2","block", "FA", "Hit","dprime",
                                                                   "stimulus","boundary","discrim.type","relative.bound"))))

# Loop that figures out what to label token relative to individual's BC token.
for (subj in unique(dprime.sine.stimulus$subject2)){
  for (b in unique(dprime.sine.stimulus$block)){
    temp <- subset(dprime.sine.stimulus,subject2==subj&block==b)
    B.C. = dprime.sine.stimulus[dprime.sine.stimulus$subject2==subj&dprime.sine.stimulus$block==b&dprime.sine.stimulus$discrim.type=="BC","stimulus"]
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

# Summarize resulting output.
dprime_rb_lineplot <- Rmisc::summarySE(dprimesine.relative.bound, measurevar="dprime",groupvars = c("relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))

# Relative boundary d' figure.
sine_dprime_relative_fig <- ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  ylab("d' score") +
  xlab('Token') +
  theme(text = element_text(size=16))

# Acoustic boundary d' figure.
dprime_lineplot <- Rmisc::summarySE(dprime.sine.stimulus, measurevar="dprime",groupvars = c("stimulus","block"))

sine_dprime_fig <- ggplot(dprime_lineplot,aes(x=stimulus,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,linetype=block),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  ylab("d' score") +
  xlab('Stimulus') +
  theme(text = element_text(size=16))

# Set up mixed-effects model on dprime with acoustic boundary (2-4 and 3-5 as BC).
dprimesine.relative.bound$acoustic.bound <- ifelse(dprimesine.relative.bound$stimulus=="3-5","BC","WC")
dprimesine.relative.bound$acoustic.bound <- as.factor(dprimesine.relative.bound$acoustic.bound)
dprimesine.relative.bound$block <- as.factor(dprimesine.relative.bound$block)

lmem.acoustic.bound1 <- mixed(dprime ~ acoustic.bound*block + 
                                   (block:acoustic.bound||subject2) + (block||subject2) + (acoustic.bound||subject2),
                                 data=dprimesine.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

lmem.acoustic.bound2 <- mixed(dprime ~ acoustic.bound*block + (block||subject2) + (acoustic.bound||subject2),
                                    data=dprimesine.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE, optCtrl = list(maxfun = 15000000)))

lmem.acoustic.bound3 <- mixed(dprime ~ acoustic.bound*block + 
                                (block:acoustic.bound||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound4 <- mixed(dprime ~ acoustic.bound*block + 
                                (block||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound5 <- mixed(dprime ~ acoustic.bound*block + 
                                (acoustic.bound||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.acoustic.bound6 <- mixed(dprime ~ acoustic.bound*block + 
                                (1|subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

# compare models
anova(lmem.acoustic.bound1,lmem.acoustic.bound3,lmem.acoustic.bound4,lmem.acoustic.bound5,lmem.acoustic.bound6)

# Results from best fitting model.
lmem.acoustic.bound1

# Set up mixed-effects model on d' with subject-relative boundaries.
dprimesine.relative.bound$discrim.type <- as.factor(dprimesine.relative.bound$discrim.type)

lmem.relative.bound1 <- mixed(dprime ~ discrim.type*block + 
                                (block:discrim.type||subject2) + (block||subject2) + (discrim.type||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.relative.bound2 <- mixed(dprime ~ discrim.type*block + 
                                (block:discrim.type||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

# lmem.relative.bound3 <- mixed(dprime ~ discrim.type*block +
#                                 (block||subject2) + (discrim.type||subject2),
#                               data=dprimesine.relative.bound,expand_re = TRUE,
#                               control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 500000)))
# does not converge

lmem.relative.bound4 <- mixed(dprime ~ discrim.type*block + 
                                (discrim.type||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.relative.bound5 <- mixed(dprime ~ discrim.type*block + 
                                (block||subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

lmem.relative.bound6 <- mixed(dprime ~ discrim.type*block + 
                                (1|subject2),
                              data=dprimesine.relative.bound,expand_re = TRUE,
                              control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

# Compare models.
anova(lmem.relative.bound1,lmem.relative.bound2,lmem.relative.bound4,lmem.relative.bound5,lmem.relative.bound6)

# Results from best model.
lmem.relative.bound1

# Compare fit of relative and acoustic boundary models.
anova(lmem.relative.bound1,lmem.acoustic.bound1)

# MANUSCRIPT FIGURES ####

# vowel d' figure
plot_grid(vowel.training.fig,PC.fig,dprime.acoustic.fig,dprime.relative.fig,labels=c("A","B","C","D"),nrow = 2)
ggsave("vowel_behavioral.pdf",dpi="retina",width=8.25,height=8,units="in")

# sine behavioral figure 
align_leftcol5 <- align_plots(sine_training_fig,sine_dprime_fig, align="hv", axis="tblr")
align_rightcol5 <- align_plots(sine_PC_fig, sine_dprime_relative_fig, align="hv", axis="tblr")
plot_grid(align_leftcol5[[1]],align_rightcol5[[1]],align_leftcol5[[2]],align_rightcol5[[2]],labels=c("A","B","C","D"))


# Comparison of Vowel and Sine ####

# Separate training data.
training <- subset(df,grepl("training",block))

# Remove session 4.
training <- subset(training,session!=4)

# Add stimulus type variable.
training$type <- ifelse(training$session=="S3","Sine-wave","Vowel")

# Set up model for training comparison
training$block <- as.factor(training$block)
training$type <- as.factor(training$type)

training.comp1 <- mixed(correct_response ~ block*type + (type:block||subject2) + (type||subject2) + (block||subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.comp2 <- mixed(correct_response ~ block*type + (type:block||subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.comp3 <- mixed(correct_response ~ block*type + (type||subject2) + (block||subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.comp4 <- mixed(correct_response ~ block*type + (block||subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.comp5 <- mixed(correct_response ~ block*type + (type||subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.comp6 <- mixed(correct_response ~ block*type + (1|subject2),
                        family=binomial(link="logit"),data=training,method="LRT",expand_re = TRUE,
                        control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

anova(training.comp1,training.comp2,training.comp3,training.comp4,training.comp5,training.comp6)
training.comp1

# Continuum categorization comparison between Vowel day 3 and SWS

# subset continuum data
continuum <- subset(df,df$block=="continuum")

# subset vowel sessions
continuum.vowel <- subset(continuum,continuum$session==3)

# drop NA trials and trials where people hit the wrong button
continuum.vowel <- subset(continuum.vowel,continuum.vowel$response!="None")
continuum.vowel <- subset(continuum.vowel,continuum.vowel$response!="d")
continuum.vowel$response <- tolower(continuum.vowel$response)

# create binary response variable
continuum.vowel$cb <- ifelse(continuum.vowel$subject2==3|continuum.vowel$subject2==8|
                               continuum.vowel$subject2==11|continuum.vowel$subject2==12|
                               continuum.vowel$subject2==15|continuum.vowel$subject2==16|
                               continuum.vowel$subject2==20|continuum.vowel$subject2==24|
                               continuum.vowel$subject2==27|continuum.vowel$subject2==28|
                               continuum.vowel$subject2==31|continuum.vowel$subject2==32,"cb1","cb2")
continuum.vowelCB1 <- subset(continuum.vowel,continuum.vowel$cb=="cb1")
continuum.vowelCB2 <- subset(continuum.vowel,continuum.vowel$cb=="cb2")
continuum.vowelCB1$resp1 <- ifelse(continuum.vowelCB1$response=="a",1,0)
continuum.vowelCB2$resp1 <- ifelse(continuum.vowelCB2$response=="a",0,1)
continuum.vowel <- rbind(continuum.vowelCB1,continuum.vowelCB2)

# create 'step' variable
continuum.vowel$step <- substr(continuum.vowel$fname,10,10)

# subset sine sessions
continuum.sine <- subset(continuum,continuum$session=="S3")

# drop NA trials and trials where people hit the wrong button
continuum.sine <- subset(continuum.sine,continuum.sine$response!="None")
continuum.sine <- subset(continuum.sine,continuum.sine$response!="d")
continuum.sine$response <- tolower(continuum.sine$response)

# create binary response variable
continuum.sine$cb <- ifelse(continuum.sine$subject2==3|continuum.sine$subject2==11|
                              continuum.sine$subject2==15|continuum.sine$subject2==20|continuum.sine$subject2==31,"cb1","cb2")
continuum.sineCB1 <- subset(continuum.sine,continuum.sine$cb=="cb1")
continuum.sineCB2 <- subset(continuum.sine,continuum.sine$cb=="cb2")
continuum.sineCB1$resp1 <- ifelse(continuum.sineCB1$response=="a",1,0)
continuum.sineCB2$resp1 <- ifelse(continuum.sineCB2$response=="a",0,1)
continuum.sine <- rbind(continuum.sineCB1,continuum.sineCB2)
rm(continuum.sineCB1,continuum.sineCB2,continuum.vowelCB1,continuum.vowelCB2)

# create 'step' variable
continuum.sine$step <- substr(continuum.sine$fname,9,9)

# combine transformed continuum datasets into one larger dataframe
continuum.comp <- rbind(continuum.sine,continuum.vowel)
#----------------------------------------------------------#
  
# prep variables for model
continuum.comp <- subset(continuum.comp,continuum.comp$session=="3"|continuum.comp$session=="S3")
continuum.comp$type <- ifelse(grepl("vowel",continuum.comp$fname),"Vowel","Sine-wave")
continuum.comp$step <- as.numeric(continuum.comp$step)
continuum.comp$step <- round(scale(continuum.comp$step,center=TRUE,scale=TRUE),digits=2)
continuum.comp$subject2 <- as.factor(continuum.comp$subject2)
continuum.comp$type <- as.factor(continuum.comp$type)
continuum.comp$fname <- as.factor(continuum.comp$fname)

# models 
PC.comp.model1 <- mixed(resp1 ~ step*type + (step:type||subject2) + (step||subject2) + (type||subject2),
                   data=continuum.comp,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa", calc.derivs = FALSE,optCtrl = list(maxfun = 150000)))

PC.comp.model2 <- mixed(resp1 ~ step*type + (step:type||subject2),
                   data=continuum.comp,  family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

PC.comp.model3 <- mixed(resp1 ~ step*type + (step||subject2) + (type||subject2),
                   data=continuum.comp, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

PC.comp.model4 <- mixed(resp1 ~ step*type + (1|subject2),
                   data=continuum.comp, family=binomial(link="logit"),method="LRT",expand_re = TRUE,
                   control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 150000)))

anova(PC.comp.model1,PC.comp.model2,PC.comp.model3,PC.comp.model4)
PC.comp.model1

# Post-hoc testing of significant interaction between step and stimulus type
lsm<-lsmeans(PC.comp.model1, ~ type|step, at = list(step=c(-1.5,-1,-0.5,0,0.5,1.0,1.5), adjust = "bonferroni"))
pairs(lsm)

# quick figure to show this difference (x axis has been mean centered hence its weirdness).
ggplot(continuum.comp, aes(x=step, y=resp1,color=type)) +
  geom_point(stat='summary', fun.y='mean', size=3,alpha=0.7) +
  geom_line(stat='summary', fun.y='mean', size=1.25, alpha=0.7) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=16))

# RT analysis to assess categoricity.

# Backtransform "step"
continuum.comp$step <- continuum.comp$step * attr(continuum.comp$step, 'scaled:scale') + attr(continuum.comp$step, 'scaled:center')

# SWS is overall slower than Vowel, so Z score within condition at each step.
continuum.comp <- continuum.comp %>% 
  group_by(type) %>% 
  mutate(zRT=scale(rt,center=TRUE,scale=TRUE))

# plot this
rt_plot <- Rmisc::summarySE(continuum.comp, measurevar="zRT",groupvars = c("step","step2","type"))

ggplot(rt_plot, aes(x=as.numeric(step),y=zRT,color=factor(type))) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=zRT-se,ymax=zRT+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  scale_color_manual("Stimulus set",values = c("Black","#4DAF4A")) +
  theme(text = element_text(size=16)) + ylab("Reaction time (z-score)")

# Analyze with mixed effects model
continuum.comp$step2 <- I(continuum.comp$step^2)

rt_comp1 <- mixed(zRT ~ type*step2 + (type:step2||subject2) + (type||subject2) + (step2||subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

rt_comp2 <- mixed(zRT ~ type*step2 + (type:step2||subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

rt_comp3 <- mixed(zRT ~ type*step2 + (type||subject2) + (step2||subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

rt_comp4 <- mixed(zRT ~ type*step2 + (step2||subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

rt_comp5 <- mixed(zRT ~ type*step2 + (type||subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

rt_comp6 <- mixed(zRT ~ type*step2 + (1|subject2),
                  data=continuum.comp,expand_re = TRUE,
                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

# Compare models
anova(rt_comp1,rt_comp2,rt_comp3,rt_comp4,rt_comp5,rt_comp6)
rt_comp3

# Comparison of slopes for categoricity

# Get vowel slopes ready
load("boundaries.Rda")
boundaries <- subset(boundaries,session==3)
boundaries$type <- "Vowel"
boundaries$session <- NULL

# Combine with Sine-wave data
load("sine.boundaries.Rda")
sine.boundaries$type <- "Sine-wave"
boundaries <- rbind(boundaries,sine.boundaries)

# Analyze
slope_comp <- mixed(Slope ~ type + (1|subject2),data=boundaries,expand_re = TRUE,
                    control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))
slope_comp

# Comparison of discrimination data.

# Add variables to data to ease combining.
dprimesine.relative.bound$session <- 3
dprimesine.relative.bound$type <- "Sine"
dprime.relative.bound$type <- "Vowel"

# Combine discrim data.
combined_discrim <- rbind(dprime.relative.bound,dprimesine.relative.bound)

# Set up models.
combined_discrim$type <- as.factor(combined_discrim$type)

comb.discrim.mod1 <- mixed(dprime ~ discrim.type*block*type + 
                             (block:discrim.type:type||subject2) + (block||subject2) + (discrim.type||subject2) + (type||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

comb.discrim.mod2 <- mixed(dprime ~ discrim.type*block*type + 
                             (block||subject2) + (discrim.type||subject2) + (type||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

comb.discrim.mod3 <- mixed(dprime ~ discrim.type*block*type + 
                             (discrim.type||subject2) + (type||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

comb.discrim.mod4 <- mixed(dprime ~ discrim.type*block*type + 
                             (type||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

comb.discrim.mod5 <- mixed(dprime ~ discrim.type*block*type + 
                             (discrim.type||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

comb.discrim.mod6 <- mixed(dprime ~ discrim.type*block*type + 
                             (block||subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))


comb.discrim.mod7 <- mixed(dprime ~ discrim.type*block*type + 
                             (1|subject2),
                           data=subset(combined_discrim,session==3),expand_re = TRUE,
                           control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 1500000)))

anova(comb.discrim.mod2,comb.discrim.mod4,comb.discrim.mod5,comb.discrim.mod6,comb.discrim.mod7)
comb.discrim.mod2

# Post-hoc testing of significant interactions
lsm2<-lsmeans(comb.discrim.mod2, ~ discrim.type|type,adjust = "bonferroni")
pairs(lsm2)

lsm3<-lsmeans(comb.discrim.mod2, ~ block|type,adjust = "bonferroni")
pairs(lsm3)
