<div align=center>

# 🌫️ Minit 🌫️
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Language: C & ASM](https://img.shields.io/badge/Language-C%20%26%20ASM-orange.svg)]()
[![Architecture: x86_64](https://img.shields.io/badge/Arch-x86__64-green.svg)]()<br>

---

[![EN](https://img.shields.io/badge/🇬🇧_EN-gray?style=flat-square)](README.md) [![RU](https://img.shields.io/badge/🇷🇺_ru-gray?style=flat-square)](README_ru.md)

---

**Minit** is a simple x86 bootloader made from scratch

This training project made for learning how the PC works. Every bug fix and improvment are welcome, so _don't be shy to contribute_.
It uses MIT license so you can do anything with this code!
</div>

---
<br>

## 🤔 What can it do?
- Boot from BIOS with custom assembly bootloader
- Enable A20 line via Fast A20 Gate for accessing memory above 1MB
- Set up GDT with 32-bit and 64-bit code/data segments
- Read disk sectors through BIOS int 0x13 Extended Read (LBA mode)
- Transition to Protected Mode (32-bit) by setting PE bit in CR0
- Configure paging with 2MB pages covering first 1GB of physical memory
- Enable Long Mode (64-bit) via PAE and MSR EFER activation
- Load kernel to 1MB physical address with hardcoded copy
- Jump to kernel and hand off control
- etc...

## 🏁 Get started

### Requirements:
- QEMU
- Clang
- NASM
- Make

---

You can start with 2 ways:

1. Compile by yourself:
<details>

<br>

  - Clone Mist repo:

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

2. Use already compiled Mist.img from releases:
<details>

<br>

  - Copy Mist.img:
  ```
  wget https://github.com/MistWorks/Minit/releases/download/v0.1/Minit.img
  ```
  - Run with QEMU:
  ```
  qemu-system-x86_64 -drive format=raw,file=Minit.img -no-reboot
  ```

</details>

## 😰 Issues
***Minit - young project made by 16 y.o. student***

It may contain bugs and errors

If you have one of these, you can visit the [issues](https://github.com/MistWorks/Minit/issues)

Also you can do pull requests with your code. You're welcome!
