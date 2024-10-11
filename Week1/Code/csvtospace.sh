#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file.csv>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Check if the file has a .csv extension
if [[ "$input_file" != *.csv ]]; then
    echo "Error: File '$input_file' is not a CSV file."
    exit 1
fi

# Create the output file name by replacing .csv with .txt
output_file="${input_file%.csv}.txt"

# Convert CSV to space-separated values
tr ',' ' ' < "$input_file" > "$output_file"

echo "Converted '$input_file' to '$output_file'."

