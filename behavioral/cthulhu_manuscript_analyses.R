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
rm(data)

# VOWEL TRAINING DESCRIPTIVES & ANALYSIS ####

# separate training data
training <- subset(df,grepl("training",block))

# remove session 4
training <- subset(training,session!=4)

# subset vowel training
training.vowel <- subset(training,session!="S3")

# calculate error bars
training.stats <- summarySE(data=training.vowel, measurevar="correct_response",groupvars=c("subject2","block","session")) # subject level
training.stats <- summarySE(data=training.vowel, measurevar="correct_response",groupvars=c("block","session")) # group level
 
# calculate number of blocks completed
training.stats$blocks.complete <- ifelse(training.stats$N<62,1,
                                         ifelse(training.stats$N>61&training.stats$N<120,2,
                                                ifelse(training.stats$N>120&training.stats$N<182,3,NA)))
# summarize
training.stats.avg <- ddply(training.stats,.(block,session,blocks.complete),summarize,mean=mean(correct_response))

# overlay individual data points and group mean bars
id <- ddply(training.stats,.(subject2,block,session,blocks.complete),summarize,mean=mean(correct_response))
stats <- summarySE(data=training.stats, measurevar="correct_response",groupvars=c("block","session"))
gd <- select(stats,block,session,correct_response)
gd <- rename(gd,mean=correct_response)

# across session
vowel.training.fig<-ggplot(id,aes(x=block,y=mean)) +
  geom_point(aes(x=block,color=session,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=gd,aes(fill=session),stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_fill_brewer('Training day',palette="Set1") +
  scale_color_brewer('Training day',palette="Set1") +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=20))

# mixed effects model
training.vowel$block <- as.factor(training.vowel$block)
training.vowel$session <- as.factor(training.vowel$session)
training.vowel$subject2 <- as.factor(training.vowel$subject2)

# # add number of completed blocks to the training data
# for (i in unique(training.vowel$block)){
#   for (s in unique(training.vowel$session)){
#     for (f in unique(training.vowel$subject2)){
#       blocklength <- length(which(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f))
#       training.vowel$blocks.complete <- ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength<62,1,
#                                                ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength>61&blocklength<120,2,
#                                                       ifelse(training.vowel$block==i&training.vowel$session==s&training.vowel$subject2==f&blocklength>120&blocklength<182,3,
#                                                              training.vowel$blocks.complete)))
#     }
#   }
# }
# training$blocks.complete <- as.factor(training$blocks.complete)

training.model1 <- glmer(correct_response ~ block*session + (block:session||subject2) +
                           (block||subject2) + (session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE,optCtrl = list(maxfun = 100000)))

training.model2 <- glmer(correct_response ~ block*session + (block:session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.model3 <- glmer(correct_response ~ block*session +
                           (block||subject2) + (session||subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

training.model4 <- glmer(correct_response ~ block*session + (1|subject2),
                         data=training.vowel,family='binomial',
                         control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

afex.training.model <- mixed(correct_response ~ block*session + (block:session||subject2), 
                             family=binomial(link="logit"),data=training.vowel,method="LRT",expand_re = TRUE,
                             control = glmerControl(optimizer="bobyqa",calc.derivs = FALSE, optCtrl = list(maxfun = 100000)))

anova(training.model1,training.model2,training.model3,training.model4)
summary(training.model2)

# VOWEL PHONETIC CATEGORIZATION ANALYSIS ####

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

PC.fig<-ggplot(stats, aes(x=as.numeric(step), y=resp1,color=factor(session))) +
  geom_point(stat='summary', fun.y='mean', size=3,alpha=0.7) +
  geom_line(stat='summary', fun.y='mean', size=1.25, alpha=0.7) +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  scale_y_continuous('Percent /y/ responses', breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  scale_color_brewer('Training Day', labels=c('1','2','3'),palette="Set1") +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=20))

# curve fitting to get boundaries
continuum$subject2 <- as.numeric(continuum$subject2)
continuum$step <- as.numeric(continuum$step)

# fit curves by session to get boundaries to compare to discrim peaks
session.subject.curves <- quickpsy(continuum, step, resp1, 
                                   grouping = .(subject2,session), 
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

# D' FOR EACH VOWEL STIMULUS ====

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

# make a new data frame that contains the data we need
discrim.vowel <- discrim.vowel %>%
  group_by(session,subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

discrim.vowel <- discrim.vowel %>% mutate(prop_incor=1-prop_cor)

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

discrim.vowel$prop_cor <- cutoff_1(discrim.vowel$prop_cor,.99)
discrim.vowel$prop_cor <- cutoff_0(discrim.vowel$prop_cor,.01)
discrim.vowel$prop_incor <- cutoff_1(discrim.vowel$prop_incor,.99)
discrim.vowel$prop_incor <- cutoff_0(discrim.vowel$prop_incor,.01)

### 1-3 ###
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-1" | discrim.vowel$discrim.token=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-3")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-2" | discrim.vowel$discrim.token=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-4")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-3" | discrim.vowel$discrim.token=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-5")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-4" | discrim.vowel$discrim.token=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-6")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-5" | discrim.vowel$discrim.token=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(session,subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-7")
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

dprime_individ <- data.frame()
dprime_individ <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# VOWEL PEAK DISCRIMINATION & RELATIVE BOUNDARY ####

# get peak d' value for each subject
peak.discrim <- dprime_individ %>% group_by(subject2,session,block) %>% slice(which.max(dprime))
peak.discrim <- select(peak.discrim,"session","subject2","dprime","stimulus","block")

# combine with category boundaries
load("boundaries.Rda")

# round boundaries
boundaries <- boundaries[rep(1:nrow(boundaries),2),]
boundaries$block[1:(nrow(boundaries)/2)] <- "pretest_discrimination"
boundaries$block[(1+nrow(boundaries)/2):nrow(boundaries)] <- "posttest_discrimination"
boundaries$Boundary <- round(boundaries$Boundary)

# look at peak discrim token and boundaries
peak.discrim$boundary <- boundaries$Boundary
peak.discrim <- subset(peak.discrim,boundary!=-8)

# use this information to determine what is between-category and what is within-category
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

# create figure where discrim tokens are labeled relative to the individuals boundary
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

# summarize for plotting
dprime_rb_lineplot <- summarySE(dprime.relative.bound, measurevar="dprime",groupvars = c("session","relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))

# new variable to plot things more clearly
dprime_rb_lineplot$plotting <- ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="pretest_discrimination",1,
ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="pretest_discrimination",2,
ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="pretest_discrimination",3,
ifelse(dprime_rb_lineplot$session==1&dprime_rb_lineplot$block=="posttest_discrimination",4,
ifelse(dprime_rb_lineplot$session==2&dprime_rb_lineplot$block=="posttest_discrimination",5,
ifelse(dprime_rb_lineplot$session==3&dprime_rb_lineplot$block=="posttest_discrimination",6,""))))))

# d' relative boundary figure
dprime.relative.fig<-ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_brewer('Training day',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20)) + 
  xlab("Token") + ylab("d' score")

# d' acoustic boundary figure
dprime_ab_lineplot <- summarySE(dprime.relative.bound, measurevar="dprime",groupvars = c("session","stimulus","block"))

dprime_ab_lineplot$plotting <- ifelse(dprime_ab_lineplot$session==1&dprime_ab_lineplot$block=="pretest_discrimination",1,
ifelse(dprime_ab_lineplot$session==2&dprime_ab_lineplot$block=="pretest_discrimination",2,
ifelse(dprime_ab_lineplot$session==3&dprime_ab_lineplot$block=="pretest_discrimination",3,
ifelse(dprime_ab_lineplot$session==1&dprime_ab_lineplot$block=="posttest_discrimination",4,
ifelse(dprime_ab_lineplot$session==2&dprime_ab_lineplot$block=="posttest_discrimination",5,
ifelse(dprime_ab_lineplot$session==3&dprime_ab_lineplot$block=="posttest_discrimination",6,""))))))

dprime.acoustic.fig <- ggplot(dprime_ab_lineplot,aes(x=stimulus,y=dprime,group=plotting,color=session)) +
  geom_point(aes(color=session),stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(color=session,linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,color=session),width=.25,size=1.25) +
  scale_color_brewer('Training day',palette="Set1") +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  theme(text = element_text(size=20)) + 
  xlab("Stimulus") + ylab("d' score")

# mixed effects model on dprime with relative boundary
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

# mixed effects model on dprime with non-relative boundary (2-4 and 3-5 as BC)
dprime.relative.bound$acoustic.bound <- ifelse(dprime.relative.bound$stimulus=="2-4"|dprime.relative.bound$stimulus=="3-5","BC","WC")

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
anova(lmem.acoustic.bound1,lmem.acoustic.bound3,lmem.acoustic.bound4,lmem.acoustic.bound5)
lmem.acoustic.bound3

# SINE TRAINING ####
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

summarySE(data=training.sine.stats, measurevar="blocks.complete",groupvars=c("block"))

# summarize
training.sine.avg <- ddply(training.sine.stats,.(block,blocks.complete),summarize,mean=mean(correct_response))

# overlay individual data points and group mean bars
id <- ddply(training.sine.stats,.(subject2,block,blocks.complete),summarize,mean=mean(correct_response))
stats <- summarySE(data=training.sine.stats, measurevar="correct_response",groupvars=("block"))
gd <- select(stats,block,correct_response)
gd <- rename(gd,mean=correct_response)

# across session
sine_training_fig <- ggplot(id,aes(x=block,y=mean)) +
  geom_point(aes(x=block,shape=factor(blocks.complete)),position = position_dodge(width=1)) + 
  geom_bar(data=gd,stat="identity",alpha=0.5,position="dodge") +
  scale_y_continuous('Percent accuracy',breaks=c(0,0.25,0.5,0.75,1),labels=c(0,25,50,75,100)) +
  scale_x_discrete('Training level',labels=c('Easy 1-7','Medium 2-6','Hard 3-5')) +
  scale_shape_discrete('Training\nblock\nrepetitions') +
  coord_cartesian(ylim=c(0.4,1)) +
  theme(text=element_text(size=20))

# set up model
training.sine$block <- as.factor(training.sine$block)
training.sine$subject2 <- as.factor(training.sine$subject2)

afex.training.model.sine <- mixed(correct_response ~ block + (1|subject2), family=binomial(link="logit"),data=training.sine,method="LRT")
afex.training.model.sine
summary(afex.training.model.sine)

# SINE PHONETIC CATEGORIZATION ####

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

# create date for figure
stats_sine <- summarySE(continuum_sine, measurevar="resp1",groupvars = c("step"))

sine_PC_fig <- ggplot(stats_sine, aes(x=as.numeric(step),y=resp1)) +
  geom_point(stat='summary', fun.y='mean', size=2.5) +
  geom_line(stat='summary', fun.y='mean', size=1.5) +
  geom_errorbar(aes(ymin=resp1-se,ymax=resp1+se),width=.5) +
  #facet_wrap(~subject2) +
  scale_x_continuous('Continuum step', breaks=c(1:7)) +
  scale_y_continuous(breaks=c(0,0.25,0.5,0.75,1), labels=c(0,25,50,75,100)) +
  coord_cartesian(ylim=c(0,1)) + 
  theme(text = element_text(size=20)) +
  labs(y=expression(Percent~'/y/'['SWS']~responses))

# set up mixed-model
continuum_sine$step <- scale(as.numeric(continuum_sine$step))

PC.sine.model1 <- mixed(resp1 ~ step + (1|subject2), family=binomial(link="logit"),data=continuum_sine,method="LRT")
PC.sine.model1

# SWS d' ####
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


discrim.vowel <- discrim.sine %>%
  group_by(subject2,condition,discrim.token,block) %>%
  summarize(prop_cor = mean(correct_response))

discrim.vowel <- discrim.vowel %>% mutate(prop_incor=1-prop_cor)

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

discrim.vowel$prop_cor <- cutoff_1(discrim.vowel$prop_cor,.99)
discrim.vowel$prop_cor <- cutoff_0(discrim.vowel$prop_cor,.01)
discrim.vowel$prop_incor <- cutoff_1(discrim.vowel$prop_incor,.99)
discrim.vowel$prop_incor <- cutoff_0(discrim.vowel$prop_incor,.01)

### 1-3 ###
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-1" | discrim.vowel$discrim.token=="3-3")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="1-3")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-2" | discrim.vowel$discrim.token=="4-4")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="2-4")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-3" | discrim.vowel$discrim.token=="5-5")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="3-5")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-4" | discrim.vowel$discrim.token=="6-6")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="4-6")
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
dprime_temp_same <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-5" | discrim.vowel$discrim.token=="7-7")
dprime_temp_same <- ddply(dprime_temp_same,.(subject2,block),summarize,mean=mean(prop_incor))
dprime_temp_same$condition <- "FA"
dprime_temp_different <- subset(discrim.vowel,discrim.vowel$discrim.token=="5-7")
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

dprime.sine.stimulus <- data.frame()
dprime.sine.stimulus <- rbind(dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)
rm(dprime_temp_same,dprime_temp_different,dprime_temp1_3,dprime_temp2_4,dprime_temp3_5,dprime_temp4_6,dprime_temp5_7)

# figure out token at which max d' occurs
peak.discrim.sine <- dprime.sine.stimulus %>% group_by(subject2,block) %>% slice(which.max(dprime))
peak.discrim.sine <- select(peak.discrim.sine,"subject2","dprime","stimulus","block")

# combine with category boundaries
load("sine.boundaries.Rda")

# round boundaries
sine.boundaries <- sine.boundaries[rep(1:nrow(sine.boundaries),2),]
sine.boundaries$block[1:26] <- "pretest_discrimination"
sine.boundaries$block[1.1:26.1] <- "posttest_discrimination"
sine.boundaries$Boundary <- round(sine.boundaries$Boundary)

# look at peak discrim token and boundaries
peak.discrim.sine$boundary <- sine.boundaries$Boundary
peak.discrim.sine <- subset(peak.discrim.sine,boundary!=-9)

# use this information to determine what is between-category and what is within-category
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

# create figure where discrim tokens are labeled relative to the individuals boundary
dprimesine.relative.bound <- data.frame(matrix(vector(), 0,9,
                                               dimnames=list(c(),c("subject2","block", "FA", "Hit","dprime",
                                                                   "stimulus","boundary","discrim.type","relative.bound"))))
# loop that figures out what to label token relative to individual's BC token
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

# summarize resulting output
dprime_rb_lineplot <- summarySE(dprimesine.relative.bound, measurevar="dprime",groupvars = c("relative.bound","block"))
dprime_rb_lineplot$relative.bound <- factor(dprime_rb_lineplot$relative.bound,levels=c("WC-3","WC-2","WC-1","BC","WC+1","WC+2","WC+3","WC+4"))

# relative boundary d' figure
sine_dprime_relative_fig <- ggplot(dprime_rb_lineplot,aes(x=relative.bound,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  ylab("d' score") +
  xlab('Token') +
  theme(text = element_text(size=20))

# acoustic boundary d' figure
dprime_lineplot <- summarySE(dprime.sine.stimulus, measurevar="dprime",groupvars = c("stimulus","block"))

sine_dprime_fig <- ggplot(dprime_lineplot,aes(x=stimulus,y=dprime,group=block)) +
  geom_point(stat='summary', fun.y='mean', size=3.5) +
  geom_line(aes(linetype=block),stat='summary', fun.y='mean', size=2) +
  geom_errorbar(aes(ymin=dprime-se,ymax=dprime+se,linetype=block),width=.25,size=1.25) +
  scale_linetype_discrete('Block',labels=c("Post-test","Pre-test")) +
  ylab("d' score") +
  xlab('Stimulus') +
  theme(text = element_text(size=20))


# mixed effects model on dprime with acoustic boundary (2-4 and 3-5 as BC)
dprimesine.relative.bound$acoustic.bound <- ifelse(dprimesine.relative.bound$stimulus=="2-4"|dprimesine.relative.bound$stimulus=="3-5","BC","WC")
dprimesine.relative.bound$acoustic.bound <- as.factor(dprimesine.relative.bound$acoustic.bound)
dprimesine.relative.bound$block <- as.factor(dprimesine.relative.bound$block)

lmem.acoustic.bound1 <- mixed(dprime ~ acoustic.bound*block + 
                                   (block:acoustic.bound||subject2) + (block||subject2) + (acoustic.bound||subject2),
                                 data=dprimesine.relative.bound,expand_re = TRUE,
                                 control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE,optCtrl = list(maxfun = 150000)))

# lmem.acoustic.bound2 <- mixed(dprime ~ acoustic.bound*block + (block||subject2) + (acoustic.bound||subject2),
#                                     data=dprimesine.relative.bound,expand_re = TRUE,
#                                  control = lmerControl(optimizer="bobyqa",calc.derivs=FALSE, optCtrl = list(maxfun = 1000000)))
# does not converge

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

# results from best model
lmem.acoustic.bound1

# mixed effects model on dprime with subject-relative boundaries
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

# compare models
anova(lmem.relative.bound1,lmem.relative.bound2,lmem.relative.bound4,lmem.relative.bound5,lmem.relative.bound6)

# results from best model
lmem.relative.bound1
# MANUSCRIPT FIGURES ####

# vowel d' figure
plot_grid(vowel.training.fig,dprime.acoustic.fig,PC.fig,dprime.relative.fig,labels=c("A","C","B","D"),nrow = 2)

# sine behavioral figure 
align_leftcol5 <- align_plots(sine_training_fig, sine_PC_fig, align="hv", axis="tblr")
align_rightcol5 <- align_plots(sine_dprime_fig,sine_dprime_relative_fig, align="hv", axis="tblr")
plot_grid(align_leftcol5[[1]],align_rightcol5[[1]],align_leftcol5[[2]],align_rightcol5[[2]],labels=c("A","C","B","D"))

