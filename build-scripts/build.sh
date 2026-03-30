#! /usr/bin/env bash

if [[ ! ($ZIPFILE && $ZIPFILE_NAME && $NAME_VERSION && $OUTPUT_DIR) ]]; then
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

mkdir -p $OUTPUT_DIR/$NAME_VERSION
cp $@ $OUTPUT_DIR/$NAME_VERSION/
( cd $OUTPUT_DIR && zip -q $ZIPFILE_NAME $NAME_VERSION/* )
rm -rf $OUTPUT_DIR/$NAME_VERSION

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
