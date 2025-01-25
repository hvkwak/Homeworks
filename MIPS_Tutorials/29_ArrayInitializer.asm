.data
	myArray: .word 100:10 # 3 elements, initialize with 100 each.
	newLine: .asciiz "\n"

.text
main:
    # what if we want to initialize array? -> initialize it with initializer.
	# while loop
	addi $t0, $zero, 0
	while:
	
		beq $t0, 40, exit # 40 for 40 bytes.
		
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