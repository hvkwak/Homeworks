.data

.text
	# 
	# Objective: Pass arguments and return values from the functions.
	#
	main:
	
		# use "a" registers to pass arguments.		
		addi $a1, $zero, 50
		addi $a2, $zero, 100
		
		# jump to target procedure, note that the address goes to $ra.
		jal addNumbers
	
		# print out the results
		li $v0, 1
		addi $a0, $v1, 0
		syscall
		
	# Tell the system that the program is done.
	li $v0, 10
	syscall
	
	
	#
	# define functions
	#
	addNumbers:
		add $v1, $a1, $a2 # note that by convention, v1 is for a return value.	
				
		# return back to jump
		jr $ra
	
