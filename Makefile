EFIINC := /usr/include/efi
EFILIB := /usr/lib
CC := gcc
LD := ld

CFLAGS := -c -fno-stack-protector -fPIC -fshort-wchar -mno-red-zone -Wall -ffreestanding -fno-stack-check -maccumulate-outgoing-args -I$(EFIINC) -I$(EFIINC)/efi/x86_64 -I$(EFILIB)/inc -DEFI_FUNCTION_WRAPPER
LDFLAGS := $(EFILIB)/crt0-efi-x86_64.o -nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds -shared -Bsymbolic  -L /usr/lib -l:libgnuefi.a -l:libefi.a

SRC := $(wildcard bootloader/*.c)
OBJ := $(patsubst bootloader/%.c,build/%.o,$(SRC))

all: build/BOOTX64.EFI

build/%.o: bootloader/%.c
	mkdir -p build
	$(CC) $< $(CFLAGS) -o $@

build/BOOTX64.EFI: $(OBJ)
	$(LD) $^ $(LDFLAGS) -o build/main.so
	objcopy -j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 build/main.so $@
	mkdir -p esp/EFI/BOOT
	cp $@ esp/EFI/BOOT/BOOTX64.EFI

clean:
	rm -rf build esp/EFI/BOOT
