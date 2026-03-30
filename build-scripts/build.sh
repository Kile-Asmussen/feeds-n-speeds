#! /usr/bin/env bash

if [[ ! ($ZIPFILE && $OUTPUT_DIR) ]]; then
    echo '$ZIPFILE' and '$OUTPUT_DIR' must be set >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"


EXCLUDE_DEBUG=
EXCLUDE_TEST=

if [[ -e debug*.lua ]]; then
    EXCLUDE_DEBUG='-x debug*.lua'
fi

if [[ -e test*.lua ]]; then
    EXCLUDE_TEST='-x test*.lua'
fi

zip -q \
    $ZIPFILE \
    $EXCLUDE_TEST \
    $EXCLUDE_DEBUG \
    info.json \
    changelog.txt \
    thumbnail.png \
    locale/**/* \
    migrations/**/* \
    *.lua

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
