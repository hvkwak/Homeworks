.data 
	message: .asciiz "The numbers are equal."
	message2: .asciiz "Nothing happend"
	
.text
	main:
		addi $t0, $zero, 20
		addi $t1, $zero, 20
			
		# check if they are equal		
		# note that label is the name.
		beq $t0, $t1, numbersEqual # displays label if it is equal.
		numbersEqual_ret:
		bne $t0, $t1, numbersDifferent
		numbersDifferent_ret:
		
		# syscall to end program
		li $v0, 10
		syscall

	# this kind of serial branches is not good idea.
	numbersEqual:
		li $v0, 4 # display text
		la $a0, message
		syscall
		j numbersEqual_ret
		
	numbersDifferent:
		li $v0, 4 # display text
		la $a0, message2
		syscall
		j numbersDifferent_ret
