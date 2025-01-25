# sll : shift left logical, it allows to shift bits (to the left).
# 		allows multiplication in a very efficient manner.
.data

.text
	addi $s0, $zero, 4
	
	# lets multiply, 4 by 4?
	
	sll $t0, $s0, 2 # shift by 2, which is multiplying by 4. 1 should be multiplying 2.
	
	# print it!
	li $v0, 1
	add $a0, $zero, $t0
	syscall
	
	