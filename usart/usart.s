@
@	usart.s
@	T.L. 2018
@	Basic USART
@
@
@	STM32F401RE
	.data
	.word 0x00000000
	.text
	.equ    STACK_TOP, 0x20000000
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
	/*Configure LED and set alternative fuction for PA2 and 3*/
	ldr r0, = 0x40020000 	@ GPIO A Base Address
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #10, #2  	@ Clear bits for PA5 (LD2)
	orr r1, #0x400  	@ Set bits for LED output
	bfc r1, #4, #4		@ Clear bits for PA2 and PA3
	orr r1, #0xA0		@ Set alternate function
	str r1, [r0, #0x00] 	@ Store value
	/*AF07=USART2 alternative function*/
	ldr r1, [r0,#0x20]	@ specify alternate function
	orr r1, #0x7700		@ AF07
	str r1, [r0,#0x20]	@ Store
	/* Turn on USART2 peripheral*/
        ldr r0, = 0x40023800    @ Base Address for RCC
        ldr r1, [r0, #0x40]     @ Load with Offset
        orr r1, #0x20000        @ Enable USART2
        str r1, [r0, #0x40]     @ Store value
	/*Configure USART2*/
	/*Tx=PA2*/
	/*Rx=PA3*/
	/*Base address=0x40004400*/
        ldr r0, = 0x40004400    @ Base Address for USART2
	/*set baudrate*/
	/* 115200 */
        ldr r1, [r0, #0x08]     @ Load Baud Register
        mov r2, #0x8		@Mantissa
	lsl r2,#0x04		@shift right 4
	orr r2, #0xb		@Add fraction
        str r2, [r0, #0x08]     @ Store value
set:
	mov r7,0x0
write:
        ldr r1, [r0, #0x0C]     @ Load Control Register 1
        orr r1, #0x2000         @ Enable Tx and UART
        orr r1, #0x08
	str r1, [r0, #0x0C]     @ Store value

	@MOV r3,#0x54		@ Move letter 'T' to r3
	ldr r4,=message		@ address of message
	ldrb r3,[r4,r7]
	str r3,[r0,#0x04]	@ Store in data register
wait:
	ldr r4,[r0, #0x00]	@Load status register
	and r4,#0x40		@ bit mask
	cmp r4,#0x40
	bne wait
	MOV r3, #0xA
	str r3,[r0,#0x04]       @ Store in data register
wait2:
	ldr r4,[r0, #0x00]      @Load status register
        and r4,#0x40            @ bit mask
        cmp r4,#0x40
        bne wait2
	/* End Transmission */
	ldr r1,[r0,#0x0C]	@load control register
	bfc r1,#13,#1
	str r1,[r0,#0x0C]	@store

	add r7,#0x01		@increment counter for value
	cmp r7,#0xF
	beq set
	mov r5, #0x100000
delay:
	subs r5,1 		@ Substract 1 from delay
	bne delay 		@ When zero reset
	b write			@ start loop again
deadloop:
	b	deadloop
message:
	.asciz "Hello, World!\n\r"
.end

