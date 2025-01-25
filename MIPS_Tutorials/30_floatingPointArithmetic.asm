.data
	number1: .float 3.14
	number2: .float 2.71

.text
	# float (or double) -> use Coproc 1, lwc1
	lwc1 $f2, number1
	lwc1 $f4, number2
	
	# add them with single precision for float	
	# add.s $f12, $f2, $f4
	# mul.s $f12, $f2, $f4
	div.s $f12, $f2, $f4
	
	li $v0, 2
	syscall
	
	# if it is double, use ldc1. Note that they take 64 bits.
	# and use add.d
	

