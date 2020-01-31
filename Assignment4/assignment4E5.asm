#
# assignment4E5.asm
#
# Ismael Cortez
# 03/19/2019
# CS21 Assignment 4 Exercise 5
#
# This program program asks user to enter 10 integers and stores them into an
# array. Then the program loops through the array and locates the smallest and
# largest values. The found values are then output to the terminal.
#
	.data
size:	.word	10
array:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
prompt:	.asciiz	"Please input 10 integers.\n"
intPr:	.asciiz	"Int #"
semiC:	.asciiz	": "
msgS:	.asciiz	"Smallest: "
msgL:	.asciiz	"Largest: "
nL:	.asciiz	"\n"

	.text
	.globl	main

main:
	li	$t1, 0			# $t1 = smallest
	li	$t2, 0			# $t2 = largest
	li	$t3, 0			# $t3 = i
	li	$t4, 1			# $t4 = (i + 1)
	la	$s0, size
	lw	$t5, 0($s0)		# $t5 = size
	la	$s0, array		# $s0 = array[0], Load delay slot
	li	$t0, 0			# $t0 = *array[0]
	
	li	$v0, 4			# Prompt user for input
	la	$a0, prompt
	syscall
	
forA:	bge	$t3, $t5, endForA	# for(i = 0, i < size, i++)
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
	addiu	$s0, $s0, 4		# Move to next word, Store delay slot
	addiu	$t3, $t3, 1		# i++
	addiu	$t4, $t3, 1		# i + 1
	
	j	forA			# Reloop
	nop				# Jump delay slot
endForA:
	la	$s0, array		# Point back to array[0]
	lw	$t1, 0($s0)		# smallest = array[0]
	lw	$t2, 0($s0)		# largest = array[0]
	li	$t3, 1			# Reinitialize count
	addiu	$s0, $s0, 4		# Move to next word
	
forB:	bge	$t3, $t5, endForB
	nop
	lw	$t0, 0($s0)		# $t0 = *array[i]
	nop				# Load delay slot
	
ifA:	blt	$t0, $t1, doIfA		# if(array[i] < smallest)
	nop
	j	endIfA			# Else do nothing
	nop
doIfA:	addu	$t1, $zero, $t0		# smallest = array[i]
endIfA: nop
	
ifB:	bgt	$t0, $t2, doIfB		# if(array[i] > largest)
	nop
	j	endIfB			# Else do nothing
	nop
doIfB:	addu	$t2, $zero, $t0 	# largest = array[i]
endIfB:	nop
	
	addiu	$s0, $s0, 4		# Move to next word
	addiu	$t3, $t3, 1		# i++
	j	forB			# Reloop
	nop				# Jump delay slot
endForB:
	li	$v0, 4			# Start on a new line
	la	$a0, nL
	syscall
	la	$a0, msgS		# Output smallest
	syscall
	li	$v0, 1
	move	$a0, $t1
	syscall
	li	$v0, 4			# Start on a new line
	la	$a0, nL
	syscall
	
	li	$v0, 4
	la	$a0, msgL		# Output largest
	syscall
	li	$v0, 1
	move	$a0, $t2
	syscall
	
	li	$v0, 10			# Program will now terminate
	syscall

# END OF PROGRAM