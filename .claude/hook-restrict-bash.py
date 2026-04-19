#!/usr/bin/env python3
"""
Restricts Bash tool invocations to an explicit allowlist.
Deny by default - commands must match an allowed pattern to execute.

Allowed commands are specified in accompanying allowed-bash-commands.json file.
Supports exact match and glob-style wildcards (* for any sequence).

Example allowed-bash-commands.json:
[
    "lua debug-load.lua",
    "lua debug-data-raw.lua *",
    "DEPTH=* lua debug-data-raw.lua *",
    "make build",
    "make test"
]
"""

import fnmatch
import json
import os
import sys
import io
import traceback
import datetime
from pathlib import Path

ALLOWED_COMMANDS_FILE = ".claude/allowed-bash-commands.json"
WATCHED_TOOLS = {'Bash'}

__print = print
def print(*args, file=sys.stdout, **aargs) -> None:
    if isinstance(file, io.IOBase):
        __print(*args, file=file, **aargs)
        return

    for f in file:
        __print(*args, file=f, **aargs)

LOG_FILE = io.StringIO()

def flush_log() -> None:
    content = LOG_FILE.getvalue()
    if not content or len(sys.argv) < 2:
        return
    try:
        with open(sys.argv[1], "a", encoding="utf-8") as f:
            f.write(content)
    except OSError:
        pass

print('', sys.argv[0], datetime.datetime.now().isoformat(), sep='\n', file=LOG_FILE)


def main() -> None:
    command = read_hook_input()

    if command is None:
        # Not a Bash tool or parse error - allow (fail open for non-Bash)
        sys.exit(0)

    # Normalize command (strip leading/trailing whitespace)
    command = command.strip()
    print(f"checking command: {command!r}", file=LOG_FILE)

    # Check for shell metacharacters that could enable command injection
    if not is_safe_command(command):
        print(
            "blocked bash -- contains shell metacharacters",
            "  " + command,
            f"Forbidden characters: {' '.join(DANGEROUS)}",
            "Use single commands only, no chaining or redirection.",
            "Remember: you are running in the project directory at all times, there is no need to change the current directory",
            sep = '\n',
            file=[sys.stderr, LOG_FILE]
        )
        sys.exit(2)

    allowed_patterns = load_allowed_commands()
    print(f"allowed patterns: {allowed_patterns}", file=LOG_FILE)

    if len(allowed_patterns) == 0:
        print("no allowed commands configured, blocking all Bash tool usages",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)

    for pattern in allowed_patterns:
        if matches_pattern(command, pattern):
            print(f"allowing-- command matches pattern:{pattern}",
            file=LOG_FILE)
            sys.exit(0)

    # No pattern matched - deny
    print(
        "blocked bash -- command not in allowlist:"
        f"  {command}\n"
        "Allowed patterns:",
        *allowed_patterns,
        sep='\n - ',
        file=[sys.stderr, LOG_FILE]
    )
    print("Remember, you are running in the project root,",
        "there is no need for absolute paths.", file=[sys.stderr, LOG_FILE])
    sys.exit(2)

DANGEROUS = [
    ';',    # command separator
    '|',    # pipe (also catches ||)
    '`',    # command substitution (backticks)
    '$',    # variable substitution (also catches $( and ${ )
    '{',    # function/command definition?
    '*',    # globs
    '?',    # globs
    '\n',   # newline (command separator)
    '>',    # output redirection
    '<',    # input redirection
    '&',    # background execution (also catches &&)
]

def is_safe_command(command: str) -> bool:
    """
    Check that command contains no shell metacharacters that could
    enable command chaining or injection.
    """

    return not any(dangerous in command for dangerous in DANGEROUS)


def matches_pattern(command: str, pattern: str) -> bool:
    """
    Check if command matches the allowed pattern.

    Supports:
    - Exact match
    - Glob-style wildcards (* matches any sequence of characters)
    - Pattern must match the ENTIRE command (no partial matches)
    """
    # Use fnmatch for glob-style matching
    # fnmatch.fnmatch does case-sensitive matching on Linux
    return fnmatch.fnmatch(command, pattern)


def load_allowed_commands() -> list[str]:
    project_dir = get_project_dir()

    allowed_file = project_dir / ALLOWED_COMMANDS_FILE

    if not allowed_file.exists():
        print(f"{ALLOWED_COMMANDS_FILE} not found, blocking all Bash as precaution",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)

    try:
        commands = json.loads(allowed_file.read_text(encoding="utf-8"))
        if isinstance(commands, list) and all(isinstance(c, str) for c in commands):
            return commands
    except (json.JSONDecodeError, OSError, ValueError):
        pass

    print(f"{ALLOWED_COMMANDS_FILE} not loaded, blocking all Bash as precaution",
          file=[sys.stderr, LOG_FILE])
    sys.exit(2)


def get_project_dir() -> Path:
    project_dir_env = os.environ.get("CLAUDE_PROJECT_DIR", "")

    if not project_dir_env:
        print("CLAUDE_PROJECT_DIR not set, blocking as precaution.",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)

    try:
        return Path(project_dir_env).resolve()
    except ValueError:
        print(f"{project_dir_env} not resolvable, blocking as precaution.",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)


def read_hook_input() -> str | None:
    """Read and parse hook input, return command string or None if not applicable."""
    hook_input = {}

    try:
        hook_input = json.load(sys.stdin)
        json.dump(hook_input, LOG_FILE, indent=1)
        LOG_FILE.write("\n")
    except (json.JSONDecodeError, ValueError):
        return None

    tool_name = hook_input.get("tool_name", "")
    if tool_name not in WATCHED_TOOLS:
        print(f"Not watching {tool_name}", file=LOG_FILE)
        return None

    tool_input = hook_input.get("tool_input", {})
    command = tool_input.get("command", "")

    if not command:
        print("No command in Bash tool input", file=LOG_FILE)
        return None

    return command


if __name__ == '__main__':
    try:
        main()
    except SystemExit as e:
        print(f"sys.exit({e.code})", file=LOG_FILE)
        raise
    except Exception as e:
        traceback.print_exc(file=LOG_FILE)
        print(f"Exception caught, blocking as precaution: {e!r}",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)
    finally:
        flush_log()
