.set mpat

.equ DATA_LOC, 0x1000

.text

.global _start

.org 0x0000

_start: ldw, r1, DATA_LOC(r0)
addi r1, r1, 1
stw r1, DATA_LOC(r0)
br _start

.end

