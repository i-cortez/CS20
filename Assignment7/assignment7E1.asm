#
# assignment7E1.asm
#
# Ismael Cortez
# 4/21/2019
# CS21 Assignment 7
#
# This program prompts the user for three values: a, b, and c. The program
# then evaluates the expression 3ab - 2bc - 5a + 20ac - 16 and outputs the
# result to the user.
#
	.data
usrMsg:	.asciiz	"This program evaluates: 3ab - 2bc - 5a + 20ac - 16\n"
msgA:	.asciiz	"Enter a: "
msgB:	.asciiz	"Enter b: "
msgC:	.asciiz	"Enter c: "
nl:	.asciiz	"\n"
endMsg:	.asciiz	"Result: "
a:	.float	0.0
be:	.float	0.0
c:	.float	0.0

	.text
	.globl	main
main:
	li	$v0, 4		# Alert user to program purpose
	la	$a0, usrMsg
	syscall
	
	la	$a0, msgA	# Get 'a' from user and store
	jal	getFloat
	nop
	s.s	$f0, a
	
	la	$a0, msgB	# Get 'b' from user and store
	jal	getFloat
	nop
	s.s	$f0, be
	
	la	$a0, msgC	# Get 'c' from user and store
	jal	getFloat
	nop
	s.s	$f0, c
	
	l.s	$f20, a		# Load 3, 'a', and 'b' into registers
	l.s	$f21, be	# then evaluate 3ab
	li.s	$f22, 3.0
	mul.s	$f20, $f20, $f21
	mul.s	$f20, $f20, $f22
	addiu	$sp, $sp, -4	# Push 3ab onto the stack
	s.s	$f20, ($sp)
	
	l.s	$f20, be	# Load -2, 'b', and 'c' into registers
	l.s	$f21, c		# then evaluate -2bc
	li.s	$f22, -2.0
	mul.s	$f20, $f20, $f21
	mul.s	$f20, $f20, $f22
	addiu	$sp, $sp, -4	# Push the result onto the stack
	s.s	$f20, ($sp)
	
	l.s	$f20, a		# Load -5 and 'a' into registers
	li.s	$f21, -5.0	# then evaluate -5a
	mul.s	$f20, $f20, $f21
	addiu	$sp, $sp, -4	# Push the result onto the stack
	s.s	$f20, ($sp)
	
	l.s	$f20, a		# Load 20, 'a', and 'c' into registers
	l.s	$f21, c		# then evaluate 20ac
	li.s	$f22, 20.0
	mul.s	$f20, $f20, $f21
	mul.s	$f20, $f20, $f22
	addiu	$sp, $sp, -4	# Push the result onto the stack
	s.s	$f20, ($sp)
	
	li.s	$f20, -16.0	# Initialize accumulator $f20 = -16
	l.s	$f21, ($sp)	# Pop the result of 20ac, add to $f20
	addiu	$sp, $sp, 4
	add.s	$f20, $f20, $f21
	
	l.s	$f21, ($sp)	# Pop the result of -5a, add to $f20
	addiu	$sp, $sp, 4
	add.s	$f20, $f20, $f21
	
	l.s	$f21, ($sp)	# Pop the result of -2bc, add to $f20
	addiu	$sp, $sp, 4
	add.s	$f20, $f20, $f21
	
	l.s	$f21, ($sp)	# Pop the result of 3ab, add to $f20
	addiu	$sp, $sp, 4
	add.s	$f20, $f20, $f21
	
	li	$v0, 4		# Output mesage for result
	la	$a0, nl
	syscall
	la	$a0, endMsg
	syscall
	
	li	$v0, 2		# Output the result
	mov.s	$f12, $f20
	syscall
endMain:
	li	$v0, 10
	syscall
# END OF PROGRAM
	
getFloat:
# On Entry:
#	$a0 = msg to user
#
# On Exit:
#	$f0 = user float input
#
	li	$v0, 4		# Output prompt to user
	syscall
	li	$v0, 6		# Read user float input
	syscall
endGetFloat:
	jr	$ra		# Return to caller
	nop