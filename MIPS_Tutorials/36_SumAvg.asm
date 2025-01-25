.data
	# all values in RAM
	array: .word 10, 2, 9 # three values to keep it simple
	length: .word 3 # length of array. 
	sum:     .word 0
	average: .word 0

.text
	main:

		la $t0, array 		# Base address of array in $t0.
		li $t1, 0 			# i = 0
		lw $t2, length		# t2 = length
		li $t3, 0 			# sum = 0
		
		# write a loop to get the sum
		sumLoop:
			lw $t4, ($t0) 		# $t4 = array[i]
			add $t3, $t3, $t4 	# $t3 = $t3 + $t4
			add $t1, $t1, 1		# $t1++
			add $t0, $t0, 4		# Updating the array address.
			blt $t1, $t2, sumLoop # if i < length, loop again.
	
		
		sw $t3, sum # save $t3 in sum.

		# display sum
		move $a0, $t3
		jal displayFunction
		
		# Calculate average
		div $t5, $t3, $t2 # t2 is length, t3 is the sum.
		sw $t5, average
		
		# display $a0
		move $a0, $t5
		jal displayFunction
				
		# Terminate the program.
		li $v0, 10
		syscall
						
		# Note:
		# sw, lw are operations that involves memory (RAM). Minimize it, use registers as much as possible.
			
		displayFunction:
			li $v0, 1
			syscall
			jr $ra
			
			
			
		