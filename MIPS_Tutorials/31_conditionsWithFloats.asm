.data
	message: .asciiz "It was true.\n"
	message2: .asciiz "It was false.\n"
	number1: .float 10.4
	number2: .float 10.4
		
.text
	main:
	
		# move numbers to registers.
		lwc1 $f0, number1
		lwc1 $f2, number2
	
		c.eq.s $f0, $f2 #  do the comparison and sets condition flags.
	
		# in case of true, go to exit.
		bc1t exit
	
		# if false, print out the message2.
		li $v0, 4
		la $a0, message2
		syscall
	
	# system call to end the program.
	li $v0, 10
	syscall

	exit:
		li $v0, 4
		la $a0, message
		syscall