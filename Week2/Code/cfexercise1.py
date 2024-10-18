## import ##
import sys

## functions ##
def foo_1(x=4):  # give a default value
    """Calculate the square root"""
    return "The square root of %d is %d." % (x, x ** 0.5)

def foo_2(x=2, y=1):
    """Find the bigger of 2 numbers"""
    if x > y:
        return "%d is bigger than %d." % (x, y)
    elif x == y:
        return "%d is equal to %d." % (x, y)
    else:
        return "%d is bigger than %d." % (y, x)

def foo_3(x=1, y=2, z=3):
    """Sort 3 numbers from small to big"""
    if x >= y:
        tmp = y
        y = x
        x = tmp
    if y >= z:
        tmp = z
        z = y
        y = tmp
    return "These 3 numbers from small to large is %d <= %d <= %d." % (x, y, z)

def foo_4(x=5):
    """Calculate the factorial of x"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return "The factorial of %d is %d." % (x, result)
        
def foo_5(x=5):
    """Calculate the factorial of x, used with foo_7"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_7(x=5):
    """Print the outcome of foo_5, used with foo_5"""
    return "The factorial of %d is %d." % (x, foo_5(x))


def foo_6(x=5):
    """Calculate the factorial of x"""
    facto = 1
    y = x
    while x >= 1:
        facto = facto * x
        x = x - 1
    return "The factorial of %d is %d." % (y, facto)

def main(argv):
    """ Main entry point of the program """
    print(foo_1(4))
    print(foo_1(9))
    print(foo_2(1,2))
    print(foo_2(2,2))
    print(foo_3(1,2,3))
    print(foo_3(2,2,4))
    print(foo_4(5))
    print(foo_4(7))
    print(foo_5(4))
    print(foo_7(4))
    print(foo_5(8))
    print(foo_7(8))
    print(foo_6(3))
    print(foo_6(6))
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from command line"""
    status = main(sys.argv)
    sys.exit(status)
