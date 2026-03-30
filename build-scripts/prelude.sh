#! /usr/bin/env bash

cd "$(git rev-parse --show-toplevel)"

export MODS_DIR='~/.factorio/mods'
export OUTPUT_DIR='./output'
export NAME=$(jq -r '.name' info.json)
export VERSION=$(jq -r '.version' info.json)
export ZIPFILE_NAME="${NAME}_${VERSION}.zip"
export ZIPFILE="${OUTPUT_DIR}/${NAME}_${VERSION}.zip"

mkdir -p "$OUTPUT_DIR"

if [[ $1 ]]; then
    . $1
else
    exit 1
fi

