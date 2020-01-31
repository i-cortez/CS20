#
# assignment4E3.asm
#
# Ismael Cortez
# 3/17/2019
# CS21 Assignment 4 Exercise 3
#
# This program will capitalize the first letter of each word only if it is
# lowercase and follows a space, or if it is the first character on the line.
# The program assumes that string data contains only uppercase, lowercase,
# and space characters.
#
	.data
myStr:	.asciiz	"in a  Hole in the  Ground there lived A hobbit"
nL:	.asciiz	"\n"

	.text
	.globl	main

main:
	la	$s0, myStr		# $s0 = myStr[0]
	la	$s1, myStr		# $s1 = myStr[0], always
	li	$t0, 0			# $t0 = *myStr[0]
	li	$t1, 1			# $t1 = myStr[i - 1]
	li	$t9, 32			# $t9 = 32, space char
	li	$t8, 65			# $t8 = 'A'
	li	$t7, 90			# $t7 = 'Z'
	
	li	$v0, 4			# Output original string
	la	$a0, myStr
	syscall
	la	$a0, nL			# '\n'
	syscall
	
while:
	lbu	$t0, 0($s0)		# $t0 = *myStr[i]
	nop				# Load delay slot
	beq	$t0, $zero, endWh	# while(*p != NULL)
	nop				# Branch delay slot
if1:
	beq	$t0, $t9, doIf1		# if(*p == space)
	nop				# Branch delay slot
if2:
	blt	$t0, $t8, doIf2		# if(*p < A)
	nop
	bgt	$t0, $t7, doIf2		# if(*p > Z), is lowercase
	nop
	j	end2			# Skip if2
	nop				# Jump delay slot
doIf2:
if3:
	lbu	$t1, -1($s0)		# Loads the char before current
	nop				# Load delay slot
	beq	$s0, $s1, doIf3		# if(*p == first char)
	nop				# Branch delay slot
	beq	$t1, $t9, doIf3		# or if(*p - 1 == space)
	nop				# Branch delay slot
	j	end3			# Skip if3
	nop
doIf3:	addiu	$t0, $t0, -32		# Capitalize character
	sb	$t0, 0($s0)		# Rewrite value in RAM
end3:	nop
end2:	nop				# Do nothing
	j	end1			# Skip if1
	nop				# Jump delay slot
doIf1:	nop				# Do nothing
end1:	nop				# Do nothing
	
	addiu	$s0, $s0, 1		# Move to next char
	j	while			# Reloop
	nop				# Jump delay slot
endWh:
	li	$v0, 4			# Output new string
	la	$a0, myStr
	syscall
	
	li	$v0, 10			# The program will now end
	syscall

# END OF PROGRAM