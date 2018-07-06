@
@	ADC.s
@	T.L. 2018
@	Continually read values from the ADC
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
	/* Enable GPIOA */
	ldr r0, = 0x40023800	@ Base Address for RCC
	ldr r1, [r0, #0x30]	@ Load with Offset
	orr r1, #1		@ Enable Port A
	str r1, [r0, #0x30]	@ Store value
	/* Enable ADC1 */
	ldr r1, [r0, #0x44]     @ Load with Offset
        orr r1, #0x100          @ Enable ADC1
        str r1, [r0, #0x44]     @ Store value
	/* Set mode for GPIO A */
	ldr r0, = 0x40020000 	@ GPIO A Base Address
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #10, #2  	@ Clear bits for PA5 (LD2)
	bfc r1, #0,  #2		@ Clear bits for PA0 (ADC1_0)
	orr r1, #0x400  	@ Set bits for Output (PA5)
	orr r1, #0x03		@ Enable analog mode (PA0)
	str r1, [r0, #0x00] 	@ Store value
	/* Configure ADC */
	/* ADC base address = 0x40012000 */
	ldr r0, = 0x40012000    @ Base Address for ADC
	/* Set resolution */
        ldr r1, [r0, #0x04]     @ Load Control Register 1
        orr r1, #0x2000000      @ 8 bit resolution
        str r1, [r0, #0x04]     @ Store value
	/*Turn on ADC*/
	ldr r1, [r0, #0x08]     @ Load Control Register 2
        orr r1, #0x3            @ Continuous conversion and turn on ADC
        str r1, [r0, #0x08]     @ Store value
	/* Begin conversion */
        ldr r1, [r0, #0x08]     @ Load Control Register 2
        orr r1, #0x40000000     @ start conversion
        str r1, [r0, #0x08]     @ Store value
	/* Read ADC */
adc:
	ldr r1, [r0, #0x4C]     @ Load Data register
	b adc
deadloop:
	b	deadloop
.end

