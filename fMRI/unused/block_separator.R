
# read in excel data
library(readxl)
library(dplyr)
data <- read_excel("~/Desktop/input/Cthulhu/1/jeff_pilot.xlsx")


# subset to blocks
block1 <- subset(data,data$count_main_sequence == 0)
block1 <- select(block1,fname)
block1$onset <- 0:159*2
block1$duration <- 2
write.csv(block1,"block1.csv")

block2 <- subset(data,data$count_main_sequence == 1)
block2 <- select(block2,fname)
block2$onset <- 0:159*2
block2$duration <- 2
write.csv(block2,"block2.csv")

block3 <- subset(data,data$count_main_sequence == 2)
block3 <- select(block3,fname)
block3$onset <- 0:159*2
block3$duration <- 2
write.csv(block3,"block3.csv")

block4 <- subset(data,data$count_main_sequence == 3)
block4 <- select(block4,fname)
block4$onset <- 0:159*2
block4$duration <- 2
write.csv(block4,"block4.csv")

block5 <- subset(data,data$count_main_sequence == 4)
block5 <- select(block5,fname)
block5$onset <- 0:159*2
block5$duration <- 2
write.csv(block5,"block5.csv")

block6 <- subset(data,data$count_main_sequence == 5)
block6 <- select(block6,fname)
block6$onset <- 0:159*2
block6$duration <- 2
write.csv(block6,"block6.csv")

block7 <- subset(data,data$count_main_sequence == 6)
block7 <- select(block7,fname)
block7$onset <- 0:159*2
block7$duration <- 2
write.csv(block7,"block7.csv")

block8 <- subset(data,data$count_main_sequence == 7)
block8 <- select(block8,fname)
block8$onset <- 0:159*2
block8$duration <- 2
write.csv(block8,"block8.csv")

block9 <- subset(data,data$count_main_sequence == 8)
block9 <- select(block9,fname)
block9$onset <- 0:159*2
block9$duration <- 2
write.csv(block9,"block9.csv")

block10 <- subset(data,data$count_main_sequence == 9)
block10 <- select(block10,fname)
block10$onset <- 0:159*2
block10$duration <- 2
write.csv(block10,"block10.csv")