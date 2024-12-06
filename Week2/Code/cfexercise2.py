########################
def hello_1(x):
    """
    Prints "hello" for every number divisible by 3 in the range [0, x).
    """
    for j in range(x):  # Iterate over the range [0, x)
        if j % 3 == 0:  # Check if the current number is divisible by 3
            print('hello')  # Print "hello"
    print(' ')  # Print an empty line for separation
 
hello_1(12)  # Call the function with x = 12
 
########################
def hello_2(x):
    """
    Prints "hello" for numbers in the range [0, x) based on specific conditions:
    - If the remainder of the number divided by 5 is 3
    - OR if the remainder of the number divided by 4 is 3
    """
    for j in range(x):  # Iterate over the range [0, x)
        if j % 5 == 3:  # Check if the remainder when divided by 5 is 3
            print('hello')  # Print "hello"
        elif j % 4 == 3:  # Check if the remainder when divided by 4 is 3
            print('hello')  # Print "hello"
    print(' ')  # Print an empty line for separation
 
hello_2(12)  # Call the function with x = 12
 
########################
def hello_3(x, y):
    """
    Prints "hello" for every number in the range [x, y).
    """
    for i in range(x, y):  # Iterate over the range [x, y)
        print('hello')  # Print "hello"
    print(' ')  # Print an empty line for separation
 
hello_3(3, 17)  # Call the function with x = 3, y = 17
 
########################
def hello_4(x):
    """
    Prints "hello" and increments x by 3 until x equals 15.
    """
    while x != 15:  # Continue looping until x equals 15
        print('hello')  # Print "hello"
        x = x + 3  # Increment x by 3
    print(' ')  # Print an empty line for separation
 
hello_4(0)  # Call the function with x = 0
 
########################
def hello_5(x):
    """
    Prints "hello" under specific conditions while x < 100:
    - If x equals 31, prints "hello" 7 times in a nested loop.
    - If x equals 18, prints "hello" once.
    """
    while x < 100:  # Continue looping until x >= 100
        if x == 31:  # Check if x equals 31
            for k in range(7):  # Nested loop to print "hello" 7 times
                print('hello')
        elif x == 18:  # Check if x equals 18
            print('hello')  # Print "hello"
        x = x + 1  # Increment x by 1
    print(' ')  # Print an empty line for separation
 
hello_5(12)  # Call the function with x = 12
 
########################
def hello_6(x, y):
    """
    Continuously prints "hello!" followed by the value of y, incrementing y by 1.
    The loop breaks when y equals 6.
    """
    while x:  # Continue looping while x is True
        print("hello! " + str(y))  # Print "hello!" followed by the value of y
        y += 1  # Increment y by 1
        if y == 6:  # Check if y equals 6
            break  # Exit the loop
    print(' ')  # Print an empty line for separation
 
hello_6(True, 0)  # Call the function with x = True, y = 0