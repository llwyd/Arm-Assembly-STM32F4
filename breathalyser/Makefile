breath.bin: breath.elf
	arm-none-eabi-objcopy -Obinary breath.elf breath.bin
breath.elf: breath.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o breath.elf breath.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o breath.elf breath.o
breath.o: breath.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g breath.s -o breath.o
clean:
	rm breath.o breath.bin breath.elf 
program:
	#st-flash breath breath.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program breath.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S breath.o > breath.list

