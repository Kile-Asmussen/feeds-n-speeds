
all: test build

PRELUDE := ./build-scripts/prelude.sh

LUA_FILES := $(filter-out debug*.lua test*.lua, $(wildcard *.lua))
LOCALE_FILES := $(wildcard locale/**/*.cfg)
MIGRATION_FILES := $(wildcard scenarios/**/*.lua, scenarios/**/*.json)
METADATA_FILES := $(wildcard thumbnail.png info.json changelog.txt)

ALL_FILES := $(LUA_FILES) $(LOCALE_FILES) $(MIGRATION_FILES) $(METADATA_FILES)

.PHONY: all build clean install uninstall test download debug

debug:
	@echo ALL_FILES := $(ALL_FILES)

build: $(ALL_FILES)
	@$(PRELUDE) ./build-scripts/build.sh $(ALL_FILES)

clean:
	rm -rf ./output/* ./data/raw.lua

install: build
	@$(PRELUDE) ./build-scripts/install.sh

uninstall:
	@$(PRELUDE) ./build-scripts/uninstall.sh

test: download
	@$(PRELUDE) ./build-scripts/test.sh

download: ./data/raw.lua
./data/raw.lua:
	@$(PRELUDE) ./build-scripts/download.sh