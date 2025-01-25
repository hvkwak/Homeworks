.data
	# integer is 4 bytes.
	myArray: .space 12 # 3 integers.
	newLine: .asciiz "\n"

.text
main:
	addi $s0, $zero, 4
	addi $s1, $zero, 10
	addi $s2, $zero, 12
	
	addi $t0, $zero, 0	
	sw $s0, myArray($t0)
	addi $t0, $t0, 4
	sw $s1, myArray($t0)
	addi $t0, $t0, 4
	sw $s2, myArray($t0)
	
	# while loop
	addi $t0, $zero, 0
	while:
	
		beq $t0, 12, exit # 12 for 12 bytes.
		
		lw $t6, myArray($t0)
		
		# print current number.
		li $v0, 1
		move $a0, $t6 # t6 goes to a0
		syscall
		
		# print new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		# update index(offset), notew that integer is 4 bytes.
		addi $t0, $t0, 4
		
		j while # keep while loop work.

	exit:
		# tell system this is end of program.
		li $v0, 10
		syscall
	