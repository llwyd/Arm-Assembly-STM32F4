func.bin: func.elf
	arm-none-eabi-objcopy -Obinary func.elf func.bin
func.elf: func.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o func.elf func.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o func.elf func.o
func.o: func.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g func.s -o func.o
clean:
	rm func.o func.bin func.elf 
program:
	#st-flash write func.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program func.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S func.o > func.list

