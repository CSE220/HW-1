# Sayan Sivakumaran
# ssivakumaran
# 110261379

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
    jal validate_first_argument
    
    lw  $t0, addr_arg0
    lbu $t1, 0($t0)                     # Extract first character from string
    
    beq $t1, '2', two_command		# If first argument matches none of these cases, set invalid
    beq $t1, 'S', S_command
    beq $t1, 'L', L_command
    beq $t1, 'D', D_command
    beq $t1, 'A', A_command
    
    j invalid_operation           
    
validate_first_argument:		# Check if first argument has string length 1
    lw  $t0, addr_arg0
    lbu $t1, 1($t0)                   	# Load second character into $t1          
    bne $zero, $t1, invalid_operation 	# If second character is not 0, we fail the test
    
    jr $ra
 
two_command:
     	jal check_2_args
     	j exit
     
S_command:
	jal check_2_args
     	j exit

L_command:
	jal check_2_args
     	j exit 
     
D_command:
	jal check_2_args
     	j exit

A_command:
	jal check_5_args
     	j exit 
     
check_2_args:
     	 lw $t0, addr_arg2
    	 bne $zero, $t0, invalid_args	# Check if third argument is empty (equivalent to only having two arguments)
     
    	 jr $ra 
     
check_5_args:
	lw $t0, addr_arg4
     	beq $zero, $t0, invalid_args	# Check if fifth argument is not empty (equivalent to only having five arguments)
     
    	jr $ra 
        
invalid_operation:
    la $a0, invalid_operation_error
    li $v0, 4
    syscall
 
    j exit
    
invalid_args:
    la $a0, invalid_args_error
    li $v0, 4
    syscall
 
    j exit
    
exit:
    li $a0, '\n'
    li $v0, 11
    syscall
    li $v0, 10
    syscall