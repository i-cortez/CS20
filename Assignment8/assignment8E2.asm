#
# assignment8E2.asm
#
# Ismael Cortez
# 5/1/2019
# CS21 Assignment 8 Exercise 2
#
# The program will write out the first 1000, 2000, ..., 10000 terms of the
# Gregory-Leibniz series by using an iterative and a recursive function. Each
# function will save the 1000, 2000, ..., 10000 term into an array and output
# the values at the end.
#

	.data
size:	.word	10
arrI:	.float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
arrR:	.float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
tab:	.asciiz	"\t"
nl:	.asciiz	"\n"

	.text
	.globl	main

main:
	li	$s0, 10000		# $s0 = constant of 10000
	
	# Caller Prolog
	addiu	$sp, $sp, -4		# Create space for parameter N = 10000
	sw	$s0, ($sp)		# Store parameter on the stack
	jal	recur			# Call with JAL
	nop
	
	# Caller Epilog
	addiu	$sp, $sp, 4		# Deallocate space for N
	
	# Caller Prolog
	addiu	$sp, $sp, -4		# Create space for parameter N = 10000
	sw	$s0, ($sp)		# Store parameter on the stack
	jal	iter			# Call with JAL
	nop
	
	# Caller Epilog
	addiu	$sp, $sp, 4		# Deallocate space for N
	
	la	$s0, arrI		# Get the first index address
	li	$s1, 0			# $s1 = loop counter
	lw	$s2, size		# Get the array size
	nop
forA:
	bge	$s1, $s2, endForA	# for($s1 = 0; $s1 < size; $s1++)
	nop
	l.s	$f12, 0($s0)		# Get the float at index $s0
	li	$v0, 2			# Print the float
	syscall
	li	$v0, 4			# Output tab between elements
	la	$a0, tab
	syscall
	
	addiu	$s0, $s0, 4		# Move to the next float
	addiu	$s1, $s1, 1		# Increment the index
	j	forA			# Reloop
	nop
	
endForA:
	li	$v0, 4			# Output new line between arrays
	la	$a0, nl
	syscall
	
	la	$s0, arrR		# Get the first index address
	li	$s1, 0			# $s1 = loop counter
forR:
	bge	$s1, $s2, endMain	# for($s1 = 0; $s1 < size; $s1++)
	nop
	l.s	$f12, 0($s0)		# Get the float at index $s0
	li	$v0, 2			# Print the float
	syscall
	li	$v0, 4			# Output tab between elements
	la	$a0, tab
	syscall
	
	addiu	$s0, $s0, 4		# Move to the next float
	addiu	$s1, $s1, 1		# Increment the index
	j	forR			# Reloop
	nop
endMain:
	li	$v0, 10
	syscall
# END OF PROGRAM

iter:
	# Subroutine Prolog
	addiu	$sp, $sp, -4		# Push the callers return address
	sw	$ra, ($sp)
	addiu	$sp, $sp, -4		# Push the callers frame pointer
	sw	$fp, ($sp)
	addiu	$fp, $sp, -4		# Create space for variable SUM
	move	$sp, $fp		# Initialize the stack pointer
	
	# Subroutine Body
	lw	$t0, 12($fp)		# Get N
	li	$t1, 0			# Initialize counter
	li	$t2, 1			# Initialize co-counter
	li	$t3, 1000		# $t3 = constant of 1000
	la	$t4, arrI		# $t4 = arrI[0]
	li.s	$f4, 4.0		# $f4 = constant 4.0
	li.s	$f5, 2.0		# $f5 = constant 2.0
	li.s	$f6, 1.0		# $f6 = constant 1.0
	li.s	$f7, 0.0		# $f7 = temp 0.0
	s.s	$f7, ($fp)		# SUM = 0.0
	li.s	$f8, 0.0		# $f8 = float N for arithmetic
forI:
	bge	$t1, $t0, endForI
	nop
	
	mul.s	$f7, $f5, $f8		# $f23 = 2N
	add.s	$f7, $f6, $f7		# $f23 = 2N + 1
	div.s	$f7, $f4, $f7		# $f23 = 4 / (2N + 1)
	l.s	$f9, ($fp)		# Load SUM
	nop
	
	andi	$t5, $t1, 1		# Test for even N
	beqz	$t5, evenI
	nop
	
	sub.s	$f7, $f9, $f7		# On odd N subtract intermediate
	j	endEvenI		# Skip over even case
	nop
	
evenI:	add.s	$f7, $f9, $f7		# $f23 = SUM + (4 / (2N + 1))
endEvenI:
	s.s	$f7, ($fp)		# SUM = SUM + or - (4 / (2N + 1))
	
	div	$t2, $t3		# Test if(((N + 1) % 1000) == 0)
	mfhi	$t6
	beqz	$t6, saveI
	nop
	j	reLoop			# Skip storing the array value
	nop
saveI:
	l.s	$f9, ($fp)		# Load SUM
	nop
	s.s	$f9, 0($t4)		# Store into the array
	addiu	$t4, $t4, 4		# Move to next array index
reLoop:
	addiu	$t1, $t1, 1		# Increment the counter
	addiu	$t2, $t2, 1		# Increment the co-counter
	add.s	$f8, $f8, $f6		# Increment the temp
	j	forI			# Reloop
	nop
endForI:
	# Subroutine Epilog
	addiu	$sp, $fp, 4		# Deallocate space for variable SUM
	lw	$fp, ($sp)		# Pop callers frame pointer
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)		# Pop callers return address
	addiu	$sp, $sp, 4
	jr	$ra			# Return to caller
	nop
# END OF SUBROUTINE

recur:
	# Subroutine Prolog
	addiu	$sp, $sp, -4		# Push the callers return address
	sw	$ra, ($sp)
	addiu	$sp, $sp, -4		# Push the callers frame pointer
	sw	$fp, ($sp)
	addiu	$fp, $sp, -4		# Initialize the frame pointer (SUM)
	move	$sp, $fp		# Initialize the stack pointer
	
	# Subroutine Body
	lw	$t0, 12($fp)		# Get the argument N
	nop
	mtc1	$t0, $f4		# Convert N to float for arithmetic
	cvt.s.w	$f4, $f4
	addiu	$t1, $t0, 1		# $t1 = (N + 1)
	li	$t2, 1000		# $t2 = constant 1000
	la	$t3, arrR		# point to first address of arrR
	li.s	$f5, 4.0		# $f5 = constant 4.0
	li.s	$f6, 2.0		# $f6 = constant 2.0
	li.s	$f7, 1.0		# $f7 = constant 1.0
	li.s	$f8, 0.0		# $f8 = temp
	s.s	$f8, ($fp)		# Initialize SUM
	
	blez	$t0, leZero		# if(N <= 0)
	nop
	
	# Else, SUM = recur(N - 1) Caller Prolog
	addiu	$sp, $sp, -4		# Push on $t0 = N
	sw	$t0, ($sp)
	addiu	$sp, $sp, -4		# Push on $t1 = (N + 1)
	sw	$t1, ($sp)
	addiu	$sp, $sp, -4		# Push on $f4
	s.s	$f4, ($sp)
	addiu	$sp, $sp, -4		# Allocate space for (N - 1)
	addiu	$t0, $t0, -1		# Compute (N - 1)
	sw	$t0, ($sp)
	jal	recur			# Recursive call
	nop
	
	# SUM = recur(N - 1) Caller Epilog
	addiu	$sp, $sp, 4		# Deallocate space for (N - 1)
	l.s	$f4, ($sp)		# Pop $f4
	addiu	$sp, $sp, 4
	lw	$t1, ($sp)		# Pop $t1
	addiu	$sp, $sp, 4
	lw	$t0, ($sp)		# Pop $t0
	addiu	$sp, $sp, 4
	
	s.s	$f0, ($fp)		# Store the returned value in SUM
	mul.s	$f8, $f6, $f4		# Compute 2N
	add.s	$f8, $f8, $f7		# 2N + 1
	div.s	$f8, $f5, $f8		# 4 / (2N + 1)
	l.s	$f0, ($fp)		# Load SUM
	nop
	andi	$t4, $t0, 1		# Test for even N
	beqz	$t4, evenR
	nop
	
	sub.s	$f0, $f0, $f8		# Else SUM - (4 / (2N + 1))
	j	endEvenR		# Skip other case
	nop
	
evenR:	add.s	$f0, $f0, $f8		# SUM + (4 / (2N + 1))
endEvenR:
	s.s	$f0, ($fp)		# SUM = SUM +- (4 / (2N + 1))
	div	$t1, $t2		# (N + 1) % 1000
	mfhi	$t4
	beqz	$t4, saveR		# if(((N + 1)%1000) == 0)
	nop
	j	epilogR			# Else jump save in array
	nop
saveR:
	l.s	$f8, ($fp)		# Load SUM
	nop
	s.s	$f8, 0($t3)		# Store into arrR
	addiu	$t3, $t3, 4		# Move to next array index
	j	epilogR			# Skip other return values
	nop

leZero:	mov.s	$f0, $f5		# Base case, return 4.0
epilogR:
	# Subroutine Epilog
	addiu	$sp, $fp, 4		# Uninitialize the frame pointer (SUM)
	lw	$fp, ($sp)		# Pop the callers frame pointer
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)		# Pop callers return addres
	addiu	$sp, $sp, 4
	jr	$ra			# Return to caller
	nop
# END OF SUBROUTINE