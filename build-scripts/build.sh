#! /usr/bin/env bash

STASH=$(git stash create)
if [[ $STASH ]]; then
    git archive --worktree-attributes --prefix=$NAME_VERSION/ $STASH -o $ZIPFILE
else
    git archive --worktree-attributes --prefix=$NAME_VERSION/ HEAD -o $ZIPFILE
fi
git gc --prune=now

(cd output && rm -rf $NAME_VERSION && unzip $ZIPFILE_NAME &>/dev/null)

if [[ -e $ZIPFILE ]]; then
    echo $ZIPFILE built
else
    echo Failed to build >&2
fi
