.data
	message:       .asciiz  "Enter the value of PI: "
	zeroAsFloat:   .float   0.0 # no default zero register.
	
.text 
	# load zeroAsFloat.
	lwc1 $f4, zeroAsFloat # due to L:15
	
	# Display message
	li $v0, 4
	la $a0, message
	syscall
	
	# Read user's input: float.
	li $v0, 6 # read a float, note that it goes to $f0 automatically.
	syscall
	
	# Display value
	li $v0, 2
	add.s $f12, $f0, $f4 # add zero to user input and keep it in $f12.
	syscall