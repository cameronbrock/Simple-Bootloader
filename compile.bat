
nasm load.asm -f bin -o load1.bin
nasm load2.asm -f bin -o load2.bin

copy /b load1.bin+load2.bin boot.iso
