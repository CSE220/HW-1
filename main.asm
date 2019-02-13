# type your first and last name here
# type your Net ID here (e.g., jmsmith)
# type your SBU ID # here (e.g., 111234567)

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
    beq $a0, 4, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here


exit:
    li $a0, '\n'
    li $v0, 11
    syscall
    li $v0, 10
    syscall