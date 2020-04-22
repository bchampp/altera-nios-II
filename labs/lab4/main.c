#include "nios2_control.h"
#include "timer.h"
#include "chario.h"
#include "button.h"

#define HEX_DISPLAYS	((volatile unsigned int *) 0x10000020)

unsigned int hex_table[] =
{
	0x3F, 0x06, 0x5B, 0x4F,
	0x66, 0x6D, 0x7D, 0x07,
	0x7F, 0x6F, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00
};

unsigned int hours = 23;
unsigned int minutes = 59;
unsigned int seconds = 55;
unsigned int one_sec_flag;
unsigned int button_flag;
unsigned int change;
unsigned int cleared;

void	Init (void)
{
	
  /* initialize software variables */

	button_flag = 0;

	cleared = 0;

  /* set timer start value for interval of HALF SECOND (0.5 sec) */
	*TIMER_START_LO = 0x4B40;
	*TIMER_START_HI = 0x004C;
	
  /* clear extraneous timer interrupt */
	*TIMER_STATUS = 0;

  /* set ITO, CONT, and START bits of timer control register */
	*TIMER_CONTROL = 7;
	
  /* set button 1 interrupt enable */
	*BUTTON_MASK = 2;

  /* set device-specific bit for timer in Nios II ienable register */
	NIOS2_WRITE_IENABLE(3); 

  /* set IE bit in Nios II status register */
	NIOS2_WRITE_STATUS(1);  
}

void clearHexDisplay(void) {
	*HEX_DISPLAYS = 0;
}

void DisplayHoursMinutes(void) {
	int hoursTens = hours / 10;
	int hoursOnes = hours % 10;
	
	int minutesTens = minutes / 10;
	int minutesOnes = minutes % 10;
	
	*HEX_DISPLAYS = 
		(hex_table[hoursTens] << 24) |
		(hex_table[hoursOnes] << 16) |
		(hex_table[minutesTens] << 8) |
		(hex_table[minutesOnes]) |
		0x80000000;
}


int	main (void)
{

  /* perform initialization */
  Init ();

  /* print startup message */
  PrintString("  ");
  DisplayHoursMinutes();
  
  /* main program is an empty infinite loop */
  while (1) {
		if(cleared == 1) {
			PrintString("\b\b");
			PrintString("  ");
			cleared = 0;
			continue;
		}

	  if(one_sec_flag != 0) {
		  one_sec_flag = 0;
		  if(button_flag == 1) {
			if(change == 1) {
		  PrintString("\b\b");
		  unsigned int secondsTens = seconds / 10;
		  unsigned int secondsOnes = seconds % 10;
		 	 PrintHexDigit(secondsTens);
		  	 PrintHexDigit(secondsOnes);
			change = 0;
			}
		}
			}
  }


  return 0; /* never reached, but needed to avoid compiler warning */
}
