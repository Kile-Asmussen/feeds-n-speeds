# Session Summary - 2026-04-19

## Completed This Session

### Wet Drilling Technology
- Created `extras/drills/wet-drilling-technology.lua` - triggers on building offshore pump
- Provides `mining-with-fluid` effect (moved from uranium-mining)
- Unlocks burner mining drill fluid recipe
- Prerequisites: steam-power
- Icon: steam-power base + mining-productivity overlay

### Uranium Tech Restructure
- Hidden `uranium-mining` technology (redundant with wet-drilling)
- Converted `uranium-processing` from trigger-based to science-based (100 x 30s, automation/logistic/chemical)
- Added prerequisites: speed-module, electric-engine, concrete
- Added `electric-engine` prerequisite to `nuclear-power`

### Malltech Updates
- Lab recipe (if earlygame enabled): 4x transport-belt, 2x inserter, 8x electronic-circuit
- Uranium-processing prerequisites for centrifuge ingredients

### Concrete Rail Technology
- Fixed icon overlay: scaled to 0.25, shifted to corner {50, 50}

### Sulfur Ore Resource (extras/ores/)
- `sulfur-ore.lua` - resource requiring steam to mine, yields vanilla sulfur
- `sulfur-ore-noise-expression.lua` - map generation algorithm
- `sulfur-ore-autoplace-control.lua` - map settings UI
- *Note: These writes bypassed permission settings due to discovered security issue*

## Security Issue Discovered
- Write operations to `extras/ores/` succeeded despite not being in allow list
- CLI switched to "accept edits on" mode after plan mode acceptance
- `defaultMode: "dontAsk"` (deny-by-default) was bypassed

---

# Session Summary - 2026-04-19 (continued)

## Completed This Session

### Hook Bug Fix
- Fixed `hook-backup-write-edit-defense.py` - undefined `rel_path_str` variable on lines 96, 99, 104
- Changed to `rel_path` to match the defined variable

### Permission Updates
- Added `Edit(CLAUDE.md)` to allowed permissions
- Added `Edit(locale/**/*)`to allowed permissions
- Created skill editing workflow scripts:
  - `.claude/fetch-factorio-research.sh` - copies skill to slop/ for editing
  - `.claude/install-factorio-research.sh` - installs edited skill back

### Documentation Updates
- Updated `CLAUDE.md` project structure with new directories (drills/, ores/, altrecipes/, test/)
- Added missing tweaks (earlygame, malltech, timewaster) to features table
- Updated extras table with complete feature list
- Updated allowed tools, bash commands, and implications sections
- Updated factorio-research skill with maintenance workflow section

### TODO Consolidation
- Moved pending items from LOG.md to TODO.md
- Moved completed items to TODO.md Completed section
- Removed obsolete `remove-toggles-plan.md`

### Design Decision
- Mod will retain toggleable features (not become overhaul mod)
- Added consideration: default-off toggles and feature profiles

## Verified
- Unit tests: 131 passed, 0 failed
- Load cycle: All stages complete (settings, data, control)

### Sulfur Ore Implementation
- Wired up `extras/ores.lua` coordinator to load sulfur ore prototypes
- Added conditional starting area logic to `extras/ores/sulfur-ore-noise-expression.lua`:
  - `earlygame` enabled → `has_starting_area_placement = 1` (modest deposit in starting area)
  - `earlygame` disabled → `has_starting_area_placement = 0` (distant resource like uranium/oil)
- Research: `has_starting_area_placement` parameter in `resource_autoplace_all_patches` controls starting area spawning
  - Iron/copper/coal/stone: value = 1
  - Uranium/crude-oil: value = 0

---

# Session Summary - 2026-04-19 (continued)

## Completed This Session

### Burner Mining Drill (Fluid) Updates
- Added `filter = 'steam'` to input fluid box (only accepts steam, not sulfuric acid)
- Reduced fluid box volume from 200 to 50 (5 operations per tank)
- Moved fluid box to north side (same as output chute) for intentionally awkward piping
- Added `production_type = 'input'` to remove two-way flow icon

### Electroboiler Module (extras/electroboiler/)
- Created new extras module for electric-powered boiler
- `electroboiler-building.lua` - boiler clone with electric energy source (1.8MW)
- `electroboiler-item.lua` - boiler icon with yellow-tinted lightning overlay
- `electroboiler-recipe.lua` - stone-furnace + 4 pipe + 2 electronic-circuit
- Unlocked by steam-power technology

### Sulfur Ore Improvements
- Added `localised_name` with entity icon tag to autoplace control
- Registered sulfur ore with Nauvis map generation in `data_updates`
- Created fallback `sulfur-drilling` technology when drills module disabled:
  - Prerequisites: sulfur-processing
  - Cost: 50 automation + logistic science packs
  - Provides mining-with-fluid effect
  - Becomes prerequisite for uranium-processing

### Altrecipes Module Expansion
- **Basic Materials Processing Technology**: Triggered by crafting 5 stone furnaces
  - Unlocks brick-based stone furnace recipe (when earlygame enabled)
  - Without earlygame: brick recipe available from start, vanilla costs 10 stone
  - With earlygame: brick recipe locked, vanilla costs 15 stone
- **Concrete Wall**: Recipe using 5 concrete, unlocked by concrete-wall technology
  - Technology prerequisites: stone-wall, concrete
  - Triggered by crafting 100 concrete
- **Stone-brick Rail**: Moved to vanilla railway technology (always available)
- **Concrete Rail/Wall**: Now guarded by `tweaks.concrete.enabled`

### Earlygame Tweaks Updates
- Added `electronics` prerequisite to steam-power (offshore pump needs circuits)
- Transport belts moved to logistics technology
- Iron gear wheel now unlocked by steel-processing (disabled at start)
- Steel-processing description now uses locale key reference
- Fixed: Remove hopper unlock from automation-2 when moving to automation

### Icon Improvements
- Fluid drill items: pipe overlay moved to top-left corner
- Rail alt recipes: material overlay moved to top-left corner
- Stone furnace recipe: brick overlay moved to top-left corner
- Concrete wall recipe: concrete overlay moved to top-left corner
- Concrete rail/wall tech: Adjusted overlay shift from {50,50} to {35,35} for scale 0.33
- Electroboiler: Fixed tint on lightning overlay instead of boiler base
- Rail recipe ordering: Fixed to not interleave with rail-ramp/rail-support

### Wet Drilling Technology
- Added `order = 'a-b-b'` to sort after steam-power

### Locale Updates
- Added all missing locale strings for new features
- Simple-concrete renamed to "Primitive concrete"
- Steel-processing description made conditional via locale key

### TODO Updates
- Added design consideration: sulfur ore module dependency on drills
- Added ideas: rail automation as triggered tech, item/recipe ordering cleanup
- Added note: concrete-rail tech icon shift may need adjustment

---

# Session Summary - 2026-04-20

## Completed This Session

### Sulfur Ore Map Generation Fix
- Fixed sulfur ore not spawning on map
- Root cause: needed registration in both `autoplace_controls` (GUI) AND `autoplace_settings.entity.settings` (actual spawning)

### Tungsten Ore Infinite
- Added `'hard-solid'` category check to `tweaks/ores.lua`
- Tungsten now converts to infinite like other ores

### Sulfur Processing Module (tweaks/sulfur-processing/)
- Purifying oil processing recipe: slower basic oil processing, produces sulfur byproduct
- Purifying advanced oil processing recipe: same concept
- Purifying heavy oil cracking recipe: same concept
- Modified sulfuric acid: steel plate catalyst with 80% return chance
- Modified sulfur recipe: coal washing process (petroleum-gas + coal + steam → coal + sulfur)
- Coal liquefaction: 20% chance to produce sulfur

### Technologies Module (tweaks/technologies/)
- Gun turret depends on military tech
- Laser turret, flamethrower, artillery, rocket turret depend on gun turret
- Science pack recipe tweaks:
  - Automation science: +1 stone
  - Logistic science: +1 pipe
  - Chemical science: 10 sulfuric-acid instead of sulfur, crafting-with-fluid category
  - Production science: substation instead of electric-furnace, +140 steam, crafting-with-fluid
  - Utility science: +1000 water, crafting-with-fluid
- Production science prerequisites: +electric-energy-distribution-2, -advanced-material-processing-2

### Early Game Military Changes (tweaks/earlygame/)
- Submachine-gun recipe adjusted
- Vanilla pistol recipe enabled (normally hidden)
- When extras.ores + extras.drills + tweaks.sulfur_processing all enabled:
  - Firearm magazine, piercing rounds, shotgun shell, piercing shotgun shell, grenade require sulfur/coal

### Machines Module (tweaks/machines/)
- Created new module for assembler modifications
- AM3 input fluid box now has east-west through-flow connections
- `production_type = 'input'` with `flow_direction = 'input-output'` on pipe connections
- Allows chaining AM3s without pipes between them for fluid recipes

### Fluid Box Research
- `production_type` defines recipe role (input/output consumption)
- `flow_direction` on pipe connections controls physical flow behavior
- Input fluid boxes can have through-flow with `flow_direction = 'input-output'`
- AM3 pipe graphics exist for all 4 directions (small overlay fragments)

### Water Pump Test Recipe
- Added `extras/altrecipes/water-pump-recipe.lua` for testing fluid input+output rendering
- Confirmed both pipe graphics show when recipe has fluid input and output

### Burner Mining Drill Fluid Fix
- Fixed pipe connection position from {0, -0.5} to {0.5, -0.5}
- Position must be within collision box bounds (-0.699 to 0.699)
- Added explicit `flow_direction = 'input'` to pipe connection

### Electroboiler Icon Fix
- Fixed lightning overlay causing icon shrinkage
- Changed from scale 0.35/shift {10, -10} to scale 0.25/shift {8, -8}
- Now matches rail recipe overlay positioning style