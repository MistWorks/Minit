ASM      := nasm
CC       := clang
LD       := ld
OBJCOPY  := objcopy
QEMU     := qemu-system-x86_64

BUILD_DIR := build

CFLAGS := --target=x86_64-elf -ffreestanding -nostdlib -O2 -mno-red-zone -mno-sse -mno-sse2 \
          -fno-stack-protector -fno-pie -fno-builtin -Wall -Wextra \
          -Iboot/second

.PHONY: all run clean

all: $(BUILD_DIR)/Minit.img

SECOND_SRCS := $(wildcard boot/second/*.c)
SECOND_OBJS := $(patsubst boot/second/%.c, $(BUILD_DIR)/second/%.o, $(SECOND_SRCS))

$(BUILD_DIR)/second/%.o: boot/second/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/second.elf: $(SECOND_OBJS) boot/second/linker.ld
	$(LD) -m elf_x86_64 -T boot/second/linker.ld -nostdlib -o $@ $(SECOND_OBJS)

$(BUILD_DIR)/second.bin: $(BUILD_DIR)/second.elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/first.bin: boot/first.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/Minit.img: $(BUILD_DIR)/first.bin $(BUILD_DIR)/second.bin
	dd if=/dev/zero of=$@ bs=512 count=128
	dd if=$(BUILD_DIR)/first.bin of=$@ bs=512 conv=notrunc
	dd if=$(BUILD_DIR)/second.bin of=$@ bs=512 seek=1 conv=notrunc

run: $(BUILD_DIR)/Minit.img
	$(QEMU) -drive format=raw,file=$< -m 256M -no-reboot

clean:
	rm -rf $(BUILD_DIR)
