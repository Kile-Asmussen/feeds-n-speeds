#! /usr/bin/env bash

if [[ ! ($ZIPFILE && $ZIPFILE_NAME && $MODS_DIR) ]]; then
    echo '$ZIPFILE', '$ZIPFILE_NAME', and '$MODS_DIR' must be set >&2
    exit 1
fi

if [[ ! -e $ZIPFILE ]]; then
    echo $ZIPFILE not found >&2
    exit 1
fi

if cp $ZIPFILE $MODS_DIR/$ZIPFILE_NAME; then
    echo $ZIPFILE installed in $MODS_DIR
fi

JQEXPR=".mods += [{ \"name\": \"$NAME\", \"enabled\": true }]"

if jq "$JQEXPR" $MODS_DIR/$MOD_LIST > $MODS_DIR/$MOD_LIST; then
    echo updated $MODS_DIR/$MOD_LIST
fi
