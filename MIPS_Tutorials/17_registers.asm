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
		
		jal increaseMyRegister # it prints the value 40
		
		# print a new line
		li $v0, 4
		la $a0, newline
		syscall
		
		# print value: prints value 10
		li $v0, 1
		move $a0, $s0
		syscall
	
	# this line is going to signal end of program.
	li $v0, 10
	syscall
	
	increaseMyRegister:
		# callee use the s registers (calle save) -> save in stack
		# Note: if this were t register, no stack may be needed. It is allowed to modify the value in t register.
		
		add $sp, $sp, -4 # sp = sp - 4, taking 4 bytes.
		sw $s0, 0($sp) #  allocating s0 to first position in the stack pointer.
		
		add $s0, $s0, 30 # $s0 = 30 + 10
		
		# print new value in function
		li $v0, 1
		move $a0, $s0
		syscall
		
		# load word from stack,
		# stack pointer goes back.
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		
		jr $ra # jump back
		
		
	

