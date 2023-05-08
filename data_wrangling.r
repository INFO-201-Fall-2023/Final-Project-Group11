library(dplyr)
library(stringr)

risk_df <- read.csv("Behavioral_Risk_Factor_Data__Tobacco_Use__2011_to_present_.csv")
# Updated upstream
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

# Focus the dataset in the Seattle-Bellevue-Everett area
seasonally_df <- subset(seasonally_df, Area.Title %in% "Seattle-Bellevue-Everett, WA Metropolitan Division")

# Excludes specific columns
seasonally_df <- select(seasonally_df, -c(Area.Code, Month, Ref_Type, Version))

# Merge the two datasets
df <- merge(risk_df, seasonally_df, by.x = "YEAR", by.y = "Year")

# Renaming columns
df <- rename(df, Year = YEAR, 
             State.Abb = LocationAbbr, 
             State = LocationDesc,
             Topic.Type = TopicType,
             Topic.Desc = TopicDesc,
             Measure.Desc = MeasureDesc,
             Data.Value.Unit = Data_Value_Unit,
             Data.Value.Type = Data_Value_Type,
             Data.Value = Data_Value,
             Data.Value.Std.Err = Data_Value_Std_Err,
             Low.Confidence.Limit = Low_Confidence_Limit,
             High.Confidence.Limit = High_Confidence_Limit,
             Sample.Size = Sample_Size,
             Geolocation = GeoLocation,
             Month = Month_Str,)

# Side-note:
# The sample size are used throughout the entire year, which is why
# the number are the same for each month. 

# Assign a unique identifier to each row
df$id <- row.names(df)

# Employment Rate to check that unemployment rate is accurate
employment <- function(identification){
  id_df <- filter(df, id == identification)
  return(round(id_df$Employment/id_df$Labor.Force*100, 1))
}
df <- mutate(df, Employment.Rate = lapply(df$id, employment))
df$Employment.Rate <- as.numeric(df$Employment.Rate)

# relative smoking sample size label
df$Sample.Size <- as.numeric(df$Sample.Size)

df$Relative.Sample.Size <- ifelse(df$Sample.Size < 1000, "Small",
                                  ifelse(df$Sample.Size < 3000, "Medium", "Large"))


# rename the data frame
behavioral_risk_and_seasonally_adjusted_LAUS_estimates <- df

# summarization data frame
summarise(df)

# write.csv(behavioral_risk_and_seasonally_adjusted_LAUS_estimates, "unifiedData.csv")
unifiedFile <- read.csv("unifiedData.csv")

# IGNORE THIS:
# Convert list column to character vector
# behavioral_risk_and_seasonally_adjusted_LAUS_estimates$Employment.Rate <- sapply(behavioral_risk_and_seasonally_adjusted_LAUS_estimates$Employment.Rate, function(x) paste0(unlist(x), collapse = ", "))

# Write data frame to CSV file
# write.csv(behavioral_risk_and_seasonally_adjusted_LAUS_estimates, "unifiedData.csv", row.names = FALSE)
