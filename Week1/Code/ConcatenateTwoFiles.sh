#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <file1> <file2> <output_file>"
    echo "Please provide two input files and one output file name."
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Error: You must provide two input files and one output file."
    usage
fi

file1="$1"
file2="$2"
output_file="$3"

# Check if the first file exists
if [ ! -f "$file1" ]; then
    echo "Error: File '$file1' not found."
    exit 1
fi

# Check if the second file exists
if [ ! -f "$file2" ]; then
    echo "Error: File '$file2' not found."
    exit 1
fi

# Merge the two files into the output file
cat "$file1" > "$output_file"
cat "$file2" >> "$output_file"

echo "Merged file is: $output_file"
cat "$output_file"
