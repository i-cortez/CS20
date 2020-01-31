#
# assignment2E3.asm
#
# Ismael Cortez
# 2/21/2019
# CS21 Assignment 2
#
# This program illustrates the differences
# between the ADDU and ADD instructions using
# the given value in Exercise 2.
#

	.data	# Data declaration section

	.text

main:		# Start of code section
	# 
	# Start with the given pattern, shift by 16-bits
	# to obtain 0x70000000 then add to itself using ADDU
	#
	# Registers: $t1, $t2
	#
	
	ori	$t1, $0, 0x7000		# Initialize
	ori	$t2, $0, 0x7000
	
	sll	$t1, $t1, 16		# $t1 contains 0x70000000
	
	addu	$t1, $t1, $t1		# $t1 contains 0xE0000000, is correct for unsigned
	
	# 
	# Start with the given pattern, shift by 16-bits
	# to obtain 0x70000000 then add to itself using ADD
	#
	# Registers: $t2
	#
	
	sll	$t2, $t2, 16		# $t2 contains 0x70000000
	
	add	$t2, $t2, $t2		# $t2 contains ?
	
	
	# The program will now terminate
	
	ori	$v0, $0, 0x0a
	syscall

# END OF PROGRAM