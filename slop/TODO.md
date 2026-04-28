# FeedsNSpeeds Development TODO

## Bugs

- [ ] The rust raw data loading library does not seem to adequately reset the state of the mod-list.json back to what it was, leading to changes visible in-game. Further investigation needed to verify it is a current issue.

## In Progress

- [ ] Space Age DLC integration
- [ ] Investigate how factorio reports prototype loading errors when using --dump-data mode.
- [ ] Textplates integration (`tweaks/textplates.lua`) — use `rawdata.load({"FeedsNSpeeds", "textplates", "even-more-text-plates-2_0"})` to get a modded dump and verify that `fix_tech` and `fix_recipe` produce the expected prototype changes. Check that triggered techs fire correctly in-game and that recipes are properly locked behind them.

## Enhanced Out-of-Game Testing Pipeline

The goal is a three-stage pipeline before ever booting the game:

1. **`debug/load.lua` (fast iteration)** — runs the full settings→data→control pipeline in plain Lua. Use `VERBOSE=1` for the proxy output: every `data:extend` call and every `data.raw` mutation is logged, which is the primary tool for bugfixing prototype logic. Already working.

2. **Headless Factorio prototype check (correctness gate)** — invoke Factorio in headless mode to actually load the mod and validate prototypes. Catches errors that `debug/load.lua` can't (type mismatches, missing required fields, invalid references between prototypes). See existing TODO item on how Factorio reports these errors under `--dump-data` or headless server mode. This stage runs after `debug/load.lua` passes.

3. **In-game verification (behaviour check)** — boot the game and inspect actual in-game behaviour: visuals, balance, recipe availability, tech tree, map generation. Only reached after stages 1 and 2 pass.

### What's done

- `rawdata.load(mod_names)` — `data.raw` from any mod combination, cached, invalidated by explicit `rawdata.dump()` call
- `rawdata.load_defines(mod_src)` / `rawdata.dump_defines(mod_src)` — real `defines` table via headless Factorio scenario (`debug/dump-defines/`), base mods only for fast load

### What's left

- [ ] **Wire `load_defines` into the test harness** — replace the hand-rolled `test/defines.lua` with values loaded from the cached `defines.json`; fixes the incomplete 8-direction stub and all made-up event IDs
- [ ] **Import core lualib directly** — `util.lua`, `math2d.lua`, `meld.lua` etc. live at a known path in the Steam install; wire them into `test.lua` via `stub_libs` redirects the same way `resource-autoplace` already is, so mod code that `require`s them gets the real implementations
- [ ] **Headless prototype error reporting** — investigate what Factorio prints to stdout/stderr/log when a prototype error occurs under `--start-server` or `--dump-data`; figure out how to surface these in an automated check (see existing In Progress item)
- [ ] **Automate the headless check** — once error reporting is understood, add a `make check` target (or similar) that installs FeedsNSpeeds, runs headless Factorio, and exits non-zero on prototype errors

## Long-term Goals

- [ ] Expand alt-recipes module (`extras/altrecipes/`)
- [ ] Expand malltech module
- [ ] Add per-planet surface condition variants for entities
- [ ] Add migration scripts for settings changes

## Ideas / Maybe

- [ ] Rail automation as triggered tech: Consider converting rail-automation from a researched technology to a triggered tech based on crafting 1000 rails. Trains are nearly useless without automation signals. Unclear which module this would belong to.
- [ ] Item/recipe ordering cleanup: With all features researched, the in-game crafting menu is cluttered. Review and improve ordering strings across all items and recipes for better organization.
- [ ] Default-off toggles: Consider shipping with most features disabled by default, letting users discover and enable combinations; reduces initial complexity while preserving modularity
- [ ] Feature profiles: Predefined toggle combinations (e.g., "minimal", "balanced", "kitchen sink") as a single setting
- [ ] Electrical boiler: identical to baseline boiler but with electrical energy source; provides steam for altered recipes or coal liquefaction; serves as accumulator alternative for solar setups
- [ ] Debug mode setting for verbose logging
- [ ] In-game changelog display
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)
