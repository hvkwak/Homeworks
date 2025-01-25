.data
	age: .word 23 
.text
	li $v0, 1 # code is 1 for printing integer
	lw $a0, age
	syscall


	print