#/usr/bin/env bash

cargo rustc --release -- -C link-arg=-undefined -C link-arg=dynamic_lookup
ln -s ./target/release/data-raw.dylib ./test/data-raw.so