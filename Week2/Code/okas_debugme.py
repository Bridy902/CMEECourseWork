
import csv
import sys
import doctest
import os

def is_an_oak(name):
    """ Returns True if name starts with 'quercus' 
    >>> is_an_oak('quercus petraea')
    True
    >>> is_an_oak('Quercus petraea')
    True
    >>> is_an_oak('Quercuss petraea')
    False
    >>> is_an_oak('Quercusquercus petraea')
    False
    >>> is_an_oak('Fraxinus excelsior')
    False
    >>> is_an_oak('Fagus sylvatica')
    False
    """
    return name.lower().split()[0] == 'quercus'

def main(argv):
    output_dir = '../results'
    os.makedirs(output_dir, exist_ok=True)

    input_file = '../data/TestOaksData.csv'
    output_file = os.path.join(output_dir, 'JustOakData.csv')

    try:
        # Use 'with' to ensure files are properly opened and closed
        with open(input_file, 'r', newline='') as f, open(output_file, 'a', newline='') as g:
            taxa = csv.reader(f)
            csvwrite = csv.writer(g)

            for row in taxa:
                if 'Genus' in row[0]:
                    csvwrite.writerow([row[0], row[1]])  # Include column headers
                    continue

                print(f"Processing row: {row}")
                genus = row[0]
                print(f"The genus is: {genus}\n")
                
                if is_an_oak(genus):
                    print('FOUND AN OAK!\n')
                    csvwrite.writerow([genus, row[1]])

    except FileNotFoundError:
        print(f"Error: The file {input_file} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

    return 0

if __name__ == "__main__":
    status = main(sys.argv)
    doctest.testmod()



