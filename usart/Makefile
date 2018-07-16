usart.bin: usart.elf
	arm-none-eabi-objcopy -Obinary usart.elf usart.bin
usart.elf: usart.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o usart.elf usart.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o usart.elf usart.o
usart.o: usart.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g usart.s -o usart.o
clean:
	rm usart.o usart.bin usart.elf 
program:
	#st-flash write usart.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program usart.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S usart.o > usart.list

