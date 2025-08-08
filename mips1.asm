# Student Information Section
#Author:Osher
#Exercise number:4

#Description: "This program converts all sentences in a string so that the first letter of each sentence is uppercase and the rest are lowercase."


.data
    # String to be processed
    input_string:       .asciiz "hyunDAi aNd Kia. tHe bEST sMartwatChEs. learning a NEW langUage."
    newline:           .asciiz "\n"
    # Variables for processing
    space:              .byte 0x20   # ASCII value for space
    dot:                .byte 0x2E   # ASCII value for dot
    null:               .byte 0x00   # ASCII value for null

.text
.globl main

main:
    # Print original string
    li $v0, 4           # syscall for printing string
    la $a0, input_string
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Process the string to capitalize the first letter of each sentence
    la $t0, input_string   # Load address of input string into $t0
    li $t2, 1              # Flag to track if it's the start of a sentence (1 means start)
    
process_loop:
    lb $t1, ($t0)         # Load byte from input string into $t1
    beqz $t1, end_program # If byte is null (end of string), end program

    # If it's not the start of a sentence, convert to lowercase
    beq $t2, 1, check_capitalize
    
    # Check if current character is uppercase
    li $t5, 0x41            # ASCII 'A'
    li $t6, 0x5A            # ASCII 'Z'
    blt $t1, $t5, check_dot # If less than 'A', skip
    bgt $t1, $t6, check_dot # If greater than 'Z', skip
    
    # Convert to lowercase
    addi $t1, $t1, 0x20     # Convert to lowercase
    sb $t1, ($t0)           # Store back in memory

check_dot:
    # Check for dot to mark the end of a sentence
    li $t3, 0x2E            # ASCII for dot
    bne $t1, $t3, continue_processing
    li $t2, 1               # Set flag for next character
    j continue_processing

check_capitalize:
    # Check if the character is a letter
    li $t3, 0x61            # ASCII 'a'
    li $t4, 0x7A            # ASCII 'z'
    li $t5, 0x41            # ASCII 'A'
    li $t6, 0x5A            # ASCII 'Z'
    
    # First check if it's already uppercase
    blt $t1, $t5, not_letter
    ble $t1, $t6, is_uppercase
    
    # Then check if it's lowercase
    blt $t1, $t3, not_letter
    bgt $t1, $t4, not_letter
    
    # Convert lowercase to uppercase
    subi $t1, $t1, 0x20     # Convert to uppercase
    sb $t1, ($t0)           # Store back in memory
    
is_uppercase:
    li $t2, 0               # Clear the start-of-sentence flag
    j continue_processing
    
not_letter:
    # If it's not a letter, keep checking for start of sentence
    j continue_processing

continue_processing:
    addi $t0, $t0, 1        # Move to next character
    j process_loop

end_program:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Print the processed string
    li $v0, 4               # syscall for printing string
    la $a0, input_string
    syscall
    
    # Exit the program
    li $v0, 10              # syscall for exiting the program
    syscall
