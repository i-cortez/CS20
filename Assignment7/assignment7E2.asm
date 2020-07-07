#
# assignment7E2.asm
#
# Ismael Cortez
# 4/23/2019
# CS21 Assignment 7
#
# This program will loop through 10 iterations, where in each pass the user
# will be prompted for two floating-point numbers. The program will then
# calculate the product of the two numbers and output the result.
#

	.data
prompt:	.asciiz	"Enter floating-point value: "
endMsg:	.asciiz	"Product: "
end:	.asciiz	"END OF PROGRAM"
nls:	.asciiz	"\n\n"

	.text
	.globl	main

main:
	li	$s0, 0		# $s0 = count
	li	$s1, 9		# $s1 = End of Sequence
	
	# Loop will perform 10 iterations.
while:
	bgt	$s0, $s1, endMain
	nop
	
	la	$a0, prompt	# First function call to get float input
	jal	getFloat
	nop
	mov.s	$f12, $f0	# Store result to be used in product calc
	
	la	$a0, prompt	# Second function call to get float input
	jal	getFloat
	nop
	mov.s	$f14, $f0	# Store result to be used in product calc
	
	jal	product		# Calculate the product of the two floats
	nop
	mov.s	$f12, $f0	# Store result as argument for printing
	
	la	$a0, endMsg	# Output the result to user
	jal	print
	nop
	
	li	$v0, 4		# Output new line
	la	$a0, nls
	syscall
	
	addiu	$s0, $s0, 1	# count++
	j	while
	nop
endMain:
	li	$v0, 4
	la	$a0, end
	syscall
	li	$v0, 10		# Program will now terminate
	syscall

# END OF PROGRAM

getFloat:
# On Entry:
#	$a0 = string pointer
# On Exit:
#	$f0 = float value

	li	$v0, 4		# Output prompt for float value
	syscall
	li	$v0, 6		# Read in float from user
	syscall
endGetFloat:
	jr	$ra		# Back to caller
	nop
	
product:
# On Entry:
#	$f12 = float value
#	$f14 = float value
# On Exit:
#	$f0 = $f12 * $f14

	mul.s	$f0, $f12, $f14
	
endProduct:
	jr	$ra		# Back to caller
	nop
	
print:
# On Entry:
#	$a0 = string pointer
#	$f12 = final float result
# On Exit:
#	No return value

	li	$v0, 4		# Output description to user
	syscall
	li	$v0, 2		# Output the result
	syscall
	
endPrint:
	jr	$ra		# Back to caller
	nop