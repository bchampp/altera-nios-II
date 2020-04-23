#ifndef _BUTTON_H_
#define _BUTTON_H_


/* define pointer macros for accessing the push button registers */

#define BUTTON_DATA	((volatile unsigned int *) 0x10000050)

#define BUTTON_MASK	((volatile unsigned int *) 0x10000058)

#define BUTTON_EDGE	((volatile unsigned int *) 0x1000005C)


#endif /* _BUTTON_H_ */
