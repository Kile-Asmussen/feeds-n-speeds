#! /usr/bin/env bash

CLAUDE_PROJECT_DIR=$(git rev-parse --show-toplevel)

if [[ ! "$CLAUDE_PROJECT_DIR" || ! -e "$CLAUDE_PROJECT_DIR/.claude" ]]; then
    echo "Not in a claude project dir." >&2
    exit 2
fi

SLOP_SKILL="$CLAUDE_PROJECT_DIR/slop/factorio-research.md"
INSTALLED_SKILL="$CLAUDE_PROJECT_DIR/.claude/skills/factorio-research/SKILL.md"

if [[ ! -e "$SLOP_SKILL" ]]; then
    echo "No factorio-research.md file found, perhaps claude meant to run fetch-factorio-research.sh first?" >&2
    exit 2
fi

if diff "$SLOP_SKILL" "$INSTALLED_SKILL" ; then
    echo "factorio-research.md doesn't differ from the installed skill, perhaps claude meant to edit it first?" >&2
    exit 2
fi

cp "$INSTALLED_SKILL" "$INSTALLED_SKILL~"
cp "$SLOP_SKILL" "$INSTALLED_SKILL"