#
# assignment8E1.asm
#
# Ismael Cortez
# 4/21/2019
# CS21 Assignment 8 Exercise 1
#
# This program prompts the user to enter an integer N and then calculates the
# Nth Fibonacci number through a recursive subroutine call using the
# real-world calling convention. The result is output to the user at the end.
#
	.data
prompt:	.asciiz	"Enter an integer N to calculate Fib(N): "
endMsg:	.asciiz	"Result: "

	.text
	.globl	main

main:
	li	$v0, 4		# Output the prompt to user
	la	$a0, prompt
	syscall
	li	$v0, 5		# Get integer input N
	syscall
	
	# Caller Prolog
	addiu	$sp, $sp, -4	# Allocate space for N
	sw	$v0, ($sp)	# Push N onto the stack
	jal	fib		# Call Fib(N)
	nop
	
	# Caller Epilog
	addiu	$sp, $sp, 4	# Deallocate space used for N
	move	$s0, $v0	# Hold the result
	
	li	$v0, 4		# Output description of result to user
	la	$a0, endMsg
	syscall
	li	$v0, 1		# Output the integer result
	move	$a0, $s0
	syscall
	
endMain:
	li	$v0, 10
	syscall	

# END OF PROGRAM

fib:
	# Subroutine Prolog
	addiu	$sp, $sp, -4		# Push the caller's return address
	sw	$ra, ($sp)
	addiu	$sp, $sp, -4		# Push the caller's frame pointer
	sw	$fp, ($sp)
	addiu	$fp, $sp, -8		# Initialize the frame pointer
	move	$sp, $fp		# Initialize the stack pointer
	
	# Subroutine Body
	lw	$t0, 16($fp)		# Get the argument N
	li	$t1, 1			# Constant of 1
	li	$t2, 2			# Constant of 2
	
	ble	$t0, $zero, base1	# if(N <= 0)
	nop
	beq	$t0, $t1, base2		# if(N == 1)
	nop
	
	# Recursive step x = fib(N - 1), Caller Prolog
	addiu	$sp, $sp, -4		# Push the $t registers
	sw	$t0, ($sp)
	addiu	$sp, $sp, -4
	sw	$t1, ($sp)
	addiu	$sp, $sp, -4
	sw	$t2, ($sp)
	addiu	$sp, $sp, -4		# Allocate space for (N - 1)
	addiu	$t0, $t0, -1		# $t0 = N - 1
	sw	$t0, ($sp)
	jal	fib			# Recursive call
	nop
	
	# Recursive step x = fib(N - 1), Caller Epilog
	addiu	$sp, $sp, 4		# Deallocate space for (N - 1)
	lw	$t2, ($sp)		# Pop the $t registers
	addiu	$sp, $sp, 4
	lw	$t1, ($sp)
	addiu	$sp, $sp, 4
	lw	$t0, ($sp)
	addiu	$sp, $sp, 4
	
	sw	$v0, 4($fp)		# Store the returned value in x
	
	# Recursive step y = fib(N - 2), Caller Prolog
	addiu	$sp, $sp, -4		# Push the $t registers
	sw	$t0, ($sp)
	addiu	$sp, $sp, -4
	sw	$t1, ($sp)
	addiu	$sp, $sp, -4
	sw	$t2, ($sp)
	addiu	$sp, $sp, -4		# Allocate space for (N - 2)
	addiu	$t0, $t0, -2		# $t0 = N - 2
	sw	$t0, ($sp)
	jal	fib			# Recursive call
	nop
	
	# Recursive step y - fib(N - 2), Caller Epilog
	addiu	$sp, $sp, 4		# Deallocate space for (N - 2)
	lw	$t2, ($sp)		# Pop the $t registers
	addiu	$sp, $sp, 4
	lw	$t1, ($sp)
	addiu	$sp, $sp, 4
	lw	$t0, ($sp)
	addiu	$sp, $sp, 4
	
	sw	$v0, 0($fp)		# Store the returned value in y
	
	# Subroutine Epilog
	lw	$t3, 4($fp)		# $t3 = x
	lw	$t4, 0($fp)		# $t3 = y
	nop
	addu	$v0, $t3, $t4		# Return (x + y)
	j	epilog			# Skip other case return values
	nop
	
base1:	li	$v0, 0			# Return 0
	j	epilog			# Skip other case return value
	nop
base2:	li	$v0, 1			# Return 1
epilog:
	addiu	$sp, $fp, 8		# Un-initialize stack frame pointer
	lw	$fp, ($sp)		# Pop caller's frame pointer
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)		# Pop caller's return address
	addiu	$sp, $sp, 4
	jr	$ra			# Return to caller
	nop