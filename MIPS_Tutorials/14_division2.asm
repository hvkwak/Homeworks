.data

.text
	addi $t0, $zero, 30   # t0 is now 30
	addi $t1, $zero, 8
	
	# Option 1, take 3 registers. divide t0 into 10 and save the quotient to s0
	# div $s0, $t0, 10  
	
	# Option 2	
	div $t0, $t1 		# quotient -> lo, remainder -> hi
	mflo $s0 			# Quotient, move from low.
	mfhi $s1 			# Remainder, move from high.
	
	
	
	# print it, but Quotient.
	li $v0, 1 # print out integer
	add $a0, $zero, $s1
	syscall
