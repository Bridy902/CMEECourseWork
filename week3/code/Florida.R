#'

#' Demonstrates sampling from a population and calculating the mean if the sample has more than 30 unique values.

#' Errors are captured during repeated sampling.

 require(tidyverse)
 
rm(list=ls())
 
load("../data/KeyWestAnnualMeanTemperature.RData")
 
ls()
 
head(ats)
plot(ats)
 
# Load data (assuming ats is already loaded)
actual_correlation <- cor(ats$Year, ats$Temp, method = "spearman")
cat("Observed correlation:", actual_correlation, "\n")
 
set.seed(123)  # For reproducibility
num_simulations <- 10000  # Number of randomizations
 
# Store random correlations
random_correlations <- replicate(num_simulations, {
  shuffled_temps <- sample(ats$Temp)  # Shuffle temperatures
  cor(ats$Year, shuffled_temps, method = "spearman")  # Calculate correlation
})
 
# Calculate p-value
p_value <- mean(random_correlations >= actual_correlation)
cat("P-value:", p_value, "\n")
 
# Plot histogram of random correlations
library(ggplot2)
 
ggplot(data.frame(Random_Correlations = random_correlations), aes(x = Random_Correlations)) +
  geom_histogram(binwidth = 0.01, fill = "skyblue", color = "black") +
  geom_vline(xintercept = actual_correlation, color = "red", linetype = "dashed") +
  labs(title = "Randomized Correlation Coefficients",
       x = "Correlation Coefficient", y = "Frequency") +
  theme_minimal()
 
cat("95% Confidence Interval of random correlations:",
    quantile(random_correlations, c(0.025, 0.975)), "\n")