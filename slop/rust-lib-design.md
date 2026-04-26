# test_rawdata lib — design notes

## Current state

`src/lib.rs` exposes a single Lua module entry point (`test_rawdata`) that:
1. Checks if `~/.factorio/script-output/data-raw-dump.json` exists.
2. If not, backs up the mod list, forces only the 5 core mods on, launches Factorio with `--dump-data`, then restores the original mod list.
3. Parses the JSON dump and returns it as a Lua table.

The cache is a single file with no mod-list awareness — a core-only dump and a full-mod dump share the same path and will silently shadow each other.

## Known bug

`factorio_dump_data_raw()` passes `--dump-data-raw` to Steam; the correct flag is `--dump-data`. Has not triggered yet because the dump file was generated manually before the code path was exercised.

## Proposed direction: richer Lua API

Rather than a single opaque entry point, expose several Lua-callable functions so test scripts can orchestrate the dump/load lifecycle themselves:

```lua
local rawdata = require("test_rawdata")

-- dump with whatever mod-list is currently active, then load
local data = rawdata.load()

-- explicitly dump first (blocks until Factorio exits), then load
rawdata.dump()
local data = rawdata.load()

-- dump with a specific mod-list override, then restore
rawdata.dump({ mods = { "base", "space-age", "quality", "elevated-rails", "FeedsNSpeeds" } })
local data = rawdata.load()
```

### Cache key

The dump file name (or a subdirectory) should be derived from a hash or sorted list of the enabled mod names+versions, so core-only and full-mod dumps can coexist without stomping each other.

### Separation of concerns

- `dump()` — writes mod-list, launches Factorio, restores mod-list. Idempotent if cache is fresh.
- `load()` — reads and parses the JSON, returns Lua table. Fast path; no process launch.
- Entry point stays thin: just calls `load()`, optionally preceded by `dump()` if the cache is missing.

## What this enables

A test script can load vanilla `data.raw` for comparison, then load the modded version, and diff or assert on the delta — all driven from Lua with no manual steps.

## Motivating use case: Textplates integration

A key use case for arbitrary-mod dumps is an integration with the various Textplates mods. The goal is to change textplate technologies from being researchable to being unlocked by item collection (i.e. triggered on picking up the item). There is a work-in-progress attempt at `tweaks/textplates.lua` that doesn't yet behave correctly.

This requires dumping `data.raw` with the relevant Textplates mod(s) enabled, so the prototype structures are visible and the integration can be developed and tested against real data rather than guesses.
