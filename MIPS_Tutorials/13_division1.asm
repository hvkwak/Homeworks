.data

.text
	addi $t0, $zero, 30   # t0 is now 30
	addi $t1, $zero, 5
	
	div $s0, $t0, $t1 # divide t0 into t1 and save the quotient to s0
	
	# print it
	li $v0, 1 # print out integer
	add $a0, $zero, $s0
	syscall
