.data
	prompt: .asciiz "enter the value of e: "

.text
	# Display message to the user
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Get the double from the user: floats and doubles ared saved in $f0.	
	li $v0, 7
	syscall
	
	# Display the user's input, doubles all have default value of 0.0
	# f0 has the user input
	# f10 has the 0.0, the default value. we are just adding just zero.
	li $v0, 3
	add.d $f12, $f0, $f10
	syscall
	