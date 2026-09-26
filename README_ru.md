<div align=center>

# 🌫️ Minit 🌫️
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Language: C & ASM](https://img.shields.io/badge/Language-C%20%26%20ASM-orange.svg)]()
[![Architecture: x86_64](https://img.shields.io/badge/Arch-x86__64-green.svg)]()<br>

---

[![EN](https://img.shields.io/badge/🇬🇧_EN-gray?style=flat-square)](README.md) [![RU](https://img.shields.io/badge/🇷🇺_ru-gray?style=flat-square)](README_ru.md)

---

**Minit** - это простой загрузчик для х86_64 процессоров, сделанный с нуля, который работает на реальном железе (проверено на Acer Aspire E5-532)

Этот проект сделан с целью изучения работы компьютера. Каждое исправление и улучшение приветствуется, так что _не стесняйтесь контрибьютить_.
Здесь используется MIT лицензия, поэтому можете делать с кодом все что угодно!
</div>

---
<br>

## 🤔 Что он может?
- Загружаться с BIOS через ассемблерную первую стадию
- Активировать A20 линию через Fast A20 Gate
- Настраивать GDT с сегментами для 32-bit и 64-bit кода/данных
- Читать сектора с диска через BIOS int 0x13
- Переходить в Protected Mode и Long Mode
- Настраивать paging с 2MB страницами (покрывающими только первый 1GB физической памяти)
- Парсить ELF-заголовки и динамически загружать ядро в память
- Передавать управление ядру через jump на точку входа
- и другое...

## Далее...
- Real-mode thunk для динамического поиска ядра на диске
- Своя ОЧЕНЬ простая ext-like ФС
- Передача загрузочной инфы ядру

### Все новые фичи и изменения в первую очередь буду постить в своем [Телеграм канале](https://t.me/DevyzLog)

## 🏁 Начало работы

### Зависимости:
- QEMU
- Clang
- NASM
- Make

---

Я **настоятельно** рекомендую использовать его в связке с [Mist](https://github.com/MistWorks/Mist), но ты можешь и попробовать подстроить свое ядро под него (В будущем тут будут конфиги и упрощенная совместимость с кастомными ядрами) Можно начать 2 путями:

1. Скомпилировать самому:
<details>

<br>

  - Скопировать репозиторий:

  ```
  git clone https://github.com/MistWorks/Minit
  ```
  - Скомпилировать (Clang):

  ```
  cd Minit
  make
  ```
  - Запустить в QEMU:

  ```
  make run
  ```

</details>

<br>

2. Использовать Minit.img из Releases (не будет нормально работать без ядра):
<details>

<br>

  - Cкопировать Minit.img:
  ```
  wget https://github.com/MistWorks/Minit/releases/download/v0.3/Minit.img
  ```
  - Запустить в QEMU:
  ```
  qemu-system-x86_64 -drive format=raw,file=Minit.img -no-reboot
  ```

</details>

## 😰 Issues
***Minit - молодой хобби проект***

В нем могут быть баги и ошибки

Если вы нашли такие, можете обратиться в [issues](https://github.com/MistWorks/Minit/issues)

Также можете делать PR с вашим кодом. Удачи!
