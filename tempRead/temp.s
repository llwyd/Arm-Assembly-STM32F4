@
@	temp.s
@	T.L. 2018
@	Reads I2C temp sensor and outputs to display
@
@	STM32F401RE
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
	/*Default clock = 16MHz*/
	/* Configure and Setup LD2 located at PA5*/
	ldr r0, = 0x40023800	@ Address for RCC Clock Enable for GPIO A and B
	ldr r1, [r0, #0x30]	@ Load with Offset
	orr r1, #1		@ Enable GPIO A
	orr r1, #2		@ Enable GPIO B
	str r1, [r0, #0x30]	@ Store value

	ldr r0, = 0x40020000 	@ Load Pin Mode Select Register GPIO A
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #10, #2  	@ Clear bits for PA5
	orr r1, #0x400  	@ Set bits for Output
	str r1, [r0, #0x00] 	@ Store value
	/* Configure I2C*/
	/*PB8=SCL*/
	/*PB9=SDA*/

	/*Set Alternative Functions*/
        ldr r0, = 0x40020400    @ GPIO B base register
        ldr r1, [r0, #0x00]     @ Load Pin Mode Select Register
        bfc r1, #16, #4         @ Clear bits for PB8 and PB9
        orr r1, #0xA0000        @ Set bits for Alternative Function (0b10)
        str r1, [r0, #0x00]     @ Store value
	/*Set Open Drain*/
        ldr r1, [r0, #0x04]     @ Load output type register
        orr r1, #256            @ Open Drain for PB8
        orr r1, #512            @ Open Drain for PB9
        str r1, [r0, #0x04]     @ Store value
	/*Specify Alternate Function*/
	/*I2C = AF04*/
	ldr r1, [r0, #0x24]	@ Load AF High Register
	orr r1, #0x44		@ AF04 for PB8 and 9
	str r1, [r0, #0x24]	@ Store value
	/*I2C Clock enable*/
	ldr r0, = 0x40023800    @ Base Address for RCC
	ldr r1, [r0, #0x40]     @ Load with Offset
        orr r1, #0x200000       @ AF04 for PB8 and 9
        str r1, [r0, #0x40]     @ Store value

	/*I2C base address=0x40005400*/
	/*Configure I2C1 as master mode*/

	ldr r0, = 0x40020000    @ Load GPIO A base register for LED
val:
	MOV r2, #0x20 		@ Starting LED value (PA5)
	MOV r1, #0x00000000
loop:
	eors r1,r2		@ XOR with latest value of r2
	str r1, [r0, #0x14] 	@ Store with offset
	mov r3, #0x50000 	@ Arbitrary Delay
delay:
	subs r3,1 		@ Substract 1 from delay
	bne delay 		@ When zero reset
	b loop			@ start loop again
deadloop:
	b	deadloop
.end
