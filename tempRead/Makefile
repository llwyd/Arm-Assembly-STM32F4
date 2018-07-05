temp.bin: temp.elf
	arm-none-eabi-objcopy -Obinary temp.elf temp.bin
temp.elf: temp.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o temp.elf temp.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o temp.elf temp.o
temp.o: temp.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g temp.s -o temp.o
clean:
	rm temp.o temp.bin temp.elf 
program:
	#st-flash write temp.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program temp.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S temp.o > temp.list

