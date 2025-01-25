.data
	prompt: .asciiz "Enter your age: "
	message: .asciiz "\nYour age is "
	
.text 
	# Prompt the user to enter age.
	li $v0, 4
	la $a0, prompt
	syscall
	
	# get user input
	li $v0, 5 # system call for user input of integer, it will be saved in v0.
	syscall
	
	# store the result in $t0, so that I can modify it later
	move $t0, $v0
	
	# display the message
	li $v0, 4
	la $a0, message		
	syscall

	# print or show the age
	li $v0, 1
	move $a0, $t0
	syscall
	
	
	
	