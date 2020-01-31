#
# assignment2E6.asm
#
# Ismael Cortez
# 2/24/2019
# CS21 Assignment 2
#
# This program evaluates the polynomial
# 18xy + 12x - 6y + 12 by simplifying.
#
# Simplified: x(18y + 12)- 6y + 12
#

	.data			# Symbolic addressing begins at 0x10010000
x:	.word	0		# x at		0x10010000
y:	.word	1		# y at		0x10010004
answer:	.word	0		# answer at 	0x10010008

	.text

main:		# Start of code section
	#
	# Evaluate the given polynomial and store
	# in "answer"
	#
	# Registers: $t0, $t1, $t2, $t3, $t4
	#
	
	lui	$t0, 0x1001	# $t0 wil serve as the base register pointer,
	lw	$t1, 0($t0)	# $t1 = x, begin load delay
	lw	$t2, 4($t0)	# $t2 = y, end delay, begin load delay
	
	ori	$t3, $0, 18	# Load coefficient of 18, end delay
	
	multu	$t2, $t3	# $t3 = 18y,
	mflo	$t3		# begin delay slot
	
	addiu	$t3, $t3, 12	# $t3 = 18y + 12,
	or	$0, $0, $0	# end delay slot
	
	multu	$t1, $t3	# $t3 = x(18y + 12),
	mflo	$t3		# begin delay slot
	
	addiu	$t4, $0, -6	# $t4 = (-6)
	or	$0, $0, $0	# end delay slot
	
	multu	$t2, $t4	# $t4 = -6y,
	mflo	$t4		# begin delay slot
	
	addu	$t3, $t3, $t4	# $t3 = x(18y + 12)- 6y
	
	addiu	$t3, $t3, 12	# $t3 = x(18y + 12)- 6y + 12, end delay
	
	sw	$t3, 8($t0)	# Final result is in "answer", begin store delay
	
	
	# The program will now terminate.
	
	ori	$v0, $0, 0x0a	# End store delay
	syscall
	

# END OF PROGRAM