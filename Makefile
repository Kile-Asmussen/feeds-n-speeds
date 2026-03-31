
all: test build

PRELUDE := ./build-scripts/prelude.sh

ALL_LUA_FILES := $(wildcard *.lua **/*.lua)
EXCLUDED_LUA_FILES := $(wildcard data/raw.lua debug*.lua debug/* test*.lua test/*)
LUA_FILES := $(filter-out $(EXCLUDED_LUA_FILES), $(ALL_LUA_FILES))
LOCALE_FILES := $(wildcard locale/**/*.cfg)
MIGRATION_FILES := $(wildcard scenarios/**/*.lua, scenarios/**/*.json)
METADATA_FILES := $(wildcard thumbnail.png info.json changelog.txt)

MOD_FILES := $(LUA_FILES) $(LOCALE_FILES) $(MIGRATION_FILES) $(METADATA_FILES)

.PHONY: all build clean install uninstall test download debug

debug:
	@echo LOCALE_FILES := $(LOCALE_FILES)
	@echo MIGRATION_FILES := $(MIGRATION_FILES)
	@echo METADATA_FILES := $(METADATA_FILES)
	@echo LUA_FILES := $(LUA_FILES)

build: $(MOD_FILES)
	@$(PRELUDE) ./build-scripts/build.sh

clean:
	rm -rf ./output/* ./data/raw.lua

install: build
	@$(PRELUDE) ./build-scripts/install.sh

uninstall:
	@$(PRELUDE) ./build-scripts/uninstall.sh

nuke: uninstall
	rm -f ~/.factorio/mods/mod-settings.dat

test: download
	@$(PRELUDE) ./build-scripts/test.sh

download: ./data/raw.lua
./data/raw.lua:
	@$(PRELUDE) ./build-scripts/download.sh