library(dplyr)
library(stringr)
library(ggplot2)

# Calls the unified dataset
df <- read.csv("unifiedData.csv")

# Creates a new data frame
df_combined <- data.frame(
  Measure = c(df$Measure.Desc),
  Education = c(df$Education),
  Unemployment_rate = c(df$Unemployment.Rate),
  labor_force = c(df$Labor.Force)
)

#Filter out to find people who are currently have low education, have a high unemployment rate, and are currently are high in the labor force
df_combined <- filter(df_combined, Measure == "Current Smoking" | Education == "< 12th Grade"| Unemployment_rate > "5"| labor_force < "15000")

# Removes duplicated years, since the values will be the same throughout the year
# It included months (12 months), which is why years were duplicated 
duplicated_rows <- duplicated(df_combined)
df_unique <- subset(df_combined, !duplicated_rows)

filtered_data <- filter(df_combined, Measure == "Current Smoking" | Education == "< 12th Grade" | Unemployment_rate > 5 | labor_force < 15000)

# Calculate the counts for each category
category_counts <- summarise(filtered_data, 
                             Education_Count = sum(Education == "< 12th Grade"),
                             Labor_Force_Count = sum(labor_force > 1500),
                             Unemployment_Count = sum(Unemployment_rate > 8))

total_tobacco_users <- sum(df$Measure.Desc == "Current Smoking")

education_percent <- (sum(filtered_data$Education == "< 12th Grade") / total_tobacco_users) * 100
unemployment_percent <- (sum(filtered_data$Unemployment_rate > 8) / total_tobacco_users) * 100
labor_force_percent <- 100 - (education_percent + unemployment_percent)

# Create the pie chart with percentages using ggplot2
pie_data <- data.frame(
  Category = c("Education", "Labor Force", "Unemployment"),
  Count = unlist(category_counts)
)

# Create the pie chart using ggplot2
pie_chart <- ggplot(pie_data, aes(x = "", y = Count, fill = Category)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Education" = "forestgreen", "Labor Force" = "seagreen4", "Unemployment" = "tan")) +
  theme_void() +
  labs(title = "Proportion of Current Smoking Users",
       fill = "Category")

# Display the pie chart
print(pie_chart)