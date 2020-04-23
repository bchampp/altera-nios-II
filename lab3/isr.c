#include "nios2_control.h"
#include "leds.h"
#include "timer.h"
#include "button.h"

extern int flag;

void interrupt_handler(void)
{
	unsigned int ipending;
	
	/* set flag */
	flag = 1;
	
	/* read current value in ipending register */
	ipending = NIOS2_READ_IPENDING();
	
	
	/* _if_ ipending bit for timer is set,
	   _then_
	       clear timer interrupt,
	       and toggle the least-sig. LED
	       (use the C '^' operator for XOR with constant 1)
	*/
	if((ipending & 0x1) != 0) {
		*TIMER_STATUS = 0;
		*LEDS ^= 0x1;
	}
	
	/** if push button is pressed */
	if((ipending & 0x2) != 0) {
		*BUTTON_EDGE = 0; //reset interrupt signal
		*LEDS ^= 0x2;
	}
}
