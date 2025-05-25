#include <efi/efi.h>
#include <efi/efilib.h>


EFI_STATUS efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *st)
{
    InitializeLib(image_handle, st);

    Print(L"Hello, world!\n");
    EFI_STATUS status = st->ConOut->OutputString(st->ConOut, L"Hello World\r\n");
    if (EFI_ERROR(status))
        return status;

    status = st->ConIn->Reset(st->ConIn, FALSE);
    if (EFI_ERROR(status))
        return status;

    EFI_INPUT_KEY key;
    while ((status = st->ConIn->ReadKeyStroke(st->ConIn, &key)) == EFI_NOT_READY) ;

    return status;
}
