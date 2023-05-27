# Brittney Oeur

library(dplyr)
library(stringr)
library(ggplot2)

# Calls the unified dataset
df <- read.csv("unifiedData.csv")

combined_employment <- c(df$Employment, df$Unemployment)

df_combined <- data.frame(combined_employment)

df_combined$EmploymentStatus <- df_combined$combined_employment == df$Employment

df_combined$EmploymentStatus <- ifelse(df_combined$EmploymentStatus, "Employed", "Unemployed")

df_combined <- df_combined[, c("EmploymentStatus", "combined_employment")]

#change_over_time <- ggplot(data = df, aes(x = Year, y = test)) +
  #geom_line(aes(col = ))