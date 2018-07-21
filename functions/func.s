@
@	func.s
@	T.L. 2018
@	Experimenting with functions
@
@
@	STM32F401RE

	.equ    STACK_TOP, 0x20010000
	.text
	.syntax unified
	.global _start
	.global testfunc
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
main:
	MOV r0, #0xFF		@ Various values to test push/pop
	mov r1, #0x12
	mov r2, #0x34
	mov r3, #0x56
	mov r4, #0x78
	mov r5, #0x9A
	mov r6, #0xBC
	mov r7, #0xDE
	mov r8, #0xF0
	mov r9, #0x12
	mov r10, #0x34
	@mov r11, #0x56
	push {r0}
	mov r0, #0x55
	pop {r0}
	bl testfunc
	mov r3,#0x4
	ldr r0, = 0x40020000    @ GPIO A Base Address
loop:
	eors r1,#0x20		@ XOR with 0x20
	str r1, [r0, #0x14] 	@ Store with offset
	mov r3, #0x100000 	@ Arbitrary Delay
delay:
	subs r3,1 		@ Substract 1 from delay
	bne delay 		@ When zero reset
	b loop			@ start loop again
	/*Arbitrary Function*/
testfunc:
	push {r4,lr}
	mov r4,#0x20
	pop {r4,pc}
deadloop:
	b	deadloop
.end

