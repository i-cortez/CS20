#
# assignment3E3.asm
#
# Ismael Cortez
# 03/06/2019
# CS21 Assignment 3
#
# This program uses a counting loop to compute the 100th term
# of the Fibonacci series as described in Assignment 3 Exercise 3.
#
	.data				# Data declaration section

	.text
	.globl	main

main:					# Start of code section
	ori	$t0, $0, 0x01		# $t0 = previous
	ori	$t1, $0, 0x01		# $t1 = current
	ori	$t2, $0, 0		# $t2 = old current
	ori	$t3, $0, 0x02		# $t3 = Term counter
	ori	$t4, $0, 0x065		# $t4 = EOS
	
doWh:
	addu	$t2, $0, $t1		# Copy current
	addu	$t1, $t0, $t1		# Next = previous + current
	addu	$t0, $0, $t2		# Move old current to previous
	
	addiu	$t3, $t3, 0x01		# Increment term counter
	blt	$t3, $t4, doWh		# Test to reloop
	nop
	
	ori	$v0, $0, 0x0a		# Program will now terminate
	syscall

# END OF PROGRAM