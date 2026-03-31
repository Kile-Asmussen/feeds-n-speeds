
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

.PHONY: all build clean install uninstall clean-reinstall test download debug nuke delete-raw redownload

build: $(OUTPUT_DIR)/$(ZIPFILE)
$(OUTPUT_DIR)/$(ZIPFILE): $(FILES)
	./build-scripts/build.sh

unzip: build
	rm -rf $(OUTPUT_DIR)/$(NAME_VERSION)
	(cd $(OUTPUT_DIR) && unzip $(ZIPFILE))

clean:
	rm -rf ./output/*

install: build
	@./build-scripts/install.sh

uninstall:
	@./build-scripts/uninstall.sh

full-reinstall: clean nuke install

nuke: uninstall
	rm -f ~/.factorio/mods/mod-settings.dat

test: download
	@./build-scripts/test.sh

delete-raw:
	rm -f ./data/raw.lua

redownload: delete-raw download

download: ./data/raw.lua
./data/raw.lua:
	@./build-scripts/download.sh