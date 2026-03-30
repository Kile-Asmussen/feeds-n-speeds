
prelude = ./build-scripts/prelude.sh

build:
	@$(prelude) ./build-scripts/build.sh

install: build
	@$(prelude) ./build-scripts/install.sh

test:
	@$(prelude) ./build-scripts/test.sh