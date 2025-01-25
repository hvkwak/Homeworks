.data
	message: .asciiz "Hello world!\n"

.text
	main:
		# jump to target procedure, note that the address goes to $ra.
		jal addNumbers
		
		addi $s0, $zero, 5
		
		# Print number 5 to the screen.
		li $v0, 1
		add $a0, $zero, $s0
	
	# Tell the system that the program is done.
	li $v0, 10
	syscall
	
	addNumbers:
		li $v0, 4
		la $a0, message
		syscall
		
		# return back to jump
		jr $ra
	
