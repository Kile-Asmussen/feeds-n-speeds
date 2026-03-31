#! /usr/bin/env bash

MOD_FILE=$MODS_DIR/$ZIPFILE_NAME

if [[ -e $MOD_FILE ]]; then
    rm $MOD_FILE && echo removed $MOD_FILE
else
    echo $ZIPFILE_NAME is not installed
fi

JQEXPR="del(.mods[] | select(.name == \"$NAME\"))"

if jq "$JQEXPR" $MODS_DIR/$MOD_LIST > $OUTPUT_DIR/$MOD_LIST; then
    echo updated $MODS_DIR/$MOD_LIST
    cp $OUTPUT_DIR/$MOD_LIST $MODS_DIR/$MOD_LIST
fi