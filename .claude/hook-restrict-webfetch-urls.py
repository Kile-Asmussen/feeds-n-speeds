#!/usr/bin/env python3
"""
Restricts WebFetch tool calls to a list of permitted domains, with path-level
exceptions that can deny specific URLs within permitted domains.

Configuration is in the accompanying webfetch-urls.json file:
  {
    "domains":    ["github.com", "*.microsoft.com"],
    "exceptions": ["learn.microsoft.com/dangerous/*"]
  }

'domains' patterns are matched with fnmatchcase against the hostname only.
'exceptions' patterns are matched with fnmatchcase against hostname + path.

Deny-by-default: URLs whose hostname matches no domain pattern are blocked.
Exceptions take precedence over domains.
"""

import json
import os
import sys
import io
import traceback
import datetime
from fnmatch import fnmatchcase
from pathlib import Path
from urllib.parse import urlsplit

WEBFETCH_URLS_FILE = ".claude/webfetch-urls.json"
WATCHED_TOOLS = { 'WebFetch' }

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

    url = read_hook_input()

    parsed = urlsplit(url)
    hostname = parsed.hostname or ""
    path = parsed.path or ""
    hostname_and_path = hostname + path

    print(f"url: {url}", file=LOG_FILE)
    print(f"hostname: {hostname}", file=LOG_FILE)
    print(f"hostname+path: {hostname_and_path}", file=LOG_FILE)

    domains, exceptions = load_config()

    print("allowed domains:", *domains, sep='\n', file=LOG_FILE)
    print("explicit exceptions:", *exceptions, sep='\n', file=LOG_FILE)
    
    allowed_by = next((domain for domain in domains if fnmatchcase(hostname, domain)), None)
    
    if not allowed_by:
        print(f"blocking fetch -- hostname `{hostname}' not in list of allowed domain patterns",
            file=[sys.stderr, LOG_FILE])
        sys.exit(2)
    
    disallowed_by = next((exception for exception in exceptions if fnmatchcase(hostname_and_path, exception)), None)
                
    if disallowed_by:
        print(
            f"blocked fetch -- url matches exception pattern `{disallowed_by}'",
            file=[sys.stderr, LOG_FILE]
        )
        sys.exit(2)

    print(
        f"allowing fetch -- hostname permitted by `{allowed_by}'",
        file=LOG_FILE
    )
    sys.exit(0)


def load_config() -> tuple[list[str], list[str]]:

    project_dir = get_project_dir()

    config_file = project_dir / WEBFETCH_URLS_FILE

    if not config_file.exists():
        print(f"{WEBFETCH_URLS_FILE} not found, blocking as a precaution",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)

    try:
        config = json.loads(config_file.read_text(encoding="utf-8"))
        
        if not isinstance(config, dict):
            raise ValueError("config must be a JSON object")
            
        domains = config.get("domains", [])
        exceptions = config.get("exceptions", [])
        
        if not (isinstance(domains, list) and all(isinstance(d, str) for d in domains)):
            raise ValueError("'domains' must be a list of strings")
            
        if not (isinstance(exceptions, list) and all(isinstance(e, str) for e in exceptions)):
            raise ValueError("'exceptions' must be a list of strings")
        
        return domains, exceptions
        
    except (json.JSONDecodeError, OSError, ValueError) as e:
        print(f"{WEBFETCH_URLS_FILE} not loaded ({e}), blocking as a precaution",
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
        print(f"{project_dir_env} not resolvable, blocking as a precaution.",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)


def read_hook_input() -> str:
    hook_input = {}

    try:
        hook_input = json.load(sys.stdin)
        json.dump(hook_input, LOG_FILE, indent=1)
        LOG_FILE.write("\n")
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    tool_name = hook_input.get("tool_name", "### NO_TOOL_NAME_GIVEN ###")
    if tool_name not in WATCHED_TOOLS:
        print(f"Not working on {tool_name}", file=LOG_FILE)
        sys.exit(0)

    tool_input = hook_input.get("tool_input", {})
    url = tool_input.get("url")

    if not url:
        print("No url in tool_input, blocking as a precaution.",
              file=[sys.stderr, LOG_FILE])
        sys.exit(2)

    return url


if __name__ == '__main__':
    try:
        main()
    except SystemExit as e:
        print(f"sys.exit({e.code})", file=LOG_FILE)
        raise
    except Exception as e:
        traceback.print_exc(file=LOG_FILE)
        print("sys.exit(2)", file=LOG_FILE)
        print(repr(e), "caught, blocking as precaution")
        sys.exit(2)
    finally:
        flush_log()