#!/usr/bin/env bash

cargo build --release && cp -f ./target/release/librawdata.so ./rawdata.so