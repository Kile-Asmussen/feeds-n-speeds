#! /usr/bin/env bash

. $PRELUDE &>/dev/null

zip -q \
    $ZIPFILE \
    -x "debug*.lua" \
    -x "test*.lua" \
    README.md \
    info.json \
    changelog.txt \
    thumbnail.png \
    locale/** \
    migrations/** \
    *.lua