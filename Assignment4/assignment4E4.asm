#
# assignment4E4.asm
#
# Ismael Cortez
# 03/18/2019
# CS21 Assignment 4 Exercise 4
#
# This program prompts a user to input a string and then exchanges the case of
# each character. This program assumes string data consists of uppercase,
# lowercase, and space string data.
#
	.data
str:	.space 64
prompt:	.asciiz	"Input string: "

	.text
	.globl	main

main:
	li	$v0, 4			# Output input prompt
	la	$a0, prompt
	syscall
	li	$v0, 8			# Read the input
	la	$a0, str
	li	$a1, 64
	syscall
	
	la	$s0, str		# $s0 = str[0]
	li	$t0, 0			# $t0 = value at $s0
	li	$t9, 32			# $t9 = space char
	li	$t8, 90			# $t8 = 'Z'
	li	$t7, 65			# $t7 = 'A'
	li	$t6, 10			# $t6 = '\n'
	
while:	lbu	$t0, 0($s0)		# Load value at $s0
	nop				# Load delay slot
	beq	$t0, $t6, endWh		# while($t0 != '\n')
	nop				# Branch delay slot
	
if1:	bne	$t0, $t9, doIf1		# if($t0 != space)
	nop				# Branch delay slot
	j	end1			# Else do nothing
	nop				# Jump delay slot
doIf1:
if2:	blt	$t0, $t7, doIf2		# if($t0 < A)
	nop				# Branch delay slot
	bgt	$t0, $t8, doIf2		# && ($t0 > Z), is lowercase
	nop				# Branch delay slot
	
	addiu	$t0, $t0, 32		# Else is uppercase, un-capitalize
	j	end2			# Skip if
	nop				# Jump delay slot
doIf2:	addiu	$t0, $t0, -32		# Is lowercase, capitalize
end2:	sb	$t0, 0($s0)		# Store the new value
	
end1:	nop				# Do nothing
	
	addiu	$s0, $s0, 1		# Move to next byte
	j	while			# Reloop
	nop				# Jump delay slot
	
endWh:	li	$v0, 4			# Output new string
	la	$a0, str
	syscall
	
	li	$v0, 10			# Program will now terminate
	syscall

# END OF PROGRAM