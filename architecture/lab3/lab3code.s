.equ	LAST_RAM_WORD,	0x007FFFFC
.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF

	.text
	.global _start
	.org	0x00000000

_start:
	movia sp, LAST_RAM_WORD
	movia r2, MSG1
    call PrintString
    movia r2, MSG2
    call PrintString
    call GetDecimal
    movia r3, NUMBER
    stw r2, 0(r3)
    movi r2, '\n'
    call PrintChar
    movia r2, MSG3
    call PrintString
    ldw r2, 0(r3)
    call PrintDecimal
    movi r2, '\n'
    call PrintChar
    
_end:
br _end


PrintChar:
    subi sp, sp, 8
    stw r3, 4(sp)
    stw r4, 0(sp)
    movia r3, JTAG_UART_BASE
pc_loop:
    ldwio r4, STATUS_OFFSET(r3)
    andhi r4, r4, WSPACE_MASK
    beq r4, r0, pc_loop
    stwio r2, DATA_OFFSET(r3)
    ldw r3, 4(sp)
    ldw r4, 0(sp)
    addi sp, sp, 8
	ret
    
PrintString:
    subi sp, sp, 12
    stw ra, 8(sp)
    stw r3, 4(sp)
    stw r2, 0(sp)
    mov r3, r2
ps_loop:
	ldb r2, 0(r3)
    beq r2, r0, end_ps_loop
    call PrintChar
    addi r3, r3, 1
    br ps_loop
end_ps_loop:
	ldw ra, 8(sp)
    ldw r3, 4(sp)
    ldw r2, 0(sp)
    addi sp, sp, 12
    ret

GetChar:
	subi sp, sp, 8
    stw r3, 0(sp)
    stw r4, 4(sp)
    movia r3, JTAG_UART_BASE
b_loop:
    ldwio r4, DATA_OFFSET(r3)
    andi r2, r4, 0x8000
    beq r2, r0, b_loop
    andi r2, r4, 0xFF
    ldw r3, 0(sp)
    ldw r4, 4(sp)
    addi sp, sp, 8
  	ret

GetDecimal:
	subi sp, sp, 12
    stw ra, 0(sp)
    stw r3, 4(sp)
    stw r5, 8(sp)
    mov r3, r0
c_loop:
	 call GetChar
     movi r5, '1'
     blt r2, r5, c_loop
     movi r5, '9'
     bgt r2, r5, c_loop
     call PrintChar
     subi r3, r2, '0'
     muli r3, r3, 10
d_loop:
	  call GetChar
      movi r5, '1'
      blt r2, r5, d_loop
      movi r5, '9'
      bgt r2, r5, d_loop
      call PrintChar
      subi r5, r2, '0'
      add r3, r3, r5
      mov r2, r3
      ldw ra, 0(sp)
      ldw r3, 4(sp)
      ldw r5, 8(sp)
      addi sp, sp, 12
      ret
      
PrintDecimal:
	subi sp, sp, 20
    stw r2, 0(sp)
    stw r3, 4(sp)
    stw r4, 8(sp)
    stw ra, 12(sp)
    stw r5, 16(sp)
	mov r3, r2
    movi r4, 10
    div r5, r2, r4
    addi r2, r5, '0'
    call PrintChar
    muli r2, r5, 10
    sub r3, r3, r2
    addi r3, r3, '0'
    mov r2, r3
    call PrintChar
    ldw r2, 0(sp)
    ldw r3, 4(sp)
    ldw r4, 8(sp)
    ldw ra, 12(sp)
    ldw r5, 16(sp)
    addi sp, sp, 20
    ret
    
    
	.org 0x00001000   
    
    NUMBER: .skip 4
    MSG1:	.asciz	"ELEC274 Lab3\n"
    MSG2:	.asciz	"Type two decimal digits:\n "
    MSG3:	.asciz	"You typed: "
    

.end
