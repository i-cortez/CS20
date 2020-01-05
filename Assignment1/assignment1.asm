#
# assignment1.asm
#
# Ismael Cortez
# Dated: 2/8/2019
# CS21 Assignment 1
#

	.data	# Data declaration section

	.text

main:		# Start of code section
	#
	# Start with the given pattern and use only
	# shift logical instructions and register to
	# register instructions to place the solution
	# 0xAAAAAAAA into $t1.
	#

	ori	$t0, $0, 0x01
	sll	$t1, $t0, 2
	or 	$t2, $t1, $t0
	sll	$t0, $t2, 4
	or	$t1, $t0, $t2
	sll	$t0, $t1,8
	or	$t2, $t0, $t1
	sll	$t1, $t2, 16
	or	$t0, $t1, $t2
	nor	$t1, $t0, $0
	
	
	#
	# Start with the given pattern and use only
	# shift logical instructions and register to
	# register instructions to place the solution
	# 0x69696969 into $t1
	# 

	ori	$t0, $0, 0x01
	sll	$t1, $t0, 3
	or	$t2, $t1, $t0
	nor	$t0, $t2, $0
	sll	$t1, $t0, 4
	nor	$t0, $t1, $t2
	sll	$t1, $t0, 8
	nor	$t2, $t1, $t0
	sll	$t0, $t2, 16
	srl	$t2, $t0, 16
	or	$t1, $t2, $t0
	
	#
	# Start with the given pattern and use only
	# shift logical and register to register
	# instructions to place the solution
	# 0xFFFFFFFF into $t1
	# 
	
	ori	$t0, $0, 0x01
	nor	$t2, $t0, $t0
	or	$t1, $t2, $t0
	
	#
	# Exit the program.
	#
	
	ori	$v0, $0, 0xA
	syscall
	
# END OF PROGRAM
