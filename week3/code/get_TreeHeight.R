#'
#' This script calculates tree heights from an input CSV file with angles and distances.
#' It validates the file, computes heights, and saves the results to a new CSV.
#'

# Getting user input from SHELL
 
if(interactive()) {

  shell_input <- "../data/trees.csv"  # Replace with the actual file path

} else {

  shell_input <- commandArgs(trailingOnly = TRUE)

}
 
if(length(shell_input) == 0) {

  stop("No input file provided. Please provide the name of 1 file.\n", call. = FALSE)

}
 
cat("Shell input is:", shell_input, "\n")
 
if(length(shell_input) != 1) {

  stop("Incorrect number of input files, please only input name of 1 file.\n", call. = FALSE)

} else {

  file_name <- basename(shell_input)

  file_name <- tools::file_path_sans_ext(file_name)

}
 
if(length(shell_input) == 0) {

  stop("No input file provided. Run the script with a single file as an argument.\nExample: Rscript script_name.R trees.csv", call. = FALSE)

} else if(length(shell_input) > 1) {

  stop("Too many input files provided. Please provide only one file.\nExample: Rscript script_name.R trees.csv", call. = FALSE)

}
 
# Function for Calculating tree heights

TreeHeight <- function(degrees, distance) {

  if(any(degrees < 0 | degrees > 90)) {

    warning("Some angles are outside the range [0, 90]. Heights may be invalid.")

  }

  if(any(distance <= 0)) {

    warning("Some distances are non-positive. Heights may be invalid.")

  }

  radians <- degrees * pi / 180

  height <- ifelse(distance > 0, distance * tan(radians), NA)

  return(height)

}
 
# Reading input file and validating

shell_input <- "D:/Bootcamp/data/trees.csv"

all_trees <- read.csv(shell_input)
 
required_columns <- c("Angle.degrees", "Distance.m")

if(!all(required_columns %in% colnames(all_trees))) {

  stop(paste("Input file must contain columns:", paste(required_columns, collapse = ", "), "\n"), call. = FALSE)

}
 
# Calculating tree heights

all_trees$Tree.Height.m <- TreeHeight(all_trees$Angle.degrees, all_trees$Distance.m)
 
# Saving calculated values to file

output_dir <- "../results/"

if(!dir.exists(output_dir)) {

  dir.create(output_dir, recursive = TRUE)

}
 
write_path <- file.path(output_dir, paste(file_name, "_treeheights_R.csv", sep = ""))

write.csv(all_trees, write_path, row.names = FALSE)
 
cat(paste("Success! Results saved to:", write_path, "\n"))
 