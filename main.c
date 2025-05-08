// main.c. May 8, 2025. Written by Gen Blaine
// This file contains tests for the BinaryGCD implemented in x86-64 assembly
# include <stdio.h>
# include <assert.h>

extern int binaryGCD(int a, int b);

void run_tests() {
    // Basic test cases
    assert(binaryGCD(4848, 4872) == 24);
    assert(binaryGCD(48, 18) == 6);
    assert(binaryGCD(18, 48) == 6);
    assert(binaryGCD(0, 5) == 5);
    assert(binaryGCD(5, 0) == 5);
    assert(binaryGCD(0, 0) == 0);
    printf("Passed basic tests\n");

    // Co-prime numbers
    assert(binaryGCD(17, 13) == 1);
    assert(binaryGCD(101, 103) == 1);
    printf("Passed co-primes\n");

    // Same numbers
    assert(binaryGCD(42, 42) == 42);
    assert(binaryGCD(100, 100) == 100);
    printf("passed same numbers\n");
}

int main() {
    run_tests();
    printf("All tests passed\n");
    return 0;
}