.data
	number1: .word 20
	number2: .word 8
.text
	# load it to registers
	lw $s0, number1 # s0 darf nicht geändert werden, $s0 = 20
	lw $s1, number2 # s1 = 8
	
	# subtraction takes place
	sub $t0, $s0, $s1 # t0 = 20 - 8
	
	li $v0, 1     # print out an integer
	move $a0, $t0 # move from t0 to a0
	syscall
	
	# why adding integers with t0, t1,
	# subtraction with s0, s1?
	
