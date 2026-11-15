ASM      := nasm
CC       := clang
LD       := ld.lld
OBJCOPY  := objcopy
QEMU     := qemu-system-x86_64

BUILD_DIR := build

MISTIC ?= ../Mistic

CFLAGS := --target=i386-elf -m32 -ffreestanding -nostdlib -O2 -mno-red-zone -mno-sse -mno-sse2 \
          -fno-stack-protector -fno-pie -fno-builtin -Wall -Wextra \
          -Isrc/second -I$(MISTIC)/include -g -I.

.PHONY: all run clean

all: $(BUILD_DIR)/Minit.img

SECOND_SRCS := $(wildcard src/second/*.c)
SECOND_OBJS := $(patsubst src/second/%.c,$(BUILD_DIR)/second/%.o,$(SECOND_SRCS))

SECOND_ASM := $(wildcard src/second/*.asm)
SECOND_ASM_OBJS := $(patsubst src/second/%.asm,$(BUILD_DIR)/second/%.o,$(SECOND_ASM))

$(MISTIC)/build/mistic32.a: FORCE
	$(MAKE) -C $(MISTIC) bits=32

$(BUILD_DIR)/second/%.o: src/second/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/second/%.o: src/second/%.asm
	@mkdir -p $(dir $@)
	$(ASM) -f elf32 $< -o $@

$(BUILD_DIR)/second.elf: $(SECOND_OBJS) $(SECOND_ASM_OBJS) src/second/linker.ld $(MISTIC)/build/mistic32.a
	$(LD) -m elf_i386 -T src/second/linker.ld -nostdlib -o $@ $(SECOND_OBJS) $(SECOND_ASM_OBJS) $(MISTIC)/build/mistic32.a

$(BUILD_DIR)/second.bin: $(BUILD_DIR)/second.elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/first.bin: src/first.asm
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
	$(MAKE) -C $(MISTIC) clean

FORCE:
.PHONY: all clean run FORCE
