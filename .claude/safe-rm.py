#!/usr/bin/env python3
"""safe-rm.py - Restricted rm wrapper for Claude Code

Restrictions:
  - Single file only (no multiple arguments)
  - No wildcards/globs
  - No directories (must be a regular file)
  - No symlinks (could escape allowed paths)
  - Must be within allowed directory tree
  - No hidden files or paths containing hidden components

Usage: safe-rm.py <filepath>
"""

import sys
import subprocess
from pathlib import Path


def get_project_dir() -> Path:
    """Get project directory from git root."""
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True, text=True, check=True
        )
        return Path(result.stdout.strip())
    except subprocess.CalledProcessError:
        print("safe-rm: not in a git repository", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("safe-rm: git not found", file=sys.stderr)
        sys.exit(1)


PROJECT_DIR = get_project_dir()

# Configuration
ALLOWED_ROOTS = [
    PROJECT_DIR / "slop",
    Path.home() / ".factorio/script-output"
]

def die(msg: str) -> None:
    print(f"safe-rm: {msg}", file=sys.stderr)
    sys.exit(1)


def validate_path(filepath: str) -> Path:
    """Validate and return resolved Path, or die with error."""

    # Reject flags
    if filepath.startswith("-"):
        die("flags not permitted")

    # Reject glob characters
    for char in ("*", "?", "[", "]", "{", "}"):
        if char in filepath:
            die(f"glob character '{char}' not permitted")

    # Reject empty or whitespace-only
    if not filepath.strip():
        die("empty path not permitted")

    path = Path(filepath)

    # Reject hidden files or hidden path components
    for part in path.parts:
        if part == "":
            continue  # Leading slash produces empty part
        if part in ('.', '..', '~'):
            die(f"forbidden special directory: {part}")
        if part.startswith("."):
            die(f"hidden file/directory not permitted: {part}")

    # Path must exist
    if not path.exists():
        die(f"file does not exist: {filepath}")

    # Reject symlinks before resolving (could point anywhere)
    if path.is_symlink():
        die("symlinks not permitted")

    # Must be a regular file
    if not path.is_file():
        die(f"not a regular file: {filepath}")

    # Resolve to absolute path for prefix checking
    resolved = path.resolve()

    # Verify symlink resolution didn't escape (paranoid double-check)
    if path.resolve() != Path(filepath).absolute().resolve():
        die("path resolution mismatch (possible symlink escape)")

    # Must be under an allowed root
    allowed = False
    for root in ALLOWED_ROOTS:
        try:
            resolved_root = root.resolve()
            resolved.relative_to(resolved_root)
            allowed = True
            break
        except ValueError:
            continue

    if not allowed:
        allowed_list = ", ".join(str(r) for r in ALLOWED_ROOTS)
        die(f"path outside allowed directories: {allowed_list}")

    return resolved


def main() -> None:
    # Must have exactly one argument
    if len(sys.argv) != 2:
        die("requires exactly one file argument")

    filepath = sys.argv[1]
    resolved = validate_path(filepath)

    # Perform the deletion
    try:
        resolved.unlink()
        print(f"removed: {filepath}")
    except PermissionError:
        die(f"permission denied: {filepath}")
    except OSError as e:
        die(f"failed to remove: {e}")


if __name__ == "__main__":
    main()
