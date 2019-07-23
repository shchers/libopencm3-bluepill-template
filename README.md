# Blue Pill (STM32F103C8T6) template for libopencm3

This is template of firmware for STM32F103 based "Blue Pill" board.
![Image of Blue Pill](https://wiki.stm32duino.com/images/d/db/STM32_Blue_Pill_perspective.jpg)

## Preparing
  * Update APT cache
```
sudo apt update
```

  * Install ARM GCC compiler and other tools
```
sudo apt install gcc-arm-none-eabi git minicom
```

  * Download Segger J-Link pack - https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack. You need to download "J-Link Software and Documentation pack for Linux, DEB installer".

  * Install J-Link pack
```
sudo dpkg -i JLink_Linux_V640_x86_64.deb
```

## Building
  * Clone project

  * Init and fetch submodules
```
git submodule update --init
```

  * Clean source code
```
make clean
```

  * Build firmware
```
make -j$(nproc)
```

  * Flash firmware to device
```
make flash
```
