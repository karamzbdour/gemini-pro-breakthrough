library(readr)

processed_brand_data <- read_csv("~/DigData Challenge/Repo/Data/Processed Data/Processed_Brand_Lift_Results.csv")
campaign_data <- read_csv("~/DigData Challenge/Repo/Data/Raw Data/Historic Campaign Data - Sheet1.csv")

# merging historic campaign data and statistically significant brand lift data
merged_data <- merge(processed_brand_data,campaign_data, by = c("Campaign_Name","Market","Channel"))

# Calculate Absolute Lift
merged_data$Abs_Lift <- (merged_data$Exposed_Rate - merged_data$Control_Rate)

# Calculate Volume of lifted users
merged_data$LiftVolume <- (merged_data$Abs_Lift * merged_data$Reach)

# Get Exchange Rates (USD -> GBP)
rates <- data.frame(
  Year = c(2021, 2022, 2023, 2024),
  Rate = c(0.73, 0.81, 0.80, 0.79) 
)

# Extract Year from Date for conversion
merged_data$Year <- as.numeric(format(as.Date(merged_data$Week_Start) , "%Y"))

# Add Conversion Rates to Data
merged_data <- merge(merged_data, rates, by = "Year", all.x = TRUE)

# Convert to GBP
merged_data$Spend_GBP <- (merged_data$Spend_USD * merged_data$Rate)

# Calculate CPLU (Cost Per Lifted User)
merged_data$CPLU <- (merged_data$Spend_GBP / merged_data$LiftVolume)

# Save Final Data
write.csv(merged_data, "Final Data.csv", row.names = FALSE)
