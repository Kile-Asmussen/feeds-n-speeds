#! /usr/bin/env bash

if [[ ! ( $ZIPFILE && $NAME_VERSION ) ]]; then
    echo '$ZIPFILE' must be set >&2
    exit 1
fi

git archive --worktree-attributes --prefix=$NAME_VERSION/ HEAD -o $ZIPFILE

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
