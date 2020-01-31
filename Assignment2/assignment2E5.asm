#
# assignment2E5.asm
#
# Ismael Cortez
# 2/24/2019
# CS21 Assignment 2
#
# This program evaluates the polynomial
# 2x^3 - 3x^2 + 5x + 12, by using
# Horner's method.
#
# Horner's: x(x(2x - 3)+ 5)+ 12
#

	.data			# Symbolic addressing begins at 0x10010000
x:	.word	1		# x at 0x10010000
answer:	.word	0		# answer at 0x10010004

	.text

main:		# Start of code section
	#
	# Evaluate the given polynomial using Horner's
	# method and store the result in "answer".
	#
	# Registers: $t0, $t1, $t2
	#
	
	lui	$t0, 0x1001	# $t0 wil serve as the base register pointer,
	lw	$t1, 0($t0)	# $t1 = x, begin load delay
	
	ori	$t2, $0, 2	# Load in the coefficient 2, end delay
	
	multu	$t1, $t2	# $t2 = 2x,
	mflo	$t2		# begin delay
	
	addiu	$t2, $t2, -3	# $t2 = 2x - 3,
	or	$0, $0, $0	# end delay
	
	multu	$t1, $t2	# $t2 = x(2x - 3),
	mflo	$t2		# begin delay slot
	
	addiu	$t2, $t2, 5	# $t2 = x(2x - 3)+ 5, 
	or	$0, $0, $0	# end delay slot
	
	multu	$t1, $t2	# $t2 = x(x(2x - 3)+ 5),
	mflo	$t2		# begin delay slot
	
	addiu	$t2, $t2, 12	# $t2 = x(x(2x - 3)+ 5)+ 12
	
	sw	$t2, 4($t0)	# Final result is in "answer", end delay slot
	
	
	# The program will now terminate.
	
	ori	$v0, $0, 0x0a	# End store delay slot
	syscall
	

# END OF PROGRAM