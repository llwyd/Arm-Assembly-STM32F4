write.bin: write.elf
	arm-none-eabi-objcopy -Obinary write.elf write.bin
write.elf: write.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o write.elf write.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o write.elf write.o
write.o: write.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g write.s -o write.o
clean:
	rm write.o write.bin write.elf 
program:
	#st-flash write write.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program write.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S write.o > write.list

