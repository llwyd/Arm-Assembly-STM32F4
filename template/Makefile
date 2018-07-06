template.bin: template.elf
	arm-none-eabi-objcopy -Obinary template.elf template.bin
template.elf: template.o
	#arm-none-eabi-ld -T stm32.ld -nostartfiles -o template.elf template.o
	arm-none-eabi-ld -Ttext 0x0 -Tbss 0x20000000 -nostartfiles -o template.elf template.o
template.o: template.s
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g template.s -o template.o
clean:
	rm template.o template.bin template.elf 
program:
	#st-flash write template.bin 0x8000000
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program template.bin exit 0x8000000 verify reset"
debug:
	#Don't forget to telnet localhost 4444 :)
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg
dump:
	arm-none-eabi-objdump -S template.o > template.list

