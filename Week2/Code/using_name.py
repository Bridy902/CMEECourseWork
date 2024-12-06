"""
This script demonstrates the use of the `__name__` variable to determine whether the script is being executed directly or imported as a module.
 
1. Prints a message indicating if the script is run directly or imported.
2. Outputs the name of the current module using `__name__`.
"""

if __name__ == '__main__':
    print('This program is being run by itself!')
else:
    print('I am being imported from another script/program/module!')

print("This module's name is: " + __name__)