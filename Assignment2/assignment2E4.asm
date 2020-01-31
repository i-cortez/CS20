#
# assignment2E4.asm
#
# Ismael Cortez
# 2/22/2019
# CS21 Assignment 2
#
# This program evaluates the expression (x*y)/z
# with the values given as in Exercise 4.
#

	.data	# Data declaration section

	.text

main:		# Start of code section
	#
	# Load the given values into temp registers
	# and evaluate the expression.
	#
	# Registers: $t0, $t1, $t2
	#
	
	ori	$t0, $0, 0x0018		# Initialize with the upper 16 bits
	ori	$t1, $0, 0x0001		# of the given values
	ori	$t2, $0, 0x0006
	
	sll	$t0, $t0, 16		# Shift to prepare for loading the lower
	sll	$t1, $t1, 16		# 16 bits into the temp registers
	sll	$t2, $t2, 16
	
	ori	$t0, $t0, 0x6a00	# $t0 will contain x = 0x00186A00
	ori	$t1, $t1, 0x3880	# $t1 will contain y = 0x00013880
	ori	$t2, $t2, 0x1a80	# $t2 will contain z = 0x00061A80
	
	divu	$t0, $t2		# Divide first to maintain the significant
	mflo	$t0			# bits in LO once proceeding to multiply
	or	$0, $0, $0		# The DIVU result $t0 = 0x00000004
	or	$0, $0, $0
	
	multu	$t0, $t1		# The result $t2 = 0x0004E200
	mflo	$t2
	
	
	# The program will now terminate
	
	ori $v0, $0, 0x0a
	syscall

# END OF PROGRAM