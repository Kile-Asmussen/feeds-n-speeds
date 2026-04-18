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

## Pending / Next Session

### Immediate
- Ensure `extras/ores.lua` coordinator loads the new sulfur ore files via data:extend
- Test wet-drilling technology in-game
- Test sulfur ore spawning and steam mining requirement
- Custom graphics for sulfur ore (currently using uranium-ore placeholder)

### From TODO.md
- Hopper neighbor graph redesign (plan exists at `.claude/plans/tranquil-herding-petal.md`)
- Test hopper in-game (placement linking, chest destruction, re-linking)
