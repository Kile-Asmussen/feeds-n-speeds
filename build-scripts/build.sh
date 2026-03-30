#! /usr/bin/env bash

if [[ ! ($ZIPFILE && $ZIPFILE_NAME && $NAME_VERSION && $OUTPUT_DIR) ]]; then
    echo '$ZIPFILE' and '$OUTPUT_DIR' must be set >&2
    exit 1
fi

git archive -o $ZIPFILE

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
