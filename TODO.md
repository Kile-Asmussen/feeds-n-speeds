# FeedsNSpeeds Functional Feature TODO

## Bugs

- [ ] Fix resource breakdowns for recipes.

- [ ] Fix visual bugs.
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

## Design considerations

- [ ] Consider splitting the barrel tapper into separate barrel filler and barrel emptier machines.

- [ ] **Infinite ores — planet richness scaling**: Currently the planet-specific richness expressions (calcite, tungsten, gleba stone) are wrapped with a hardcoded scale factor (`25000 / vanilla_baseline`) to align generated amounts with `resource.normal`. This is fragile and doesn't generalise to other mods' resources. A proper solution would derive the scale factor dynamically — either by parsing the baseline constant out of the planet noise expression, or by moving this logic to `data-updates` and inspecting the autoplace control settings to infer intended spawn richness. The latter would also make the infinite ores feature compatible with planet-aware resource mods.

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
- [ ] **Migrate away from global table instancing**: Module files should use `local table = fns.table` (and similarly for `string`, `math`, `utils`) rather than relying on the global namespace being in an instanced state. Global variable access is slower than local in Lua, and depending on global state is fragile — `fns.restore()` at the wrong scope strips the custom functions for all subsequent modules. Mostly mechanical, but touch every module file.
  - For `string` specifically, a safer alternative to replacing `_ENV.string` is to set a metatable on `_ENV.string` with `__index` pointing to the extra methods. Since `getmetatable("").__index` is `_ENV.string`, the chain becomes: string literal → string metatable → `_ENV.string` → its metatable → extra methods. This extends string methods non-destructively without replacing anything. Unclear whether Factorio permits `setmetatable` on `_ENV.string` (it disallows metatables on `_ENV` itself) — worth testing.
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

### Feature proposal: multi-mod script execution

Currently `debug/load.lua` loads a pre-dumped `data.raw` snapshot for vanilla content and only executes FeedsNSpeeds's own scripts on top of it. This means cross-mod interactions (load order, prototype mutations by other mods, `data-updates.lua` interleaving) are invisible to the pipeline. A higher-fidelity approach would execute the actual Lua scripts of all installed mods in proper dependency/alphabetical order, the same way Factorio does.

**What this would look like:**
- A Rust tool (in `src/`) that reads all enabled mods' `info.json` files, resolves the full dependency graph, and outputs a sorted load order (dependency sort + alphabetical tiebreak) — this is a prerequisite for everything else
- For each enabled mod, locate its source directory (Steam install, mods folder, or local dev path)
- Execute each mod's `data.lua`, then all `data-updates.lua`, etc. in the resolved order, inside the same sandboxed environment `debug/load.lua` already provides
- FeedsNSpeeds scripts slot into this sequence at their natural position

**Benefits:**
- Catches bugs caused by other mods mutating prototypes before or after FeedsNSpeeds runs
- No need to manually re-dump `data.raw` after vanilla updates — snapshot becomes unnecessary
- The `PROXY=1` log becomes meaningful across the full pipeline, not just our own mutations

**Challenges:**
- Other mods may use Factorio-specific APIs not shimmed in the test harness — but this is largely a non-issue: running `core`'s scripts first (exactly as Factorio does) provides `dataloader.lua`, which sets up `data`/`data:extend`/`data.raw` for real, replacing the hand-rolled shim. The lualib (`util.lua`, `meld.lua`, etc.) also becomes available to all subsequent mods for free. What remains unshimmable are things backed by C++ (e.g. noise expression evaluation, sprite loading), but those don't affect prototype table correctness.
- `require` isolation between mods: Factorio uses a prefixed path convention — `require("__mod-name__.file")` resolves relative to that mod's directory, while an unprefixed `require "util"` resolves relative to the current mod. The harness can implement this by replacing `require` with a custom resolver that parses the `__mod-name__` prefix to look up the mod's directory, falling back to the current mod's directory for unprefixed paths. `package.loaded` should be keyed by the resolved absolute path to avoid cross-mod cache collisions. No `package.path` manipulation needed. Note: `io`, `os`, `coroutine`, and `loadfile`/`dofile` are stripped in Factorio's Lua — the harness should either nil these out or leave them available behind a flag for debugging convenience. Additionally, Factorio adds `string.pack`, `string.packsize`, and `string.unpack` from Lua 5.4, and a global `table_size()` — none of these are present in Lua 5.2 and will need Rust implementations (via mlua) added to `src/`.
- Mods with C extensions or bundled binaries can't be simulated
- Adds a hard dependency on the local game install being present and up to date
- May significantly slow down the fast-iteration loop — could be gated behind a flag (e.g. `FULL_MODS=1 lua debug/load.lua`)

**Relation to existing work:** This would subsume the `rawdata.load(mod_names)` Rust library for `debug/load.lua` purposes, but `debug/data-raw.lua` would still benefit from loading a pre-dumped snapshot — it's faster and has no dependency on the Lua shim surface being complete for vanilla scripts. The headless correctness gate (stage 2) would remain valuable for catching type errors the Lua sandbox can't enforce.

### What's left

- [ ] **Rename `test_rawdata` / `rawdata` library**: As the Rust library grows to cover shimming (`table_size`, future `string.pack` etc.) and eventually multi-mod script execution, the name `rawdata` will no longer reflect its scope. Consider a broader name like `factorio_shim` or `test_harness`.

- [ ] The rust raw data loading library does not seem to adequately reset the state of the mod-list.json back to what it was, leading to changes visible in-game. Further investigation needed to verify it is a current issue.

- [ ] Investigate how factorio reports prototype loading errors when using --dump-data mode.
- [ ] **Wire `load_defines` into the test harness** — replace the hand-rolled `test/defines.lua` with values loaded from the cached `defines.json`; fixes the incomplete 8-direction stub and all made-up event IDs
- [ ] **Import core lualib directly** — `util.lua`, `math2d.lua`, `meld.lua` etc. live at a known path in the Steam install; wire them into `test.lua` via `stub_libs` redirects the same way `resource-autoplace` already is, so mod code that `require`s them gets the real implementations. Two approaches:
  - **Makefile copy rule**: add a `test/lualib` target that `cp`s the needed files out of the Steam install, add `test/lualib/` to `.gitignore`, make it a prerequisite of the test target. `stub_libs` entries point at `test.lualib.util` etc.
  - **serpent via luarocks/clone**: `util.lua` depends on `serpent` (Factorio's serializer). It turns out serpent is pure Lua and available on luarocks and GitHub — a Makefile rule could `luarocks install serpent` or clone the repo into `test/lualib/` alongside the copied lualib files.
- [ ] **Headless prototype error reporting** — investigate what Factorio prints to stdout/stderr/log when a prototype error occurs under `--start-server` or `--dump-data`; figure out how to surface these in an automated check (see existing In Progress item)
- [ ] **Automate the headless check** — once error reporting is understood, add a `make check` target (or similar) that installs FeedsNSpeeds, runs headless Factorio, and exits non-zero on prototype errors