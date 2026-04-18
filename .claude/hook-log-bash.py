#!/usr/bin/env python3
"""
Logs all Bash tool invocations. No blocking logic, purely for auditing.
"""

import json
import sys
import io
import datetime

WATCHED_TOOLS = { 'Bash' }

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

print('',  sys.argv[0], datetime.datetime.now().isoformat(), sep='\n', file=LOG_FILE)


def main() -> None:
    hook_input = {}

    try:
        hook_input = json.load(sys.stdin)
        json.dump(hook_input, LOG_FILE, indent=1)
        LOG_FILE.write("\n")
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "")
    if tool_name not in WATCHED_TOOLS:
        print(f"Not watching {tool_name}", file=LOG_FILE)
        sys.exit(0)

    tool_input = hook_input.get("tool_input", {})
    command = tool_input.get("command", "")

    print(f"Bash command: {command}", file=LOG_FILE)

    # Always allow - this hook is for logging only
    sys.exit(0)


if __name__ == '__main__':
    try:
        main()
    except SystemExit as e:
        print(f"sys.exit({e.code})", file=LOG_FILE)
        raise
    except Exception as e:
        print(f"Exception: {e!r}", file=LOG_FILE)
        # Still allow on error - logging failure shouldn't block
        sys.exit(0)
    finally:
        flush_log()
