#! /usr/bin/env bash

DATA_DIR='./data'
DATA_RAW=$DATA_DIR/raw.lua
DATA_RAW_URL='https://gist.githubusercontent.com/Bilka2/6b8a6a9e4a4ec779573ad703d03c1ae7/raw'

mkdir -p $DATA_DIR
echo "data = data or {}" > $DATA_RAW
echo "data.raw = {" >> $DATA_RAW

if wget -qO- $DATA_RAW_URL | tail -n +2 >> $DATA_RAW; then
    echo downloaded $DATA_RAW
else
    rm -f $DATA_RAW
    echo downloading $DATA_RAW failed >&2
    exit 1
fi
