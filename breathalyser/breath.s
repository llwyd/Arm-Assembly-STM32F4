@
@	breath.s
@	T.L. 2018
@	Read alcohol gas from MQ3 sensor and writes to i2c expander (PCF8574A)
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
	/* Enable ADC1 */
        ldr r1, [r0, #0x44]     @ Load with Offset
        orr r1, #0x100          @ Enable ADC1
        str r1, [r0, #0x44]     @ Store value
	/*Set pinmodes for GPIO A*/
	ldr r0, = 0x40020000 	@ Load Pin Mode Select Register GPIO A
	ldr r1, [r0, #0x00]  	@ Load withOffset
	bfc r1, #0,  #2         @ Clear bits for PA0 (ADC1_0)
	bfc r1, #10, #2  	@ Clear bits for PA5
	orr r1, #0x03           @ Enable analog mode (PA0)
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
	/*Configure CR2 to generate correct timings*/
	/*Default APB clock is 16MHz*/
        ldr r0, = 0x40005400    @ Load Base Address for I2C1
        ldr r1, [r0, #0x04]     @ Load CR2
        bfc r1, #0, #6         	@ Clear bits 0->5
        orr r1, #0x400          @ Set bits for Output
        str r1, [r0, #0x04]     @ Store value
	/*Clock control register*/
	ldr r1, [r0, #0x1C]     @ Load clock control register
	orr r1, #0x50		@ set CCR, standard mode is default
	str r1, [r0, #0x1C]	@ Store value
	/*Configure rise time register*/
	ldr r1, [r0, #0x20]	@ Load TRISE register
	bfc r1, #0, #6		@ Clear bits 0->5
	orr r1, #0x11		@ Set rise time
	str r1, [r0, #0x20]	@ Store value
	/* Enable the peripheral */
        ldr r1, [r0, #0x00]     @ Load CR1 register
        orr r1, #0x01           @ Enable the peripheral
        @orr r1, #0x400		@ Enable Acknowledgements
	str r1, [r0, #0x00]     @ Store value
        /* Configure ADC */
        /* ADC base address = 0x40012000 */
        ldr r0, = 0x40012000    @ Base Address for ADC
        /* Set resolution */
        ldr r1, [r0, #0x04]     @ Load Control Register 1
        orr r1, #0x0000000      @ 12 bit resolution
        str r1, [r0, #0x04]     @ Store value
        /*Turn on ADC*/
        ldr r1, [r0, #0x08]     @ Load Control Register 2
        orr r1, #0x3            @ Continuous conversion and turn on ADC
        str r1, [r0, #0x08]     @ Store value
        /* Begin conversion */
        ldr r1, [r0, #0x08]     @ Load Control Register 2
        orr r1, #0x40000000     @ start conversion
        str r1, [r0, #0x08]     @ Store value
	/* Reload i2c1 base address*/
	ldr r0, = 0x40005400    @ Load Base Address for I2C1
	ldr r2, = 0x40012000    @ Base Address for ADC
	mov r6, #0x00
loop:
	/*Read ADC*/
adc:
	ldr r5, [r2, #0x00]	@Load status register
	and r5, #0x02
	cmp r5, #0x02
	bne adc
	ldr r6, [r2, #0x4C]     @ Load Data register
	lsr r6,r6,#0x4
	mov r5,#0x8
	mov r1,r6
adjust:
	orr r6,r6,r1
	lsr r1,#1
	subs r5,1
	bne adjust
	/* Send Start Condition */
	ldr r1, [r0, #0x00]	@ Reload CR1 register
	orr r1, #0x100		@ Set start condition
	str r1, [r0, #0x00]	@ store register
	/* check status register to ensure SB is set */
scond:
	ldr r4, [r0, #0x14]     @ Reload SR1 register
	cmp r4,#0x01		@ Wait for start condition
	bne scond
	/* After start condition is recognised send address*/
	/* Address for pcf8574a write = 0x70 */
	mov r5, #0x70		@ Address of expander
	str r5, [r0, #0x10]	@ write into data register
	/* Check whether address has been sent successfully */
add:
        ldr r4, [r0, #0x14]     @ Reload SR1 register
        and r4,#0x02		@ bit mask
	cmp r4,#0x02            @ Wait for start condition
        bne add
	ldr r5, [r0, #0x18]	@ Load SR2
	/* wait while data buffer is filled */
write:
	ldr r4, [r0, #0x14]	@ Reload status register
	and r4, #0x80		@ bitmask for write bit
	cmp r4, #0x80		@ compare
	bne write		@ branch if not equal
	mov r5, r6		@ Load register to write
	str r5, [r0,#0x10]	@ Write value to device
	/* Send stop command*/
	ldr r1, [r0, #0x00]     @ Load CR1 register
        orr r1,#0x200		@ Set stop flag
	str r1, [r0, #0x00]     @ Store value
	/*Transfer Complete!*/
	@add r6,#1		@increment leds
	@cmp r6,#0xff
	@beq val
	/* LED blink to make sure things are running */
	@ldr r0, = 0x40020000    @ Load GPIO A base register for LED
	@eors r1,r2		@ XOR with latest value of r2
	@str r1, [r0, #0x14] 	@ Store with offset
	mov r3, #0x50000 	@ Arbitrary Delay
delay:
	subs r3,1 		@ Substract 1 from delay
	bne delay 		@ When zero reset
	b loop			@ start loop again
deadloop:
	b	deadloop
.end
