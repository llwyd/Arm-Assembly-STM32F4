@
@	push.s
@	T.L. 2018
@	Turns on LED when push button is pressed
@
@
	.equ    STACK_TOP, 0x20000000
	.text
	.syntax unified
	.thumb
	.global _start
	.type start, %function
_start:
	.word STACK_TOP, start
start:
	ldr r0, = 0x40023800	@ Address for RCC Clock Enable for PORT D
	ldr r1, [r0, #0x30]		@ Load with Offset
	orr r1, #8				@ Enable Port D (LEDs)
	orr r1, #1				@ Enable Port A (button)
	str r1, [r0, #0x30]		@ Store value

	ldr r0, = 0x40020000	@ Load Pin Mode Select Register for GPIOA
	ldr r1, [r0, #0x00]  	@ Load with Offset
	bfc r1, #0, #2  		@ Set PA0 as Input
	str r1, [r0, #0x00] 	@ Store value

	ldr r0, = 0x40020C00 	@ Load Pin Mode Select Register for GPIOD
	ldr r1, [r0, #0x00]  	@ Load with Offset
	bfc r1, #24, #8  		@ Clear bits for PD12/13/14/15
	orr r1, #0x55000000  	@ Set bits for Output
	str r1, [r0, #0x00] 	@ Store value

	ldr r3, = 0x40020000	@ Load base register for GPIOA
	mov r4, #0x01  			@ Comparison Value 
clear:						@ Clear LEDs
	mov r1,#0x0 			
	str r1,[r0,#0x14]
loop:
	ldr r2,[r3,#0x10]		@ Read Input Pin
	and r6,r2,#0x01			@ Apply Bitmask
	cmp r4,r6				@ Compare with r4
	bne clear				@ if not equal then clear leds
	mov r1,#0xFFFFFFFF		@ else Set LEDS
	str r1,[r0,#0x14]
	b loop					@ Loop
deadloop:	
	b	deadloop
.end 