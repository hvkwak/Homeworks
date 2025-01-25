.data
	message: .asciiz "Hi, how are you?"

.text
	main:
		# get two numbers
		addi $s0, $zero, 14
		addi $s1, $zero, 10

		bgt	 $s0, $s1, displayHi # directly goes to displayHi if it is greater.
		# more available: bgtz, blt, ....
	
		# end of main
		li $v0, 10
		syscall
	
	displayHi:
		li $v0, 4
		la $a0, message
		syscall
