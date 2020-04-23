#--------------------------------------------------------------------------------------------
# This program demonstrates arithmetic, memory accesses, and subroutines.
#--------------------------------------------------------------------------------------------
	.equ 	LAST_RAM_WORD, 0x007FFFFC 	# last word location in DRAM chip
	
	.text								# needed to indicate the start of a code segment
	.global _start						# makes the _start symbol visible to the linker
	.org 	0x00000000					# starting memory location for following content
	
_start:
	movia 	sp, LAST_RAM_WORD 			# initializes stack pointer for subroutines
	ldw		r2, A(r0)					# read value of A from memory into register r2
	ldw		r3, B(r0)					# read value of B from memory into register r3
	call	AddValues					# call subroutine with parameters in r2 and r3
	stw		r2, C(r)					# write return value in r2 to C in memory
		
_end:
	br		_end						# infinite loop once execution of program completes
			
#--------------------------------------------------------------------------------------------

AddValues:
	subi	sp, sp, 4					# adjust stack pointer down to reserve space
	stw		r16, 0(sp)					# save value of register r16 so it can be a temp
	add		r16, r2, r3					# add input values in r2 and r3, place sum in r16
	mov		r2, r16						# transfer value from r16 into r2
	ldw		r16, 0(sp)					# restore value of r16 from stack
	addi	sp, sp, 4					# readjust stack pointer up to deallocate space
	return								# return to calling routine with result in r2
	
#--------------------------------------------------------------------------------------------

	.org	0x00001000					# starting memory location for following content
	
A:	.word	7							# specify initial value of 7 in location for A
B: 	.word 	6							# specify initial value of 6 in location for B
C	.skip	4							# reserve 4 bytes (1 word) of space for C
										# (this space is technically uninitizalized
										# but it will normally be zero by default)
										
	.end								# indicates the end of the assembly-language source