.text
.global _start
.extern PrintString

_start: 
movia sp, 0x7FFFFC

movia r2, MSG
call PrintString

_end: 
break

# ----------------------------------------

.data

MSG: .asciz "ELEC 274 Lab 4\n"

.end
