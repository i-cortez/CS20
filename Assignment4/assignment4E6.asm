#
# assignment4E6.asm
#
# Ismael Cortez
# 03/19/2019
# CS21 Assignment 4 Exercise 6
#
# This program asks user to enter 10 integers and stores them into an
# array. The program then outputs the array, reverses the array values
# then outputs the array again.
#

	.data
size:	.word	10
array:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
prompt:	.asciiz	"Please input 10 integers.\n"
intPr:	.asciiz	"Int #"
semiC:	.asciiz	": "
tab:	.asciiz "\t"
nL:	.asciiz	"\n"

	.text
	.globl	main

main:
	li	$t2, 0			# $t2 = temp
	li	$t3, 0			# $t3 = i
	li	$t4, 1			# $t4 = (i + 1)
	la	$s0, size
	lw	$t5, 0($s0)		# $t5 = size
	nop				# Load delay slot
	la	$s0, array		# $s0 = array[0], Load delay slot
	li	$t0, 0			# $t0 = s
	la	$s1, array		# $s1 = array[0]
	li	$t1, 0			# $t1 = t
	
	li	$v0, 4			# Prompt user for input
	la	$a0, prompt
	syscall
	
forA:	bge	$t3, $t5, endForA	# for(i = 0, i < size; i++)
	nop				# Branch delay slot
	
	li	$v0, 4			# Display input number
	la	$a0, intPr
	syscall
	li	$v0, 1
	move	$a0, $t4
	syscall
	li	$v0, 4
	la	$a0, semiC
	syscall
	
	li	$v0, 5			# Read user input
	syscall
	
	sw	$v0, 0($s0)		# Store into array[i]
	nop				# Store delay slot
	addiu	$s0, $s0, 4		# Move to next word, Store delay slot
	addiu	$t3, $t3, 1		# i++
	addiu	$t4, $t3, 1		# i + 1
	
	j	forA			# Reloop
	nop				# Jump delay slot
endForA:
	li	$t3, 0			# i = 0
	la	$s0, array		# $s0 = array[0]
	
	li	$v0, 4			# Start output on a new line
	la	$a0, nL
	syscall
	
forB:	bge	$t3, $t5, endForB	# for(i = 0; i < size; i++)
	nop				# Branch delay slot
	
	lw	$t0, 0($s0)		# Load the value array[i]
	nop				# Load delay slot
	
	li	$v0, 1			# Prepare to print int
	move	$a0, $t0
	syscall
	
	li	$v0, 4			# Prepare to print tab
	la	$a0, tab
	syscall
	
	addiu	$t3, $t3, 1		# i++
	addiu	$s0, $s0, 4		# Move to next word
	
	j	forB			# Reloop
	nop				# Jump delay slot
endForB:
	la	$s0, array		# $s0 = array[0]
	la	$s1, array		# $s1 = array[0]
	addiu	$s1, $s1, 36		# $s1 = array[9]
	
while:	bgeu	$s0, $s1, endWh		# while(s < t)
	nop				# Branch delay slot
	
	lw	$t0, 0($s0)		# $t0 = value at $s0
	lw	$t1, 0($s1)		# $t1 = value at $s1
	nop
	
	move	$t2, $t1		# temp = *t
	move	$t1, $t0		# *t = *s
	move	$t0, $t2		# *s = temp
	
	sw	$t0, 0($s0)		# Store the new swapped values
	sw	$t1, 0($s1)
	nop				# Store delay slot
	
	addiu	$s0, $s0, 4		# Move to next word
	addiu	$s1, $s1, -4		# Move to previous word
	
	j	while			# Reloop
	nop				# Jump delay slot
endWh:
	li	$v0, 4			# Start output on a new line
	la	$a0, nL
	syscall
	
	li	$t3, 0			# i = 0
	la	$s0, array		# $s0 = array[0]
	
forC:	bge	$t3, $t5, endForC	# for(i = 0; i < size; i++)
	nop				# Branch delay slot
	
	lw	$t0, 0($s0)		# Load the value array[i]
	nop				# Load delay slot
	
	li	$v0, 1			# Prepare to print int
	move	$a0, $t0
	syscall
	
	li	$v0, 4			# Prepare to print tab
	la	$a0, tab
	syscall
	
	addiu	$t3, $t3, 1		# i++
	addiu	$s0, $s0, 4		# Move to next word
	
	j	forC			# Reloop
	nop				# Jump delay slot
endForC:
	li	$v0, 10			# Program will now terminate
	syscall

# END OF PROGRAM