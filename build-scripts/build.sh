#! /usr/bin/env bash

shopt -s nullglob extglob

if [[ ! ( $NAME_VERSION && $OUTPUT_DIR && $ZIPFILE ) ]]; then
    echo '$NAME_VERSION $OUTPUT_DIR $ZIPFILE not set'
    exit 1
fi

STASH=$(git stash create)
if [[ $STASH ]]; then
    git archive --worktree-attributes --prefix=$NAME_VERSION/ $STASH -o $OUTPUT_DIR/$ZIPFILE
else
    git archive --worktree-attributes --prefix=$NAME_VERSION/ HEAD -o $OUTPUT_DIR/$ZIPFILE
fi
git gc --prune=now

(cd output && rm -rf $NAME_VERSION && unzip $ZIPFILE &>/dev/null)

if [[ -e $OUTPUT_DIR/$ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
