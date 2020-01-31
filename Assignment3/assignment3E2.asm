#
# assignment3E2.asm
#
# Ismael Cortez
# 03/03/2019
# CS21 Assignment 3
#
# This program implements the loop as described in
# Assignment 3 Exercise 2, to sum the even, odd, and
# all values 1 to 100.
#
	.data				# Data declaration section

	.text
	.globl	main

main:					# Start of code section
	# int i = 1, evenSum = 0, oddSum = 0, sum = 0, eos = 0, lsb = 0
	# do
	# if(i == even)
	#	evens += i
	# else
	#	odds += i
	# sum += i
	# i++
	# while(i < eos)
	
	ori	$t0, $0, 0		# evenSum = 0
	ori	$t1, $0, 0		# oddSum = 0
	ori	$t2, $0, 0		# sum = 0
	ori	$t3, $0, 0x01		# i = 1
	ori	$t4, $0, 0x065		# End Of Sequence
	ori	$t5, $0, 0		# LSB holder
	
doWh:					# Branch target
	andi	$t5, $t3, 0x01		# Extract the LSB of $t3
	beqz	$t5, even		# if($t5 == 0), begin delay
	nop				# End delay
	
	addu	$t1, $t1, $t3		# else, $t1 = $t1 + $t3
	j	endEv			# jump if(even)
	nop
even:	addu	$t0, $t0, $t3		# if(even), $t0 = $t0 + $t3
endEv:	addu	$t2, $t2, $t3		# sum += i

	addiu	$t3, $t3, 0x01		# i++
	blt	$t3, $t4, doWh		# while(i < eos), begin delay
	nop				# End delay
	
	ori	$v0, $0, 0x0a		# The program will now terminate
	syscall

# END OF PROGRAM