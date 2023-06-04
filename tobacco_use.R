library(dplyr)
library(stringr)
library(ggplot2)

# Calls the unified dataset
df <- read.csv("unifiedData.csv")

# Creates a new data frame
df_combined <- data.frame(
  Year = c(df$Year),
  Age = c(df$Age),
  Race = c(df$Race),
  Topic = c(df$Topic.Desc),
  Measure = c(df$Measure.Desc),
  Sample_Size = c(df$Sample.Size),
  Data_Value = c(df$Data.Value)
)

# Filters out 'df_combined'
# Focuses on users that are currently smoking, all ages, and all races
df_combined <- filter(df_combined, Measure == "Current Smoking" | Measure == "Current Use", Age == "All Ages", Race == "All Races")

# Removes duplicated years, since the values will be the same throughout the year
# It included months (12 months), which is why years were duplicated 
duplicated_rows <- duplicated(df_combined)
df_unique <- subset(df_combined, !duplicated_rows)

# Tobacco use graph
tobacco_use_graph <- ggplot(data = df_unique, aes(x = Year, y = Data_Value)) +
  geom_line(aes(col = Topic)) +
  geom_point() +
  labs(y = "Percentage Use", 
       x = "Years", 
       color = "Types of Tobacco use",
       title = "Average Use of Tobacco in WA state (2011-2019)")

# write.csv(df_unique, "tobacco_use.csv", row.names = FALSE)

plot(tobacco_use_graph)