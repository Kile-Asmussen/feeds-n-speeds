# FeedsNSpeeds Functional Feature TODO


## Bugs

- [ ] The rust raw data loading library does not seem to adequately reset the state of the mod-list.json back to what it was, leading to changes visible in-game. Further investigation needed to verify it is a current issue.

- [ ] Pavement types localised_description ?

## Fun tasks

- [ ] Solar power/accumulator extras
    - [ ] Accumulators should probably be more expensive (when the plastics/battery tweak is enabled) but hold more power
        - [ ] Find a nice ratio
    - [ ] Create an alternate accumulator prototype with higher energy throughput that might be useful in fusion power, "supercapacitor energy storage" technology or something, with a 5MW charge rate but the same 5MJ energy storage rate

- [ ] Electric heating, an electric energy interface Reactor, (if possible,) which produces heat, but at something like 80% efficiency.

- [ ] Boost concrete and stone brick's walkspeed bonus to about double 
- [ ] Change sulfur ore to be in smaller patches
- [ ] Oil and uranium in starting area

## Larger tasks

- Liquid rocket fuel
    - fluid boxes on rocket silos?

- Factoripedia explanation of pavement mechanics

## Potential spinoffs

- Extract big steel chest + hoppers into a standalone mod — self-contained enough to be useful without the rest of FeedsNSpeeds.
- Extract tweaks.military into self-contained mod
- Extract tweaks.water and tweaks.nuclear

## Necessary tasks

- [ ] Item/recipe ordering cleanup: With all features researched, the in-game crafting menu is cluttered. Review and improve ordering strings across all items and recipes for better organization.
- [ ] In-game changelog display
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)

# FeedsNSpeeds Development Ergonomics TODO

## Major refactor

Unify tweaks and extras

- fix dependency chaining sorting algorithm of modules
- loading system for prototype files
- loading system for update scripts
- get rid of toggles
- recipe unlocks in the data_update stage?
- Recipe dependency graph + tech dependency graph comparison

Concrete:

- Better naming
- Add to the dependency graph

Expand utilities to include way more useful things.

Split:


- **LOGISTICS** tweaks.robotics, extras.roboports, extras.chests, tweaks.electric, extras.energy, tweaks.nuclear, tweaks.chests, tweaks.concrete tile speed
- **PRODUCTION** tweaks.malltech, tweaks.timewaster.ADVANCED,  extras.altrecipes.castings, tweaks.technologies, tweaks.ores
- **CONSTRUCTION** extras.altrecipes.concrete*, extras.concrete.data2, extras.concrete.data/data_updates, tweaks.timewaster.*, tweaks.machines, extras.barreling
- **BOOTSTRAP** extras.altrecipes.stone-furnace, tweaks.earlygame, parts of tweaks.technologies, tweaks.earlygame, tweaks.start
- **MILITARY** extras.ore, tweaks.sulfur-processing, extras.drills, extras.heavy, tweaks.military, extras.altrecipes.ammo, extras.radar, tweaks.cliffsplosives


### Migration progress:

- 


## Enhanced Out-of-Game Testing Pipeline

The goal is a three-stage pipeline before ever booting the game:

1. **`debug/load.lua` (fast iteration)** — runs the full settings→data→control pipeline in plain Lua. Use `VERBOSE=1` for the proxy output: every `data:extend` call and every `data.raw` mutation is logged, which is the primary tool for bugfixing prototype logic. Already working.

2. **Headless Factorio prototype check (correctness gate)** — invoke Factorio in headless mode to actually load the mod and validate prototypes. Catches errors that `debug/load.lua` can't (type mismatches, missing required fields, invalid references between prototypes). See existing TODO item on how Factorio reports these errors under `--dump-data` or headless server mode. This stage runs after `debug/load.lua` passes.

3. **In-game verification (behaviour check)** — boot the game and inspect actual in-game behaviour: visuals, balance, recipe availability, tech tree, map generation. Only reached after stages 1 and 2 pass.

### What's done

- `rawdata.load(mod_names)` — `data.raw` from any mod combination, cached, invalidated by explicit `rawdata.dump()` call
- `rawdata.load_defines(mod_src)` / `rawdata.dump_defines(mod_src)` — real `defines` table via headless Factorio scenario (`debug/dump-defines/`), base mods only for fast load

### What's left

- [ ] Investigate how factorio reports prototype loading errors when using --dump-data mode.
- [ ] **Wire `load_defines` into the test harness** — replace the hand-rolled `test/defines.lua` with values loaded from the cached `defines.json`; fixes the incomplete 8-direction stub and all made-up event IDs
- [ ] **Import core lualib directly** — `util.lua`, `math2d.lua`, `meld.lua` etc. live at a known path in the Steam install; wire them into `test.lua` via `stub_libs` redirects the same way `resource-autoplace` already is, so mod code that `require`s them gets the real implementations. Two approaches:
  - **Makefile copy rule**: add a `test/lualib` target that `cp`s the needed files out of the Steam install, add `test/lualib/` to `.gitignore`, make it a prerequisite of the test target. `stub_libs` entries point at `test.lualib.util` etc.
  - **serpent via luarocks/clone**: `util.lua` depends on `serpent` (Factorio's serializer). It turns out serpent is pure Lua and available on luarocks and GitHub — a Makefile rule could `luarocks install serpent` or clone the repo into `test/lualib/` alongside the copied lualib files.
- [ ] **Headless prototype error reporting** — investigate what Factorio prints to stdout/stderr/log when a prototype error occurs under `--start-server` or `--dump-data`; figure out how to surface these in an automated check (see existing In Progress item)
- [ ] **Automate the headless check** — once error reporting is understood, add a `make check` target (or similar) that installs FeedsNSpeeds, runs headless Factorio, and exits non-zero on prototype errors