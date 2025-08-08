# Student Information Section
#Author:Osher
#Exercise number:5

# Complete MIPS program for array processing
# Features:
# - Prints array in different bases (2-10)
# - Handles both signed and unsigned numbers
# - Calculates sums, differences, and pair operations
# - Uses stack and procedure calls

.data
    # Initialize array with 10 signed bytes
    array:          .byte 127, -128, 64, -64, 32, -32, 16, -16, 8, -8
    
    # Program messages
    prompt:         .asciiz "In what base to print 2-10? "
    error_msg:      .asciiz "Invalid input. Please enter a number between 2-10.\n"
    newline:        .asciiz "\n"
    space:          .asciiz " "
    sign_msg:       .asciiz "Signed numbers: "
    unsign_msg:     .asciiz "Unsigned numbers: "
    sign_sum_msg:   .asciiz "Signed sum: "
    unsign_sum_msg: .asciiz "Unsigned sum: "
    sign_diff_msg:  .asciiz "Signed differences between adjacent numbers: "
    unsign_pair_msg: .asciiz "Unsigned sums of adjacent pairs: "

.text
.globl main

# Main program
main:
    # Get valid base input (2-10)
input_loop:
    li $v0, 4
    la $a0, prompt
    syscall
    
    li $v0, 5               # Read integer
    syscall
    
    # Validate input (2 <= input <= 10)
    blt $v0, 2, invalid_input
    bgt $v0, 10, invalid_input
    
    move $a1, $v0           # Store base in $a1 for procedures
    j valid_input
    
invalid_input:
    li $v0, 4
    la $a0, error_msg
    syscall
    j input_loop
    
valid_input:
    # 1. Print signed array
    la $a0, sign_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal sign_array_print
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # 2. Print unsigned array
    la $a0, unsign_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal unsign_array_print
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # 3. Print signed sum
    la $a0, sign_sum_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal sign_sum
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # 4. Print unsigned sum
    la $a0, unsign_sum_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal unsign_sum
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # 5. Print signed differences
    la $a0, sign_diff_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal sign_diff_print
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # 6. Print unsigned pair sums
    la $a0, unsign_pair_msg
    li $v0, 4
    syscall
    
    la $a0, array
    jal unsign_sum_print
    
    # Exit program
    li $v0, 10
    syscall

#######################
# Procedure: sign_array_print
# Purpose: Prints array elements as signed numbers in specified base
# Parameters: 
#   $a0: array address
#   $a1: base for printing
#######################
sign_array_print:
    addi $sp, $sp, -12      # Save registers
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    move $s0, $a0           # Save array address
    li $s1, 0               # Counter
    
print_sign_loop:
    lb $a0, ($s0)          # Load signed byte
    jal base_print         # Print in specified base
    
    la $a0, space          # Print space
    li $v0, 4
    syscall
    
    addi $s0, $s0, 1       # Next array element
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 10, print_sign_loop
    
    lw $ra, 8($sp)         # Restore registers
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

#######################
# Procedure: unsign_array_print
# Purpose: Prints array elements as unsigned numbers in specified base
# Parameters:
#   $a0: array address
#   $a1: base for printing
#######################
unsign_array_print:
    addi $sp, $sp, -12     # Save registers
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    move $s0, $a0          # Save array address
    li $s1, 0              # Counter
    
print_unsign_loop:
    lbu $a0, ($s0)         # Load unsigned byte
    jal base_print         # Print in specified base
    
    la $a0, space          # Print space
    li $v0, 4
    syscall
    
    addi $s0, $s0, 1       # Next array element
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 10, print_unsign_loop
    
    lw $ra, 8($sp)         # Restore registers
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

#######################
# Procedure: sign_sum
# Purpose: Calculates and prints the sum of all array elements as signed numbers
# Parameters:
#   $a0: array address
#   $a1: base for printing
#######################
sign_sum:
    addi $sp, $sp, -16     # Save registers
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0          # Save array address
    li $s1, 0              # Counter
    li $s2, 0              # Sum
    
sign_sum_loop:
    lb $t0, ($s0)          # Load signed byte
    add $s2, $s2, $t0      # Add to sum
    
    addi $s0, $s0, 1       # Next array element
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 10, sign_sum_loop
    
    move $a0, $s2          # Load sum for printing
    jal base_print         # Print sum in specified base
    
    lw $ra, 12($sp)        # Restore registers
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

#######################
# Procedure: unsign_sum
# Purpose: Calculates and prints the sum of all array elements as unsigned numbers
# Parameters:
#   $a0: array address
#   $a1: base for printing
#######################
unsign_sum:
    addi $sp, $sp, -16     # Save registers
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0          # Save array address
    li $s1, 0              # Counter
    li $s2, 0              # Sum
    
unsign_sum_loop:
    lbu $t0, ($s0)         # Load unsigned byte
    add $s2, $s2, $t0      # Add to sum
    
    addi $s0, $s0, 1       # Next array element
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 10, unsign_sum_loop
    
    move $a0, $s2          # Load sum for printing
    jal base_print         # Print sum in specified base
    
    lw $ra, 12($sp)        # Restore registers
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

#######################
# Procedure: sign_diff_print
# Purpose: Prints differences between adjacent array elements as signed numbers
# Parameters:
#   $a0: array address
#   $a1: base for printing
#######################
sign_diff_print:
    addi $sp, $sp, -16     # Save registers
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0          # Save array address
    li $s1, 0              # Counter
    
diff_loop:
    lb $t0, ($s0)          # Load first number (signed)
    lb $t1, 1($s0)         # Load second number (signed)
    sub $a0, $t0, $t1      # Calculate difference
    
    move $s2, $a1          # Save base
    jal base_print         # Print difference
    move $a1, $s2          # Restore base
    
    la $a0, space          # Print space
    li $v0, 4
    syscall
    
    addi $s0, $s0, 1       # Next pair
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 9, diff_loop  # Loop for 9 pairs
    
    lw $ra, 12($sp)        # Restore registers
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

#######################
# Procedure: unsign_sum_print
# Purpose: Prints sums of adjacent array elements as unsigned numbers
# Parameters:
#   $a0: array address
#   $a1: base for printing
#######################
unsign_sum_print:
    addi $sp, $sp, -16     # Save registers
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    
    move $s0, $a0          # Save array address
    li $s1, 0              # Counter
    
sum_pair_loop:
    lbu $t0, ($s0)         # Load first number (unsigned)
    lbu $t1, 1($s0)        # Load second number (unsigned)
    add $a0, $t0, $t1      # Calculate sum
    
    move $s2, $a1          # Save base
    jal base_print         # Print sum
    move $a1, $s2          # Restore base
    
    la $a0, space          # Print space
    li $v0, 4
    syscall
    
    addi $s0, $s0, 1       # Next pair
    addi $s1, $s1, 1       # Increment counter
    blt $s1, 9, sum_pair_loop  # Loop for 9 pairs
    
    lw $ra, 12($sp)        # Restore registers
    lw $s0, 8($sp)
    lw $s1, 4($sp)
    lw $s2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

#######################
# Procedure: base_print
# Purpose: Prints a number in the specified base (2-10)
# Parameters:
#   $a0: number to print
#   $a1: base for printing
#######################
base_print:
    addi $sp, $sp, -20     # Save registers
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    move $s0, $a0          # Number to print
    move $s1, $a1          # Base
    
    # Handle negative numbers
    bgez $s0, convert_to_base
    li $v0, 11
    li $a0, '-'           # Print minus sign
    syscall
    neg $s0, $s0          # Make number positive
    
convert_to_base:
    move $s2, $s0         # Working copy of number
    li $s3, 0            # Digit counter
    
digit_loop:
    div $s2, $s1         # Divide by base
    mfhi $t0             # Get remainder (digit)
    mflo $s2             # Get quotient
    
    # Convert digit to ASCII
    addi $t0, $t0, '0'   # Convert to ASCII
    addi $sp, $sp, -4
    sw $t0, 0($sp)
    addi $s3, $s3, 1     # Increment digit counter
    
    bnez $s2, digit_loop # Continue if quotient not zero

print_digits:
    # Print digits in reverse order
    beqz $s3, base_print_done
    lw $a0, 0($sp)
    li $v0, 11
    syscall
    addi $sp, $sp, 4
    addi $s3, $s3, -1
    j print_digits
    
base_print_done:
    lw $ra, 16($sp)      # Restore registers
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra
