#
# assignment6.asm
#
# Ismael Cortez
# 4/15/2019
# CS21 Assignment 6
#
# This program prompts the user for the (x,y) coordinates of two points in the
# Cartesian plane, then calculates and displays the distance between the
# points.
#
# The subroutine sqrt(n) was adapted from:
# http://chortle.ccsu.edu/assemblytutorial/Chapter-32/ass32_14.html
# http://www.chabotcollege.edu/faculty/kmehl/csci21.htm
#
	.data
endMsg:	.asciiz	"The distance between (x1, y1), (x2, y2): "
x1:	.asciiz	"Enter coordinate x1: "
y1:	.asciiz	"Enter coordinate y1: "
x2:	.asciiz	"Enter coordinate x2: "
y2:	.asciiz "Enter coordinate y2: "
nl:	.asciiz	"\n"
n:	.float	2.0

	.text
	.globl	main
main:
	la	$a0, x1		# Pass the current prompt
	jal	getPoint	# Call getPoint(currentPrompt)
	nop
	mov.s	$f20, $f0	# $f20 = x1
	
	la	$a0, y1		# Pass the current prompt
	jal	getPoint	# Call getPoint(currentPrompt)
	nop
	mov.s	$f21, $f0	# $f21 = y1
	
	li	$v0, 4		# Output new line to separate ordered pair
	la	$a0, nl
	syscall
	
	la	$a0, x2		# Pass the current prompt
	jal	getPoint	# Call getPoint(currentPrompt)
	nop
	mov.s	$f22, $f0	# $f22 = x2
	
	la	$a0, y2		# Pass the current prompt
	jal	getPoint	# Call getPoint(currentPrompt)
	nop
	mov.s	$f23, $f0	# $f23 = y2
	
	# Compute (x2 - x1)^2
	sub.s	$f20, $f22, $f20
	mul.s	$f20, $f20, $f20
	# Compute (y2 - y1)^2
	sub.s	$f21, $f23, $f21
	mul.s	$f21, $f21, $f21
	# Compute dx^2 + dy^2
	add.s	$f22, $f20, $f21
	
	mov.s	$f16, $f22	# Argument = dx^2 + dy^2
	jal	sqrt		# Call sqrt(dx^2 + dy^2)
	nop
	mov.s	$f12, $f0	# Prepare to print result
	
	li	$v0, 4		# Output final mesage on new line
	la	$a0, nl
	syscall
	la	$a0, endMsg
	syscall
	
	li	$v0, 2		# Output the result to user
	syscall

endMain:
	li	$v0, 10		# End the program
	syscall

getPoint:			# getPoint(currentPrompt)
	li	$v0, 4		# Output prompt to user terminal
	syscall
	
	li	$v0, 6		# Float input will return in $f0
	syscall
endGetPoint:
	jr	$ra		# Return the the caller
	nop

sqrt:
	s.s	$f16, n		# Store the argument in 'n'
	nop
	
	l.s	$f4, n		# Retrieve 'n'
	li.s	$f5, 1.0	# Constant 1.0 used for ending approximation
	li.s	$f6, 2.0	# Constant 2.0 used for division
	li.s	$f7, 1.0	# $f7 = x, is first approximation
	li.s	$f8, 1.0e-5	# Five figure accuracy
	
doWhile:
	mov.s	$f9, $f4	# x' = n
	div.s	$f9, $f9, $f7	# x' = n/x
	add.s	$f9, $f9, $f7	# x' = x + n/x
	div.s	$f7, $f9, $f6	# x = (1/2)(x + n/x)
	
	mul.s	$f10, $f7, $f7	# x^2
	div.s	$f10, $f4, $f10	# n/x^2
	sub.s	$f10, $f10, $f5	# (n/x^2)- 1.0
	abs.s	$f10, $f10	# |(n/x^2)- 1.0|
	c.lt.s	$f10, $f8	# |(n/x^2)- 1.0| < small?
	bc1t	endDoWhile	# On YES exit loop
	nop
	j	doWhile		# Reloop for next approximation
	nop
	
endDoWhile:
	mov.s	$f0, $f7	# Move to return register
endSqrt:
	jr	$ra		# Return to caller
	nop