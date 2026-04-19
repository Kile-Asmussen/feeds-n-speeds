#! /usr/bin/env bash

CLAUDE_PROJECT_DIR=$(git rev-parse --show-toplevel)

if [[ ! $CLAUDE_PROJECT_DIR || ! -e $CLAUDE_PROJECT_DIR/.claude ]]; then
    echo "Not in a claude project dir." >&2
    exit 2
fi

SLOP_SKILL="$CLAUDE_PROJECT_DIR/slop/factorio-research.md"
INSTALLED_SKILL="$CLAUDE_PROJECT_DIR/.claude/skills/factorio-research/SKILL.md"

if [[ -e "$SLOP_SKILL" ]]; then
    echo "factorio-research.md file still exists in slop directory, this would overwrite -- delete it first with" >&2
    echo "python .claude/safe-rm.py slop/factorio-research.md" >&2
    exit 2
fi 

cp "$INSTALLED_SKILL" "$SLOP_SKILL"