brand_data <- read_csv("Data/Raw Data/Brand Lift Study Results - Sheet1.csv")

# Calculating Pooled Proportion
brand_data$Pooled_Proportion <- (brand_data$Control_Consideration + brand_data$Exposed_Consideration) / (brand_data$Control_Responses + brand_data$Exposed_Responses)

# Calculating Standard Error (SE)
brand_data$SE <- sqrt(brand_data$Pooled_Proportion * (1 - brand_data$Pooled_Proportion) * ((1/brand_data$Control_Responses) + (1/brand_data$Exposed_Responses)))

# Calculate Z-scores
brand_data$Z_score <- (brand_data$Exposed_Rate - brand_data$Control_Rate) / brand_data$SE

# Calculate P-values
brand_data$P_value <- 2 * (1 - pnorm(brand_data$Z_score))

# Test Significance with 5% Sig. Level
brand_data$IsSignificant <- brand_data$P_value < 0.05

# Filter Lift Studies based on Significance.
brand_data <- subset(brand_data, IsSignificant == TRUE)

# Save processed Data
write.csv(brand_data, "Processed_Brand_Lift_Results.csv", row.names = FALSE)