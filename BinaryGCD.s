# BinaryGCD.s May 8, 2025. Written by Gen Blaine
# binary GCD algorithm takes two positive 32-bit integers, a and b
# the algorithm returns the greatest common divisor of the two integers

.globl  binaryGCD # make binaryGCD global for the C file.

# this is a helper function for taking two to the power of some 
# input: positive 32-bit integer, power
# output: 2 ^ power (32-bit integer)
two_to_the_power:
    # the power is stored in register %edi (first argument and 32 bits)
    .start:
        pushq	%rbp
        movq	%rsp, %rbp
        movl	%edi, -20(%rbp) # move the power into the stack
        movl	$1, %eax # initialize the return value to 1
        movl	$0, -4(%rbp) # i = 0
        jmp	.condition
    .loop:
        sall	%eax # left shift return value by 1 bit (multiply by 2)
        addl	$1, -4(%rbp) # i++
    .condition:
        movl	-4(%rbp), %ecx # store i in %ecx 
        cmpl	-20(%rbp), %ecx # compare i to power
        jl	.loop # enter loop if i is les than the power
        popq	%rbp
        ret

# this is the caller function
binaryGCD:
    # a is in %edi, b is in %esi
    .begin:
        pushq	%rbp
        movq	%rsp, %rbp
        subq	$24, %rsp # allocate 24 bytes
        movl	%edi, -20(%rbp) # store a in -20 on stack
        movl	%esi, -24(%rbp) # store b in -24 on stack
        movl	$0, -8(%rbp) # initialize k to 0
        # check if b == 0. In this specific case, we must return a.
        cmpl    $0, %esi
        jne .out_of_loop # jump to loop condition if b != 0

        # here b is 0. Return a
        movl    %edi, %eax # move a into the return register
        leave
        ret       

    .check_swap:
        # perform the tests and swaps
        movl    -20(%rbp), %eax
        cmpl    -24(%rbp), %eax # if (a < b)
        jl .swap # swap if a < b

        jmp .check_even # skip the swap step if a >= b
    
    .check_even:
        # here, a >= b
        # now, check for evenness
        # to check if 2 divides a or b, we can and a and b with 1. 
        movl	-20(%rbp), %eax # move a into the return register
        andl	$1, %eax # and a with 1 to check if it is even
        # store 1 if a is odd, 0 if even in -10(%rbp)
        movb	%al, -10(%rbp)
        
        # do the same thing for b
        movl	-24(%rbp), %eax # move b into the return register
        andl	$1, %eax # and b with 1 to check if it is even
        # store 1 if b is odd, 0 if even in -9(%rbp)
	    movb	%al, -9(%rbp)

        jmp .check_cases

    .swap:
        # here, a < b and we must swap first
        movl	-24(%rbp), %eax # %eax contains a temporary value (b)
        movl    -20(%rbp), %edx # %edx now contains a
        movl    %edx, -24(%rbp) # b = a
        movl    %eax, -20(%rbp) # a = temp

        jmp .check_even

    .check_cases:
        # -10(%rbp) contains whether a is even
        # -9(%rbp) contains whether b is even
        cmpb   $0, -10(%rbp)
        je .a_is_even

        # test if b is even
        cmpb    $0, -9(%rbp)
        je .b_is_even

        # here, both are odd
        jmp .both_odd

    .a_is_even:
        # when a is even, divide by two (same as right shifting by one bit)
        movl    -20(%rbp), %eax
        shrl    %eax
        movl    %eax, -20(%rbp)
        # handle cases where b is also even.
        cmpb    $0, -9(%rbp)
        je .both_even
        # move on to next iteration
        jmp .out_of_loop

    .both_even:
        # when b is also even, right shift b by one bit and increment k
        movl    -24(%rbp), %eax
        shrl    %eax
        movl    %eax, -24(%rbp)
        addl    $1, -8(%rbp)
        jmp .out_of_loop

    .b_is_even:
        # dividing by two is the same as right shifting by one bit
        movl    -24(%rbp), %eax
        shrl    %eax
        movl    %eax, -24(%rbp)
        jmp .out_of_loop

    .both_odd:
        # when both are odd, we subtract b from a and set that as a.
        # this forces a to be even in the next iteration.
        movl    -24(%rbp), %eax
        subl    %eax, -20(%rbp)
        jmp .out_of_loop

    .out_of_loop:
        # conidtion to continue loop
        cmpl	$0, -20(%rbp) # compare 0 to a
        jne	.check_swap # jump into .check_swap if a != 0
        # at this point, a == 0, and we may proceed outside of the loop
        # Gcd is 2^k * b
        # -8(%rbp) contains k. # Move into first argument register for the helper function
        movl	-8(%rbp), %edi 
        call	two_to_the_power
        # multiply b by 2^k. %eax is the return register which contains the returned value of 
        # the helper function, two_to_the_power. Store the entire thing in the return register
        imull	-24(%rbp), %eax
        leave
        ret
