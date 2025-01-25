.data
	# array of integer in RAM
	mdArray: .word 2, 5, 4
			 .word 3, 7, 4
			 .word 11, 2, 3
	size: 	 .word 3 # for both row and column. If they differ, we need two values.
	
	.eqv DATA_SIZE 4 # data size is 4, because we are dealing with integers. double would be 8.
	
.text
	main:
		la $a0, mdArray		# $a0 has the base address of mdArray.
		lw $a1, size		# $a1 has the size, two columns!
		jal sumDiagonal 	# sum of diagonal elements
		
		move $a0, $v0		# sumDiagonal returns $v0, and move to $a0.
							# but why $a0? We want to display this.
		li $v0, 1
		syscall				# 2 + 7 = 9
		
		# end program
		li $v0, 10
		syscall
	
	# we use row major representation:
	# addr = baseAddr + (rowIndex*colSize+ colIndex)*dataSize
	sumDiagonal:
		li $v0, 0 	# sum = 0
		li $t0, 0	# $t0 is the index, starts with 0.
		
		sumLoop:
			mul $t1, $t0, $a1 				# t1 = t0(rowIndex) * a1(colSize)
			add $t1, $t1, $t0  				# 					  + colIndex (t0)
			mul $t1, $t1, DATA_SIZE 		# multiply datasize.
			add $t1, $t1, $a0				# add base address.
			
			# Note that $t1 has the address. a0 is the matrix. 
			lw $t2, ($t1)                   # put the element into $t2.
			add $v0, $v0, $t2		 		# sum = sum + array[i][i]
			
			addi $t0, $t0, 1				# i++
			blt  $t0, $a1, sumLoop 			# go back to loop if t0 less than size(=a1).
			
			
	jr $ra
	