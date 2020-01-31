#
# assignment2E2.asm
#
# Ismael Cortez
# 2/12/2019
# CS21 Assignment 2 Exercise 2
#
# This program performs addition and shifting
# as indicated by the Exercise 2 instructions
#

	.data	# Data declaration section

	.text

main:		# Start of code section
	
	#
	# This part of the program initializes
	# $t0 to 0, then adds 0x1000 to $t0
	# sixteen times.
	#
	# Registers: $t0
	#
	
	ori	$t0, $0, 0
	
	addiu	$t0, $t0, 0x1000	# 0x10000 will display in $t0.
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	addiu	$t0, $t0, 0x1000
	
	#
	#
	# This part of the program initializes
	# $t1 to 0x1000, then uses SLL to produce
	# the same pattern as contained in $t0.
	#
	# Registers: $t1
	#
	
	ori	$t1, $0, 0x1000
	
	sll	$t1, $t1, 4		# 0x10000 will display in $t1.
	
	#
	#
	# This part of the program initializes
	# $t2 to 0x1000, then adds $t2 to itself
	# the appropriate number of times so that
	# its pattern matches that of $t0 and $t1.
	#
	# Registers: $t2
	#
	
	ori	$t2, $0, 0x1000
	
	addu	$t2, $t2, $t2		# After 4 additions with itself
	addu	$t2, $t2, $t2		# $t2 will display 0x10000.
	addu	$t2, $t2, $t2
	addu	$t2, $t2, $t2
	
	
	# Program will now terminate.
	
	ori $v0, $0, 0xa
	syscall

# END OF PROGRAM