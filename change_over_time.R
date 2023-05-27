# Brittney Oeur

library(dplyr)
library(stringr)
library(ggplot2)

# Calls the unified dataset
df <- read.csv("unifiedData.csv")

# Creates a new data frame
df_combined <- data.frame(
  Year = c(df$Year),
  combined_employment = c(df$Employment, df$Unemployment),
  Topic = c(df$Topic.Desc),
  Measure = c(df$Measure.Desc),
  LaborForce = c(df$Labor.Force),
  EmployRate = c(df$Employment.Rate),
  UnemployRate = c(df$Unemployment.Rate)
)

# Checks to see if the values are equal to those who are employed
df_combined$EmploymentStatus <- df_combined$combined_employment == df$Employment

# If they are employed, set them as 'Employed,' else, 'Unemployed'
df_combined$EmploymentStatus <- ifelse(df_combined$EmploymentStatus, "Employed", "Unemployed")

# Switches columns so that it shows the employment status first then the number of those who are employed or unemployed
df_combined <- df_combined[, c("Year", "EmploymentStatus", "Topic", "Measure", "LaborForce", "combined_employment", "EmployRate", "UnemployRate")]

# Group_by the selected columns:
selected_employed <- group_by(df_combined, Year, EmploymentStatus)

# Will change this dataframe later
# Gets the average of number of people who are employed and unemployed
mean_value <- summarize(selected_employed, avg_employment = mean(combined_employment))

# Will edit more of this later
# Graph for 'change over time'
change_over_time_emp <- ggplot(data = mean_value, aes(x = Year, y = avg_employment)) +
  geom_line(aes(col = EmploymentStatus)) +
  geom_point() +
  labs(y = "Values", x = "Years", color = "Employment Status")

plot(change_over_time_emp)
