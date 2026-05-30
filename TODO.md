# FeedsNSpeeds Functional Feature TODO

## Bugs

- [ ] There's something wrong with the electric link.

- [ ] Fluid-capable burner mining drill not correctly unlocked by wet-drilling tech.

- [x] Hopper is still named the same as the steel/smart chest

- [x] Startup additional resources not working in freeplay

- [ ] Fix visual bugs.
  - [ ] Basic materials processing looks weird
  - [ ] Contrast problems in overlaid icons (can Tint lighten a sprite?)
  - [ ] Something else for the sleeper roboport's antenna
  - [ ] Overlaid icons look kinda jank
  - [ ] Chests need to be ever so slightly bigger in collission to prevent clipping


## Fun tasks

- [ ] Turn crushers into a tiered furnaces
  - Reprocessor
  - Crusher
  - Crusher Mk 2

- [ ] **Mini-reactor technology** (IMPORTANT): The mini-reactor is currently inaccessible in-game. Needs a new technology that unlocks it alongside heat pipes, heat exchangers, and steam turbines. This tech should sit in a larger energy branch that connects to accumulator/solar improvements, providing tiered energy storage options (mini-reactor → heat-based steam → supercapacitor accumulators).
  - [ ] "Tank full of sand" heat battery
  - [ ] Tertiary generator variants?
  - [ ] Tertiary 

- [ ] Solar power/accumulator extras
    - [ ] Accumulators should probably be more expensive (when the plastics/battery tweak is enabled) but hold more power
        - [ ] Find a nice ratio

- [ ] Giant slow inserter with huge hand size for unloading trains.

## Big tasks

- [ ] Alternate, more complex recipes for all the personal equipment
- [ ] **Auto-pavement coverage**: Set `auto_require_pavement` on all mod-created entity prototypes (turrets, roboports, electroboiler, mini-reactor, electric-link, hoppers, etc.) and expand `pavement.lua` to assign tiers to relevant vanilla entities beyond mining drills.

## Potential spinoffs

- [ ] Extract big steel chest + hoppers into a standalone mod — self-contained enough to be useful without the rest of FeedsNSpeeds.


## Necessary tasks

- [ ] Tweak shit related to everything
  - Recipes
  - Less ore from rocks
  - Chest inventory sizes, etc.
  - Express transport belts need to depend on fast

- Recipes:
  - Pipes in recipe for electric drill
  - Burner inserter needs sticks and bricks
  - Burner drills should use furnaces
  - Boilers also


- [ ] **Readability refactor**: Audit all mod files for raw ingredient/result arrays and direct prototype assignments that should use `table.merge` and `gadgets.throughputs`. Mostly mechanical find-and-replace work.
- [ ] Item/recipe ordering cleanup: With all features researched, the in-game crafting menu is cluttered. Review and improve ordering strings across all items and recipes for better organization.
- [ ] **Tech unlock ordering** (low priority): `assign-recipe-unlocks` appends effects to technologies in arbitrary iteration order. A sorting pass by group → subgroup → order string after all effects are inserted would make the in-game technology screen tidier.
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)

## Overarching tasks

- [ ] Expand malltech module to include late-game structures
- [ ] Add per-planet surface condition variants for entities
  - [ ] Mini reactor should not be available on Aquilo, for instance
- [ ] Add migration scripts for settings changes

# FeedsNSpeeds Development Ergonomics TODO

## Enhanced Out-of-Game Testing Pipeline

The goal is a three-stage pipeline before ever booting the game:

1. **`debug/load.lua` (fast iteration)** — runs the full settings→data→control pipeline in plain Lua. Use `VERBOSE=1` for the proxy output: every `data:extend` call and every `data.raw` mutation is logged, which is the primary tool for bugfixing prototype logic. Already working.

2. **Headless Factorio prototype check (correctness gate)** — invoke Factorio in headless mode to actually load the mod and validate prototypes. Catches errors that `debug/load.lua` can't (type mismatches, missing required fields, invalid references between prototypes). See existing TODO item on how Factorio reports these errors under `--dump-data` or headless server mode. This stage runs after `debug/load.lua` passes.

3. **In-game verification (behaviour check)** — boot the game and inspect actual in-game behaviour: visuals, balance, recipe availability, tech tree, map generation. Only reached after stages 1 and 2 pass.

### What's done

- `rawdata.load(mod_names)` — `data.raw` from any mod combination, cached, invalidated by explicit `rawdata.dump()` call
- `rawdata.load_defines(mod_src)` / `rawdata.dump_defines(mod_src)` — real `defines` table via headless Factorio scenario (`debug/dump-defines/`), base mods only for fast load

### What's left

- [ ] The rust raw data loading library does not seem to adequately reset the state of the mod-list.json back to what it was, leading to changes visible in-game. Further investigation needed to verify it is a current issue.

- [ ] Investigate how factorio reports prototype loading errors when using --dump-data mode.
- [ ] **Wire `load_defines` into the test harness** — replace the hand-rolled `test/defines.lua` with values loaded from the cached `defines.json`; fixes the incomplete 8-direction stub and all made-up event IDs
- [ ] **Import core lualib directly** — `util.lua`, `math2d.lua`, `meld.lua` etc. live at a known path in the Steam install; wire them into `test.lua` via `stub_libs` redirects the same way `resource-autoplace` already is, so mod code that `require`s them gets the real implementations. Two approaches:
  - **Makefile copy rule**: add a `test/lualib` target that `cp`s the needed files out of the Steam install, add `test/lualib/` to `.gitignore`, make it a prerequisite of the test target. `stub_libs` entries point at `test.lualib.util` etc.
  - **serpent via luarocks/clone**: `util.lua` depends on `serpent` (Factorio's serializer). It turns out serpent is pure Lua and available on luarocks and GitHub — a Makefile rule could `luarocks install serpent` or clone the repo into `test/lualib/` alongside the copied lualib files.
- [ ] **Headless prototype error reporting** — investigate what Factorio prints to stdout/stderr/log when a prototype error occurs under `--start-server` or `--dump-data`; figure out how to surface these in an automated check (see existing In Progress item)
- [ ] **Automate the headless check** — once error reporting is understood, add a `make check` target (or similar) that installs FeedsNSpeeds, runs headless Factorio, and exits non-zero on prototype errors