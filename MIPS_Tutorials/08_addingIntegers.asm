.data
	number1: .word 5
	number2: .word 10

.text
	lw $s0, number1($zero)
	lw $s1, number2($zero)
	
	add $s2, $s0, $s1 # t2 = t0 + t1
	
	li $v0, 1
	add $a0, $zero, $s2 # prints out whats at $s0
	syscall