
all: test build

FACTORIO_DIR := ~/.steam/steam/steamapps/common/Factorio

export NAME := $(shell jq -r '.name' info.json)
export VERSION := $(shell jq -r '.version' info.json)
export NAME_VERSION := $(NAME)_$(VERSION)
export ZIPFILE := $(NAME_VERSION).zip
export MODS_DIR := $(HOME)/.factorio/mods
export MOD_LIST := mod-list.json
export OUTPUT_DIR := ./target

.PHONY: all build clean rawdata grab-base load textplates
.PHONY: install uninstall clean-reinstall nuke 

build: 
	./build-scripts/stage.sh
	./build-scripts/build.sh
	./build-scripts/unstage.sh

unzip: build
	rm -rf $(OUTPUT_DIR)/$(NAME_VERSION)
	(cd $(OUTPUT_DIR) && unzip $(ZIPFILE))

clean:
	cargo clean
	rm -rf ./target/*
	mkdir ./target
	rm -f ./test/rawdata.so

install: build ./build-scripts/install.sh load
	./build-scripts/install.sh

uninstall: ./build-scripts/uninstall.sh
	./build-scripts/uninstall.sh

clean-reinstall: clean nuke install

nuke: uninstall
	rm -f ~/.factorio/mods/mod-settings.dat

rawdata: 
	./build-scripts/rawdata.sh 

load: 
	lua debug/load.lua

textplates:
	./build-scripts/textplates.sh

grab-base:
	./build-scripts/grab-base.sh
