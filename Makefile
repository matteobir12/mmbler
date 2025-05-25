EFIINC := /usr/include/efi
EFILIB := /usr/lib
CC := gcc
LD := ld

CFLAGS := -I$(EFIINC) -I$(EFIINC)/x86_64 -Wall -fpic -fshort-wchar -mno-red-zone -c
LDFLAGS := -T $(EFILIB)/elf_x86_64_efi.lds -shared -Bsymbolic -znocombreloc -L$(EFILIB) -lefi -lgnuefi

SRC := $(wildcard bootloader/*.c)
OBJ := $(patsubst bootloader/%.c,build/%.o,$(SRC))

all: build/BOOTX64.EFI

build/%.o: bootloader/%.c
	mkdir -p build
	$(CC) $(CFLAGS) $< -o $@

build/BOOTX64.EFI: $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $@
	mkdir -p esp/EFI/BOOT
	cp $@ esp/EFI/BOOT/BOOTX64.EFI

run:
	qemu-system-x86_64 \
	  -bios /usr/share/OVMF/OVMF_CODE.fd \
	  -drive file=fat:rw:esp,format=raw

clean:
	rm -rf build esp/EFI/BOOT
