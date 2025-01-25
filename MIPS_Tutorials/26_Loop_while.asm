.data
	message: .asciiz "After while loop is done"
	space: .asciiz "\n"
	
.text
	main:
		# i = 0, make sure that t0 has zero.
		addi $t0, $zero, 0
		
		# two labels for while loop: while and exit.
		while:
			# if greater than 10, call exit.
			# make sure to check branch and function again.
			bgt $t0, 10, exit
			jal printNumber

			
			addi $t0, $t0, 1 # i++
			
			# jump back to while again: it makes a loop.
			j while
		
		exit:
			li $v0, 4
			la $a0, message
			syscall
		
		# end of program:
		li $v0, 10
		syscall
		
	printNumber:
		li $v0, 1
		add $a0, $t0, $zero
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		# jump back to where it was.
		jr $ra
		
		