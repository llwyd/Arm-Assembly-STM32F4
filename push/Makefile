push.bin: push.elf
	arm-none-eabi-objcopy -Obinary push.elf push.bin
push.elf: push.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o push.elf push.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o push.elf push.o
push.o: push.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb push.s -o push.o
clean:
	rm push.o push.bin push.elf 
program:
	st-flash write push.bin 0x8000000