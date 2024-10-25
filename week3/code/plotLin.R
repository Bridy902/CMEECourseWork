# Load necessary library
library(ggplot2)

# Generate data
x <- seq(0, 100, by = 0.1)
y <- -4 + 0.25 * x + rnorm(length(x), mean = 0, sd = 2.5)

# Put them in a dataframe
my_data <- data.frame(x = x, y = y)

# Perform a linear regression
my_lm <- lm(y ~ x, data = my_data)

# Plot the data
p <- ggplot(my_data, aes(x = x, y = y, colour = abs(my_lm$residuals))) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none") +
  scale_x_continuous(
    expression(alpha^2 * pi / beta * sqrt(Theta))
  )

# Add the regression line
p <- p + geom_abline(intercept = coef(my_lm)[1], slope = coef(my_lm)[2], colour = "red")

# Add annotation
p <- p + annotate("text", x = 60, y = 0, label = "sqrt(alpha) * 2 * pi", 
                  parse = TRUE, size = 6, colour = "blue")

# Print the plot
dev.new()
print(p)

# Save the plot
ggsave("week3/results/MyLinReg.pdf", plot = p)

