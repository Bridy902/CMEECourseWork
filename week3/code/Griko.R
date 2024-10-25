library(ggplot2)

# Function to build an ellipse
build_ellipse <- function(hradius, vradius) {
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)  
  return(data.frame(x = x, y = y))
}

N <- 250 # Assign size of the matrix
M <- matrix(rnorm(N * N), N, N) # Build the matrix
eigvals <- eigen(M)$values # Find the eigenvalues
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # Build a dataframe

my_radius <- sqrt(N) # The radius of the circle is sqrt(N)
ellDF <- build_ellipse(my_radius, my_radius) # Dataframe to plot the ellipse
names(ellDF) <- c("Real", "Imaginary") # Rename the columns

# Plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary)) +
  geom_point(shape = I(3)) +
  theme(legend.position = "none") +
  geom_hline(aes(yintercept = 0)) +
  geom_vline(aes(xintercept = 0)) +
  geom_polygon(data = ellDF, aes(x = Real, y = Imaginary), alpha = 1/20, fill = "red")

# Print the plot
print(p)

# Create the directory if it doesn't exist
dir.create("week3/results", recursive = TRUE)

# Save the plot to the specified directory
ggsave("week3/results/Griko.pdf", plot = p, width = 8, height = 6)
