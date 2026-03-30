#! /usr/bin/env bash

shopt -s nullglob

cd "$(git rev-parse --show-toplevel)"

export MODS_DIR="${HOME}/.factorio/mods"
export MOD_LIST="mod-list.json"
export OUTPUT_DIR="./output"
export NAME=$(jq -r '.name' info.json)
export VERSION=$(jq -r '.version' info.json)
export ZIPFILE_NAME="${NAME}_${VERSION}.zip"
export ZIPFILE="${OUTPUT_DIR}/${ZIPFILE_NAME}"

if [[ $1 ]]; then
    . $@
else
    echo 'No file given' >&2
    exit 1
fi

