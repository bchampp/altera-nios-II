#include "chario.h"

void PrintChar(int ch) {
	unsigned int st;
	do {
		st = *JTAG_UART_STATUS;
		st = st & 0xFFFF0000;
	} while(st == 0);
	
	*JTAG_UART_DATA = ch;
}

void PrintString(char *s) {
	while(*s != '\0') {
		PrintChar(*s);
		s++;
	}
}

void PrintHexDigit(unsigned int n) {
	if(n >= 10) {
		PrintChar((n-10)+'A');
	} else {
		PrintChar(n + '0');
	}
}