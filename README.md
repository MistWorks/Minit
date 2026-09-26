<div align=center>

# 🌫️ Minit 🌫️
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Language: C & ASM](https://img.shields.io/badge/Language-C%20%26%20ASM-orange.svg)]()
[![Architecture: x86_64](https://img.shields.io/badge/Arch-x86__64-green.svg)]()<br>

---

[![EN](https://img.shields.io/badge/🇬🇧_EN-gray?style=flat-square)](README.md) [![RU](https://img.shields.io/badge/🇷🇺_ru-gray?style=flat-square)](README_ru.md)

---

**Minit** is a simple x86 bootloader made from scratch, that can work on real hardware (checked on Acer Aspire E5-532)

This training project made for learning how the PC works. Every bug fix and improvement are welcome, so _don't be shy to contribute_.
It uses MIT license so you can do anything with this code!
</div>

---
<br>

## 🤔 What can it do?
- Boot from BIOS with assembly 1st stage
- Enable A20 line via Fast A20 Gate
- Set up GDT with 32-bit and 64-bit code/data segments
- Read disk through BIOS int 0x13
- Transition to Protected Mode and Long Mode
- Configure paging with 2MB pages (only first 1GB of physical memory)
- Parse ELF64 headers and dynamically load kernel to memory
- Jump to kernel and hand off control
- etc...

## In future...
- Real-mode thunk to dynamic search kernel on the disk
- Own VERY simple ext-like FS
- Pass boot info to the kernel

### All new features and changes will be posted first to my [Telegram channel](https://t.me/DevyzLog)

## 🏁 Get started

### Requirements:
- QEMU
- Clang
- NASM
- Make

---

I **highly** recommend using it with [Mist](https://github.com/MistWorks/Mist), but also you can configure your kernel to it (In future there will be config and simplified compatibility with custom kernels). You can start with 2 ways:

1. Compile by yourself:
<details>

<br>

  - Clone Minit repo:

  ```
  git clone https://github.com/MistWorks/Minit
  ```
  - Compile (Clang):

  ```
  cd Minit
  make
  ```
  - Run with QEMU:

  ```
  make run
  ```

</details>

<br>

2. Use already compiled Minit.img from releases (it won't start normally without OS):
<details>

<br>

  - Copy Minit.img:
  ```
  wget https://github.com/MistWorks/Minit/releases/download/v0.3/Minit.img
  ```
  - Run with QEMU:
  ```
  qemu-system-x86_64 -drive format=raw,file=Minit.img -no-reboot
  ```

</details>

## 😰 Issues
***Minit - young hobby project***

It may contain bugs and errors

If you have one of these, you can visit the [issues](https://github.com/MistWorks/Minit/issues)

Also you can do pull requests with your code. You're welcome!
