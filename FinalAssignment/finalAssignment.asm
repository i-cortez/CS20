#
# finalAssignment.asm
#
# Ismael Cortez
# 5/11/2019
# CS21 Final Programming Project
#
# This program starts with an asciiz string and an empty array and then copies
# the "source" array into the "display" array. Interrupts are then enabled to
# handle all input and output.
# The "display" string will be output to the terminal character by character
# until it's end. It will then start over at the beginnig on a new line.
# Whenever the user presses a key, the following tasks are performed:
# 's' - sorting of the "display" array
# 't' - toggling the case of every alphabetic character in "display"
# 'a' - restore the "display" array elements with the "source" elements
# 'r' - reverse the elements in "display"
# 'q' - quit the program
# All other character input is ignored.
#
# The following QtSpim settings are needed:
# Bare Machine OFF
# Accept Pseudo Instructions ON
# Enable Delayed Branches OFF
# Enable Delayed Loads OFF
# Enable Mapped IO ON
#
	.data
n:	.word	0
display:
	.space	64
source:	.asciiz	"Orange juice HAS 50MG of vitamin C per 100G serving\n"
	.text
	.globl	main
main:
	# Caller Prolog
	la	$s0, source
	addiu	$sp, $sp, -4		# Allocate space for source
	sw	$s0, ($sp)
	la	$s0, display
	addiu	$sp, $sp, -4		# Allocate space for display
	sw	$s0, ($sp)
	jal	copy
	
	# Caller Epilog
	addiu	$sp, $sp, 8		# Deallocate space for parameters
	
	mfc0	$s0, $12		# Access the Status register
	ori	$s0, $zero, 0x0c01	# Turn on bits 0, 10, and 11
	mtc0	$s0, $12		# Interrupts now enabled
	
	li	$s0, 0xffff0000		# Receiver Control register address
	lw	$s1, 0($s0)		# Load Receiver Control
	ori	$s1, $zero, 0x02	# Turn on the Interrupt Enable bit
	sw	$s1, 0($s0)		# Receiver interrupts enabled
	
	li	$s0, 0xffff0008		# Transmitter Control register address
	lw	$s1, 0($s0)		# Load Transmitter Control
	ori	$s1, $zero, 0x02	# Turn on the Interrupt Enable bit
	sw	$s1, 0($s0)		# Transmitter interrupts enabled
while:
	lw	$s0, n			# N indicates when to exit the loop
	beqz	$s0, while		# Reloop while not Q from user
endMain:
	li	$v0, 10
	syscall
# END OF PROGRAM

# BEGIN SUBROUTINE: copy
# On Entry:
#	12($fp) = address of first source element
#	8($fp) = address of first display element
# On Exit:
#	No Return Value
#
copy:
	# Subroutine Prolog
	addiu	$sp, $sp, -4		# Push callers $ra
	sw	$ra, ($sp)
	addiu	$sp, $sp, -4		# Push callers $fp
	sw	$fp, ($sp)
	move	$fp, $sp		# No variables, $fp = $sp
	
	# Subroutine Body
	lw	$t0, 12($fp)		# Get source
	lw	$t1, 8($fp)		# Get display
	lbu	$t2, 0($t0)		# Load ASCII from source
cLoop:
	sb	$t2, ($t1)		# Copy from source to display
	beqz	$t2, epilog		# IF($t2 == NUL), exit loop
	addiu	$t0, $t0, 1		# Next source byte
	addiu	$t1, $t1, 1		# Next display byte
	lbu	$t2, 0($t0)		# Load ASCII from source
	j	cLoop			# Reloop
epilog:
	# Subroutine Epilog
	move	$sp, $fp		# Restore $sp = $fp
	lw	$fp, ($sp)		# Pop callers $fp
	addiu	$sp, $sp, 4
	lw	$ra, ($sp)		# Pop callers $ra
	addiu	$sp, $sp, 4
	jr	$ra			# Return to caller
# END OF SUBROUTINE

# BEGIN INTERRUPT HANDLER
	.kdata
i:	.word	0
ktemp:	.space	44
	.ktext	0x80000180
	
	.set	noat			# Turn OFF $at before saving
	move	$k0, $at		# Store in $k0 for now
	.set	at			# Turn ON $at to use again
	
	la	$k1, ktemp		# Load the address of memory block
	sw	$k0, 0($k1)		# First word holds saved $at, $k0 free
	sw	$s0, 4($k1)		# Store ALL other used registers
	sw	$s1, 8($k1)
	sw	$s2, 12($k1)
	sw	$s3, 16($k1)
	sw	$s4, 20($k1)
	sw	$s5, 24($k1)
	sw	$s6, 28($k1)
	sw	$s7, 32($k1)
	sw	$t0, 36($k1)
	sw	$t1, 40($k1)
	
	mfc0	$s0, $13		# Determine the CAUSE of exception
	andi	$s0, $s0, 0x07c		# Extract the Exception Code
	bnez	$s0, endInter		# If not INTERRUPT, end the handler
	
	mfc0	$s0, $13		# Access the STATUS register
	andi	$s0, $s0, 0x0800	# Extract bit 11
	beqz	$s0, trans		# Check for a TRANSMITTER service
	lw	$s0, 0xffff0004		# ELSE, extract user input
	li	$s1, 0x061		# Check IF(input == 'a')
	beq	$s0, $s1, a		# Perform operation 'a'
	li	$s1, 0x071		# ELSE, check IF(input == 'q')
	beq	$s0, $s1, q		# Perform operation 'q'
	li	$s1, 0x072		# ELSE, check IF(input == 'r')
	beq	$s0, $s1, r		# Perform operation 'r'
	li	$s1, 0x073		# ELSE, check IF(input == 's')
	beq	$s0, $s1, s		# Perform operation 's'
	li	$s1, 0x074		# ELSE, check IF(input == 't')
	bne	$s0, $s1, endInter	# IF not equal end interrupt routine
	la	$s0, display		# ELSE, toggle the alphabetic chars
	li	$s1, 0x020		# $s1 = space
	li	$s2, 0x030		# $s2 = '0'
	li	$s3, 0x039		# $s3 = '9'
	li	$s4, 0x0a		# $s4 = '\n'
	li	$s5, 0x041		# $s5 = 'A'
	li	$s6, 0x05a		# $s6 = 'Z'
toggleLoop:
	lbu	$s7, 0($s0)		# Load the ASCII value
	beq	$s7, $s4, endToggleLoop	# IF($s7 == '\n'), end loop
	beq	$s7, $s1, increment	# IF($s7 == space), increment pointer
	sle	$t0, $s2, $s7		# Set IF('0' <= $s7)
	sle	$t1, $s7, $s3		# Set IF($s7 <= '9')
	and	$t0, $t0, $t1		# Determine if $s7 is in range
	bnez	$t0, increment		# IF('0' < $s7 < '9'), increment
	sle	$t0, $s5, $s7		# Set IF(A <= $s7)
	sle	$t1, $s7, $s6		# Set IF($s7 <= Z)
	and	$t0, $t0, $t1		# Determine if $s7 is in range
	bnez	$t0, isUpper		# IF(A < $s7 < Z), un-capitalize
	addiu	$s7, $s7, 0xffffffe0	# ELSE, is lowercase
	j	store			# Skip the IF case
isUpper:
	addiu	$s7, $s7, 0x020		# Un-capitalize the value
store:	sb	$s7, 0($s0)
increment:
	addiu	$s0, $s0, 0x01		# Move to next byte
	j	toggleLoop		# Reloop
endToggleLoop:
	j	endInter		# End the interrupt handler
s:
	li	$s0, 0			# Initialize a SIZE constant
	li	$s1, 0x0a		# Load the ASCII new line
	la	$s2, display		# Load the display string address
lLoop:
	lbu	$s3, 0($s2)		# Load the ASCII value at pointer
	beq	$s3, $s1, endLLoop	# IF(char == \n), End lLoop
	addiu	$s0, $s0, 0x01		# SIZE++
	addiu	$s2, $s2, 0x01		# Move to next ASCII char
	j	lLoop			# Reloop lLoop
endLLoop:
	li	$s1, 0			# Initialize index I
iLoop:
	beq	$s1, $s0, endILoop	# IF(I == SIZE), End iLoop
	subu	$s2, $s0, $s1		# Compute SIZE - I
	addiu	$s2, $s2, 0xFFFFFFFF	# Compute SIZE - I - 1
	li	$s3, 0			# Initialize index J
jLoop:
	beq	$s3, $s2, endJLoop	# IF(J == SIZE - I - 1), end jLoop
	la	$s4, display		# Load the address of display
	addu	$s5, $s4, $s3		# Add the offset J
	lbu	$s6, 0($s5)		# Load byte at index J
	lbu	$s7, 1($s5)		# Load the byte at index J + 1
	sgt	$t0, $s6, $s7		# Set IF(dis[j] > dis[J + 1])
	beqz	$t0, noSwap		# IF FALSE, no swap
	sb	$s7, 0($s5)		# Store the J + 1 value at J
	sb	$s6, 1($s5)		# Store the J value at J + 1
noSwap:
	addiu	$s3, $s3, 0x01		# J++
	j	jLoop			# Reloop jLoop
endJLoop:
	addiu	$s1, $s1, 0x01		# I++
	j	iLoop			# Reloop iLoop
	
endILoop:
	j	endInter		# End the interrupt handler
r:
	la	$s0, display		# Point to the base of display
	la	$s1, display		# Point to the base of display
	li	$s2, 0x0a		# Load with '\n'
moveUp:
	lbu	$s3, 0($s1)
	beq	$s3, $s2, endMoveUp
	addiu	$s1, $s1, 1		# Move up one byte
	j	moveUp
endMoveUp:
	addiu	$s1, $s1, -1		# Move to char before the '\n'
rev:
	bgeu	$s0, $s1, endRev	# While ($s0 < $s1), swap
	lbu	$s3, 0($s0)		# Load the char at $s0
	lbu	$s4, 0($s1)		# Load the char at $s1
	move	$s5, $s4		# Move the char at $s5 to a temp
	move	$s4, $s3		# Move the value in $s3 to $s4
	move	$s3, $s5		# Move the value in temp to $s3
	sb	$s3, 0($s0)		# Store the exchanged value
	sb	$s4, 0($s1)		# Store the exchanged value
	addiu	$s0, $s0, 1		# Increment the base pointer
	addiu	$s1, $s1, -1		# Decrement the base pointer
	j	rev			# Reloop
endRev:
	j	endInter		# End the interrupt handler
q:
	li	$s0, 0x01		# Load register with constant of 1
	sw	$s0, n			# Store the contents to N in main
	j	endInter		# End the interrupt handler
a:
	la	$s0, source		# Get source
	la	$s1, display		# Get display
	lbu	$s2, 0($s0)		# Load ASCII from source
cLoop2:
	sb	$s2, 0($s1)		# Else, copy source to display
	beqz	$s2, endCloop2		# IF($s2 == NUL), exit loop
	addiu	$s0, $s0, 1		# Next source byte
	addiu	$s1, $s1, 1		# Next display byte
	lbu	$s2, 0($s0)		# Load ASCII from source
	j	cLoop2			# Reloop
endCloop2:
	j	endInter
trans:
	mfc0	$s0, $13		# Determine if TRANSMITTER
	andi	$s0, $s0, 0x0400	# Extract bit 10
	beqz	$s0, endInter		# If not set, go to end
	la	$s0, display		# Get address of display string
	lw	$s1, i			# Load the offset variable
	addu	$s2, $s1, $s0		# Add the offset to the base address
	lbu	$s3, 0($s2)		# Load the char
	sw	$s3, 0xffff000c
	ori	$s4, $zero, 0x0a	# ASCII for New Line
	beq	$s3, $s4, clear		# If(char == \n), clear variable
	addiu	$s1, $s1, 0x01		# Else increase offset by one byte
	j	endClear		# Skip the if statement
clear:	li	$s1, 0
endClear:
	sw	$s1, i
endInter:
	lw	$t1, 40($k1)		# Restore ALL used registers
	lw	$t0, 36($k1)
	lw	$s7, 32($k1)
	lw	$s6, 28($k1)
	lw	$s5, 24($k1)
	lw	$s4, 20($k1)
	lw	$s3, 16($k1)
	lw	$s2, 12($k1)
	lw	$s1, 8($k1)
	lw	$s0, 4($k1)
	lw	$k0, 0($k1)		# Load saved $at back to $k0
	
	.set	noat			# Turn OFF $at before restoring
	move	$at, $k0		# Restore $at
	.set	at			# Turn ON $at to use again
	eret				# Return from the interrupt
# END OF INTERRUPT HANDLER