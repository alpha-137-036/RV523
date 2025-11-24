GCC_HOME=~/riscv32-unknown-elf.gcc-13.2.0

mkdir -p build/

OPT=-Oz

$GCC_HOME/bin/riscv32-unknown-elf-gcc -Wall -g $OPT -march=rv32i -c crt0.s -o build/crt0.o
$GCC_HOME/bin/riscv32-unknown-elf-gcc -Wall -g $OPT -march=rv32i -c test_fibonacci.c -o build/test_fibonacci.o

$GCC_HOME/bin/riscv32-unknown-elf-gcc -Wall -g $OPT -march=rv32i -nostdlib -T bare_metal.ld build/crt0.o build/test_fibonacci.o -o build/test_fibonacci.elf

$GCC_HOME/bin/riscv32-unknown-elf-objdump -d build/test_fibonacci.elf > build/test_fibonacci.elf.txt

$GCC_HOME/bin/riscv32-unknown-elf-objcopy -O binary --only-section=.text --reverse-bytes=4 build/test_fibonacci.elf build/test_fibonacci.bin
xxd -p -c 4 build/test_fibonacci.bin > build/test_fibonacci.hex
