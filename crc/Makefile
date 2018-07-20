crc.bin: crc.elf
	arm-none-eabi-objcopy -Obinary crc.elf crc.bin
crc.elf: crc.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o crc.elf crc.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o crc.elf crc.o
crc.o: crc.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g crc.s -o crc.o
clean:
	rm crc.o crc.bin crc.elf 
program:
	#st-flash write crc.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program crc.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S crc.o > crc.list

