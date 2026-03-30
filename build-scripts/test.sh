#! /usr/bin/env bash

$PRELUDE &>/dev/null

for TEST_FILE in test*.lua; do
    echo '$>' lua $TEST_FILE
    lua $TEST_FILE
done