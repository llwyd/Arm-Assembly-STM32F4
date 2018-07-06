@
@	template.s
@	T.L. 2018
@	Blinky template for ARM asm projects
@
@
@	STM32F401RE

	.equ    STACK_TOP, 0x20000000
	.text
	.syntax unified
	.thumb
	.global _start
	.type start, %function
_start:
	.word STACK_TOP, start
start:
	ldr r0, = 0x40023800	@ Base Address for RCC
	ldr r1, [r0, #0x30]	@ Load with Offset
	orr r1, #1		@ Enable Port A
	str r1, [r0, #0x30]	@ Store value

	ldr r0, = 0x40020000 	@ GPIO A Base Address
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #10, #2  	@ Clear bits for PA5 (LD2)
	orr r1, #0x400  	@ Set bits for Output
	str r1, [r0, #0x00] 	@ Store value

	MOV r1, #0x20		@ Initial value for PA5
loop:
	eors r1,#0x20		@ XOR with 0x20
	str r1, [r0, #0x14] 	@ Store with offset
	mov r3, #0x100000 	@ Arbitrary Delay
delay:
	subs r3,1 		@ Substract 1 from delay
	bne delay 		@ When zero reset
	b loop			@ start loop again
deadloop:
	b	deadloop
.end

