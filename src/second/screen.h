#include "types.h"
#include "format.h"

#define vga ((volatile u16*)0xB8000)

void putchar(u8 c);
void clear(void);
void print_str(const char* s);
void print_num(usize num, u8 base);
