#include "nios2_control.h"
#include "leds.h"
#include "timer.h"
#include "button.h"
#include "switches.h"
#include "chario.h"

extern int hours, minutes, seconds, one_sec_flag, button_flag, change, cleared;

unsigned int timer_count = 0;
unsigned int led_start = 0x200;
unsigned int hex_flag = 0;
void interrupt_handler(void)
{
	unsigned int ipending;
	
	/* read current value in ipending register */
	ipending = NIOS2_READ_IPENDING();
	
	/** if push button is pressed */
	if((ipending & 0x2) != 0) {
		*BUTTON_EDGE = 0; //reset interrupt signal
		button_flag = button_flag == 0 ? 1 : 0;
		if(button_flag == 0 && cleared == 0) {
			cleared = 1;
		}
	}

	/* _if_ ipending bit for timer is set */
	if((ipending & 0x1) != 0) {
		*LEDS = led_start;
		led_start = led_start >> 1;
		if(*LEDS == 0x001) {
			led_start = 0x200;
		}

		if(*SWITCHES == 0x1) {
			hex_flag = 1;
			DisplayHoursMinutes();
		} else {
			hex_flag = 0;
			clearHexDisplay();
		}

		
		*TIMER_STATUS = 0;
		timer_count++;
		if(timer_count >= 10) {
			timer_count = 0;
			one_sec_flag = 1;
			seconds++;
			change = 1;
			if(seconds >= 60) {
				seconds = 0;
				minutes++;
				if(minutes >= 60) {
					minutes = 0;
					hours++;
					if(hours >= 24) {
						hours = 0;
					}
				}
				if(hex_flag == 1) {
					DisplayHoursMinutes();
				} 			
			}
		}
	}
	
}
