.data
	# integer is 4 bytes.
	myArray: .space 12 # 3 integers.

.text
	# make integers. 
	addi $s0, $zero, 4
	addi $s1, $zero, 10
	addi $s2, $zero, 12
	
	# keep them in array.
	# clean the $t0, index = $t0
	addi $t0, $zero, 0
	
	sw $s0, myArray($t0) # keep the first element.
	addi $t0, $t0, 4 #  add 4. 
	
	sw $s1, myArray($t0)
	addi $t0, $t0, 4 #  add 4. 
	
	sw $s2, myArray($t0)
	
	# retrieve values from memory (RAM)
	lw $t6, myArray($zero)

	
	li $v0, 1
	addi $a0, $t6, 0
	syscall	
	
	