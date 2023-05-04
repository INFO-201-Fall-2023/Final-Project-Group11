library(dplyr)
library(stringr)

risk_df <- read.csv("Behavioral_Risk_Factor_Data__Tobacco_Use__2011_to_present_.csv")
seasonally_df <- read.csv("Seasonally_Adjusted_LAUS_Estimates.csv")

# ---- risk_df CLEANUP ----

# Dataset is focused on Washington state
risk_df <- risk_df[risk_df$LocationDesc == "Washington", ]

# Removes the dash in 'YEAR'
risk_df <- risk_df[!grepl("-", risk_df$YEAR), ]

# Converts the character to an integer
risk_df$YEAR <- as.integer(risk_df$YEAR)

# Including and excluding specific rows
risk_df <- subset(risk_df, Gender %in% "Overall" & Race %in% "All Races" & 
                    !(MeasureDesc == "Quit Attempt in Past Year Among Every Day Cigarette Smokers"))

# Excludes specific columns
risk_df <- select(risk_df, -c(DisplayOrder, SubMeasureID, StratificationID1, StratificationID2, StratificationID3,
                              StratificationID4, TopicTypeId, TopicId, MeasureId, Data_Value_Footnote, DataSource,
                              Data_Value_Footnote_Symbol))



# ---- seasonally_df CLEANUP ---- 

# Stores years into a vector
years <- c(2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019)

# Focus the dataset on the specific years that was given
seasonally_df <- seasonally_df[seasonally_df$Year %in% years, ]

seasonally_df <- subset(seasonally_df, Area.Title %in% 
"Seattle-Bellevue-Everett, WA Metropolitan Division")

# Excludes specific columns
seasonally_df <- select(seasonally_df, -c(Area.Code, Month, Ref_Type, Version))

# Merge the two datasets
df <- merge(risk_df, seasonally_df, by.x = "YEAR", by.y = "Year")

# Side-note:
# The sample size are used throughout the entire year, which is why
# the number are the same for each month. 