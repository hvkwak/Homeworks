.data
	message: .asciiz "The number is less than the other."
	
.text
	main:
	addi $t0, $zero, 1
	addi $t1, $zero, 200
	
	slt $s0, $t0, $t1 # yes ore no goes to $s0
	
	# only bne.	
	bne $s0, $zero, printMessage # if it is not equal, go to printMessage.
	
	# Tell the system this is end of main..
	li $v0, 10
	syscall	
	
	printMessage:
		li $v0, 4
		la $a0, message
		syscall