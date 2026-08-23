ASM      := nasm
QEMU     := qemu-system-x86_64
QEMU_FLAGS := -drive format=raw,file=$< -m 256M -serial stdio -no-reboot

BUILD_DIR := build

.PHONY: all run debug clean

all: $(BUILD_DIR)/System.img

$(BUILD_DIR)/Minit.bin: boot/Minit.asm boot/Stages/real.asm boot/Stages/protected.asm boot/Stages/long.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin boot/Minit.asm -o $@

$(BUILD_DIR)/stub.bin: boot/Kernstub.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/System.img: $(BUILD_DIR)/Minit.bin $(BUILD_DIR)/stub.bin
	cat $^ > $@

run: $(BUILD_DIR)/System.img
	$(QEMU) -drive format=raw,file=$< -m 256M -serial stdio

debug: $(BUILD_DIR)/System.img
	$(QEMU) -drive format=raw,file=$< -m 256M -serial stdio -no-reboot -s -S

clean:
	rm -rf $(BUILD_DIR)
