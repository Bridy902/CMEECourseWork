#'
#' This script analyzes predator-prey mass relationships:
#' 1. Filters groups with sufficient data for regression.
#' 2. Plots log-transformed predator vs. prey mass with regression lines.
#' 3. Performs linear regression by group and extracts statistics.
#' 4. Saves the plot to a PDF and regression results to a CSV file.
#'

library(ggplot2)
library(scales)
library(tidyverse)
 
# Load the dataset

data <- read.csv("../data/EcolArchives-E089-51-D1.csv")
 
# Convert relevant columns to factors

data$Type.of.feeding.interaction <- as.factor(data$Type.of.feeding.interaction)

data$Predator.lifestage <- as.factor(data$Predator.lifestage)

data$Prey.mass.unit <- as.factor(data$Prey.mass.unit)
 
# Filter to remove zero or negative values for mass

data <- data %>% filter(Prey.mass > 0, Predator.mass > 0)
 
# Remove unnecessary columns and rename

data <- data.frame(data$Predator.mass, data$Type.of.feeding.interaction, data$Prey.mass, data$Predator.lifestage)

colnames(data) <- c("Predator.mass", "Type.of.feeding.interaction", "Prey.mass", "Predator.lifestage")
 
# Filter groups with at least 2 data points to ensure valid regression analysis

data <- data %>%

  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%

  filter(n() > 2)
 
# PLOTTING
 
# Create the plot

plot <- ggplot(data, aes(x = log10(Prey.mass), y = log10(Predator.mass))) +

  geom_point(aes(colour = Predator.lifestage), shape = 3) +

  geom_smooth(aes(colour = Predator.lifestage), method = "lm", fullrange = TRUE, linewidth = 0.5, se = FALSE) +

  facet_grid(Type.of.feeding.interaction ~ .) +

  theme_bw() +

  labs(x = "Prey Mass in grams", y = "Predator Mass in grams") +

  theme(legend.position = "bottom",

        legend.title = element_text(face = "bold")) +

  guides(colour = guide_legend(nrow = 1)) +

  coord_fixed(ratio = 0.5) +

  scale_x_continuous(labels = scales::scientific) +

  scale_y_continuous(labels = scales::scientific)
 
# Save the plot to a PDF

ggsave("../results/PP_Regress.pdf", plot = plot, width = 8, height = 10)
 
# STATISTICAL ANALYSIS
 
# Perform linear regression for each group

fitted_models <- data %>%

  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%

  do(model = lm(log10(Predator.mass) ~ log10(Prey.mass), data = .))
 
# Initialize results data frame

results_lm <- data.frame(

  Type.of.feeding.interaction = fitted_models$Type.of.feeding.interaction,

  Predator.lifestage = fitted_models$Predator.lifestage,
  
  Slope = NA,

  Intercept = NA,

  R.squared = NA,

  F.value = NA,

  P.value = NA

)
 
# Extract regression statistics for each model

for (row in seq_along(fitted_models$model)) {

  model_summary <- summary(fitted_models$model[[row]])

  # Extract coefficients

  results_lm$Intercept[row] <- coef(model_summary)[1]

  results_lm$Slope[row] <- coef(model_summary)[2]

  # Extract R-squared, F-value, and P-value

  results_lm$R.squared[row] <- model_summary$r.squared

  results_lm$F.value[row] <- model_summary$fstatistic[1]

  results_lm$P.value[row] <- pf(

    model_summary$fstatistic[1],

    model_summary$fstatistic[2],

    model_summary$fstatistic[3],

    lower.tail = FALSE

  )

}
 
# Save results to CSV

write.csv(results_lm, "../results/PP_Regress_Results.csv", row.names = FALSE)
 