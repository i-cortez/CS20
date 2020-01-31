#
# assignment2E1.asm
#
# Ismael Cortez
# 2/19/2019
# CS21 Assignment 2
#
# This program adds up the integers as given
# in Exercise 1, leaving the answer in $t0.
#
# Registers: $t0, $t1, $t2, $t3
#

	.data	# Data declaration section

	.text

main:		# Start of code section
	
	
	li	$t0, 456		# Translates to an ORI instruction.	
	li	$t1, -229		# To LUI then ORI.
	li	$t2, 325		# To ORI.
	li	$t3, -552		# To LUI then ORI. All seen in QTSpim Text tab.
	
	addu	$t0, $t0, $t1		# The result displays as 0x0E3.
	
	addu	$t0, $t0, $t2		# The result displays as 0x0228.
	
	addu	$t0, $t0, $t3		# The final result displays as 0.
	
	
	# The program will now terminate.
	
	li	$v0, 0xa
	syscall
	

# END OF PROGRAM