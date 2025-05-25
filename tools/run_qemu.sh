#!/bin/bash

cd "$(dirname "$0")"

ARCH=${1:-x86_64}
ESP_DIR=../esp
CODE_FD=/usr/share/OVMF/OVMF_CODE_4M.fd
VARS_FD=./OVMF_VARS.fd

if [ "$ARCH" = "x86_64" ]; then
    QEMU=qemu-system-x86_64
    BIOS=/usr/share/OVMF/OVMF_CODE_4M.fd
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if [ ! -f "$VARS_FD" ]; then
    cp /usr/share/OVMF/OVMF_VARS_4M.fd "$VARS_FD"
fi

qemu-system-x86_64 \
  -drive if=pflash,format=raw,readonly=on,file="$CODE_FD" \
  -drive if=pflash,format=raw,file="$VARS_FD" \
  -drive file=fat:rw:$ESP_DIR,format=raw \
  -net none

