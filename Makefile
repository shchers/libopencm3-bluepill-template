#
#
# Copyright (C) 2019, Sergey Shcherbakov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

MODULE ?= bluepill

CC_TYPE ?= gcc

TARGET ?= stm32/f1

OPENCM3_DIR = $(PWD)/libopencm3
PROJECT = template_$(MODULE)
CFILES = \
	src/main.c

OBJS = $(CFILES:.c=.o)

CFLAGS          += -Os -ggdb3
CFLAGS          += -std=c99
CPPFLAGS        += -MD
LDFLAGS         += -static -nostartfiles
LDLIBS          += -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group

# Enable color logging
CFLAGS          += -DLOG_ENABLE_COLORS=1


DEVICE=stm32f103c8t6

all: lib
	$(MAKE) firmware

include $(OPENCM3_DIR)/mk/genlink-config.mk
include $(OPENCM3_DIR)/mk/$(CC_TYPE)-config.mk

.PHONY: lib lib-clean clean firmware all

lib:
	$(MAKE) -C $(OPENCM3_DIR) TARGETS=$(TARGET)

lib-clean:
	$(MAKE) -C $(OPENCM3_DIR) TARGETS=$(TARGET) clean

firmware: $(PROJECT).elf $(PROJECT).bin $(PROJECT).hex

flash: firmware
	@echo "\\033[1;37;42m--- Flashing $(PROJECT).bin to device ---\\033[0m"
	@echo "\
log $(PROJECT)_jlink.log \n\
si SWD\n\
speed 4000\n\
device stm32f103c8\n\
connect\n\
r\n\
h\n\
loadbin $(PROJECT).bin, 0x08000000\n\
r\n\
g\n\
qc\
" > $(PROJECT)_jlink.scr
	$(Q)JLinkExe $(PROJECT)_jlink.scr; [ "$$?" -eq 1 ]

clean: lib-clean
	$(Q)$(RM) -rf $(PROJECT).*
	$(Q)$(RM) -rf $(OBJS) $(OBJS:.o=.d)
	$(Q)$(RM) -rf generated.*.ld
	$(Q)$(RM) -rf $(PROJECT)_jlink.* JLink.log

include $(OPENCM3_DIR)/mk/genlink-rules.mk
include $(OPENCM3_DIR)/mk/$(CC_TYPE)-rules.mk
