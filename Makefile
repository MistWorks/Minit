# === Инструменты ===
ASM = nasm
QEMU = qemu-system-x86_64
DD = dd
CAT = cat

# === Флаги ===
ASM_FLAGS = -f bin
QEMU_FLAGS = -drive format=raw,file=Mist.img -m 256M -serial stdio -no-reboot

# === Цели ===
.PHONY: all run debug clean

all: Mist.img

# Сборка загрузчика
BootLoader.bin: BootLoader.asm
	$(ASM) $(ASM_FLAGS) -o $@ $< -g

# Создание образа диска (загрузчик + ядро)
Mist.img: BootLoader.bin
	$(CAT) $< > $@
	# Если есть Kernel.bin — добавляем его после загрузчика
	@if [ -f Kernel.bin ]; then $(CAT) Kernel.bin >> $@; fi

# Запуск в QEMU
run: Mist.img
	$(QEMU) $(QEMU_FLAGS)

# Запуск с GDB (порт 1234)
debug: Mist.img
	$(QEMU) $(QEMU_FLAGS) -s -S

# Очистка
clean:
	rm -f BootLoader.bin Mist.img
