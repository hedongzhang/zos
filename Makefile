# Automatically generate lists of sources using wildcards .
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# TODO : Make sources dep on all header files .

# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o}

# Defaul build target
all: zos.img

# image
zos.img: boot/boot.bin kernel/kernel.bin
	cat $^ > $@

# kernel
kernel/kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -melf_i386 -Ttext 0x9000 --oformat binary -o $@ $^

%.o: %.asm
	nasm -f elf -o $@ $<
%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -o $@ -c $<

# bootloader
%.bin: %.asm
	nasm -f bin -I './boot/' -o $@ $<

clean:
	rm -rf *.img *.bin *.o
	rm -rf boot/*.bin kernel/*.bin kernel/*.o drivers/*.o
