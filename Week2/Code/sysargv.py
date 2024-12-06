"""

This script demonstrates the use of the `sys.argv` module to handle command-line arguments.
 
1. Prints the name of the script being executed.

2. Displays the number of command-line arguments passed to the script.

3. Outputs the list of all command-line arguments as a string.
 
Usage:

Run the script with additional arguments to see how they are captured by `sys.argv`.

"""

import sys
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: " , str(sys.argv))