"""
This script processes a CSV file with species data. It performs the following:
 
1. Reads the CSV file and prints each row, along with the species name.
2. Writes a new CSV file containing only the species name and body mass.
 
"""
import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
with open('../data/testcsv.csv','r') as f:

    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# write a file containing only species name and Body mass
with open('../data/testcsv.csv','r') as f:
    with open('../data/bodymass.csv','w') as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])
