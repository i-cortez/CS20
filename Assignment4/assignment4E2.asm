#
# assignment4E2.asm
# Ismael Cortez
# 03/16/2019
#
# This program capitalizes the first character of any word
# assuming in a string assuming it contains only lower case characters
# and spaces.
#

	.data
myStr:	.asciiz	"in a  hole in the  ground there lived a hobbit"
nL:	.asciiz	"\n"

	.text
	.globl	main

main:
	ori	$t0, $zero, 0		# $t0 = char pointer
	ori	$t1, $zero, 0		# $t1 = pointer value
	ori	$t2, $zero, 32		# $t2 = space bit pattern
	ori	$t3, $zero, 1		# $t3 = first char flag, set true
	
	ori	$v0, $zero, 4		# Output the original string
	la	$a0, myStr
	syscall
	la	$a0, nL
	syscall
	
	la	$t0, myStr		# Points to the first char
	
while:	lbu	$t1, 0($t0)		# Load pointer value
	nop				# Load delay slot
	beq	$t1, $zero, endWh	# while($t1 != NULL)
	nop				# Branch delay slot
	
if1:	beq	$t1, $t2, true1		# if($t1 == 32), do true1
	nop				# Branch delay slot
	
if2:	bne	$t3, $zero, true2	# if($t3 == 1), do true2
	nop				# Branch delay slot
	j	endIf2			# Skip true2
	nop				# Jump delay slot
	
true2:	addiu	$t1, $t1, -32		# Capatalize character
	ori	$t3, $zero, 0		# flag = false
	sb	$t1, 0($t0)		# Replace the value
endIf2:	nop

	j	endIf1			# Skip true1
	nop				# Jump delay slot
	
true1:	ori	$t3, $zero, 1		# flag = true
endIf1:	nop
	
	addiu	$t0, $t0, 1		# Increment the pointer, store delay
	j	while			# Reloop
	nop				# Jump delay slot
	
endWh:	ori	$v0, $zero, 4		# Output new string
	la	$a0, myStr
	syscall
	
	ori	$v0, $zero, 10		# Program will now terminate
	syscall

# END OF PROGRAM