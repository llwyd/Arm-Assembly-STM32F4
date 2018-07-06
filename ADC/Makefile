adc.bin: adc.elf
	arm-none-eabi-objcopy -Obinary adc.elf adc.bin
adc.elf: adc.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o adc.elf adc.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o adc.elf adc.o
adc.o: adc.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g adc.s -o adc.o
clean:
	rm adc.o adc.bin adc.elf 
program:
	#st-flash write adc.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program adc.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S adc.o > adc.list

