blink.bin: blink.elf
	arm-none-eabi-objcopy -Obinary blink.elf blink.bin
blink.elf: blink.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o blink.elf blink.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o blink.elf blink.o
blink.o: blink.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb blink.s -o blink.o
clean:
	rm blink.o blink.bin blink.elf 
program:
	st-flash write blink.bin 0x8000000