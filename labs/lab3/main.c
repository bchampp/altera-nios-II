#include "nios2_control.h"
#include "timer.h"
#include "chario.h"
#include "button.h"

int flag;

void	Init (void)
{
  /* initialize software variables */

  /* set timer start value for interval of HALF SECOND (0.5 sec) */
	*TIMER_START_LO = 0x7840;
	*TIMER_START_HI = 0x017D;
	
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


int	main (void)
{

  /* perform initialization */
  Init ();

  /* print startup message */
  PrintString("ELEC 371 Lab 3\n");
  
  /* main program is an empty infinite loop */
  while (1) {
	  if(flag != 0) {
		  PrintChar('*');
		  flag = 0;
	  }
  }


  return 0; /* never reached, but needed to avoid compiler warning */
}
