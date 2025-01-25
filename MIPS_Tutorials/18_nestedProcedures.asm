.data
	newline: .asciiz "\n"
	
.text

	# https://stackoverflow.com/questions/20111326/mips-assembly-language-temporary-register-vs-saved-registers
 	# t registers are caller save, s registers are callee save. 
	# caller, callee are convention	
	# -> For instance, if function A uses registers $t0 and $s0 and then calls a function B, 
	# it must save the register $t0 if it wants to use it after function B returns. 
	# Function B must save $s0 before it can begin using it.

	# we do this
	# 1. save a value in t register
	# 2. write a function that modifies the value in the t register
	
	main: 
		addi $s0, $zero, 10
		
		jal increaseMyRegister
		
		# print a new line
		li $v0, 4
		la $a0, newline
		syscall
		
		jal printValue
		
		# print value: prints value 10

	
	# this line is going to signal end of program.
	li $v0, 10
	syscall
	
	increaseMyRegister:
		# callee use the s registers (calle save) -> save in stack
		# Note: if this were t register, no stack may be needed. It is allowed to modify the value in t register.
		add $sp, $sp, -8 # sp = sp - 8, taking 4 bytes each for s0, ra.
		sw $s0, 0($sp) #  allocating s0 to first position in the stack pointer.
		sw $ra, 4($sp)
		
		add $s0, $s0, 30 # $s0 = 30 + 10
		
		# nested procedure: we need to know where the address of this gonna be.
		jal printValue # -> changes ra. ra has to be restored.
		
		# load word and stack pointer from stack back.
		lw $s0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		
		jr $ra # jump back to main.
	
	printValue:
		# print new value
		li $v0, 1
		move $a0, $s0
		syscall
		
		jr $ra
	

