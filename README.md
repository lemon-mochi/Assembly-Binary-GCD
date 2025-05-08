# Assembly Binary GCD #

This is an implementation of the binary greatest common divisor algorithm using x86-64 assembly. The `binaryGCD` function in the `BinaryGCD.s` file expects the two inputs to be two 32-bit non-negative integers. In my computer algebra course (MACM 401) we had to implement this algorithm using the Maple computer algebra system. I wanted to see if this would be easier in assembly, as I believed it would be. In my opinion, Maple is much harder than assembly. This took way less time than the Maple implementation despite being many more lines of code (unsurprisngly).

## Compiling, running, and testing ##
To compile,
```
make
```
To delete the executable
```
make clean
```
To run,
```
./binaryGCD
```
You can add your own test cases to the `main.c` file to see if this function is working as intended.

