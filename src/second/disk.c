#include "disk.h"

void thunk_disk(u8 drive, u16 count, u32 lba, void *buf) {
    u32 a = (u32)buf;

    volatile dap *d = (volatile dap *)0x5000;

    d->size = 16;
    d->res = 0;
    d->count = count;
    d->offset = (u16)(a & 0xFFFF);
    d->segment = (u16)(a >> 4);
    d->lba = lba;

    *(volatile u8 *)0x5010 = drive;

    thunk_call(DISK_READ);
}
