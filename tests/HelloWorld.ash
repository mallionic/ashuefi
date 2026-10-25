
import "../efi.ash";

@Entry
@msabi
pub func efi_main(
    EFI_HANDLE ImageHandle,
    EFI_SYSTEM_TABLE* SystemTable
): EFI_STATUS {
    InitializeLib(ImageHandle, SystemTable);

    SystemTable->ConOut->ClearScreen(
        SystemTable->ConOut
    );

    UINT64 FileSystem = 0;
    UINT64 Network = 0;
    UINT64 Graphics = 0;

    EFI_STATUS FsStatus = gBS->LocateProtocol(
        gEfiSimpleFileSystemProtocolGuid,
        NULL,
        &FileSystem
    );

    EFI_STATUS NetStatus = gBS->LocateProtocol(
        gEfiSimpleNetworkProtocolGuid,
        NULL,
        &Network
    );

    EFI_STATUS GfxStatus = gBS->LocateProtocol(
        gEfiGraphicsOutputProtocolGuid,
        NULL,
        &Graphics
    );

    SystemTable->ConOut->SetAttribute(
        SystemTable->ConOut, 0x0E
    );
    conout(L"=== UEFI SERVICE DIAGNOSTICS ===\r\n\r\n");

    SystemTable->ConOut->SetAttribute(
        SystemTable->ConOut, 0x07
    );

    if (EFI_ERROR(FsStatus) == FALSE) {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0A
        );
        conout(L"[OK] Filesystem disponible\r\n");
    } else {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0C
        );
        conout(L"[NO] Filesystem no encontrado\r\n");
    }

    if (EFI_ERROR(NetStatus) == FALSE) {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0A
        );
        conout(L"[OK] Network protocol disponible\r\n");
    } else {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0C
        );
        conout(L"[NO] Network protocol no encontrado\r\n");
    }

    if (EFI_ERROR(GfxStatus) == FALSE) {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0A
        );
        conout(L"[OK] Graphics Output Protocol disponible\r\n");
    } else {
        SystemTable->ConOut->SetAttribute(
            SystemTable->ConOut, 0x0C
        );
        conout(L"[NO] Graphics Output Protocol no encontrado\r\n");
    }

    SystemTable->ConOut->SetAttribute(
        SystemTable->ConOut, 0x07
    );

    conout(L"\r\nDiagnostico terminado.\r\n");

    loop {
        asm {
            nop
        }
    }

    return EFI_SUCCESS;
}
