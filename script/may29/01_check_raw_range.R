library(readxl)
library(tidyverse)
 lincoln <- read_xlsx("/home/schnablelab/PROJECTS/RAWDATA/data/May29_Data/220725 Inbred HIPS - SAM - Lincoln 2022 - Turkus Summary.xlsx",
                      sheet = "Index")
 

plot_level <- read_csv("/home/schnablelab/PROJECTS/RAWDATA/data/May29_Data/HIPS_INBREDS_V12_1.csv")
plot_level <- plot_level %>% filter(is.na(row & range))
lincoln_v2 <- lincoln %>% select(`Plot ID`, `Genotype (with @ removed)`, Row, Range) %>% mutate(
  `Genotype (with @ removed)` = str_squish(tolower(as.character(`Genotype (with @ removed)`)))
) %>% rename(genotype = `Genotype (with @ removed)`)
 
plot_level_v2 <- plot_level %>% rename(Plot_Id = plotNumber)
plot_level_v2 <- plot_level_v2 %>% mutate(genotype = str_squish(tolower(as.character(genotype)))) %>% select(genotype, Plot_Id)
setdiff(plot_level_v2$Plot_Id, lincoln_v2$`Plot ID`)
setdiff(plot_level_v2$genotype, lincoln_v2$genotype)

setdiff(lincoln_v2$`Plot ID`, plot_level_v2$Plot_Id)

setdiff(lincoln_v2$genotype, plot_level_v2$genotype)
