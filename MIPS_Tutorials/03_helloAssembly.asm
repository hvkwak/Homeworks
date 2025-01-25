.data
myMessage:  .asciiz "Hello World \n"  
	
.text
	# see system calls in https://www.doc.ic.ac.uk/lab/secondyear/spim/node8.html
	li $v0, 4 
	la $a0, myMessage
	syscall