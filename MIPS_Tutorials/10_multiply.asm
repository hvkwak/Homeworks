.data
	# no data in RAM!
.text
	# three ways to multiply.
	
	# Option1: mul	
	addi $s0, $zero, 10 # save 0 + 10 into s0, note that it takes place directly, just saving to $s0 and $s1.
	addi $s1, $zero, 4
	mul $t0, $s0, $s1 # note that s0, s1 can be only 16 bits long (addi.)
	
	# display the product.
	li $v0, 1
	add $a0, $zero, $t0
	syscall
		
	# Option2: mult
	addi $t0, $zero, 2000 # $t0, $t1 are 16 bits (addi!)
	addi $t1, $zero, 10
	mult $t0, $t1 # if multiplication is big, it goes to hi, lo seperately: 32 bits each. 
	mflo $s0      # This case is but not too high, taking mflo is fine. moving from low to $s0.
	mfhi $s1
	
	# display the product
	li $v0, 1  				# service call to print integer.
	add $a0, $zero, $s0		# zero and s0 to a0, and print a0.
	syscall
	
	# Check this before moving to next one:
	# 1. s and t registers???? what are differences? 
	# -> we will take care of this later.
	
	# 2. what if mfhi??? 
	# -> later. 
	
	# 3. display the product: check this again!
	# -> 
	
