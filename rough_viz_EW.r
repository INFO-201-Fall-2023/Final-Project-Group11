library(dplyr)
library(stringr)
library(ggplot2)

source("data_wrangling.r")

df <- read.csv("unifiedData.csv")

df_f <- filter(df, Age != "All Ages", Education != "All Grades" )



smoking <- ggplot(df_f, aes(x = Education, y = Data.Value, color = Topic.Desc)) +
  geom_point()

plot(smoking)