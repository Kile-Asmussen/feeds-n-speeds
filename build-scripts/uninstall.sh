#! /usr/bin/env bash

shopt -s nullglob extglob

if [[ ! ( $MODS_DIR && $ZIPFILE && $MOD_LIST && $OUTPUT_DIR ) ]]; then
    echo '$MODS_DIR $ZIPFILE $MOD_LIST $OUTPUT_DIR not set' >&2
    exit 2
fi

if [[ -e $MODS_DIR/$ZIPFILE ]]; then
    rm $MODS_DIR/$ZIPFILE && echo removed $MODS_DIR/$ZIPFILE
else
    echo $ZIPFILE is not installed
fi

JQEXPR="del(.mods[] | select(.name == \"$NAME\"))"

if jq "$JQEXPR" $MODS_DIR/$MOD_LIST > $OUTPUT_DIR/$MOD_LIST; then
    echo updated $MODS_DIR/$MOD_LIST
    cp $OUTPUT_DIR/$MOD_LIST $MODS_DIR/$MOD_LIST
fi