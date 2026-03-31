#! /usr/bin/env bash

shopt -s nullglob extglob

if [[ ! ( $OUTPUT_DIR ) ]]; then
    echo '$OUTPUT_DIR not set' >&2 
fi

echo "TESTING"

TESTS=0
SUCCESSES=0
FAILURES=0

DUMP=$OUTPUT_DIR/test.$$.dump

for TEST_FILE in test-*.lua; do
    TESTS=$(( $TESTS + 1 ))
    echo '$>' lua $TEST_FILE
    if lua $TEST_FILE &>$DUMP; then
        SUCCESSES=$(( $FAILURES + 1 ))
    else
        echo FAILED
        cat $DUMP
        FAILURES=$(( $FAILURES + 1 ))
    fi
    echo
done

rm $DUMP

echo Ran $TESTS tests, $SUCCESSES passed, $FAILURES failed