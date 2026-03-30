#! /usr/bin/env bash

if [[ ! ($ZIPFILE_NAME && $MODS_DIR) ]]; then
    echo '$ZIPFILE_NAME' and '$MODS_DIR' must be set >&2
    exit 1
fi

MOD_FILE=$MODS_DIR/$ZIPFILE_NAME

if [[ -e $MOD_FILE ]]; then
    rm $MOD_FILE && echo removed $MOD_FILE
else
    echo $ZIPFILE_NAME is not installed
fi

JQEXPR="del(.mods[] | select(.name == \"$NAME\"))"

if jq "$JQEXPR" $MODS_DIR/$MOD_LIST > $OUTPUT_DIR/$MOD_LIST; then
    echo updated $MODS_DIR/$MOD_LIST
fi