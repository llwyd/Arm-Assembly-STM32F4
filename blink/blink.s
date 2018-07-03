@
@	blink.s
@	T.L. 2018
@	Blinks the leds on in sequence and then off again
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
	orr r1, #8				@ Enable Port D
	str r1, [r0, #0x30]		@ Store value

	ldr r0, = 0x40020C00 	@ Load Pin Mode Select Register
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #24, #8  		@ Clear bits for PD12/13/14/15
	orr r1, #0x55000000  	@ Set bits for Output
	str r1, [r0, #0x00] 	@ Store value

	MOV r4, #0x8000 		@ Final LED value (PD15)
val:
	MOV r2, #0x1000 		@ Starting LED value (PD12)
loop:
	eors r1,r2				@ XOR with latest value of r2
	str r1, [r0, #0x14] 	@ Store with offset
	mov r3, #0x100000 		@ Arbitrary Delay
delay:
	subs r3,1 				@ Substract 1 from delay
	bne delay 				@ When zero reset
	cmp r2,r4				@ Compare current with final
	beq val 				@ if equal then reset
	lsls r2,#1 				@ shift left 1 place
	b loop					@ start loop again
deadloop:	
	b	deadloop
.end   
