library(dplyr)
library(stringr)
library(ggplot2)

source("data_wrangling.r")

df <- read.csv("unifiedData.csv")

df_f <- filter(df, Age != "All Ages", Education != "All Grades" )

df_g <- group_by(df_f, Topic.Desc, Education)
df_g <- summarize(df_g, avg_rate = mean(Data.Value, na.rm = TRUE))


smoking <- ggplot(df_g, aes(x = Education, y = avg_rate, fill = Topic.Desc)) +
  geom_bar(stat = "identity")

plot(smoking)


