def fizzBuzz(n):
    i = 1
    while i < (n + 1):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)
        i += 1

if __name__ == "__main__":
    fizzBuzz(30)
