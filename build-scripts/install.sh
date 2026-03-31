#! /usr/bin/env bash

if [[ ! -e $ZIPFILE ]]; then
    echo $ZIPFILE not found >&2
    exit 1
fi

if cp $ZIPFILE $MODS_DIR/$ZIPFILE_NAME; then
    echo $ZIPFILE installed in $MODS_DIR
fi
