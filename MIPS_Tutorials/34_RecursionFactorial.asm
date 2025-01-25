.data
	doneMessage: .asciiz "Factorial Done aufgerufen."
	promptMessage: .asciiz "Enter a number to find its factorial: "
	resultMessage: .asciiz "\nThe factorial of the number is "
	theNumber: 	   .word 0 # stores the number.
	theAnswer: 	   .word 0 # stores answer

.text
	.globl main # global: can be reference for all files
	main:
		# read the number from the user
		li $v0, 4
		la $a0, promptMessage
		syscall
		
		li $v0, 5 # the user input goes to $v0
		syscall

		sw $v0, theNumber # $v0 is saved in the theNumber.
		
		# call the factorial function.
		lw $a0, theNumber # a0 is the argument.
		jal findFactorial # call function findFactorial
		
		sw $v0, theAnswer # the value from findFactorial will be in $v0 by convention.
						  # we keep this in theAnswer.						  
		
		# Display the results
		li $v0, 4
		la $a0, resultMessage
		syscall
		
		li $v0, 1
		lw $a0, theAnswer
		syscall
	
		# Tell the OS that this is the end of the program
		li $v0, 10
		syscall
		
# ----------------------------------------------------------------------
# findFactorial function
.globl findFactorial
findFactorial:
		# putting values to stack (RAM)
		# get the memory ready.
		subu $sp, $sp, 8 # enough space in stack mittels stack pointer
		sw   $ra, 0($sp) # keep return address in the stack
		sw   $s0, 4($sp) # keep the local variable in the stack
		
		# Base Case
		li $v0, 1                 
		beq $a0, 0, factorialDone # if argument is 0, return 1 (note that $v0 is 1).
		
		# findFactorial(theNumber-1)
		move $s0, $a0   # a0 goes to s0.
		sub $a0, $a0, 1
		jal findFactorial
		
		# the magic phappens here.
		mul $v0, $s0, $v0 # $s0 is from argument $a0, $v0 is from the base case. 
		
		factorialDone:
					# get the values back from the stack (an area of RAM)
					lw $ra, ($sp)
					lw $s0, 4($sp)
					addu $sp, $sp, 8 # stack pointer should go upward.
					
					jr $ra
					
					
		# note: watch the final walk throug starting at 17:50.
		# what was that factorialDone in beq $a0, 0, factorialDone?
		
