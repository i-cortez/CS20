#
# assignment4E1.asm
#
# Ismael Cortez
# 03/15/2019
# CS21 Assignment 4
#
# This program converts a string to all lowercase characters
# assuming a given string of all uppercase characters.
#
# Register use:
# $t0 = base address pointer
# $t1 = value at $t0
#
	.data
myStr:	.asciiz	"ABCDEFG"
nL:	.asciiz	"\n"

	.text
	.globl	main

main:
	ori	$v0, $zero, 0x04	# Output the original string
	la	$a0, myStr
	syscall
	la	$a0, nL
	syscall
	
	la	$t0,myStr		# Point to the first char
while:					# Jump target
	lbu	$t1, 0($t0)		# Load the current char
	nop				# Load delay slot
	beq	$t1, $zero, endWh	# while($t1 != NULL)
	nop				# Branch delay slot
	addiu	$t1, $t1, 0x20		# Convert char to lowercase
	sb	$t1, 0($t0)		# Store new char
	addiu	$t0, $t0, 0x01		# Increment pointer, store delay slot
	j	while			# Reloop
	nop				# Jump delay slot
	
endWh:	ori	$v0, $zero, 0x04	# Output new string
	la	$a0, myStr
	syscall
	
	ori	$v0, $zero, 0x0a	# Program will now terminate
	syscall

# END OF PROGRAM