
all: test build

ALL_FILES := $(shell find . -name '.git' -prune -o -type f -print)
CHECK_ATTR := $(shell git check-attr --cached --source=HEAD export-ignore -- $(ALL_FILES) | rg unspecified)
FILTER_OUT_JUNK := $(filter-out export-ignore: unspecified, $(CHECK_ATTR))
PATSUBST_COLONS := $(patsubst %:,%,$(FILTER_OUT_JUNK))
IGNORE_FILES := $(shell git check-ignore -- $(ALL_FILES))
FILES := $(filter-out $(IGNORE_FILES), $(PATSUBST_COLONS))

FACTORIO_DIR := ~/.steam/steam/steamapps/common/Factorio

export NAME := $(shell jq -r '.name' info.json)
export VERSION := $(shell jq -r '.version' info.json)
export NAME_VERSION := $(NAME)_$(VERSION)
export ZIPFILE := $(NAME_VERSION).zip
export MODS_DIR := $(HOME)/.factorio/mods
export MOD_LIST := mod-list.json
export OUTPUT_DIR := ./target

.PHONY: all build clean rawdata lualib load
.PHONY: install uninstall clean-reinstall nuke

build: # $(OUTPUT_DIR)/$(ZIPFILE)
	./build-scripts/build.sh

# $(OUTPUT_DIR)/$(ZIPFILE): $(FILES) ./build-scripts/build.sh
# ./build-scripts/build.sh

unzip: build
	rm -rf $(OUTPUT_DIR)/$(NAME_VERSION)
	(cd $(OUTPUT_DIR) && unzip $(ZIPFILE))

clean:
	rm -rf ./target/*
	rm -f ./test/rawdata.so

install: build ./build-scripts/install.sh load
	@./build-scripts/install.sh

uninstall: ./build-scripts/uninstall.sh
	@./build-scripts/uninstall.sh

clean-reinstall: clean nuke install

nuke: uninstall
	rm -f ~/.factorio/mods/mod-settings.dat

rawdata: 
	@./build-scripts/rawdata.sh 

load: 
	@lua debug/load.lua


lualib:
	@cp -r $(FACTORIO_DIR)/data/core/lualib ./lualib


