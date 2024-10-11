#!/bin/sh
# Author: Your Name <lg1824@ic.ac.uk>
# Script: tabtocsv.sh
# Description: Create a comma-delimited version of a tab-delimited file.
# Arguments: 1 -> tab-delimited file
# Date: Oct 2024

# Function to display usage
usage() {
    echo "Usage: $0 <input_file>"
    echo "Please provide a tab-delimited file."
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Error: You must provide one input file."
    usage
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Create the output file name by appending .csv
output_file="${input_file}.csv"

# Inform the user about the conversion
echo "Creating a comma-delimited version of '$input_file'..."

# Convert tabs to commas and save to the output file
tr -s "\t" "," < "$input_file" > "$output_file"

# Confirm completion
echo "Done! The comma-delimited file is saved as '$output_file'."
exit 0

