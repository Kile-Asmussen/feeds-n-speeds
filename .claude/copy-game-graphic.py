#!/usr/bin/env python3
"""
Copy graphics from Factorio game files to the mod's graphics/from-game directory.

Usage: python copy-game-graphic.py __base__/graphics/icons/pump.png

Translates Factorio mod paths like __base__/graphics/... to actual filesystem paths
and copies them to graphics/from-game/ for editing.
"""

import sys
import os
import shutil
import re
from pathlib import Path

# Factorio data directory base
FACTORIO_DATA = Path.home() / ".steam/steam/steamapps/common/Factorio/data"

# Allowed mod directories (maps __modname__ to directory name)
ALLOWED_MODS = {
    "core": FACTORIO_DATA / "core",
    "base": FACTORIO_DATA / "base",
    "quality": FACTORIO_DATA / "quality",
    "space-age": FACTORIO_DATA / "space-age",
    "elevated-rails": FACTORIO_DATA / "elevated-rails",
}

# Output directory (relative to script's assumed working directory)
OUTPUT_DIR = Path("graphics/from-game")


def main():
    if len(sys.argv) != 2:
        print("ERROR: Expected exactly one argument: the in-game path")
        print("Usage: python copy-game-graphic.py __modname__/path/to/file.png")
        print("Example: python copy-game-graphic.py __base__/graphics/icons/pump.png")
        print("Allowed mods: " + ", ".join(f"__{m}__" for m in ALLOWED_MODS.keys()))
        sys.exit(1)

    game_path = sys.argv[1]

    # Check for directory traversal attempts (explicit check for better error message)
    if ".." in game_path:
        print(f"ERROR: Path contains '..', which is not allowed: {game_path}")
        print("Use a direct path without parent directory references.")
        sys.exit(1)

    # Parse the __modname__/path format
    match = re.match(r"^__([a-zA-Z0-9_-]+)__/(.+)$", game_path)
    if not match:
        print(f"ERROR: Invalid game path format: {game_path}")
        print("Expected format: __modname__/path/to/file.png")
        print("Example: __base__/graphics/icons/pump.png")
        print("Allowed mods: " + ", ".join(f"__{m}__" for m in ALLOWED_MODS.keys()))
        sys.exit(1)

    mod_name = match.group(1)
    relative_path = match.group(2)

    # Check if mod is allowed
    if mod_name not in ALLOWED_MODS:
        print(f"ERROR: Mod '__{mod_name}__' is not in the allowed list.")
        print("Allowed mods: " + ", ".join(f"__{m}__" for m in ALLOWED_MODS.keys()))
        sys.exit(1)

    # Construct the full filesystem path
    mod_dir = ALLOWED_MODS[mod_name]
    full_path = mod_dir / relative_path

    # Resolve the path and verify it's still within the allowed mod directory
    try:
        resolved_path = full_path.resolve(strict=True)
    except FileNotFoundError:
        print(f"ERROR: File does not exist: {full_path}")
        print(f"Resolved from game path: {game_path}")
        print("Verify the path is correct by checking the prototype in debug-data-raw.lua")
        sys.exit(1)

    # Security check: ensure resolved path is within one of the allowed directories
    is_within_allowed = False
    for allowed_dir in ALLOWED_MODS.values():
        try:
            resolved_path.relative_to(allowed_dir.resolve())
            is_within_allowed = True
            break
        except ValueError:
            continue

    if not is_within_allowed:
        print(f"ERROR: Resolved path is outside allowed directories: {resolved_path}")
        print("This may indicate a symlink escape or path manipulation.")
        print("Allowed directories:")
        for name, path in ALLOWED_MODS.items():
            print(f"  __{name}__: {path}")
        sys.exit(1)

    # Check that it's a PNG file
    if not resolved_path.suffix.lower() == ".png":
        print(f"ERROR: File is not a PNG: {resolved_path}")
        print(f"File extension: {resolved_path.suffix}")
        print("Only PNG files can be copied.")
        sys.exit(1)

    # Create output directory if needed
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Determine output filename (preserve original name)
    output_path = OUTPUT_DIR / resolved_path.name

    # Copy the file
    try:
        shutil.copy2(resolved_path, output_path)
    except Exception as e:
        print(f"ERROR: Failed to copy file: {e}")
        print(f"Source: {resolved_path}")
        print(f"Destination: {output_path}")
        print("Notify operator.")
        sys.exit(1)

    print(f"SUCCESS: Copied {resolved_path.name}")
    print(f"Source: {resolved_path}")
    print(f"Destination: {output_path}")
    print(f"The file is now available at: {output_path}")


if __name__ == "__main__":
    main()
