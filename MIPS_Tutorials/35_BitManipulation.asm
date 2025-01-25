.data
	newLine: .asciiz "\n"
	

.text
	main:
		li $a1, 11 # load 11 to a1
		jal showNumber
		
		li $a1, 11 # takes 11 as argument, this will become 10. 1011 -> 1010
		jal clearBitZero
		
		move $a1, $v0 # this will show 10.
		jal showNumber
		
		li $v0, 10
		syscall
	
# expects number in $a1	
showNumber:
	
	# Display text
	li $v0, 4
	la $a0, newLine
	syscall
	
	# Display number.
	li $v0, 1
	move $a0, $a1
	syscall
	
	# jump back
	jr $ra

clearBitZero:

	# mask will be $s0. Since s register is callee saved, keep it in stack.
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	# make mask.	
	li $s0, -1 # first all -1
	sll $s0, $s0, 1 # shift left one bit. $s0, 1

	# apply bitwise AND.
	and $v0, $a1, $s0 # a1 is the argument, s0 is what we made. 
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	
	
	