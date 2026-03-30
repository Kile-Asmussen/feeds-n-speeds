#! /usr/bin/env bash

if [[ ! ($ZIPFILE && $ZIPFILE_NAME && $NAME_VERSION && $OUTPUT_DIR) ]]; then
    echo '$ZIPFILE' and '$OUTPUT_DIR' must be set >&2
    exit 1
fi

for file in $@; do
    mkdir -p $OUTPUT_DIR/$NAME_VERSION/$(dirname $file)
    cp $file $OUTPUT_DIR/$NAME_VERSION/$file
done

( cd $OUTPUT_DIR && zip -q $ZIPFILE_NAME $NAME_VERSION/**/* $NAME_VERSION/* )

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
