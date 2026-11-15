#pragma once
#include "types.h"

#define DISK_READ 1
#define GET_MMAP 2

typedef struct {
    u8  size;
    u8  res;
    u16 count;
    u16 offset;
    u16 segment;
    u64 lba;
} __attribute__((packed)) dap;

extern void thunk_call(u8 service);

void thunk_disk(u8 drive, u16 count, u32 lba, void *buf);
