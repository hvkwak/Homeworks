.data
	message:      .asciiz "Hello, "
	userInput:    .space  20 # declaring an array, allow 20 characters of user input.
	
.text
	main:
		# Getting user's input as text
		li $v0, 8 					# get the user input string.
		la $a0, userInput			# specify the variable that holds text.
		li $a1, 20 					# tell the system that the maximum length of text 20.
		syscall						# one character is one byte: 20 letters.
		
		# Displays hello
		li $v0, 4
		la $a0, message
		syscall
		
		# display the name
		li $v0, 4
		la $a0, userInput
		syscall
	
	# Good practice: tell the system the end of main.
	li $v0, 10
	syscall