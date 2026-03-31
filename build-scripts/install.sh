#! /usr/bin/env bash

shopt -s nullglob extglob

if [[ ! ( $ZIPFILE && $OUTPUT_DIR && $MOD_LIST && $MODS_DIR ) ]]; then
    echo '$ZIPFILE $OUTPUT_DIR $MOD_LIST $MODS_DIR not set'
    exit 1
fi

if [[ ! -e $OUTPUT_DIR/$ZIPFILE ]]; then
    echo $OUTPUT_DIR/$ZIPFILE not found >&2
    exit 1
fi

if cp $OUTPUT_DIR/$ZIPFILE $MODS_DIR/$ZIPFILE; then
    echo $ZIPFILE installed in $MODS_DIR
fi

JQEXPR="if any(.mods[]; .name == \"$NAME\") then . else .mods += [{ name: \"$NAME\", enabled: true }] end"

if
jq "$JQEXPR" $MODS_DIR/$MOD_LIST > $OUTPUT_DIR/$MOD_LIST && \
cp $OUTPUT_DIR/$MOD_LIST $MODS_DIR/$MOD_LIST
then
    echo updated $MODS_DIR/$MOD_LIST
else
    echo failed to update $MODS_DIR/$MOD_LIST
fi