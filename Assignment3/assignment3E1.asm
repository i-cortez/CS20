#
# assignment3E1.asm
#
# Ismael Cortez
# 03/03/2019
# CS21 Assignment 3
#
# This program implements the loop as desctibed in
# Assignment 3 Exercise 1, to sum the integers 1 to 100.
#
	.data				# Data declaration section

	.text
	.globl	main

main:					# Start of code section
	# int i = 1, sum = 0, eos = 101
	# do
	#	sum = sum + i
	#	i++
	# while(i < eos)
	
	ori	$t0, $0, 0x01		# $t0 = i, is the counter
	ori	$t1, $0, 0x0		# $t1 = sum, accumulates the result
	ori	$t2, $0, 0x065		# $t2 = 101, End of Sequence
	
do_while:				# Branch target
	addu	$t1, $t1, $t0		# sum = sum + i
	addiu	$t0, $t0, 0x01		# i++
	blt	$t0, $t2, do_while	# while(i < eos), begin delay
	sll	$0, $0, 0		# End delay
	
	ori	$v0, $0, 0x0a		# Program will now terminate
	syscall

# END OF PROGRAM