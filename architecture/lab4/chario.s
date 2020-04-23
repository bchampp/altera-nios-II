.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF

.text
.global PrintString, PrintChar, GetChar


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

.end
