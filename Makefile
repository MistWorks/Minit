ASM      := nasm
CC       := clang        # <--- МЕНЯЕМ ЗДЕСЬ
LD       := ld
OBJCOPY  := objcopy
QEMU     := qemu-system-x86_64

BUILD_DIR := build

# Добавляем --target=x86_64-elf для гарантии freestanding
CFLAGS := --target=x86_64-elf -ffreestanding -nostdlib -O2 -mno-red-zone -mno-sse -mno-sse2 \
          -fno-stack-protector -fno-pie -fno-builtin -Wall -Wextra \
          -Iboot/Stages/second

.PHONY: all run debug clean

all: $(BUILD_DIR)/System.img

SECOND_SRCS := $(wildcard boot/Stages/second/*.c)
SECOND_OBJS := $(SECOND_SRCS:boot/Stages/second/%.c=$(BUILD_DIR)/second/%.o)

$(BUILD_DIR)/second/%.o: boot/Stages/second/%.c boot/Stages/second/types.h
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/second.elf: $(SECOND_OBJS) boot/Stages/second/linker.ld
	$(LD) -m elf_x86_64 -T boot/Stages/second/linker.ld -nostdlib -o $@ $(SECOND_OBJS)

$(BUILD_DIR)/second.bin: $(BUILD_DIR)/second.elf
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/first.bin: boot/Stages/first.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/Minit.bin: $(BUILD_DIR)/first.bin $(BUILD_DIR)/second.bin
	cat $^ > $@

$(BUILD_DIR)/stub.bin: boot/Kernstub.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/System.img: $(BUILD_DIR)/Minit.bin $(BUILD_DIR)/stub.bin
	dd if=/dev/zero of=$@ bs=512 count=128
	dd if=$(BUILD_DIR)/Minit.bin of=$@ bs=512 conv=notrunc
	#dd if=$(BUILD_DIR)/stub.bin of=$@ bs=512 seek=5 conv=notrunc

run: $(BUILD_DIR)/System.img
	$(QEMU) -drive format=raw,file=$< -m 256M -serial stdio -no-reboot

debug: $(BUILD_DIR)/System.img
	$(QEMU) -drive format=raw,file=$< -m 256M -serial stdio -no-reboot -s -S

clean:
	rm -rf $(BUILD_DIR)
