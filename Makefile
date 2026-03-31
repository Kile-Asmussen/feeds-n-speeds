
all: test build

ALL_FILES := $(shell find . -name '.git' -prune -o -type f -print)
CHECK_ATTR := $(shell git check-attr --cached --source=HEAD export-ignore -- $(ALL_FILES) | rg unspecified)
FILTER_OUT_JUNK := $(filter-out export-ignore: unspecified, $(CHECK_ATTR))
PATSUBST_COLONS := $(patsubst %:,%,$(FILTER_OUT_JUNK))
IGNORE_FILES := $(shell git check-ignore -- $(ALL_FILES))
FILES := $(filter-out $(IGNORE_FILES), $(PATSUBST_COLONS))

export NAME := $(shell jq -r '.name' info.json)
export VERSION := $(shell jq -r '.version' info.json)
export NAME_VERSION := $(NAME)_$(VERSION)
export ZIPFILE := $(NAME_VERSION).zip
export MODS_DIR := $(HOME)/.factorio/mods
export MOD_LIST := mod-list.json
export OUTPUT_DIR := ./output

.PHONY: all build clean install uninstall test download debug

build: $(OUTPUT_DIR)/$(ZIPFILE)
$(OUTPUT_DIR)/$(ZIPFILE): $(FILES)
	./build-scripts/build.sh

clean:
	rm -rf ./output/* ./data/raw.lua

install: build
	@./build-scripts/install.sh

uninstall:
	@./build-scripts/uninstall.sh

nuke: uninstall
	rm -f ~/.factorio/mods/mod-settings.dat

test: download
	@./build-scripts/test.sh

download: ./data/raw.lua
./data/raw.lua:
	@./build-scripts/download.sh