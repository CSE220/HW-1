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

#-------------------------------------------------
# TWO COMMAND
#--------------------------------------------------
two_command:
     	jal check_2_args
     	# Loop through and create binary representation 
     	lw $t1, addr_arg1
     	li $t2, 0	# iterator from 0 to 7
 	jal validate_hexadecimal_string
     	lw $t0, addr_arg1
     	addi $t1, $t0, 7 # Goes from 7 to 0 (read string end to front)
     	li $t2, 1	 # Place value, initialize at 1
     	li $t4, 0	 # Initialize sum to 0
     	j two_binary_loop	
     	
two_binary_loop:
	lb $a0, 0($t1)  # Character to read
	jal hex_char_to_dec
	mul $t3, $v1, $t2
	add $t4, $t4, $t3
	
	beq $t0, $t1, convert_two_complement
	addi $t1, $t1, -1
	sll $t2, $t2, 4
	j two_binary_loop

convert_two_complement:
	move $t0, $t4
	li $t1, 0x10000000
	and $t2, $t1, $t0
	beq $t2, $t1, two_complement_is_negative
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	j exit
	
two_complement_is_negative:
	li $t1, 0x00000001       # Number to mask with
	li $t2, 0		 # Iterator
	addi $t0, $t0, -1       # Reverse adding 1 to Twos Complement
	j two_complement_loop

two_complement_loop:
	xor $t0, $t0, $t1
	
	addi $t2, $t2, 1
	sll $t1, $t1, 1
	bne $t2, 32, two_complement_loop
	
	move $a0, $t0
	neg $a0, $a0
	li $v0, 1
	syscall
	
	j exit
#-------------------------------------------------

#-------------------------------------------------
# S COMMAND
#-------------------------------------------------- 
S_command:
	jal check_2_args
	# Loop through and create binary representation 
     	lw $t1, addr_arg1
     	li $t2, 0	# iterator from 0 to 7
 	jal validate_hexadecimal_string
 	lw $t0, addr_arg1
     	addi $t1, $t0, 7 # Goes from 7 to 0 (read string end to front)
     	li $t2, 1	 # Place value, initialize at 1
     	li $t4, 0	 # Initialize sum to 0
     	j signed_binary_loop
     	j exit

signed_binary_loop:
	lb $a0, 0($t1)  # Character to read
	jal hex_char_to_dec
	mul $t3, $v1, $t2
	add $t4, $t4, $t3
	
	beq $t0, $t1, convert_signed_number
	addi $t1, $t1, -1
	sll $t2, $t2, 4
	j signed_binary_loop

convert_signed_number:
	move $t0, $t4
	li $t1, 0x80000000
	and $t2, $t1, $t0
	beq $t2, $t1, signed_is_negative
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	j exit

signed_is_negative:
	andi $t0, $t0, 0x7FFFFFFF
	
	#Print negative sign
	li $a0, '-'
	li $v0, 11
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	j exit
#-------------------------------------------------

#-------------------------------------------------
# D COMMAND
#-------------------------------------------------- 

D_command:
	jal check_2_args
	
	# Validate location representation
     	lw $t1, addr_arg1
     	li $t2, 0	# iterator from 0 to 7
 	jal validate_location_string
 	lw $t0, addr_arg1 # Increases from 0 to 7
 	li $t1, 0
 	li $t4, 0 	# Initialize looping sum to 0
 	j calculate_location_loop

validate_location_string:
	bge  $t2, 8, location_go_back
	
	lbu $t3, 0($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	
	beq $t3, 48, validate_location_string
	bgt $t3, 122, invalid_args     
	blt $t3, 97, invalid_args
	
	j validate_location_string

location_go_back:
	jr $ra

calculate_location_loop:
	lbu $a0, 0($t0)
	jal location_char_to_value
	add $t4, $t4, $v1
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	bne $t1, 8, calculate_location_loop
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	j exit
	
location_char_to_value:
	beq $a0, 48, result_zero
	
	addi $t7, $a0, -97
	li $t6, 0x00000001
	move $t5, $zero
	j location_char_loop

location_char_loop:
	beq $t5, $t7, set_result
	sll $t6, $t6, 1
	addi $t5, $t5, 1
	j location_char_loop

set_result:
	move $v1, $t6
	
	jr $ra
	
result_zero:
	move $v1, $zero
	
	jr $ra
#-------------------------------------------------
     
#-------------------------------------------------
# L COMMAND
#-------------------------------------------------- 
L_command:
	jal check_2_args
     	lw $t1, addr_arg1
     	li $t2, 0	# iterator from 0 to 7
 	jal validate_dec_string
 	
 	lw $t0, addr_arg1 # Go backwards from 7 to 0
 	addi $t0, $t0, 7
 	li $t1, 0
 	li $t4, 0 	# Initialize looping sum to 0
 	li $t2, 1
 	li $t3, 10
 	j calculate_dec_loop

validate_dec_string:
	lbu $t3, 0($t1)
	bgt $t3, 57, invalid_args     
	blt $t3, 48, invalid_args
	
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	bne $t2, 8, validate_dec_string
	
	jr $ra

dec_char_to_value:	
	addi $v1, $a0, -48
	jr $ra

print_char:
	li $v0, 11
	syscall
	
	jr $ra

calculate_dec_loop:
	lbu $a0, 0($t0)
	jal dec_char_to_value
	mul $t6, $t2, $v1
	add $t4, $t4, $t6
	
	addi $t0, $t0, -1
	addi $t1, $t1, 1
	mul $t2, $t2, $t3
	bne $t1, 8, calculate_dec_loop
	
	move $t0, $t4
	li $t1, 1
	li $t5, 96 	# Letter to print
	j print_location_numeral

print_location_numeral:
	addi $t5, $t5, 1
	and $t2, $t0, $t1
	srl $t0, $t0, 1
	beq $t1, $t2, print_location_char

	bge $t5, 122, exit
	
	j print_location_numeral

print_location_char:
	move $a0, $t5
	jal print_char
	
	bge $t5, 122, exit
	
	j print_location_numeral
#-------------------------------------------------- 
     
#-------------------------------------------------
# L COMMAND
#-------------------------------------------------- 
A_command:
	jal check_5_args
	lw $t1, addr_arg1
     	li $t2, 0	# iterator from 0 to 7
     	li $v1, 0
     	jal count_uppercase
     	
     	j exit 
     	
count_uppercase:
	beq $t2, 8, exit
	lbu $t3, 0($t1)
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	move $a0, $t3
	li $v0, 11,
	syscall
	bge $t3, 65, count_uppercase_second    
	
	bne $t2, 8, count_uppercase
	
	jr $ra

count_uppercase_second:
	bgt $t3, 90, count_uppercase
	
	addi $v1, $v1, 1
	
	bne $t2, 8, count_uppercase
	
	jr $ra
		
count_lowercase:

count_digits:
     	
#-------------------------------------------------
     
check_2_args:
     	 lw $t0, addr_arg2
    	 bne $zero, $t0, invalid_args	# Check if third argument is empty (equivalent to only having two arguments)
     
    	 jr $ra 
     
check_5_args:
	lw $t0, addr_arg4
     	beq $zero, $t0, invalid_args	# Check if fifth argument is not empty (equivalent to only having five arguments)
     
    	jr $ra
#-----------------------------------------------------------------------     	
# UTILS
#-----------------------------------------------------------------------  

#-----------------------------------------------------------------------  	
# Validates a string to make sure it has only hexadecimal characters
validate_hexadecimal_string:
	lbu $t3, 0($t1)
	bgt $t3, 70, invalid_args     
	beq $t3, ':',  invalid_args
	beq $t3, ';',  invalid_args
	beq $t3, '<',  invalid_args
	beq $t3, '=',  invalid_args
	beq $t3, '>',  invalid_args
	beq $t3, '?',  invalid_args
	beq $t3, '@',  invalid_args
	blt $t3, 48, invalid_args
	
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	bne $t2, 8, validate_hexadecimal_string
	
	jr $ra

#-----------------------------------------------------------------------  	
# Takes a hexadecimal character and converts it to a decimal number
hex_char_to_dec:
	bge $a0, 65, convert_letter     # If $a0 has ascii value greater than 'A'
	bge $a0, 48, convert_number	# If $a0 has ascii value greater than '0'
	
convert_number:
	addi $v1, $a0, -48		# Map ASCII dec values to hex value
	jr $ra
	
convert_letter:
	addi $v1, $a0, -55		# Map ASCII dec values to hex value
	jr $ra

#----------------------------------------------------------------------
        
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
