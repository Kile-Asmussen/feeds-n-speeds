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